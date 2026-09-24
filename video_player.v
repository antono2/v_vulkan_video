module main

import antono2.vulkan as vk
import os
import math
import antono2.vkmemalloc as vkmem

const max_texture_count = 64
const slot_count = 17

enum DecodeOutputMode {
	automatic
	coincident
	distinct
}

fn select_decode_output_mode(requested DecodeOutputMode, supports_coincident bool,
	supports_distinct bool) !DecodeOutputMode {
	return match requested {
		.automatic {
			if supports_coincident {
				DecodeOutputMode.coincident
			} else if supports_distinct {
				DecodeOutputMode.distinct
			} else {
				return error('Vulkan Video device supports neither coincident nor distinct DPB/output images')
			}
		}
		.coincident {
			if !supports_coincident {
				return error('Vulkan Video device does not support forced coincident DPB/output images')
			}
			DecodeOutputMode.coincident
		}
		.distinct {
			if !supports_distinct {
				return error('Vulkan Video device does not support forced distinct DPB/output images')
			}
			DecodeOutputMode.distinct
		}
	}
}

struct VideoPlayer {
mut:
	decode_operation          DecoderVideoDecodeOperation
	output_textures           []OutputImage
	output_textures_free      []int
	output_textures_ready     []int
	output_textures_retired   []RetiredOutputImage
	current_output_index      int = -1
	next_display_order        int
	presentation_buffer_count int = 1
	decode_finished           bool
	waiting_for_loop_start    bool
	render_serial             u64
	is_stopped                bool
	is_looping                bool = true
	dpb_slot_used             []int
	dpb                       DPB
	current_frame             int
	flags                     u32
	video_frames              []VideoPlayerDecodeStreamFrame
	decode_output_image       Image
	decode_output_state       DPBResourceState
	playback_timeline         PlaybackTimeline
	current_upload_index      int
	graphics_command_pool     vk.CommandPool = unsafe { nil }
	video_command_pool        vk.CommandPool = unsafe { nil }
pub mut:
	app                  &VideoDecodeApp = unsafe { nil }
	decoder              shared Decoder
	event_video_player   vk.Event
	command_buffer_infos []CommandBufferInfo
}

struct Decoder {
pub mut:
	properties                 DecoderQueryProperties
	settings                   DecoderSettings
	video_data                 DecoderVideoFileProperties
	gpu_bitstream_buffer       vk.Buffer = unsafe { nil }
	gpu_bitstream_allocation   vkmem.AllocationInfo
	session_memory_allocations []vk.DeviceMemory
	video_session              vk.VideoSessionKHR           = unsafe { nil }
	video_session_parameters   vk.VideoSessionParametersKHR = unsafe { nil }
	info                       DecoderInfo
}

struct DecoderDpbState {
pub mut:
	slotindex      int
	frame_num      int
	reference_info vk.StdVideoDecodeH264ReferenceInfo
}

struct DecoderInfo {
pub mut:
	memory_frames []DecoderVideoMemoryFrameInfo
	images_dpb    []DecoderDpbImage
	dpb_state     []DecoderDpbState
}

struct DecoderVideoMemoryFrameInfo {
pub mut:
	data_frame_info                           &DecoderVideoDataFrameInfo
	gpu_bitstream_offset                      u64
	gpu_bitstream_capacity                    u64
	gpu_bitstream_size                        u64
	gpu_bitstream_slice_mapped_memory_address &u8
	decoding_frame_index                      int = -1
}

struct VideoPlayerDecodeStreamFrame {
pub mut:
	gpu_bitstream_capacity                    u64
	gpu_bitstream_offset                      u64
	gpu_bitstream_size                        u64
	gpu_bitstream_slice_mapped_memory_address byteptr
	slice_offsets                             []u32
	in_flight_fence                           vk.Fence = unsafe { nil }
}

struct CommandBufferInfo {
pub mut:
	video_command_buffer    vk.CommandBuffer
	graphics_command_buffer vk.CommandBuffer
	sem_video_to_gfx        vk.Semaphore
}

enum VideoPlayerFlags as u32 {
	e_none          = 0
	e_playing       = 1 << 1
	e_decoder_reset = 1 << 3
	e_need_resolve  = 1 << 4
}

struct DPB {
pub mut:
	image            [slot_count]Image
	resource_state   [slot_count]DPBResourceState
	poc_status       [slot_count]int
	frame_num_status [slot_count]int
	reference_usage  []u8
	next_ref         u8
	next_slot        u8
	current_slot     u8
}

// Choose a slot which is not referenced by the picture being decoded. When all
// slots are references, expire the oldest short-term reference first (the H.264
// sliding-window default). Explicit MMCO and long-term references are handled
// separately as stream metadata becomes available.
fn (mut dpb DPB) acquire_decode_slot(slot_limit int) u8 {
	assert slot_limit > 0 && slot_limit <= slot_count
	for slot in 0 .. slot_limit {
		if u8(slot) !in dpb.reference_usage {
			return u8(slot)
		}
	}
	assert dpb.reference_usage.len > 0
	expired_slot := dpb.reference_usage[0]
	dpb.reference_usage.delete(0)
	return expired_slot
}

struct DPBResourceState {
pub mut:
	flag   vk.AccessFlags2
	layout vk.ImageLayout
}

struct OutputImage {
pub mut:
	display_order int = -1
	texture       Image
	duration_ns   i64
	layout        vk.ImageLayout
	is_new        bool = true
}

struct RetiredOutputImage {
	index                 int
	reusable_after_serial u64
}

struct Image {
pub mut:
	image           vk.Image
	view            vk.ImageView
	allocation      vkmem.Allocator
	allocation_info vkmem.AllocationInfo
}

struct DecoderQueryProperties {
pub mut:
	decode_h264_caps        vk.VideoDecodeH264CapabilitiesKHR
	decode_caps             vk.VideoDecodeCapabilitiesKHR
	caps                    vk.VideoCapabilitiesKHR
	format_props            vk.VideoFormatPropertiesKHR
	dpb_format_props        vk.VideoFormatPropertiesKHR
	dpb_and_output_coincide bool
	usage_dpb               vk.ImageUsageFlags
}

struct DecoderSettings {
pub mut:
	decode_h264_profile_info vk.VideoDecodeH264ProfileInfoKHR
	profile_info             vk.VideoProfileInfoKHR
	profile_list_info        vk.VideoProfileListInfoKHR
}

enum DecoderFrameType as u8 {
	e_unknown = 0
	e_intra
	e_predictive
}

struct DecoderVideoDataFrameInfo {
pub mut:
	src_offset             u64
	frame_bytes_num        u64
	size                   u64
	poc                    int
	bottom_field_order_cnt u32
	top_field_order_cnt    u32
	gop                    int
	display_order          int
	decode_time_ns         i64
	display_time_ns        i64
	duration_ns            i64
	nal_unit_type          u8
	frame_type             DecoderFrameType
	nal_ref_idc            u32
	reference_priority     u32
}

fn compare_frame_display_order(a &DecoderVideoDataFrameInfo, b &DecoderVideoDataFrameInfo) int {
	key_a := u64(a.gop) << 32 | u64(a.poc)
	key_b := u64(b.gop) << 32 | u64(b.poc)
	if key_a < key_b {
		return -1
	}
	if key_a > key_b {
		return 1
	}
	return 0
}

// presentation_buffer_size returns the number of decoded pictures which may
// have to wait while an earlier display-order picture is still being decoded.
// One additional slot is reserved for that missing picture itself.
fn presentation_buffer_size(display_orders []int) int {
	mut waiting := map[int]bool{}
	mut next_display_order := 0
	mut max_waiting := 0
	for display_order in display_orders {
		waiting[display_order] = true
		for waiting[next_display_order] {
			waiting.delete(next_display_order)
			next_display_order++
		}
		max_waiting = math.max(max_waiting, waiting.len)
	}
	return max_waiting + 1
}

struct DecoderVideoFileProperties {
pub mut:
	file               os.File
	file_open          bool
	h264_profile_idc   u32
	width_padd         u32
	height_padd        u32
	width              u32
	height             u32
	sps_count          u32
	pps_count          u32
	slice_header_count u32

	frame_infos                 []DecoderVideoDataFrameInfo
	max_memory_frame_size_bytes u64
	num_dpb_slots               u32
	max_reference_pictures      u32

	sps_bytes           []u8
	pps_bytes           []u8
	slice_header_bytes  []u8
	frame_display_order []u64

	total_duration i64
	metadata       VideoMetadata
}

struct VideoMetadata {
pub mut:
	coded_width                u32
	coded_height               u32
	display_width              u32
	display_height             u32
	sar_width                  u32 = 1
	sar_height                 u32 = 1
	rotation_degrees           int
	track_matrix               [9]i32
	video_full_range           bool
	colour_description_present bool
	colour_primaries           u8
	transfer_function          u8
	matrix_coefficients        u8
}

fn rotation_from_track_matrix(matrix [9]i32) int {
	a := matrix[0]
	b := matrix[1]
	c := matrix[3]
	d := matrix[4]
	if a < 0 && d < 0 {
		return 180
	}
	if b > 0 && c < 0 {
		return -90
	}
	if b < 0 && c > 0 {
		return 90
	}
	return 0
}

fn h264_profile_name(profile_idc u32) string {
	return match profile_idc {
		66 { 'Baseline' }
		77 { 'Main' }
		100 { 'High' }
		else { 'Unknown (${profile_idc})' }
	}
}

fn sample_aspect_ratio(aspect_ratio_idc u32, extended_width u32, extended_height u32) (u32, u32) {
	if aspect_ratio_idc == 255 {
		if extended_width > 0 && extended_height > 0 {
			return extended_width, extended_height
		}
		return 1, 1
	}
	return match aspect_ratio_idc {
		1 { u32(1), u32(1) }
		2 { u32(12), u32(11) }
		3 { u32(10), u32(11) }
		4 { u32(16), u32(11) }
		5 { u32(40), u32(33) }
		6 { u32(24), u32(11) }
		7 { u32(20), u32(11) }
		8 { u32(32), u32(11) }
		9 { u32(80), u32(33) }
		10 { u32(18), u32(11) }
		11 { u32(15), u32(11) }
		12 { u32(64), u32(33) }
		13 { u32(160), u32(99) }
		14 { u32(4), u32(3) }
		15 { u32(3), u32(2) }
		16 { u32(2), u32(1) }
		else { u32(1), u32(1) }
	}
}

fn (mut metadata VideoMetadata) update_display_dimensions() {
	mut width := u64(metadata.coded_width) * u64(metadata.sar_width) / u64(metadata.sar_height)
	mut height := u64(metadata.coded_height)
	if metadata.rotation_degrees in [90, -90] {
		width, height = height, width
	}
	metadata.display_width = u32(width)
	metadata.display_height = u32(height)
}

struct DecoderDpbImage {
pub mut:
	image vk.Image
	view  vk.ImageView
	// TODO: Refactor Allocator to Decoder
	allocator       vkmem.Allocator
	allocation_info vkmem.AllocationInfo
}

struct DecoderVideoDecodeOperation {
pub mut:
	flags               u32
	stream_offset       u64
	stream_size         u64
	frame_type          DecoderFrameType = DecoderFrameType.e_intra
	reference_priority  u32
	decoded_frame_index int
	slice_header        voidptr = unsafe { nil }
	pps                 voidptr = unsafe { nil }
	sps                 voidptr = unsafe { nil }
	poc                 [2]int
	current_dpb         u32
	dpb_reference_count u32
	dpb_reference_slots &u8  = unsafe { nil }
	dpb_poc             &int = unsafe { nil }
	dpb_frame_num       &int = unsafe { nil }
	dpb_slot_num        u32
	p_dpbs              vk.Image
	p_dpb_views         vk.ImageView
	slice_count         u32
	slice_offsets       &u32 = unsafe { nil }
}

enum DecoderVideoDecodeOperationFlags {
	e_none          = 0
	e_session_reset = 1
}

// TODO: May be worth to use interface types, but interfaces IApp containg sub interface IDeviceContext "error: `&video_decode_app.VideoDecodeApp` incorrectly implements field `device_context` of interface `examples.video_decode_app.video_player.IApp`, expected `video_player.IDeviceContext`, got `video_decode_app.DeviceContext`", no matter what's in the interface
fn (mut vp VideoPlayer) prepare(path string) ! {
	// Do not propagate parser errors from inside the lock: cleanup must be able
	// to reacquire it and close a partially opened input file.
	mut parse_error := ''
	lock vp.decoder {
		vp.decoder.parse_mp4_data(path) or { parse_error = err.msg() }
	}
	if parse_error != '' {
		return error(parse_error)
	}
}

fn (mut vp VideoPlayer) close_input() {
	lock vp.decoder {
		if vp.decoder.video_data.file_open {
			vp.decoder.video_data.file.close()
			vp.decoder.video_data.file_open = false
		}
	}
}

fn (vp &VideoPlayer) h264_profile_idc() u32 {
	rlock vp.decoder {
		return vp.decoder.video_data.h264_profile_idc
	}
}

fn (vp &VideoPlayer) metadata() VideoMetadata {
	rlock vp.decoder {
		return vp.decoder.video_data.metadata
	}
}

fn (mut vp VideoPlayer) initialize(mut app VideoDecodeApp) {
	vp.app = app
	lock vp.decoder {
		vp.decoder.initialize(mut app)
		vp.video_frames = []VideoPlayerDecodeStreamFrame{len: vp.decoder.info.memory_frames.len}
		for i, frame in vp.decoder.info.memory_frames {
			vp.video_frames[i] = VideoPlayerDecodeStreamFrame{
				gpu_bitstream_capacity:                    frame.gpu_bitstream_capacity
				gpu_bitstream_offset:                      frame.gpu_bitstream_offset
				gpu_bitstream_size:                        frame.gpu_bitstream_size
				gpu_bitstream_slice_mapped_memory_address: byteptr(frame.gpu_bitstream_slice_mapped_memory_address)
			}
		}
		if vp.decoder.info.images_dpb.len > vp.dpb.image.len {
			panic('Video stream requires too many DPB images')
		}
		for i, image in vp.decoder.info.images_dpb {
			vp.dpb.image[i] = Image{
				image:           image.image
				view:            image.view
				allocation_info: image.allocation_info
			}
		}
		vp.presentation_buffer_count = presentation_buffer_size(vp.decoder.video_data.frame_infos.map(it.display_order))
	}

	vk_device := app.device_context.vk_device
	for i in 0 .. vp.decoder.info.memory_frames.len {
		fence_ci := vk.FenceCreateInfo{
			flags: vk.FenceCreateFlags(vk.FenceCreateFlagBits.signaled)
		}
		res := vk.create_fence(vk_device, &fence_ci, unsafe { nil }, &vp.video_frames[i].in_flight_fence)
		check_vk(res, 'Could not create video-frame fence ${i}')
	}
	mut command_pool_ci := vk.CommandPoolCreateInfo{
		flags: vk.CommandPoolCreateFlags(vk.CommandPoolCreateFlagBits.reset_command_buffer)
	}
	command_pool_ci.queueFamilyIndex = app.device_context.graphics_family
	mut res := vk.create_command_pool(vk_device, &command_pool_ci, unsafe { nil }, &vp.graphics_command_pool)
	check_vk(res, 'Could not create video-player graphics command pool')
	command_pool_ci.queueFamilyIndex = app.device_context.get_decoder_queue_family_index()
	res = vk.create_command_pool(vk_device, &command_pool_ci, unsafe { nil }, &vp.video_command_pool)
	check_vk(res, 'Could not create video-decode command pool')

	vp.command_buffer_infos = []CommandBufferInfo{len: app.device_context.swapchain.image_views.len}
	for mut info in vp.command_buffer_infos {
		mut alloc_info := vk.CommandBufferAllocateInfo{
			level:              .primary
			commandBufferCount: 1
		}
		alloc_info.commandPool = vp.graphics_command_pool
		res = vk.allocate_command_buffers(vk_device, &alloc_info, &info.graphics_command_buffer)
		check_vk(res, 'Could not allocate video-player graphics command buffer')
		alloc_info.commandPool = vp.video_command_pool
		res = vk.allocate_command_buffers(vk_device, &alloc_info, &info.video_command_buffer)
		check_vk(res, 'Could not allocate video-decode command buffer')
		semaphore_ci := vk.SemaphoreCreateInfo{}
		res = vk.create_semaphore(vk_device, &semaphore_ci, unsafe { nil }, &info.sem_video_to_gfx)
		check_vk(res, 'Could not create video-to-graphics semaphore')
	}
	event_ci := vk.EventCreateInfo{}
	res = vk.create_event(vk_device, &event_ci, unsafe { nil }, &vp.event_video_player)
	check_vk(res, 'Could not create video-player event')
	output_texture_count := vp.presentation_buffer_count + vp.command_buffer_infos.len + 2
	if output_texture_count > max_texture_count {
		panic('Video requires ${output_texture_count} presentation images, but the player supports at most ${max_texture_count}')
	}
	decode_family := app.device_context.get_decoder_queue_family_index()
	if decode_family != app.device_context.graphics_family {
		println('Display image queues: decode family ${decode_family}, graphics family ${app.device_context.graphics_family} (concurrent)')
	} else {
		println('Display image queue family: ${decode_family} (exclusive)')
	}
	for _ in 0 .. output_texture_count {
		vp.create_output_image()
	}
	println('Presentation queue: ${vp.presentation_buffer_count} reorder images, ${output_texture_count} images total')
	if !vp.decoder.properties.dpb_and_output_coincide {
		vp.create_decode_output_image()
	}
}

fn (mut vp VideoPlayer) recreate_swapchain_resources() {
	vk_device := vp.app.device_context.vk_device
	for mut info in vp.command_buffer_infos {
		if !isnil(info.graphics_command_buffer) {
			vk.free_command_buffers(vk_device, vp.graphics_command_pool, 1, &info.graphics_command_buffer)
		}
		if !isnil(info.video_command_buffer) {
			vk.free_command_buffers(vk_device, vp.video_command_pool, 1, &info.video_command_buffer)
		}
		if !isnil(info.sem_video_to_gfx) {
			vk.destroy_semaphore(vk_device, info.sem_video_to_gfx, unsafe { nil })
		}
	}
	vp.command_buffer_infos = []CommandBufferInfo{len: vp.app.device_context.swapchain.image_views.len}
	for mut info in vp.command_buffer_infos {
		mut alloc_info := vk.CommandBufferAllocateInfo{
			level:              .primary
			commandBufferCount: 1
			commandPool:        vp.graphics_command_pool
		}
		mut result := vk.allocate_command_buffers(vk_device, &alloc_info, &info.graphics_command_buffer)
		check_vk(result, 'Could not reallocate video-player graphics command buffer')
		alloc_info.commandPool = vp.video_command_pool
		result = vk.allocate_command_buffers(vk_device, &alloc_info, &info.video_command_buffer)
		check_vk(result, 'Could not reallocate video-decode command buffer')
		result = vk.create_semaphore(vk_device, &vk.SemaphoreCreateInfo{}, unsafe { nil }, &info.sem_video_to_gfx)
		check_vk(result, 'Could not recreate video-to-graphics semaphore')
	}
	// The caller waits for device idle before rebuilding the swapchain, so every
	// retired presentation image can be reused immediately. Grow the pool if the
	// replacement swapchain has more images than the old one.
	for retired in vp.output_textures_retired {
		vp.output_textures_free << retired.index
	}
	vp.output_textures_retired.clear()
	required_output_count := vp.presentation_buffer_count + vp.command_buffer_infos.len + 2
	if required_output_count > max_texture_count {
		panic('Resized swapchain requires ${required_output_count} presentation images, but the player supports at most ${max_texture_count}')
	}
	for vp.output_textures.len < required_output_count {
		vp.create_output_image()
	}
}

fn (mut vp VideoPlayer) shutdown() {
	vk_device := vp.app.device_context.vk_device
	for mut info in vp.command_buffer_infos {
		if !isnil(info.sem_video_to_gfx) {
			vk.destroy_semaphore(vk_device, info.sem_video_to_gfx, unsafe { nil })
			info.sem_video_to_gfx = unsafe { nil }
		}
	}
	vp.command_buffer_infos.clear()
	if !isnil(vp.graphics_command_pool) {
		vk.destroy_command_pool(vk_device, vp.graphics_command_pool, unsafe { nil })
		vp.graphics_command_pool = unsafe { nil }
	}
	if !isnil(vp.video_command_pool) {
		vk.destroy_command_pool(vk_device, vp.video_command_pool, unsafe { nil })
		vp.video_command_pool = unsafe { nil }
	}
	if !isnil(vp.event_video_player) {
		vk.destroy_event(vk_device, vp.event_video_player, unsafe { nil })
		vp.event_video_player = unsafe { nil }
	}
	for mut frame in vp.video_frames {
		if !isnil(frame.in_flight_fence) {
			vk.destroy_fence(vk_device, frame.in_flight_fence, unsafe { nil })
			frame.in_flight_fence = unsafe { nil }
		}
	}
	lock vp.decoder {
		for mut output in vp.output_textures {
			if !isnil(output.texture.view) {
				vk.destroy_image_view(vk_device, output.texture.view, unsafe { nil })
				output.texture.view = unsafe { nil }
			}
			if !isnil(output.texture.image) {
				vk.destroy_image(vk_device, output.texture.image, unsafe { nil })
				output.texture.image = unsafe { nil }
			}
			_ = vp.app.device_context.memory_allocator.release(mut output.texture.allocation_info)
		}
		vp.output_textures.clear()
		vp.output_textures_free.clear()
		vp.output_textures_ready.clear()
		vp.output_textures_retired.clear()
		if !isnil(vp.decode_output_image.view) {
			vk.destroy_image_view(vk_device, vp.decode_output_image.view, unsafe { nil })
			vp.decode_output_image.view = unsafe { nil }
		}
		if !isnil(vp.decode_output_image.image) {
			vk.destroy_image(vk_device, vp.decode_output_image.image, unsafe { nil })
			vp.decode_output_image.image = unsafe { nil }
		}
		_ = vp.app.device_context.memory_allocator.release(mut vp.decode_output_image.allocation_info)
		for mut dpb in vp.decoder.info.images_dpb {
			if !isnil(dpb.view) {
				vk.destroy_image_view(vk_device, dpb.view, unsafe { nil })
				dpb.view = unsafe { nil }
			}
			if !isnil(dpb.image) {
				vk.destroy_image(vk_device, dpb.image, unsafe { nil })
				dpb.image = unsafe { nil }
			}
			_ = vp.app.device_context.memory_allocator.release(mut dpb.allocation_info)
		}
		if !isnil(vp.decoder.gpu_bitstream_buffer) {
			vp.app.device_context.memory_allocator.unmap(mut vp.decoder.gpu_bitstream_allocation)
			vk.destroy_buffer(vk_device, vp.decoder.gpu_bitstream_buffer, unsafe { nil })
			vp.decoder.gpu_bitstream_buffer = unsafe { nil }
		}
		_ = vp.app.device_context.memory_allocator.release(mut vp.decoder.gpu_bitstream_allocation)
		if !isnil(vp.decoder.video_session_parameters) {
			vk.destroy_video_session_parameters_khr(vk_device, vp.decoder.video_session_parameters, unsafe { nil })
			vp.decoder.video_session_parameters = unsafe { nil }
		}
		if !isnil(vp.decoder.video_session) {
			vk.destroy_video_session_khr(vk_device, vp.decoder.video_session, unsafe { nil })
			vp.decoder.video_session = unsafe { nil }
		}
		for memory in vp.decoder.session_memory_allocations {
			if !isnil(memory) {
				vk.free_memory(vk_device, memory, unsafe { nil })
			}
		}
		vp.decoder.session_memory_allocations.clear()
	}
}

fn (mut vp VideoPlayer) create_output_image() {
	mut dev_ctx := vp.app.device_context
	mut output := OutputImage{}
	queue_families := [dev_ctx.get_decoder_queue_family_index(), dev_ctx.graphics_family]
	queues_differ := queue_families[0] != queue_families[1]
	queue_family_data := if queues_differ {
		queue_families.data
	} else {
		unsafe { &u32(nil) }
	}
	mut image_ci := vk.ImageCreateInfo{
		pNext:                 unsafe { nil }
		flags:                 0
		imageType:             ._2d
		format:                vp.decoder.properties.format_props.format
		extent:                vk.Extent3D{
			width:  vp.decoder.video_data.width
			height: vp.decoder.video_data.height
			depth:  1
		}
		mipLevels:             1
		arrayLayers:           1
		samples:               ._1
		tiling:                .optimal
		usage:                 vk.ImageUsageFlags(u32(vk.ImageUsageFlagBits.transfer_dst) | u32(vk.ImageUsageFlagBits.sampled))
		sharingMode:           .exclusive
		queueFamilyIndexCount: 0
		pQueueFamilyIndices:   unsafe { nil }
		initialLayout:         .undefined
	}
	if queues_differ {
		image_ci.sharingMode = .concurrent
		image_ci.queueFamilyIndexCount = u32(queue_families.len)
		image_ci.pQueueFamilyIndices = queue_family_data
	}
	mut res := vp.app.device_context.memory_allocator.create_image_with_options(&image_ci, vkmem.AllocationOptions{
		usage: .gpu_only
	}, &output.texture.image, mut output.texture.allocation_info)
	check_vk(res, 'Could not create sampled video output image')
	mut conversion_info := vk.SamplerYcbcrConversionInfo{
		conversion: dev_ctx.sampler_ycbcr_conversion
	}
	view_ci := vk.ImageViewCreateInfo{
		pNext:            &conversion_info
		image:            output.texture.image
		viewType:         ._2d
		format:           image_ci.format
		subresourceRange: vk.ImageSubresourceRange{
			aspectMask: vk.ImageAspectFlags(vk.ImageAspectFlagBits.color)
			levelCount: 1
			layerCount: 1
		}
	}
	res = vk.create_image_view(dev_ctx.vk_device, &view_ci, unsafe { nil }, &output.texture.view)
	check_vk(res, 'Could not create sampled video output image view')
	vp.output_textures << output
	vp.output_textures_free << vp.output_textures.len - 1
}

fn (mut vp VideoPlayer) create_decode_output_image() {
	mut dev_ctx := vp.app.device_context
	image_ci := vk.ImageCreateInfo{
		pNext:                 &vp.decoder.settings.profile_list_info
		flags:                 0
		imageType:             ._2d
		format:                vp.decoder.properties.format_props.format
		extent:                vk.Extent3D{
			width:  vp.decoder.video_data.width
			height: vp.decoder.video_data.height
			depth:  1
		}
		mipLevels:             1
		arrayLayers:           1
		samples:               ._1
		tiling:                .optimal
		usage:                 vk.ImageUsageFlags(u32(vk.ImageUsageFlagBits.video_decode_dst) | u32(vk.ImageUsageFlagBits.transfer_src))
		sharingMode:           .exclusive
		queueFamilyIndexCount: 0
		pQueueFamilyIndices:   unsafe { nil }
		initialLayout:         .undefined
	}
	mut result := vp.app.device_context.memory_allocator.create_image_with_options(&image_ci, vkmem.AllocationOptions{
		usage: .gpu_only
	}, &vp.decode_output_image.image, mut vp.decode_output_image.allocation_info)
	check_vk(result, 'Could not create distinct video decode-output image')
	view_ci := vk.ImageViewCreateInfo{
		image:            vp.decode_output_image.image
		viewType:         ._2d
		format:           image_ci.format
		subresourceRange: vk.ImageSubresourceRange{
			aspectMask: vk.ImageAspectFlags(vk.ImageAspectFlagBits.color)
			levelCount: 1
			layerCount: 1
		}
	}
	result = vk.create_image_view(dev_ctx.vk_device, &view_ci, unsafe { nil }, &vp.decode_output_image.view)
	check_vk(result, 'Could not create distinct video decode-output image view')
}

fn query_video_format(gpu vk.PhysicalDevice, profile_list &vk.VideoProfileListInfoKHR,
	usage vk.ImageUsageFlags) ?vk.VideoFormatPropertiesKHR {
	format_info := vk.PhysicalDeviceVideoFormatInfoKHR{
		pNext:      unsafe { profile_list }
		imageUsage: usage
	}
	mut count := u32(0)
	mut no_formats := unsafe { nil }
	mut result := vk.get_physical_device_video_format_properties_khr(gpu, &format_info, &count, mut no_formats)
	if result != .success || count == 0 {
		return none
	}
	mut formats := []vk.VideoFormatPropertiesKHR{len: int(count), init: vk.VideoFormatPropertiesKHR{}}
	mut formats_data := formats.data
	result = vk.get_physical_device_video_format_properties_khr(gpu, &format_info, &count, mut formats_data)
	if result != .success || count == 0 {
		return none
	}
	return formats[0]
}
