module video_decode_app

import vulkan as vk
import math
import glfw

pub struct Swapchain {
mut:
	swapchain     vk.SwapchainKHR = unsafe { nil }
	present_mode  vk.PresentModeKHR = vk.PresentModeKHR.fifo
	images        []vk.Image
	current_index u32 = u32(0)
pub mut:
	image_views              []vk.ImageView
	app                      &VideoDecodeApp = unsafe { nil } // @[required]
	surface                  vk.SurfaceKHR = unsafe { nil }
	sampler_ycbcr_conversion vk.SamplerYcbcrConversion = unsafe { nil }
	surface_format           vk.SurfaceFormatKHR = vk.SurfaceFormatKHR{
		format: vk.Format.undefined
		colorSpace: vk.ColorSpaceKHR.srgb_nonlinear
	}
	image_count              u32 = u32(2)
	extent_2d                vk.Extent2D
}

pub fn (mut sc Swapchain) initialize_surface(window_p &glfw.Window) {
	if !isnil(sc.surface) {
		return
	}
	device_context := sc.app.device_context
	res := glfw.create_window_surface(device_context.vk_instance, window_p, unsafe { nil }, &sc.surface)
	if res != vk.Result.success {
		panic('Could not create glfw window surface')
	}
}

pub fn (mut sc Swapchain) initialize(window_p &glfw.Window, desired_format vk.Format) bool {
	sc.initialize_surface(window_p)
	mut n := unsafe { nil }
	device_context := sc.app.device_context
	mut surface_caps := vk.SurfaceCapabilitiesKHR{}
	vk.get_physical_device_surface_capabilities_khr(device_context.get_gpu_current(), sc.surface, mut &surface_caps)

	mut swapchain_size := vk.Extent2D{1280, 720}
	if surface_caps.currentExtent.width != max_u32 {
		swapchain_size = surface_caps.currentExtent
	}
	// Vulkan requires at least the surface minimum; a non-zero maximum is an
	// upper bound rather than the preferred count.
	sc.image_count = math.max[u32](surface_caps.minImageCount, 2)
	if surface_caps.maxImageCount > 0 {
		sc.image_count = math.min[u32](sc.image_count, surface_caps.maxImageCount)
	}

	mut surface_count := u32(0)
	result := vk.get_physical_device_surface_formats_khr(device_context.get_gpu_current(), sc.surface, &surface_count, mut n)
	if result != .success || surface_count == 0 {
		panic('Could not enumerate Vulkan surface formats: ${result}')
	}

	// Find and store desired format
	mut formats := []vk.SurfaceFormatKHR{len: int(surface_count)}
	mut p_formats := formats.data
	formats_result := vk.get_physical_device_surface_formats_khr(device_context.get_gpu_current(), sc.surface, &surface_count, mut p_formats)
	if formats_result != .success {
		panic('Could not read Vulkan surface formats: ${formats_result}')
	}
	for format in formats {
		if format.format == desired_format {
			sc.surface_format = format
			break
		}
	}

	if sc.surface_format.format == vk.Format.undefined {
		for format in formats {
			if format.colorSpace == vk.ColorSpaceKHR.srgb_nonlinear {
				sc.surface_format = format
				break
			}
		}
		if sc.surface_format.format == vk.Format.undefined {
			sc.surface_format = formats[0]
		}
	}
	println('Swapchain format: ${sc.surface_format.format}, color space ${sc.surface_format.colorSpace}')

	return sc.resize(swapchain_size)
}

pub fn (mut sc Swapchain) resize(extent vk.Extent2D) bool {
	device_context := sc.app.device_context
	mut surface_caps := vk.SurfaceCapabilitiesKHR{}
	vk.get_physical_device_surface_capabilities_khr(device_context.get_gpu_current(), sc.surface, mut &surface_caps)
	mut actual_extent := extent
	if surface_caps.currentExtent.width != max_u32 {
		actual_extent = surface_caps.currentExtent
	} else {
		actual_extent.width = math.max(surface_caps.minImageExtent.width, math.min(actual_extent.width, surface_caps.maxImageExtent.width))
		actual_extent.height = math.max(surface_caps.minImageExtent.height, math.min(actual_extent.height, surface_caps.maxImageExtent.height))
	}
	mut old_swapchain := sc.swapchain
	mut swapchain_ci := vk.SwapchainCreateInfoKHR{
		surface: sc.surface
		minImageCount: sc.image_count
		imageFormat: sc.surface_format.format
		imageColorSpace: sc.surface_format.colorSpace
		imageExtent: actual_extent
		imageArrayLayers: 1
		imageUsage: vk.ImageUsageFlags(vk.ImageUsageFlagBits.color_attachment)
		imageSharingMode: vk.SharingMode.exclusive
		preTransform: surface_caps.currentTransform
		compositeAlpha: vk.CompositeAlphaFlagBitsKHR.opaque
		presentMode: sc.present_mode
		clipped: vk._true
		oldSwapchain: old_swapchain
	}

	vk_device := device_context.vk_device
	res := vk.create_swapchain_khr(vk_device, &swapchain_ci, unsafe { nil }, &sc.swapchain)
	if res != vk.Result.success {
		panic('Could not vk.create_swapchain_khr: ${res}')
		return false
	}

	if old_swapchain != unsafe { nil } {
		for mut view in sc.image_views {
			vk.destroy_image_view(vk_device, view, unsafe { nil })
		}
		vk.destroy_swapchain_khr(vk_device, old_swapchain, unsafe { nil })
	}
	mut image_count := u32(0)
	vk.get_swapchain_images_khr(vk_device, sc.swapchain, &image_count, unsafe { nil })
	sc.images = unsafe { []vk.Image{len: int(image_count)} }
	sc.image_views = unsafe { []vk.ImageView{len: int(image_count)} }
	vk.get_swapchain_images_khr(vk_device, sc.swapchain, &image_count, sc.images.data)
	sc.image_count = image_count
	for i in 0 .. image_count {
		mut view_ci := vk.ImageViewCreateInfo{
			image: sc.images[i]
			viewType: vk.ImageViewType._2d
			format: sc.surface_format.format
			components: vk.ComponentMapping{
				r: vk.ComponentSwizzle.r
				g: vk.ComponentSwizzle.g
				b: vk.ComponentSwizzle.b
				a: vk.ComponentSwizzle.a
			}
			subresourceRange: vk.ImageSubresourceRange{
				aspectMask: vk.ImageAspectFlags(vk.ImageAspectFlagBits.color)
				baseMipLevel: 0
				levelCount: 1
				baseArrayLayer: 0
				layerCount: 1
			}
		}
		view_result := vk.create_image_view(vk_device, &view_ci, unsafe { nil }, &sc.image_views[i])
		if view_result != .success {
			panic('Could not create swapchain image view ${i}: ${view_result}')
		}
	}
	sc.extent_2d = swapchain_ci.imageExtent

	return true
}

pub fn (sc Swapchain) get_handle() vk.SwapchainKHR {
	return sc.swapchain
}

pub fn (mut sc Swapchain) acquire_next_image(mut sem_present_complete vk.Semaphore) vk.Result {
	device_context := sc.app.device_context
	mut vk_device := device_context.get_vk_device()
	mut index := u32(0)
	res := vk.acquire_next_image_khr(vk_device, sc.swapchain, max_u64, sem_present_complete, unsafe { nil }, &index)
	if res != vk.Result.success && res != vk.Result.suboptimal_khr && res != vk.Result.error_out_of_date_khr {
		eprintln('Could not acquire_next_image_khr: ${res}')
		return res
	}
	if res != vk.Result.error_out_of_date_khr {
		sc.current_index = index
	}
	return res
}

pub fn (sc Swapchain) get_current_index() u32 {
	return sc.current_index
}

pub fn (mut sc Swapchain) shutdown() {
	device_context := sc.app.device_context
	mut vk_device := device_context.get_vk_device()
	// Image views must be released before the swapchain images they reference.
	for mut view in sc.image_views {
		vk.destroy_image_view(vk_device, view, unsafe { nil })
	}
	sc.image_views = []
	sc.images = []
	vk.destroy_swapchain_khr(vk_device, sc.swapchain, unsafe { nil })
	sc.swapchain = unsafe { nil }
}
