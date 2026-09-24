module main

import antono2.vulkan as vk

fn (vp &VideoPlayer) ready_output_position(display_order int) ?int {
	for position, output_index in vp.output_textures_ready {
		if vp.output_textures[output_index].display_order == display_order {
			return position
		}
	}
	return none
}

fn (mut vp VideoPlayer) reclaim_output_textures() {
	mut position := 0
	for position < vp.output_textures_retired.len {
		retired := vp.output_textures_retired[position]
		if retired.reusable_after_serial > vp.render_serial {
			position++
			continue
		}
		vp.output_textures[retired.index].display_order = -1
		vp.output_textures[retired.index].duration_ns = 0
		vp.output_textures_free << retired.index
		vp.output_textures_retired.delete(position)
	}
}

fn (mut vp VideoPlayer) retire_current_output() {
	if vp.current_output_index < 0 {
		return
	}
	// The application has one fence per swapchain image. Once this many later
	// render submissions have begun, the last submission sampling this image is
	// guaranteed to have completed on the ordered graphics queue.
	vp.output_textures_retired << RetiredOutputImage{
		index:                 vp.current_output_index
		reusable_after_serial: vp.render_serial + u64(vp.command_buffer_infos.len + 1)
	}
}

fn (mut vp VideoPlayer) present_ready_output(display_order int) bool {
	position := vp.ready_output_position(display_order) or { return false }
	output_index := vp.output_textures_ready[position]
	vp.output_textures_ready.delete(position)
	vp.retire_current_output()
	vp.current_output_index = output_index
	vp.next_display_order = display_order + 1
	vp.waiting_for_loop_start = false
	vp.playback_timeline.present_frame(vp.output_textures[output_index].duration_ns)
	$if debug {
		if display_order % 100 == 0 {
			eprintln('Presented frame ${display_order}')
		}
	}
	return true
}

fn (mut vp VideoPlayer) restart_decode_cycle() {
	$if debug {
		println('Playback loop completed in display order')
	}
	vp.current_frame = 0
	vp.next_display_order = 0
	vp.decode_finished = false
	vp.waiting_for_loop_start = true
	vp.dpb.reference_usage.clear()
	vp.flags |= u32(VideoPlayerFlags.e_decoder_reset)
	vp.playback_timeline.reset()
}

fn (mut vp VideoPlayer) update_presentation() {
	if vp.current_output_index < 0 || vp.waiting_for_loop_start {
		// Prime enough codec-order pictures to absorb the stream's maximum
		// reordering delay. No-B-frame streams have a target of one and still
		// display their first decoded picture immediately.
		if !vp.decode_finished && vp.output_textures_ready.len < vp.presentation_buffer_count {
			return
		}
		vp.present_ready_output(vp.next_display_order)
		return
	}
	if !vp.playback_timeline.frame_is_due() {
		return
	}
	frame_count := vp.decoder.video_data.frame_infos.len
	if vp.next_display_order < frame_count {
		vp.present_ready_output(vp.next_display_order)
		return
	}
	if !vp.decode_finished {
		return
	}
	if vp.is_looping {
		// Keep the last picture visible while the first pictures of the next loop
		// are decoded and reordered.
		vp.restart_decode_cycle()
	} else {
		vp.is_stopped = true
	}
}

fn (vp &VideoPlayer) current_output_view() vk.ImageView {
	if vp.current_output_index < 0 || vp.current_output_index >= vp.output_textures.len {
		return unsafe { nil }
	}
	return vp.output_textures[vp.current_output_index].texture.view
}

fn (mut vp VideoPlayer) update(graphics_cmd_buffer vk.CommandBuffer, time_elapsed_ns i64) {
	vp.decode_operation = DecoderVideoDecodeOperation{}
	vp.render_serial++
	$if debug {
		if vp.render_serial <= 5 {
			eprintln('Playback update ${vp.render_serial}: ready=${vp.output_textures_ready.len}, free=${vp.output_textures_free.len}')
		}
	}
	vp.reclaim_output_textures()
	if vp.current_output_index >= 0 && !vp.waiting_for_loop_start {
		vp.playback_timeline.tick(time_elapsed_ns)
	}

	if vp.is_stopped {
		vp.dpb_slot_used = []int{len: int(vp.decoder.video_data.max_reference_pictures), init: 0}
		return
	}
	should_decode := !vp.decode_finished
		&& vp.output_textures_ready.len < vp.presentation_buffer_count
		&& vp.output_textures_free.len > 0
	if !should_decode {
		vp.update_presentation()
		return
	}

	vp.update_decode_video() or {
		eprintln('Playback stopped: ${err}')
		vp.is_stopped = true
		return
	}
	$if debug {
		if vp.render_serial <= 5 {
			eprintln('Decoded access unit ${vp.current_frame}: ready=${vp.output_textures_ready.len}')
		}
	}
	vp.update_presentation()

	vk.cmd_wait_events(graphics_cmd_buffer, 1, &vp.event_video_player, vk.PipelineStageFlags(vk.PipelineStageFlagBits.all_commands), vk.PipelineStageFlags(vk.PipelineStageFlagBits.all_commands), 0, unsafe { nil }, 0, unsafe { nil }, 0, unsafe { nil })
	vk.cmd_reset_event(graphics_cmd_buffer, vp.event_video_player, vk.PipelineStageFlags(vk.PipelineStageFlagBits.bottom_of_pipe))

	// Finish recording the command buffer and submit
	dev_ctx := vp.app.device_context
	index_cur_swapchain := dev_ctx.swapchain.get_current_index()
	command_buffer_info := vp.command_buffer_infos[index_cur_swapchain]
	vk.end_command_buffer(command_buffer_info.graphics_command_buffer)

	mut semaphore := command_buffer_info.sem_video_to_gfx
	mut wait_stage := vk.PipelineStageFlags(vk.PipelineStageFlagBits.top_of_pipe)
	mut sumbit_info_video := vk.SubmitInfo{
		waitSemaphoreCount:   0
		pWaitSemaphores:      unsafe { nil }
		pWaitDstStageMask:    &wait_stage
		commandBufferCount:   1
		pCommandBuffers:      &command_buffer_info.video_command_buffer
		signalSemaphoreCount: 1
		pSignalSemaphores:    &semaphore
	}
	upload_fence := vp.video_frames[vp.current_upload_index].in_flight_fence
	res_video := vk.queue_submit(dev_ctx.get_queue(.video_decode), 1, &sumbit_info_video, upload_fence)
	check_vk(res_video, 'Could not submit Vulkan Video decode command')

	mut sumbit_info_graphics := vk.SubmitInfo{
		waitSemaphoreCount: 1
		pWaitSemaphores:    &semaphore
		pWaitDstStageMask:  &wait_stage
		commandBufferCount: 1
		pCommandBuffers:    &command_buffer_info.graphics_command_buffer
	}
	res_graphics := vk.queue_submit(dev_ctx.get_queue(.graphics), 1, &sumbit_info_graphics, unsafe { nil })
	check_vk(res_graphics, 'Could not submit decoded frame for graphics use')
}
