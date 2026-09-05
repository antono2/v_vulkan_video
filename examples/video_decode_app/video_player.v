module video_decode_app

import vulkan as vk
import os
import math
import vulkan_memory_allocator as vma
import minimp4
import h264

pub const max_texture_count = 64
pub const slot_count = 17

pub struct VideoPlayer {
mut:
	decode_operation      DecoderVideoDecodeOperation
	output_textures_free  []OutputImage
	output_textures_used  []OutputImage
	video_cursor          VideoCursorInfo
	is_prepared           bool
	is_stopped            bool
	is_looping            bool = true
	dpb_slot_used         []int
	dpb                   DPB
	current_frame         int
	flags                 u32
	video_frames          []VideoPlayerDecodeStreamFrame
	output_image          Image
	decode_output_image   Image
	output_image_layout   vk.ImageLayout
	output_image_is_new   bool = true
	decode_output_state   DPBResourceState
	playback_timeline     PlaybackTimeline
	current_upload_index  int
	graphics_command_pool vk.CommandPool = unsafe { nil }
	video_command_pool    vk.CommandPool = unsafe { nil }
pub mut:
	app                  &VideoDecodeApp = unsafe { nil }
	decoder              shared Decoder
	event_video_player   vk.Event
	command_buffer_infos []CommandBufferInfo
}

pub struct Decoder {
pub mut:
	properties                 DecoderQueryProperties
	settings                   DecoderSettings
	video_data                 DecoderVideoFileProperties
	gpu_bitstream_buffer       vk.Buffer = unsafe { nil }
	gpu_bitstream_allocation   vma.AllocationInfo
	session_memory_allocations []vk.DeviceMemory
	video_session              vk.VideoSessionKHR = unsafe { nil }
	video_session_parameters   vk.VideoSessionParametersKHR = unsafe { nil }
	info                       DecoderInfo
}

pub struct DecoderDpbState {
pub mut:
	slotindex      int
	frame_num      int
	reference_info vk.StdVideoDecodeH264ReferenceInfo
}

pub struct DecoderInfo {
pub mut:
	memory_frames []DecoderVideoMemoryFrameInfo
	images_dpb    []DecoderDpbImage
	dpb_state     []DecoderDpbState
}

pub struct DecoderVideoMemoryFrameInfo {
pub mut:
	data_frame_info                           &DecoderVideoDataFrameInfo
	gpu_bitstream_offset                      u64
	gpu_bitstream_capacity                    u64
	gpu_bitstream_size                        u64
	gpu_bitstream_slice_mapped_memory_address &u8
	decoding_frame_index                      int = -1
}

pub struct VideoPlayerDecodeStreamFrame {
pub mut:
	gpu_bitstream_capacity                    u64
	gpu_bitstream_offset                      u64
	gpu_bitstream_size                        u64
	gpu_bitstream_slice_mapped_memory_address byteptr
	slice_offsets                             []u32
	in_flight_fence                           vk.Fence = unsafe { nil }
}

pub struct CommandBufferInfo {
pub mut:
	video_command_buffer    vk.CommandBuffer
	graphics_command_buffer vk.CommandBuffer
	sem_video_to_gfx        vk.Semaphore
}

pub enum VideoPlayerFlags as u32 {
	e_none                        = 0
	e_playing                     = 1 << 1
	e_decoder_reset               = 1 << 3
	e_need_resolve                = 1 << 4
}

pub struct DPB {
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

pub struct DPBResourceState {
pub mut:
	flag   vk.AccessFlags2
	layout vk.ImageLayout
}

pub struct OutputImage {
pub mut:
	display_order int = -1
	texture       Image
	flags         u32
	duration      i64
}

pub enum OutputImageFlags {
	e_init = 1
}

pub struct VideoCursorInfo {
pub mut:
	index_play  int // frame being played
	index_frame int // decoded frame
}

pub struct Image {
pub mut:
	image           vk.Image
	view            vk.ImageView
	allocation      vma.Allocator
	allocation_info vma.AllocationInfo
}

pub struct DecoderQueryProperties {
pub mut:
	decode_h264_caps        vk.VideoDecodeH264CapabilitiesKHR
	decode_caps             vk.VideoDecodeCapabilitiesKHR
	caps                    vk.VideoCapabilitiesKHR
	format_props            vk.VideoFormatPropertiesKHR
	dpb_format_props        vk.VideoFormatPropertiesKHR
	dpb_and_output_coincide bool
	usage_dpb               vk.ImageUsageFlags
}

pub struct DecoderSettings {
pub mut:
	decode_h264_profile_info vk.VideoDecodeH264ProfileInfoKHR
	profile_info             vk.VideoProfileInfoKHR
	profile_list_info        vk.VideoProfileListInfoKHR
}

pub enum DecoderFrameType as u8 {
	e_unknown = 0
	e_intra
	e_predictive
}

pub struct DecoderVideoDataFrameInfo {
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

pub struct DecoderVideoFileProperties {
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

pub struct VideoMetadata {
pub mut:
	coded_width         u32
	coded_height        u32
	display_width       u32
	display_height      u32
	sar_width           u32 = 1
	sar_height          u32 = 1
	rotation_degrees    int
	track_matrix        [9]i32
	video_full_range    bool
	colour_primaries    u8
	transfer_function   u8
	matrix_coefficients u8
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

pub struct DecoderDpbImage {
pub mut:
	image vk.Image
	view  vk.ImageView
	// TODO: Refactor Allocator to Decoder
	allocator       vma.Allocator
	allocation_info vma.AllocationInfo
}

pub struct DecoderVideoDecodeOperation {
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
	dpb_reference_slots &u8 = unsafe { nil }
	dpb_poc             &int = unsafe { nil }
	dpb_frame_num       &int = unsafe { nil }
	dpb_slot_num        u32
	p_dpbs              vk.Image
	p_dpb_views         vk.ImageView
	slice_count         u32
	slice_offsets       &u32 = unsafe { nil }
}

pub enum DecoderVideoDecodeOperationFlags {
	e_none          = 0
	e_session_reset = 1
}

// TODO: May be worth to use interface types, but interfaces IApp containg sub interface IDeviceContext "error: `&video_decode_app.VideoDecodeApp` incorrectly implements field `device_context` of interface `examples.video_decode_app.video_player.IApp`, expected `video_player.IDeviceContext`, got `video_decode_app.DeviceContext`", no matter what's in the interface
pub fn (mut vp VideoPlayer) prepare(path string) ! {
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

pub fn (mut vp VideoPlayer) close_input() {
	lock vp.decoder {
		if vp.decoder.video_data.file_open {
			vp.decoder.video_data.file.close()
			vp.decoder.video_data.file_open = false
		}
	}
}

pub fn (vp &VideoPlayer) h264_profile_idc() u32 {
	rlock vp.decoder {
		return vp.decoder.video_data.h264_profile_idc
	}
}

pub fn (vp &VideoPlayer) metadata() VideoMetadata {
	rlock vp.decoder {
		return vp.decoder.video_data.metadata
	}
}

pub fn (mut vp VideoPlayer) initialize(mut app VideoDecodeApp) {
	vp.app = app
	lock vp.decoder {
		vp.decoder.initialize(mut app)
		vp.video_frames = []VideoPlayerDecodeStreamFrame{len: vp.decoder.info.memory_frames.len}
		for i, frame in vp.decoder.info.memory_frames {
			vp.video_frames[i] = VideoPlayerDecodeStreamFrame{
				gpu_bitstream_capacity: frame.gpu_bitstream_capacity
				gpu_bitstream_offset: frame.gpu_bitstream_offset
				gpu_bitstream_size: frame.gpu_bitstream_size
				gpu_bitstream_slice_mapped_memory_address: byteptr(frame.gpu_bitstream_slice_mapped_memory_address)
			}
		}
		if vp.decoder.info.images_dpb.len > vp.dpb.image.len {
			panic('Video stream requires too many DPB images')
		}
		for i, image in vp.decoder.info.images_dpb {
			vp.dpb.image[i] = Image{
				image: image.image
				view: image.view
				allocation_info: image.allocation_info
			}
		}
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
			level: .primary
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
	vp.create_output_image()
	if !vp.decoder.properties.dpb_and_output_coincide {
		vp.create_decode_output_image()
	}
}

pub fn (mut vp VideoPlayer) recreate_swapchain_resources() {
	vk_device := vp.app.device_context.vk_device
	for mut info in vp.command_buffer_infos {
		if !isnil(info.graphics_command_buffer) {
			vk.free_command_buffers(vk_device, &vp.graphics_command_pool, 1, &info.graphics_command_buffer)
		}
		if !isnil(info.video_command_buffer) {
			vk.free_command_buffers(vk_device, &vp.video_command_pool, 1, &info.video_command_buffer)
		}
		if !isnil(info.sem_video_to_gfx) {
			vk.destroy_semaphore(vk_device, info.sem_video_to_gfx, unsafe { nil })
		}
	}
	vp.command_buffer_infos = []CommandBufferInfo{len: vp.app.device_context.swapchain.image_views.len}
	for mut info in vp.command_buffer_infos {
		mut alloc_info := vk.CommandBufferAllocateInfo{
			level: .primary
			commandBufferCount: 1
			commandPool: vp.graphics_command_pool
		}
		mut result := vk.allocate_command_buffers(vk_device, &alloc_info, &info.graphics_command_buffer)
		check_vk(result, 'Could not reallocate video-player graphics command buffer')
		alloc_info.commandPool = vp.video_command_pool
		result = vk.allocate_command_buffers(vk_device, &alloc_info, &info.video_command_buffer)
		check_vk(result, 'Could not reallocate video-decode command buffer')
		result = vk.create_semaphore(vk_device, &vk.SemaphoreCreateInfo{}, unsafe { nil }, &info.sem_video_to_gfx)
		check_vk(result, 'Could not recreate video-to-graphics semaphore')
	}
}

pub fn (mut vp VideoPlayer) shutdown() {
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
		if !isnil(vp.output_image.view) {
			vk.destroy_image_view(vk_device, vp.output_image.view, unsafe { nil })
			vp.output_image.view = unsafe { nil }
		}
		if !isnil(vp.output_image.image) {
			vk.destroy_image(vk_device, vp.output_image.image, unsafe { nil })
			vp.output_image.image = unsafe { nil }
		}
		_ = vp.app.device_context.vma_allocator.release(mut vp.output_image.allocation_info)
		if !isnil(vp.decode_output_image.view) {
			vk.destroy_image_view(vk_device, vp.decode_output_image.view, unsafe { nil })
			vp.decode_output_image.view = unsafe { nil }
		}
		if !isnil(vp.decode_output_image.image) {
			vk.destroy_image(vk_device, vp.decode_output_image.image, unsafe { nil })
			vp.decode_output_image.image = unsafe { nil }
		}
		_ = vp.app.device_context.vma_allocator.release(mut vp.decode_output_image.allocation_info)
		for mut dpb in vp.decoder.info.images_dpb {
			if !isnil(dpb.view) {
				vk.destroy_image_view(vk_device, dpb.view, unsafe { nil })
				dpb.view = unsafe { nil }
			}
			if !isnil(dpb.image) {
				vk.destroy_image(vk_device, dpb.image, unsafe { nil })
				dpb.image = unsafe { nil }
			}
			_ = vp.app.device_context.vma_allocator.release(mut dpb.allocation_info)
		}
		if !isnil(vp.decoder.gpu_bitstream_buffer) {
			vp.app.device_context.vma_allocator.unmap(mut vp.decoder.gpu_bitstream_allocation)
			vk.destroy_buffer(vk_device, vp.decoder.gpu_bitstream_buffer, unsafe { nil })
			vp.decoder.gpu_bitstream_buffer = unsafe { nil }
		}
		_ = vp.app.device_context.vma_allocator.release(mut vp.decoder.gpu_bitstream_allocation)
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
	queue_families := [dev_ctx.get_decoder_queue_family_index(), dev_ctx.graphics_family]
	queues_differ := queue_families[0] != queue_families[1]
	queue_family_data := if queues_differ {
		queue_families.data
	} else {
		unsafe { &u32(nil) }
	}
	mut image_ci := vk.ImageCreateInfo{
		pNext: unsafe { nil }
		flags: 0
		imageType: ._2d
		format: vp.decoder.properties.format_props.format
		extent: vk.Extent3D{
			width: vp.decoder.video_data.width
			height: vp.decoder.video_data.height
			depth: 1
		}
		mipLevels: 1
		arrayLayers: 1
		samples: ._1
		tiling: .optimal
		usage: vk.ImageUsageFlags(u32(vk.ImageUsageFlagBits.transfer_dst) | u32(vk.ImageUsageFlagBits.sampled))
		sharingMode: .exclusive
		queueFamilyIndexCount: 0
		pQueueFamilyIndices: unsafe { nil }
		initialLayout: .undefined
	}
	if queues_differ {
		image_ci.sharingMode = .concurrent
		image_ci.queueFamilyIndexCount = u32(queue_families.len)
		image_ci.pQueueFamilyIndices = queue_family_data
		println('Display image queues: decode family ${queue_families[0]}, graphics family ${queue_families[1]} (concurrent)')
	} else {
		println('Display image queue family: ${queue_families[0]} (exclusive)')
	}
	mut res := vp.app.device_context.vma_allocator.create_image(&image_ci, .gpu, &vp.output_image.image, mut vp.output_image.allocation_info)
	check_vk(res, 'Could not create sampled video output image')
	mut conversion_info := vk.SamplerYcbcrConversionInfo{
		conversion: dev_ctx.sampler_ycbcr_conversion
	}
	view_ci := vk.ImageViewCreateInfo{
		pNext: &conversion_info
		image: vp.output_image.image
		viewType: ._2d
		format: image_ci.format
		subresourceRange: vk.ImageSubresourceRange{
			aspectMask: vk.ImageAspectFlags(vk.ImageAspectFlagBits.color)
			levelCount: 1
			layerCount: 1
		}
	}
	res = vk.create_image_view(dev_ctx.vk_device, &view_ci, unsafe { nil }, &vp.output_image.view)
	check_vk(res, 'Could not create sampled video output image view')
}

fn (mut vp VideoPlayer) create_decode_output_image() {
	mut dev_ctx := vp.app.device_context
	image_ci := vk.ImageCreateInfo{
		pNext: &vp.decoder.settings.profile_list_info
		flags: 0
		imageType: ._2d
		format: vp.decoder.properties.format_props.format
		extent: vk.Extent3D{
			width: vp.decoder.video_data.width
			height: vp.decoder.video_data.height
			depth: 1
		}
		mipLevels: 1
		arrayLayers: 1
		samples: ._1
		tiling: .optimal
		usage: vk.ImageUsageFlags(u32(vk.ImageUsageFlagBits.video_decode_dst) | u32(vk.ImageUsageFlagBits.transfer_src))
		sharingMode: .exclusive
		queueFamilyIndexCount: 0
		pQueueFamilyIndices: unsafe { nil }
		initialLayout: .undefined
	}
	mut result := vp.app.device_context.vma_allocator.create_image(&image_ci, .gpu, &vp.decode_output_image.image, mut vp.decode_output_image.allocation_info)
	check_vk(result, 'Could not create distinct video decode-output image')
	view_ci := vk.ImageViewCreateInfo{
		image: vp.decode_output_image.image
		viewType: ._2d
		format: image_ci.format
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
		pNext: unsafe { profile_list }
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

fn (mut d Decoder) initialize(mut app VideoDecodeApp) {
	mut dev_ctx := app.device_context
	d.properties.decode_h264_caps = vk.VideoDecodeH264CapabilitiesKHR{}
	d.properties.decode_caps = vk.VideoDecodeCapabilitiesKHR{
		pNext: &d.properties.decode_h264_caps
	}
	d.properties.caps = vk.VideoCapabilitiesKHR{
		pNext: &d.properties.decode_caps
	}

	d.settings.decode_h264_profile_info = vk.VideoDecodeH264ProfileInfoKHR{
		stdProfileIdc: unsafe { vk.StdVideoH264ProfileIdc(d.video_data.h264_profile_idc) }
		pictureLayout: vk.VideoDecodeH264PictureLayoutFlagBitsKHR.progressive
	}
	d.settings.profile_info = vk.VideoProfileInfoKHR{
		pNext: &d.settings.decode_h264_profile_info
		videoCodecOperation: vk.VideoCodecOperationFlagBitsKHR.decode_h264
		chromaSubsampling: vk.VideoChromaSubsamplingFlagsKHR(vk.VideoChromaSubsamplingFlagBitsKHR._420)
		lumaBitDepth: vk.VideoComponentBitDepthFlagsKHR(vk.VideoComponentBitDepthFlagBitsKHR._8)
		chromaBitDepth: vk.VideoComponentBitDepthFlagsKHR(vk.VideoComponentBitDepthFlagBitsKHR._8)
	}
	d.properties.caps.pNext = &d.properties.decode_caps

	mut res := vk.get_physical_device_video_capabilities_khr(dev_ctx.get_gpu_current(), &d.settings.profile_info, mut &d.properties.caps)
	if res != vk.Result.success {
		panic('Vulkan device does not expose H.264 ${h264_profile_name(d.video_data.h264_profile_idc)} Profile decode capabilities: ${res}')
	}

	// Construct the complete wrapper so its required Vulkan sType default is
	// applied. Mutating fields of the zero-initialized embedded value leaves
	// sType at zero with some V compiler/code-generation paths; NVIDIA's driver
	// may then fault when this chain is passed to vkCreateImage.
	d.settings.profile_list_info = vk.VideoProfileListInfoKHR{
		profileCount: 1
		pProfiles: &d.settings.profile_info
	}

	capability_flags := d.properties.decode_caps.flags
	supports_coincide := (capability_flags & vk.VideoDecodeCapabilityFlagsKHR(vk.VideoDecodeCapabilityFlagBitsKHR.dpb_and_output_coincide)) != 0
	supports_distinct := (capability_flags & vk.VideoDecodeCapabilityFlagsKHR(vk.VideoDecodeCapabilityFlagBitsKHR.dpb_and_output_distinct)) != 0
	if !supports_coincide && !supports_distinct {
		panic('Vulkan Video device supports neither coincident nor distinct DPB/output images')
	}
	d.properties.dpb_and_output_coincide = supports_coincide
	println('Decode image mode: ${if supports_coincide {
		'coincident DPB/output'
	} else {
		'distinct DPB/output'
	}}')
	output_usage := vk.ImageUsageFlags(u32(vk.ImageUsageFlagBits.video_decode_dst) | u32(vk.ImageUsageFlagBits.transfer_src))
	d.properties.format_props = query_video_format(dev_ctx.get_gpu_current(), &d.settings.profile_list_info, output_usage) or {
		panic('No Vulkan Video decode-output format supports transfer to the display image')
	}
	dpb_usage := if d.properties.dpb_and_output_coincide {
		vk.ImageUsageFlags(u32(vk.ImageUsageFlagBits.video_decode_dpb) | u32(vk.ImageUsageFlagBits.video_decode_dst) | u32(vk.ImageUsageFlagBits.transfer_src))
	} else {
		vk.ImageUsageFlags(vk.ImageUsageFlagBits.video_decode_dpb)
	}
	d.properties.dpb_format_props = query_video_format(dev_ctx.get_gpu_current(), &d.settings.profile_list_info, dpb_usage) or {
		panic('No Vulkan Video DPB format supports the required decode mode')
	}
	d.properties.usage_dpb = dpb_usage

	num_memory_frames := u64(d.video_data.num_dpb_slots)
	mut aligned_frame_size := U64(d.video_data.max_memory_frame_size_bytes).align_to(d.properties.caps.minBitstreamBufferOffsetAlignment)
	aligned_frame_size = U64(aligned_frame_size).align_to(d.properties.caps.minBitstreamBufferSizeAlignment)
	d.video_data.max_memory_frame_size_bytes = aligned_frame_size
	video_decoder_queue_family_index := dev_ctx.get_decoder_queue_family_index()
	buffer_size := d.video_data.max_memory_frame_size_bytes * num_memory_frames
	buffer_ci := vk.BufferCreateInfo{
		pNext: &d.settings.profile_list_info
		flags: 0
		size: buffer_size
		usage: vk.BufferUsageFlags(vk.BufferUsageFlagBits.video_decode_src)
		sharingMode: vk.SharingMode.exclusive
		queueFamilyIndexCount: 0
		pQueueFamilyIndices: unsafe { nil }
	}
	res = app.device_context.vma_allocator.create_buffer(&buffer_ci, .staging, &d.gpu_bitstream_buffer, mut d.gpu_bitstream_allocation)
	if res != vk.Result.success {
		panic('Could not create the Vulkan Video bitstream buffer: ${res}')
	}
	// Host visible
	mut p_data := unsafe { nil }
	res = dev_ctx.vma_allocator.map(mut d.gpu_bitstream_allocation, &p_data)
	if res != vk.Result.success {
		panic('Could not map the Vulkan Video bitstream buffer: ${res}')
	}
	if d.video_data.num_dpb_slots > d.properties.caps.maxDpbSlots {
		panic('Video requires ${d.video_data.num_dpb_slots} DPB slots, but this device supports ${d.properties.caps.maxDpbSlots}')
	}
	d.video_data.max_reference_pictures = d.video_data.num_dpb_slots - 1
	if d.video_data.max_reference_pictures > d.properties.caps.maxActiveReferencePictures {
		panic('Video requires ${d.video_data.max_reference_pictures} active references, but this device supports ${d.properties.caps.maxActiveReferencePictures}')
	}

	session_ci := vk.VideoSessionCreateInfoKHR{
		queueFamilyIndex: video_decoder_queue_family_index
		pVideoProfile: &d.settings.profile_info
		pictureFormat: d.properties.format_props.format
		maxCodedExtent: vk.Extent2D{
			width: math.min(d.video_data.width, d.properties.caps.maxCodedExtent.width)
			height: math.min(d.video_data.height, d.properties.caps.maxCodedExtent.height)
		}
		referencePictureFormat: d.properties.dpb_format_props.format
		maxDpbSlots: d.video_data.num_dpb_slots
		maxActiveReferencePictures: d.video_data.max_reference_pictures
		pStdHeaderVersion: &d.properties.caps.stdHeaderVersion
	}
	res = vk.create_video_session_khr(dev_ctx.vk_device, &session_ci, unsafe { nil }, &d.video_session)
	if res != vk.Result.success {
		panic('Could not create the Vulkan Video H.264 decode session: ${res}')
	}

	mut requirement_count := u32(0)
	mut n := unsafe { nil }
	vk.get_video_session_memory_requirements_khr(dev_ctx.vk_device, d.video_session, &requirement_count, mut n)
	mut requirements := []vk.VideoSessionMemoryRequirementsKHR{len: int(requirement_count), init: vk.VideoSessionMemoryRequirementsKHR{}}

	mut requirements_data := requirements.data
	res = vk.get_video_session_memory_requirements_khr(dev_ctx.vk_device, d.video_session, &requirement_count, mut requirements_data)
	if res != vk.Result.success {
		panic('Could not query Vulkan Video session memory requirements: ${res}')
	}
	d.session_memory_allocations.ensure_cap(int(requirement_count))
	// V's length-only array initialization zeroes C structs and therefore loses
	// the Vulkan binding's required sType default. Construct every element.
	mut bind_session_memory_infos := []vk.BindVideoSessionMemoryInfoKHR{len: int(requirement_count), init: vk.BindVideoSessionMemoryInfoKHR{}}
	for i in 0 .. requirement_count {
		req := requirements[i]
		// Video-session memory is opaque driver storage. The requirement's
		// memoryTypeBits is authoritative; some drivers expose a dedicated type
		// without VK_MEMORY_PROPERTY_DEVICE_LOCAL_BIT for this binding.
		memory_type_index := dev_ctx.vma_allocator.get_memory_type(req.memoryRequirements.memoryTypeBits, vk.MemoryPropertyFlags(0))
		if memory_type_index == max_u32 {
			panic('No compatible Vulkan memory type exists for video-session binding ${req.memoryBindIndex}')
		}
		allocate_info := vk.MemoryAllocateInfo{
			allocationSize: req.memoryRequirements.size
			memoryTypeIndex: memory_type_index
		}
		mut session_memory := vk.DeviceMemory(unsafe { nil })
		res = vk.allocate_memory(dev_ctx.vk_device, &allocate_info, unsafe { nil }, &session_memory)
		if res != vk.Result.success {
			panic('Could not allocate ${req.memoryRequirements.size} bytes for Vulkan Video session binding ${req.memoryBindIndex}: ${res}')
		}
		d.session_memory_allocations << session_memory

		bind_session_memory_infos[i] = vk.BindVideoSessionMemoryInfoKHR{
			memoryBindIndex: req.memoryBindIndex
			memory: session_memory
			memoryOffset: 0
			memorySize: req.memoryRequirements.size
		}
	}

	// Resolve this extension command from the device directly. When another
	// shared object links libvulkan, ELF symbol interposition can otherwise
	// make Volk's same-named global dispatch slot unreliable.
	bind_session_memory_fn := vk.PFN_vkBindVideoSessionMemoryKHR(vk.get_device_proc_addr(dev_ctx.vk_device, c'vkBindVideoSessionMemoryKHR'))
	if isnil(voidptr(bind_session_memory_fn)) {
		panic('vkGetDeviceProcAddr returned null for vkBindVideoSessionMemoryKHR')
	}
	res = bind_session_memory_fn(dev_ctx.vk_device, d.video_session, u32(bind_session_memory_infos.len), bind_session_memory_infos.data)
	if res != vk.Result.success {
		panic('Could not bind Vulkan Video session memory: ${res}')
	}

	d.create_video_session_parameters(dev_ctx.vk_device)

	$if debug {
		if (d.properties.decode_caps.flags & vk.VideoDecodeCapabilityFlagsKHR(vk.VideoDecodeCapabilityFlagBitsKHR.dpb_and_output_coincide)) > 0 {
			println('NOTE: video decode: dpb and output coincide')
		} else {
			println('NOTE: video decode: dpb and output do NOT coincide')
		}
		if (d.properties.decode_caps.flags & vk.VideoDecodeCapabilityFlagsKHR(vk.VideoDecodeCapabilityFlagBitsKHR.dpb_and_output_distinct)) > 0 {
			println('NOTE: video decode: dpb and output distinct')
		} else {
			println('NOTE: video decode: dpb and output NOT distinct')
		}
	}

	d.prepare_decoded_picture_buffer(dev_ctx.vk_device, mut app.device_context.vma_allocator)

	d.info.memory_frames = []DecoderVideoMemoryFrameInfo{len: int(num_memory_frames), init: DecoderVideoMemoryFrameInfo{
		data_frame_info: unsafe { nil }
		gpu_bitstream_slice_mapped_memory_address: unsafe { nil }
		decoding_frame_index: -1
	}}
	mut i := u64(0)
	for mut frame in d.info.memory_frames {
		frame.gpu_bitstream_capacity = d.video_data.max_memory_frame_size_bytes
		frame.gpu_bitstream_offset = i * d.video_data.max_memory_frame_size_bytes
		frame.gpu_bitstream_size = 0
		frame.gpu_bitstream_slice_mapped_memory_address = unsafe {
			byteptr(p_data) + frame.gpu_bitstream_offset
		}
		i++
	}
	// Runtime sample uploads use absolute MP4 offsets. Do not perform an
	// unrelated seek here that can turn an otherwise completed initialization
	// into a fatal media-I/O panic.
}

pub fn (mut d Decoder) prepare_decoded_picture_buffer(device vk.Device, mut allocator vma.Allocator) {
	// Allocate an image array to store decoded pictures in  -
	// num_dpb_slots already includes one slot for the picture currently decoded.
	//
	// we know there will be at max 17 images (16+1) as 16 is the max by the standard.
	//
	// When using VmaAllocationCreateInfo later: usage VMA_MEMORY_USAGE_GPU_ONLY, preferredFlags VK_MEMORY_PROPERTY_DEVICE_LOCAL_BIT
	dpb_image_count := int(d.video_data.num_dpb_slots)
	d.info.images_dpb = []DecoderDpbImage{len: dpb_image_count}

	image_ci := vk.ImageCreateInfo{
		pNext: &d.settings.profile_list_info
		flags: 0
		imageType: vk.ImageType._2d
		format: d.properties.dpb_format_props.format
		extent: vk.Extent3D{
			width: d.video_data.width
			height: d.video_data.height
			depth: 1
		}
		mipLevels: 1
		arrayLayers: 1
		samples: vk.SampleCountFlagBits._1
		tiling: vk.ImageTiling.optimal
		usage: d.properties.usage_dpb
		sharingMode: vk.SharingMode.exclusive
		queueFamilyIndexCount: 0
		pQueueFamilyIndices: unsafe { nil }
		initialLayout: vk.ImageLayout.undefined
	}

	mut image_view_ci := vk.ImageViewCreateInfo{
		flags: 0
		image: unsafe { nil }
		viewType: vk.ImageViewType._2d
		format: image_ci.format
		components: vk.ComponentMapping{}
		subresourceRange: vk.ImageSubresourceRange{
			aspectMask: vk.ImageAspectFlags(vk.ImageAspectFlagBits.color)
			baseMipLevel: 0
			levelCount: 1
			baseArrayLayer: 0
			layerCount: 1
		}
	}

	mut dpb_index := 0
	mut res := vk.Result.error_unknown
	for mut dpb in d.info.images_dpb {
		res = allocator.create_image(&image_ci, vma.MemType.gpu, &dpb.image, mut dpb.allocation_info)
		if res != vk.Result.success {
			panic('Could not create decoded-picture-buffer image ${dpb_index}: ${res}')
		}
		image_view_ci.image = dpb.image
		res = vk.create_image_view(device, &image_view_ci, unsafe { nil }, &dpb.view)
		if res != vk.Result.success {
			panic('Could not create decoded-picture-buffer image view ${dpb_index}: ${res}')
		}
		// VK_EXT_debug_utils is enabled only for debug builds. Calling its
		// device command unconditionally jumps through a null dispatch slot in
		// release packages.
		$if debug? {
			name := 'myDPBImage${dpb_index}'
			name_info := vk.DebugUtilsObjectNameInfoEXT{
				objectType: vk.ObjectType.image
				objectHandle: u64(voidptr(dpb.image))
				pObjectName: name.str // C string
			}
			vk.set_debug_utils_object_name_ext(device, &name_info)
		}
		dpb_index++
	} // for d.info.images_dpb
}

pub fn (mut d Decoder) create_video_session_parameters(device vk.Device) {
	mut video_picture_parameter_sets := []vk.StdVideoH264PictureParameterSet{len: int(d.video_data.pps_count)}
	mut video_scaling_list_pps := []vk.StdVideoH264ScalingLists{len: int(d.video_data.pps_count)}
	for i in 0 .. int(d.video_data.pps_count) {
		pps_offset := i * int(sizeof(h264.PictureParameterSet))
		pps := unsafe { &h264.PictureParameterSet(&d.video_data.pps_bytes[pps_offset]) }
		video_scaling_list_pps[i] = vk.StdVideoH264ScalingLists{}
		for j in 0 .. pps.pic_scaling_list_present_flag.len {
			video_scaling_list_pps[i].scaling_list_present_mask |= u16(pps.pic_scaling_list_present_flag[j]) << j
		}
		for j in 0 .. pps.use_default_scaling_matrix_4x4_flag.len {
			video_scaling_list_pps[i].use_default_scaling_matrix_mask |= u16(pps.use_default_scaling_matrix_4x4_flag[j]) << j
		}
		mut list_idx := 0
		mut el_idx := 0
		for list_idx < vk.std_video_h264_scaling_list_4x4_num_lists && list_idx < pps.scaling_list_4x4.len {
			for el_idx < vk.std_video_h264_scaling_list_4x4_num_elements && el_idx < pps.scaling_list_4x4[0].len {
				unsafe {
					C.vv_set_h264_scaling_list_4x4(&video_scaling_list_pps[i], u32(list_idx), u32(el_idx), u8(pps.scaling_list_4x4[list_idx][el_idx]))
				}
				el_idx++
			}
			list_idx++
		}
		list_idx = 0
		el_idx = 0
		for list_idx < vk.std_video_h264_scaling_list_8x8_num_lists && list_idx < pps.scaling_list_8x8.len {
			for el_idx < vk.std_video_h264_scaling_list_8x8_num_elements && el_idx < pps.scaling_list_8x8[0].len {
				unsafe {
					C.vv_set_h264_scaling_list_8x8(&video_scaling_list_pps[i], u32(list_idx), u32(el_idx), u8(pps.scaling_list_8x8[list_idx][el_idx]))
				}
				el_idx++
			}
			list_idx++
		}

		video_picture_parameter_sets[i] = vk.StdVideoH264PictureParameterSet{
			flags: vk.StdVideoH264PpsFlags{
				transform_8x8_mode_flag: u32(pps.transform_8x8_mode_flag)
				redundant_pic_cnt_present_flag: pps.redundant_pic_cnt_present_flag
				constrained_intra_pred_flag: pps.constrained_intra_pred_flag
				deblocking_filter_control_present_flag: pps.deblocking_filter_control_present_flag
				weighted_pred_flag: pps.weighted_pred_flag
				bottom_field_pic_order_in_frame_present_flag: pps.pic_order_present_flag
				entropy_coding_mode_flag: pps.entropy_coding_mode_flag
				pic_scaling_matrix_present_flag: pps.pic_scaling_matrix_present_flag
			}
			seq_parameter_set_id: u8(pps.seq_parameter_set_id)
			pic_parameter_set_id: u8(pps.pic_parameter_set_id)
			num_ref_idx_l0_default_active_minus1: u8(pps.num_ref_idx_l0_active_minus1)
			num_ref_idx_l1_default_active_minus1: u8(pps.num_ref_idx_l1_active_minus1)
			weighted_bipred_idc: unsafe { vk.StdVideoH264WeightedBipredIdc(pps.weighted_bipred_idc) }
			pic_init_qp_minus26: i8(pps.pic_init_qp_minus26)
			pic_init_qs_minus26: i8(pps.pic_init_qs_minus26)
			chroma_qp_index_offset: i8(pps.chroma_qp_index_offset)
			second_chroma_qp_index_offset: i8(pps.second_chroma_qp_index_offset)
			pScalingLists: unsafe { &video_scaling_list_pps[i] }
		}
	} // for d.video_data.pps_count

	mut video_sequence_parameter_set := []vk.StdVideoH264SequenceParameterSet{len: int(d.video_data.sps_count)}
	mut video_sequence_parameter_set_vui := []vk.StdVideoH264SequenceParameterSetVui{len: int(d.video_data.sps_count)}
	mut video_scaling_list_sps := []vk.StdVideoH264ScalingLists{len: int(d.video_data.sps_count)}
	mut video_hrd_parameters := []vk.StdVideoH264HrdParameters{len: int(d.video_data.sps_count)}
	get_chroma_format := fn (profile u32, chroma u32) vk.StdVideoH264ChromaFormatIdc {
		if profile < unsafe { int(vk.StdVideoH264ProfileIdc.high) } {
			// If profile is less than HIGH chroma format will not be explicitly given. (A.2)
			// If chroma format is not present, it shall be inferred to be equal to 1 (4:2:0) (7.4.2.1.1)
			return vk.StdVideoH264ChromaFormatIdc._420
		} else {
			// If profile is greater than HIGH, then we assume chroma to be explicitly specified
			return unsafe { vk.StdVideoH264ChromaFormatIdc(chroma) }
		}
	}

	for i in 0 .. int(d.video_data.sps_count) {
		sps_offset := i * int(sizeof(h264.SequenceParameterSet))
		sps := unsafe { &h264.SequenceParameterSet(&d.video_data.sps_bytes[sps_offset]) }

		video_sequence_parameter_set[i] = vk.StdVideoH264SequenceParameterSet{
			flags: vk.StdVideoH264SpsFlags{
				constraint_set0_flag: sps.constraint_set0_flag
				constraint_set1_flag: sps.constraint_set1_flag
				constraint_set2_flag: sps.constraint_set2_flag
				constraint_set3_flag: sps.constraint_set3_flag
				constraint_set4_flag: sps.constraint_set4_flag
				constraint_set5_flag: sps.constraint_set5_flag
				direct_8x8_inference_flag: sps.direct_8x8_inference_flag
				mb_adaptive_frame_field_flag: sps.mb_adaptive_frame_field_flag
				frame_mbs_only_flag: sps.frame_mbs_only_flag
				delta_pic_order_always_zero_flag: sps.delta_pic_order_always_zero_flag
				separate_colour_plane_flag: sps.separate_colour_plane_flag
				gaps_in_frame_num_value_allowed_flag: sps.gaps_in_frame_num_value_allowed_flag
				qpprime_y_zero_transform_bypass_flag: sps.qpprime_y_zero_transform_bypass_flag
				frame_cropping_flag: sps.frame_cropping_flag
				seq_scaling_matrix_present_flag: sps.seq_scaling_matrix_present_flag
				vui_parameters_present_flag: sps.vui_parameters_present_flag
			}
			// Note: There is no 0 in StdVideoH264ProfileIdc enum
			profile_idc: unsafe { vk.StdVideoH264ProfileIdc(sps.profile_idc) }
			level_idc: unsafe { vk.StdVideoH264LevelIdc(sps.level_idc) }
			chroma_format_idc: get_chroma_format(sps.profile_idc, sps.chroma_format_idc)
			seq_parameter_set_id: u8(sps.seq_parameter_set_id)
			bit_depth_luma_minus8: u8(sps.bit_depth_luma_minus8)
			bit_depth_chroma_minus8: u8(sps.bit_depth_chroma_minus8)
			log2_max_frame_num_minus4: u8(sps.log2_max_frame_num_minus4)
			pic_order_cnt_type: unsafe { vk.StdVideoH264PocType(sps.pic_order_cnt_type) }
			offset_for_non_ref_pic: sps.offset_for_non_ref_pic
			log2_max_pic_order_cnt_lsb_minus4: u8(sps.log2_max_pic_order_cnt_lsb_minus4)
			num_ref_frames_in_pic_order_cnt_cycle: u8(sps.num_ref_frames_in_pic_order_cnt_cycle)
			max_num_ref_frames: u8(sps.num_ref_frames)
			reserved1: 0
			pic_width_in_mbs_minus1: sps.pic_width_in_mbs_minus1
			pic_height_in_map_units_minus1: sps.pic_height_in_map_units_minus1
			frame_crop_left_offset: sps.frame_crop_left_offset
			frame_crop_right_offset: sps.frame_crop_right_offset
			frame_crop_top_offset: sps.frame_crop_top_offset
			frame_crop_bottom_offset: sps.frame_crop_bottom_offset
			reserved2: 0
			pOffsetForRefFrame: unsafe { nil }
			pScalingLists: unsafe { &video_scaling_list_sps[i] }
			pSequenceParameterSetVui: unsafe { &video_sequence_parameter_set_vui[i] }
		}

		// VUI stands for "Video Usability Information"
		vui := &sps.vui

		video_sequence_parameter_set_vui[i] = vk.StdVideoH264SequenceParameterSetVui{
			flags: vk.StdVideoH264SpsVuiFlags{
				aspect_ratio_info_present_flag: vui.aspect_ratio_info_present_flag
				overscan_info_present_flag: vui.overscan_info_present_flag
				overscan_appropriate_flag: vui.overscan_appropriate_flag
				video_signal_type_present_flag: vui.video_signal_type_present_flag
				video_full_range_flag: vui.video_full_range_flag
				color_description_present_flag: vui.color_description_present_flag
				chroma_loc_info_present_flag: vui.chroma_loc_info_present_flag
				timing_info_present_flag: vui.timing_info_present_flag
				fixed_frame_rate_flag: vui.fixed_frame_rate_flag
				bitstream_restriction_flag: vui.bitstream_restriction_flag
				nal_hrd_parameters_present_flag: vui.nal_hrd_parameters_present_flag
				vcl_hrd_parameters_present_flag: vui.vcl_hrd_parameters_present_flag
			}
			aspect_ratio_idc: unsafe { vk.StdVideoH264AspectRatioIdc(vui.aspect_ratio_idc) }
			sar_width: u16(vui.sar_width)
			sar_height: u16(vui.sar_height)
			video_format: u8(vui.video_format)
			colour_primaries: u8(vui.colour_primaries)
			transfer_characteristics: u8(vui.transfer_characteristics)
			matrix_coefficients: u8(vui.matrix_coefficients)
			num_units_in_tick: vui.num_units_in_tick
			time_scale: vui.time_scale
			max_num_reorder_frames: u8(vui.num_reorder_frames)
			max_dec_frame_buffering: u8(vui.max_dec_frame_buffering)
			chroma_sample_loc_type_top_field: u8(vui.chroma_sample_loc_type_top_field)
			chroma_sample_loc_type_bottom_field: u8(vui.chroma_sample_loc_type_bottom_field)
			reserved1: 0
			pHrdParameters: unsafe { &video_hrd_parameters[i] }
		}

		hrd := &sps.hrd
		video_hrd_parameters[i] = vk.StdVideoH264HrdParameters{
			cpb_cnt_minus1: u8(hrd.cpb_cnt_minus1)
			bit_rate_scale: u8(hrd.bit_rate_scale)
			cpb_size_scale: u8(hrd.cpb_size_scale)
			// reserved1: u8(0)
			// bit_rate_value_minus1: [u32(0)]
			// cpb_size_value_minus1: [u32(0)]
			// cbr_flag: [u8(0)]
			initial_cpb_removal_delay_length_minus1: hrd.initial_cpb_removal_delay_length_minus1
			cpb_removal_delay_length_minus1: hrd.cpb_removal_delay_length_minus1
			dpb_output_delay_length_minus1: hrd.dpb_output_delay_length_minus1
			time_offset_length: hrd.time_offset_length
		}

		for j in 0 .. vk.std_video_h264_cpb_cnt_list_size {
			video_hrd_parameters[i].bit_rate_value_minus1[j] = hrd.bit_rate_value_minus1[j]
			video_hrd_parameters[i].cpb_size_value_minus1[j] = hrd.cpb_size_value_minus1[j]
			video_hrd_parameters[i].cbr_flag[j] = u8(hrd.cbr_flag[j])
		}

		// Fill scaling lists
		video_scaling_list_sps[i] = vk.StdVideoH264ScalingLists{}
		for j in 0 .. sps.seq_scaling_list_present_flag.len {
			video_scaling_list_sps[i].scaling_list_present_mask |= u16(sps.seq_scaling_list_present_flag[j]) << j
		}
		for j in 0 .. sps.use_default_scaling_matrix_4x4_flag.len {
			video_scaling_list_sps[i].use_default_scaling_matrix_mask |= u16(sps.use_default_scaling_matrix_4x4_flag[j]) << j
		}

		mut list_idx := 0
		mut el_idx := 0
		for list_idx < vk.std_video_h264_scaling_list_4x4_num_lists && list_idx < sps.scaling_list_4x4.len {
			for el_idx < vk.std_video_h264_scaling_list_4x4_num_elements && el_idx < sps.scaling_list_4x4[0].len {
				unsafe {
					C.vv_set_h264_scaling_list_4x4(&video_scaling_list_sps[i], u32(list_idx), u32(el_idx), u8(sps.scaling_list_4x4[list_idx][el_idx]))
				}
				el_idx++
			}
			list_idx++
		}

		list_idx = 0
		el_idx = 0
		for list_idx < vk.std_video_h264_scaling_list_8x8_num_lists && list_idx < sps.scaling_list_8x8.len {
			for el_idx < vk.std_video_h264_scaling_list_8x8_num_elements && el_idx < sps.scaling_list_8x8[0].len {
				unsafe {
					C.vv_set_h264_scaling_list_8x8(&video_scaling_list_sps[i], u32(list_idx), u32(el_idx), u8(sps.scaling_list_8x8[list_idx][el_idx]))
				}
				el_idx++
			}
			list_idx++
		}
	} // for d.video_data.sps_count

	mut session_parameters_add_info := vk.VideoDecodeH264SessionParametersAddInfoKHR{
		stdSPSCount: d.video_data.sps_count
		pStdSPSs: video_sequence_parameter_set.data
		stdPPSCount: d.video_data.pps_count
		pStdPPSs: video_picture_parameter_sets.data
	}
	mut video_decode_session_parameters_ci := vk.VideoDecodeH264SessionParametersCreateInfoKHR{
		maxStdSPSCount: d.video_data.sps_count
		maxStdPPSCount: d.video_data.pps_count
		pParametersAddInfo: &session_parameters_add_info
	}
	video_session_parameters_ci := vk.VideoSessionParametersCreateInfoKHR{
		pNext: &video_decode_session_parameters_ci
		flags: 0
		videoSessionParametersTemplate: unsafe { nil }
		videoSession: d.video_session
	}

	res := vk.create_video_session_parameters_khr(device, &video_session_parameters_ci, unsafe { nil }, &d.video_session_parameters)
	if res != vk.Result.success {
		panic('Could not create H.264 video-session parameters: ${res}')
	}
}

pub struct VKUGPUImage {
pub mut:
	image           vk.Image = unsafe { nil }
	view            vk.ImageView = unsafe { nil }
	allocation      vma.Allocator
	allocation_info vma.AllocationInfo
}

@[heap]
pub struct CallbackUserData {
pub mut:
	file        &os.File
	last_offset i64
	file_size   u64
	read_error  string
}

pub fn read_callback(offset i64, buffer &u8, size usize, user_data voidptr) int {
	mut data := unsafe { &CallbackUserData(user_data) }
	if offset < 0 || offset >= data.file_size {
		return 1
	}
	to_copy := math.min(i64(size), data.file_size - offset)
	data.file.seek(offset, .start) or {
		data.read_error = 'could not seek to MP4 offset ${offset}: ${err}'
		return 1
	}
	num_bytes_read := data.file.read_into_ptr(buffer, int(to_copy)) or {
		data.read_error = 'could not read ${to_copy} bytes at MP4 offset ${offset}: ${err}'
		return 1
	}
	data.last_offset = offset + num_bytes_read
	if num_bytes_read != int(to_copy) {
		data.read_error = 'short read at MP4 offset ${offset}: expected ${to_copy} bytes, read ${num_bytes_read}'
		return 1
	}
	return 0
}

// Turn an EBSP (Encapsulated Byte Sequence Payload) into an RBSP (Raw Byte Sequence Payload)
// pub fn remove_emulation_prevention_bytes(ebsp []u8) []u8 {
//   mut rbsp := []u8{cap: ebsp.len}
//   if ebsp.len == 0 { return rbsp }
//   mut i := 0
//   for i < ebsp.len {
//     if ((i + 2) < ebsp.len)
//     && ebsp[i] == 0
//     && ebsp[i + 1] == 0
//     && ebsp[i + 2] == 3 {
//       rbsp << ebsp[i]
//       rbsp << ebsp[i + 1]
//       i += 2
//     } else {
//       rbsp << ebsp[i]
//     }
//     i++
//   }
//   return rbsp
// }
@[unsafe]
pub fn remove_emulation_prevention_bytes(ebsp byteptr, size int) []u8 {
	mut rbsp := []u8{cap: size}
	if size == 0 {
		return rbsp
	}
	mut i := 0
	for i < size {
		if (i + 2) < size && unsafe { ebsp[i] == 0 && ebsp[i + 1] == 0 && ebsp[i + 2] == 3 } {
			rbsp << unsafe { ebsp[i] }
			rbsp << unsafe { ebsp[i + 1] }
			i += 2
		} else {
			rbsp << unsafe { ebsp[i] }
		}
		i++
	}
	return rbsp
}

pub type BytePtr = byteptr

pub fn (p BytePtr) to_varray[T](len u32) []T {
	if isnil(p) && len > 0 {
		panic('Nil to_varray for len: ${len}')
	}
	if len <= 0 {
		return []T{}
	}
	// TODO: doesn't trigger on to_varray[u8]
	$if T is u8 {
		return p.vbytes(int(len))
	}
	mut ret := []T{cap: int(len)}
	// vmemcpy(ret.data, p, len * sizeof(T))
	for i in 0 .. len {
		ret << *unsafe { &T(p + (i * sizeof(T))) }
	}
	return ret
}

pub fn (mut d Decoder) parse_mp4_data(file_path string) ! {
	d.video_data.file = os.open_file(file_path, 'rb')!
	d.video_data.file_open = true
	d.video_data.file.seek(0, .end)!
	mp4_file_size := d.video_data.file.tell()!
	d.video_data.file.seek(0, .start)!
	mut mp4 := minimp4.MP4D_demux_t{}
	mut user_data := CallbackUserData{
		file: &d.video_data.file
		last_offset: 0
		file_size: os.file_size(file_path)
	}
	if minimp4.mp4d_open(&mp4, read_callback, &user_data, mp4_file_size) != 1 {
		if user_data.read_error != '' {
			return error(user_data.read_error)
		}
		return error('not a readable MP4 file')
	}
	defer {
		minimp4.mp4d_close(&mp4)
	}
	if mp4.track_count == 0 || isnil(mp4.track) {
		return error('MP4 contains no tracks')
	}
	mut ntrack := u32(0)
	mut found_video_track := false
	mut found_unsupported_video_track := false
	for track_index in u32(0) .. mp4.track_count {
		candidate := unsafe { mp4.track[track_index] }
		if candidate.handler_type != minimp4.mp4d_handler_type_vide {
			continue
		}
		if candidate.object_type_indication == minimp4.mp4_object_type_avc {
			ntrack = track_index
			found_video_track = true
			break
		}
		found_unsupported_video_track = true
	}
	if !found_video_track {
		if found_unsupported_video_track {
			return error('MP4 video codec is unsupported; this player currently supports H.264/AVC')
		}
		return error('MP4 contains no H.264/AVC video track')
	}
	track := unsafe { mp4.track[ntrack] }
	if track.sample_count == 0 {
		return error('H.264 video track contains no samples')
	}
	if track.timescale == 0 {
		return error('H.264 video track has an invalid zero timescale')
	}
	d.video_data.metadata.track_matrix = track.track_matrix
	d.video_data.metadata.rotation_degrees = rotation_from_track_matrix(track.track_matrix)

	// Read SPS
	mut num_bytes_sps := 0
	mut count_sps := 0
	mut sps_array := []h264.SequenceParameterSet{}
	mut data_sps := minimp4.mp4d_read_sps(&mp4, ntrack, count_sps, &num_bytes_sps)
	for !isnil(data_sps) {
		mut nal := h264.NetworkAbstractionLayerHeader{}
		mut nal_header_bs := h264.Bitstream{}
		nal_header_bs.init(unsafe { data_sps.vbytes(1) })
		nal.read_nal_header(mut &nal_header_bs)
		if num_bytes_sps <= 1 {
			return error('H.264 track contains an invalid sequence parameter set')
		}
		mut nal_payload_rbsp_data := unsafe {
			remove_emulation_prevention_bytes(byteptr(data_sps) + 1, num_bytes_sps - 1)
		}
		mut nal_payload_bs := h264.Bitstream{}
		nal_payload_bs.init(nal_payload_rbsp_data)
		mut sps := h264.SequenceParameterSet{}
		sps.read_sps(mut nal_payload_bs)
		if sps.profile_idc !in [u32(66), 77, 100] {
			return error('H.264 profile_idc ${sps.profile_idc} is unsupported; supported profiles are Baseline, Main, and High 8-bit 4:2:0')
		}
		if d.video_data.h264_profile_idc == 0 {
			d.video_data.h264_profile_idc = sps.profile_idc
		} else if d.video_data.h264_profile_idc != sps.profile_idc {
			return error('H.264 track changes profile between sequence parameter sets')
		}
		if sps.bit_depth_luma_minus8 != 0 || sps.bit_depth_chroma_minus8 != 0 {
			return error('H.264 bit depths above 8-bit are not supported')
		}
		if sps.profile_idc >= 100 && sps.chroma_format_idc != 1 {
			return error('H.264 chroma formats other than 4:2:0 are not supported')
		}
		if sps.frame_mbs_only_flag == 0 {
			return error('interlaced H.264 video is not currently supported')
		}
		// Data validation
		// https://stackoverflow.com/questions/6394874/fetching-the-dimensions-of-a-h264video-stream
		width := ((sps.pic_width_in_mbs_minus1 + 1) * 16) - (sps.frame_crop_left_offset * 2) - (sps.frame_crop_right_offset * 2)
		height := ((2 - sps.frame_mbs_only_flag) * (sps.pic_height_in_map_units_minus1 + 1) * 16) - (sps.frame_crop_top_offset * 2) - (sps.frame_crop_bottom_offset * 2)
		mp4_width := unsafe { track.sampleDescription.video.width }
		mp4_height := unsafe { track.sampleDescription.video.height }
		if mp4_width != width || mp4_height != height {
			eprintln('Warning: MP4 dimensions ${mp4_width}x${mp4_height} differ from H.264 SPS display dimensions ${width}x${height}')
		}
		d.video_data.width_padd = (sps.pic_width_in_mbs_minus1 + 1) * 16
		d.video_data.height_padd = (sps.pic_height_in_map_units_minus1 + 1) * 16
		if sps.vui_parameters_present_flag != 0 {
			d.video_data.metadata.sar_width, d.video_data.metadata.sar_height = sample_aspect_ratio(sps.vui.aspect_ratio_idc, sps.vui.sar_width, sps.vui.sar_height)
			d.video_data.metadata.video_full_range = sps.vui.video_full_range_flag != 0
			d.video_data.metadata.colour_primaries = u8(sps.vui.colour_primaries)
			d.video_data.metadata.transfer_function = u8(sps.vui.transfer_characteristics)
			d.video_data.metadata.matrix_coefficients = u8(sps.vui.matrix_coefficients)
		}
		// x ^ ((x ^ y) & -(x < y)) // max(x, y)
		// d.video_data.num_dpb_slots = d.video_data.num_dpb_slots ^ ((d.video_data.num_dpb_slots ^ (sps.num_ref_frames * 2 + 1)) & -u32(d.video_data.num_dpb_slots < (sps.num_ref_frames * 2 + 1)))
		d.video_data.num_dpb_slots = math.max[u32](d.video_data.num_dpb_slots, sps.num_ref_frames + 1)
		d.video_data.sps_bytes << unsafe { byteptr(&sps).vbytes(int(sizeof(sps))) }
		sps_array << sps
		d.video_data.sps_count++
		count_sps++

		data_sps = minimp4.mp4d_read_sps(&mp4, ntrack, count_sps, &num_bytes_sps)
	}
	if sps_array.len == 0 {
		return error('H.264 video track contains no sequence parameter set (SPS)')
	}

	// Read PPS
	mut size_pps := 0
	mut count_pps := 0
	mut pps_array := []h264.PictureParameterSet{}
	mut data_pps := minimp4.mp4d_read_pps(&mp4, ntrack, count_pps, &size_pps)

	for !isnil(data_pps) {
		mut nal := h264.NetworkAbstractionLayerHeader{}
		mut nal_header_bs := h264.Bitstream{}
		nal_header_bs.init(unsafe { data_pps.vbytes(1) })
		nal.read_nal_header(mut nal_header_bs)
		if size_pps <= 1 {
			return error('H.264 track contains an invalid picture parameter set')
		}
		pps_payload_rbsp_data := unsafe {
			remove_emulation_prevention_bytes(byteptr(data_pps) + 1, size_pps - 1)
		}
		mut pps_payload_bs := h264.Bitstream{}
		pps_payload_bs.init(pps_payload_rbsp_data)

		mut pps := h264.PictureParameterSet{}
		pps.read_pps(mut pps_payload_bs)
		d.video_data.pps_bytes.ensure_cap(d.video_data.pps_bytes.len + int(sizeof(pps)))
		d.video_data.pps_bytes << unsafe { byteptr(&pps).vbytes(int(sizeof(pps))) }
		pps_array << pps
		d.video_data.pps_count++
		count_pps++

		data_pps = minimp4.mp4d_read_pps(&mp4, ntrack, count_pps, &size_pps)
	}
	if pps_array.len == 0 {
		return error('H.264 video track contains no picture parameter set (PPS)')
	}

	d.video_data.width = unsafe { track.sampleDescription.video.width }
	d.video_data.height = unsafe { track.sampleDescription.video.height }
	d.video_data.metadata.coded_width = d.video_data.width
	d.video_data.metadata.coded_height = d.video_data.height
	d.video_data.metadata.update_display_dimensions()
	println('Video codec: H.264 ${h264_profile_name(d.video_data.h264_profile_idc)} Profile')
	println('Display metadata: coded ${d.video_data.metadata.coded_width}x${d.video_data.metadata.coded_height}, display ${d.video_data.metadata.display_width}x${d.video_data.metadata.display_height}, SAR ${d.video_data.metadata.sar_width}:${d.video_data.metadata.sar_height}, rotation ${d.video_data.metadata.rotation_degrees}°')

	timescale_rcp := 1.0 / f64(track.timescale)
	mut prev_pic_order_cnt_lsb := u32(0)
	mut prev_pic_order_cnt_msb := u32(0)
	mut poc_cycle := -1
	mut prev_frame_num := u32(0)
	mut prev_frame_offset := u32(0)

	// Read frames
	mut track_duration := u32(0)
	mut max_frame_size_bytes := u64(0)
	mut input_file_position := u64(0)
	d.video_data.file.seek(0, .start)!

	d.video_data.frame_infos = []DecoderVideoDataFrameInfo{cap: int(track.sample_count)}
	d.video_data.slice_header_bytes.ensure_cap(int(track.sample_count * sizeof(h264.SliceHeader)))
	d.video_data.slice_header_count = track.sample_count

	mut file := d.video_data.file
	mut sample_index := u32(0)
	for {
		if sample_index >= track.sample_count {
			break
		}
		mut frame_bytes_num_to_do := u32(0)
		mut duration := u32(0)
		mut timestamp := u32(0)
		// minimp4 returns timestamp before duration. These were previously passed
		// in reverse order, causing later frames to use their growing timestamp as
		// a duration and making playback progressively slower.
		offset := minimp4.mp4d_frame_offset(&mp4, ntrack, sample_index, &frame_bytes_num_to_do, &timestamp, &duration)
		// The upload buffer must fit any slice contained in the complete MP4
		// sample, including samples with leading non-slice NAL units.
		max_frame_size_bytes = math.max[u64](max_frame_size_bytes, frame_bytes_num_to_do)
		track_duration += duration

		mut data_frame := DecoderVideoDataFrameInfo{
			src_offset: offset
			frame_bytes_num: frame_bytes_num_to_do
		}

		mut src_buffer := []u8{len: int(frame_bytes_num_to_do)}
		mut src_buffer_idx := 0
		if offset - input_file_position > 0 {
			file.seek(offset - input_file_position, .current) or {
				return error('could not seek to MP4 sample ${sample_index}: ${err}')
			}
		}
		if file.eof() {
			return error('MP4 sample ${sample_index} points beyond the end of the file')
		}
		expected_frame_bytes := frame_bytes_num_to_do
		frame_bytes_num_to_do = u32(file.read(mut src_buffer) or {
			return error('could not read MP4 sample ${sample_index}: ${err}')
		})
		if frame_bytes_num_to_do != expected_frame_bytes {
			return error('MP4 sample ${sample_index} is truncated: expected ${expected_frame_bytes} bytes, read ${frame_bytes_num_to_do}')
		}
		input_file_position = offset + frame_bytes_num_to_do
		for frame_bytes_num_to_do > 0 {
			if frame_bytes_num_to_do < 4 {
				return error('MP4 sample ${sample_index} has a truncated H.264 NAL length')
			}
			// mut size := unsafe{ (u32(*&src_buffer[src_buffer_idx+0]) << 24) | (u32(*&src_buffer[src_buffer_idx+1]) << 16) | (u32(*&src_buffer[src_buffer_idx+2]) << 8) | *&src_buffer[src_buffer_idx+3] }
			mut size := unsafe {
				(u32(src_buffer[src_buffer_idx + 0]) << 24) | (u32(src_buffer[src_buffer_idx + 1]) << 16) | (u32(src_buffer[src_buffer_idx + 2]) << 8) | src_buffer[src_buffer_idx + 3]
			}
			size += 4
			if size < 4 || frame_bytes_num_to_do < size {
				return error('MP4 sample ${sample_index} has an invalid H.264 NAL size ${size - 4}')
			}

			length_prefixed_data_offset := src_buffer_idx + 4
			length_prefixed_data_size := size - 4
			if length_prefixed_data_size <= 1 {
				return error('MP4 sample ${sample_index} contains an empty H.264 NAL unit')
			}

			mut nal := h264.NetworkAbstractionLayerHeader{}
			mut nal_header_bs := h264.Bitstream{}
			nal_header_bs.init(src_buffer[length_prefixed_data_offset..length_prefixed_data_offset + 1])
			nal.read_nal_header(mut nal_header_bs)

			slfrom := length_prefixed_data_offset + 1
			nal_payload_rbsp_data := unsafe {
				remove_emulation_prevention_bytes(byteptr(src_buffer.data) + slfrom, int(length_prefixed_data_size - 1))
			}
			mut nal_payload_bs := h264.Bitstream{}
			nal_payload_bs.init(nal_payload_rbsp_data)

			mut is_idr := false
			match nal.type {
				.coded_slice_idr {
					data_frame.frame_type = DecoderFrameType.e_intra
					is_idr = true
				}
				.coded_slice_non_idr {
					data_frame.frame_type = DecoderFrameType.e_predictive
				}
				else {
					frame_bytes_num_to_do -= size
					src_buffer_idx += int(size)
					continue
				}
			}

			/*
																																																																					      * Decode Picture Order Count
																																																																					      * (tig) see ITU-T H.264 (08/2021) pp.113
																																																																					      *
																																																																					      */
			// tig: see Rec. ITU-T H.264 (08/2021) p.66 (7-1)
			mut slice_header := h264.SliceHeader{}
			slice_header.read_slice_header(&nal, pps_array, sps_array, mut nal_payload_bs)
			if slice_header.pic_parameter_set_id >= u32(pps_array.len) {
				return error('MP4 sample ${sample_index} references missing H.264 PPS ${slice_header.pic_parameter_set_id}')
			}
			pps := pps_array[slice_header.pic_parameter_set_id]
			if pps.seq_parameter_set_id >= u32(sps_array.len) {
				return error('MP4 sample ${sample_index} references missing H.264 SPS ${pps.seq_parameter_set_id}')
			}
			sps := sps_array[pps.seq_parameter_set_id]

			max_frame_num := u32(1) << (sps.log2_max_frame_num_minus4 + 4)
			max_pic_order_cnt_lsb := u32(1) << (sps.log2_max_pic_order_cnt_lsb_minus4 + 4)
			pic_order_cnt_lsb := u32(slice_header.pic_order_cnt_lsb)
			mut pic_order_cnt_msb := u32(0)
			mut frame_num_offset := u32(0)
			mut tmp_pic_order_cout := u32(0)

			match sps.pic_order_cnt_type {
				0 {
					// TYPE 0
					// Rec. ITU-T H.264 (08/2021) page 114
					// Use the NAL unit type, not idr flag
					if is_idr {
						prev_pic_order_cnt_msb = 0
						prev_pic_order_cnt_lsb = 0
						poc_cycle++
					}
					if pic_order_cnt_lsb < prev_pic_order_cnt_lsb && (prev_pic_order_cnt_lsb - pic_order_cnt_lsb) >= max_pic_order_cnt_lsb / 2 {
						pic_order_cnt_msb = prev_pic_order_cnt_msb + max_pic_order_cnt_lsb
					} else if pic_order_cnt_lsb > prev_pic_order_cnt_lsb && (pic_order_cnt_lsb - prev_pic_order_cnt_lsb) > max_pic_order_cnt_lsb / 2 {
						pic_order_cnt_msb = prev_pic_order_cnt_msb - max_pic_order_cnt_lsb
					} else {
						pic_order_cnt_msb = prev_pic_order_cnt_msb
					}
					// Top and bottom field order count in case the picture is a field
					if slice_header.field_pic_flag == 0 || slice_header.bottom_field_flag == 0 {
						data_frame.top_field_order_cnt = pic_order_cnt_msb + pic_order_cnt_lsb
					}
					if slice_header.field_pic_flag == 0 {
						data_frame.bottom_field_order_cnt = data_frame.top_field_order_cnt + u32(slice_header.delta_pic_order_cnt_bottom)
					} else if slice_header.bottom_field_flag != 0 {
						data_frame.bottom_field_order_cnt = pic_order_cnt_msb + slice_header.pic_order_cnt_lsb
					}

					// Same as top field order count
					data_frame.poc = int(pic_order_cnt_msb + pic_order_cnt_lsb)
					data_frame.gop = poc_cycle

					// TODO: memory_management_control_operation equal to 5
					if nal.idc != h264.NAL_REF_IDC.priority_disposable {
						prev_pic_order_cnt_msb = pic_order_cnt_msb
						prev_pic_order_cnt_lsb = pic_order_cnt_lsb
					}
				}

				// match 0
				2 {
					if is_idr {
						frame_num_offset = 0
					} else if prev_frame_num > slice_header.frame_num {
						frame_num_offset = prev_frame_offset + max_frame_num
					} else {
						frame_num_offset = prev_frame_offset
					}
					prev_frame_offset = frame_num_offset
					prev_frame_num = slice_header.frame_num

					if is_idr {
						tmp_pic_order_cout = 0
					} else if nal.idc == h264.NAL_REF_IDC.priority_disposable {
						tmp_pic_order_cout = 2 * (frame_num_offset + slice_header.frame_num) - 1
					} else {
						tmp_pic_order_cout = 2 * (frame_num_offset + slice_header.frame_num)
					}

					// (tig) Ignore bottom or top fields, as we assume progressive.
					// If it were otherwise - for interleaved - either the top or the bottom
					// field shall be set, depending on whether the current picture is the
					// top or bottom field, as indicated by bottom_field_flag
					data_frame.poc = int(tmp_pic_order_cout)
					if tmp_pic_order_cout == 0 {
						poc_cycle++
					}
					data_frame.gop = poc_cycle
				}

				// match 2
				else {
					return error('H.264 picture-order-count type ${sps.pic_order_cnt_type} is not supported')
				}
			} // match

			// Accept frame beginning NAL unit
			data_frame.nal_ref_idc = u32(nal.idc)
			data_frame.nal_unit_type = u8(nal.type)
			// TODO: h264.nal_start_code as pub const. error, imported types must start with a capital letter, but const can't be upper case
			// data_frame.size = sizeof(h264.nal_start_code) + size - 4
			nal_start_code := h264.NalStartCode{}.value
			data_frame.size = u64(nal_start_code.len) + size - 4
			data_frame.reference_priority = u32(nal.idc)

			data_frame.decode_time_ns = i64(f64(timestamp) * timescale_rcp * 1_000_000_000.0)
			data_frame.display_time_ns = i64(f64(timestamp) * timescale_rcp * 1_000_000_000.0)
			data_frame.duration_ns = math.max[i64](1, i64(f64(duration) * timescale_rcp * 1_000_000_000.0))
			d.video_data.slice_header_bytes << unsafe {
				byteptr(&slice_header).vbytes(int(sizeof(slice_header)))
			}

			// for frame_bytes_num_to_do > 0
			break
		}

		// x ^ ((x ^ y) & -(x < y)) // max(x, y)
		// max_frame_size_bytes = max_frame_size_bytes ^ ((max_frame_size_bytes ^ data_frame.size) & -(u64(max_frame_size_bytes < data_frame.size)))
		max_frame_size_bytes = math.max[u64](max_frame_size_bytes, data_frame.size)

		d.video_data.frame_infos << data_frame
		sample_index++
	} // for sample_index < track.sample_count

	// Fills array values with their index 0..len
	d.video_data.frame_display_order = []u64{len: d.video_data.frame_infos.len, init: index}

	// Keep frame_infos in MP4 decode order. Only the display-order index list is
	// sorted; slice_header_bytes and current_frame use the original decode order.
	for i in 1 .. d.video_data.frame_display_order.len {
		index_to_insert := d.video_data.frame_display_order[i]
		frame_to_insert := d.video_data.frame_infos[index_to_insert]
		mut j := i
		for j > 0 {
			previous_index := d.video_data.frame_display_order[j - 1]
			if compare_frame_display_order(&d.video_data.frame_infos[previous_index], &frame_to_insert) <= 0 {
				break
			}
			d.video_data.frame_display_order[j] = previous_index
			j--
		}
		d.video_data.frame_display_order[j] = index_to_insert
	}

	for i in 0 .. d.video_data.frame_display_order.len {
		d.video_data.frame_infos[d.video_data.frame_display_order[i]].display_order = i
	}

	d.video_data.max_memory_frame_size_bytes = max_frame_size_bytes
	d.video_data.total_duration = i64(f64(track_duration) * timescale_rcp * 1_000_000_000.0)
}

pub type U64 = u64

pub fn (sz U64) align_to(alignment usize) u64 {
	return ((sz - 1) / alignment + 1) * alignment
}

pub fn (mut vp VideoPlayer) update(graphics_cmd_buffer vk.CommandBuffer, time_elapsed_ns i64) {
	vp.decode_operation = DecoderVideoDecodeOperation{}

	if vp.is_stopped {
		vp.dpb_slot_used = []int{len: int(vp.decoder.video_data.max_reference_pictures), init: 0}
		return
	}
	// The output image contains the last decoded frame. Hold it according to the
	// MP4 time base before submitting the next decode.
	if !vp.playback_timeline.decode_is_due(time_elapsed_ns) {
		return
	}
	if max_texture_count <= vp.output_textures_used.len {
		println('Skipped decoding for a frame')
		return
	}
	if !vp.is_prepared && slot_count <= vp.output_textures_used.len {
		// Once a minimum amount of data has been collected, the preparation is considered complete
		vp.is_prepared = true
	}

	vp.update_decode_video() or {
		eprintln('Playback stopped: ${err}')
		vp.is_stopped = true
		return
	}

	vk.cmd_wait_events(graphics_cmd_buffer, 1, &vp.event_video_player, vk.pipeline_stage_2_all_commands_bit, vk.pipeline_stage_2_all_commands_bit, 0, unsafe { nil }, 0, unsafe { nil }, 0, unsafe { nil })
	vk.cmd_reset_event(graphics_cmd_buffer, vp.event_video_player, vk.pipeline_stage_2_bottom_of_pipe_bit)

	// Finish recording the command buffer and submit
	dev_ctx := vp.app.device_context
	index_cur_swapchain := dev_ctx.swapchain.get_current_index()
	command_buffer_info := vp.command_buffer_infos[index_cur_swapchain]
	vk.end_command_buffer(command_buffer_info.graphics_command_buffer)

	mut semaphore := command_buffer_info.sem_video_to_gfx
	mut wait_stage := vk.PipelineStageFlags(vk.PipelineStageFlagBits.top_of_pipe)
	mut sumbit_info_video := vk.SubmitInfo{
		waitSemaphoreCount: 0
		pWaitSemaphores: unsafe { nil }
		pWaitDstStageMask: &wait_stage
		commandBufferCount: 1
		pCommandBuffers: &command_buffer_info.video_command_buffer
		signalSemaphoreCount: 1
		pSignalSemaphores: &semaphore
	}
	upload_fence := vp.video_frames[vp.current_upload_index].in_flight_fence
	res_video := vk.queue_submit(dev_ctx.get_queue(.video_decode), 1, &sumbit_info_video, upload_fence)
	check_vk(res_video, 'Could not submit Vulkan Video decode command')

	mut sumbit_info_graphics := vk.SubmitInfo{
		waitSemaphoreCount: 1
		pWaitSemaphores: &semaphore
		pWaitDstStageMask: &wait_stage
		commandBufferCount: 1
		pCommandBuffers: &command_buffer_info.graphics_command_buffer
	}
	res_graphics := vk.queue_submit(dev_ctx.get_queue(.graphics), 1, &sumbit_info_graphics, unsafe { nil })
	check_vk(res_graphics, 'Could not submit decoded frame for graphics use')
}

pub fn (mut vp VideoPlayer) update_decode_video() ! {
	dev_ctx := vp.app.device_context
	command_buffer_info := vp.command_buffer_infos[dev_ctx.swapchain.get_current_index()]
	mut begin_command_buffer := vk.CommandBufferBeginInfo{}
	vk.reset_command_buffer(command_buffer_info.graphics_command_buffer, 0)
	vk.begin_command_buffer(command_buffer_info.graphics_command_buffer, &begin_command_buffer)
	if vp.is_stopped {
		vk.cmd_set_event(command_buffer_info.graphics_command_buffer, vp.event_video_player, vk.pipeline_stage_2_all_commands_bit)
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
			&h264.SliceHeader(byteptr(usize(vp.decoder.get_slice_header()) + usize(vp.current_frame) * sizeof(h264.SliceHeader)))
		}
		pps = unsafe {
			&h264.PictureParameterSet(byteptr(usize(vp.decoder.get_pps()) + usize(slice_header.pic_parameter_set_id) * sizeof(h264.PictureParameterSet)))
		}
		sps = unsafe {
			&h264.SequenceParameterSet(byteptr(usize(vp.decoder.get_sps()) + usize(pps.seq_parameter_set_id) * sizeof(h264.SequenceParameterSet)))
		}
	}

	mut decode_ope := DecoderVideoDecodeOperation{}
	if vp.current_frame == 0 || has_flag[VideoPlayerFlags](vp.flags, VideoPlayerFlags.e_decoder_reset) {
		decode_ope.flags = u32(DecoderVideoDecodeOperationFlags.e_session_reset)
		vp.flags &= ~u32(VideoPlayerFlags.e_decoder_reset)
	}

	// An ordinary I-picture can occur in an open GOP and may still depend on the
	// existing DPB for pictures decoded after it. Only IDR starts a new reference
	// picture sequence here.
	if frame_info.nal_unit_type == u8(h264.NAL_UNIT_TYPE.coded_slice_idr) {
		vp.dpb.reference_usage.clear()
	}

	dpb_slot_num := int(vp.decoder.video_data.num_dpb_slots)
	vp.dpb.current_slot = vp.dpb.acquire_decode_slot(dpb_slot_num)
	vp.dpb.poc_status[vp.dpb.current_slot] = int(frame_info.poc)
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
	res_reset := vk.reset_fences(dev_ctx.vk_device, 1, &upload_fence)
	check_vk(res_reset, 'Could not reset decoded-frame fence')
	vp.video_frames[use_frame_index].gpu_bitstream_size = 0
	vp.video_frames[use_frame_index].slice_offsets.clear()
	mut use_frame := &vp.video_frames[use_frame_index]
	vp.write_video_frame(mut use_frame)!
	if use_frame.gpu_bitstream_size == 0 {
		// MP4 samples may contain only metadata/non-slice NAL units. They do not
		// form a Vulkan decode operation and must not be submitted with range 0.
		vk.end_command_buffer(video_command_buffer)
		vp.current_frame = (vp.current_frame + 1) % vp.decoder.video_data.frame_infos.len
		vk.cmd_set_event(command_buffer_info.graphics_command_buffer, vp.event_video_player, vk.pipeline_stage_2_all_commands_bit)
		return
	}

	decode_ope.stream_offset = use_frame.gpu_bitstream_offset
	decode_ope.stream_size = use_frame.gpu_bitstream_size
	decode_ope.poc[0] = frame_info.poc
	decode_ope.poc[1] = frame_info.poc
	decode_ope.frame_type = frame_info.frame_type
	decode_ope.reference_priority = frame_info.reference_priority
	decode_ope.decoded_frame_index = vp.current_frame
	decode_ope.slice_header = slice_header
	decode_ope.pps = pps
	decode_ope.sps = sps
	decode_ope.current_dpb = vp.dpb.current_slot
	decode_ope.dpb_reference_count = u32(vp.dpb.reference_usage.len)
	decode_ope.dpb_reference_slots = vp.dpb.reference_usage.data
	// Pointer to data of fixed size array
	decode_ope.dpb_poc = &vp.dpb.poc_status[0]
	decode_ope.dpb_frame_num = &vp.dpb.frame_num_status[0]

	decode_ope.dpb_slot_num = u32(dpb_slot_num)
	decode_ope.p_dpbs = dpbs.data
	decode_ope.p_dpb_views = dpb_views.data
	decode_ope.slice_count = u32(use_frame.slice_offsets.len)
	decode_ope.slice_offsets = use_frame.slice_offsets.data

	// Copy for display
	vp.decode_operation = decode_ope

	vp.video_decode_pre_barrier(video_command_buffer)
	vp.video_decode_core(&decode_ope, video_command_buffer)
	vp.copy_decoded_frame_to_output(video_command_buffer)

	if frame_info.reference_priority > 0 {
		vp.dpb.reference_usage << vp.dpb.current_slot
		for vp.dpb.reference_usage.len > int(vp.decoder.video_data.max_reference_pictures) {
			vp.dpb.reference_usage.delete(0)
		}
	}
	vp.playback_timeline.frame_decoded(frame_info.duration_ns)
	vk.end_command_buffer(video_command_buffer)
	mut frame_count := 0
	rlock vp.decoder {
		frame_count = vp.decoder.video_data.frame_infos.len
	}
	advance := advance_decoded_frame(vp.current_frame, frame_count, vp.is_looping)
	vp.current_frame = advance.next_frame
	vp.is_stopped = advance.stopped
	if advance.decoder_reset {
		// Hold the final frame for its normal duration. The next scheduled update
		// begins again at the first access unit with fresh codec state.
		vp.dpb.reference_usage.clear()
		vp.flags |= u32(VideoPlayerFlags.e_decoder_reset)
	}

	// The graphics command buffer waits on the decode semaphore before this
	// transition, making the copied output safe for fragment sampling.
	output_barrier := vk.ImageMemoryBarrier2{
		srcStageMask: vk.pipeline_stage_2_transfer_bit
		srcAccessMask: vk.access_2_transfer_write_bit
		dstStageMask: vk.pipeline_stage_2_fragment_shader_bit
		dstAccessMask: vk.access_2_shader_read_bit
		oldLayout: .transfer_dst_optimal
		newLayout: .shader_read_only_optimal
		image: vp.output_image.image
		subresourceRange: vk.ImageSubresourceRange{
			aspectMask: vk.ImageAspectFlags(vk.ImageAspectFlagBits.color)
			levelCount: 1
			layerCount: 1
		}
	}
	output_dependency := vk.DependencyInfo{
		imageMemoryBarrierCount: 1
		pImageMemoryBarriers: &output_barrier
	}
	vk.cmd_pipeline_barrier2(command_buffer_info.graphics_command_buffer, &output_dependency)
	vp.output_image_layout = .shader_read_only_optimal

	// Signal the application command buffer after the decode queue completes.
	vk.cmd_set_event(command_buffer_info.graphics_command_buffer, vp.event_video_player, vk.pipeline_stage_2_all_commands_bit)
}

fn (mut vp VideoPlayer) copy_decoded_frame_to_output(command_buffer vk.CommandBuffer) {
	decode_family := vp.app.device_context.get_decoder_queue_family_index()
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
			srcStageMask: vk.pipeline_stage_2_video_decode_bit_khr
			srcAccessMask: source_state.flag
			dstStageMask: vk.pipeline_stage_2_transfer_bit
			dstAccessMask: vk.access_2_transfer_read_bit
			oldLayout: source_state.layout
			newLayout: .transfer_src_optimal
			srcQueueFamilyIndex: decode_family
			dstQueueFamilyIndex: decode_family
			image: source_image
			subresourceRange: vk.ImageSubresourceRange{
				aspectMask: vk.ImageAspectFlags(vk.ImageAspectFlagBits.color)
				levelCount: 1
				layerCount: 1
			}
		},
		vk.ImageMemoryBarrier2{
			srcStageMask: vk.pipeline_stage_2_transfer_bit
			dstStageMask: vk.pipeline_stage_2_transfer_bit
			dstAccessMask: vk.access_2_transfer_write_bit
			oldLayout: if vp.output_image_is_new {
				vk.ImageLayout.undefined} else {
				vp.output_image_layout}
			newLayout: .transfer_dst_optimal
			srcQueueFamilyIndex: decode_family
			dstQueueFamilyIndex: decode_family
			image: vp.output_image.image
			subresourceRange: vk.ImageSubresourceRange{
				aspectMask: vk.ImageAspectFlags(vk.ImageAspectFlagBits.color)
				levelCount: 1
				layerCount: 1
			}
		},
	]
	dependency := vk.DependencyInfo{
		imageMemoryBarrierCount: u32(barriers.len)
		pImageMemoryBarriers: barriers.data
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
			extent: vk.Extent3D{
				width: vp.decoder.video_data.width
				height: vp.decoder.video_data.height
				depth: 1
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
			extent: vk.Extent3D{
				width: vp.decoder.video_data.width / 2
				height: vp.decoder.video_data.height / 2
				depth: 1
			}
		},
	]
	copy_info := vk.CopyImageInfo2{
		srcImage: source_image
		srcImageLayout: .transfer_src_optimal
		dstImage: vp.output_image.image
		dstImageLayout: .transfer_dst_optimal
		regionCount: u32(regions.len)
		pRegions: regions.data
	}
	vk.cmd_copy_image2(command_buffer, &copy_info)
	vp.output_image_layout = .transfer_dst_optimal
	vp.output_image_is_new = false

	post_barrier := vk.ImageMemoryBarrier2{
		srcStageMask: vk.pipeline_stage_2_transfer_bit
		srcAccessMask: vk.access_2_transfer_read_bit
		dstStageMask: vk.pipeline_stage_2_video_decode_bit_khr
		dstAccessMask: vk.access_2_video_decode_read_bit_khr
		oldLayout: .transfer_src_optimal
		newLayout: source_restore_layout
		srcQueueFamilyIndex: decode_family
		dstQueueFamilyIndex: decode_family
		image: source_image
		subresourceRange: vk.ImageSubresourceRange{
			aspectMask: vk.ImageAspectFlags(vk.ImageAspectFlagBits.color)
			levelCount: 1
			layerCount: 1
		}
	}
	mut post_barriers := [post_barrier]
	if !coincide {
		post_barriers << vk.ImageMemoryBarrier2{
			srcStageMask: vk.pipeline_stage_2_video_decode_bit_khr
			srcAccessMask: vk.access_2_video_decode_write_bit_khr
			dstStageMask: vk.pipeline_stage_2_video_decode_bit_khr
			dstAccessMask: vk.access_2_video_decode_read_bit_khr
			oldLayout: .video_decode_dpb_khr
			newLayout: .video_decode_dpb_khr
			srcQueueFamilyIndex: decode_family
			dstQueueFamilyIndex: decode_family
			image: vp.dpb.image[vp.dpb.current_slot].image
			subresourceRange: vk.ImageSubresourceRange{
				aspectMask: vk.ImageAspectFlags(vk.ImageAspectFlagBits.color)
				levelCount: 1
				layerCount: 1
			}
		}
	}
	post_dependency := vk.DependencyInfo{
		imageMemoryBarrierCount: u32(post_barriers.len)
		pImageMemoryBarriers: post_barriers.data
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

pub fn (mut vp VideoPlayer) video_decode_pre_barrier(video_command_buffer vk.CommandBuffer) {
	mut image_barriers := []vk.ImageMemoryBarrier2{}
	decode_family := vp.app.device_context.get_decoder_queue_family_index()
	mut current_state := &vp.dpb.resource_state[vp.dpb.current_slot]
	if current_state.layout != .video_decode_dpb_khr || current_state.flag != vk.access_2_video_decode_write_bit_khr {
		barrier := vk.ImageMemoryBarrier2{
			srcStageMask: vk.pipeline_stage_2_video_decode_bit_khr
			srcAccessMask: current_state.flag
			dstStageMask: vk.pipeline_stage_2_video_decode_bit_khr
			dstAccessMask: vk.access_2_video_decode_write_bit_khr
			oldLayout: current_state.layout
			newLayout: .video_decode_dpb_khr
			srcQueueFamilyIndex: decode_family
			dstQueueFamilyIndex: decode_family
			image: vp.dpb.image[vp.dpb.current_slot].image
			subresourceRange: vk.ImageSubresourceRange{
				aspectMask: vk.ImageAspectFlags(vk.ImageAspectFlagBits.color)
				baseMipLevel: 0
				levelCount: 1
				baseArrayLayer: 0
				layerCount: 1
			}
		}
		image_barriers << barrier
		current_state.layout = barrier.newLayout
		current_state.flag = barrier.dstAccessMask
	}
	if !vp.decoder.properties.dpb_and_output_coincide && (vp.decode_output_state.layout != .video_decode_dst_khr || vp.decode_output_state.flag != vk.access_2_video_decode_write_bit_khr) {
		output_barrier := vk.ImageMemoryBarrier2{
			srcStageMask: vk.pipeline_stage_2_all_commands_bit
			srcAccessMask: vp.decode_output_state.flag
			dstStageMask: vk.pipeline_stage_2_video_decode_bit_khr
			dstAccessMask: vk.access_2_video_decode_write_bit_khr
			oldLayout: vp.decode_output_state.layout
			newLayout: .video_decode_dst_khr
			srcQueueFamilyIndex: decode_family
			dstQueueFamilyIndex: decode_family
			image: vp.decode_output_image.image
			subresourceRange: vk.ImageSubresourceRange{
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
		if ref_state.layout != .video_decode_dpb_khr || ref_state.flag != vk.access_2_video_decode_read_bit_khr {
			barrier := vk.ImageMemoryBarrier2{
				srcStageMask: vk.pipeline_stage_2_video_decode_bit_khr
				srcAccessMask: ref_state.flag
				dstStageMask: vk.pipeline_stage_2_video_decode_bit_khr
				dstAccessMask: vk.access_2_video_decode_read_bit_khr
				oldLayout: ref_state.layout
				newLayout: .video_decode_dpb_khr
				srcQueueFamilyIndex: decode_family
				dstQueueFamilyIndex: decode_family
				image: vp.dpb.image[ref_index].image
				subresourceRange: vk.ImageSubresourceRange{
					aspectMask: vk.ImageAspectFlags(vk.ImageAspectFlagBits.color)
					baseMipLevel: 0
					levelCount: 1
					baseArrayLayer: 0
					layerCount: 1
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
			pImageMemoryBarriers: image_barriers.data
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
		frame_num: u16(slice_header.frame_num)
		idr_pic_id: u16(slice_header.idr_pic_id)
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
			codedExtent: vk.Extent2D{
				width: vp.decoder.video_data.width
				height: vp.decoder.video_data.height
			}
			baseArrayLayer: 0
			imageViewBinding: vp.dpb.image[i].view
		}
		C.vv_set_h264_reference_info(&reference_infos[i], u16(unsafe { operation.dpb_frame_num[i] }), unsafe { operation.dpb_poc[i] }, unsafe { operation.dpb_poc[i] })
		h264_slots[i] = vk.VideoDecodeH264DpbSlotInfoKHR{
			pStdReferenceInfo: unsafe { &reference_infos[i] }
		}
		slot_infos[i] = vk.VideoReferenceSlotInfoKHR{
			pNext: unsafe { &h264_slots[i] }
			slotIndex: i
			pPictureResource: unsafe { &pictures[i] }
		}
	}

	mut active_slots := [slot_count]vk.VideoReferenceSlotInfoKHR{}
	for i in 0 .. int(operation.dpb_reference_count) {
		ref_slot := unsafe { operation.dpb_reference_slots[i] }
		active_slots[i] = slot_infos[ref_slot]
	}
	active_slots[operation.dpb_reference_count] = slot_infos[operation.current_dpb]
	active_slots[operation.dpb_reference_count].slotIndex = -1
	begin_info := vk.VideoBeginCodingInfoKHR{
		videoSession: vp.decoder.video_session
		videoSessionParameters: vp.decoder.video_session_parameters
		referenceSlotCount: operation.dpb_reference_count + 1
		pReferenceSlots: unsafe { &active_slots[0] }
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
		sliceCount: operation.slice_count
		pSliceOffsets: operation.slice_offsets
	}
	dst_picture := if vp.decoder.properties.dpb_and_output_coincide {
		pictures[operation.current_dpb]
	} else {
		vk.VideoPictureResourceInfoKHR{
			codedExtent: vk.Extent2D{
				width: vp.decoder.video_data.width
				height: vp.decoder.video_data.height
			}
			baseArrayLayer: 0
			imageViewBinding: vp.decode_output_image.view
		}
	}
	mut decode_info := vk.VideoDecodeInfoKHR{
		pNext: &h264_picture
		srcBuffer: vp.decoder.gpu_bitstream_buffer
		srcBufferOffset: operation.stream_offset
		srcBufferRange: operation.stream_size
		dstPictureResource: dst_picture
		pSetupReferenceSlot: unsafe { &slot_infos[operation.current_dpb] }
		referenceSlotCount: operation.dpb_reference_count
		pReferenceSlots: if operation.dpb_reference_count == 0 {
			unsafe { nil }
		} else {
			unsafe { &active_slots[0] }
		}
	}
	vk.cmd_decode_video_khr(command_buffer, &decode_info)
	end_info := vk.VideoEndCodingInfoKHR{}
	vk.cmd_end_video_coding_khr(command_buffer, &end_info)
}

pub fn (mut vp VideoPlayer) write_video_frame(mut frame VideoPlayerDecodeStreamFrame) ! {
	data_frame := vp.decoder.video_data.frame_infos[vp.current_frame]
	mut frame_bytes_num_to_do := data_frame.frame_bytes_num
	lock vp.decoder {
		vp.decoder.video_data.file.seek(data_frame.src_offset, .start) or {
			return error('could not seek to MP4 frame ${vp.current_frame}: ${err}')
		}
	}
	for frame_bytes_num_to_do > 0 {
		if frame_bytes_num_to_do < 4 {
			return error('MP4 frame ${vp.current_frame} has a truncated H.264 NAL length')
		}
		mut src_buffer := []u8{len: 4}
		mut length_bytes_read := 0
		lock vp.decoder {
			length_bytes_read = vp.decoder.video_data.file.read(mut src_buffer) or {
				return error('could not read H.264 NAL length in MP4 frame ${vp.current_frame}: ${err}')
			}
		}
		if length_bytes_read != src_buffer.len {
			return error('short read of H.264 NAL length in MP4 frame ${vp.current_frame}: expected 4 bytes, read ${length_bytes_read}')
		}
		mut size := u32(src_buffer[0]) << 24 | u32(src_buffer[1]) << 16 | u32(src_buffer[2]) << 8 | src_buffer[3]
		size += 4
		if size < 4 || frame_bytes_num_to_do < size {
			return error('MP4 frame ${vp.current_frame} has an invalid H.264 NAL size ${size - 4}')
		}
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
		if nal.type != h264.NAL_UNIT_TYPE.coded_slice_idr && nal.type != h264.NAL_UNIT_TYPE.coded_slice_non_idr {
			frame_bytes_num_to_do -= size
			lock vp.decoder {
				vp.decoder.video_data.file.seek(size - 4, .current) or {
					return error('could not skip non-slice NAL in MP4 frame ${vp.current_frame}: ${err}')
				}
			}
			continue
		}

		if frame.gpu_bitstream_size + size <= frame.gpu_bitstream_capacity {
			nal_start_code := h264.NalStartCode{}.value
			frame.slice_offsets << u32(frame.gpu_bitstream_size)
			dst_buffer := unsafe {
				frame.gpu_bitstream_slice_mapped_memory_address + frame.gpu_bitstream_size
			}
			lock vp.decoder {
				unsafe { vmemcpy(dst_buffer, nal_start_code.data, nal_start_code.len) }
				bytes_read := vp.decoder.video_data.file.read_into_ptr(unsafe {
					dst_buffer + nal_start_code.len
				}, int(size - 4)) or {
					return error('could not read H.264 NAL payload in MP4 frame ${vp.current_frame}: ${err}')
				}
				if bytes_read != int(size - 4) {
					return error('short read of H.264 NAL payload in MP4 frame ${vp.current_frame}: expected ${size - 4} bytes, read ${bytes_read}')
				}
			}
			frame.gpu_bitstream_size += u64(nal_start_code.len) + size - 4
		} else {
			return error('encoded access unit ${vp.current_frame} requires more than its ${frame.gpu_bitstream_capacity}-byte aligned bitstream-buffer capacity (written=${frame.gpu_bitstream_size}, next_nal=${size})')
		}
		frame_bytes_num_to_do -= size
	}
	lock vp.decoder {
		aligned_size := U64(frame.gpu_bitstream_size).align_to(vp.decoder.properties.caps.minBitstreamBufferSizeAlignment)
		if aligned_size > frame.gpu_bitstream_capacity {
			return error('aligned access unit ${vp.current_frame} exceeds its ${frame.gpu_bitstream_capacity}-byte bitstream-buffer capacity')
		}
		if aligned_size > frame.gpu_bitstream_size {
			unsafe {
				vmemset(frame.gpu_bitstream_slice_mapped_memory_address + frame.gpu_bitstream_size, 0, isize(aligned_size - frame.gpu_bitstream_size))
			}
		}
		frame.gpu_bitstream_size = aligned_size
	}
}

pub type File = os.File

// Return next byte in file, but don't move the cursor position
pub fn (mut f File) peek() !u8 {
	pos_bk := f.tell()!
	mut ret := []u8{len: 1}
	bytes_read := f.read(mut ret)!
	f.seek(pos_bk, .start)!
	if bytes_read != 1 {
		return error('unexpected end of file while reading H.264 NAL header')
	}
	return ret[0]
}

pub fn has_flag[T](lhs u32, rhs T) bool {
	return (lhs & u32(rhs)) == u32(rhs)
}

// Find next frame
pub fn (mut vp VideoPlayer) update_display_frame(time_elapsed i64) {
	if !vp.is_prepared || vp.is_stopped {
		return
	}

	mut frame_next, index_frame := vp.find_video_frame(vp.video_cursor.index_play)
	assert frame_next != vp.output_textures_used.last()

	// Process elapsed time
	frame_next.duration -= time_elapsed
	if frame_next.duration > 0 {
		vp.video_cursor.index_frame = index_frame
		return
	}

	// Fractional amounts are handled on the frame after
	time_remaining := math.abs(frame_next.duration)

	vp.video_cursor.index_play++
	if vp.decoder.video_data.frame_infos.len <= vp.video_cursor.index_play {
		// Not at the end yet
		vp.video_cursor.index_play = vp.decoder.video_data.frame_infos.len - 1
		vp.is_stopped = true
	} else {
		// Cleanup mark frames as unused
		vp.output_textures_free << frame_next
		vp.output_textures_used.delete(index_frame)
	}
	// TODO: Remove if not needed
	frame_next, _ = vp.find_video_frame(vp.video_cursor.index_play)
	assert frame_next != vp.output_textures_used.last()
	frame_next.duration -= time_remaining
	vp.video_cursor.index_frame = index_frame
}

@[direct_array_access]
pub fn (arr []OutputImage) find_display_order(display_order int) ?OutputImage {
	for a in arr {
		if a.display_order == display_order {
			return a
		}
	}
	return none
}

// Find frame and its index in vp.output_textures_used
fn (mut vp VideoPlayer) find_video_frame(index_play int) (OutputImage, int) {
	mut frame_ret := vp.output_textures_used.find_display_order(index_play) or {
		println('Could not find frame for index ${index_play}')
		OutputImage{}
	}

	mut index_frame := -1
	if frame_ret == vp.output_textures_used.last() {
		// Find closest
		mut index_abs := max_int
		mut i := 0
		for frame in vp.output_textures_used {
			diff := math.abs(frame.display_order - vp.video_cursor.index_play)
			if diff < index_abs {
				index_frame = i
				index_abs = diff
			}
			i++
		}
		assert index_frame != -1
		frame_ret = vp.output_textures_used[index_frame]
	}
	return frame_ret, index_frame
}

pub fn (mut vp VideoPlayer) get_video_texture() OutputImage {
	return vp.output_textures_used[vp.video_cursor.index_frame]
}

pub fn (d Decoder) get_slice_header() byteptr {
	return d.video_data.slice_header_bytes.data
}

pub fn (d Decoder) get_pps() byteptr {
	return d.video_data.pps_bytes.data
}

pub fn (d Decoder) get_sps() byteptr {
	return d.video_data.sps_bytes.data
}
