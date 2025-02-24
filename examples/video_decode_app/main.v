/*
  This program creates a window and prints a message on pressing Enter. Press ESC to exit.
  It provides examples for calling vulkan and glfw functions, using the bindings located at
  modules/vulkan/vulkan.v
*/

module video_decode_app

import src.vulkan as vk
import bindings.glfw

pub interface IApp {
	get_device_context() DeviceContext
}

@[heap]
struct VideoDecodeApp {
mut:
	device_context  DeviceContext
	reference_slots []int
	dpb_slot_graph  [18][]int
pub mut:
	window          C.GLFWwindow
	share_data      []string // some data to share between main() and glfw callback functions
	descriptor_pool C.VkDescriptorPool
}

pub fn (mut app VideoDecodeApp) initialize() bool {
	if !glfw.init() {
		return false
	}

	glfw.window_hint(glfw.client_api, glfw.no_api)
	glfw.window_hint(glfw.resizable, glfw.glfw_false)

	app.window = glfw.create_window(1280, 720, 'Example', unsafe { nil }, unsafe { nil })
	if app.window == 0 {
		return false
	}
	glfw.set_window_user_pointer(app.window, &app)
	app.device_context.initialize_device(0)
	app.device_context.initialize_swapchain(app, app.window, vk.Format.g8_b8r8_2plane420_unorm)

	descriptor_pool_sizes := [
		vk.DescriptorPoolSize{
			type:            vk.DescriptorType.uniform_buffer
			descriptorCount: 1000
		},
		vk.DescriptorPoolSize{
			type:            vk.DescriptorType.combined_image_sampler
			descriptorCount: 1000
		},
	]
	descriptor_pool_ci := vk.DescriptorPoolCreateInfo{
		maxSets:       100
		poolSizeCount: u32(descriptor_pool_sizes.len)
		pPoolSizes:    descriptor_pool_sizes.data
	}
	vk.create_descriptor_pool(app.device_context.vk_device, &descriptor_pool_ci, unsafe { nil },
		app.descriptor_pool)

	mut sampler_ci := vk.SamplerCreateInfo{
		magFilter:    vk.Filter.linear
		minFilter:    vk.Filter.linear
		mipmapMode:   vk.SamplerMipmapMode.linear
		addressModeU: vk.SamplerAddressMode.clamp_to_edge
		addressModeV: vk.SamplerAddressMode.clamp_to_edge
		addressModeW: vk.SamplerAddressMode.clamp_to_edge
	}
	sampler_conversion_info := vk.SamplerYcbcrConversionInfo{
		conversion: app.device_context.sampler_ycbcr_conversion
	}
	sampler_ci.pNext = &sampler_conversion_info
	vk.create_sampler(app.device_context.vk_device, &sampler_ci, unsafe { nil }, &app.device_context.sampler)

	// imgui

	return true
}

fn init_app(window C.GLFWwindow) VideoDecodeApp {
	mut new_app := VideoDecodeApp{
		window:         unsafe { window }
		share_data:     []
		device_context: DeviceContext{
			swapchain: Swapchain{
				app: unsafe { nil }
			}
		}
	}
	// Note: Please make sure to set the IApp struct member
	new_app.device_context.swapchain.app = &new_app
	return new_app
}

fn main() {
	/*
  mut app := VideoDecodeApp{ device_context: DeviceContext{swapchain: Swapchain{app:unsafe{nil}}}}
  app.device_context.swapchain.app = &app
  if app.initialize(){
		app.run()
		app.shutdown()
  }
  */
	println('123')
}

fn (mut app VideoDecodeApp) run() {
	unsafe { app.reference_slots.grow_len(300) }
	for graph in app.dpb_slot_graph {
		unsafe { graph.grow_len(300) }
	}
}

// Called on a keyboard event
// GLFW_PRESS, GLFW_RELEASE or GLFW_REPEAT
// https://www.glfw.org/docs/latest/group__keys.html
fn key_callback_function(window C.GLFWwindow, key int, scancode int, action int, mods int) {
	if action == glfw.press {
		// get user data pointer from glfw.window
		mut app := unsafe { &VideoDecodeApp(glfw.get_user_pointer(window)) }
		if key == glfw.key_enter {
			txt := 'Enter key pressed'
			app.share_data << txt
		}
		if key == glfw.key_escape {
			unsafe { glfw.set_should_close(window, 1) }
		}
	}
}

// NOTE: array d is consumed/freed
fn to_v_array[T](d &T, len u32) []T {
	mut ret := unsafe { []T{len: int(len)} }
	for i in 0 .. len {
		unsafe {
			ret[i] = d[i]
		}
	}
	unsafe {
		free(d)
	}
	return ret
}

pub fn (app VideoDecodeApp) get_device_context() DeviceContext {
	return app.device_context
}
