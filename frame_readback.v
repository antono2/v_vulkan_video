module main

import os
import antono2.vulkan as vk
import antono2.vkmemalloc as vkmem

// Opt-in validation path: one host-visible NV12 buffer per in-flight decode.
struct FrameReadback {
mut:
	buffer        vk.Buffer
	allocation    vkmem.AllocationInfo
	mapped        byteptr = unsafe { nil }
	decode_index  int
	display_order int
	pending       bool
}

fn (mut vp VideoPlayer) initialize_frame_readback() {
	vp.frame_readback_dir = os.getenv('VV_DUMP_NV12_DIR')
	if vp.frame_readback_dir == '' {
		return
	}
	os.mkdir_all(vp.frame_readback_dir) or { panic('Could not create readback directory: ${err}') }
	width := vp.decoder.video_data.width
	height := vp.decoder.video_data.height
	if width % 2 != 0 || height % 2 != 0 {
		panic('NV12 readback requires even picture dimensions')
	}
	buffer_size := u64(width) * u64(height) * 3 / 2
	vp.frame_readbacks = []FrameReadback{len: vp.video_frames.len}
	for mut frame in vp.frame_readbacks {
		buffer_ci := vk.BufferCreateInfo{
			size:  buffer_size
			usage: vk.BufferUsageFlags(vk.BufferUsageFlagBits.transfer_dst)
		}
		result := vp.app.device_context.memory_allocator.create_buffer_with_options(&buffer_ci, vkmem.AllocationOptions{
			usage: .readback
		}, &frame.buffer, mut frame.allocation)
		check_vk(result, 'Could not allocate decoded-frame readback buffer')
		mut mapped := voidptr(unsafe { nil })
		check_vk(vp.app.device_context.memory_allocator.map(mut frame.allocation, &mapped),
			'Could not map decoded-frame readback buffer')
		frame.mapped = byteptr(mapped)
	}
	eprintln('Decoded NV12 readback enabled: ${vp.frame_readback_dir}')
}

fn (mut vp VideoPlayer) record_frame_readback(command_buffer vk.CommandBuffer, source_image vk.Image) {
	if vp.frame_readback_dir == '' || vp.frame_readback_done {
		return
	}
	mut frame := &vp.frame_readbacks[vp.current_upload_index]
	width := vp.decoder.video_data.width
	height := vp.decoder.video_data.height
	regions := [
		vk.BufferImageCopy2{
			bufferOffset:     0
			imageSubresource: vk.ImageSubresourceLayers{
				aspectMask: vk.ImageAspectFlags(vk.ImageAspectFlagBits.plane0)
				layerCount: 1
			}
			imageExtent:      vk.Extent3D{
				width:  width
				height: height
				depth:  1
			}
		},
		vk.BufferImageCopy2{
			bufferOffset:     u64(width) * u64(height)
			imageSubresource: vk.ImageSubresourceLayers{
				aspectMask: vk.ImageAspectFlags(vk.ImageAspectFlagBits.plane1)
				layerCount: 1
			}
			imageExtent:      vk.Extent3D{
				width:  width / 2
				height: height / 2
				depth:  1
			}
		},
	]
	copy_info := vk.CopyImageToBufferInfo2{
		srcImage:       source_image
		srcImageLayout: .transfer_src_optimal
		dstBuffer:      frame.buffer
		regionCount:    u32(regions.len)
		pRegions:       regions.data
	}
	vk.cmd_copy_image_to_buffer2(command_buffer, &copy_info)
	family := vp.app.device_context.get_decoder_queue_family_index()
	barrier := vk.BufferMemoryBarrier2{
		srcStageMask:        vk.pipeline_stage_2_transfer_bit
		srcAccessMask:       vk.access_2_transfer_write_bit
		dstStageMask:        vk.pipeline_stage_2_host_bit
		dstAccessMask:       vk.access_2_host_read_bit
		srcQueueFamilyIndex: family
		dstQueueFamilyIndex: family
		buffer:              frame.buffer
		offset:              0
		size:                vk.whole_size
	}
	dependency := vk.DependencyInfo{
		bufferMemoryBarrierCount: 1
		pBufferMemoryBarriers:    &barrier
	}
	vk.cmd_pipeline_barrier2(command_buffer, &dependency)
	frame.decode_index = vp.current_frame
	frame.display_order = vp.decoder.video_data.frame_infos[vp.current_frame].display_order
	frame.pending = true
}

fn (mut vp VideoPlayer) write_frame_readback(slot int) ! {
	if vp.frame_readback_dir == '' || !vp.frame_readbacks[slot].pending {
		return
	}
	mut frame := &vp.frame_readbacks[slot]
	size := u64(vp.decoder.video_data.width) * u64(vp.decoder.video_data.height) * 3 / 2
	check_vk(vp.app.device_context.memory_allocator.invalidate_range(frame.allocation, 0, size),
		'Could not invalidate decoded-frame readback')
	path := os.join_path(vp.frame_readback_dir, '${frame.display_order}.nv12')
	os.write_file_array(path, unsafe { frame.mapped.vbytes(int(size)) })!
	frame.pending = false
}

fn (mut vp VideoPlayer) finish_frame_readback() ! {
	if vp.frame_readback_dir == '' || vp.frame_readback_done {
		return
	}
	for i, frame in vp.frame_readbacks {
		if !frame.pending {
			continue
		}
		fence := vp.video_frames[i].in_flight_fence
		check_vk(vk.wait_for_fences(vp.app.device_context.vk_device, 1, &fence, vk._true, max_u64),
			'Could not wait for decoded-frame readback')
		vp.write_frame_readback(i)!
	}
	vp.frame_readback_done = true
	eprintln('Decoded NV12 frames written to ${vp.frame_readback_dir}')
}

fn (mut vp VideoPlayer) release_frame_readback() {
	for mut frame in vp.frame_readbacks {
		if !isnil(frame.mapped) {
			vp.app.device_context.memory_allocator.unmap(mut frame.allocation)
			frame.mapped = unsafe { nil }
		}
		if !isnil(frame.buffer) {
			vk.destroy_buffer(vp.app.device_context.vk_device, frame.buffer, unsafe { nil })
			frame.buffer = unsafe { nil }
		}
		_ = vp.app.device_context.memory_allocator.release(mut frame.allocation)
	}
	vp.frame_readbacks.clear()
}
