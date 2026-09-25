module main

import antono2.vulkan as vk
import os
import antono2.h264

fn (mut vp VideoPlayer) update_decode_video() ! {
	dev_ctx := vp.app.device_context
	if vp.output_textures_free.len == 0 {
		return error('presentation queue has no reusable output image')
	}
	output_index := vp.output_textures_free[0]
	vp.output_textures_free.delete(0)
	mut output_queued := false
	defer {
		if !output_queued {
			vp.output_textures_free << output_index
		}
	}
	command_buffer_info := vp.command_buffer_infos[dev_ctx.swapchain.get_current_index()]
	mut begin_command_buffer := vk.CommandBufferBeginInfo{}
	vk.reset_command_buffer(command_buffer_info.graphics_command_buffer, 0)
	vk.begin_command_buffer(command_buffer_info.graphics_command_buffer, &begin_command_buffer)
	if vp.is_stopped {
		vk.cmd_set_event(command_buffer_info.graphics_command_buffer, vp.event_video_player,
			vk.PipelineStageFlags(vk.PipelineStageFlagBits.all_commands))
		return
	}

	video_command_buffer := command_buffer_info.video_command_buffer
	vk.reset_command_buffer(video_command_buffer, 0)
	vk.begin_command_buffer(video_command_buffer, &begin_command_buffer)

	mut frame_info := vp.decoder.video_data.frame_infos[vp.current_frame]
	mut slice_header := &h264.SliceHeader(unsafe { nil })
	mut pps := &h264.PictureParameterSet(unsafe { nil })
	mut sps := &h264.SequenceParameterSet(unsafe { nil })
	lock vp.decoder {
		assert !isnil(vp.decoder.get_slice_header())
		assert !isnil(vp.decoder.get_pps())
		assert !isnil(vp.decoder.get_sps())

		slice_header = unsafe {
			&h264.SliceHeader(byteptr(usize(vp.decoder.get_slice_header()) +
				usize(vp.current_frame) * sizeof(h264.SliceHeader)))
		}
		pps = unsafe {
			&h264.PictureParameterSet(byteptr(usize(vp.decoder.get_pps()) +
				usize(vp.decoder.video_data.pps_storage_offset(slice_header.pic_parameter_set_id)!)))
		}
		sps = unsafe {
			&h264.SequenceParameterSet(byteptr(usize(vp.decoder.get_sps()) +
				usize(vp.decoder.video_data.sps_storage_offset(pps.seq_parameter_set_id)!)))
		}
	}

	mut decode_ope := DecoderVideoDecodeOperation{}
	if vp.current_frame == 0
		|| has_flag[VideoPlayerFlags](vp.flags, VideoPlayerFlags.e_decoder_reset) {
		decode_ope.flags = u32(DecoderVideoDecodeOperationFlags.e_session_reset)
		vp.flags &= ~u32(VideoPlayerFlags.e_decoder_reset)
	}

	// An ordinary I-picture can occur in an open GOP and may still depend on the
	// existing DPB for pictures decoded after it. Only IDR starts a new reference
	// picture sequence here.
	if frame_info.nal_unit_type == u8(h264.NAL_UNIT_TYPE.coded_slice_idr) {
		vp.dpb.reference_usage.clear()
		vp.dpb.max_long_term_index = -1
	}

	dpb_slot_num := int(vp.decoder.video_data.num_dpb_slots)
	vp.dpb.current_slot = vp.dpb.acquire_decode_slot(dpb_slot_num)
	vp.dpb.long_term[vp.dpb.current_slot] = false
	vp.dpb.poc_status[vp.dpb.current_slot] = frame_info.top_field_order_cnt
	vp.dpb.bottom_poc_status[vp.dpb.current_slot] = frame_info.bottom_field_order_cnt
	vp.dpb.frame_num_status[vp.dpb.current_slot] = int(slice_header.frame_num)

	// Index variable on initialization comes in handy
	dpbs := []vk.Image{len: dpb_slot_num, init: vp.dpb.image[index].image}
	dpb_views := []vk.ImageView{len: dpb_slot_num, init: vp.dpb.image[index].view}

	// Only the prefix initialized from decoder.info.memory_frames owns mapped
	// bitstream-buffer slices. Using the fixed array length eventually selects an
	// uninitialized zero-capacity entry on streams longer than the DPB count.
	use_frame_index := vp.current_frame % vp.decoder.info.memory_frames.len
	vp.current_upload_index = use_frame_index
	upload_fence := vp.video_frames[use_frame_index].in_flight_fence
	res_wait := vk.wait_for_fences(dev_ctx.vk_device, 1, &upload_fence, vk._true, max_u64)
	check_vk(res_wait, 'Could not wait for decoded-frame fence')
	vp.write_frame_readback(use_frame_index)!
	res_reset := vk.reset_fences(dev_ctx.vk_device, 1, &upload_fence)
	check_vk(res_reset, 'Could not reset decoded-frame fence')
	vp.video_frames[use_frame_index].gpu_bitstream_size = 0
	vp.video_frames[use_frame_index].slice_offsets.clear()
	mut use_frame := &vp.video_frames[use_frame_index]
	vp.write_video_frame(mut use_frame)!
	mut flush_result := vk.Result.error_unknown
	lock vp.decoder {
		flush_result = vp.app.device_context.memory_allocator.flush_range(vp.decoder.gpu_bitstream_allocation,
			use_frame.gpu_bitstream_offset, use_frame.gpu_bitstream_size)
	}
	check_vk(flush_result, 'Could not flush the Vulkan Video bitstream buffer')

	decode_ope.stream_offset = use_frame.gpu_bitstream_offset
	decode_ope.stream_size = use_frame.gpu_bitstream_size
	decode_ope.poc[0] = frame_info.top_field_order_cnt
	decode_ope.poc[1] = frame_info.bottom_field_order_cnt
	decode_ope.frame_type = frame_info.frame_type
	decode_ope.reference_priority = frame_info.reference_priority
	decode_ope.current_mmco5 = frame_info.has_mmco5
	decode_ope.decoded_frame_index = vp.current_frame
	decode_ope.slice_header = slice_header
	decode_ope.pps = pps
	decode_ope.sps = sps
	decode_ope.current_dpb = vp.dpb.current_slot
	decode_ope.dpb_reference_count = u32(vp.dpb.reference_usage.len)
	decode_ope.dpb_reference_slots = vp.dpb.reference_usage.data
	// Pointer to data of fixed size array
	decode_ope.dpb_poc = &vp.dpb.poc_status[0]
	decode_ope.dpb_bottom_poc = &vp.dpb.bottom_poc_status[0]
	decode_ope.dpb_frame_num = &vp.dpb.frame_num_status[0]
	decode_ope.dpb_long_term = &vp.dpb.long_term[0]
	decode_ope.dpb_long_term_index = &vp.dpb.long_term_index[0]
	if frame_info.nal_unit_type == u8(h264.NAL_UNIT_TYPE.coded_slice_idr) {
		decode_ope.current_long_term = slice_header.drpm.long_term_reference_flag != 0
		decode_ope.current_long_index = 0
	} else if frame_info.reference_priority > 0
		&& slice_header.drpm.adaptive_ref_pic_marking_mode_flag != 0 {
		for i in 0 .. slice_header.drpm.memory_management_control_operation.len {
			op := slice_header.drpm.memory_management_control_operation[i]
			if op == 0 { break
			 }
			if op == 6 {
				decode_ope.current_long_term = true
				decode_ope.current_long_index = int(slice_header.drpm.long_term_frame_idx[i])
			}
		}
	}

	decode_ope.dpb_slot_num = u32(dpb_slot_num)
	decode_ope.p_dpbs = dpbs.data
	decode_ope.p_dpb_views = dpb_views.data
	decode_ope.slice_count = u32(use_frame.slice_offsets.len)
	decode_ope.slice_offsets = use_frame.slice_offsets.data

	// Copy for display
	vp.decode_operation = decode_ope

	vp.video_decode_pre_barrier(video_command_buffer)
	vp.video_decode_core(&decode_ope, video_command_buffer)
	vp.copy_decoded_frame_to_output(video_command_buffer, output_index)
	vp.output_textures[output_index].display_order = frame_info.display_order
	vp.output_textures[output_index].duration_ns = frame_info.duration_ns
	vp.output_textures_ready << output_index
	output_queued = true

	// Reference marking takes effect after decoding; this picture used the
	// previous DPB when the Vulkan command was recorded.
	vp.dpb.mark_after_decode(slice_header,
		frame_info.nal_unit_type == u8(h264.NAL_UNIT_TYPE.coded_slice_idr),
		frame_info.reference_priority > 0, int(vp.decoder.video_data.max_reference_pictures), int(u32(1) << (
		sps.log2_max_frame_num_minus4 + 4)))!
	vk.end_command_buffer(video_command_buffer)
	mut frame_count := 0
	rlock vp.decoder {
		frame_count = vp.decoder.video_data.frame_infos.len
	}
	if vp.current_frame + 1 < frame_count {
		vp.current_frame++
	} else {
		// B-frame output may still be waiting in presentation order. Do not reset
		// the codec or overwrite those images until the last picture was shown.
		vp.decode_finished = true
	}

	// The graphics command buffer waits on the decode semaphore before this
	// transition, making the copied output safe for fragment sampling.
	mut output_barrier := vk.ImageMemoryBarrier2{
		srcStageMask:     vk.pipeline_stage_2_transfer_bit
		srcAccessMask:    vk.access_2_transfer_write_bit
		dstStageMask:     vk.pipeline_stage_2_fragment_shader_bit
		dstAccessMask:    vk.access_2_shader_read_bit
		oldLayout:        .transfer_dst_optimal
		newLayout:        .shader_read_only_optimal
		image:            vp.output_textures[output_index].texture.image
		subresourceRange: vk.ImageSubresourceRange{
			aspectMask: vk.ImageAspectFlags(vk.ImageAspectFlagBits.color)
			levelCount: 1
			layerCount: 1
		}
	}
	output_dependency := vk.DependencyInfo{
		imageMemoryBarrierCount: 1
		pImageMemoryBarriers:    &output_barrier
	}
	vk.cmd_pipeline_barrier2(command_buffer_info.graphics_command_buffer, &output_dependency)
	vp.output_textures[output_index].layout = .shader_read_only_optimal

	// Signal the application command buffer after the decode queue completes.
	vk.cmd_set_event(command_buffer_info.graphics_command_buffer, vp.event_video_player,
		vk.PipelineStageFlags(vk.PipelineStageFlagBits.all_commands))
}

fn (mut vp VideoPlayer) copy_decoded_frame_to_output(command_buffer vk.CommandBuffer, output_index int) {
	decode_family := vp.app.device_context.get_decoder_queue_family_index()
	mut output := &vp.output_textures[output_index]
	coincide := vp.decoder.properties.dpb_and_output_coincide
	mut source_image := vp.dpb.image[vp.dpb.current_slot].image
	mut source_state := &vp.dpb.resource_state[vp.dpb.current_slot]
	mut source_restore_layout := vk.ImageLayout.video_decode_dpb_khr
	if !coincide {
		source_image = vp.decode_output_image.image
		source_state = &vp.decode_output_state
		source_restore_layout = .video_decode_dst_khr
	}
	mut barriers := [
		vk.ImageMemoryBarrier2{
			srcStageMask:        vk.pipeline_stage_2_video_decode_bit_khr
			srcAccessMask:       source_state.flag
			dstStageMask:        vk.pipeline_stage_2_transfer_bit
			dstAccessMask:       vk.access_2_transfer_read_bit
			oldLayout:           source_state.layout
			newLayout:           .transfer_src_optimal
			srcQueueFamilyIndex: decode_family
			dstQueueFamilyIndex: decode_family
			image:               source_image
			subresourceRange:    vk.ImageSubresourceRange{
				aspectMask: vk.ImageAspectFlags(vk.ImageAspectFlagBits.color)
				levelCount: 1
				layerCount: 1
			}
		},
		vk.ImageMemoryBarrier2{
			srcStageMask:        vk.pipeline_stage_2_transfer_bit
			dstStageMask:        vk.pipeline_stage_2_transfer_bit
			dstAccessMask:       vk.access_2_transfer_write_bit
			oldLayout:           if output.is_new {
				vk.ImageLayout.undefined
			} else {
				output.layout
			}
			newLayout:           .transfer_dst_optimal
			srcQueueFamilyIndex: decode_family
			dstQueueFamilyIndex: decode_family
			image:               output.texture.image
			subresourceRange:    vk.ImageSubresourceRange{
				aspectMask: vk.ImageAspectFlags(vk.ImageAspectFlagBits.color)
				levelCount: 1
				layerCount: 1
			}
		},
	]
	dependency := vk.DependencyInfo{
		imageMemoryBarrierCount: u32(barriers.len)
		pImageMemoryBarriers:    barriers.data
	}
	vk.cmd_pipeline_barrier2(command_buffer, &dependency)
	source_state.layout = .transfer_src_optimal
	source_state.flag = vk.access_2_transfer_read_bit

	mut regions := [
		vk.ImageCopy2{
			srcSubresource: vk.ImageSubresourceLayers{
				aspectMask: vk.ImageAspectFlags(vk.ImageAspectFlagBits.plane0)
				layerCount: 1
			}
			dstSubresource: vk.ImageSubresourceLayers{
				aspectMask: vk.ImageAspectFlags(vk.ImageAspectFlagBits.plane0)
				layerCount: 1
			}
			extent:         vk.Extent3D{
				width:  vp.decoder.video_data.width
				height: vp.decoder.video_data.height
				depth:  1
			}
		},
		vk.ImageCopy2{
			srcSubresource: vk.ImageSubresourceLayers{
				aspectMask: vk.ImageAspectFlags(vk.ImageAspectFlagBits.plane1)
				layerCount: 1
			}
			dstSubresource: vk.ImageSubresourceLayers{
				aspectMask: vk.ImageAspectFlags(vk.ImageAspectFlagBits.plane1)
				layerCount: 1
			}
			extent:         vk.Extent3D{
				width:  vp.decoder.video_data.width / 2
				height: vp.decoder.video_data.height / 2
				depth:  1
			}
		},
	]
	copy_info := vk.CopyImageInfo2{
		srcImage:       source_image
		srcImageLayout: .transfer_src_optimal
		dstImage:       output.texture.image
		dstImageLayout: .transfer_dst_optimal
		regionCount:    u32(regions.len)
		pRegions:       regions.data
	}
	vk.cmd_copy_image2(command_buffer, &copy_info)
	vp.record_frame_readback(command_buffer, source_image)
	output.layout = .transfer_dst_optimal
	output.is_new = false

	post_barrier := vk.ImageMemoryBarrier2{
		srcStageMask:        vk.pipeline_stage_2_transfer_bit
		srcAccessMask:       vk.access_2_transfer_read_bit
		dstStageMask:        vk.pipeline_stage_2_video_decode_bit_khr
		dstAccessMask:       vk.access_2_video_decode_read_bit_khr
		oldLayout:           .transfer_src_optimal
		newLayout:           source_restore_layout
		srcQueueFamilyIndex: decode_family
		dstQueueFamilyIndex: decode_family
		image:               source_image
		subresourceRange:    vk.ImageSubresourceRange{
			aspectMask: vk.ImageAspectFlags(vk.ImageAspectFlagBits.color)
			levelCount: 1
			layerCount: 1
		}
	}
	mut post_barriers := [post_barrier]
	if !coincide {
		post_barriers << vk.ImageMemoryBarrier2{
			srcStageMask:        vk.pipeline_stage_2_video_decode_bit_khr
			srcAccessMask:       vk.access_2_video_decode_write_bit_khr
			dstStageMask:        vk.pipeline_stage_2_video_decode_bit_khr
			dstAccessMask:       vk.access_2_video_decode_read_bit_khr
			oldLayout:           .video_decode_dpb_khr
			newLayout:           .video_decode_dpb_khr
			srcQueueFamilyIndex: decode_family
			dstQueueFamilyIndex: decode_family
			image:               vp.dpb.image[vp.dpb.current_slot].image
			subresourceRange:    vk.ImageSubresourceRange{
				aspectMask: vk.ImageAspectFlags(vk.ImageAspectFlagBits.color)
				levelCount: 1
				layerCount: 1
			}
		}
	}
	post_dependency := vk.DependencyInfo{
		imageMemoryBarrierCount: u32(post_barriers.len)
		pImageMemoryBarriers:    post_barriers.data
	}
	vk.cmd_pipeline_barrier2(command_buffer, &post_dependency)
	source_state.layout = source_restore_layout
	source_state.flag = if coincide {
		vk.access_2_video_decode_read_bit_khr
	} else {
		vk.access_2_video_decode_write_bit_khr
	}
	if !coincide {
		vp.dpb.resource_state[vp.dpb.current_slot].layout = .video_decode_dpb_khr
		vp.dpb.resource_state[vp.dpb.current_slot].flag = vk.access_2_video_decode_read_bit_khr
	}
}

fn (mut vp VideoPlayer) video_decode_pre_barrier(video_command_buffer vk.CommandBuffer) {
	mut image_barriers := []vk.ImageMemoryBarrier2{}
	decode_family := vp.app.device_context.get_decoder_queue_family_index()
	mut current_state := &vp.dpb.resource_state[vp.dpb.current_slot]
	if current_state.layout != .video_decode_dpb_khr
		|| current_state.flag != vk.access_2_video_decode_write_bit_khr {
		barrier := vk.ImageMemoryBarrier2{
			srcStageMask:        vk.pipeline_stage_2_video_decode_bit_khr
			srcAccessMask:       current_state.flag
			dstStageMask:        vk.pipeline_stage_2_video_decode_bit_khr
			dstAccessMask:       vk.access_2_video_decode_write_bit_khr
			oldLayout:           current_state.layout
			newLayout:           .video_decode_dpb_khr
			srcQueueFamilyIndex: decode_family
			dstQueueFamilyIndex: decode_family
			image:               vp.dpb.image[vp.dpb.current_slot].image
			subresourceRange:    vk.ImageSubresourceRange{
				aspectMask:     vk.ImageAspectFlags(vk.ImageAspectFlagBits.color)
				baseMipLevel:   0
				levelCount:     1
				baseArrayLayer: 0
				layerCount:     1
			}
		}
		image_barriers << barrier
		current_state.layout = barrier.newLayout
		current_state.flag = barrier.dstAccessMask
	}
	if !vp.decoder.properties.dpb_and_output_coincide
		&& (vp.decode_output_state.layout != .video_decode_dst_khr
		|| vp.decode_output_state.flag != vk.access_2_video_decode_write_bit_khr) {
		output_barrier := vk.ImageMemoryBarrier2{
			srcStageMask:        vk.pipeline_stage_2_all_commands_bit
			srcAccessMask:       vp.decode_output_state.flag
			dstStageMask:        vk.pipeline_stage_2_video_decode_bit_khr
			dstAccessMask:       vk.access_2_video_decode_write_bit_khr
			oldLayout:           vp.decode_output_state.layout
			newLayout:           .video_decode_dst_khr
			srcQueueFamilyIndex: decode_family
			dstQueueFamilyIndex: decode_family
			image:               vp.decode_output_image.image
			subresourceRange:    vk.ImageSubresourceRange{
				aspectMask: vk.ImageAspectFlags(vk.ImageAspectFlagBits.color)
				levelCount: 1
				layerCount: 1
			}
		}
		image_barriers << output_barrier
		vp.decode_output_state.layout = output_barrier.newLayout
		vp.decode_output_state.flag = output_barrier.dstAccessMask
	}
	for ref_index in vp.dpb.reference_usage {
		mut ref_state := &vp.dpb.resource_state[ref_index]
		if ref_state.layout != .video_decode_dpb_khr
			|| ref_state.flag != vk.access_2_video_decode_read_bit_khr {
			barrier := vk.ImageMemoryBarrier2{
				srcStageMask:        vk.pipeline_stage_2_video_decode_bit_khr
				srcAccessMask:       ref_state.flag
				dstStageMask:        vk.pipeline_stage_2_video_decode_bit_khr
				dstAccessMask:       vk.access_2_video_decode_read_bit_khr
				oldLayout:           ref_state.layout
				newLayout:           .video_decode_dpb_khr
				srcQueueFamilyIndex: decode_family
				dstQueueFamilyIndex: decode_family
				image:               vp.dpb.image[ref_index].image
				subresourceRange:    vk.ImageSubresourceRange{
					aspectMask:     vk.ImageAspectFlags(vk.ImageAspectFlagBits.color)
					baseMipLevel:   0
					levelCount:     1
					baseArrayLayer: 0
					layerCount:     1
				}
			}
			image_barriers << barrier
			ref_state.layout = barrier.newLayout
			ref_state.flag = barrier.dstAccessMask
		}
	}
	if image_barriers.len > 0 {
		dependency := vk.DependencyInfo{
			imageMemoryBarrierCount: u32(image_barriers.len)
			pImageMemoryBarriers:    image_barriers.data
		}
		vk.cmd_pipeline_barrier2(video_command_buffer, &dependency)
	}
}

fn (mut vp VideoPlayer) video_decode_core(operation &DecoderVideoDecodeOperation, command_buffer vk.CommandBuffer) {
	slice_header := unsafe { &h264.SliceHeader(operation.slice_header) }
	pps := unsafe { &h264.PictureParameterSet(operation.pps) }
	frame := vp.decoder.video_data.frame_infos[operation.decoded_frame_index]
	mut std_picture := vk.StdVideoDecodeH264PictureInfo{
		pic_parameter_set_id: u8(slice_header.pic_parameter_set_id)
		seq_parameter_set_id: u8(pps.seq_parameter_set_id)
		frame_num:            u16(slice_header.frame_num)
		idr_pic_id:           u16(slice_header.idr_pic_id)
	}
	C.vv_set_h264_picture_order_count(&std_picture, operation.poc[0], operation.poc[1])
	std_picture.flags.is_intra = u32(operation.frame_type == .e_intra)
	std_picture.flags.is_reference = u32(operation.reference_priority > 0)
	C.vv_set_h264_idr_picture_flag(&std_picture, u32(frame.nal_unit_type == 5))
	std_picture.flags.field_pic_flag = slice_header.field_pic_flag
	std_picture.flags.bottom_field_flag = slice_header.bottom_field_flag

	mut slot_infos := [slot_count]vk.VideoReferenceSlotInfoKHR{}
	mut pictures := [slot_count]vk.VideoPictureResourceInfoKHR{}
	mut h264_slots := [slot_count]vk.VideoDecodeH264DpbSlotInfoKHR{}
	mut reference_infos := [slot_count]vk.StdVideoDecodeH264ReferenceInfo{}
	for i in 0 .. int(operation.dpb_slot_num) {
		pictures[i] = vk.VideoPictureResourceInfoKHR{
			codedExtent:      vk.Extent2D{
				width:  vp.decoder.video_data.width_padd
				height: vp.decoder.video_data.height_padd
			}
			baseArrayLayer:   0
			imageViewBinding: vp.dpb.image[i].view
		}
		C.vv_set_h264_reference_info(&reference_infos[i], u16(if unsafe { operation.dpb_long_term[i] } {
			unsafe { operation.dpb_long_term_index[i] }
		} else {
			unsafe { operation.dpb_frame_num[i] }
		}), unsafe { operation.dpb_poc[i] }, unsafe { operation.dpb_bottom_poc[i] })
		reference_infos[i].flags.used_for_long_term_reference = u32(unsafe { operation.dpb_long_term[i] })
		h264_slots[i] = vk.VideoDecodeH264DpbSlotInfoKHR{
			pStdReferenceInfo: unsafe { &reference_infos[i] }
		}
		slot_infos[i] = vk.VideoReferenceSlotInfoKHR{
			pNext:            unsafe { &h264_slots[i] }
			slotIndex:        i
			pPictureResource: unsafe { &pictures[i] }
		}
	}
	if operation.current_mmco5 {
		minimum := if operation.poc[0] < operation.poc[1] {
			operation.poc[0]
		} else {
			operation.poc[1]
		}
		C.vv_set_h264_reference_info(&reference_infos[operation.current_dpb], 0,
			operation.poc[0] - minimum, operation.poc[1] - minimum)
	} else if operation.current_long_term {
		C.vv_set_h264_reference_info(&reference_infos[operation.current_dpb],
			u16(operation.current_long_index), operation.poc[0], operation.poc[1])
		reference_infos[operation.current_dpb].flags.used_for_long_term_reference = 1
	}

	mut active_slots := [slot_count]vk.VideoReferenceSlotInfoKHR{}
	for i in 0 .. int(operation.dpb_reference_count) {
		ref_slot := unsafe { operation.dpb_reference_slots[i] }
		active_slots[i] = slot_infos[ref_slot]
	}
	active_slots[operation.dpb_reference_count] = slot_infos[operation.current_dpb]
	active_slots[operation.dpb_reference_count].slotIndex = -1
	begin_info := vk.VideoBeginCodingInfoKHR{
		videoSession:           vp.decoder.video_session
		videoSessionParameters: vp.decoder.video_session_parameters
		referenceSlotCount:     operation.dpb_reference_count + 1
		pReferenceSlots:        unsafe { &active_slots[0] }
	}
	vk.cmd_begin_video_coding_khr(command_buffer, &begin_info)
	if (operation.flags & u32(DecoderVideoDecodeOperationFlags.e_session_reset)) != 0 {
		control_info := vk.VideoCodingControlInfoKHR{
			flags: vk.VideoCodingControlFlagsKHR(vk.VideoCodingControlFlagBitsKHR.reset)
		}
		vk.cmd_control_video_coding_khr(command_buffer, &control_info)
	}

	mut h264_picture := vk.VideoDecodeH264PictureInfoKHR{
		pStdPictureInfo: &std_picture
		sliceCount:      operation.slice_count
		pSliceOffsets:   operation.slice_offsets
	}
	dst_picture := if vp.decoder.properties.dpb_and_output_coincide {
		pictures[operation.current_dpb]
	} else {
		vk.VideoPictureResourceInfoKHR{
			codedExtent:      vk.Extent2D{
				width:  vp.decoder.video_data.width_padd
				height: vp.decoder.video_data.height_padd
			}
			baseArrayLayer:   0
			imageViewBinding: vp.decode_output_image.view
		}
	}
	mut decode_info := vk.VideoDecodeInfoKHR{
		pNext:               &h264_picture
		srcBuffer:           vp.decoder.gpu_bitstream_buffer
		srcBufferOffset:     operation.stream_offset
		srcBufferRange:      operation.stream_size
		dstPictureResource:  dst_picture
		pSetupReferenceSlot: unsafe { &slot_infos[operation.current_dpb] }
		referenceSlotCount:  operation.dpb_reference_count
		pReferenceSlots:     if operation.dpb_reference_count == 0 {
			unsafe { nil }
		} else {
			unsafe { &active_slots[0] }
		}
	}
	vk.cmd_decode_video_khr(command_buffer, &decode_info)
	end_info := vk.VideoEndCodingInfoKHR{}
	vk.cmd_end_video_coding_khr(command_buffer, &end_info)
}

fn (mut vp VideoPlayer) write_video_frame(mut frame VideoPlayerDecodeStreamFrame) ! {
	data_frame := vp.decoder.video_data.frame_infos[vp.current_frame]
	mut frame_bytes_num_to_do := data_frame.frame_bytes_num
	length_size := int(vp.decoder.video_data.nal_length_size)
	lock vp.decoder {
		vp.decoder.video_data.file.seek(data_frame.src_offset, .start) or {
			return error('could not seek to MP4 frame ${vp.current_frame}: ${err}')
		}
	}
	for frame_bytes_num_to_do > 0 {
		if frame_bytes_num_to_do < u64(length_size) {
			return error('MP4 frame ${vp.current_frame} has a truncated H.264 NAL length')
		}
		mut src_buffer := []u8{len: length_size}
		mut length_bytes_read := 0
		lock vp.decoder {
			length_bytes_read = vp.decoder.video_data.file.read(mut src_buffer) or {
				return error('could not read H.264 NAL length in MP4 frame ${vp.current_frame}: ${err}')
			}
		}
		if length_bytes_read != src_buffer.len {
			return error('short read of H.264 NAL length in MP4 frame ${vp.current_frame}: expected ${length_size} bytes, read ${length_bytes_read}')
		}
		nal_size := read_nal_length(src_buffer, 0, length_size)!
		if u64(nal_size) > frame_bytes_num_to_do - u64(length_size) {
			return error('MP4 frame ${vp.current_frame} has an invalid H.264 NAL size ${nal_size}')
		}
		size := u64(nal_size) + u64(length_size)
		mut file := File(os.File{})
		mut nal_header_byte := u8(0)
		lock vp.decoder {
			file = vp.decoder.video_data.file
			nal_header_byte = file.peek()!
		}
		mut bs := h264.Bitstream{}
		bs.init([nal_header_byte])
		mut nal := h264.NetworkAbstractionLayerHeader{}
		nal.read_nal_header(mut bs)
		// Skip over any frame data that is not idr slice or non-idr slice
		if nal.type != h264.NAL_UNIT_TYPE.coded_slice_idr
			&& nal.type != h264.NAL_UNIT_TYPE.coded_slice_non_idr {
			frame_bytes_num_to_do -= size
			lock vp.decoder {
				vp.decoder.video_data.file.seek(nal_size, .current) or {
					return error('could not skip non-slice NAL in MP4 frame ${vp.current_frame}: ${err}')
				}
			}
			continue
		}

		nal_start_code := h264.NalStartCode{}.value
		if frame.gpu_bitstream_size + u64(nal_start_code.len) + u64(nal_size) <= frame.gpu_bitstream_capacity {
			frame.slice_offsets << u32(frame.gpu_bitstream_size)
			dst_buffer := unsafe {
				frame.gpu_bitstream_slice_mapped_memory_address + frame.gpu_bitstream_size
			}
			lock vp.decoder {
				unsafe { vmemcpy(dst_buffer, nal_start_code.data, nal_start_code.len) }
				bytes_read := vp.decoder.video_data.file.read_into_ptr(unsafe {
					dst_buffer + nal_start_code.len
				}, int(nal_size)) or {
					return error('could not read H.264 NAL payload in MP4 frame ${vp.current_frame}: ${err}')
				}
				if bytes_read != int(nal_size) {
					return error('short read of H.264 NAL payload in MP4 frame ${vp.current_frame}: expected ${nal_size} bytes, read ${bytes_read}')
				}
			}
			frame.gpu_bitstream_size += u64(nal_start_code.len) + u64(nal_size)
		} else {
			return error('encoded access unit ${vp.current_frame} requires more than its ${frame.gpu_bitstream_capacity}-byte aligned bitstream-buffer capacity (written=${frame.gpu_bitstream_size}, next_nal=${size})')
		}
		frame_bytes_num_to_do -= size
	}
	if frame.gpu_bitstream_size == 0 {
		return error('MP4 frame ${vp.current_frame} no longer contains a decodable H.264 slice')
	}
	lock vp.decoder {
		aligned_size :=
			U64(frame.gpu_bitstream_size).align_to(vp.decoder.properties.caps.minBitstreamBufferSizeAlignment)
		if aligned_size > frame.gpu_bitstream_capacity {
			return error('aligned access unit ${vp.current_frame} exceeds its ${frame.gpu_bitstream_capacity}-byte bitstream-buffer capacity')
		}
		if aligned_size > frame.gpu_bitstream_size {
			unsafe {
				vmemset(frame.gpu_bitstream_slice_mapped_memory_address + frame.gpu_bitstream_size,
					0, isize(aligned_size - frame.gpu_bitstream_size))
			}
		}
		frame.gpu_bitstream_size = aligned_size
	}
}

type File = os.File

// Return next byte in file, but don't move the cursor position
fn (mut f File) peek() !u8 {
	pos_bk := f.tell()!
	mut ret := []u8{len: 1}
	bytes_read := f.read(mut ret)!
	f.seek(pos_bk, .start)!
	if bytes_read != 1 {
		return error('unexpected end of file while reading H.264 NAL header')
	}
	return ret[0]
}

fn has_flag[T](lhs u32, rhs T) bool {
	return (lhs & u32(rhs)) == u32(rhs)
}

fn (d Decoder) get_slice_header() byteptr {
	return d.video_data.slice_header_bytes.data
}

fn (d Decoder) get_pps() byteptr {
	return d.video_data.pps_bytes.data
}

fn (d Decoder) get_sps() byteptr {
	return d.video_data.sps_bytes.data
}
