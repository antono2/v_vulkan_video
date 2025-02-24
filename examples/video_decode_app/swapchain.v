module video_decode_app


import src.vulkan as vk
import math
import bindings.glfw

pub struct Swapchain {
mut:
	app            &IApp @[required]
	swapchain      C.VkSwapchainKHR
	image_count    u32                 = 2
	surface_format vk.SurfaceFormatKHR = vk.SurfaceFormatKHR{
		format:     vk.Format.undefined
		colorSpace: vk.ColorSpaceKHR.srgb_nonlinear_khr
	}
	present_mode   vk.PresentModeKHR
	image_views    []C.VkImageView
	images         []C.VkImage
	extent_2d      vk.Extent2D
	current_index  u32 = u32(0)
pub mut:
	surface C.VkSurfaceKHR
}

pub fn (mut sc Swapchain) initialize(window C.GLFWwindow, desired_format vk.Format) bool {
	device_context := sc.app.get_device_context()
	res := glfw.create_window_surface(device_context.vk_instance, window, unsafe { nil },
		sc.surface)
	if res != vk.Result.success {
		panic('Could not create glfw window surface')
	}
	mut surface_caps := vk.SurfaceCapabilitiesKHR{}
	vk.get_physical_device_surface_capabilities_khr(device_context.get_gpu_current(),
		sc.surface, &surface_caps)

	mut swapchain_size := vk.Extent2D{1280, 720}
	if surface_caps.currentExtent.width != u32(0xFFFF) {
		swapchain_size = surface_caps.currentExtent
	}
	sc.image_count = math.min[u32](surface_caps.minImageCount, u32(2))

	mut surface_count := u32(0)
	vk.get_physical_device_surface_formats_khr(device_context.get_gpu_current(), sc.surface,
		&surface_count, unsafe { nil })

	// Find and store desired format
	mut formats := []vk.SurfaceFormatKHR{len: int(surface_count)}
	for format in formats {
		if format.format == desired_format {
			sc.surface_format = format
			break
		}
	}

	return sc.resize(swapchain_size)
}

pub fn (mut sc Swapchain) resize(extent vk.Extent2D) bool {
	old_swapchain := sc.swapchain
	swapchain_ci := vk.SwapchainCreateInfoKHR{
		surface:          sc.surface
		minImageCount:    sc.image_count
		imageFormat:      sc.surface_format.format
		imageColorSpace:  sc.surface_format.colorSpace
		imageExtent:      extent
		imageArrayLayers: 1
		imageUsage:       vk.ImageUsageFlags(vk.ImageUsageFlagBits.color_attachment_bit)
		imageSharingMode: vk.SharingMode.exclusive
		preTransform:     vk.SurfaceTransformFlagBitsKHR.identity_bit_khr
		compositeAlpha:   vk.CompositeAlphaFlagBitsKHR.opaque_bit_khr
		presentMode:      sc.present_mode
		clipped:          vk._true
		oldSwapchain:     old_swapchain
	}

	device_context := sc.app.get_device_context()
	vk_device := device_context.vk_device
	res := vk.create_swapchain_khr(vk_device, &swapchain_ci, unsafe { nil }, &sc.swapchain)
	if res != vk.Result.success {
		println('vk.create_swapchain_khr failed ${res}')
		return false
	}
	if old_swapchain != unsafe { nil } {
		for view in sc.image_views {
			vk.destroy_image_view(vk_device, view, unsafe { nil })
		}
		vk.destroy_swapchain_khr(vk_device, old_swapchain, unsafe { nil })
	}
	mut image_count := u32(0)
	vk.get_swapchain_images_khr(vk_device, sc.swapchain, &image_count, sc.images.data)
	for i in 0 .. image_count {
		view_ci := vk.ImageViewCreateInfo{
			image:            sc.images[i]
			viewType:         vk.ImageViewType._2d
			format:           sc.surface_format.format
			components:       vk.ComponentMapping{
				r: vk.ComponentSwizzle.r
				g: vk.ComponentSwizzle.g
				b: vk.ComponentSwizzle.b
				a: vk.ComponentSwizzle.a
			}
			subresourceRange: vk.ImageSubresourceRange{
				aspectMask:     vk.ImageAspectFlags(vk.ImageAspectFlagBits.color_bit)
				baseMipLevel:   0
				levelCount:     1
				baseArrayLayer: 0
				layerCount:     1
			}
		}
		vk.create_image_view(vk_device, &view_ci, unsafe { nil }, sc.image_views[i])
	}
	sc.extent_2d = swapchain_ci.imageExtent

	return true
}

pub fn (sc Swapchain) get_handle() C.VkSwapchainKHR {
	return sc.swapchain
}

pub fn (mut sc Swapchain) acquire_next_image(sem_present_complete C.VkSemaphore) vk.Result {
	device_context := sc.app.get_device_context()
	vk_device := device_context.get_vk_device()
	mut index := u32(0)
	res := vk.acquire_next_image_khr(vk_device, sc.swapchain, max_u64, sem_present_complete,
		unsafe { nil }, &index)
	if res != vk.Result.success {
		print('Could not acquire_next_image_khr ${res}')
		return res
	}
	sc.current_index = index
	return res
}

pub fn (sc Swapchain) get_current_index() u32 {
	return sc.current_index
}

pub fn (mut sc Swapchain) shutdown() {
	device_context := sc.app.get_device_context()
	vk_device := device_context.get_vk_device()
	vk.destroy_swapchain_khr(vk_device, sc.swapchain, unsafe { nil })

	sc.images = []
	for view in sc.image_views {
		vk.destroy_image_view(vk_device, view, unsafe { nil })
	}
	sc.image_views = []
	sc.swapchain = unsafe { nil }
}
