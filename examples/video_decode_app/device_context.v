module video_decode_app


import src.vulkan as vk
import bindings.vk_mem_alloc as vma
import bindings.volk

#flag linux -I$env('VULKAN_SDK')/include
#flag windows -I$env('VULKAN_SDK')/Include

#include "volk.h"

pub struct DeviceContext {
mut:
	vk_instance          C.VkInstance
	vk_device            C.VkDevice
	vk_debug_utils       C.VkDebugUtilsMessengerEXT
	use_gpu_index        u32
	gpus                 []C.VkPhysicalDevice
	queue_families       []QueueFamilyProperties
	queue_family_indices []u32
	graphics_family      u32 = vk.queue_family_ignored
	video_decode_family  u32 = vk.queue_family_ignored
	graphics_queue       C.VkQueue
	video_decode_queue   C.VkQueue

	physical_device_memory_props []vk.PhysicalDeviceMemoryProperties2
	features2                    vk.PhysicalDeviceFeatures2
	vulkan12_features            vk.PhysicalDeviceVulkan12Features
	vulkan13_features            vk.PhysicalDeviceVulkan13Features
	video_profile_info           vk.VideoProfileInfoKHR
	video_decode_h264            VideoDecodeH264
	video_capabilities           vk.VideoCapabilitiesKHR
pub mut:
	swapchain                Swapchain @[required]
	sampler                  C.VkSampler
	vma_allocator            C.VmaAllocator
	sampler_ycbcr_conversion C.VkSamplerYcbcrConversion
}

struct VideoDecodeH264 {
mut:
	profile      vk.VideoDecodeH264ProfileInfoKHR
	capabilities vk.VideoDecodeH264CapabilitiesKHR
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
	memory_property vk.MemoryPropertyFlagBits = vk.MemoryPropertyFlagBits.device_local_bit
}

pub struct GPUImageDesc {
pub mut:
	extent          vk.Extent3D
	array_size      u32          = 1
	mip_levels      u32          = 1
	image_type      vk.ImageType = vk.ImageType._2d
	format          vk.Format    = vk.Format.undefined
	sample_count    u32          = 1
	usage           vk.ImageUsageFlags
	memory_property vk.MemoryPropertyFlagBits = vk.MemoryPropertyFlagBits.device_local_bit
}

pub struct GPUBuffer {
pub mut:
	buffer         C.VkBuffer
	memory         C.VkDeviceMemory
	device_address vk.DeviceAddress
	p_mapped       voidptr = unsafe { nil }

	desc GPUBufferDesc
}

pub struct GPUImage {
pub mut:
	image      C.VkImage
	image_view C.VkImageView
	memory     C.VkDeviceMemory

	device_address vk.DeviceAddress
	p_mapped       voidptr = unsafe { nil }

	desc GPUImageDesc
}

pub enum QueueType {
	graphics
	video_decode
}

pub fn vulkan_debug_callback(messageSeverity vk.DebugUtilsMessageSeverityFlagBitsEXT, messageType vk.DebugUtilsMessageTypeFlagsEXT, data &vk.DebugUtilsMessengerCallbackDataEXT, userData voidptr) vk.Bool32 {
	if int(messageSeverity) & int(vk.DebugUtilsMessageSeverityFlagBitsEXT.error_bit_ext) != 0 {
		println(data.pMessage)
	}
	return vk._false
}

pub fn (mut ctx DeviceContext) initialize() {
	ctx.initialize_vk_instance()
	ctx.enumerate_gpus()
}

pub fn (mut ctx DeviceContext) shutdown() {
	ctx.swapchain.shutdown()
	unsafe { free(ctx) }
}

pub fn (mut ctx DeviceContext) initialize_device(use_gpu_index u32) bool {
	mut family_props_count := u32(0)
	ctx.use_gpu_index = use_gpu_index
	gpu := ctx.get_gpu_current()
	vk.get_physical_device_queue_family_properties2(gpu, &family_props_count, unsafe { nil })
	mut family_props_video := []vk.QueueFamilyVideoPropertiesKHR{len: int(family_props_count)}
	mut family_props := []vk.QueueFamilyProperties2{len: int(family_props_count)}

	for i in 0 .. family_props_count {
		// TODO: need &family_props or is it done by reference in background already?
		mut prop := family_props[i]
		video_prop := family_props_video[i]
		prop.pNext = &video_prop
	}
	vk.get_physical_device_queue_family_properties2(gpu, &family_props_count, family_props.data)

	for i in 0 .. family_props_count {
		ctx.queue_families[i].properties = family_props[i]
		ctx.queue_families[i].properties_video = family_props_video[i]

		queue_family := ctx.queue_families[i].properties.queueFamilyProperties
		if queue_family.queueCount > 0
			&& (int(queue_family.queueFlags) & int(vk.QueueFlagBits.graphics_bit)) != 0 {
			if ctx.graphics_family == vk.queue_family_ignored {
				ctx.graphics_family = i
				ctx.queue_family_indices << ctx.graphics_family
			}
		}

		if queue_family.queueCount > 0 && int(queue_family.queueFlags) != 0
			&& int(vk.QueueFlagBits.video_decode_bit_khr) != 0 {
			if ctx.video_decode_family == vk.queue_family_ignored {
				// H264
				if (int(ctx.queue_families[i].properties_video.videoCodecOperations) & int(vk.VideoCodecOperationFlagBitsKHR.decode_h264_bit_khr)) != 0 {
					ctx.video_decode_family = i
					ctx.queue_family_indices << ctx.video_decode_family
				}
			}
		}
	}

	ctx.features2.pNext = &ctx.vulkan12_features
	ctx.vulkan12_features.pNext = &ctx.vulkan13_features
	vk.get_physical_device_features2(gpu, &ctx.features2)

	mut default_prior := f32(1.0)
	mut device_queue_ci := [
		vk.DeviceQueueCreateInfo{
			queueFamilyIndex: ctx.graphics_family
			queueCount:       1
			pQueuePriorities: &default_prior
		},
		vk.DeviceQueueCreateInfo{
			queueFamilyIndex: ctx.video_decode_family
			queueCount:       1
			pQueuePriorities: &default_prior
		},
	]

	active_device_extensions := [vk.khr_swapchain_extension_name, vk.khr_video_queue_extension_name,
		vk.khr_video_decode_queue_extension_name, vk.khr_video_decode_h264_extension_name,
		vk.khr_sampler_ycbcr_conversion_extension_name]

	sampler_ycbcr_conversion_features := vk.PhysicalDeviceSamplerYcbcrConversionFeatures{
		samplerYcbcrConversion: vk._true
	}
	ctx.vulkan13_features.pNext = &sampler_ycbcr_conversion_features

	device_create_info := vk.DeviceCreateInfo{
		pNext:                   &ctx.features2
		queueCreateInfoCount:    u32(device_queue_ci.len)
		pQueueCreateInfos:       device_queue_ci.data
		enabledExtensionCount:   u32(active_device_extensions.len)
		ppEnabledExtensionNames: active_device_extensions.data
	}

	res := vk.create_device(gpu, &device_create_info, unsafe { nil }, ctx.vk_device)
	if res != vk.Result.success {
		panic('Could not create vulkan device')
	}
	volk.load_device(ctx.vk_device)

	vk.get_device_queue(ctx.vk_device, ctx.graphics_family, 0, ctx.graphics_queue)
	vk.get_device_queue(ctx.vk_device, ctx.video_decode_family, 0, ctx.video_decode_queue)

	ctx.video_profile_info.videoCodecOperation = vk.VideoCodecOperationFlagBitsKHR.decode_h264_bit_khr
	ctx.video_profile_info.chromaSubsampling = vk.VideoChromaSubsamplingFlagsKHR(vk.VideoChromaSubsamplingFlagBitsKHR._420_bit_khr)
	ctx.video_profile_info.chromaBitDepth = vk.VideoComponentBitDepthFlagsKHR(vk.VideoComponentBitDepthFlagBitsKHR._8_bit_khr)
	ctx.video_profile_info.lumaBitDepth = vk.VideoComponentBitDepthFlagsKHR(vk.VideoComponentBitDepthFlagBitsKHR._8_bit_khr)
	ctx.video_profile_info.pNext = &ctx.video_decode_h264.profile

	ctx.video_decode_h264.profile.stdProfileIdc = vk.StdVideoH264ProfileIdc.high
	ctx.video_decode_h264.profile.pictureLayout = vk.VideoDecodeH264PictureLayoutFlagBitsKHR.interlaced_interleaved_lines_bit_khr

	ctx.video_capabilities.pNext = &ctx.video_decode_h264.capabilities

	vk.get_physical_device_video_capabilities_khr(gpu, &ctx.video_profile_info, &ctx.video_capabilities)

	mut vulkan_functions := vma.VulkanFunctions{
		// Required when using VMA_DYNAMIC_VULKAN_FUNCTIONS.
		vkGetInstanceProcAddr: vk.get_instance_proc_addr
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

	mut allocator_ci := vma.VmaAllocatorCreateInfo{
		flags:            0 // VMA_ALLOCATOR_CREATE_EXT_MEMORY_BUDGET_BIT
		physicalDevice:   ctx.get_gpu_current()
		device:           ctx.vk_device
		pVulkanFunctions: &vulkan_functions
		instance:         ctx.vk_instance
		vulkanApiVersion: vk.api_version_1_3
	}

	vma.create_allocator(&allocator_ci, ctx.vma_allocator)

	mut sampler_ycbcr_conversion_ci := vk.SamplerYcbcrConversionCreateInfo{
		format:                      vk.Format.g8_b8r8_2plane420_unorm
		ycbcrModel:                  vk.SamplerYcbcrModelConversion.ycbcr709
		ycbcrRange:                  vk.SamplerYcbcrRange.itu_narrow
		components:                  vk.ComponentMapping{
			r: vk.ComponentSwizzle.identity
			g: vk.ComponentSwizzle.identity
			b: vk.ComponentSwizzle.identity
			a: vk.ComponentSwizzle.identity
		}
		xChromaOffset:               vk.ChromaLocation.midpoint
		yChromaOffset:               vk.ChromaLocation.midpoint
		chromaFilter:                vk.Filter.nearest
		forceExplicitReconstruction: 0
	}

	vk.create_sampler_ycbcr_conversion(ctx.vk_device, &sampler_ycbcr_conversion_ci, unsafe { nil },
		ctx.sampler_ycbcr_conversion)

	return true
}

pub fn (mut ctx DeviceContext) initialize_swapchain(app IApp, window C.GLFWwindow, desired_format vk.Format) bool {
	return ctx.swapchain.initialize(window, desired_format)
}

pub fn (ctx DeviceContext) create_buffer(desc &GPUBufferDesc, buffer &GPUBuffer) {}

pub fn (ctx DeviceContext) create_image(desc &GPUImageDesc, image &GPUImage) {
	mut image_ci := vk.ImageCreateInfo{
		flags:                 0
		imageType:             desc.image_type
		format:                desc.format
		extent:                desc.extent
		mipLevels:             desc.mip_levels
		arrayLayers:           desc.array_size
		samples:               vk.SampleCountFlagBits._1_bit
		tiling:                vk.ImageTiling.optimal
		usage:                 u32(desc.usage)
		sharingMode:           vk.SharingMode.exclusive
		queueFamilyIndexCount: 0
		pQueueFamilyIndices:   unsafe { nil }
		initialLayout:         vk.ImageLayout.undefined
	}
	image_ci.usage = vk.ImageUsageFlags(u32(vk.BufferUsageFlagBits.transfer_src_bit) | u32(vk.BufferUsageFlagBits.transfer_dst_bit))

	mut profile_list_info := vk.VideoProfileListInfoKHR{
		profileCount: 1
		pProfiles:    &ctx.video_profile_info
	}
	if desc.usage & (u32(vk.ImageUsageFlagBits.video_decode_dst_bit_khr) | u32(vk.ImageUsageFlagBits.video_decode_src_bit_khr) | u32(vk.ImageUsageFlagBits.video_decode_dpb_bit_khr)) != 0 {
		image_ci.pNext = &profile_list_info

		mut video_format_info := vk.PhysicalDeviceVideoFormatInfoKHR{
			pNext:      &profile_list_info
			imageUsage: image_ci.usage
		}
		mut format_count := u32(0)
		vk.get_physical_device_video_format_properties_khr(ctx.get_gpu_current(), &video_format_info,
			&format_count, unsafe { nil })
		mut video_formats := []vk.VideoFormatPropertiesKHR{len: int(format_count)}
		res := vk.get_physical_device_video_format_properties_khr(ctx.get_gpu_current(),
			&video_format_info, &format_count, video_formats.data)
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
	vk.get_image_memory_requirements2(ctx.vk_device, &info, &reqs)

	mut alloc_info := vk.MemoryAllocateInfo{
		allocationSize:  reqs.memoryRequirements.size
		memoryTypeIndex: ctx.get_memory_type_index(reqs, vk.MemoryPropertyFlags(desc.memory_property))
	}
	vk.allocate_memory(ctx.vk_device, &alloc_info, unsafe { nil }, &image.memory)
	vk.bind_image_memory(ctx.vk_device, image.image, image.memory, 0)

	mut view_ci := vk.ImageViewCreateInfo{
		flags:    0
		image:    image.image
		viewType: vk.ImageViewType._2d
		format:   image_ci.format
		// NOTE: int(identity) = 0
		components:       vk.ComponentMapping{
			r: vk.ComponentSwizzle.identity
			g: vk.ComponentSwizzle.identity
			b: vk.ComponentSwizzle.identity
			a: vk.ComponentSwizzle.identity
		}
		subresourceRange: vk.ImageSubresourceRange{
			aspectMask:     vk.ImageAspectFlags(vk.ImageAspectFlagBits.color_bit)
			baseMipLevel:   0
			levelCount:     image_ci.mipLevels
			baseArrayLayer: 0
			layerCount:     image_ci.arrayLayers
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

pub fn (ctx DeviceContext) submit(queue_type QueueType, p_submit_info &vk.SubmitInfo, wait_fence C.VkFence) {
	queue := match queue_type {
		.graphics { ctx.graphics_queue }
		.video_decode { ctx.video_decode_queue }
	}
	vk.queue_submit(queue, 1, p_submit_info, wait_fence)
}

pub fn (ctx DeviceContext) present(wait_semaphores []C.VkSemaphore) {
	mut handle := ctx.swapchain.get_handle()
	mut index := ctx.swapchain.get_current_index()
	mut present := vk.PresentInfoKHR{
		waitSemaphoreCount: u32(wait_semaphores.len)
		pWaitSemaphores:    wait_semaphores.data
		swapchainCount:     1
		pSwapchains:        &handle
		pImageIndices:      &index
	}
	vk.queue_present_khr(ctx.graphics_queue, &present)
	vk.queue_wait_idle(ctx.graphics_queue)
}

pub fn (ctx DeviceContext) get_queue(type QueueType) C.VkQueue {
	return match type {
		.graphics { ctx.graphics_queue }
		.video_decode { ctx.video_decode_queue }
	}
}

pub fn (mut ctx DeviceContext) initialize_vk_instance() bool {
	if volk.initialize() != vk.Result.success {
		panic('Could not volkInitialize()')
	}

	mut instance_extension_count := u32(0)
	vk.enumerate_instance_extension_properties(unsafe { nil }, &instance_extension_count,
		unsafe { nil })
	mut instance_extensions := []vk.ExtensionProperties{len: int(instance_extension_count)}
	vk.enumerate_instance_extension_properties(unsafe { nil }, &instance_extension_count,
		instance_extensions.data)

	mut active_instance_extensions := []string{len: 0} //&&char(0)
	mut glfw_required_count := u32(0)
	for i in 0 .. glfw_required_count {
		glfw_required_extension_names := unsafe { (&char(C.glfwGetRequiredInstanceExtensions(&glfw_required_count)[i])).vstring() }
		active_instance_extensions << glfw_required_extension_names
	}
	instance_extension_required := [
		vk.khr_get_physical_device_properties_2_extension_name,
		vk.khr_get_surface_capabilities_2_extension_name,
		// $if debug ? {
		// 	vk.ext_debug_utils_extension_name
		// }
	]
	active_instance_extensions << instance_extension_required

	mut active_instance_layers := [
		// $if debug ? {
		// 	c'VK_LAYER_KHRONOS_validation'
		// },
	] & char{}

	mut app_info := vk.ApplicationInfo{
		pApplicationName: c'Example'
		pEngineName:      c'Example'
		engineVersion:    vk.api_version_1_3
		apiVersion:       vk.api_version_1_3
	}

	mut instance_create_info := vk.InstanceCreateInfo{
		pApplicationInfo:        &app_info
		enabledLayerCount:       u32(active_instance_layers.len)
		/*pp_enabled_layer_names:     if active_instance_layers.len > 0 {
			active_instance_layers.data
		} else {
			unsafe { nil }
		}*/
		ppEnabledLayerNames:     active_instance_layers.data
		enabledExtensionCount:   u32(active_instance_extensions.len)
		/*pp_enabled_extension_names: if active_instance_extensions.len > 0 {
			active_instance_extensions.data
		} else {
			unsafe { nil }
		}*/
		ppEnabledExtensionNames: active_instance_extensions.data
	}
	// $if debug ? {
	// 	mut debug_utils_create_info := vk.DebugUtilsMessengerCreateInfoEXT{
	// 		message_severity:  vk.DebugUtilsMessageSeverityFlagBitsEXT.error_bit_ext | vk.DebugUtilsMessageSeverityFlagBitsEXT.warning_bit_ext
	// 		message_type:      vk.DebugUtilsMessageTypeFlagBitsEXT.validation_bit_ext | vk.DebugUtilsMessageTypeFlagBitsEXT.performance_bit_ext
	// 		pfn_user_callback: vulkan_debug_callback
	// 	}
	// 	instance_create_info.p_next = &debug_utils_create_info
	// }
	res := vk.create_instance(&instance_create_info, unsafe { nil }, ctx.vk_instance)
	if res != vk.Result.success {
		panic('Could not create vkInstance')
	}

	// $if debug ? {
	// 	resdbg := vk.create_debug_utils_messenger_ext(ctx.vk_instance, &debug_utils_create_info,
	// 		unsafe { nil }, &ctx.debug_utils)
	// 	if resdbg != vk.Result.success {
	// 		panic('Could not create DebugUtilsMessengerEXT')
	// 	}
	// }
	return true
}

pub fn (mut ctx DeviceContext) enumerate_gpus() {
	mut gpu_count := u32(0)

	vk.enumerate_physical_devices(ctx.vk_instance, &gpu_count, unsafe { nil })
	vk.enumerate_physical_devices(ctx.vk_instance, &gpu_count, ctx.gpus.data)

	ctx.physical_device_memory_props = []vk.PhysicalDeviceMemoryProperties2{len: int(gpu_count)}
	for i in 0 .. gpu_count {
		vk.get_physical_device_memory_properties2(ctx.gpus[i], &ctx.physical_device_memory_props[i])
	}
}

pub fn (ctx DeviceContext) get_memory_type_index(reqs vk.MemoryRequirements2, flags vk.MemoryPropertyFlags) u32 {
	mut request_bits := reqs.memoryRequirements.memoryTypeBits
	memory_props := ctx.physical_device_memory_props[ctx.use_gpu_index].memoryProperties
	for i in 0 .. memory_props.memoryTypeCount {
		// Match wanted memory properties
		if (int(request_bits) & 1) != 0 {
			types := memory_props.memoryTypes[i]
			if (types.propertyFlags & flags) == flags {
				return i
			}
		}
		request_bits >>= 1
	}
	return max_u32
}

pub fn (ctx DeviceContext) get_gpu(gpu_index int) C.VkPhysicalDevice {
	return ctx.gpus[gpu_index]
}

pub fn (ctx DeviceContext) get_gpu_current() C.VkPhysicalDevice {
	return ctx.gpus[ctx.use_gpu_index]
}

pub fn (ctx DeviceContext) get_vk_device() C.VkDevice {
	return ctx.vk_device
}
