module video_decode_app

import vulkan as vk
import vulkan_memory_allocator as vma
import glfw
import math

// import bindings.volk

// #flag linux -I$env('VULKAN_SDK')/include
// #flag windows -I$env('VULKAN_SDK')/Include
// #flag windows -I$env('VULKAN_SDK')/Include/Volk

// #flag -DVOLK_IMPLEMENTATION
// #include "volk.h"
pub struct DeviceContext {
mut:
	vk_debug_utils               vk.DebugUtilsMessengerEXT = unsafe { nil }
	use_gpu_index                int
	gpus                         []vk.PhysicalDevice
	queue_families               []QueueFamilyProperties
	queue_family_indices         []u32
	video_decode_family          u32 = vk.queue_family_ignored
	graphics_queue               vk.Queue = unsafe { nil }
	video_decode_queue           vk.Queue = unsafe { nil }
	physical_device_memory_props []vk.PhysicalDeviceMemoryProperties2
	features2                    vk.PhysicalDeviceFeatures2 = vk.PhysicalDeviceFeatures2{}
	vulkan12_features            vk.PhysicalDeviceVulkan12Features = vk.PhysicalDeviceVulkan12Features{}
	vulkan13_features            vk.PhysicalDeviceVulkan13Features = vk.PhysicalDeviceVulkan13Features{}
	video_profile_info           vk.VideoProfileInfoKHR
	video_decode_h264            VideoDecodeH264
	video_capabilities           vk.VideoCapabilitiesKHR = vk.VideoCapabilitiesKHR{}
	video_decode_capabilities    vk.VideoDecodeCapabilitiesKHR
pub mut:
	vk_instance                      vk.Instance = unsafe { nil }
	vk_device                        vk.Device = unsafe { nil }
	swapchain                        Swapchain // @[required]
	sampler                          vk.Sampler = unsafe { nil }
	vma_allocator                    vma.Allocator
	sampler_ycbcr_conversion         vk.SamplerYcbcrConversion
	video_decode_bitstream_alignment vk.DeviceSize = 1
	graphics_family                  u32 = vk.queue_family_ignored
}

struct VideoDecodeH264 {
mut:
	profile      vk.VideoDecodeH264ProfileInfoKHR = vk.VideoDecodeH264ProfileInfoKHR{}
	capabilities vk.VideoDecodeH264CapabilitiesKHR = vk.VideoDecodeH264CapabilitiesKHR{}
}

struct QueueFamilyProperties {
mut:
	properties       vk.QueueFamilyProperties2
	properties_video vk.QueueFamilyVideoPropertiesKHR
}

pub struct GPUBufferDesc {
pub mut:
	size            vk.DeviceSize
	usage           vk.BufferUsageFlags
	memory_property vk.MemoryPropertyFlagBits = vk.MemoryPropertyFlagBits.device_local
}

pub struct GPUImageDesc {
pub mut:
	extent          vk.Extent3D
	array_size      u32 = 1
	mip_levels      u32 = 1
	image_type      vk.ImageType = vk.ImageType._2d
	format          vk.Format = vk.Format.undefined
	sample_count    u32 = 1
	usage           vk.ImageUsageFlags
	memory_property vk.MemoryPropertyFlagBits = vk.MemoryPropertyFlagBits.device_local
}

pub struct GPUBuffer {
pub mut:
	buffer         vk.Buffer = unsafe { nil }
	memory         vk.DeviceMemory = unsafe { nil }
	device_address vk.DeviceAddress
	p_mapped       voidptr = unsafe { nil }

	desc GPUBufferDesc
}

pub struct GPUImage {
pub mut:
	image      vk.Image = unsafe { nil }
	image_view vk.ImageView = unsafe { nil }
	memory     vk.DeviceMemory = unsafe { nil }

	device_address vk.DeviceAddress
	p_mapped       voidptr = unsafe { nil }

	desc GPUImageDesc
}

pub enum QueueType {
	graphics
	video_decode
}

pub fn vulkan_debug_callback(messageSeverity vk.DebugUtilsMessageSeverityFlagBitsEXT, messageType vk.DebugUtilsMessageTypeFlagsEXT, data &vk.DebugUtilsMessengerCallbackDataEXT, userData voidptr) vk.Bool32 {
	if int(messageSeverity) & int(vk.DebugUtilsMessageSeverityFlagBitsEXT.error) != 0 {
		println(unsafe { data.pMessage.vstring() })
	}
	return 0
}

pub fn (mut ctx DeviceContext) initialize() {
	ctx.initialize_vk_instance()
	ctx.enumerate_gpus()
}

pub fn (mut ctx DeviceContext) shutdown() {
	if !isnil(ctx.vk_device) {
		ctx.swapchain.shutdown()
	}
	if !isnil(ctx.sampler_ycbcr_conversion) {
		vk.destroy_sampler_ycbcr_conversion(ctx.vk_device, ctx.sampler_ycbcr_conversion, unsafe { nil })
		ctx.sampler_ycbcr_conversion = unsafe { nil }
	}
	ctx.vma_allocator.destroy()
	if !isnil(ctx.vk_device) {
		vk.destroy_device(ctx.vk_device, unsafe { nil })
		ctx.vk_device = unsafe { nil }
	}
	ctx.shutdown_instance_resources()
}

// Release resources created before logical-device selection. This is also used
// when no installed GPU supports the requested Vulkan Video profile.
pub fn (mut ctx DeviceContext) shutdown_instance_resources() {
	if !isnil(ctx.swapchain.surface) && !isnil(ctx.vk_instance) {
		vk.destroy_surface_khr(ctx.vk_instance, ctx.swapchain.surface, unsafe { nil })
		ctx.swapchain.surface = unsafe { nil }
	}
	$if debug? {
		if !isnil(ctx.vk_debug_utils) {
			vk.destroy_debug_utils_messenger_ext(ctx.vk_instance, ctx.vk_debug_utils, unsafe { nil })
			ctx.vk_debug_utils = unsafe { nil }
		}
	}
	if !isnil(ctx.vk_instance) {
		vk.destroy_instance(ctx.vk_instance, unsafe { nil })
		ctx.vk_instance = unsafe { nil }
	}
}

pub fn (mut ctx DeviceContext) initialize_device(use_gpu_index u32, h264_profile_idc u32,
	metadata VideoMetadata) bool {
	mut n := unsafe { nil }
	mut family_props_count := u32(0)
	ctx.use_gpu_index = int(use_gpu_index)
	gpu := ctx.get_gpu_current()
	mut gpu_properties := vk.PhysicalDeviceProperties{}
	vk.get_physical_device_properties(gpu, mut &gpu_properties)
	gpu_name := unsafe { cstring_to_vstring(&gpu_properties.deviceName[0]) }
	println('Vulkan device: ${gpu_name}')
	vk.get_physical_device_queue_family_properties2(gpu, &family_props_count, mut n)
	mut family_props_video := []vk.QueueFamilyVideoPropertiesKHR{len: int(family_props_count), init: vk.QueueFamilyVideoPropertiesKHR{}}
	mut family_props := []vk.QueueFamilyProperties2{len: int(family_props_count), init: vk.QueueFamilyProperties2{}}

	for i in 0 .. family_props_count {
		mut prop := unsafe { &family_props[i] }
		mut video_prop := unsafe { &family_props_video[i] }
		prop.pNext = video_prop
	}
	mut p_family_props := family_props.data
	vk.get_physical_device_queue_family_properties2(gpu, &family_props_count, mut p_family_props)
	ctx.queue_families = []QueueFamilyProperties{len: int(family_props_count), init: QueueFamilyProperties{}}
	for i in 0 .. family_props_count {
		ctx.queue_families[i].properties = family_props[i]
		ctx.queue_families[i].properties_video = family_props_video[i]

		queue_family := ctx.queue_families[i].properties.queueFamilyProperties
		mut supports_present := vk.Bool32(0)
		vk.get_physical_device_surface_support_khr(gpu, u32(i), ctx.swapchain.surface, &supports_present)
		if queue_family.queueCount > 0 && (queue_family.queueFlags & vk.QueueFlags(vk.QueueFlagBits.graphics)) != 0 && supports_present == vk._true {
			if ctx.graphics_family == vk.queue_family_ignored {
				ctx.graphics_family = u32(i)
				ctx.queue_family_indices << ctx.graphics_family
			}
		}
		if queue_family.queueCount > 0 && (queue_family.queueFlags & vk.QueueFlags(vk.QueueFlagBits.video_decode)) != 0 {
			if ctx.video_decode_family == vk.queue_family_ignored {
				// H264
				if (int(ctx.queue_families[i].properties_video.videoCodecOperations) & int(vk.VideoCodecOperationFlagBitsKHR.decode_h264)) != 0 {
					ctx.video_decode_family = u32(i)
					ctx.queue_family_indices << ctx.video_decode_family
				}
			}
		}
	}
	if ctx.graphics_family == vk.queue_family_ignored {
		panic('Selected Vulkan device has no graphics queue family that can present to this surface')
	}
	if ctx.video_decode_family == vk.queue_family_ignored {
		panic('Selected Vulkan device has no queue family supporting Vulkan Video H.264 decode')
	}

	ctx.features2.pNext = &ctx.vulkan12_features
	ctx.vulkan12_features.pNext = &ctx.vulkan13_features
	vk.get_physical_device_features2(gpu, mut &ctx.features2)

	mut default_prior := f32(1.0)
	mut device_queue_ci := [
		vk.DeviceQueueCreateInfo{
			queueFamilyIndex: ctx.graphics_family
			queueCount: 1
			pQueuePriorities: &default_prior
			flags: 0 // If not 0, use vk.get_device_queue2 below
		},
	]
	if ctx.video_decode_family != ctx.graphics_family {
		device_queue_ci << vk.DeviceQueueCreateInfo{
			queueFamilyIndex: ctx.video_decode_family
			queueCount: 1
			pQueuePriorities: &default_prior
			flags: 0 // If not 0, use vk.get_device_queue2 below
		}
	}

	active_device_extensions := [vk.khr_swapchain_extension_name, vk.khr_video_queue_extension_name,
		vk.khr_video_decode_queue_extension_name, vk.khr_video_decode_h264_extension_name]

	sampler_ycbcr_conversion_features := vk.PhysicalDeviceSamplerYcbcrConversionFeatures{
		samplerYcbcrConversion: vk._true
	}
	ctx.vulkan13_features.pNext = &sampler_ycbcr_conversion_features

	mut device_create_info := vk.DeviceCreateInfo{
		pNext: &ctx.features2
		queueCreateInfoCount: u32(device_queue_ci.len)
		pQueueCreateInfos: device_queue_ci.data
		enabledExtensionCount: u32(active_device_extensions.len)
		ppEnabledExtensionNames: active_device_extensions.data
	}

	res := vk.create_device(gpu, &device_create_info, unsafe { nil }, &ctx.vk_device)
	if res != vk.Result.success {
		mut error_msg := 'Could not create vulkan device\n\t-> VkResult: ${res}\n'
		if res == .error_extension_not_present {
			error_msg += '\t\tPlease make sure your device supports these extensions:\n'
			for _, e in active_device_extensions {
				error_msg += '\t\t\t${unsafe { e.vstring() }}\n'
			}
		}
		panic(error_msg)
	}
	C.volkLoadDevice(ctx.vk_device)

	vk.get_device_queue(ctx.vk_device, ctx.graphics_family, 0, &ctx.graphics_queue)
	if isnil(ctx.graphics_queue) {
		panic('Could not get device queue for graphics')
	}
	vk.get_device_queue(ctx.vk_device, ctx.video_decode_family, 0, &ctx.video_decode_queue)
	if isnil(ctx.video_decode_queue) {
		panic('Could not get device queue for video decoding')
	}

	ctx.video_profile_info.videoCodecOperation = vk.VideoCodecOperationFlagBitsKHR.decode_h264
	ctx.video_profile_info.chromaSubsampling = vk.VideoChromaSubsamplingFlagsKHR(vk.VideoChromaSubsamplingFlagBitsKHR._420)
	ctx.video_profile_info.chromaBitDepth = vk.VideoComponentBitDepthFlagsKHR(vk.VideoComponentBitDepthFlagBitsKHR._8)
	ctx.video_profile_info.lumaBitDepth = vk.VideoComponentBitDepthFlagsKHR(vk.VideoComponentBitDepthFlagBitsKHR._8)
	ctx.video_profile_info.pNext = &ctx.video_decode_h264.profile

	ctx.video_decode_h264.profile.stdProfileIdc = unsafe { vk.StdVideoH264ProfileIdc(h264_profile_idc) }
	ctx.video_decode_h264.profile.pictureLayout = vk.VideoDecodeH264PictureLayoutFlagBitsKHR.progressive

	ctx.video_capabilities.pNext = &ctx.video_decode_capabilities

	ctx.video_decode_capabilities.pNext = &ctx.video_decode_h264.capabilities

	capabilities_result := vk.get_physical_device_video_capabilities_khr(gpu, &ctx.video_profile_info, mut &ctx.video_capabilities)
	if capabilities_result != .success {
		panic('Could not query selected GPU H.264 video capabilities: ${capabilities_result}')
	}

	ctx.video_decode_bitstream_alignment = math.max(ctx.video_decode_bitstream_alignment, ctx.video_capabilities.minBitstreamBufferOffsetAlignment)
	ctx.video_decode_bitstream_alignment = math.max(ctx.video_decode_bitstream_alignment, ctx.video_capabilities.minBitstreamBufferSizeAlignment)

	/*
											mut vulkan_functions := vma.VulkanFunctions{
												// Required when using VMA_DYNAMIC_VULKAN_FUNCTIONS.
												vkGetInstanceProcAddr:               vk.get_instance_proc_addr
												// Required when using VMA_DYNAMIC_VULKAN_FUNCTIONS.
												vkGetDeviceProcAddr:                 vk.get_device_proc_addr
												vkGetPhysicalDeviceProperties:       vk.get_physical_device_properties
												vkGetPhysicalDeviceMemoryProperties: vk.get_physical_device_memory_properties
												vkAllocateMemory:                    vk.allocate_memory
												vkFreeMemory:                        vk.free_memory
												vkMapMemory:                         vk.map_memory
												vkUnmapMemory:                       vk.unmap_memory
												vkFlushMappedMemoryRanges:           vk.flush_mapped_memory_ranges
												vkInvalidateMappedMemoryRanges:      vk.invalidate_mapped_memory_ranges
												vkBindBufferMemory:                  vk.bind_buffer_memory
												vkBindImageMemory:                   vk.bind_image_memory
												vkGetBufferMemoryRequirements:       vk.get_buffer_memory_requirements
												vkGetImageMemoryRequirements:        vk.get_image_memory_requirements
												vkCreateBuffer:                      vk.create_buffer
												vkDestroyBuffer:                     vk.destroy_buffer
												vkCreateImage:                       vk.create_image
												vkDestroyImage:                      vk.destroy_image
												vkCmdCopyBuffer:                     vk.cmd_copy_buffer
											}

											mut allocator_ci := vma.AllocatorCreateInfo{
												flags:            0 // VMA_ALLOCATOR_CREATE_EXT_MEMORY_BUDGET_BIT
												// physicalDevice:   ctx.get_gpu_current()
												physicalDevice:   unsafe { voidptr(ctx.get_gpu_current()) }
												// device:           ctx.vk_device
												device:           unsafe { voidptr(ctx.vk_device) }
												pVulkanFunctions: &vulkan_functions
												// instance:         ctx.vk_instance
												instance:         unsafe { voidptr(ctx.vk_instance) }
												vulkanApiVersion: vk.api_version_1_3
											}

											vma.create_allocator(&allocator_ci, &ctx.vma_allocator)
											*/
	allocator_create_info := vma.AllocatorCreateInfo{
		physical_device: ctx.get_gpu_current()
		device: ctx.get_vk_device()
	}

	ctx.vma_allocator = vma.new(allocator_create_info)
	profile_list := vk.VideoProfileListInfoKHR{
		profileCount: 1
		pProfiles: &ctx.video_profile_info
	}
	decode_output_usage := vk.ImageUsageFlags(u32(vk.ImageUsageFlagBits.video_decode_dst) | u32(vk.ImageUsageFlagBits.transfer_src))
	decode_output_format := query_video_format(ctx.get_gpu_current(), &profile_list, decode_output_usage) or {
		panic('No Vulkan Video decode-output format supports transfer to the display image')
	}

	mut sampler_ycbcr_conversion_ci := vk.SamplerYcbcrConversionCreateInfo{
		format: decode_output_format.format
		ycbcrModel: ycbcr_model_from_colour_primaries(metadata.colour_primaries)
		ycbcrRange: if metadata.video_full_range {
			vk.SamplerYcbcrRange.itu_full} else {
			vk.SamplerYcbcrRange.itu_narrow}
		components: vk.ComponentMapping{
			r: vk.ComponentSwizzle.identity
			g: vk.ComponentSwizzle.identity
			b: vk.ComponentSwizzle.identity
			a: vk.ComponentSwizzle.identity
		}
		xChromaOffset: vk.ChromaLocation.midpoint
		yChromaOffset: vk.ChromaLocation.midpoint
		chromaFilter: vk.Filter.nearest
		forceExplicitReconstruction: 0
	}

	conversion_result := vk.create_sampler_ycbcr_conversion(ctx.vk_device, &sampler_ycbcr_conversion_ci, unsafe { nil }, &ctx.sampler_ycbcr_conversion)
	if conversion_result != .success {
		panic('Could not create metadata-aware Vulkan YCbCr conversion: ${conversion_result}')
	}
	println('Decode output format: ${decode_output_format.format}')
	println('Color conversion: ${ycbcr_model_name(sampler_ycbcr_conversion_ci.ycbcrModel)}, ${if metadata.video_full_range {
		'full range'
	} else {
		'limited range'
	}}')

	return true
}

fn ycbcr_model_from_colour_primaries(colour_primaries u8) vk.SamplerYcbcrModelConversion {
	// Match the Vulkan-Video-Samples mapping from H.264 VUI colour primaries.
	return match colour_primaries {
		1 { vk.SamplerYcbcrModelConversion.ycbcr709 }
		5, 6 { vk.SamplerYcbcrModelConversion.ycbcr601 }
		9 { vk.SamplerYcbcrModelConversion.ycbcr2020 }
		else { vk.SamplerYcbcrModelConversion.ycbcr_identity }
	}
}

fn ycbcr_model_name(model vk.SamplerYcbcrModelConversion) string {
	return match model {
		.ycbcr709 { 'BT.709' }
		.ycbcr601 { 'BT.601' }
		.ycbcr2020 { 'BT.2020' }
		else { 'identity/unspecified' }
	}
}

fn device_supports_extensions(gpu vk.PhysicalDevice, required_extensions []&u8) bool {
	return missing_device_extensions(gpu, required_extensions).len == 0
}

fn missing_device_extensions(gpu vk.PhysicalDevice, required_extensions []&u8) []string {
	mut count := u32(0)
	mut no_extensions := unsafe { nil }
	if vk.enumerate_device_extension_properties(gpu, unsafe { nil }, &count, mut no_extensions) != .success {
		return ['could not enumerate device extensions']
	}
	mut extensions := []vk.ExtensionProperties{len: int(count)}
	mut extensions_data := extensions.data
	if vk.enumerate_device_extension_properties(gpu, unsafe { nil }, &count, mut extensions_data) != .success {
		return ['could not read device extensions']
	}
	mut missing := []string{}
	for required in required_extensions {
		required_name := unsafe { cstring_to_vstring(required) }
		mut found := false
		for i in 0 .. count {
			available_name := unsafe { cstring_to_vstring(&extensions[i].extensionName[0]) }
			if available_name == required_name {
				found = true
				break
			}
		}
		if !found {
			missing << required_name
		}
	}
	return missing
}

pub fn (ctx DeviceContext) h264_decode_gpu_diagnostics(h264_profile_idc u32) []string {
	required_extensions := [vk.khr_swapchain_extension_name, vk.khr_video_queue_extension_name,
		vk.khr_video_decode_queue_extension_name, vk.khr_video_decode_h264_extension_name]
	if ctx.gpus.len == 0 {
		return ['No Vulkan physical devices were found.']
	}
	mut diagnostics := []string{}
	for gpu in ctx.gpus {
		mut properties := vk.PhysicalDeviceProperties{}
		vk.get_physical_device_properties(gpu, mut &properties)
		name := unsafe { cstring_to_vstring(&properties.deviceName[0]) }
		missing := missing_device_extensions(gpu, required_extensions)
		if missing.len > 0 {
			diagnostics << '${name}: missing ${missing.join(', ')}'
		} else if !gpu_supports_h264_profile(gpu, h264_profile_idc) {
			diagnostics << '${name}: H.264 ${h264_profile_name(h264_profile_idc)} Profile, 8-bit 4:2:0 progressive decode is not supported'
		} else if device_has_required_queues(ctx, gpu) {
			diagnostics << '${name}: compatible'
		} else {
			diagnostics << '${name}: required extensions/profile exist, but no compatible graphics, presentation, and decode queue combination was found'
		}
	}
	return diagnostics
}

pub fn (ctx DeviceContext) gpu_count() int {
	return ctx.gpus.len
}

pub fn (ctx DeviceContext) is_h264_decode_gpu_compatible(gpu_index int, h264_profile_idc u32) bool {
	if gpu_index < 0 || gpu_index >= ctx.gpus.len {
		return false
	}
	gpu := ctx.gpus[gpu_index]
	required_extensions := [vk.khr_swapchain_extension_name, vk.khr_video_queue_extension_name,
		vk.khr_video_decode_queue_extension_name, vk.khr_video_decode_h264_extension_name]
	return device_supports_extensions(gpu, required_extensions)
		&& device_has_required_queues(ctx, gpu)
		&& gpu_supports_h264_profile(gpu, h264_profile_idc)
}

fn device_has_required_queues(ctx &DeviceContext, gpu vk.PhysicalDevice) bool {
	mut family_count := u32(0)
	mut no_properties := unsafe { nil }
	vk.get_physical_device_queue_family_properties2(gpu, &family_count, mut no_properties)
	mut video_props := []vk.QueueFamilyVideoPropertiesKHR{len: int(family_count), init: vk.QueueFamilyVideoPropertiesKHR{}}
	mut family_props := []vk.QueueFamilyProperties2{len: int(family_count), init: vk.QueueFamilyProperties2{}}
	for i in 0 .. family_count {
		unsafe { family_props[i].pNext = &video_props[i] }
	}
	mut props_data := family_props.data
	vk.get_physical_device_queue_family_properties2(gpu, &family_count, mut props_data)
	mut has_graphics_and_present := false
	mut has_h264_decode := false
	for i in 0 .. family_count {
		queue := family_props[i].queueFamilyProperties
		if queue.queueCount == 0 { continue }
		mut supports_present := vk.Bool32(0)
		vk.get_physical_device_surface_support_khr(gpu, u32(i), ctx.swapchain.surface, &supports_present)
		has_graphics_and_present = has_graphics_and_present || ((queue.queueFlags & vk.QueueFlags(vk.QueueFlagBits.graphics)) != 0 && supports_present == vk._true)
		has_h264_decode = has_h264_decode || ((queue.queueFlags & vk.QueueFlags(vk.QueueFlagBits.video_decode)) != 0 && (video_props[i].videoCodecOperations & vk.VideoCodecOperationFlagsKHR(vk.VideoCodecOperationFlagBitsKHR.decode_h264)) != 0)
	}
	return has_graphics_and_present && has_h264_decode
}

pub fn (ctx DeviceContext) find_h264_decode_gpu(h264_profile_idc u32) ?u32 {
	required_extensions := [vk.khr_swapchain_extension_name, vk.khr_video_queue_extension_name,
		vk.khr_video_decode_queue_extension_name, vk.khr_video_decode_h264_extension_name]
	for gpu_index, gpu in ctx.gpus {
		if device_supports_extensions(gpu, required_extensions)
			&& device_has_required_queues(ctx, gpu)
			&& gpu_supports_h264_profile(gpu, h264_profile_idc) {
			return u32(gpu_index)
		}
	}
	return none
}

fn gpu_supports_h264_profile(gpu vk.PhysicalDevice, h264_profile_idc u32) bool {
	mut h264_profile := vk.VideoDecodeH264ProfileInfoKHR{
		stdProfileIdc: unsafe { vk.StdVideoH264ProfileIdc(h264_profile_idc) }
		pictureLayout: vk.VideoDecodeH264PictureLayoutFlagBitsKHR.progressive
	}
	profile := vk.VideoProfileInfoKHR{
		pNext: &h264_profile
		videoCodecOperation: vk.VideoCodecOperationFlagBitsKHR.decode_h264
		chromaSubsampling: vk.VideoChromaSubsamplingFlagsKHR(vk.VideoChromaSubsamplingFlagBitsKHR._420)
		lumaBitDepth: vk.VideoComponentBitDepthFlagsKHR(vk.VideoComponentBitDepthFlagBitsKHR._8)
		chromaBitDepth: vk.VideoComponentBitDepthFlagsKHR(vk.VideoComponentBitDepthFlagBitsKHR._8)
	}
	mut h264_caps := vk.VideoDecodeH264CapabilitiesKHR{}
	mut decode_caps := vk.VideoDecodeCapabilitiesKHR{
		pNext: &h264_caps
	}
	mut caps := vk.VideoCapabilitiesKHR{
		pNext: &decode_caps
	}
	return vk.get_physical_device_video_capabilities_khr(gpu, &profile, mut &caps) == .success
}

pub fn (mut ctx DeviceContext) initialize_swapchain(window_p &glfw.Window, desired_format vk.Format) bool {
	return ctx.swapchain.initialize(window_p, desired_format)
}

pub fn (ctx DeviceContext) create_buffer(desc &GPUBufferDesc, buffer &GPUBuffer) {
	// TODO
	panic('Not implemented')
}

pub fn (mut ctx DeviceContext) create_image(desc &GPUImageDesc, mut image &GPUImage) {
	mut n := unsafe { nil }
	mut image_ci := vk.ImageCreateInfo{
		flags: 0
		imageType: desc.image_type
		format: desc.format
		extent: desc.extent
		mipLevels: desc.mip_levels
		arrayLayers: desc.array_size
		samples: vk.SampleCountFlagBits._1
		tiling: vk.ImageTiling.optimal
		usage: u32(desc.usage)
		sharingMode: vk.SharingMode.exclusive
		queueFamilyIndexCount: 0
		pQueueFamilyIndices: unsafe { nil }
		initialLayout: vk.ImageLayout.undefined
	}
	image_ci.usage = vk.ImageUsageFlags(u32(vk.BufferUsageFlagBits.transfer_src) | u32(vk.BufferUsageFlagBits.transfer_dst))

	mut profile_list_info := vk.VideoProfileListInfoKHR{
		profileCount: 1
		pProfiles: &ctx.video_profile_info
	}
	if desc.usage & (u32(vk.ImageUsageFlagBits.video_decode_dst) | u32(vk.ImageUsageFlagBits.video_decode_src) | u32(vk.ImageUsageFlagBits.video_decode_dpb)) != 0 {
		image_ci.pNext = &profile_list_info

		mut video_format_info := vk.PhysicalDeviceVideoFormatInfoKHR{
			pNext: &profile_list_info
			imageUsage: image_ci.usage
		}
		mut format_count := u32(0)
		vk.get_physical_device_video_format_properties_khr(ctx.get_gpu_current(), &video_format_info, &format_count, mut n)
		mut video_formats := []vk.VideoFormatPropertiesKHR{len: int(format_count)}
		// TODO: Ticket. &format_count should be mut, or make every other mut optional
		// TODO: Ticket video_formats.data. Array can not be modified. It's not marked const in vulkan
		mut tmp_formats := &vk.VideoFormatPropertiesKHR(video_formats.data)
		res := vk.get_physical_device_video_format_properties_khr(ctx.get_gpu_current(), &video_format_info, &format_count, mut &tmp_formats)
		if res != vk.Result.success {
			panic('Could not get device video format properties')
		}
	}

	if ctx.queue_family_indices.len > 1 {
		image_ci.sharingMode = vk.SharingMode.concurrent
		image_ci.queueFamilyIndexCount = u32(ctx.queue_family_indices.len)
		image_ci.pQueueFamilyIndices = ctx.queue_family_indices.data
	}

	vk.create_image(ctx.vk_device, &image_ci, unsafe { nil }, &image.image)

	mut reqs := vk.MemoryRequirements2{}
	mut info := vk.ImageMemoryRequirementsInfo2{
		image: image.image
	}
	vk.get_image_memory_requirements2(ctx.vk_device, &info, mut &reqs)

	mut alloc_info := vk.MemoryAllocateInfo{
		allocationSize: reqs.memoryRequirements.size
		memoryTypeIndex: ctx.get_memory_type_index(reqs, vk.MemoryPropertyFlags(desc.memory_property))
	}
	vk.allocate_memory(ctx.vk_device, &alloc_info, unsafe { nil }, &image.memory)
	vk.bind_image_memory(ctx.vk_device, image.image, image.memory, 0)

	mut view_ci := vk.ImageViewCreateInfo{
		flags: 0
		image: image.image
		viewType: vk.ImageViewType._2d
		format: image_ci.format
		// NOTE: int(identity) = 0
		components: vk.ComponentMapping{
			r: vk.ComponentSwizzle.identity
			g: vk.ComponentSwizzle.identity
			b: vk.ComponentSwizzle.identity
			a: vk.ComponentSwizzle.identity
		}
		subresourceRange: vk.ImageSubresourceRange{
			aspectMask: vk.ImageAspectFlags(vk.ImageAspectFlagBits.color)
			baseMipLevel: 0
			levelCount: image_ci.mipLevels
			baseArrayLayer: 0
			layerCount: image_ci.arrayLayers
		}
	}

	view_ci.viewType = match desc.image_type {
		._1d {
			vk.ImageViewType._1d
		}
		._2d {
			vk.ImageViewType._2d
		}
		._3d {
			vk.ImageViewType._3d
		}
		else {
			vk.ImageViewType._2d
		}
	}

	vk.create_image_view(ctx.vk_device, &view_ci, unsafe { nil }, &image.image_view)
}

pub fn (ctx DeviceContext) submit(queue_type QueueType, mut p_submit_info vk.SubmitInfo, mut wait_fence vk.Fence) {
	mut queue := match queue_type {
		.graphics { ctx.graphics_queue }
		.video_decode { ctx.video_decode_queue }
	}

	vk.queue_submit(queue, 1, p_submit_info, wait_fence)
}

pub fn (mut ctx DeviceContext) present(wait_semaphores []vk.Semaphore) vk.Result {
	mut handle := ctx.swapchain.get_handle()
	mut index := ctx.swapchain.get_current_index()
	mut present := vk.PresentInfoKHR{
		waitSemaphoreCount: u32(wait_semaphores.len)
		pWaitSemaphores: wait_semaphores.data
		swapchainCount: 1
		pSwapchains: &handle
		pImageIndices: &index
		pResults: unsafe { nil }
	}
	result := vk.queue_present_khr(ctx.graphics_queue, &present)
	vk.queue_wait_idle(ctx.graphics_queue)
	return result
}

pub fn (ctx DeviceContext) get_queue(type QueueType) vk.Queue {
	return match type {
		.graphics { ctx.graphics_queue }
		.video_decode { ctx.video_decode_queue }
	}
}

pub fn (mut ctx DeviceContext) initialize_vk_instance() bool {
	if C.volkInitialize() != vk.Result.success {
		panic('Could not volkInitialize()')
	}
	mut n := unsafe { nil }
	mut instance_extension_count := u32(0)
	vk.enumerate_instance_extension_properties(unsafe { nil }, &instance_extension_count, mut n)
	mut instance_extensions := []vk.ExtensionProperties{len: int(instance_extension_count)}
	// Temporary variable to make data mutable
	mut instance_extensions_data := instance_extensions.data
	vk.enumerate_instance_extension_properties(unsafe { nil }, &instance_extension_count, mut instance_extensions_data)

	mut active_instance_extensions := []&u8{}
	mut glfw_required_count := u32(0)
	glfw_required_extension_names := glfw.get_required_instance_extensions(&glfw_required_count)
	for i in 0 .. glfw_required_count {
		active_instance_extensions << unsafe { glfw_required_extension_names[i] }
	}
	mut instance_extensions_required := [
		vk.khr_get_physical_device_properties_2_extension_name,
		vk.khr_get_surface_capabilities_2_extension_name,
	]
	$if debug? {
		instance_extensions_required << vk.ext_debug_utils_extension_name
	}
	for i in 0 .. instance_extensions_required.len {
		active_instance_extensions << instance_extensions_required[i]
	}

	mut active_instance_layers := []&u8{}
	$if debug? {
		active_instance_layers = [c'VK_LAYER_KHRONOS_validation']
	}

	mut app_info := vk.ApplicationInfo{
		pApplicationName: c'Example'
		pEngineName: c'Example'
		engineVersion: vk.api_version_1_3
		apiVersion: vk.api_version_1_3
	}

	mut instance_create_info := vk.InstanceCreateInfo{
		pApplicationInfo: &app_info
		enabledLayerCount: u32(active_instance_layers.len)
		ppEnabledLayerNames: &&u8(active_instance_layers.data)
		enabledExtensionCount: u32(active_instance_extensions.len)
		ppEnabledExtensionNames: &&u8(active_instance_extensions.data)
	}
	mut debug_utils_create_info := vk.DebugUtilsMessengerCreateInfoEXT{}
	$if debug? {
		debug_utils_create_info = vk.DebugUtilsMessengerCreateInfoEXT{
			messageSeverity: vk.DebugUtilsMessageSeverityFlagsEXT(vk.DebugUtilsMessageSeverityFlagBitsEXT.error) | vk.DebugUtilsMessageSeverityFlagsEXT(vk.DebugUtilsMessageSeverityFlagBitsEXT.warning)
			messageType: vk.DebugUtilsMessageTypeFlagsEXT(vk.DebugUtilsMessageTypeFlagBitsEXT.validation) | vk.DebugUtilsMessageTypeFlagsEXT(vk.DebugUtilsMessageTypeFlagBitsEXT.performance)
			pfnUserCallback: vulkan_debug_callback
		}
		instance_create_info.pNext = &debug_utils_create_info
	}
	res := vk.create_instance(&instance_create_info, unsafe { nil }, &ctx.vk_instance)
	if res != .success {
		panic('Could not create vkInstance')
	}
	C.volkLoadInstance(ctx.vk_instance)
	$if debug? {
		resdbg := vk.create_debug_utils_messenger_ext(ctx.vk_instance, &debug_utils_create_info, unsafe { nil }, &ctx.vk_debug_utils)
		if resdbg != vk.Result.success {
			panic('Could not create DebugUtilsMessengerEXT')
		}
	}
	return true
}

pub fn (mut ctx DeviceContext) enumerate_gpus() {
	mut gpu_count := u32(0)

	vk.enumerate_physical_devices(ctx.vk_instance, &gpu_count, unsafe { nil })
	int_gpu_count := int(gpu_count)
	ctx.gpus = unsafe { []vk.PhysicalDevice{len: int_gpu_count} }
	vk.enumerate_physical_devices(ctx.vk_instance, &gpu_count, ctx.gpus.data)

	ctx.physical_device_memory_props = []vk.PhysicalDeviceMemoryProperties2{len: int(gpu_count), init: vk.PhysicalDeviceMemoryProperties2{
		memoryProperties: vk.PhysicalDeviceMemoryProperties{
			memoryTypes: [vk.max_memory_types]vk.MemoryType{}
			memoryHeaps: [vk.max_memory_heaps]vk.MemoryHeap{}
		}
	}}
	for i in 0 .. gpu_count {
		vk.get_physical_device_memory_properties2(ctx.gpus[i], mut &ctx.physical_device_memory_props[i])
	}
}

pub fn (ctx DeviceContext) get_memory_type_index(reqs vk.MemoryRequirements2, flags vk.MemoryPropertyFlags) u32 {
	mut request_bits := reqs.memoryRequirements.memoryTypeBits
	memory_props := ctx.physical_device_memory_props[ctx.use_gpu_index].memoryProperties
	for i in 0 .. memory_props.memoryTypeCount {
		// Match wanted memory properties
		if (int(request_bits) & 1) != 0 {
			if (memory_props.memoryTypes[i].propertyFlags & flags) == flags {
				return i
			}
		}
		request_bits >>= 1
	}
	return max_u32
}

pub fn (ctx DeviceContext) get_gpu(gpu_index int) vk.PhysicalDevice {
	return ctx.gpus[gpu_index]
}

pub fn (ctx DeviceContext) get_gpu_current() vk.PhysicalDevice {
	assert ctx.gpus.len > ctx.use_gpu_index && !isnil(ctx.gpus[ctx.use_gpu_index])
	return ctx.gpus[ctx.use_gpu_index]
}

// TODO: Do we want getters/setters?
pub fn (ctx DeviceContext) get_vk_device() vk.Device {
	return ctx.vk_device
}

pub fn (ctx DeviceContext) wait_for_idle() {
	vk.queue_wait_idle(ctx.graphics_queue)
	vk.queue_wait_idle(ctx.video_decode_queue)
}

pub fn (ctx DeviceContext) get_decoder_queue_family_index() u32 {
	return ctx.video_decode_family
}
