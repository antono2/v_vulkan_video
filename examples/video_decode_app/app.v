module video_decode_app

import vulkan as vk
import glfw
import imgui
import imgui.implot
import imgui.impl_vulkan
import imgui.impl_glfw
import time
import math

// #flag -DCIMGUI_NO_EXPORT=no
// #flag -DIMGUI_STATIC=yes
// #flag -DIMGUI_DISABLE_WIN32_FUNCTIONS
// #flag -DIMGUI_DISABLE_OSX_FUNCTIONS
// #flag -DCIMGUI_DEFINE_ENUMS_AND_STRUCTS=yes
// #flag -DIMGUI_USE_WCHAR32=yes
// #flag -DIMGUI_DEFINE_MATH_OPERATORS
// #flag -DIM_VEC2_CLASS_EXTRA=yes
// #flag -DCIMGUI_USE_GLFW=yes
// #flag -DIMGUI_HAS_DOCK=yes
// #flag -DIMGUI_STATIC=yes
// #flag -DCIMGUI_DEFINE_ENUMS_AND_STRUCTS=yes
// #flag -DCIMGUI_NO_EXPORT=no
// #flag -DIMGUI_DISABLE_WIN32_FUNCTIONS=yes
// #flag -DIMGUI_DISABLE_OSX_FUNCTIONS=yes
pub const v_modroot = @VMODROOT

@[heap]
pub struct VideoDecodeApp {
mut:
	reference_slots      []int
	dpb_slot_graph       [18][]int
	pipeline_layout      vk.PipelineLayout
	pipeline             vk.Pipeline
	frames               []FrameInfo
	sem_render_complete  vk.Semaphore
	sem_present_complete vk.Semaphore
	imgui_image_count    u32
	ds_layout            vk.DescriptorSetLayout
	video_player         VideoPlayer = VideoPlayer{}
	render_pass          vk.RenderPass
	sampler              vk.Sampler
pub mut:
	device_context  DeviceContext
	video_path      string
	preferred_gpu_index int = -1
	list_gpus      bool
	window_p        &glfw.Window = unsafe { nil }
	share_data      []string // some data to share between main() and glfw callback functions
	descriptor_pool vk.DescriptorPool
}

fn check_vk(result vk.Result, operation string) {
	if result != .success {
		panic('${operation}: ${result}')
	}
}

@[heap]
pub struct FrameInfo {
pub mut:
	command_pool       vk.CommandPool
	command_buffer     vk.CommandBuffer
	queue_submit_fence vk.Fence
	queue_index        u32
	framebuffer        vk.Framebuffer
	descriptor_set     vk.DescriptorSet
}

// Three vec4 values match the vertex shader's push-constant block without
// relying on compiler-specific struct padding.
pub struct VideoRenderTransform {
pub mut:
	values [12]f32
}

fn video_render_transform(metadata VideoMetadata, extent vk.Extent2D) VideoRenderTransform {
	mut result := VideoRenderTransform{}
	match metadata.rotation_degrees {
		-90 {
			// The track matrix rotates the stored image counter-clockwise. Texture
			// lookup uses the inverse transform from display space to source space.
			result.values[0] = 0
			result.values[1] = 1
			result.values[2] = 0
			result.values[4] = -1
			result.values[5] = 0
			result.values[6] = 1
		}
		90 {
			result.values[0] = 0
			result.values[1] = -1
			result.values[2] = 1
			result.values[4] = 1
			result.values[5] = 0
			result.values[6] = 0
		}
		180, -180 {
			result.values[0] = -1
			result.values[1] = 0
			result.values[2] = 1
			result.values[4] = 0
			result.values[5] = -1
			result.values[6] = 1
		}
		else {
			result.values[0] = 1
			result.values[1] = 0
			result.values[2] = 0
			result.values[4] = 0
			result.values[5] = 1
			result.values[6] = 0
		}
	}
	mut scale_x := f32(1)
	mut scale_y := f32(1)
	if metadata.display_width > 0 && metadata.display_height > 0 && extent.width > 0 && extent.height > 0 {
		video_aspect := f32(metadata.display_width) / f32(metadata.display_height)
		surface_aspect := f32(extent.width) / f32(extent.height)
		if video_aspect > surface_aspect {
			scale_y = surface_aspect / video_aspect
		} else {
			scale_x = video_aspect / surface_aspect
		}
	}
	result.values[8] = scale_x
	result.values[9] = scale_y
	return result
}

pub fn (mut app VideoDecodeApp) initialize() bool {
	println('Initializing')
	if !glfw.initialize() {
		println('Could not initialize glfw')
		return false
	}

	glfw.window_hint(glfw.client_api, glfw.no_api)
	glfw.window_hint(glfw.resizable, glfw._true)

	app.window_p = glfw.create_window(1280, 720, 'Vulkan Video Player', unsafe { nil }, unsafe { nil })
	if isnil(app.window_p) {
		println('app.window_p is nil')
		return false
	}
	glfw.set_window_user_pointer(app.window_p, &app)
	// Swapchain methods need the owning context for the Vulkan device and
	// instance. Set this before any surface or swapchain call.
	app.device_context.swapchain.app = &app
	app.device_context.initialize()
	app.device_context.swapchain.initialize_surface(app.window_p)
	// Parse the stream before GPU selection so capability probing uses the
	// video's actual H.264 profile rather than a hard-coded default.
	video_path := if app.video_path != '' {
		app.video_path
	} else {
		'${v_modroot}/res/20240917_095400.mp4'
	}
	println('Video input: ${video_path}')
	app.video_player.prepare(video_path) or {
		eprintln('Could not read ${video_path}: ${err}')
		app.abort_initialization()
		return false
	}
	h264_profile_idc := app.video_player.h264_profile_idc()
	video_metadata := app.video_player.metadata()
	diagnostics := app.device_context.h264_decode_gpu_diagnostics(h264_profile_idc)
	if app.list_gpus {
		println('Vulkan devices for H.264 ${h264_profile_name(h264_profile_idc)} Profile:')
		for index, diagnostic in diagnostics {
			println('  [${index}] ${diagnostic}')
		}
		app.abort_initialization()
		return false
	}
	mut gpu_index := u32(0)
	if app.preferred_gpu_index >= 0 {
		if app.preferred_gpu_index >= app.device_context.gpu_count() {
			eprintln('GPU index ${app.preferred_gpu_index} is out of range; found ${app.device_context.gpu_count()} Vulkan device(s).')
			app.abort_initialization()
			return false
		}
		if !app.device_context.is_h264_decode_gpu_compatible(app.preferred_gpu_index, h264_profile_idc) {
			eprintln('GPU [${app.preferred_gpu_index}] cannot play this video: ${diagnostics[app.preferred_gpu_index]}')
			app.abort_initialization()
			return false
		}
		gpu_index = u32(app.preferred_gpu_index)
	} else {
		gpu_index = app.device_context.find_h264_decode_gpu(h264_profile_idc) or {
		eprintln('No Vulkan device provides presentation, graphics, and H.264 ${h264_profile_name(h264_profile_idc)} Profile decode support.')
		for diagnostic in diagnostics {
			eprintln('  ${diagnostic}')
		}
		eprintln('Required device extensions: VK_KHR_video_queue, VK_KHR_video_decode_queue, VK_KHR_video_decode_h264')
		app.abort_initialization()
		return false
		}
	}
	app.device_context.initialize_device(gpu_index, h264_profile_idc, video_metadata)
	// YCbCr sampling produces display-encoded R'G'B' values. Store those values
	// in an UNORM swapchain; an sRGB attachment would encode them a second time
	// and visibly lift shadows and midtones.
	if !app.device_context.initialize_swapchain(app.window_p, vk.Format.b8g8r8a8_unorm) {
		panic('Could not initialize the Vulkan swapchain')
	}
	dev_ctx := app.device_context
	vk_device := dev_ctx.vk_device

	descriptor_pool_sizes := [
		vk.DescriptorPoolSize{
			type: vk.DescriptorType.uniform_buffer
			descriptorCount: 1000
		},
		vk.DescriptorPoolSize{
			type: vk.DescriptorType.combined_image_sampler
			descriptorCount: 1000
		},
	]
	descriptor_pool_ci := vk.DescriptorPoolCreateInfo{
		flags: vk.DescriptorPoolCreateFlags(vk.DescriptorPoolCreateFlagBits.free_descriptor_set)
		maxSets: 100
		poolSizeCount: u32(descriptor_pool_sizes.len)
		pPoolSizes: descriptor_pool_sizes.data
	}
	check_vk(vk.create_descriptor_pool(app.device_context.vk_device, &descriptor_pool_ci, unsafe { nil }, &app.descriptor_pool), 'Could not create descriptor pool')

	mut sampler_ci := vk.SamplerCreateInfo{
		magFilter: vk.Filter.linear
		minFilter: vk.Filter.linear
		mipmapMode: vk.SamplerMipmapMode.linear
		addressModeU: vk.SamplerAddressMode.clamp_to_edge
		addressModeV: vk.SamplerAddressMode.clamp_to_edge
		addressModeW: vk.SamplerAddressMode.clamp_to_edge
	}
	sampler_conversion_info := vk.SamplerYcbcrConversionInfo{
		conversion: app.device_context.sampler_ycbcr_conversion
	}
	sampler_ci.pNext = &sampler_conversion_info
	check_vk(vk.create_sampler(app.device_context.vk_device, &sampler_ci, unsafe { nil }, &app.sampler), 'Could not create video sampler')

	// ImGui
	// # IMGUI_CHECKVERSION();
	_ := imgui.create_context(unsafe { nil })
	imgui.style_colors_dark(unsafe { nil })
	implot.create_context()

	if !impl_glfw.init_for_vulkan(app.window_p, true) {
		panic('Could not initialize the ImGui GLFW backend')
	}
	impl_vulkan.load_functions(vk.api_version_1_3, loader_function_callback, &app)
	ds_layouts := [
		vk.DescriptorSetLayoutBinding{
			binding: 0
			descriptorType: vk.DescriptorType.uniform_buffer
			descriptorCount: 1
			stageFlags: vk.ShaderStageFlags(vk.ShaderStageFlagBits.all_graphics)
		},
		vk.DescriptorSetLayoutBinding{
			binding: 1
			descriptorType: vk.DescriptorType.combined_image_sampler
			descriptorCount: 1
			stageFlags: vk.ShaderStageFlags(vk.ShaderStageFlagBits.all_graphics)
			pImmutableSamplers: &app.sampler
		},
	]
	ds_layout_ci := vk.DescriptorSetLayoutCreateInfo{
		bindingCount: u32(ds_layouts.len)
		pBindings: ds_layouts.data
	}
	check_vk(vk.create_descriptor_set_layout(app.device_context.vk_device, &ds_layout_ci, unsafe { nil }, &app.ds_layout), 'Could not create descriptor-set layout')

	app.initialize_render_pass()
	app.initialize_pipeline()
	app.initialize_framebuffers()

	app.initialize_imgui_vulkan_backend()
	app.video_player.initialize(app)

	semaphore_ci := vk.SemaphoreCreateInfo{}
	check_vk(vk.create_semaphore(vk_device, &semaphore_ci, unsafe { nil }, &app.sem_render_complete), 'Could not create render-complete semaphore')
	check_vk(vk.create_semaphore(vk_device, &semaphore_ci, unsafe { nil }, &app.sem_present_complete), 'Could not create presentation semaphore')

	return true
}

fn (mut app VideoDecodeApp) initialize_imgui_vulkan_backend() {
	dev_ctx := app.device_context
	mut vk_info := impl_vulkan.InitInfo{
		api_version: vk.api_version_1_3
		instance: dev_ctx.vk_instance
		physical_device: dev_ctx.get_gpu_current()
		device: dev_ctx.vk_device
		queue_family: dev_ctx.graphics_family
		queue: dev_ctx.get_queue(.graphics)
		descriptor_pool: app.descriptor_pool
		min_image_count: 2
		image_count: dev_ctx.swapchain.image_count
		pipeline_info_main: impl_vulkan.PipelineInfo{
			render_pass: app.render_pass
			msaa_samples: vk.SampleCountFlagBits._1
		}
	}
	unsafe {
		vk_info.custom_shader_vert_create_info.sType = vk.StructureType(0)
		vk_info.custom_shader_frag_create_info.sType = vk.StructureType(0)
	}
	if !impl_vulkan.vkinit(&vk_info) {
		panic('Could not initialize the ImGui Vulkan backend')
	}
	app.imgui_image_count = dev_ctx.swapchain.image_count
}

pub fn loader_function_callback(function_name &char, user_data voidptr) voidptr {
	app := unsafe { &VideoDecodeApp(user_data) }
	dev_func_addr := vk.get_device_proc_addr(app.device_context.vk_device, function_name)
	if !isnil(dev_func_addr) {
		return dev_func_addr
	}
	instance_func_addr := vk.get_instance_proc_addr(app.device_context.vk_instance, function_name)
	if !isnil(instance_func_addr) {
		return instance_func_addr
	}
	return unsafe { nil }
}

pub fn (mut app VideoDecodeApp) run() {
	app.reference_slots.ensure_cap(300)
	for mut graph in app.dpb_slot_graph {
		graph.ensure_cap(300)
	}
	mut prev_time := time.now()
	for !glfw.window_should_close(app.window_p) && glfw.get_key(app.window_p, glfw.key_escape) == glfw.release {
		glfw.poll_events()

		// Keep playback timing in nanoseconds. Converting a sub-second frame
		// interval to i64 seconds made almost every update zero and advanced the
		// decoder at the render-loop rate instead of the MP4 track rate.
		time_elapsed_ns := math.min(time.since(prev_time).nanoseconds(), i64(500_000_000))
		prev_time = time.now()

		mut res := app.device_context.swapchain.acquire_next_image(mut app.sem_present_complete)
		if res == vk.Result.error_out_of_date_khr {
			app.recreate_swapchain()
			continue
		}
		if res != vk.Result.success && res != vk.Result.suboptimal_khr {
			panic('Could not acquire a swapchain image: ${res}')
		}

		// Start the UI frame only after acquisition succeeds, so an out-of-date
		// swapchain cannot leave ImGui with an unfinished frame.
		impl_glfw.new_frame()
		impl_vulkan.new_frame()
		imgui.new_frame()

		mut frame := FrameInfo{}
		app.begin_frame(mut frame)
		begin_info := vk.CommandBufferBeginInfo{}
		res = vk.begin_command_buffer(frame.command_buffer, &begin_info)
		if res != vk.Result.success {
			panic('Could not begin graphics command buffer: ${res}')
		}

		// Record and submit the next Vulkan Video decode operation. The player
		// signals its event once the decoded frame is ready for graphics work.
		app.video_player.update(frame.command_buffer, time_elapsed_ns)
		mut image_info := vk.DescriptorImageInfo{
			imageView: app.video_player.output_image.view
			imageLayout: .shader_read_only_optimal
		}
		write_descriptor := vk.WriteDescriptorSet{
			dstSet: frame.descriptor_set
			dstBinding: 1
			descriptorCount: 1
			descriptorType: .combined_image_sampler
			pImageInfo: &image_info
		}
		vk.update_descriptor_sets(app.device_context.vk_device, 1, &write_descriptor, 0, unsafe { nil })

		// Finish the Dear ImGui frame before starting the next one. The previous
		// loop left every frame open, which triggers ImGui's frame-sanity assert.
		imgui.render()
		mut clear_value := vk.ClearValue{}
		clear_value.color.float32[0] = 0.08
		clear_value.color.float32[1] = 0.08
		clear_value.color.float32[2] = 0.10
		clear_value.color.float32[3] = 1.0
		render_pass_begin := vk.RenderPassBeginInfo{
			renderPass: app.render_pass
			framebuffer: frame.framebuffer
			renderArea: vk.Rect2D{
				extent: app.device_context.swapchain.extent_2d
			}
			clearValueCount: 1
			pClearValues: &clear_value
		}
		vk.cmd_begin_render_pass(frame.command_buffer, &render_pass_begin, .inline)
		vk.cmd_bind_pipeline(frame.command_buffer, .graphics, app.pipeline)
		vk.cmd_bind_descriptor_sets(frame.command_buffer, .graphics, app.pipeline_layout, 0, 1, &frame.descriptor_set, 0, unsafe { nil })
		extent := app.device_context.swapchain.extent_2d
		mut metadata := VideoMetadata{}
		rlock app.video_player.decoder {
			metadata = app.video_player.decoder.video_data.metadata
		}
		mut video_transform := video_render_transform(metadata, extent)
		vk.cmd_push_constants(frame.command_buffer, app.pipeline_layout, vk.ShaderStageFlags(vk.ShaderStageFlagBits.vertex), 0, u32(sizeof(VideoRenderTransform)), &video_transform)
		viewport := vk.Viewport{
			width: f32(extent.width)
			height: f32(extent.height)
			maxDepth: 1
		}
		scissor := vk.Rect2D{
			extent: extent
		}
		vk.cmd_set_viewport(frame.command_buffer, 0, 1, &viewport)
		vk.cmd_set_scissor(frame.command_buffer, 0, 1, &scissor)
		vk.cmd_draw(frame.command_buffer, 4, 1, 0, 0)
		impl_vulkan.render_draw_data(imgui.get_draw_data(), frame.command_buffer, unsafe { nil })
		vk.cmd_end_render_pass(frame.command_buffer)

		res = vk.end_command_buffer(frame.command_buffer)
		if res != vk.Result.success {
			panic('Could not end graphics command buffer: ${res}')
		}
		mut wait_stage := vk.PipelineStageFlags(vk.PipelineStageFlagBits.color_attachment_output)
		submit_info := vk.SubmitInfo{
			waitSemaphoreCount: 1
			pWaitSemaphores: &app.sem_present_complete
			pWaitDstStageMask: &wait_stage
			commandBufferCount: 1
			pCommandBuffers: &frame.command_buffer
			signalSemaphoreCount: 1
			pSignalSemaphores: &app.sem_render_complete
		}
		res = vk.queue_submit(app.device_context.get_queue(.graphics), 1, &submit_info, frame.queue_submit_fence)
		if res != vk.Result.success {
			panic('Could not submit graphics command buffer: ${res}')
		}
		present_result := app.device_context.present([app.sem_render_complete])
		if present_result == vk.Result.error_out_of_date_khr || present_result == vk.Result.suboptimal_khr {
			app.recreate_swapchain()
		} else if present_result != vk.Result.success {
			panic('Could not present a swapchain image: ${present_result}')
		}
	}
}

fn (mut app VideoDecodeApp) recreate_swapchain() bool {
	mut width := i32(0)
	mut height := i32(0)
	glfw.get_framebuffer_size(app.window_p, &width, &height)
	// A minimized window has no drawable surface. GLFW will deliver another
	// resize/out-of-date event once it becomes visible again.
	if width <= 0 || height <= 0 {
		return false
	}
	app.device_context.wait_for_idle()
	for mut frame in app.frames {
		app.teardown_per_frame(mut frame)
	}
	app.frames.clear()
	if !app.device_context.swapchain.resize(vk.Extent2D{
		width: u32(width)
		height: u32(height)
	}) {
		return false
	}
	app.initialize_framebuffers()
	app.video_player.recreate_swapchain_resources()
	if app.imgui_image_count != app.device_context.swapchain.image_count {
		// This backend cannot change its image count in place; rebuild only when
		// the driver actually returned a different number of swapchain images.
		impl_vulkan.shutdown()
		app.initialize_imgui_vulkan_backend()
	}
	println('Resized swapchain to ${width}x${height} (${app.device_context.swapchain.image_count} images)')
	return true
}

// Called on a keyboard event
// GLFW_PRESS, GLFW_RELEASE or GLFW_REPEAT
// https://www.glfw.org/docs/latest/group__keys.html
fn key_function_callback(window_p &glfw.Window, key int, _scancode int, action int, _mods int) {
	if action == glfw.press {
		// get user data pointer from glfw.Window
		mut app := unsafe { &VideoDecodeApp(glfw.get_user_pointer(window_p)) }
		if key == glfw.key_enter {
			txt := 'Enter key pressed'
			app.share_data << txt
		}
		if key == glfw.key_escape {
			unsafe { glfw.set_should_close(window_p, 1) }
		}
	}
}

pub fn (mut app VideoDecodeApp) shutdown() {
	mut dev_ctx := app.device_context
	vk_device := dev_ctx.get_vk_device()
	vk.device_wait_idle(vk_device)
	app.video_player.shutdown()
	app.video_player.close_input()
	impl_vulkan.shutdown()
	impl_glfw.shutdown()
	if !isnil(app.pipeline) {
		vk.destroy_pipeline(vk_device, app.pipeline, unsafe { nil })
		app.pipeline = unsafe { nil }
	}
	if !isnil(app.pipeline_layout) {
		vk.destroy_pipeline_layout(vk_device, app.pipeline_layout, unsafe { nil })
		app.pipeline_layout = unsafe { nil }
	}
	app.teardown_framebuffers()
	for mut frame in app.frames {
		app.teardown_per_frame(mut frame)
	}
	app.frames.clear()
	if !isnil(app.ds_layout) {
		vk.destroy_descriptor_set_layout(vk_device, app.ds_layout, unsafe { nil })
		app.ds_layout = unsafe { nil }
	}
	if !isnil(app.sampler) {
		vk.destroy_sampler(vk_device, app.sampler, unsafe { nil })
		app.sampler = unsafe { nil }
	}
	if !isnil(app.descriptor_pool) {
		vk.destroy_descriptor_pool(vk_device, app.descriptor_pool, unsafe { nil })
		app.descriptor_pool = unsafe { nil }
	}

	vk.destroy_semaphore(vk_device, app.sem_render_complete, unsafe { nil })
	vk.destroy_semaphore(vk_device, app.sem_present_complete, unsafe { nil })
	app.sem_render_complete = unsafe { nil }
	app.sem_present_complete = unsafe { nil }

	if !isnil(app.render_pass) {
		vk.destroy_render_pass(vk_device, app.render_pass, unsafe { nil })
		app.render_pass = unsafe { nil }
	}
	implot.destroy_context(implot.get_current_context())
	imgui.destroy_context(imgui.get_current_context())

	dev_ctx.shutdown()
	if !isnil(app.window_p) {
		glfw.destroy_window(app.window_p)
		app.window_p = unsafe { nil }
	}
	glfw.terminate()
}

fn (mut app VideoDecodeApp) abort_initialization() {
	app.video_player.close_input()
	app.device_context.shutdown_instance_resources()
	if !isnil(app.window_p) {
		glfw.destroy_window(app.window_p)
		app.window_p = unsafe { nil }
	}
	glfw.terminate()
}

fn (mut app VideoDecodeApp) teardown_per_frame(mut frame_info FrameInfo) {
	vk_device := app.device_context.get_vk_device()
	if !isnil(frame_info.descriptor_set) {
		result := vk.free_descriptor_sets(vk_device, app.descriptor_pool, 1, &frame_info.descriptor_set)
		assert result == .success
		frame_info.descriptor_set = unsafe { nil }
	}
	if !isnil(frame_info.queue_submit_fence) {
		vk.destroy_fence(vk_device, frame_info.queue_submit_fence, unsafe { nil })
		frame_info.queue_submit_fence = unsafe { nil }
	}
	if !isnil(frame_info.command_buffer) {
		vk.free_command_buffers(vk_device, &frame_info.command_pool, 1, &frame_info.command_buffer)
		frame_info.command_buffer = unsafe { nil }
	}
	if !isnil(frame_info.command_pool) {
		vk.destroy_command_pool(vk_device, frame_info.command_pool, unsafe { nil })
		frame_info.command_pool = unsafe { nil }
	}
	if !isnil(frame_info.framebuffer) {
		vk.destroy_framebuffer(vk_device, frame_info.framebuffer, unsafe { nil })
		frame_info.framebuffer = unsafe { nil }
	}

	frame_info.queue_index = 0
}

fn (mut app VideoDecodeApp) teardown_framebuffers() {
	app.device_context.wait_for_idle()
	vk_device := app.device_context.get_vk_device()
	for mut frame in app.frames {
		vk.destroy_framebuffer(vk_device, frame.framebuffer, unsafe { nil })
		frame.framebuffer = unsafe { nil }
	}
}

fn (mut app VideoDecodeApp) begin_frame(mut frame FrameInfo) {
	index := app.device_context.swapchain.get_current_index()
	vk_device := app.device_context.get_vk_device()
	frame = app.frames[index]
	if frame.queue_submit_fence != unsafe { nil } {
		vk.wait_for_fences(vk_device, 1, &frame.queue_submit_fence, vk._true, max_u64)
		vk.reset_fences(vk_device, 1, &frame.queue_submit_fence)
	}
	if frame.command_pool != unsafe { nil } {
		vk.reset_command_pool(vk_device, frame.command_pool, 0)
	}
}

fn (mut app VideoDecodeApp) initialize_render_pass() {
	dev_ctx := app.device_context
	vk_device := dev_ctx.vk_device

	mut attachment := vk.AttachmentDescription{
		// flags: vk.AttachmentDescriptionFlags(vk.AttachmentDescriptionFlagBits.may_alias)
		format: dev_ctx.swapchain.surface_format.format
		samples: vk.SampleCountFlagBits._1
		loadOp: vk.AttachmentLoadOp.clear
		storeOp: vk.AttachmentStoreOp.store
		stencilLoadOp: vk.AttachmentLoadOp.dont_care
		stencilStoreOp: vk.AttachmentStoreOp.dont_care
		initialLayout: vk.ImageLayout.undefined
		finalLayout: vk.ImageLayout.present_src_khr
	}

	mut color_ref := vk.AttachmentReference{
		attachment: 0
		layout: vk.ImageLayout.color_attachment_optimal
	}

	mut subpass := vk.SubpassDescription{
		pipelineBindPoint: vk.PipelineBindPoint.graphics
		colorAttachmentCount: 1
		pColorAttachments: &color_ref
	}

	mut dependency := vk.SubpassDependency{
		srcSubpass: vk.subpass_external
		dstSubpass: 0
		srcStageMask: vk.PipelineStageFlags(vk.PipelineStageFlagBits.color_attachment_output)
		dstStageMask: vk.PipelineStageFlags(vk.PipelineStageFlagBits.color_attachment_output)
		srcAccessMask: 0
		dstAccessMask: vk.AccessFlags(u32(vk.AccessFlagBits.color_attachment_read) | u32(vk.AccessFlagBits.color_attachment_write))
	}

	rp_info := vk.RenderPassCreateInfo{
		attachmentCount: 1
		pAttachments: &attachment
		subpassCount: 1
		pSubpasses: &subpass
		dependencyCount: 1
		pDependencies: &dependency
	}

	check_vk(vk.create_render_pass(vk_device, &rp_info, unsafe { nil }, &app.render_pass), 'Could not create render pass')
}

@[heap]
pub struct ShaderModuleHeap {
pub mut:
	shader_module vk.ShaderModule
}

fn (mut app VideoDecodeApp) create_shader_module(shader_data []u32) vk.ShaderModule {
	vk_device := app.device_context.vk_device
	module_ci := vk.ShaderModuleCreateInfo{
		codeSize: usize(shader_data.len) * sizeof(u32)
		pCode: unsafe { shader_data.data }
	}
	mut shader_module := vk.ShaderModule(0)
	check_vk(vk.create_shader_module(vk_device, &module_ci, unsafe { nil }, &shader_module), 'Could not create shader module')
	return shader_module
}

fn (mut app VideoDecodeApp) initialize_pipeline() {
	dev_ctx := app.device_context
	vk_device := dev_ctx.vk_device
	if isnil(app.ds_layout) {
		panic('Please make sure to create app.ds_layout')
	}
	mut push_constant_range := vk.PushConstantRange{
		stageFlags: vk.ShaderStageFlags(vk.ShaderStageFlagBits.vertex)
		size: u32(sizeof(VideoRenderTransform))
	}
	pipeline_layout_ci := vk.PipelineLayoutCreateInfo{
		setLayoutCount: 1
		pSetLayouts: &app.ds_layout
		pushConstantRangeCount: 1
		pPushConstantRanges: &push_constant_range
	}
	check_vk(vk.create_pipeline_layout(vk_device, &pipeline_layout_ci, unsafe { nil }, &app.pipeline_layout), 'Could not create graphics pipeline layout')

	mut vertex_input_ci := vk.PipelineVertexInputStateCreateInfo{}
	mut input_assembly_ci := vk.PipelineInputAssemblyStateCreateInfo{
		topology: vk.PrimitiveTopology.triangle_strip
	}
	mut raster_ci := vk.PipelineRasterizationStateCreateInfo{
		cullMode: vk.CullModeFlags(vk.CullModeFlagBits.back)
		frontFace: vk.FrontFace.counter_clockwise
		lineWidth: 1.0
	}
	// Note Anton: Enums can be u32 or i32. Vulkan makes sure to not use enum values
	// bigger than half of 32bit, until version 2.0
	// https://github.com/KhronosGroup/Vulkan-Docs/issues/124
	mut blend_attachment := vk.PipelineColorBlendAttachmentState{
		// colorWriteMask: vk.ColorComponentFlags(u32(vk.ColorComponentFlagBits.r) |  u32(vk.ColorComponentFlagBits.g) | u32(vk.ColorComponentFlagBits.b) | u32(vk.ColorComponentFlagBits.a))
		colorWriteMask: u32(0x00000001) | u32(0x00000002) | u32(0x00000004) | u32(0x00000008)
	}
	mut blend_ci := vk.PipelineColorBlendStateCreateInfo{
		attachmentCount: 1
		pAttachments: &blend_attachment
	}
	mut viewport_ci := vk.PipelineViewportStateCreateInfo{
		viewportCount: 1
		scissorCount: 1
	}
	mut depth_stencil_ci := vk.PipelineDepthStencilStateCreateInfo{}
	mut multisample_ci := vk.PipelineMultisampleStateCreateInfo{
		rasterizationSamples: vk.SampleCountFlagBits._1
	}
	mut dynamic_states := [vk.DynamicState.viewport, vk.DynamicState.scissor]
	mut dynamic_ci := vk.PipelineDynamicStateCreateInfo{
		dynamicStateCount: u32(dynamic_states.len)
		pDynamicStates: dynamic_states.data
	}
	mut shader_stages := [
		vk.PipelineShaderStageCreateInfo{
			stage: vk.ShaderStageFlagBits.vertex
			module: app.create_shader_module(g_vertex_shader)
			pName: c'main'
		},
		vk.PipelineShaderStageCreateInfo{
			stage: vk.ShaderStageFlagBits.fragment
			module: app.create_shader_module(g_fragment_shader)
			pName: c'main'
		},
	]
	mut pipeline_ci := vk.GraphicsPipelineCreateInfo{
		stageCount: u32(shader_stages.len)
		pStages: shader_stages.data
		pVertexInputState: &vertex_input_ci
		pInputAssemblyState: &input_assembly_ci
		pViewportState: &viewport_ci
		pRasterizationState: &raster_ci
		pMultisampleState: &multisample_ci
		pDepthStencilState: &depth_stencil_ci
		pColorBlendState: &blend_ci
		pDynamicState: &dynamic_ci
		layout: app.pipeline_layout
		renderPass: app.render_pass
	}

	check_vk(vk.create_graphics_pipelines(vk_device, unsafe { nil }, 1, &pipeline_ci, unsafe { nil }, &app.pipeline), 'Could not create graphics pipeline')

	for sstage in shader_stages {
		vk.destroy_shader_module(vk_device, sstage.module, unsafe { nil })
	}
}

fn (mut app VideoDecodeApp) initialize_framebuffers() {
	dev_ctx := app.device_context
	swapchain := dev_ctx.swapchain
	vk_device := dev_ctx.vk_device
	count := swapchain.image_count
	extent := swapchain.extent_2d

	app.frames = []FrameInfo{len: int(count)}
	for i in 0 .. count {
		view := swapchain.image_views[i]
		framebuffer_ci := vk.FramebufferCreateInfo{
			renderPass: app.render_pass
			attachmentCount: 1
			pAttachments: &view
			width: extent.width
			height: extent.height
			layers: 1
		}
		mut fb := unsafe { nil }
		check_vk(vk.create_framebuffer(vk_device, &framebuffer_ci, unsafe { nil }, &fb), 'Could not create swapchain framebuffer ${i}')
		app.frames[i].framebuffer = fb
		app.init_per_frame(mut app.frames[i])
	}
}

fn (mut app VideoDecodeApp) init_per_frame(mut frame_info FrameInfo) {
	dev_ctx := app.device_context
	vk_device := dev_ctx.vk_device
	fence_ci := vk.FenceCreateInfo{
		flags: vk.FenceCreateFlags(vk.FenceCreateFlagBits.signaled)
	}
	check_vk(vk.create_fence(vk_device, &fence_ci, unsafe { nil }, &frame_info.queue_submit_fence), 'Could not create frame fence')

	command_pool_ci := vk.CommandPoolCreateInfo{
		flags: vk.CommandPoolCreateFlags(vk.CommandPoolCreateFlagBits.transient)
	}
	check_vk(vk.create_command_pool(vk_device, &command_pool_ci, unsafe { nil }, &frame_info.command_pool), 'Could not create graphics command pool')

	command_buffer_allocate_info := vk.CommandBufferAllocateInfo{
		commandPool: frame_info.command_pool
		level: vk.CommandBufferLevel.primary
		commandBufferCount: 1
	}
	check_vk(vk.allocate_command_buffers(vk_device, &command_buffer_allocate_info, &frame_info.command_buffer), 'Could not allocate graphics command buffer')
	frame_info.queue_index = 0

	descriptor_set_allocate_info := vk.DescriptorSetAllocateInfo{
		descriptorPool: app.descriptor_pool
		descriptorSetCount: 1
		pSetLayouts: &app.ds_layout
	}
	result := vk.allocate_descriptor_sets(vk_device, &descriptor_set_allocate_info, &frame_info.descriptor_set)
	if result != .success || isnil(frame_info.descriptor_set) {
		panic('Could not allocate per-frame descriptor set: ${result}')
	}
}
