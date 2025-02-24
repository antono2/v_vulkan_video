/*
** https://github.com/antono2/vulkan
**
** License: Public Domain
*/

/*
** This module was generated using the Khronos Vulkan XML API Registry.
** https://github.com/KhronosGroup/Vulkan-Docs/
*/

module vulkan

#flag linux -I$env('VULKAN_SDK')/include
#flag linux -I$env('VULKAN_SDK')/include/vulkan
#flag windows -I$env('VULKAN_SDK')/Include
#flag windows -I$env('VULKAN_SDK')/Include/vulkan
#flag linux -L$env('VULKAN_SDK')/lib
#flag windows -L$env('VULKAN_SDK')/Lib
#include "vulkan.h"

pub fn make_api_version(variant u32, major u32, minor u32, patch u32) u32 {
	return (variant << 29) | (major << 22) | (minor << 12) | patch
}

pub const api_version_1_0 = make_api_version(0, 1, 0, 0) // Patch version should always be set to 0
pub const header_version = 275
pub const header_version_complete = make_api_version(0, 1, 3, header_version)

pub fn version_variant(version u32) u32 {
	return version >> 29
}

pub fn api_version_major(version u32) u32 {
	return (version >> 22) & u32(0x7F)
}

pub fn api_version_minor(version u32) u32 {
	return (version >> 12) & u32(0x3FF)
}

pub fn api_version_patch(version u32) u32 {
	return version & u32(0xFFF)
}

pub type Bool32 = u32
pub type DeviceAddress = u64
pub type DeviceSize = u64
pub type Flags = u32
pub type SampleMask = u32
pub type C.VkBuffer = voidptr
pub type C.VkImage = voidptr
pub type C.VkInstance = voidptr
pub type C.VkPhysicalDevice = voidptr
pub type C.VkDevice = voidptr
pub type C.VkQueue = voidptr
pub type C.VkSemaphore = voidptr
pub type C.VkCommandBuffer = voidptr
pub type C.VkFence = voidptr
pub type C.VkDeviceMemory = voidptr
pub type C.VkEvent = voidptr
pub type C.VkQueryPool = voidptr
pub type C.VkBufferView = voidptr
pub type C.VkImageView = voidptr
pub type C.VkShaderModule = voidptr
pub type C.VkPipelineCache = voidptr
pub type C.VkPipelineLayout = voidptr
pub type C.VkPipeline = voidptr
pub type C.VkRenderPass = voidptr
pub type C.VkDescriptorSetLayout = voidptr
pub type C.VkSampler = voidptr
pub type C.VkDescriptorSet = voidptr
pub type C.VkDescriptorPool = voidptr
pub type C.VkFramebuffer = voidptr
pub type C.VkCommandPool = voidptr

pub const attachment_unused = ~u32(0)
pub const _false = u32(0)
pub const lod_clamp_none = f32(1000.0)
pub const queue_family_ignored = ~u32(0)
pub const remaining_array_layers = ~u32(0)
pub const remaining_mip_levels = ~u32(0)
pub const subpass_external = ~u32(0)
pub const _true = u32(1)
pub const whole_size = ~u64(0)
pub const max_memory_types = u32(32)
pub const max_physical_device_name_size = u32(256)
pub const uuid_size = u32(16)
pub const max_extension_name_size = u32(256)
pub const max_description_size = u32(256)
pub const max_memory_heaps = u32(16)

pub enum Result {
	success                                            = 0
	not_ready                                          = 1
	timeout                                            = 2
	event_set                                          = 3
	event_reset                                        = 4
	incomplete                                         = 5
	error_out_of_host_memory                           = -1
	error_out_of_device_memory                         = -2
	error_initialization_failed                        = -3
	error_device_lost                                  = -4
	error_memory_map_failed                            = -5
	error_layer_not_present                            = -6
	error_extension_not_present                        = -7
	error_feature_not_present                          = -8
	error_incompatible_driver                          = -9
	error_too_many_objects                             = -10
	error_format_not_supported                         = -11
	error_fragmented_pool                              = -12
	error_unknown                                      = -13
	error_out_of_pool_memory                           = -1000069000
	error_invalid_external_handle                      = -1000072003
	error_fragmentation                                = -1000161000
	error_invalid_opaque_capture_address               = -1000257000
	pipeline_compile_required                          = 1000297000
	error_surface_lost_khr                             = -1000000000
	error_native_window_in_use_khr                     = -1000000001
	suboptimal_khr                                     = 1000001003
	error_out_of_date_khr                              = -1000001004
	error_incompatible_display_khr                     = -1000003001
	error_validation_failed_ext                        = -1000011001
	error_invalid_shader_nv                            = -1000012000
	error_image_usage_not_supported_khr                = -1000023000
	error_video_picture_layout_not_supported_khr       = -1000023001
	error_video_profile_operation_not_supported_khr    = -1000023002
	error_video_profile_format_not_supported_khr       = -1000023003
	error_video_profile_codec_not_supported_khr        = -1000023004
	error_video_std_version_not_supported_khr          = -1000023005
	error_invalid_drm_format_modifier_plane_layout_ext = -1000158000
	error_not_permitted_khr                            = -1000174001
	error_full_screen_exclusive_mode_lost_ext          = -1000255000
	thread_idle_khr                                    = 1000268000
	thread_done_khr                                    = 1000268001
	operation_deferred_khr                             = 1000268002
	operation_not_deferred_khr                         = 1000268003
	error_invalid_video_std_parameters_khr             = -1000299000
	error_compression_exhausted_ext                    = -1000338000
	error_incompatible_shader_binary_ext               = 1000482000
	max_enum                                           = max_int
}

pub enum StructureType {
	application_info                                                    = 0
	instance_create_info                                                = 1
	device_queue_create_info                                            = 2
	device_create_info                                                  = 3
	submit_info                                                         = 4
	memory_allocate_info                                                = 5
	mapped_memory_range                                                 = 6
	bind_sparse_info                                                    = 7
	fence_create_info                                                   = 8
	semaphore_create_info                                               = 9
	event_create_info                                                   = 10
	query_pool_create_info                                              = 11
	buffer_create_info                                                  = 12
	buffer_view_create_info                                             = 13
	image_create_info                                                   = 14
	image_view_create_info                                              = 15
	shader_module_create_info                                           = 16
	pipeline_cache_create_info                                          = 17
	pipeline_shader_stage_create_info                                   = 18
	pipeline_vertex_input_state_create_info                             = 19
	pipeline_input_assembly_state_create_info                           = 20
	pipeline_tessellation_state_create_info                             = 21
	pipeline_viewport_state_create_info                                 = 22
	pipeline_rasterization_state_create_info                            = 23
	pipeline_multisample_state_create_info                              = 24
	pipeline_depth_stencil_state_create_info                            = 25
	pipeline_color_blend_state_create_info                              = 26
	pipeline_dynamic_state_create_info                                  = 27
	graphics_pipeline_create_info                                       = 28
	compute_pipeline_create_info                                        = 29
	pipeline_layout_create_info                                         = 30
	sampler_create_info                                                 = 31
	descriptor_set_layout_create_info                                   = 32
	descriptor_pool_create_info                                         = 33
	descriptor_set_allocate_info                                        = 34
	write_descriptor_set                                                = 35
	copy_descriptor_set                                                 = 36
	framebuffer_create_info                                             = 37
	render_pass_create_info                                             = 38
	command_pool_create_info                                            = 39
	command_buffer_allocate_info                                        = 40
	command_buffer_inheritance_info                                     = 41
	command_buffer_begin_info                                           = 42
	render_pass_begin_info                                              = 43
	buffer_memory_barrier                                               = 44
	image_memory_barrier                                                = 45
	memory_barrier                                                      = 46
	loader_instance_create_info                                         = 47
	loader_device_create_info                                           = 48
	physical_device_subgroup_properties                                 = 1000094000
	bind_buffer_memory_info                                             = 1000157000
	bind_image_memory_info                                              = 1000157001
	physical_device16bit_storage_features                               = 1000083000
	memory_dedicated_requirements                                       = 1000127000
	memory_dedicated_allocate_info                                      = 1000127001
	memory_allocate_flags_info                                          = 1000060000
	device_group_render_pass_begin_info                                 = 1000060003
	device_group_command_buffer_begin_info                              = 1000060004
	device_group_submit_info                                            = 1000060005
	device_group_bind_sparse_info                                       = 1000060006
	bind_buffer_memory_device_group_info                                = 1000060013
	bind_image_memory_device_group_info                                 = 1000060014
	physical_device_group_properties                                    = 1000070000
	device_group_device_create_info                                     = 1000070001
	buffer_memory_requirements_info2                                    = 1000146000
	image_memory_requirements_info2                                     = 1000146001
	image_sparse_memory_requirements_info2                              = 1000146002
	memory_requirements2                                                = 1000146003
	sparse_image_memory_requirements2                                   = 1000146004
	physical_device_features2                                           = 1000059000
	physical_device_properties2                                         = 1000059001
	format_properties2                                                  = 1000059002
	image_format_properties2                                            = 1000059003
	physical_device_image_format_info2                                  = 1000059004
	queue_family_properties2                                            = 1000059005
	physical_device_memory_properties2                                  = 1000059006
	sparse_image_format_properties2                                     = 1000059007
	physical_device_sparse_image_format_info2                           = 1000059008
	physical_device_point_clipping_properties                           = 1000117000
	render_pass_input_attachment_aspect_create_info                     = 1000117001
	image_view_usage_create_info                                        = 1000117002
	pipeline_tessellation_domain_origin_state_create_info               = 1000117003
	render_pass_multiview_create_info                                   = 1000053000
	physical_device_multiview_features                                  = 1000053001
	physical_device_multiview_properties                                = 1000053002
	physical_device_variable_pointers_features                          = 1000120000
	protected_submit_info                                               = 1000145000
	physical_device_protected_memory_features                           = 1000145001
	physical_device_protected_memory_properties                         = 1000145002
	device_queue_info2                                                  = 1000145003
	sampler_ycbcr_conversion_create_info                                = 1000156000
	sampler_ycbcr_conversion_info                                       = 1000156001
	bind_image_plane_memory_info                                        = 1000156002
	image_plane_memory_requirements_info                                = 1000156003
	physical_device_sampler_ycbcr_conversion_features                   = 1000156004
	sampler_ycbcr_conversion_image_format_properties                    = 1000156005
	descriptor_update_template_create_info                              = 1000085000
	physical_device_external_image_format_info                          = 1000071000
	external_image_format_properties                                    = 1000071001
	physical_device_external_buffer_info                                = 1000071002
	external_buffer_properties                                          = 1000071003
	physical_device_id_properties                                       = 1000071004
	external_memory_buffer_create_info                                  = 1000072000
	external_memory_image_create_info                                   = 1000072001
	export_memory_allocate_info                                         = 1000072002
	physical_device_external_fence_info                                 = 1000112000
	external_fence_properties                                           = 1000112001
	export_fence_create_info                                            = 1000113000
	export_semaphore_create_info                                        = 1000077000
	physical_device_external_semaphore_info                             = 1000076000
	external_semaphore_properties                                       = 1000076001
	physical_device_maintenance3_properties                             = 1000168000
	descriptor_set_layout_support                                       = 1000168001
	physical_device_shader_draw_parameters_features                     = 1000063000
	physical_device_vulkan1_1_features                                  = 49
	physical_device_vulkan1_1_properties                                = 50
	physical_device_vulkan1_2_features                                  = 51
	physical_device_vulkan1_2_properties                                = 52
	image_format_list_create_info                                       = 1000147000
	attachment_description2                                             = 1000109000
	attachment_reference2                                               = 1000109001
	subpass_description2                                                = 1000109002
	subpass_dependency2                                                 = 1000109003
	render_pass_create_info2                                            = 1000109004
	subpass_begin_info                                                  = 1000109005
	subpass_end_info                                                    = 1000109006
	physical_device8bit_storage_features                                = 1000177000
	physical_device_driver_properties                                   = 1000196000
	physical_device_shader_atomic_int64_features                        = 1000180000
	physical_device_shader_float16_int8_features                        = 1000082000
	physical_device_float_controls_properties                           = 1000197000
	descriptor_set_layout_binding_flags_create_info                     = 1000161000
	physical_device_descriptor_indexing_features                        = 1000161001
	physical_device_descriptor_indexing_properties                      = 1000161002
	descriptor_set_variable_descriptor_count_allocate_info              = 1000161003
	descriptor_set_variable_descriptor_count_layout_support             = 1000161004
	physical_device_depth_stencil_resolve_properties                    = 1000199000
	subpass_description_depth_stencil_resolve                           = 1000199001
	physical_device_scalar_block_layout_features                        = 1000221000
	image_stencil_usage_create_info                                     = 1000246000
	physical_device_sampler_filter_minmax_properties                    = 1000130000
	sampler_reduction_mode_create_info                                  = 1000130001
	physical_device_vulkan_memory_model_features                        = 1000211000
	physical_device_imageless_framebuffer_features                      = 1000108000
	framebuffer_attachments_create_info                                 = 1000108001
	framebuffer_attachment_image_info                                   = 1000108002
	render_pass_attachment_begin_info                                   = 1000108003
	physical_device_uniform_buffer_standard_layout_features             = 1000253000
	physical_device_shader_subgroup_extended_types_features             = 1000175000
	physical_device_separate_depth_stencil_layouts_features             = 1000241000
	attachment_reference_stencil_layout                                 = 1000241001
	attachment_description_stencil_layout                               = 1000241002
	physical_device_host_query_reset_features                           = 1000261000
	physical_device_timeline_semaphore_features                         = 1000207000
	physical_device_timeline_semaphore_properties                       = 1000207001
	semaphore_type_create_info                                          = 1000207002
	timeline_semaphore_submit_info                                      = 1000207003
	semaphore_wait_info                                                 = 1000207004
	semaphore_signal_info                                               = 1000207005
	physical_device_buffer_device_address_features                      = 1000257000
	buffer_device_address_info                                          = 1000244001
	buffer_opaque_capture_address_create_info                           = 1000257002
	memory_opaque_capture_address_allocate_info                         = 1000257003
	device_memory_opaque_capture_address_info                           = 1000257004
	physical_device_vulkan1_3_features                                  = 53
	physical_device_vulkan1_3_properties                                = 54
	pipeline_creation_feedback_create_info                              = 1000192000
	physical_device_shader_terminate_invocation_features                = 1000215000
	physical_device_tool_properties                                     = 1000245000
	physical_device_shader_demote_to_helper_invocation_features         = 1000276000
	physical_device_private_data_features                               = 1000295000
	device_private_data_create_info                                     = 1000295001
	private_data_slot_create_info                                       = 1000295002
	physical_device_pipeline_creation_cache_control_features            = 1000297000
	memory_barrier2                                                     = 1000314000
	buffer_memory_barrier2                                              = 1000314001
	image_memory_barrier2                                               = 1000314002
	dependency_info                                                     = 1000314003
	submit_info2                                                        = 1000314004
	semaphore_submit_info                                               = 1000314005
	command_buffer_submit_info                                          = 1000314006
	physical_device_synchronization2_features                           = 1000314007
	physical_device_zero_initialize_workgroup_memory_features           = 1000325000
	physical_device_image_robustness_features                           = 1000335000
	copy_buffer_info2                                                   = 1000337000
	copy_image_info2                                                    = 1000337001
	copy_buffer_to_image_info2                                          = 1000337002
	copy_image_to_buffer_info2                                          = 1000337003
	blit_image_info2                                                    = 1000337004
	resolve_image_info2                                                 = 1000337005
	buffer_copy2                                                        = 1000337006
	image_copy2                                                         = 1000337007
	image_blit2                                                         = 1000337008
	buffer_image_copy2                                                  = 1000337009
	image_resolve2                                                      = 1000337010
	physical_device_subgroup_size_control_properties                    = 1000225000
	pipeline_shader_stage_required_subgroup_size_create_info            = 1000225001
	physical_device_subgroup_size_control_features                      = 1000225002
	physical_device_inline_uniform_block_features                       = 1000138000
	physical_device_inline_uniform_block_properties                     = 1000138001
	write_descriptor_set_inline_uniform_block                           = 1000138002
	descriptor_pool_inline_uniform_block_create_info                    = 1000138003
	physical_device_texture_compression_astc_hdr_features               = 1000066000
	rendering_info                                                      = 1000044000
	rendering_attachment_info                                           = 1000044001
	pipeline_rendering_create_info                                      = 1000044002
	physical_device_dynamic_rendering_features                          = 1000044003
	command_buffer_inheritance_rendering_info                           = 1000044004
	physical_device_shader_integer_dot_product_features                 = 1000280000
	physical_device_shader_integer_dot_product_properties               = 1000280001
	physical_device_texel_buffer_alignment_properties                   = 1000281001
	format_properties3                                                  = 1000360000
	physical_device_maintenance4_features                               = 1000413000
	physical_device_maintenance4_properties                             = 1000413001
	device_buffer_memory_requirements                                   = 1000413002
	device_image_memory_requirements                                    = 1000413003
	swapchain_create_info_khr                                           = 1000001000
	present_info_khr                                                    = 1000001001
	device_group_present_capabilities_khr                               = 1000060007
	image_swapchain_create_info_khr                                     = 1000060008
	bind_image_memory_swapchain_info_khr                                = 1000060009
	acquire_next_image_info_khr                                         = 1000060010
	device_group_present_info_khr                                       = 1000060011
	device_group_swapchain_create_info_khr                              = 1000060012
	display_mode_create_info_khr                                        = 1000002000
	display_surface_create_info_khr                                     = 1000002001
	display_present_info_khr                                            = 1000003000
	xlib_surface_create_info_khr                                        = 1000004000
	xcb_surface_create_info_khr                                         = 1000005000
	wayland_surface_create_info_khr                                     = 1000006000
	android_surface_create_info_khr                                     = 1000008000
	win32_surface_create_info_khr                                       = 1000009000
	debug_report_callback_create_info_ext                               = 1000011000
	pipeline_rasterization_state_rasterization_order_amd                = 1000018000
	debug_marker_object_name_info_ext                                   = 1000022000
	debug_marker_object_tag_info_ext                                    = 1000022001
	debug_marker_marker_info_ext                                        = 1000022002
	video_profile_info_khr                                              = 1000023000
	video_capabilities_khr                                              = 1000023001
	video_picture_resource_info_khr                                     = 1000023002
	video_session_memory_requirements_khr                               = 1000023003
	bind_video_session_memory_info_khr                                  = 1000023004
	video_session_create_info_khr                                       = 1000023005
	video_session_parameters_create_info_khr                            = 1000023006
	video_session_parameters_update_info_khr                            = 1000023007
	video_begin_coding_info_khr                                         = 1000023008
	video_end_coding_info_khr                                           = 1000023009
	video_coding_control_info_khr                                       = 1000023010
	video_reference_slot_info_khr                                       = 1000023011
	queue_family_video_properties_khr                                   = 1000023012
	video_profile_list_info_khr                                         = 1000023013
	physical_device_video_format_info_khr                               = 1000023014
	video_format_properties_khr                                         = 1000023015
	queue_family_query_result_status_properties_khr                     = 1000023016
	video_decode_info_khr                                               = 1000024000
	video_decode_capabilities_khr                                       = 1000024001
	video_decode_usage_info_khr                                         = 1000024002
	dedicated_allocation_image_create_info_nv                           = 1000026000
	dedicated_allocation_buffer_create_info_nv                          = 1000026001
	dedicated_allocation_memory_allocate_info_nv                        = 1000026002
	physical_device_transform_feedback_features_ext                     = 1000028000
	physical_device_transform_feedback_properties_ext                   = 1000028001
	pipeline_rasterization_state_stream_create_info_ext                 = 1000028002
	cu_module_create_info_nvx                                           = 1000029000
	cu_function_create_info_nvx                                         = 1000029001
	cu_launch_info_nvx                                                  = 1000029002
	image_view_handle_info_nvx                                          = 1000030000
	image_view_address_properties_nvx                                   = 1000030001
	video_encode_h264_capabilities_khr                                  = 1000038000
	video_encode_h264_session_parameters_create_info_khr                = 1000038001
	video_encode_h264_session_parameters_add_info_khr                   = 1000038002
	video_encode_h264_picture_info_khr                                  = 1000038003
	video_encode_h264_dpb_slot_info_khr                                 = 1000038004
	video_encode_h264_nalu_slice_info_khr                               = 1000038005
	video_encode_h264_gop_remaining_frame_info_khr                      = 1000038006
	video_encode_h264_profile_info_khr                                  = 1000038007
	video_encode_h264_rate_control_info_khr                             = 1000038008
	video_encode_h264_rate_control_layer_info_khr                       = 1000038009
	video_encode_h264_session_create_info_khr                           = 1000038010
	video_encode_h264_quality_level_properties_khr                      = 1000038011
	video_encode_h264_session_parameters_get_info_khr                   = 1000038012
	video_encode_h264_session_parameters_feedback_info_khr              = 1000038013
	video_encode_h265_capabilities_khr                                  = 1000039000
	video_encode_h265_session_parameters_create_info_khr                = 1000039001
	video_encode_h265_session_parameters_add_info_khr                   = 1000039002
	video_encode_h265_picture_info_khr                                  = 1000039003
	video_encode_h265_dpb_slot_info_khr                                 = 1000039004
	video_encode_h265_nalu_slice_segment_info_khr                       = 1000039005
	video_encode_h265_gop_remaining_frame_info_khr                      = 1000039006
	video_encode_h265_profile_info_khr                                  = 1000039007
	video_encode_h265_rate_control_info_khr                             = 1000039009
	video_encode_h265_rate_control_layer_info_khr                       = 1000039010
	video_encode_h265_session_create_info_khr                           = 1000039011
	video_encode_h265_quality_level_properties_khr                      = 1000039012
	video_encode_h265_session_parameters_get_info_khr                   = 1000039013
	video_encode_h265_session_parameters_feedback_info_khr              = 1000039014
	video_decode_h264_capabilities_khr                                  = 1000040000
	video_decode_h264_picture_info_khr                                  = 1000040001
	video_decode_h264_profile_info_khr                                  = 1000040003
	video_decode_h264_session_parameters_create_info_khr                = 1000040004
	video_decode_h264_session_parameters_add_info_khr                   = 1000040005
	video_decode_h264_dpb_slot_info_khr                                 = 1000040006
	texture_lod_gather_format_properties_amd                            = 1000041000
	rendering_fragment_shading_rate_attachment_info_khr                 = 1000044006
	rendering_fragment_density_map_attachment_info_ext                  = 1000044007
	attachment_sample_count_info_amd                                    = 1000044008
	multiview_per_view_attributes_info_nvx                              = 1000044009
	stream_descriptor_surface_create_info_ggp                           = 1000049000
	physical_device_corner_sampled_image_features_nv                    = 1000050000
	external_memory_image_create_info_nv                                = 1000056000
	export_memory_allocate_info_nv                                      = 1000056001
	import_memory_win32_handle_info_nv                                  = 1000057000
	export_memory_win32_handle_info_nv                                  = 1000057001
	win32_keyed_mutex_acquire_release_info_nv                           = 1000058000
	validation_flags_ext                                                = 1000061000
	vi_surface_create_info_nn                                           = 1000062000
	image_view_astc_decode_mode_ext                                     = 1000067000
	physical_device_astc_decode_features_ext                            = 1000067001
	pipeline_robustness_create_info_ext                                 = 1000068000
	physical_device_pipeline_robustness_features_ext                    = 1000068001
	physical_device_pipeline_robustness_properties_ext                  = 1000068002
	import_memory_win32_handle_info_khr                                 = 1000073000
	export_memory_win32_handle_info_khr                                 = 1000073001
	memory_win32_handle_properties_khr                                  = 1000073002
	memory_get_win32_handle_info_khr                                    = 1000073003
	import_memory_fd_info_khr                                           = 1000074000
	memory_fd_properties_khr                                            = 1000074001
	memory_get_fd_info_khr                                              = 1000074002
	win32_keyed_mutex_acquire_release_info_khr                          = 1000075000
	import_semaphore_win32_handle_info_khr                              = 1000078000
	export_semaphore_win32_handle_info_khr                              = 1000078001
	d3d12_fence_submit_info_khr                                         = 1000078002
	semaphore_get_win32_handle_info_khr                                 = 1000078003
	import_semaphore_fd_info_khr                                        = 1000079000
	semaphore_get_fd_info_khr                                           = 1000079001
	physical_device_push_descriptor_properties_khr                      = 1000080000
	command_buffer_inheritance_conditional_rendering_info_ext           = 1000081000
	physical_device_conditional_rendering_features_ext                  = 1000081001
	conditional_rendering_begin_info_ext                                = 1000081002
	present_regions_khr                                                 = 1000084000
	pipeline_viewport_w_scaling_state_create_info_nv                    = 1000087000
	surface_capabilities2_ext                                           = 1000090000
	display_power_info_ext                                              = 1000091000
	device_event_info_ext                                               = 1000091001
	display_event_info_ext                                              = 1000091002
	swapchain_counter_create_info_ext                                   = 1000091003
	present_times_info_google                                           = 1000092000
	physical_device_multiview_per_view_attributes_properties_nvx        = 1000097000
	pipeline_viewport_swizzle_state_create_info_nv                      = 1000098000
	physical_device_discard_rectangle_properties_ext                    = 1000099000
	pipeline_discard_rectangle_state_create_info_ext                    = 1000099001
	physical_device_conservative_rasterization_properties_ext           = 1000101000
	pipeline_rasterization_conservative_state_create_info_ext           = 1000101001
	physical_device_depth_clip_enable_features_ext                      = 1000102000
	pipeline_rasterization_depth_clip_state_create_info_ext             = 1000102001
	hdr_metadata_ext                                                    = 1000105000
	physical_device_relaxed_line_rasterization_features_img             = 1000110000
	shared_present_surface_capabilities_khr                             = 1000111000
	import_fence_win32_handle_info_khr                                  = 1000114000
	export_fence_win32_handle_info_khr                                  = 1000114001
	fence_get_win32_handle_info_khr                                     = 1000114002
	import_fence_fd_info_khr                                            = 1000115000
	fence_get_fd_info_khr                                               = 1000115001
	physical_device_performance_query_features_khr                      = 1000116000
	physical_device_performance_query_properties_khr                    = 1000116001
	query_pool_performance_create_info_khr                              = 1000116002
	performance_query_submit_info_khr                                   = 1000116003
	acquire_profiling_lock_info_khr                                     = 1000116004
	performance_counter_khr                                             = 1000116005
	performance_counter_description_khr                                 = 1000116006
	physical_device_surface_info2_khr                                   = 1000119000
	surface_capabilities2_khr                                           = 1000119001
	surface_format2_khr                                                 = 1000119002
	display_properties2_khr                                             = 1000121000
	display_plane_properties2_khr                                       = 1000121001
	display_mode_properties2_khr                                        = 1000121002
	display_plane_info2_khr                                             = 1000121003
	display_plane_capabilities2_khr                                     = 1000121004
	ios_surface_create_info_mvk                                         = 1000122000
	macos_surface_create_info_mvk                                       = 1000123000
	debug_utils_object_name_info_ext                                    = 1000128000
	debug_utils_object_tag_info_ext                                     = 1000128001
	debug_utils_label_ext                                               = 1000128002
	debug_utils_messenger_callback_data_ext                             = 1000128003
	debug_utils_messenger_create_info_ext                               = 1000128004
	android_hardware_buffer_usage_android                               = 1000129000
	android_hardware_buffer_properties_android                          = 1000129001
	android_hardware_buffer_format_properties_android                   = 1000129002
	import_android_hardware_buffer_info_android                         = 1000129003
	memory_get_android_hardware_buffer_info_android                     = 1000129004
	external_format_android                                             = 1000129005
	android_hardware_buffer_format_properties2_android                  = 1000129006
	sample_locations_info_ext                                           = 1000143000
	render_pass_sample_locations_begin_info_ext                         = 1000143001
	pipeline_sample_locations_state_create_info_ext                     = 1000143002
	physical_device_sample_locations_properties_ext                     = 1000143003
	multisample_properties_ext                                          = 1000143004
	physical_device_blend_operation_advanced_features_ext               = 1000148000
	physical_device_blend_operation_advanced_properties_ext             = 1000148001
	pipeline_color_blend_advanced_state_create_info_ext                 = 1000148002
	pipeline_coverage_to_color_state_create_info_nv                     = 1000149000
	write_descriptor_set_acceleration_structure_khr                     = 1000150007
	acceleration_structure_build_geometry_info_khr                      = 1000150000
	acceleration_structure_device_address_info_khr                      = 1000150002
	acceleration_structure_geometry_aabbs_data_khr                      = 1000150003
	acceleration_structure_geometry_instances_data_khr                  = 1000150004
	acceleration_structure_geometry_triangles_data_khr                  = 1000150005
	acceleration_structure_geometry_khr                                 = 1000150006
	acceleration_structure_version_info_khr                             = 1000150009
	copy_acceleration_structure_info_khr                                = 1000150010
	copy_acceleration_structure_to_memory_info_khr                      = 1000150011
	copy_memory_to_acceleration_structure_info_khr                      = 1000150012
	physical_device_acceleration_structure_features_khr                 = 1000150013
	physical_device_acceleration_structure_properties_khr               = 1000150014
	acceleration_structure_create_info_khr                              = 1000150017
	acceleration_structure_build_sizes_info_khr                         = 1000150020
	physical_device_ray_tracing_pipeline_features_khr                   = 1000347000
	physical_device_ray_tracing_pipeline_properties_khr                 = 1000347001
	ray_tracing_pipeline_create_info_khr                                = 1000150015
	ray_tracing_shader_group_create_info_khr                            = 1000150016
	ray_tracing_pipeline_interface_create_info_khr                      = 1000150018
	physical_device_ray_query_features_khr                              = 1000348013
	pipeline_coverage_modulation_state_create_info_nv                   = 1000152000
	physical_device_shader_sm_builtins_features_nv                      = 1000154000
	physical_device_shader_sm_builtins_properties_nv                    = 1000154001
	drm_format_modifier_properties_list_ext                             = 1000158000
	physical_device_image_drm_format_modifier_info_ext                  = 1000158002
	image_drm_format_modifier_list_create_info_ext                      = 1000158003
	image_drm_format_modifier_explicit_create_info_ext                  = 1000158004
	image_drm_format_modifier_properties_ext                            = 1000158005
	drm_format_modifier_properties_list2_ext                            = 1000158006
	validation_cache_create_info_ext                                    = 1000160000
	shader_module_validation_cache_create_info_ext                      = 1000160001
	pipeline_viewport_shading_rate_image_state_create_info_nv           = 1000164000
	physical_device_shading_rate_image_features_nv                      = 1000164001
	physical_device_shading_rate_image_properties_nv                    = 1000164002
	pipeline_viewport_coarse_sample_order_state_create_info_nv          = 1000164005
	ray_tracing_pipeline_create_info_nv                                 = 1000165000
	acceleration_structure_create_info_nv                               = 1000165001
	geometry_nv                                                         = 1000165003
	geometry_triangles_nv                                               = 1000165004
	geometry_aabb_nv                                                    = 1000165005
	bind_acceleration_structure_memory_info_nv                          = 1000165006
	write_descriptor_set_acceleration_structure_nv                      = 1000165007
	acceleration_structure_memory_requirements_info_nv                  = 1000165008
	physical_device_ray_tracing_properties_nv                           = 1000165009
	ray_tracing_shader_group_create_info_nv                             = 1000165011
	acceleration_structure_info_nv                                      = 1000165012
	physical_device_representative_fragment_test_features_nv            = 1000166000
	pipeline_representative_fragment_test_state_create_info_nv          = 1000166001
	physical_device_image_view_image_format_info_ext                    = 1000170000
	filter_cubic_image_view_image_format_properties_ext                 = 1000170001
	import_memory_host_pointer_info_ext                                 = 1000178000
	memory_host_pointer_properties_ext                                  = 1000178001
	physical_device_external_memory_host_properties_ext                 = 1000178002
	physical_device_shader_clock_features_khr                           = 1000181000
	pipeline_compiler_control_create_info_amd                           = 1000183000
	physical_device_shader_core_properties_amd                          = 1000185000
	video_decode_h265_capabilities_khr                                  = 1000187000
	video_decode_h265_session_parameters_create_info_khr                = 1000187001
	video_decode_h265_session_parameters_add_info_khr                   = 1000187002
	video_decode_h265_profile_info_khr                                  = 1000187003
	video_decode_h265_picture_info_khr                                  = 1000187004
	video_decode_h265_dpb_slot_info_khr                                 = 1000187005
	device_queue_global_priority_create_info_khr                        = 1000174000
	physical_device_global_priority_query_features_khr                  = 1000388000
	queue_family_global_priority_properties_khr                         = 1000388001
	device_memory_overallocation_create_info_amd                        = 1000189000
	physical_device_vertex_attribute_divisor_properties_ext             = 1000190000
	present_frame_token_ggp                                             = 1000191000
	physical_device_compute_shader_derivatives_features_nv              = 1000201000
	physical_device_mesh_shader_features_nv                             = 1000202000
	physical_device_mesh_shader_properties_nv                           = 1000202001
	physical_device_shader_image_footprint_features_nv                  = 1000204000
	pipeline_viewport_exclusive_scissor_state_create_info_nv            = 1000205000
	physical_device_exclusive_scissor_features_nv                       = 1000205002
	checkpoint_data_nv                                                  = 1000206000
	queue_family_checkpoint_properties_nv                               = 1000206001
	physical_device_shader_integer_functions2_features_intel            = 1000209000
	query_pool_performance_query_create_info_intel                      = 1000210000
	initialize_performance_api_info_intel                               = 1000210001
	performance_marker_info_intel                                       = 1000210002
	performance_stream_marker_info_intel                                = 1000210003
	performance_override_info_intel                                     = 1000210004
	performance_configuration_acquire_info_intel                        = 1000210005
	physical_device_pci_bus_info_properties_ext                         = 1000212000
	display_native_hdr_surface_capabilities_amd                         = 1000213000
	swapchain_display_native_hdr_create_info_amd                        = 1000213001
	imagepipe_surface_create_info_fuchsia                               = 1000214000
	metal_surface_create_info_ext                                       = 1000217000
	physical_device_fragment_density_map_features_ext                   = 1000218000
	physical_device_fragment_density_map_properties_ext                 = 1000218001
	render_pass_fragment_density_map_create_info_ext                    = 1000218002
	fragment_shading_rate_attachment_info_khr                           = 1000226000
	pipeline_fragment_shading_rate_state_create_info_khr                = 1000226001
	physical_device_fragment_shading_rate_properties_khr                = 1000226002
	physical_device_fragment_shading_rate_features_khr                  = 1000226003
	physical_device_fragment_shading_rate_khr                           = 1000226004
	physical_device_shader_core_properties2_amd                         = 1000227000
	physical_device_coherent_memory_features_amd                        = 1000229000
	physical_device_shader_image_atomic_int64_features_ext              = 1000234000
	physical_device_memory_budget_properties_ext                        = 1000237000
	physical_device_memory_priority_features_ext                        = 1000238000
	memory_priority_allocate_info_ext                                   = 1000238001
	surface_protected_capabilities_khr                                  = 1000239000
	physical_device_dedicated_allocation_image_aliasing_features_nv     = 1000240000
	physical_device_buffer_device_address_features_ext                  = 1000244000
	buffer_device_address_create_info_ext                               = 1000244002
	validation_features_ext                                             = 1000247000
	physical_device_present_wait_features_khr                           = 1000248000
	physical_device_cooperative_matrix_features_nv                      = 1000249000
	cooperative_matrix_properties_nv                                    = 1000249001
	physical_device_cooperative_matrix_properties_nv                    = 1000249002
	physical_device_coverage_reduction_mode_features_nv                 = 1000250000
	pipeline_coverage_reduction_state_create_info_nv                    = 1000250001
	framebuffer_mixed_samples_combination_nv                            = 1000250002
	physical_device_fragment_shader_interlock_features_ext              = 1000251000
	physical_device_ycbcr_image_arrays_features_ext                     = 1000252000
	physical_device_provoking_vertex_features_ext                       = 1000254000
	pipeline_rasterization_provoking_vertex_state_create_info_ext       = 1000254001
	physical_device_provoking_vertex_properties_ext                     = 1000254002
	surface_full_screen_exclusive_info_ext                              = 1000255000
	surface_capabilities_full_screen_exclusive_ext                      = 1000255002
	surface_full_screen_exclusive_win32_info_ext                        = 1000255001
	headless_surface_create_info_ext                                    = 1000256000
	physical_device_line_rasterization_features_ext                     = 1000259000
	pipeline_rasterization_line_state_create_info_ext                   = 1000259001
	physical_device_line_rasterization_properties_ext                   = 1000259002
	physical_device_shader_atomic_float_features_ext                    = 1000260000
	physical_device_index_type_uint8_features_ext                       = 1000265000
	physical_device_extended_dynamic_state_features_ext                 = 1000267000
	physical_device_pipeline_executable_properties_features_khr         = 1000269000
	pipeline_info_khr                                                   = 1000269001
	pipeline_executable_properties_khr                                  = 1000269002
	pipeline_executable_info_khr                                        = 1000269003
	pipeline_executable_statistic_khr                                   = 1000269004
	pipeline_executable_internal_representation_khr                     = 1000269005
	physical_device_host_image_copy_features_ext                        = 1000270000
	physical_device_host_image_copy_properties_ext                      = 1000270001
	memory_to_image_copy_ext                                            = 1000270002
	image_to_memory_copy_ext                                            = 1000270003
	copy_image_to_memory_info_ext                                       = 1000270004
	copy_memory_to_image_info_ext                                       = 1000270005
	host_image_layout_transition_info_ext                               = 1000270006
	copy_image_to_image_info_ext                                        = 1000270007
	subresource_host_memcpy_size_ext                                    = 1000270008
	host_image_copy_device_performance_query_ext                        = 1000270009
	memory_map_info_khr                                                 = 1000271000
	memory_unmap_info_khr                                               = 1000271001
	physical_device_shader_atomic_float2_features_ext                   = 1000273000
	surface_present_mode_ext                                            = 1000274000
	surface_present_scaling_capabilities_ext                            = 1000274001
	surface_present_mode_compatibility_ext                              = 1000274002
	physical_device_swapchain_maintenance1_features_ext                 = 1000275000
	swapchain_present_fence_info_ext                                    = 1000275001
	swapchain_present_modes_create_info_ext                             = 1000275002
	swapchain_present_mode_info_ext                                     = 1000275003
	swapchain_present_scaling_create_info_ext                           = 1000275004
	release_swapchain_images_info_ext                                   = 1000275005
	physical_device_device_generated_commands_properties_nv             = 1000277000
	graphics_shader_group_create_info_nv                                = 1000277001
	graphics_pipeline_shader_groups_create_info_nv                      = 1000277002
	indirect_commands_layout_token_nv                                   = 1000277003
	indirect_commands_layout_create_info_nv                             = 1000277004
	generated_commands_info_nv                                          = 1000277005
	generated_commands_memory_requirements_info_nv                      = 1000277006
	physical_device_device_generated_commands_features_nv               = 1000277007
	physical_device_inherited_viewport_scissor_features_nv              = 1000278000
	command_buffer_inheritance_viewport_scissor_info_nv                 = 1000278001
	physical_device_texel_buffer_alignment_features_ext                 = 1000281000
	command_buffer_inheritance_render_pass_transform_info_qcom          = 1000282000
	render_pass_transform_begin_info_qcom                               = 1000282001
	physical_device_depth_bias_control_features_ext                     = 1000283000
	depth_bias_info_ext                                                 = 1000283001
	depth_bias_representation_info_ext                                  = 1000283002
	physical_device_device_memory_report_features_ext                   = 1000284000
	device_device_memory_report_create_info_ext                         = 1000284001
	device_memory_report_callback_data_ext                              = 1000284002
	physical_device_robustness2_features_ext                            = 1000286000
	physical_device_robustness2_properties_ext                          = 1000286001
	sampler_custom_border_color_create_info_ext                         = 1000287000
	physical_device_custom_border_color_properties_ext                  = 1000287001
	physical_device_custom_border_color_features_ext                    = 1000287002
	pipeline_library_create_info_khr                                    = 1000290000
	physical_device_present_barrier_features_nv                         = 1000292000
	surface_capabilities_present_barrier_nv                             = 1000292001
	swapchain_present_barrier_create_info_nv                            = 1000292002
	present_id_khr                                                      = 1000294000
	physical_device_present_id_features_khr                             = 1000294001
	video_encode_info_khr                                               = 1000299000
	video_encode_rate_control_info_khr                                  = 1000299001
	video_encode_rate_control_layer_info_khr                            = 1000299002
	video_encode_capabilities_khr                                       = 1000299003
	video_encode_usage_info_khr                                         = 1000299004
	query_pool_video_encode_feedback_create_info_khr                    = 1000299005
	physical_device_video_encode_quality_level_info_khr                 = 1000299006
	video_encode_quality_level_properties_khr                           = 1000299007
	video_encode_quality_level_info_khr                                 = 1000299008
	video_encode_session_parameters_get_info_khr                        = 1000299009
	video_encode_session_parameters_feedback_info_khr                   = 1000299010
	physical_device_diagnostics_config_features_nv                      = 1000300000
	device_diagnostics_config_create_info_nv                            = 1000300001
	cuda_module_create_info_nv                                          = 1000307000
	cuda_function_create_info_nv                                        = 1000307001
	cuda_launch_info_nv                                                 = 1000307002
	physical_device_cuda_kernel_launch_features_nv                      = 1000307003
	physical_device_cuda_kernel_launch_properties_nv                    = 1000307004
	query_low_latency_support_nv                                        = 1000310000
	export_metal_object_create_info_ext                                 = 1000311000
	export_metal_objects_info_ext                                       = 1000311001
	export_metal_device_info_ext                                        = 1000311002
	export_metal_command_queue_info_ext                                 = 1000311003
	export_metal_buffer_info_ext                                        = 1000311004
	import_metal_buffer_info_ext                                        = 1000311005
	export_metal_texture_info_ext                                       = 1000311006
	import_metal_texture_info_ext                                       = 1000311007
	export_metal_io_surface_info_ext                                    = 1000311008
	import_metal_io_surface_info_ext                                    = 1000311009
	export_metal_shared_event_info_ext                                  = 1000311010
	import_metal_shared_event_info_ext                                  = 1000311011
	queue_family_checkpoint_properties2_nv                              = 1000314008
	checkpoint_data2_nv                                                 = 1000314009
	physical_device_descriptor_buffer_properties_ext                    = 1000316000
	physical_device_descriptor_buffer_density_map_properties_ext        = 1000316001
	physical_device_descriptor_buffer_features_ext                      = 1000316002
	descriptor_address_info_ext                                         = 1000316003
	descriptor_get_info_ext                                             = 1000316004
	buffer_capture_descriptor_data_info_ext                             = 1000316005
	image_capture_descriptor_data_info_ext                              = 1000316006
	image_view_capture_descriptor_data_info_ext                         = 1000316007
	sampler_capture_descriptor_data_info_ext                            = 1000316008
	opaque_capture_descriptor_data_create_info_ext                      = 1000316010
	descriptor_buffer_binding_info_ext                                  = 1000316011
	descriptor_buffer_binding_push_descriptor_buffer_handle_ext         = 1000316012
	acceleration_structure_capture_descriptor_data_info_ext             = 1000316009
	physical_device_graphics_pipeline_library_features_ext              = 1000320000
	physical_device_graphics_pipeline_library_properties_ext            = 1000320001
	graphics_pipeline_library_create_info_ext                           = 1000320002
	physical_device_shader_early_and_late_fragment_tests_features_amd   = 1000321000
	physical_device_fragment_shader_barycentric_features_khr            = 1000203000
	physical_device_fragment_shader_barycentric_properties_khr          = 1000322000
	physical_device_shader_subgroup_uniform_control_flow_features_khr   = 1000323000
	physical_device_fragment_shading_rate_enums_properties_nv           = 1000326000
	physical_device_fragment_shading_rate_enums_features_nv             = 1000326001
	pipeline_fragment_shading_rate_enum_state_create_info_nv            = 1000326002
	acceleration_structure_geometry_motion_triangles_data_nv            = 1000327000
	physical_device_ray_tracing_motion_blur_features_nv                 = 1000327001
	acceleration_structure_motion_info_nv                               = 1000327002
	physical_device_mesh_shader_features_ext                            = 1000328000
	physical_device_mesh_shader_properties_ext                          = 1000328001
	physical_device_ycbcr2_plane444_formats_features_ext                = 1000330000
	physical_device_fragment_density_map2_features_ext                  = 1000332000
	physical_device_fragment_density_map2_properties_ext                = 1000332001
	copy_command_transform_info_qcom                                    = 1000333000
	physical_device_workgroup_memory_explicit_layout_features_khr       = 1000336000
	physical_device_image_compression_control_features_ext              = 1000338000
	image_compression_control_ext                                       = 1000338001
	image_compression_properties_ext                                    = 1000338004
	physical_device_attachment_feedback_loop_layout_features_ext        = 1000339000
	physical_device4444_formats_features_ext                            = 1000340000
	physical_device_fault_features_ext                                  = 1000341000
	device_fault_counts_ext                                             = 1000341001
	device_fault_info_ext                                               = 1000341002
	physical_device_rgba10x6_formats_features_ext                       = 1000344000
	directfb_surface_create_info_ext                                    = 1000346000
	physical_device_vertex_input_dynamic_state_features_ext             = 1000352000
	vertex_input_binding_description2_ext                               = 1000352001
	vertex_input_attribute_description2_ext                             = 1000352002
	physical_device_drm_properties_ext                                  = 1000353000
	physical_device_address_binding_report_features_ext                 = 1000354000
	device_address_binding_callback_data_ext                            = 1000354001
	physical_device_depth_clip_control_features_ext                     = 1000355000
	pipeline_viewport_depth_clip_control_create_info_ext                = 1000355001
	physical_device_primitive_topology_list_restart_features_ext        = 1000356000
	import_memory_zircon_handle_info_fuchsia                            = 1000364000
	memory_zircon_handle_properties_fuchsia                             = 1000364001
	memory_get_zircon_handle_info_fuchsia                               = 1000364002
	import_semaphore_zircon_handle_info_fuchsia                         = 1000365000
	semaphore_get_zircon_handle_info_fuchsia                            = 1000365001
	buffer_collection_create_info_fuchsia                               = 1000366000
	import_memory_buffer_collection_fuchsia                             = 1000366001
	buffer_collection_image_create_info_fuchsia                         = 1000366002
	buffer_collection_properties_fuchsia                                = 1000366003
	buffer_constraints_info_fuchsia                                     = 1000366004
	buffer_collection_buffer_create_info_fuchsia                        = 1000366005
	image_constraints_info_fuchsia                                      = 1000366006
	image_format_constraints_info_fuchsia                               = 1000366007
	sysmem_color_space_fuchsia                                          = 1000366008
	buffer_collection_constraints_info_fuchsia                          = 1000366009
	subpass_shading_pipeline_create_info_huawei                         = 1000369000
	physical_device_subpass_shading_features_huawei                     = 1000369001
	physical_device_subpass_shading_properties_huawei                   = 1000369002
	physical_device_invocation_mask_features_huawei                     = 1000370000
	memory_get_remote_address_info_nv                                   = 1000371000
	physical_device_external_memory_rdma_features_nv                    = 1000371001
	pipeline_properties_identifier_ext                                  = 1000372000
	physical_device_pipeline_properties_features_ext                    = 1000372001
	physical_device_frame_boundary_features_ext                         = 1000375000
	frame_boundary_ext                                                  = 1000375001
	physical_device_multisampled_render_to_single_sampled_features_ext  = 1000376000
	subpass_resolve_performance_query_ext                               = 1000376001
	multisampled_render_to_single_sampled_info_ext                      = 1000376002
	physical_device_extended_dynamic_state2_features_ext                = 1000377000
	screen_surface_create_info_qnx                                      = 1000378000
	physical_device_color_write_enable_features_ext                     = 1000381000
	pipeline_color_write_create_info_ext                                = 1000381001
	physical_device_primitives_generated_query_features_ext             = 1000382000
	physical_device_ray_tracing_maintenance1_features_khr               = 1000386000
	physical_device_image_view_min_lod_features_ext                     = 1000391000
	image_view_min_lod_create_info_ext                                  = 1000391001
	physical_device_multi_draw_features_ext                             = 1000392000
	physical_device_multi_draw_properties_ext                           = 1000392001
	physical_device_image2d_view_of3d_features_ext                      = 1000393000
	physical_device_shader_tile_image_features_ext                      = 1000395000
	physical_device_shader_tile_image_properties_ext                    = 1000395001
	micromap_build_info_ext                                             = 1000396000
	micromap_version_info_ext                                           = 1000396001
	copy_micromap_info_ext                                              = 1000396002
	copy_micromap_to_memory_info_ext                                    = 1000396003
	copy_memory_to_micromap_info_ext                                    = 1000396004
	physical_device_opacity_micromap_features_ext                       = 1000396005
	physical_device_opacity_micromap_properties_ext                     = 1000396006
	micromap_create_info_ext                                            = 1000396007
	micromap_build_sizes_info_ext                                       = 1000396008
	acceleration_structure_triangles_opacity_micromap_ext               = 1000396009
	physical_device_cluster_culling_shader_features_huawei              = 1000404000
	physical_device_cluster_culling_shader_properties_huawei            = 1000404001
	physical_device_cluster_culling_shader_vrs_features_huawei          = 1000404002
	physical_device_border_color_swizzle_features_ext                   = 1000411000
	sampler_border_color_component_mapping_create_info_ext              = 1000411001
	physical_device_pageable_device_local_memory_features_ext           = 1000412000
	physical_device_shader_core_properties_arm                          = 1000415000
	device_queue_shader_core_control_create_info_arm                    = 1000417000
	physical_device_scheduling_controls_features_arm                    = 1000417001
	physical_device_scheduling_controls_properties_arm                  = 1000417002
	physical_device_image_sliced_view_of3d_features_ext                 = 1000418000
	image_view_sliced_create_info_ext                                   = 1000418001
	physical_device_descriptor_set_host_mapping_features_valve          = 1000420000
	descriptor_set_binding_reference_valve                              = 1000420001
	descriptor_set_layout_host_mapping_info_valve                       = 1000420002
	physical_device_depth_clamp_zero_one_features_ext                   = 1000421000
	physical_device_non_seamless_cube_map_features_ext                  = 1000422000
	physical_device_render_pass_striped_features_arm                    = 1000424000
	physical_device_render_pass_striped_properties_arm                  = 1000424001
	render_pass_stripe_begin_info_arm                                   = 1000424002
	render_pass_stripe_info_arm                                         = 1000424003
	render_pass_stripe_submit_info_arm                                  = 1000424004
	physical_device_fragment_density_map_offset_features_qcom           = 1000425000
	physical_device_fragment_density_map_offset_properties_qcom         = 1000425001
	subpass_fragment_density_map_offset_end_info_qcom                   = 1000425002
	physical_device_copy_memory_indirect_features_nv                    = 1000426000
	physical_device_copy_memory_indirect_properties_nv                  = 1000426001
	physical_device_memory_decompression_features_nv                    = 1000427000
	physical_device_memory_decompression_properties_nv                  = 1000427001
	physical_device_device_generated_commands_compute_features_nv       = 1000428000
	compute_pipeline_indirect_buffer_info_nv                            = 1000428001
	pipeline_indirect_device_address_info_nv                            = 1000428002
	physical_device_linear_color_attachment_features_nv                 = 1000430000
	physical_device_image_compression_control_swapchain_features_ext    = 1000437000
	physical_device_image_processing_features_qcom                      = 1000440000
	physical_device_image_processing_properties_qcom                    = 1000440001
	image_view_sample_weight_create_info_qcom                           = 1000440002
	physical_device_nested_command_buffer_features_ext                  = 1000451000
	physical_device_nested_command_buffer_properties_ext                = 1000451001
	external_memory_acquire_unmodified_ext                              = 1000453000
	physical_device_extended_dynamic_state3_features_ext                = 1000455000
	physical_device_extended_dynamic_state3_properties_ext              = 1000455001
	physical_device_subpass_merge_feedback_features_ext                 = 1000458000
	render_pass_creation_control_ext                                    = 1000458001
	render_pass_creation_feedback_create_info_ext                       = 1000458002
	render_pass_subpass_feedback_create_info_ext                        = 1000458003
	direct_driver_loading_info_lunarg                                   = 1000459000
	direct_driver_loading_list_lunarg                                   = 1000459001
	physical_device_shader_module_identifier_features_ext               = 1000462000
	physical_device_shader_module_identifier_properties_ext             = 1000462001
	pipeline_shader_stage_module_identifier_create_info_ext             = 1000462002
	shader_module_identifier_ext                                        = 1000462003
	physical_device_rasterization_order_attachment_access_features_ext  = 1000342000
	physical_device_optical_flow_features_nv                            = 1000464000
	physical_device_optical_flow_properties_nv                          = 1000464001
	optical_flow_image_format_info_nv                                   = 1000464002
	optical_flow_image_format_properties_nv                             = 1000464003
	optical_flow_session_create_info_nv                                 = 1000464004
	optical_flow_execute_info_nv                                        = 1000464005
	optical_flow_session_create_private_data_info_nv                    = 1000464010
	physical_device_legacy_dithering_features_ext                       = 1000465000
	physical_device_pipeline_protected_access_features_ext              = 1000466000
	physical_device_external_format_resolve_features_android            = 1000468000
	physical_device_external_format_resolve_properties_android          = 1000468001
	android_hardware_buffer_format_resolve_properties_android           = 1000468002
	physical_device_maintenance5_features_khr                           = 1000470000
	physical_device_maintenance5_properties_khr                         = 1000470001
	rendering_area_info_khr                                             = 1000470003
	device_image_subresource_info_khr                                   = 1000470004
	subresource_layout2_khr                                             = 1000338002
	image_subresource2_khr                                              = 1000338003
	pipeline_create_flags2_create_info_khr                              = 1000470005
	buffer_usage_flags2_create_info_khr                                 = 1000470006
	physical_device_ray_tracing_position_fetch_features_khr             = 1000481000
	physical_device_shader_object_features_ext                          = 1000482000
	physical_device_shader_object_properties_ext                        = 1000482001
	shader_create_info_ext                                              = 1000482002
	physical_device_tile_properties_features_qcom                       = 1000484000
	tile_properties_qcom                                                = 1000484001
	physical_device_amigo_profiling_features_sec                        = 1000485000
	amigo_profiling_submit_info_sec                                     = 1000485001
	physical_device_multiview_per_view_viewports_features_qcom          = 1000488000
	physical_device_ray_tracing_invocation_reorder_features_nv          = 1000490000
	physical_device_ray_tracing_invocation_reorder_properties_nv        = 1000490001
	physical_device_extended_sparse_address_space_features_nv           = 1000492000
	physical_device_extended_sparse_address_space_properties_nv         = 1000492001
	physical_device_mutable_descriptor_type_features_ext                = 1000351000
	mutable_descriptor_type_create_info_ext                             = 1000351002
	layer_settings_create_info_ext                                      = 1000496000
	physical_device_shader_core_builtins_features_arm                   = 1000497000
	physical_device_shader_core_builtins_properties_arm                 = 1000497001
	physical_device_pipeline_library_group_handles_features_ext         = 1000498000
	physical_device_dynamic_rendering_unused_attachments_features_ext   = 1000499000
	latency_sleep_mode_info_nv                                          = 1000505000
	latency_sleep_info_nv                                               = 1000505001
	set_latency_marker_info_nv                                          = 1000505002
	get_latency_marker_info_nv                                          = 1000505003
	latency_timings_frame_report_nv                                     = 1000505004
	latency_submission_present_id_nv                                    = 1000505005
	out_of_band_queue_type_info_nv                                      = 1000505006
	swapchain_latency_create_info_nv                                    = 1000505007
	latency_surface_capabilities_nv                                     = 1000505008
	physical_device_cooperative_matrix_features_khr                     = 1000506000
	cooperative_matrix_properties_khr                                   = 1000506001
	physical_device_cooperative_matrix_properties_khr                   = 1000506002
	physical_device_multiview_per_view_render_areas_features_qcom       = 1000510000
	multiview_per_view_render_areas_render_pass_begin_info_qcom         = 1000510001
	physical_device_video_maintenance1_features_khr                     = 1000515000
	video_inline_query_info_khr                                         = 1000515001
	physical_device_per_stage_descriptor_set_features_nv                = 1000516000
	physical_device_image_processing2_features_qcom                     = 1000518000
	physical_device_image_processing2_properties_qcom                   = 1000518001
	sampler_block_match_window_create_info_qcom                         = 1000518002
	sampler_cubic_weights_create_info_qcom                              = 1000519000
	physical_device_cubic_weights_features_qcom                         = 1000519001
	blit_image_cubic_weights_info_qcom                                  = 1000519002
	physical_device_ycbcr_degamma_features_qcom                         = 1000520000
	sampler_ycbcr_conversion_ycbcr_degamma_create_info_qcom             = 1000520001
	physical_device_cubic_clamp_features_qcom                           = 1000521000
	physical_device_attachment_feedback_loop_dynamic_state_features_ext = 1000524000
	physical_device_vertex_attribute_divisor_properties_khr             = 1000525000
	pipeline_vertex_input_divisor_state_create_info_khr                 = 1000190001
	physical_device_vertex_attribute_divisor_features_khr               = 1000190002
	screen_buffer_properties_qnx                                        = 1000529000
	screen_buffer_format_properties_qnx                                 = 1000529001
	import_screen_buffer_info_qnx                                       = 1000529002
	external_format_qnx                                                 = 1000529003
	physical_device_external_memory_screen_buffer_features_qnx          = 1000529004
	physical_device_layered_driver_properties_msft                      = 1000530000
	calibrated_timestamp_info_khr                                       = 1000184000
	physical_device_maintenance6_features_khr                           = 1000545000
	physical_device_maintenance6_properties_khr                         = 1000545001
	bind_memory_status_khr                                              = 1000545002
	bind_descriptor_sets_info_khr                                       = 1000545003
	push_constants_info_khr                                             = 1000545004
	push_descriptor_set_info_khr                                        = 1000545005
	push_descriptor_set_with_template_info_khr                          = 1000545006
	set_descriptor_buffer_offsets_info_ext                              = 1000545007
	bind_descriptor_buffer_embedded_samplers_info_ext                   = 1000545008
	physical_device_descriptor_pool_overallocation_features_nv          = 1000546000
	max_enum                                                            = max_int
}

pub enum PipelineCacheHeaderVersion {
	one      = 1
	max_enum = max_int
}

pub enum ImageLayout {
	undefined                                    = 0
	general                                      = 1
	color_attachment_optimal                     = 2
	depth_stencil_attachment_optimal             = 3
	depth_stencil_read_only_optimal              = 4
	shader_read_only_optimal                     = 5
	transfer_src_optimal                         = 6
	transfer_dst_optimal                         = 7
	preinitialized                               = 8
	depth_read_only_stencil_attachment_optimal   = 1000117000
	depth_attachment_stencil_read_only_optimal   = 1000117001
	depth_attachment_optimal                     = 1000241000
	depth_read_only_optimal                      = 1000241001
	stencil_attachment_optimal                   = 1000241002
	stencil_read_only_optimal                    = 1000241003
	read_only_optimal                            = 1000314000
	attachment_optimal                           = 1000314001
	present_src_khr                              = 1000001002
	video_decode_dst_khr                         = 1000024000
	video_decode_src_khr                         = 1000024001
	video_decode_dpb_khr                         = 1000024002
	shared_present_khr                           = 1000111000
	fragment_density_map_optimal_ext             = 1000218000
	fragment_shading_rate_attachment_optimal_khr = 1000164003
	video_encode_dst_khr                         = 1000299000
	video_encode_src_khr                         = 1000299001
	video_encode_dpb_khr                         = 1000299002
	attachment_feedback_loop_optimal_ext         = 1000339000
	max_enum                                     = max_int
}

pub enum ObjectType {
	unknown                         = 0
	instance                        = 1
	physical_device                 = 2
	device                          = 3
	queue                           = 4
	semaphore                       = 5
	command_buffer                  = 6
	fence                           = 7
	device_memory                   = 8
	buffer                          = 9
	image                           = 10
	event                           = 11
	query_pool                      = 12
	buffer_view                     = 13
	image_view                      = 14
	shader_module                   = 15
	pipeline_cache                  = 16
	pipeline_layout                 = 17
	render_pass                     = 18
	pipeline                        = 19
	descriptor_set_layout           = 20
	sampler                         = 21
	descriptor_pool                 = 22
	descriptor_set                  = 23
	framebuffer                     = 24
	command_pool                    = 25
	sampler_ycbcr_conversion        = 1000156000
	descriptor_update_template      = 1000085000
	private_data_slot               = 1000295000
	surface_khr                     = 1000000000
	swapchain_khr                   = 1000001000
	display_khr                     = 1000002000
	display_mode_khr                = 1000002001
	debug_report_callback_ext       = 1000011000
	video_session_khr               = 1000023000
	video_session_parameters_khr    = 1000023001
	cu_module_nvx                   = 1000029000
	cu_function_nvx                 = 1000029001
	debug_utils_messenger_ext       = 1000128000
	acceleration_structure_khr      = 1000150000
	validation_cache_ext            = 1000160000
	acceleration_structure_nv       = 1000165000
	performance_configuration_intel = 1000210000
	deferred_operation_khr          = 1000268000
	indirect_commands_layout_nv     = 1000277000
	cuda_module_nv                  = 1000307000
	cuda_function_nv                = 1000307001
	buffer_collection_fuchsia       = 1000366000
	micromap_ext                    = 1000396000
	optical_flow_session_nv         = 1000464000
	shader_ext                      = 1000482000
	max_enum                        = max_int
}

pub enum VendorId {
	viv      = int(0x10001)
	vsi      = int(0x10002)
	kazan    = int(0x10003)
	codeplay = int(0x10004)
	mesa     = int(0x10005)
	pocl     = int(0x10006)
	mobileye = int(0x10007)
	max_enum = max_int
}

pub enum SystemAllocationScope {
	command  = 0
	object   = 1
	cache    = 2
	device   = 3
	instance = 4
	max_enum = max_int
}

pub enum InternalAllocationType {
	executable = 0
	max_enum   = max_int
}

pub enum Format {
	undefined                                = 0
	r4g4_unorm_pack8                         = 1
	r4g4b4a4_unorm_pack16                    = 2
	b4g4r4a4_unorm_pack16                    = 3
	r5g6b5_unorm_pack16                      = 4
	b5g6r5_unorm_pack16                      = 5
	r5g5b5a1_unorm_pack16                    = 6
	b5g5r5a1_unorm_pack16                    = 7
	a1r5g5b5_unorm_pack16                    = 8
	r8_unorm                                 = 9
	r8_snorm                                 = 10
	r8_uscaled                               = 11
	r8_sscaled                               = 12
	r8_uint                                  = 13
	r8_sint                                  = 14
	r8_srgb                                  = 15
	r8g8_unorm                               = 16
	r8g8_snorm                               = 17
	r8g8_uscaled                             = 18
	r8g8_sscaled                             = 19
	r8g8_uint                                = 20
	r8g8_sint                                = 21
	r8g8_srgb                                = 22
	r8g8b8_unorm                             = 23
	r8g8b8_snorm                             = 24
	r8g8b8_uscaled                           = 25
	r8g8b8_sscaled                           = 26
	r8g8b8_uint                              = 27
	r8g8b8_sint                              = 28
	r8g8b8_srgb                              = 29
	b8g8r8_unorm                             = 30
	b8g8r8_snorm                             = 31
	b8g8r8_uscaled                           = 32
	b8g8r8_sscaled                           = 33
	b8g8r8_uint                              = 34
	b8g8r8_sint                              = 35
	b8g8r8_srgb                              = 36
	r8g8b8a8_unorm                           = 37
	r8g8b8a8_snorm                           = 38
	r8g8b8a8_uscaled                         = 39
	r8g8b8a8_sscaled                         = 40
	r8g8b8a8_uint                            = 41
	r8g8b8a8_sint                            = 42
	r8g8b8a8_srgb                            = 43
	b8g8r8a8_unorm                           = 44
	b8g8r8a8_snorm                           = 45
	b8g8r8a8_uscaled                         = 46
	b8g8r8a8_sscaled                         = 47
	b8g8r8a8_uint                            = 48
	b8g8r8a8_sint                            = 49
	b8g8r8a8_srgb                            = 50
	a8b8g8r8_unorm_pack32                    = 51
	a8b8g8r8_snorm_pack32                    = 52
	a8b8g8r8_uscaled_pack32                  = 53
	a8b8g8r8_sscaled_pack32                  = 54
	a8b8g8r8_uint_pack32                     = 55
	a8b8g8r8_sint_pack32                     = 56
	a8b8g8r8_srgb_pack32                     = 57
	a2r10g10b10_unorm_pack32                 = 58
	a2r10g10b10_snorm_pack32                 = 59
	a2r10g10b10_uscaled_pack32               = 60
	a2r10g10b10_sscaled_pack32               = 61
	a2r10g10b10_uint_pack32                  = 62
	a2r10g10b10_sint_pack32                  = 63
	a2b10g10r10_unorm_pack32                 = 64
	a2b10g10r10_snorm_pack32                 = 65
	a2b10g10r10_uscaled_pack32               = 66
	a2b10g10r10_sscaled_pack32               = 67
	a2b10g10r10_uint_pack32                  = 68
	a2b10g10r10_sint_pack32                  = 69
	r16_unorm                                = 70
	r16_snorm                                = 71
	r16_uscaled                              = 72
	r16_sscaled                              = 73
	r16_uint                                 = 74
	r16_sint                                 = 75
	r16_sfloat                               = 76
	r16g16_unorm                             = 77
	r16g16_snorm                             = 78
	r16g16_uscaled                           = 79
	r16g16_sscaled                           = 80
	r16g16_uint                              = 81
	r16g16_sint                              = 82
	r16g16_sfloat                            = 83
	r16g16b16_unorm                          = 84
	r16g16b16_snorm                          = 85
	r16g16b16_uscaled                        = 86
	r16g16b16_sscaled                        = 87
	r16g16b16_uint                           = 88
	r16g16b16_sint                           = 89
	r16g16b16_sfloat                         = 90
	r16g16b16a16_unorm                       = 91
	r16g16b16a16_snorm                       = 92
	r16g16b16a16_uscaled                     = 93
	r16g16b16a16_sscaled                     = 94
	r16g16b16a16_uint                        = 95
	r16g16b16a16_sint                        = 96
	r16g16b16a16_sfloat                      = 97
	r32_uint                                 = 98
	r32_sint                                 = 99
	r32_sfloat                               = 100
	r32g32_uint                              = 101
	r32g32_sint                              = 102
	r32g32_sfloat                            = 103
	r32g32b32_uint                           = 104
	r32g32b32_sint                           = 105
	r32g32b32_sfloat                         = 106
	r32g32b32a32_uint                        = 107
	r32g32b32a32_sint                        = 108
	r32g32b32a32_sfloat                      = 109
	r64_uint                                 = 110
	r64_sint                                 = 111
	r64_sfloat                               = 112
	r64g64_uint                              = 113
	r64g64_sint                              = 114
	r64g64_sfloat                            = 115
	r64g64b64_uint                           = 116
	r64g64b64_sint                           = 117
	r64g64b64_sfloat                         = 118
	r64g64b64a64_uint                        = 119
	r64g64b64a64_sint                        = 120
	r64g64b64a64_sfloat                      = 121
	b10g11r11_ufloat_pack32                  = 122
	e5b9g9r9_ufloat_pack32                   = 123
	d16_unorm                                = 124
	x8_d24_unorm_pack32                      = 125
	d32_sfloat                               = 126
	s8_uint                                  = 127
	d16_unorm_s8_uint                        = 128
	d24_unorm_s8_uint                        = 129
	d32_sfloat_s8_uint                       = 130
	bc1_rgb_unorm_block                      = 131
	bc1_rgb_srgb_block                       = 132
	bc1_rgba_unorm_block                     = 133
	bc1_rgba_srgb_block                      = 134
	bc2_unorm_block                          = 135
	bc2_srgb_block                           = 136
	bc3_unorm_block                          = 137
	bc3_srgb_block                           = 138
	bc4_unorm_block                          = 139
	bc4_snorm_block                          = 140
	bc5_unorm_block                          = 141
	bc5_snorm_block                          = 142
	bc6h_ufloat_block                        = 143
	bc6h_sfloat_block                        = 144
	bc7_unorm_block                          = 145
	bc7_srgb_block                           = 146
	etc2_r8g8b8_unorm_block                  = 147
	etc2_r8g8b8_srgb_block                   = 148
	etc2_r8g8b8a1_unorm_block                = 149
	etc2_r8g8b8a1_srgb_block                 = 150
	etc2_r8g8b8a8_unorm_block                = 151
	etc2_r8g8b8a8_srgb_block                 = 152
	eac_r11_unorm_block                      = 153
	eac_r11_snorm_block                      = 154
	eac_r11g11_unorm_block                   = 155
	eac_r11g11_snorm_block                   = 156
	astc4x4_unorm_block                      = 157
	astc4x4_srgb_block                       = 158
	astc5x4_unorm_block                      = 159
	astc5x4_srgb_block                       = 160
	astc5x5_unorm_block                      = 161
	astc5x5_srgb_block                       = 162
	astc6x5_unorm_block                      = 163
	astc6x5_srgb_block                       = 164
	astc6x6_unorm_block                      = 165
	astc6x6_srgb_block                       = 166
	astc8x5_unorm_block                      = 167
	astc8x5_srgb_block                       = 168
	astc8x6_unorm_block                      = 169
	astc8x6_srgb_block                       = 170
	astc8x8_unorm_block                      = 171
	astc8x8_srgb_block                       = 172
	astc10x5_unorm_block                     = 173
	astc10x5_srgb_block                      = 174
	astc10x6_unorm_block                     = 175
	astc10x6_srgb_block                      = 176
	astc10x8_unorm_block                     = 177
	astc10x8_srgb_block                      = 178
	astc10x10_unorm_block                    = 179
	astc10x10_srgb_block                     = 180
	astc12x10_unorm_block                    = 181
	astc12x10_srgb_block                     = 182
	astc12x12_unorm_block                    = 183
	astc12x12_srgb_block                     = 184
	g8b8g8r8_422_unorm                       = 1000156000
	b8g8r8g8_422_unorm                       = 1000156001
	g8_b8_r8_3plane420_unorm                 = 1000156002
	g8_b8r8_2plane420_unorm                  = 1000156003
	g8_b8_r8_3plane422_unorm                 = 1000156004
	g8_b8r8_2plane422_unorm                  = 1000156005
	g8_b8_r8_3plane444_unorm                 = 1000156006
	r10x6_unorm_pack16                       = 1000156007
	r10x6g10x6_unorm2pack16                  = 1000156008
	r10x6g10x6b10x6a10x6_unorm4pack16        = 1000156009
	g10x6b10x6g10x6r10x6_422_unorm4pack16    = 1000156010
	b10x6g10x6r10x6g10x6_422_unorm4pack16    = 1000156011
	g10x6_b10x6_r10x6_3plane420_unorm3pack16 = 1000156012
	g10x6_b10x6r10x6_2plane420_unorm3pack16  = 1000156013
	g10x6_b10x6_r10x6_3plane422_unorm3pack16 = 1000156014
	g10x6_b10x6r10x6_2plane422_unorm3pack16  = 1000156015
	g10x6_b10x6_r10x6_3plane444_unorm3pack16 = 1000156016
	r12x4_unorm_pack16                       = 1000156017
	r12x4g12x4_unorm2pack16                  = 1000156018
	r12x4g12x4b12x4a12x4_unorm4pack16        = 1000156019
	g12x4b12x4g12x4r12x4_422_unorm4pack16    = 1000156020
	b12x4g12x4r12x4g12x4_422_unorm4pack16    = 1000156021
	g12x4_b12x4_r12x4_3plane420_unorm3pack16 = 1000156022
	g12x4_b12x4r12x4_2plane420_unorm3pack16  = 1000156023
	g12x4_b12x4_r12x4_3plane422_unorm3pack16 = 1000156024
	g12x4_b12x4r12x4_2plane422_unorm3pack16  = 1000156025
	g12x4_b12x4_r12x4_3plane444_unorm3pack16 = 1000156026
	g16b16g16r16_422_unorm                   = 1000156027
	b16g16r16g16_422_unorm                   = 1000156028
	g16_b16_r16_3plane420_unorm              = 1000156029
	g16_b16r16_2plane420_unorm               = 1000156030
	g16_b16_r16_3plane422_unorm              = 1000156031
	g16_b16r16_2plane422_unorm               = 1000156032
	g16_b16_r16_3plane444_unorm              = 1000156033
	g8_b8r8_2plane444_unorm                  = 1000330000
	g10x6_b10x6r10x6_2plane444_unorm3pack16  = 1000330001
	g12x4_b12x4r12x4_2plane444_unorm3pack16  = 1000330002
	g16_b16r16_2plane444_unorm               = 1000330003
	a4r4g4b4_unorm_pack16                    = 1000340000
	a4b4g4r4_unorm_pack16                    = 1000340001
	astc4x4_sfloat_block                     = 1000066000
	astc5x4_sfloat_block                     = 1000066001
	astc5x5_sfloat_block                     = 1000066002
	astc6x5_sfloat_block                     = 1000066003
	astc6x6_sfloat_block                     = 1000066004
	astc8x5_sfloat_block                     = 1000066005
	astc8x6_sfloat_block                     = 1000066006
	astc8x8_sfloat_block                     = 1000066007
	astc10x5_sfloat_block                    = 1000066008
	astc10x6_sfloat_block                    = 1000066009
	astc10x8_sfloat_block                    = 1000066010
	astc10x10_sfloat_block                   = 1000066011
	astc12x10_sfloat_block                   = 1000066012
	astc12x12_sfloat_block                   = 1000066013
	pvrtc1_2bpp_unorm_block_img              = 1000054000
	pvrtc1_4bpp_unorm_block_img              = 1000054001
	pvrtc2_2bpp_unorm_block_img              = 1000054002
	pvrtc2_4bpp_unorm_block_img              = 1000054003
	pvrtc1_2bpp_srgb_block_img               = 1000054004
	pvrtc1_4bpp_srgb_block_img               = 1000054005
	pvrtc2_2bpp_srgb_block_img               = 1000054006
	pvrtc2_4bpp_srgb_block_img               = 1000054007
	r16g16_s10_5_nv                          = 1000464000
	a1b5g5r5_unorm_pack16_khr                = 1000470000
	a8_unorm_khr                             = 1000470001
	max_enum                                 = max_int
}

pub enum ImageTiling {
	optimal                 = 0
	linear                  = 1
	drm_format_modifier_ext = 1000158000
	max_enum                = max_int
}

pub enum ImageType {
	_1d      = 0
	_2d      = 1
	_3d      = 2
	max_enum = max_int
}

pub enum PhysicalDeviceType {
	other          = 0
	integrated_gpu = 1
	discrete_gpu   = 2
	virtual_gpu    = 3
	cpu            = 4
	max_enum       = max_int
}

pub enum QueryType {
	occlusion                                                      = 0
	pipeline_statistics                                            = 1
	timestamp                                                      = 2
	result_status_only_khr                                         = 1000023000
	transform_feedback_stream_ext                                  = 1000028004
	performance_query_khr                                          = 1000116000
	acceleration_structure_compacted_size_khr                      = 1000150000
	acceleration_structure_serialization_size_khr                  = 1000150001
	acceleration_structure_compacted_size_nv                       = 1000165000
	performance_query_intel                                        = 1000210000
	video_encode_feedback_khr                                      = 1000299000
	mesh_primitives_generated_ext                                  = 1000328000
	primitives_generated_ext                                       = 1000382000
	acceleration_structure_serialization_bottom_level_pointers_khr = 1000386000
	acceleration_structure_size_khr                                = 1000386001
	micromap_serialization_size_ext                                = 1000396000
	micromap_compacted_size_ext                                    = 1000396001
	max_enum                                                       = max_int
}

pub enum SharingMode {
	exclusive  = 0
	concurrent = 1
	max_enum   = max_int
}

pub enum ComponentSwizzle {
	identity = 0
	zero     = 1
	one      = 2
	r        = 3
	g        = 4
	b        = 5
	a        = 6
	max_enum = max_int
}

pub enum ImageViewType {
	_1d        = 0
	_2d        = 1
	_3d        = 2
	cube       = 3
	_1d_array  = 4
	_2d_array  = 5
	cube_array = 6
	max_enum   = max_int
}

pub enum BlendFactor {
	zero                     = 0
	one                      = 1
	src_color                = 2
	one_minus_src_color      = 3
	dst_color                = 4
	one_minus_dst_color      = 5
	src_alpha                = 6
	one_minus_src_alpha      = 7
	dst_alpha                = 8
	one_minus_dst_alpha      = 9
	constant_color           = 10
	one_minus_constant_color = 11
	constant_alpha           = 12
	one_minus_constant_alpha = 13
	src_alpha_saturate       = 14
	src1_color               = 15
	one_minus_src1_color     = 16
	src1_alpha               = 17
	one_minus_src1_alpha     = 18
	max_enum                 = max_int
}

pub enum BlendOp {
	add                    = 0
	subtract               = 1
	reverse_subtract       = 2
	min                    = 3
	max                    = 4
	zero_ext               = 1000148000
	src_ext                = 1000148001
	dst_ext                = 1000148002
	src_over_ext           = 1000148003
	dst_over_ext           = 1000148004
	src_in_ext             = 1000148005
	dst_in_ext             = 1000148006
	src_out_ext            = 1000148007
	dst_out_ext            = 1000148008
	src_atop_ext           = 1000148009
	dst_atop_ext           = 1000148010
	xor_ext                = 1000148011
	multiply_ext           = 1000148012
	screen_ext             = 1000148013
	overlay_ext            = 1000148014
	darken_ext             = 1000148015
	lighten_ext            = 1000148016
	colordodge_ext         = 1000148017
	colorburn_ext          = 1000148018
	hardlight_ext          = 1000148019
	softlight_ext          = 1000148020
	difference_ext         = 1000148021
	exclusion_ext          = 1000148022
	invert_ext             = 1000148023
	invert_rgb_ext         = 1000148024
	lineardodge_ext        = 1000148025
	linearburn_ext         = 1000148026
	vividlight_ext         = 1000148027
	linearlight_ext        = 1000148028
	pinlight_ext           = 1000148029
	hardmix_ext            = 1000148030
	hsl_hue_ext            = 1000148031
	hsl_saturation_ext     = 1000148032
	hsl_color_ext          = 1000148033
	hsl_luminosity_ext     = 1000148034
	plus_ext               = 1000148035
	plus_clamped_ext       = 1000148036
	plus_clamped_alpha_ext = 1000148037
	plus_darker_ext        = 1000148038
	minus_ext              = 1000148039
	minus_clamped_ext      = 1000148040
	contrast_ext           = 1000148041
	invert_ovg_ext         = 1000148042
	red_ext                = 1000148043
	green_ext              = 1000148044
	blue_ext               = 1000148045
	max_enum               = max_int
}

pub enum CompareOp {
	never            = 0
	less             = 1
	equal            = 2
	less_or_equal    = 3
	greater          = 4
	not_equal        = 5
	greater_or_equal = 6
	always           = 7
	max_enum         = max_int
}

pub enum DynamicState {
	viewport                                = 0
	scissor                                 = 1
	line_width                              = 2
	depth_bias                              = 3
	blend_constants                         = 4
	depth_bounds                            = 5
	stencil_compare_mask                    = 6
	stencil_write_mask                      = 7
	stencil_reference                       = 8
	cull_mode                               = 1000267000
	front_face                              = 1000267001
	primitive_topology                      = 1000267002
	viewport_with_count                     = 1000267003
	scissor_with_count                      = 1000267004
	vertex_input_binding_stride             = 1000267005
	depth_test_enable                       = 1000267006
	depth_write_enable                      = 1000267007
	depth_compare_op                        = 1000267008
	depth_bounds_test_enable                = 1000267009
	stencil_test_enable                     = 1000267010
	stencil_op                              = 1000267011
	rasterizer_discard_enable               = 1000377001
	depth_bias_enable                       = 1000377002
	primitive_restart_enable                = 1000377004
	viewport_w_scaling_nv                   = 1000087000
	discard_rectangle_ext                   = 1000099000
	discard_rectangle_enable_ext            = 1000099001
	discard_rectangle_mode_ext              = 1000099002
	sample_locations_ext                    = 1000143000
	ray_tracing_pipeline_stack_size_khr     = 1000347000
	viewport_shading_rate_palette_nv        = 1000164004
	viewport_coarse_sample_order_nv         = 1000164006
	exclusive_scissor_enable_nv             = 1000205000
	exclusive_scissor_nv                    = 1000205001
	fragment_shading_rate_khr               = 1000226000
	line_stipple_ext                        = 1000259000
	vertex_input_ext                        = 1000352000
	patch_control_points_ext                = 1000377000
	logic_op_ext                            = 1000377003
	color_write_enable_ext                  = 1000381000
	tessellation_domain_origin_ext          = 1000455002
	depth_clamp_enable_ext                  = 1000455003
	polygon_mode_ext                        = 1000455004
	rasterization_samples_ext               = 1000455005
	sample_mask_ext                         = 1000455006
	alpha_to_coverage_enable_ext            = 1000455007
	alpha_to_one_enable_ext                 = 1000455008
	logic_op_enable_ext                     = 1000455009
	color_blend_enable_ext                  = 1000455010
	color_blend_equation_ext                = 1000455011
	color_write_mask_ext                    = 1000455012
	rasterization_stream_ext                = 1000455013
	conservative_rasterization_mode_ext     = 1000455014
	extra_primitive_overestimation_size_ext = 1000455015
	depth_clip_enable_ext                   = 1000455016
	sample_locations_enable_ext             = 1000455017
	color_blend_advanced_ext                = 1000455018
	provoking_vertex_mode_ext               = 1000455019
	line_rasterization_mode_ext             = 1000455020
	line_stipple_enable_ext                 = 1000455021
	depth_clip_negative_one_to_one_ext      = 1000455022
	viewport_w_scaling_enable_nv            = 1000455023
	viewport_swizzle_nv                     = 1000455024
	coverage_to_color_enable_nv             = 1000455025
	coverage_to_color_location_nv           = 1000455026
	coverage_modulation_mode_nv             = 1000455027
	coverage_modulation_table_enable_nv     = 1000455028
	coverage_modulation_table_nv            = 1000455029
	shading_rate_image_enable_nv            = 1000455030
	representative_fragment_test_enable_nv  = 1000455031
	coverage_reduction_mode_nv              = 1000455032
	attachment_feedback_loop_enable_ext     = 1000524000
	max_enum                                = max_int
}

pub enum FrontFace {
	counter_clockwise = 0
	clockwise         = 1
	max_enum          = max_int
}

pub enum VertexInputRate {
	vertex   = 0
	instance = 1
	max_enum = max_int
}

pub enum PrimitiveTopology {
	point_list                    = 0
	line_list                     = 1
	line_strip                    = 2
	triangle_list                 = 3
	triangle_strip                = 4
	triangle_fan                  = 5
	line_list_with_adjacency      = 6
	line_strip_with_adjacency     = 7
	triangle_list_with_adjacency  = 8
	triangle_strip_with_adjacency = 9
	patch_list                    = 10
	max_enum                      = max_int
}

pub enum PolygonMode {
	fill              = 0
	line              = 1
	point             = 2
	fill_rectangle_nv = 1000153000
	max_enum          = max_int
}

pub enum StencilOp {
	keep                = 0
	zero                = 1
	replace             = 2
	increment_and_clamp = 3
	decrement_and_clamp = 4
	invert              = 5
	increment_and_wrap  = 6
	decrement_and_wrap  = 7
	max_enum            = max_int
}

pub enum LogicOp {
	clear         = 0
	and           = 1
	and_reverse   = 2
	copy          = 3
	and_inverted  = 4
	no_op         = 5
	xor           = 6
	or            = 7
	nor           = 8
	equivalent    = 9
	invert        = 10
	or_reverse    = 11
	copy_inverted = 12
	or_inverted   = 13
	nand          = 14
	set           = 15
	max_enum      = max_int
}

pub enum BorderColor {
	float_transparent_black = 0
	int_transparent_black   = 1
	float_opaque_black      = 2
	int_opaque_black        = 3
	float_opaque_white      = 4
	int_opaque_white        = 5
	float_custom_ext        = 1000287003
	int_custom_ext          = 1000287004
	max_enum                = max_int
}

pub enum Filter {
	nearest   = 0
	linear    = 1
	cubic_ext = 1000015000
	max_enum  = max_int
}

pub enum SamplerAddressMode {
	repeat               = 0
	mirrored_repeat      = 1
	clamp_to_edge        = 2
	clamp_to_border      = 3
	mirror_clamp_to_edge = 4
	max_enum             = max_int
}

pub enum SamplerMipmapMode {
	nearest  = 0
	linear   = 1
	max_enum = max_int
}

pub enum DescriptorType {
	sampler                    = 0
	combined_image_sampler     = 1
	sampled_image              = 2
	storage_image              = 3
	uniform_texel_buffer       = 4
	storage_texel_buffer       = 5
	uniform_buffer             = 6
	storage_buffer             = 7
	uniform_buffer_dynamic     = 8
	storage_buffer_dynamic     = 9
	input_attachment           = 10
	inline_uniform_block       = 1000138000
	acceleration_structure_khr = 1000150000
	acceleration_structure_nv  = 1000165000
	sample_weight_image_qcom   = 1000440000
	block_match_image_qcom     = 1000440001
	mutable_ext                = 1000351000
	max_enum                   = max_int
}

pub enum AttachmentLoadOp {
	load      = 0
	clear     = 1
	dont_care = 2
	none_ext  = 1000400000
	max_enum  = max_int
}

pub enum AttachmentStoreOp {
	store     = 0
	dont_care = 1
	none      = 1000301000
	max_enum  = max_int
}

pub enum PipelineBindPoint {
	graphics               = 0
	compute                = 1
	ray_tracing_khr        = 1000165000
	subpass_shading_huawei = 1000369003
	max_enum               = max_int
}

pub enum CommandBufferLevel {
	primary   = 0
	secondary = 1
	max_enum  = max_int
}

pub enum IndexType {
	uint16    = 0
	uint32    = 1
	none_khr  = 1000165000
	uint8_ext = 1000265000
	max_enum  = max_int
}

pub enum SubpassContents {
	inline                                   = 0
	secondary_command_buffers                = 1
	inline_and_secondary_command_buffers_ext = 1000451000
	max_enum                                 = max_int
}

pub enum AccessFlagBits {
	indirect_command_read_bit                    = int(0x00000001)
	index_read_bit                               = int(0x00000002)
	vertex_attribute_read_bit                    = int(0x00000004)
	uniform_read_bit                             = int(0x00000008)
	input_attachment_read_bit                    = int(0x00000010)
	shader_read_bit                              = int(0x00000020)
	shader_write_bit                             = int(0x00000040)
	color_attachment_read_bit                    = int(0x00000080)
	color_attachment_write_bit                   = int(0x00000100)
	depth_stencil_attachment_read_bit            = int(0x00000200)
	depth_stencil_attachment_write_bit           = int(0x00000400)
	transfer_read_bit                            = int(0x00000800)
	transfer_write_bit                           = int(0x00001000)
	host_read_bit                                = int(0x00002000)
	host_write_bit                               = int(0x00004000)
	memory_read_bit                              = int(0x00008000)
	memory_write_bit                             = int(0x00010000)
	none                                         = 0
	transform_feedback_write_bit_ext             = int(0x02000000)
	transform_feedback_counter_read_bit_ext      = int(0x04000000)
	transform_feedback_counter_write_bit_ext     = int(0x08000000)
	conditional_rendering_read_bit_ext           = int(0x00100000)
	color_attachment_read_noncoherent_bit_ext    = int(0x00080000)
	acceleration_structure_read_bit_khr          = int(0x00200000)
	acceleration_structure_write_bit_khr         = int(0x00400000)
	ragment_density_map_read_bit_ext             = int(0x01000000)
	ragment_shading_rate_attachment_read_bit_khr = int(0x00800000)
	command_preprocess_read_bit_nv               = int(0x00020000)
	command_preprocess_write_bit_nv              = int(0x00040000)
	max_enum                                     = max_int
}

pub type AccessFlags = u32

pub enum ImageAspectFlagBits {
	color_bit             = int(0x00000001)
	depth_bit             = int(0x00000002)
	stencil_bit           = int(0x00000004)
	metadata_bit          = int(0x00000008)
	plane0_bit            = int(0x00000010)
	plane1_bit            = int(0x00000020)
	plane2_bit            = int(0x00000040)
	none                  = 0
	memory_plane0_bit_ext = int(0x00000080)
	memory_plane1_bit_ext = int(0x00000100)
	memory_plane2_bit_ext = int(0x00000200)
	memory_plane3_bit_ext = int(0x00000400)
	max_enum              = max_int
}

pub type ImageAspectFlags = u32

pub enum FormatFeatureFlagBits {
	sampled_image_bit                                                           = int(0x00000001)
	storage_image_bit                                                           = int(0x00000002)
	storage_image_atomic_bit                                                    = int(0x00000004)
	uniform_texel_buffer_bit                                                    = int(0x00000008)
	storage_texel_buffer_bit                                                    = int(0x00000010)
	storage_texel_buffer_atomic_bit                                             = int(0x00000020)
	vertex_buffer_bit                                                           = int(0x00000040)
	color_attachment_bit                                                        = int(0x00000080)
	color_attachment_blend_bit                                                  = int(0x00000100)
	depth_stencil_attachment_bit                                                = int(0x00000200)
	blit_src_bit                                                                = int(0x00000400)
	blit_dst_bit                                                                = int(0x00000800)
	sampled_image_filter_linear_bit                                             = int(0x00001000)
	transfer_src_bit                                                            = int(0x00004000)
	transfer_dst_bit                                                            = int(0x00008000)
	midpoint_chroma_samples_bit                                                 = int(0x00020000)
	sampled_image_ycbcr_conversion_linear_filter_bit                            = int(0x00040000)
	sampled_image_ycbcr_conversion_separate_reconstruction_filter_bit           = int(0x00080000)
	sampled_image_ycbcr_conversion_chroma_reconstruction_explicit_bit           = int(0x00100000)
	sampled_image_ycbcr_conversion_chroma_reconstruction_explicit_forceable_bit = int(0x00200000)
	disjoint_bit                                                                = int(0x00400000)
	cosited_chroma_samples_bit                                                  = int(0x00800000)
	sampled_image_filter_minmax_bit                                             = int(0x00010000)
	video_decode_output_bit_khr                                                 = int(0x02000000)
	video_decode_dpb_bit_khr                                                    = int(0x04000000)
	acceleration_structure_vertex_buffer_bit_khr                                = int(0x20000000)
	sampled_image_filter_cubic_bit_ext                                          = int(0x00002000)
	ragment_density_map_bit_ext                                                 = int(0x01000000)
	ragment_shading_rate_attachment_bit_khr                                     = int(0x40000000)
	video_encode_input_bit_khr                                                  = int(0x08000000)
	video_encode_dpb_bit_khr                                                    = int(0x10000000)
	max_enum                                                                    = max_int
}

pub type FormatFeatureFlags = u32

pub enum ImageCreateFlagBits {
	sparse_binding_bit                            = int(0x00000001)
	sparse_residency_bit                          = int(0x00000002)
	sparse_aliased_bit                            = int(0x00000004)
	mutable_format_bit                            = int(0x00000008)
	cube_compatible_bit                           = int(0x00000010)
	alias_bit                                     = int(0x00000400)
	split_instance_bind_regions_bit               = int(0x00000040)
	_2d_array_compatible_bit                      = int(0x00000020)
	block_texel_view_compatible_bit               = int(0x00000080)
	extended_usage_bit                            = int(0x00000100)
	protected_bit                                 = int(0x00000800)
	disjoint_bit                                  = int(0x00000200)
	corner_sampled_bit_nv                         = int(0x00002000)
	sample_locations_compatible_depth_bit_ext     = int(0x00001000)
	subsampled_bit_ext                            = int(0x00004000)
	descriptor_buffer_capture_replay_bit_ext      = int(0x00010000)
	multisampled_render_to_single_sampled_bit_ext = int(0x00040000)
	_2d_view_compatible_bit_ext                   = int(0x00020000)
	ragment_density_map_offset_bit_qcom           = int(0x00008000)
	video_profile_independent_bit_khr             = int(0x00100000)
	max_enum                                      = max_int
}

pub type ImageCreateFlags = u32

pub enum SampleCountFlagBits {
	_1_bit   = int(0x00000001)
	_2_bit   = int(0x00000002)
	_4_bit   = int(0x00000004)
	_8_bit   = int(0x00000008)
	_16_bit  = int(0x00000010)
	_32_bit  = int(0x00000020)
	_64_bit  = int(0x00000040)
	max_enum = max_int
}

pub type SampleCountFlags = u32

pub enum ImageUsageFlagBits {
	transfer_src_bit                        = int(0x00000001)
	transfer_dst_bit                        = int(0x00000002)
	sampled_bit                             = int(0x00000004)
	storage_bit                             = int(0x00000008)
	color_attachment_bit                    = int(0x00000010)
	depth_stencil_attachment_bit            = int(0x00000020)
	transient_attachment_bit                = int(0x00000040)
	input_attachment_bit                    = int(0x00000080)
	video_decode_dst_bit_khr                = int(0x00000400)
	video_decode_src_bit_khr                = int(0x00000800)
	video_decode_dpb_bit_khr                = int(0x00001000)
	ragment_density_map_bit_ext             = int(0x00000200)
	ragment_shading_rate_attachment_bit_khr = int(0x00000100)
	host_transfer_bit_ext                   = int(0x00400000)
	video_encode_dst_bit_khr                = int(0x00002000)
	video_encode_src_bit_khr                = int(0x00004000)
	video_encode_dpb_bit_khr                = int(0x00008000)
	attachment_feedback_loop_bit_ext        = int(0x00080000)
	invocation_mask_bit_huawei              = int(0x00040000)
	sample_weight_bit_qcom                  = int(0x00100000)
	sample_block_match_bit_qcom             = int(0x00200000)
	max_enum                                = max_int
}

pub type ImageUsageFlags = u32

pub enum InstanceCreateFlagBits {
	enumerate_portability_bit_khr = int(0x00000001)
	max_enum                      = max_int
}

pub type InstanceCreateFlags = u32

pub enum MemoryHeapFlagBits {
	device_local_bit   = int(0x00000001)
	multi_instance_bit = int(0x00000002)
	max_enum           = max_int
}

pub type MemoryHeapFlags = u32

pub enum MemoryPropertyFlagBits {
	device_local_bit        = int(0x00000001)
	host_visible_bit        = int(0x00000002)
	host_coherent_bit       = int(0x00000004)
	host_cached_bit         = int(0x00000008)
	lazily_allocated_bit    = int(0x00000010)
	protected_bit           = int(0x00000020)
	device_coherent_bit_amd = int(0x00000040)
	device_uncached_bit_amd = int(0x00000080)
	rdma_capable_bit_nv     = int(0x00000100)
	max_enum                = max_int
}

pub type MemoryPropertyFlags = u32

pub enum QueueFlagBits {
	graphics_bit         = int(0x00000001)
	compute_bit          = int(0x00000002)
	transfer_bit         = int(0x00000004)
	sparse_binding_bit   = int(0x00000008)
	protected_bit        = int(0x00000010)
	video_decode_bit_khr = int(0x00000020)
	video_encode_bit_khr = int(0x00000040)
	optical_flow_bit_nv  = int(0x00000100)
	max_enum             = max_int
}

pub type QueueFlags = u32
pub type DeviceCreateFlags = u32

pub enum DeviceQueueCreateFlagBits {
	protected_bit = int(0x00000001)
	max_enum      = max_int
}

pub type DeviceQueueCreateFlags = u32

pub enum PipelineStageFlagBits {
	top_of_pipe_bit                         = int(0x00000001)
	draw_indirect_bit                       = int(0x00000002)
	vertex_input_bit                        = int(0x00000004)
	vertex_shader_bit                       = int(0x00000008)
	tessellation_control_shader_bit         = int(0x00000010)
	tessellation_evaluation_shader_bit      = int(0x00000020)
	geometry_shader_bit                     = int(0x00000040)
	ragment_shader_bit                      = int(0x00000080)
	early_fragment_tests_bit                = int(0x00000100)
	late_fragment_tests_bit                 = int(0x00000200)
	color_attachment_output_bit             = int(0x00000400)
	compute_shader_bit                      = int(0x00000800)
	transfer_bit                            = int(0x00001000)
	bottom_of_pipe_bit                      = int(0x00002000)
	host_bit                                = int(0x00004000)
	all_graphics_bit                        = int(0x00008000)
	all_commands_bit                        = int(0x00010000)
	none                                    = 0
	transform_feedback_bit_ext              = int(0x01000000)
	conditional_rendering_bit_ext           = int(0x00040000)
	acceleration_structure_build_bit_khr    = int(0x02000000)
	ray_tracing_shader_bit_khr              = int(0x00200000)
	ragment_density_process_bit_ext         = int(0x00800000)
	ragment_shading_rate_attachment_bit_khr = int(0x00400000)
	command_preprocess_bit_nv               = int(0x00020000)
	task_shader_bit_ext                     = int(0x00080000)
	mesh_shader_bit_ext                     = int(0x00100000)
	max_enum                                = max_int
}

pub type PipelineStageFlags = u32
pub type MemoryMapFlags = u32

pub enum SparseMemoryBindFlagBits {
	metadata_bit = int(0x00000001)
	max_enum     = max_int
}

pub type SparseMemoryBindFlags = u32

pub enum SparseImageFormatFlagBits {
	single_miptail_bit         = int(0x00000001)
	aligned_mip_size_bit       = int(0x00000002)
	nonstandard_block_size_bit = int(0x00000004)
	max_enum                   = max_int
}

pub type SparseImageFormatFlags = u32

pub enum FenceCreateFlagBits {
	signaled_bit = int(0x00000001)
	max_enum     = max_int
}

pub type FenceCreateFlags = u32
pub type SemaphoreCreateFlags = u32

pub enum EventCreateFlagBits {
	device_only_bit = int(0x00000001)
	max_enum        = max_int
}

pub type EventCreateFlags = u32

pub enum QueryPipelineStatisticFlagBits {
	input_assembly_vertices_bit                    = int(0x00000001)
	input_assembly_primitives_bit                  = int(0x00000002)
	vertex_shader_invocations_bit                  = int(0x00000004)
	geometry_shader_invocations_bit                = int(0x00000008)
	geometry_shader_primitives_bit                 = int(0x00000010)
	clipping_invocations_bit                       = int(0x00000020)
	clipping_primitives_bit                        = int(0x00000040)
	ragment_shader_invocations_bit                 = int(0x00000080)
	tessellation_control_shader_patches_bit        = int(0x00000100)
	tessellation_evaluation_shader_invocations_bit = int(0x00000200)
	compute_shader_invocations_bit                 = int(0x00000400)
	task_shader_invocations_bit_ext                = int(0x00000800)
	mesh_shader_invocations_bit_ext                = int(0x00001000)
	cluster_culling_shader_invocations_bit_huawei  = int(0x00002000)
	max_enum                                       = max_int
}

pub type QueryPipelineStatisticFlags = u32
pub type QueryPoolCreateFlags = u32

pub enum QueryResultFlagBits {
	_64_bit               = int(0x00000001)
	wait_bit              = int(0x00000002)
	with_availability_bit = int(0x00000004)
	partial_bit           = int(0x00000008)
	with_status_bit_khr   = int(0x00000010)
	max_enum              = max_int
}

pub type QueryResultFlags = u32

pub enum BufferCreateFlagBits {
	sparse_binding_bit                       = int(0x00000001)
	sparse_residency_bit                     = int(0x00000002)
	sparse_aliased_bit                       = int(0x00000004)
	protected_bit                            = int(0x00000008)
	device_address_capture_replay_bit        = int(0x00000010)
	descriptor_buffer_capture_replay_bit_ext = int(0x00000020)
	video_profile_independent_bit_khr        = int(0x00000040)
	max_enum                                 = max_int
}

pub type BufferCreateFlags = u32

pub enum BufferUsageFlagBits {
	transfer_src_bit                                     = int(0x00000001)
	transfer_dst_bit                                     = int(0x00000002)
	uniform_texel_buffer_bit                             = int(0x00000004)
	storage_texel_buffer_bit                             = int(0x00000008)
	uniform_buffer_bit                                   = int(0x00000010)
	storage_buffer_bit                                   = int(0x00000020)
	index_buffer_bit                                     = int(0x00000040)
	vertex_buffer_bit                                    = int(0x00000080)
	indirect_buffer_bit                                  = int(0x00000100)
	shader_device_address_bit                            = int(0x00020000)
	video_decode_src_bit_khr                             = int(0x00002000)
	video_decode_dst_bit_khr                             = int(0x00004000)
	transform_feedback_buffer_bit_ext                    = int(0x00000800)
	transform_feedback_counter_buffer_bit_ext            = int(0x00001000)
	conditional_rendering_bit_ext                        = int(0x00000200)
	acceleration_structure_build_input_read_only_bit_khr = int(0x00080000)
	acceleration_structure_storage_bit_khr               = int(0x00100000)
	shader_binding_table_bit_khr                         = int(0x00000400)
	video_encode_dst_bit_khr                             = int(0x00008000)
	video_encode_src_bit_khr                             = int(0x00010000)
	sampler_descriptor_buffer_bit_ext                    = int(0x00200000)
	resource_descriptor_buffer_bit_ext                   = int(0x00400000)
	push_descriptors_descriptor_buffer_bit_ext           = int(0x04000000)
	micromap_build_input_read_only_bit_ext               = int(0x00800000)
	micromap_storage_bit_ext                             = int(0x01000000)
	max_enum                                             = max_int
}

pub type BufferUsageFlags = u32
pub type BufferViewCreateFlags = u32

pub enum ImageViewCreateFlagBits {
	ragment_density_map_dynamic_bit_ext      = int(0x00000001)
	descriptor_buffer_capture_replay_bit_ext = int(0x00000004)
	ragment_density_map_deferred_bit_ext     = int(0x00000002)
	max_enum                                 = max_int
}

pub type ImageViewCreateFlags = u32
pub type ShaderModuleCreateFlags = u32

pub enum PipelineCacheCreateFlagBits {
	externally_synchronized_bit = int(0x00000001)
	max_enum                    = max_int
}

pub type PipelineCacheCreateFlags = u32

pub enum ColorComponentFlagBits {
	r_bit    = int(0x00000001)
	g_bit    = int(0x00000002)
	b_bit    = int(0x00000004)
	a_bit    = int(0x00000008)
	max_enum = max_int
}

pub type ColorComponentFlags = u32

pub enum PipelineCreateFlagBits {
	disable_optimization_bit                               = int(0x00000001)
	allow_derivatives_bit                                  = int(0x00000002)
	derivative_bit                                         = int(0x00000004)
	view_index_from_device_index_bit                       = int(0x00000008)
	dispatch_base_bit                                      = int(0x00000010)
	ail_on_pipeline_compile_required_bit                   = int(0x00000100)
	early_return_on_failure_bit                            = int(0x00000200)
	rendering_fragment_shading_rate_attachment_bit_khr     = int(0x00200000)
	rendering_fragment_density_map_attachment_bit_ext      = int(0x00400000)
	ray_tracing_no_null_any_hit_shaders_bit_khr            = int(0x00004000)
	ray_tracing_no_null_closest_hit_shaders_bit_khr        = int(0x00008000)
	ray_tracing_no_null_miss_shaders_bit_khr               = int(0x00010000)
	ray_tracing_no_null_intersection_shaders_bit_khr       = int(0x00020000)
	ray_tracing_skip_triangles_bit_khr                     = int(0x00001000)
	ray_tracing_skip_aabbs_bit_khr                         = int(0x00002000)
	ray_tracing_shader_group_handle_capture_replay_bit_khr = int(0x00080000)
	defer_compile_bit_nv                                   = int(0x00000020)
	capture_statistics_bit_khr                             = int(0x00000040)
	capture_internal_representations_bit_khr               = int(0x00000080)
	indirect_bindable_bit_nv                               = int(0x00040000)
	library_bit_khr                                        = int(0x00000800)
	descriptor_buffer_bit_ext                              = int(0x20000000)
	retain_link_time_optimization_info_bit_ext             = int(0x00800000)
	link_time_optimization_bit_ext                         = int(0x00000400)
	ray_tracing_allow_motion_bit_nv                        = int(0x00100000)
	color_attachment_feedback_loop_bit_ext                 = int(0x02000000)
	depth_stencil_attachment_feedback_loop_bit_ext         = int(0x04000000)
	ray_tracing_opacity_micromap_bit_ext                   = int(0x01000000)
	no_protected_access_bit_ext                            = int(0x08000000)
	protected_access_only_bit_ext                          = int(0x40000000)
	max_enum                                               = max_int
}

pub type PipelineCreateFlags = u32

pub enum PipelineShaderStageCreateFlagBits {
	allow_varying_subgroup_size_bit = int(0x00000001)
	require_full_subgroups_bit      = int(0x00000002)
	max_enum                        = max_int
}

pub type PipelineShaderStageCreateFlags = u32

pub enum ShaderStageFlagBits {
	vertex_bit                  = int(0x00000001)
	tessellation_control_bit    = int(0x00000002)
	tessellation_evaluation_bit = int(0x00000004)
	geometry_bit                = int(0x00000008)
	ragment_bit                 = int(0x00000010)
	compute_bit                 = int(0x00000020)
	all_graphics                = int(0x0000001F)
	all                         = int(0x7FFFFFFF)
	raygen_bit_khr              = int(0x00000100)
	any_hit_bit_khr             = int(0x00000200)
	closest_hit_bit_khr         = int(0x00000400)
	miss_bit_khr                = int(0x00000800)
	intersection_bit_khr        = int(0x00001000)
	callable_bit_khr            = int(0x00002000)
	task_bit_ext                = int(0x00000040)
	mesh_bit_ext                = int(0x00000080)
	subpass_shading_bit_huawei  = int(0x00004000)
	cluster_culling_bit_huawei  = int(0x00080000)
	max_enum                    = max_int
}

pub enum CullModeFlagBits {
	none          = 0
	ront_bit      = int(0x00000001)
	back_bit      = int(0x00000002)
	ront_and_back = int(0x00000003)
	max_enum      = max_int
}

pub type CullModeFlags = u32
pub type PipelineVertexInputStateCreateFlags = u32
pub type PipelineInputAssemblyStateCreateFlags = u32
pub type PipelineTessellationStateCreateFlags = u32
pub type PipelineViewportStateCreateFlags = u32
pub type PipelineRasterizationStateCreateFlags = u32
pub type PipelineMultisampleStateCreateFlags = u32

pub enum PipelineDepthStencilStateCreateFlagBits {
	rasterization_order_attachment_depth_access_bit_ext   = int(0x00000001)
	rasterization_order_attachment_stencil_access_bit_ext = int(0x00000002)
	max_enum                                              = max_int
}

pub type PipelineDepthStencilStateCreateFlags = u32

pub enum PipelineColorBlendStateCreateFlagBits {
	rasterization_order_attachment_access_bit_ext = int(0x00000001)
	max_enum                                      = max_int
}

pub type PipelineColorBlendStateCreateFlags = u32
pub type PipelineDynamicStateCreateFlags = u32

pub enum PipelineLayoutCreateFlagBits {
	independent_sets_bit_ext = int(0x00000002)
	max_enum                 = max_int
}

pub type PipelineLayoutCreateFlags = u32
pub type ShaderStageFlags = u32

pub enum SamplerCreateFlagBits {
	subsampled_bit_ext                       = int(0x00000001)
	subsampled_coarse_reconstruction_bit_ext = int(0x00000002)
	descriptor_buffer_capture_replay_bit_ext = int(0x00000008)
	non_seamless_cube_map_bit_ext            = int(0x00000004)
	image_processing_bit_qcom                = int(0x00000010)
	max_enum                                 = max_int
}

pub type SamplerCreateFlags = u32

pub enum DescriptorPoolCreateFlagBits {
	ree_descriptor_set_bit            = int(0x00000001)
	update_after_bind_bit             = int(0x00000002)
	host_only_bit_ext                 = int(0x00000004)
	allow_overallocation_sets_bit_nv  = int(0x00000008)
	allow_overallocation_pools_bit_nv = int(0x00000010)
	max_enum                          = max_int
}

pub type DescriptorPoolCreateFlags = u32
pub type DescriptorPoolResetFlags = u32

pub enum DescriptorSetLayoutCreateFlagBits {
	update_after_bind_pool_bit          = int(0x00000002)
	push_descriptor_bit_khr             = int(0x00000001)
	descriptor_buffer_bit_ext           = int(0x00000010)
	embedded_immutable_samplers_bit_ext = int(0x00000020)
	indirect_bindable_bit_nv            = int(0x00000080)
	host_only_pool_bit_ext              = int(0x00000004)
	per_stage_bit_nv                    = int(0x00000040)
	max_enum                            = max_int
}

pub type DescriptorSetLayoutCreateFlags = u32

pub enum AttachmentDescriptionFlagBits {
	may_alias_bit = int(0x00000001)
	max_enum      = max_int
}

pub type AttachmentDescriptionFlags = u32

pub enum DependencyFlagBits {
	by_region_bit        = int(0x00000001)
	device_group_bit     = int(0x00000004)
	view_local_bit       = int(0x00000002)
	eedback_loop_bit_ext = int(0x00000008)
	max_enum             = max_int
}

pub type DependencyFlags = u32

pub enum FramebufferCreateFlagBits {
	imageless_bit = int(0x00000001)
	max_enum      = max_int
}

pub type FramebufferCreateFlags = u32

pub enum RenderPassCreateFlagBits {
	transform_bit_qcom = int(0x00000002)
	max_enum           = max_int
}

pub type RenderPassCreateFlags = u32

pub enum SubpassDescriptionFlagBits {
	per_view_attributes_bit_nvx                           = int(0x00000001)
	per_view_position_x_only_bit_nvx                      = int(0x00000002)
	ragment_region_bit_qcom                               = int(0x00000004)
	shader_resolve_bit_qcom                               = int(0x00000008)
	rasterization_order_attachment_color_access_bit_ext   = int(0x00000010)
	rasterization_order_attachment_depth_access_bit_ext   = int(0x00000020)
	rasterization_order_attachment_stencil_access_bit_ext = int(0x00000040)
	enable_legacy_dithering_bit_ext                       = int(0x00000080)
	max_enum                                              = max_int
}

pub type SubpassDescriptionFlags = u32

pub enum CommandPoolCreateFlagBits {
	transient_bit            = int(0x00000001)
	reset_command_buffer_bit = int(0x00000002)
	protected_bit            = int(0x00000004)
	max_enum                 = max_int
}

pub type CommandPoolCreateFlags = u32

pub enum CommandPoolResetFlagBits {
	release_resources_bit = int(0x00000001)
	max_enum              = max_int
}

pub type CommandPoolResetFlags = u32

pub enum CommandBufferUsageFlagBits {
	one_time_submit_bit      = int(0x00000001)
	render_pass_continue_bit = int(0x00000002)
	simultaneous_use_bit     = int(0x00000004)
	max_enum                 = max_int
}

pub type CommandBufferUsageFlags = u32

pub enum QueryControlFlagBits {
	precise_bit = int(0x00000001)
	max_enum    = max_int
}

pub type QueryControlFlags = u32

pub enum CommandBufferResetFlagBits {
	release_resources_bit = int(0x00000001)
	max_enum              = max_int
}

pub type CommandBufferResetFlags = u32

pub enum StencilFaceFlagBits {
	ront_bit      = int(0x00000001)
	back_bit      = int(0x00000002)
	ront_and_back = int(0x00000003)
	max_enum      = max_int
}

pub type StencilFaceFlags = u32
pub type Extent2D = C.VkExtent2D

@[typedef]
pub struct C.VkExtent2D {
pub mut:
	width  u32
	height u32
}

pub type Extent3D = C.VkExtent3D

@[typedef]
pub struct C.VkExtent3D {
pub mut:
	width  u32
	height u32
	depth  u32
}

pub type Offset2D = C.VkOffset2D

@[typedef]
pub struct C.VkOffset2D {
pub mut:
	x i32
	y i32
}

pub type Offset3D = C.VkOffset3D

@[typedef]
pub struct C.VkOffset3D {
pub mut:
	x i32
	y i32
	z i32
}

pub type Rect2D = C.VkRect2D

@[typedef]
pub struct C.VkRect2D {
pub mut:
	offset Offset2D
	extent Extent2D
}

pub type BaseInStructure = C.VkBaseInStructure

@[typedef]
pub struct C.VkBaseInStructure {
pub mut:
	sType StructureType
	pNext &BaseInStructure
}

pub type BaseOutStructure = C.VkBaseOutStructure

@[typedef]
pub struct C.VkBaseOutStructure {
pub mut:
	sType StructureType
	pNext &BaseOutStructure
}

pub type BufferMemoryBarrier = C.VkBufferMemoryBarrier

@[typedef]
pub struct C.VkBufferMemoryBarrier {
pub mut:
	sType               StructureType = StructureType.buffer_memory_barrier
	pNext               voidptr       = unsafe { nil }
	srcAccessMask       AccessFlags
	dstAccessMask       AccessFlags
	srcQueueFamilyIndex u32
	dstQueueFamilyIndex u32
	buffer              C.VkBuffer
	offset              DeviceSize
	size                DeviceSize
}

pub type DispatchIndirectCommand = C.VkDispatchIndirectCommand

@[typedef]
pub struct C.VkDispatchIndirectCommand {
pub mut:
	x u32
	y u32
	z u32
}

pub type DrawIndexedIndirectCommand = C.VkDrawIndexedIndirectCommand

@[typedef]
pub struct C.VkDrawIndexedIndirectCommand {
pub mut:
	indexCount    u32
	instanceCount u32
	firstIndex    u32
	vertexOffset  i32
	firstInstance u32
}

pub type DrawIndirectCommand = C.VkDrawIndirectCommand

@[typedef]
pub struct C.VkDrawIndirectCommand {
pub mut:
	vertexCount   u32
	instanceCount u32
	firstVertex   u32
	firstInstance u32
}

pub type ImageSubresourceRange = C.VkImageSubresourceRange

@[typedef]
pub struct C.VkImageSubresourceRange {
pub mut:
	aspectMask     ImageAspectFlags
	baseMipLevel   u32
	levelCount     u32
	baseArrayLayer u32
	layerCount     u32
}

pub type ImageMemoryBarrier = C.VkImageMemoryBarrier

@[typedef]
pub struct C.VkImageMemoryBarrier {
pub mut:
	sType               StructureType = StructureType.image_memory_barrier
	pNext               voidptr       = unsafe { nil }
	srcAccessMask       AccessFlags
	dstAccessMask       AccessFlags
	oldLayout           ImageLayout
	newLayout           ImageLayout
	srcQueueFamilyIndex u32
	dstQueueFamilyIndex u32
	image               C.VkImage
	subresourceRange    ImageSubresourceRange
}

pub type MemoryBarrier = C.VkMemoryBarrier

@[typedef]
pub struct C.VkMemoryBarrier {
pub mut:
	sType         StructureType = StructureType.memory_barrier
	pNext         voidptr       = unsafe { nil }
	srcAccessMask AccessFlags
	dstAccessMask AccessFlags
}

pub type PipelineCacheHeaderVersionOne = C.VkPipelineCacheHeaderVersionOne

@[typedef]
pub struct C.VkPipelineCacheHeaderVersionOne {
pub mut:
	headerSize        u32
	headerVersion     PipelineCacheHeaderVersion
	vendorID          u32
	deviceID          u32
	pipelineCacheUUID [uuid_size]u8
}

pub type PFN_vkAllocationFunction = fn (pUserData voidptr, size usize, alignment usize, allocationScope SystemAllocationScope)

pub type PFN_vkFreeFunction = fn (pUserData voidptr, pMemory voidptr)

pub type PFN_vkInternalAllocationNotification = fn (pUserData voidptr, size usize, allocationType InternalAllocationType, allocationScope SystemAllocationScope)

pub type PFN_vkInternalFreeNotification = fn (pUserData voidptr, size usize, allocationType InternalAllocationType, allocationScope SystemAllocationScope)

pub type PFN_vkReallocationFunction = fn (pUserData voidptr, pOriginal voidptr, size usize, alignment usize, allocationScope SystemAllocationScope)

pub type PFN_vkVoidFunction = fn ()

pub type AllocationCallbacks = C.VkAllocationCallbacks

@[typedef]
pub struct C.VkAllocationCallbacks {
pub mut:
	pUserData             voidptr                              = unsafe { nil }
	pfnAllocation         PFN_vkAllocationFunction             = unsafe { nil }
	pfnReallocation       PFN_vkReallocationFunction           = unsafe { nil }
	pfnFree               PFN_vkFreeFunction                   = unsafe { nil }
	pfnInternalAllocation PFN_vkInternalAllocationNotification = unsafe { nil }
	pfnInternalFree       PFN_vkInternalFreeNotification       = unsafe { nil }
}

pub type ApplicationInfo = C.VkApplicationInfo

@[typedef]
pub struct C.VkApplicationInfo {
pub mut:
	sType              StructureType = StructureType.application_info
	pNext              voidptr       = unsafe { nil }
	pApplicationName   &char
	applicationVersion u32
	pEngineName        &char
	engineVersion      u32
	apiVersion         u32
}

pub type FormatProperties = C.VkFormatProperties

@[typedef]
pub struct C.VkFormatProperties {
pub mut:
	linearTilingFeatures  FormatFeatureFlags
	optimalTilingFeatures FormatFeatureFlags
	bufferFeatures        FormatFeatureFlags
}

pub type ImageFormatProperties = C.VkImageFormatProperties

@[typedef]
pub struct C.VkImageFormatProperties {
pub mut:
	maxExtent       Extent3D
	maxMipLevels    u32
	maxArrayLayers  u32
	sampleCounts    SampleCountFlags
	maxResourceSize DeviceSize
}

pub type InstanceCreateInfo = C.VkInstanceCreateInfo

@[typedef]
pub struct C.VkInstanceCreateInfo {
pub mut:
	sType                   StructureType = StructureType.instance_create_info
	pNext                   voidptr       = unsafe { nil }
	flags                   InstanceCreateFlags
	pApplicationInfo        &ApplicationInfo
	enabledLayerCount       u32
	ppEnabledLayerNames     &&char
	enabledExtensionCount   u32
	ppEnabledExtensionNames &&char
}

pub type MemoryHeap = C.VkMemoryHeap

@[typedef]
pub struct C.VkMemoryHeap {
pub mut:
	size  DeviceSize
	flags MemoryHeapFlags
}

pub type MemoryType = C.VkMemoryType

@[typedef]
pub struct C.VkMemoryType {
pub mut:
	propertyFlags MemoryPropertyFlags
	heapIndex     u32
}

pub type PhysicalDeviceFeatures = C.VkPhysicalDeviceFeatures

@[typedef]
pub struct C.VkPhysicalDeviceFeatures {
pub mut:
	robustBufferAccess                      Bool32
	fullDrawIndexUint32                     Bool32
	imageCubeArray                          Bool32
	independentBlend                        Bool32
	geometryShader                          Bool32
	tessellationShader                      Bool32
	sampleRateShading                       Bool32
	dualSrcBlend                            Bool32
	logicOp                                 Bool32
	multiDrawIndirect                       Bool32
	drawIndirectFirstInstance               Bool32
	depthClamp                              Bool32
	depthBiasClamp                          Bool32
	fillModeNonSolid                        Bool32
	depthBounds                             Bool32
	wideLines                               Bool32
	largePoints                             Bool32
	alphaToOne                              Bool32
	multiViewport                           Bool32
	samplerAnisotropy                       Bool32
	textureCompressionETC2                  Bool32
	textureCompressionASTC_LDR              Bool32
	textureCompressionBC                    Bool32
	occlusionQueryPrecise                   Bool32
	pipelineStatisticsQuery                 Bool32
	vertexPipelineStoresAndAtomics          Bool32
	fragmentStoresAndAtomics                Bool32
	shaderTessellationAndGeometryPointSize  Bool32
	shaderImageGatherExtended               Bool32
	shaderStorageImageExtendedFormats       Bool32
	shaderStorageImageMultisample           Bool32
	shaderStorageImageReadWithoutFormat     Bool32
	shaderStorageImageWriteWithoutFormat    Bool32
	shaderUniformBufferArrayDynamicIndexing Bool32
	shaderSampledImageArrayDynamicIndexing  Bool32
	shaderStorageBufferArrayDynamicIndexing Bool32
	shaderStorageImageArrayDynamicIndexing  Bool32
	shaderClipDistance                      Bool32
	shaderCullDistance                      Bool32
	shaderFloat64                           Bool32
	shaderInt64                             Bool32
	shaderInt16                             Bool32
	shaderResourceResidency                 Bool32
	shaderResourceMinLod                    Bool32
	sparseBinding                           Bool32
	sparseResidencyBuffer                   Bool32
	sparseResidencyImage2D                  Bool32
	sparseResidencyImage3D                  Bool32
	sparseResidency2Samples                 Bool32
	sparseResidency4Samples                 Bool32
	sparseResidency8Samples                 Bool32
	sparseResidency16Samples                Bool32
	sparseResidencyAliased                  Bool32
	variableMultisampleRate                 Bool32
	inheritedQueries                        Bool32
}

pub type PhysicalDeviceLimits = C.VkPhysicalDeviceLimits

@[typedef]
pub struct C.VkPhysicalDeviceLimits {
pub mut:
	maxImageDimension1D                             u32
	maxImageDimension2D                             u32
	maxImageDimension3D                             u32
	maxImageDimensionCube                           u32
	maxImageArrayLayers                             u32
	maxTexelBufferElements                          u32
	maxUniformBufferRange                           u32
	maxStorageBufferRange                           u32
	maxPushConstantsSize                            u32
	maxMemoryAllocationCount                        u32
	maxSamplerAllocationCount                       u32
	bufferImageGranularity                          DeviceSize
	sparseAddressSpaceSize                          DeviceSize
	maxBoundDescriptorSets                          u32
	maxPerStageDescriptorSamplers                   u32
	maxPerStageDescriptorUniformBuffers             u32
	maxPerStageDescriptorStorageBuffers             u32
	maxPerStageDescriptorSampledImages              u32
	maxPerStageDescriptorStorageImages              u32
	maxPerStageDescriptorInputAttachments           u32
	maxPerStageResources                            u32
	maxDescriptorSetSamplers                        u32
	maxDescriptorSetUniformBuffers                  u32
	maxDescriptorSetUniformBuffersDynamic           u32
	maxDescriptorSetStorageBuffers                  u32
	maxDescriptorSetStorageBuffersDynamic           u32
	maxDescriptorSetSampledImages                   u32
	maxDescriptorSetStorageImages                   u32
	maxDescriptorSetInputAttachments                u32
	maxVertexInputAttributes                        u32
	maxVertexInputBindings                          u32
	maxVertexInputAttributeOffset                   u32
	maxVertexInputBindingStride                     u32
	maxVertexOutputComponents                       u32
	maxTessellationGenerationLevel                  u32
	maxTessellationPatchSize                        u32
	maxTessellationControlPerVertexInputComponents  u32
	maxTessellationControlPerVertexOutputComponents u32
	maxTessellationControlPerPatchOutputComponents  u32
	maxTessellationControlTotalOutputComponents     u32
	maxTessellationEvaluationInputComponents        u32
	maxTessellationEvaluationOutputComponents       u32
	maxGeometryShaderInvocations                    u32
	maxGeometryInputComponents                      u32
	maxGeometryOutputComponents                     u32
	maxGeometryOutputVertices                       u32
	maxGeometryTotalOutputComponents                u32
	maxFragmentInputComponents                      u32
	maxFragmentOutputAttachments                    u32
	maxFragmentDualSrcAttachments                   u32
	maxFragmentCombinedOutputResources              u32
	maxComputeSharedMemorySize                      u32
	maxComputeWorkGroupCount                        [3]u32
	maxComputeWorkGroupInvocations                  u32
	maxComputeWorkGroupSize                         [3]u32
	subPixelPrecisionBits                           u32
	subTexelPrecisionBits                           u32
	mipmapPrecisionBits                             u32
	maxDrawIndexedIndexValue                        u32
	maxDrawIndirectCount                            u32
	maxSamplerLodBias                               f32
	maxSamplerAnisotropy                            f32
	maxViewports                                    u32
	maxViewportDimensions                           [2]u32
	viewportBoundsRange                             [2]f32
	viewportSubPixelBits                            u32
	minMemoryMapAlignment                           usize
	minTexelBufferOffsetAlignment                   DeviceSize
	minUniformBufferOffsetAlignment                 DeviceSize
	minStorageBufferOffsetAlignment                 DeviceSize
	minTexelOffset                                  i32
	maxTexelOffset                                  u32
	minTexelGatherOffset                            i32
	maxTexelGatherOffset                            u32
	minInterpolationOffset                          f32
	maxInterpolationOffset                          f32
	subPixelInterpolationOffsetBits                 u32
	maxFramebufferWidth                             u32
	maxFramebufferHeight                            u32
	maxFramebufferLayers                            u32
	framebufferColorSampleCounts                    SampleCountFlags
	framebufferDepthSampleCounts                    SampleCountFlags
	framebufferStencilSampleCounts                  SampleCountFlags
	framebufferNoAttachmentsSampleCounts            SampleCountFlags
	maxColorAttachments                             u32
	sampledImageColorSampleCounts                   SampleCountFlags
	sampledImageIntegerSampleCounts                 SampleCountFlags
	sampledImageDepthSampleCounts                   SampleCountFlags
	sampledImageStencilSampleCounts                 SampleCountFlags
	storageImageSampleCounts                        SampleCountFlags
	maxSampleMaskWords                              u32
	timestampComputeAndGraphics                     Bool32
	timestampPeriod                                 f32
	maxClipDistances                                u32
	maxCullDistances                                u32
	maxCombinedClipAndCullDistances                 u32
	discreteQueuePriorities                         u32
	pointSizeRange                                  [2]f32
	lineWidthRange                                  [2]f32
	pointSizeGranularity                            f32
	lineWidthGranularity                            f32
	strictLines                                     Bool32
	standardSampleLocations                         Bool32
	optimalBufferCopyOffsetAlignment                DeviceSize
	optimalBufferCopyRowPitchAlignment              DeviceSize
	nonCoherentAtomSize                             DeviceSize
}

pub type PhysicalDeviceMemoryProperties = C.VkPhysicalDeviceMemoryProperties

@[typedef]
pub struct C.VkPhysicalDeviceMemoryProperties {
pub mut:
	memoryTypeCount u32
	memoryTypes     [max_memory_types]MemoryType
	memoryHeapCount u32
	memoryHeaps     [max_memory_heaps]MemoryHeap
}

pub type PhysicalDeviceSparseProperties = C.VkPhysicalDeviceSparseProperties

@[typedef]
pub struct C.VkPhysicalDeviceSparseProperties {
pub mut:
	residencyStandard2DBlockShape            Bool32
	residencyStandard2DMultisampleBlockShape Bool32
	residencyStandard3DBlockShape            Bool32
	residencyAlignedMipSize                  Bool32
	residencyNonResidentStrict               Bool32
}

pub type PhysicalDeviceProperties = C.VkPhysicalDeviceProperties

@[typedef]
pub struct C.VkPhysicalDeviceProperties {
pub mut:
	apiVersion        u32
	driverVersion     u32
	vendorID          u32
	deviceID          u32
	deviceType        PhysicalDeviceType
	deviceName        [max_physical_device_name_size]char
	pipelineCacheUUID [uuid_size]u8
	limits            PhysicalDeviceLimits
	sparseProperties  PhysicalDeviceSparseProperties
}

pub type QueueFamilyProperties = C.VkQueueFamilyProperties

@[typedef]
pub struct C.VkQueueFamilyProperties {
pub mut:
	queueFlags                  QueueFlags
	queueCount                  u32
	timestampValidBits          u32
	minImageTransferGranularity Extent3D
}

pub type DeviceQueueCreateInfo = C.VkDeviceQueueCreateInfo

@[typedef]
pub struct C.VkDeviceQueueCreateInfo {
pub mut:
	sType            StructureType = StructureType.device_queue_create_info
	pNext            voidptr       = unsafe { nil }
	flags            DeviceQueueCreateFlags
	queueFamilyIndex u32
	queueCount       u32
	pQueuePriorities &f32
}

pub type DeviceCreateInfo = C.VkDeviceCreateInfo

@[typedef]
pub struct C.VkDeviceCreateInfo {
pub mut:
	sType                StructureType = StructureType.device_create_info
	pNext                voidptr       = unsafe { nil }
	flags                DeviceCreateFlags
	queueCreateInfoCount u32
	pQueueCreateInfos    &DeviceQueueCreateInfo
	// enabledLayerCount is deprecated and should not be used
	enabledLayerCount u32
	// ppEnabledLayerNames is deprecated and should not be used
	ppEnabledLayerNames     &&char
	enabledExtensionCount   u32
	ppEnabledExtensionNames &&char
	pEnabledFeatures        &PhysicalDeviceFeatures
}

pub type ExtensionProperties = C.VkExtensionProperties

@[typedef]
pub struct C.VkExtensionProperties {
pub mut:
	extensionName [max_extension_name_size]char
	specVersion   u32
}

pub type LayerProperties = C.VkLayerProperties

@[typedef]
pub struct C.VkLayerProperties {
pub mut:
	layerName             [max_extension_name_size]char
	specVersion           u32
	implementationVersion u32
	description           [max_description_size]char
}

pub type SubmitInfo = C.VkSubmitInfo

@[typedef]
pub struct C.VkSubmitInfo {
pub mut:
	sType                StructureType = StructureType.submit_info
	pNext                voidptr       = unsafe { nil }
	waitSemaphoreCount   u32
	pWaitSemaphores      C.VkSemaphore
	pWaitDstStageMask    &PipelineStageFlags
	commandBufferCount   u32
	pCommandBuffers      C.VkCommandBuffer
	signalSemaphoreCount u32
	pSignalSemaphores    C.VkSemaphore
}

pub type MappedMemoryRange = C.VkMappedMemoryRange

@[typedef]
pub struct C.VkMappedMemoryRange {
pub mut:
	sType  StructureType = StructureType.mapped_memory_range
	pNext  voidptr       = unsafe { nil }
	memory C.VkDeviceMemory
	offset DeviceSize
	size   DeviceSize
}

pub type MemoryAllocateInfo = C.VkMemoryAllocateInfo

@[typedef]
pub struct C.VkMemoryAllocateInfo {
pub mut:
	sType           StructureType = StructureType.memory_allocate_info
	pNext           voidptr       = unsafe { nil }
	allocationSize  DeviceSize
	memoryTypeIndex u32
}

pub type MemoryRequirements = C.VkMemoryRequirements

@[typedef]
pub struct C.VkMemoryRequirements {
pub mut:
	size           DeviceSize
	alignment      DeviceSize
	memoryTypeBits u32
}

pub type SparseMemoryBind = C.VkSparseMemoryBind

@[typedef]
pub struct C.VkSparseMemoryBind {
pub mut:
	resourceOffset DeviceSize
	size           DeviceSize
	memory         C.VkDeviceMemory
	memoryOffset   DeviceSize
	flags          SparseMemoryBindFlags
}

pub type SparseBufferMemoryBindInfo = C.VkSparseBufferMemoryBindInfo

@[typedef]
pub struct C.VkSparseBufferMemoryBindInfo {
pub mut:
	buffer    C.VkBuffer
	bindCount u32
	pBinds    &SparseMemoryBind
}

pub type SparseImageOpaqueMemoryBindInfo = C.VkSparseImageOpaqueMemoryBindInfo

@[typedef]
pub struct C.VkSparseImageOpaqueMemoryBindInfo {
pub mut:
	image     C.VkImage
	bindCount u32
	pBinds    &SparseMemoryBind
}

pub type ImageSubresource = C.VkImageSubresource

@[typedef]
pub struct C.VkImageSubresource {
pub mut:
	aspectMask ImageAspectFlags
	mipLevel   u32
	arrayLayer u32
}

pub type SparseImageMemoryBind = C.VkSparseImageMemoryBind

@[typedef]
pub struct C.VkSparseImageMemoryBind {
pub mut:
	subresource  ImageSubresource
	offset       Offset3D
	extent       Extent3D
	memory       C.VkDeviceMemory
	memoryOffset DeviceSize
	flags        SparseMemoryBindFlags
}

pub type SparseImageMemoryBindInfo = C.VkSparseImageMemoryBindInfo

@[typedef]
pub struct C.VkSparseImageMemoryBindInfo {
pub mut:
	image     C.VkImage
	bindCount u32
	pBinds    &SparseImageMemoryBind
}

pub type BindSparseInfo = C.VkBindSparseInfo

@[typedef]
pub struct C.VkBindSparseInfo {
pub mut:
	sType                StructureType = StructureType.bind_sparse_info
	pNext                voidptr       = unsafe { nil }
	waitSemaphoreCount   u32
	pWaitSemaphores      C.VkSemaphore
	bufferBindCount      u32
	pBufferBinds         &SparseBufferMemoryBindInfo
	imageOpaqueBindCount u32
	pImageOpaqueBinds    &SparseImageOpaqueMemoryBindInfo
	imageBindCount       u32
	pImageBinds          &SparseImageMemoryBindInfo
	signalSemaphoreCount u32
	pSignalSemaphores    C.VkSemaphore
}

pub type SparseImageFormatProperties = C.VkSparseImageFormatProperties

@[typedef]
pub struct C.VkSparseImageFormatProperties {
pub mut:
	aspectMask       ImageAspectFlags
	imageGranularity Extent3D
	flags            SparseImageFormatFlags
}

pub type SparseImageMemoryRequirements = C.VkSparseImageMemoryRequirements

@[typedef]
pub struct C.VkSparseImageMemoryRequirements {
pub mut:
	formatProperties     SparseImageFormatProperties
	imageMipTailFirstLod u32
	imageMipTailSize     DeviceSize
	imageMipTailOffset   DeviceSize
	imageMipTailStride   DeviceSize
}

pub type FenceCreateInfo = C.VkFenceCreateInfo

@[typedef]
pub struct C.VkFenceCreateInfo {
pub mut:
	sType StructureType = StructureType.fence_create_info
	pNext voidptr       = unsafe { nil }
	flags FenceCreateFlags
}

pub type SemaphoreCreateInfo = C.VkSemaphoreCreateInfo

@[typedef]
pub struct C.VkSemaphoreCreateInfo {
pub mut:
	sType StructureType = StructureType.semaphore_create_info
	pNext voidptr       = unsafe { nil }
	flags SemaphoreCreateFlags
}

pub type EventCreateInfo = C.VkEventCreateInfo

@[typedef]
pub struct C.VkEventCreateInfo {
pub mut:
	sType StructureType = StructureType.event_create_info
	pNext voidptr       = unsafe { nil }
	flags EventCreateFlags
}

pub type QueryPoolCreateInfo = C.VkQueryPoolCreateInfo

@[typedef]
pub struct C.VkQueryPoolCreateInfo {
pub mut:
	sType              StructureType = StructureType.query_pool_create_info
	pNext              voidptr       = unsafe { nil }
	flags              QueryPoolCreateFlags
	queryType          QueryType
	queryCount         u32
	pipelineStatistics QueryPipelineStatisticFlags
}

pub type BufferCreateInfo = C.VkBufferCreateInfo

@[typedef]
pub struct C.VkBufferCreateInfo {
pub mut:
	sType                 StructureType = StructureType.buffer_create_info
	pNext                 voidptr       = unsafe { nil }
	flags                 BufferCreateFlags
	size                  DeviceSize
	usage                 BufferUsageFlags
	sharingMode           SharingMode
	queueFamilyIndexCount u32
	pQueueFamilyIndices   &u32
}

pub type BufferViewCreateInfo = C.VkBufferViewCreateInfo

@[typedef]
pub struct C.VkBufferViewCreateInfo {
pub mut:
	sType  StructureType = StructureType.buffer_view_create_info
	pNext  voidptr       = unsafe { nil }
	flags  BufferViewCreateFlags
	buffer C.VkBuffer
	format Format
	offset DeviceSize
	range  DeviceSize
}

pub type ImageCreateInfo = C.VkImageCreateInfo

@[typedef]
pub struct C.VkImageCreateInfo {
pub mut:
	sType                 StructureType = StructureType.image_create_info
	pNext                 voidptr       = unsafe { nil }
	flags                 ImageCreateFlags
	imageType             ImageType
	format                Format
	extent                Extent3D
	mipLevels             u32
	arrayLayers           u32
	samples               SampleCountFlagBits
	tiling                ImageTiling
	usage                 ImageUsageFlags
	sharingMode           SharingMode
	queueFamilyIndexCount u32
	pQueueFamilyIndices   &u32
	initialLayout         ImageLayout
}

pub type SubresourceLayout = C.VkSubresourceLayout

@[typedef]
pub struct C.VkSubresourceLayout {
pub mut:
	offset     DeviceSize
	size       DeviceSize
	rowPitch   DeviceSize
	arrayPitch DeviceSize
	depthPitch DeviceSize
}

pub type ComponentMapping = C.VkComponentMapping

@[typedef]
pub struct C.VkComponentMapping {
pub mut:
	r ComponentSwizzle
	g ComponentSwizzle
	b ComponentSwizzle
	a ComponentSwizzle
}

pub type ImageViewCreateInfo = C.VkImageViewCreateInfo

@[typedef]
pub struct C.VkImageViewCreateInfo {
pub mut:
	sType            StructureType = StructureType.image_view_create_info
	pNext            voidptr       = unsafe { nil }
	flags            ImageViewCreateFlags
	image            C.VkImage
	viewType         ImageViewType
	format           Format
	components       ComponentMapping
	subresourceRange ImageSubresourceRange
}

pub type ShaderModuleCreateInfo = C.VkShaderModuleCreateInfo

@[typedef]
pub struct C.VkShaderModuleCreateInfo {
pub mut:
	sType    StructureType = StructureType.shader_module_create_info
	pNext    voidptr       = unsafe { nil }
	flags    ShaderModuleCreateFlags
	codeSize usize
	pCode    &u32
}

pub type PipelineCacheCreateInfo = C.VkPipelineCacheCreateInfo

@[typedef]
pub struct C.VkPipelineCacheCreateInfo {
pub mut:
	sType           StructureType = StructureType.pipeline_cache_create_info
	pNext           voidptr       = unsafe { nil }
	flags           PipelineCacheCreateFlags
	initialDataSize usize
	pInitialData    voidptr
}

pub type SpecializationMapEntry = C.VkSpecializationMapEntry

@[typedef]
pub struct C.VkSpecializationMapEntry {
pub mut:
	constantID u32
	offset     u32
	size       usize
}

pub type SpecializationInfo = C.VkSpecializationInfo

@[typedef]
pub struct C.VkSpecializationInfo {
pub mut:
	mapEntryCount u32
	pMapEntries   &SpecializationMapEntry
	dataSize      usize
	pData         voidptr
}

pub type PipelineShaderStageCreateInfo = C.VkPipelineShaderStageCreateInfo

@[typedef]
pub struct C.VkPipelineShaderStageCreateInfo {
pub mut:
	sType               StructureType = StructureType.pipeline_shader_stage_create_info
	pNext               voidptr       = unsafe { nil }
	flags               PipelineShaderStageCreateFlags
	stage               ShaderStageFlagBits
	vkmodule            C.VkShaderModule
	pName               &char
	pSpecializationInfo &SpecializationInfo
}

pub type ComputePipelineCreateInfo = C.VkComputePipelineCreateInfo

@[typedef]
pub struct C.VkComputePipelineCreateInfo {
pub mut:
	sType              StructureType = StructureType.compute_pipeline_create_info
	pNext              voidptr       = unsafe { nil }
	flags              PipelineCreateFlags
	stage              PipelineShaderStageCreateInfo
	layout             C.VkPipelineLayout
	basePipelineHandle C.VkPipeline
	basePipelineIndex  i32
}

pub type VertexInputBindingDescription = C.VkVertexInputBindingDescription

@[typedef]
pub struct C.VkVertexInputBindingDescription {
pub mut:
	binding   u32
	stride    u32
	inputRate VertexInputRate
}

pub type VertexInputAttributeDescription = C.VkVertexInputAttributeDescription

@[typedef]
pub struct C.VkVertexInputAttributeDescription {
pub mut:
	location u32
	binding  u32
	format   Format
	offset   u32
}

pub type PipelineVertexInputStateCreateInfo = C.VkPipelineVertexInputStateCreateInfo

@[typedef]
pub struct C.VkPipelineVertexInputStateCreateInfo {
pub mut:
	sType                           StructureType = StructureType.pipeline_vertex_input_state_create_info
	pNext                           voidptr       = unsafe { nil }
	flags                           PipelineVertexInputStateCreateFlags
	vertexBindingDescriptionCount   u32
	pVertexBindingDescriptions      &VertexInputBindingDescription
	vertexAttributeDescriptionCount u32
	pVertexAttributeDescriptions    &VertexInputAttributeDescription
}

pub type PipelineInputAssemblyStateCreateInfo = C.VkPipelineInputAssemblyStateCreateInfo

@[typedef]
pub struct C.VkPipelineInputAssemblyStateCreateInfo {
pub mut:
	sType                  StructureType = StructureType.pipeline_input_assembly_state_create_info
	pNext                  voidptr       = unsafe { nil }
	flags                  PipelineInputAssemblyStateCreateFlags
	topology               PrimitiveTopology
	primitiveRestartEnable Bool32
}

pub type PipelineTessellationStateCreateInfo = C.VkPipelineTessellationStateCreateInfo

@[typedef]
pub struct C.VkPipelineTessellationStateCreateInfo {
pub mut:
	sType              StructureType = StructureType.pipeline_tessellation_state_create_info
	pNext              voidptr       = unsafe { nil }
	flags              PipelineTessellationStateCreateFlags
	patchControlPoints u32
}

pub type Viewport = C.VkViewport

@[typedef]
pub struct C.VkViewport {
pub mut:
	x        f32
	y        f32
	width    f32
	height   f32
	minDepth f32
	maxDepth f32
}

pub type PipelineViewportStateCreateInfo = C.VkPipelineViewportStateCreateInfo

@[typedef]
pub struct C.VkPipelineViewportStateCreateInfo {
pub mut:
	sType         StructureType = StructureType.pipeline_viewport_state_create_info
	pNext         voidptr       = unsafe { nil }
	flags         PipelineViewportStateCreateFlags
	viewportCount u32
	pViewports    &Viewport
	scissorCount  u32
	pScissors     &Rect2D
}

pub type PipelineRasterizationStateCreateInfo = C.VkPipelineRasterizationStateCreateInfo

@[typedef]
pub struct C.VkPipelineRasterizationStateCreateInfo {
pub mut:
	sType                   StructureType = StructureType.pipeline_rasterization_state_create_info
	pNext                   voidptr       = unsafe { nil }
	flags                   PipelineRasterizationStateCreateFlags
	depthClampEnable        Bool32
	rasterizerDiscardEnable Bool32
	polygonMode             PolygonMode
	cullMode                CullModeFlags
	frontFace               FrontFace
	depthBiasEnable         Bool32
	depthBiasConstantFactor f32
	depthBiasClamp          f32
	depthBiasSlopeFactor    f32
	lineWidth               f32
}

pub type PipelineMultisampleStateCreateInfo = C.VkPipelineMultisampleStateCreateInfo

@[typedef]
pub struct C.VkPipelineMultisampleStateCreateInfo {
pub mut:
	sType                 StructureType = StructureType.pipeline_multisample_state_create_info
	pNext                 voidptr       = unsafe { nil }
	flags                 PipelineMultisampleStateCreateFlags
	rasterizationSamples  SampleCountFlagBits
	sampleShadingEnable   Bool32
	minSampleShading      f32
	pSampleMask           &SampleMask
	alphaToCoverageEnable Bool32
	alphaToOneEnable      Bool32
}

pub type StencilOpState = C.VkStencilOpState

@[typedef]
pub struct C.VkStencilOpState {
pub mut:
	failOp      StencilOp
	passOp      StencilOp
	depthFailOp StencilOp
	compareOp   CompareOp
	compareMask u32
	writeMask   u32
	reference   u32
}

pub type PipelineDepthStencilStateCreateInfo = C.VkPipelineDepthStencilStateCreateInfo

@[typedef]
pub struct C.VkPipelineDepthStencilStateCreateInfo {
pub mut:
	sType                 StructureType = StructureType.pipeline_depth_stencil_state_create_info
	pNext                 voidptr       = unsafe { nil }
	flags                 PipelineDepthStencilStateCreateFlags
	depthTestEnable       Bool32
	depthWriteEnable      Bool32
	depthCompareOp        CompareOp
	depthBoundsTestEnable Bool32
	stencilTestEnable     Bool32
	front                 StencilOpState
	back                  StencilOpState
	minDepthBounds        f32
	maxDepthBounds        f32
}

pub type PipelineColorBlendAttachmentState = C.VkPipelineColorBlendAttachmentState

@[typedef]
pub struct C.VkPipelineColorBlendAttachmentState {
pub mut:
	blendEnable         Bool32
	srcColorBlendFactor BlendFactor
	dstColorBlendFactor BlendFactor
	colorBlendOp        BlendOp
	srcAlphaBlendFactor BlendFactor
	dstAlphaBlendFactor BlendFactor
	alphaBlendOp        BlendOp
	colorWriteMask      ColorComponentFlags
}

pub type PipelineColorBlendStateCreateInfo = C.VkPipelineColorBlendStateCreateInfo

@[typedef]
pub struct C.VkPipelineColorBlendStateCreateInfo {
pub mut:
	sType           StructureType = StructureType.pipeline_color_blend_state_create_info
	pNext           voidptr       = unsafe { nil }
	flags           PipelineColorBlendStateCreateFlags
	logicOpEnable   Bool32
	logicOp         LogicOp
	attachmentCount u32
	pAttachments    &PipelineColorBlendAttachmentState
	blendConstants  [4]f32
}

pub type PipelineDynamicStateCreateInfo = C.VkPipelineDynamicStateCreateInfo

@[typedef]
pub struct C.VkPipelineDynamicStateCreateInfo {
pub mut:
	sType             StructureType = StructureType.pipeline_dynamic_state_create_info
	pNext             voidptr       = unsafe { nil }
	flags             PipelineDynamicStateCreateFlags
	dynamicStateCount u32
	pDynamicStates    &DynamicState
}

pub type GraphicsPipelineCreateInfo = C.VkGraphicsPipelineCreateInfo

@[typedef]
pub struct C.VkGraphicsPipelineCreateInfo {
pub mut:
	sType               StructureType = StructureType.graphics_pipeline_create_info
	pNext               voidptr       = unsafe { nil }
	flags               PipelineCreateFlags
	stageCount          u32
	pStages             &PipelineShaderStageCreateInfo
	pVertexInputState   &PipelineVertexInputStateCreateInfo
	pInputAssemblyState &PipelineInputAssemblyStateCreateInfo
	pTessellationState  &PipelineTessellationStateCreateInfo
	pViewportState      &PipelineViewportStateCreateInfo
	pRasterizationState &PipelineRasterizationStateCreateInfo
	pMultisampleState   &PipelineMultisampleStateCreateInfo
	pDepthStencilState  &PipelineDepthStencilStateCreateInfo
	pColorBlendState    &PipelineColorBlendStateCreateInfo
	pDynamicState       &PipelineDynamicStateCreateInfo
	layout              C.VkPipelineLayout
	renderPass          C.VkRenderPass
	subpass             u32
	basePipelineHandle  C.VkPipeline
	basePipelineIndex   i32
}

pub type PushConstantRange = C.VkPushConstantRange

@[typedef]
pub struct C.VkPushConstantRange {
pub mut:
	stageFlags ShaderStageFlags
	offset     u32
	size       u32
}

pub type PipelineLayoutCreateInfo = C.VkPipelineLayoutCreateInfo

@[typedef]
pub struct C.VkPipelineLayoutCreateInfo {
pub mut:
	sType                  StructureType = StructureType.pipeline_layout_create_info
	pNext                  voidptr       = unsafe { nil }
	flags                  PipelineLayoutCreateFlags
	setLayoutCount         u32
	pSetLayouts            C.VkDescriptorSetLayout
	pushConstantRangeCount u32
	pPushConstantRanges    &PushConstantRange
}

pub type SamplerCreateInfo = C.VkSamplerCreateInfo

@[typedef]
pub struct C.VkSamplerCreateInfo {
pub mut:
	sType                   StructureType = StructureType.sampler_create_info
	pNext                   voidptr       = unsafe { nil }
	flags                   SamplerCreateFlags
	magFilter               Filter
	minFilter               Filter
	mipmapMode              SamplerMipmapMode
	addressModeU            SamplerAddressMode
	addressModeV            SamplerAddressMode
	addressModeW            SamplerAddressMode
	mipLodBias              f32
	anisotropyEnable        Bool32
	maxAnisotropy           f32
	compareEnable           Bool32
	compareOp               CompareOp
	minLod                  f32
	maxLod                  f32
	borderColor             BorderColor
	unnormalizedCoordinates Bool32
}

pub type CopyDescriptorSet = C.VkCopyDescriptorSet

@[typedef]
pub struct C.VkCopyDescriptorSet {
pub mut:
	sType           StructureType = StructureType.copy_descriptor_set
	pNext           voidptr       = unsafe { nil }
	srcSet          C.VkDescriptorSet
	srcBinding      u32
	srcArrayElement u32
	dstSet          C.VkDescriptorSet
	dstBinding      u32
	dstArrayElement u32
	descriptorCount u32
}

pub type DescriptorBufferInfo = C.VkDescriptorBufferInfo

@[typedef]
pub struct C.VkDescriptorBufferInfo {
pub mut:
	buffer C.VkBuffer
	offset DeviceSize
	range  DeviceSize
}

pub type DescriptorImageInfo = C.VkDescriptorImageInfo

@[typedef]
pub struct C.VkDescriptorImageInfo {
pub mut:
	sampler     C.VkSampler
	imageView   C.VkImageView
	imageLayout ImageLayout
}

pub type DescriptorPoolSize = C.VkDescriptorPoolSize

@[typedef]
pub struct C.VkDescriptorPoolSize {
pub mut:
	type            DescriptorType
	descriptorCount u32
}

pub type DescriptorPoolCreateInfo = C.VkDescriptorPoolCreateInfo

@[typedef]
pub struct C.VkDescriptorPoolCreateInfo {
pub mut:
	sType         StructureType = StructureType.descriptor_pool_create_info
	pNext         voidptr       = unsafe { nil }
	flags         DescriptorPoolCreateFlags
	maxSets       u32
	poolSizeCount u32
	pPoolSizes    &DescriptorPoolSize
}

pub type DescriptorSetAllocateInfo = C.VkDescriptorSetAllocateInfo

@[typedef]
pub struct C.VkDescriptorSetAllocateInfo {
pub mut:
	sType              StructureType = StructureType.descriptor_set_allocate_info
	pNext              voidptr       = unsafe { nil }
	descriptorPool     C.VkDescriptorPool
	descriptorSetCount u32
	pSetLayouts        C.VkDescriptorSetLayout
}

pub type DescriptorSetLayoutBinding = C.VkDescriptorSetLayoutBinding

@[typedef]
pub struct C.VkDescriptorSetLayoutBinding {
pub mut:
	binding            u32
	descriptorType     DescriptorType
	descriptorCount    u32
	stageFlags         ShaderStageFlags
	pImmutableSamplers C.VkSampler
}

pub type DescriptorSetLayoutCreateInfo = C.VkDescriptorSetLayoutCreateInfo

@[typedef]
pub struct C.VkDescriptorSetLayoutCreateInfo {
pub mut:
	sType        StructureType = StructureType.descriptor_set_layout_create_info
	pNext        voidptr       = unsafe { nil }
	flags        DescriptorSetLayoutCreateFlags
	bindingCount u32
	pBindings    &DescriptorSetLayoutBinding
}

pub type WriteDescriptorSet = C.VkWriteDescriptorSet

@[typedef]
pub struct C.VkWriteDescriptorSet {
pub mut:
	sType            StructureType = StructureType.write_descriptor_set
	pNext            voidptr       = unsafe { nil }
	dstSet           C.VkDescriptorSet
	dstBinding       u32
	dstArrayElement  u32
	descriptorCount  u32
	descriptorType   DescriptorType
	pImageInfo       &DescriptorImageInfo
	pBufferInfo      &DescriptorBufferInfo
	pTexelBufferView C.VkBufferView
}

pub type AttachmentDescription = C.VkAttachmentDescription

@[typedef]
pub struct C.VkAttachmentDescription {
pub mut:
	flags          AttachmentDescriptionFlags
	format         Format
	samples        SampleCountFlagBits
	loadOp         AttachmentLoadOp
	storeOp        AttachmentStoreOp
	stencilLoadOp  AttachmentLoadOp
	stencilStoreOp AttachmentStoreOp
	initialLayout  ImageLayout
	finalLayout    ImageLayout
}

pub type AttachmentReference = C.VkAttachmentReference

@[typedef]
pub struct C.VkAttachmentReference {
pub mut:
	attachment u32
	layout     ImageLayout
}

pub type FramebufferCreateInfo = C.VkFramebufferCreateInfo

@[typedef]
pub struct C.VkFramebufferCreateInfo {
pub mut:
	sType           StructureType = StructureType.framebuffer_create_info
	pNext           voidptr       = unsafe { nil }
	flags           FramebufferCreateFlags
	renderPass      C.VkRenderPass
	attachmentCount u32
	pAttachments    C.VkImageView
	width           u32
	height          u32
	layers          u32
}

pub type SubpassDescription = C.VkSubpassDescription

@[typedef]
pub struct C.VkSubpassDescription {
pub mut:
	flags                   SubpassDescriptionFlags
	pipelineBindPoint       PipelineBindPoint
	inputAttachmentCount    u32
	pInputAttachments       &AttachmentReference
	colorAttachmentCount    u32
	pColorAttachments       &AttachmentReference
	pResolveAttachments     &AttachmentReference
	pDepthStencilAttachment &AttachmentReference
	preserveAttachmentCount u32
	pPreserveAttachments    &u32
}

pub type SubpassDependency = C.VkSubpassDependency

@[typedef]
pub struct C.VkSubpassDependency {
pub mut:
	srcSubpass      u32
	dstSubpass      u32
	srcStageMask    PipelineStageFlags
	dstStageMask    PipelineStageFlags
	srcAccessMask   AccessFlags
	dstAccessMask   AccessFlags
	dependencyFlags DependencyFlags
}

pub type RenderPassCreateInfo = C.VkRenderPassCreateInfo

@[typedef]
pub struct C.VkRenderPassCreateInfo {
pub mut:
	sType           StructureType = StructureType.render_pass_create_info
	pNext           voidptr       = unsafe { nil }
	flags           RenderPassCreateFlags
	attachmentCount u32
	pAttachments    &AttachmentDescription
	subpassCount    u32
	pSubpasses      &SubpassDescription
	dependencyCount u32
	pDependencies   &SubpassDependency
}

pub type CommandPoolCreateInfo = C.VkCommandPoolCreateInfo

@[typedef]
pub struct C.VkCommandPoolCreateInfo {
pub mut:
	sType            StructureType = StructureType.command_pool_create_info
	pNext            voidptr       = unsafe { nil }
	flags            CommandPoolCreateFlags
	queueFamilyIndex u32
}

pub type CommandBufferAllocateInfo = C.VkCommandBufferAllocateInfo

@[typedef]
pub struct C.VkCommandBufferAllocateInfo {
pub mut:
	sType              StructureType = StructureType.command_buffer_allocate_info
	pNext              voidptr       = unsafe { nil }
	commandPool        C.VkCommandPool
	level              CommandBufferLevel
	commandBufferCount u32
}

pub type CommandBufferInheritanceInfo = C.VkCommandBufferInheritanceInfo

@[typedef]
pub struct C.VkCommandBufferInheritanceInfo {
pub mut:
	sType                StructureType = StructureType.command_buffer_inheritance_info
	pNext                voidptr       = unsafe { nil }
	renderPass           C.VkRenderPass
	subpass              u32
	framebuffer          C.VkFramebuffer
	occlusionQueryEnable Bool32
	queryFlags           QueryControlFlags
	pipelineStatistics   QueryPipelineStatisticFlags
}

pub type CommandBufferBeginInfo = C.VkCommandBufferBeginInfo

@[typedef]
pub struct C.VkCommandBufferBeginInfo {
pub mut:
	sType            StructureType = StructureType.command_buffer_begin_info
	pNext            voidptr       = unsafe { nil }
	flags            CommandBufferUsageFlags
	pInheritanceInfo &CommandBufferInheritanceInfo
}

pub type BufferCopy = C.VkBufferCopy

@[typedef]
pub struct C.VkBufferCopy {
pub mut:
	srcOffset DeviceSize
	dstOffset DeviceSize
	size      DeviceSize
}

pub type ImageSubresourceLayers = C.VkImageSubresourceLayers

@[typedef]
pub struct C.VkImageSubresourceLayers {
pub mut:
	aspectMask     ImageAspectFlags
	mipLevel       u32
	baseArrayLayer u32
	layerCount     u32
}

pub type BufferImageCopy = C.VkBufferImageCopy

@[typedef]
pub struct C.VkBufferImageCopy {
pub mut:
	bufferOffset      DeviceSize
	bufferRowLength   u32
	bufferImageHeight u32
	imageSubresource  ImageSubresourceLayers
	imageOffset       Offset3D
	imageExtent       Extent3D
}

pub type ClearColorValue = C.VkClearColorValue

@[typedef]
pub union C.VkClearColorValue {
pub mut:
	float32 [4]f32
	int32   [4]i32
	uint32  [4]u32
}

pub type ClearDepthStencilValue = C.VkClearDepthStencilValue

@[typedef]
pub struct C.VkClearDepthStencilValue {
pub mut:
	depth   f32
	stencil u32
}

pub type ClearValue = C.VkClearValue

@[typedef]
pub union C.VkClearValue {
pub mut:
	color        ClearColorValue
	depthStencil ClearDepthStencilValue
}

pub type ClearAttachment = C.VkClearAttachment

@[typedef]
pub struct C.VkClearAttachment {
pub mut:
	aspectMask      ImageAspectFlags
	colorAttachment u32
	clearValue      ClearValue
}

pub type ClearRect = C.VkClearRect

@[typedef]
pub struct C.VkClearRect {
pub mut:
	rect           Rect2D
	baseArrayLayer u32
	layerCount     u32
}

pub type ImageBlit = C.VkImageBlit

@[typedef]
pub struct C.VkImageBlit {
pub mut:
	srcSubresource ImageSubresourceLayers
	srcOffsets     [2]Offset3D
	dstSubresource ImageSubresourceLayers
	dstOffsets     [2]Offset3D
}

pub type ImageCopy = C.VkImageCopy

@[typedef]
pub struct C.VkImageCopy {
pub mut:
	srcSubresource ImageSubresourceLayers
	srcOffset      Offset3D
	dstSubresource ImageSubresourceLayers
	dstOffset      Offset3D
	extent         Extent3D
}

pub type ImageResolve = C.VkImageResolve

@[typedef]
pub struct C.VkImageResolve {
pub mut:
	srcSubresource ImageSubresourceLayers
	srcOffset      Offset3D
	dstSubresource ImageSubresourceLayers
	dstOffset      Offset3D
	extent         Extent3D
}

pub type RenderPassBeginInfo = C.VkRenderPassBeginInfo

@[typedef]
pub struct C.VkRenderPassBeginInfo {
pub mut:
	sType           StructureType = StructureType.render_pass_begin_info
	pNext           voidptr       = unsafe { nil }
	renderPass      C.VkRenderPass
	framebuffer     C.VkFramebuffer
	renderArea      Rect2D
	clearValueCount u32
	pClearValues    &ClearValue
}

fn C.vkCreateInstance(&InstanceCreateInfo, &AllocationCallbacks, C.VkInstance) Result

pub type PFN_vkCreateInstance = fn (&InstanceCreateInfo, &AllocationCallbacks, C.VkInstance) Result

@[inline]
pub fn create_instance(p_create_info &InstanceCreateInfo,
	p_allocator &AllocationCallbacks,
	p_instance C.VkInstance) Result {
	return C.vkCreateInstance(p_create_info, p_allocator, p_instance)
}

fn C.vkDestroyInstance(C.VkInstance, &AllocationCallbacks)

pub type PFN_vkDestroyInstance = fn (C.VkInstance, &AllocationCallbacks)

@[inline]
pub fn destroy_instance(instance C.VkInstance,
	p_allocator &AllocationCallbacks) {
	C.vkDestroyInstance(instance, p_allocator)
}

fn C.vkEnumeratePhysicalDevices(C.VkInstance, &u32, C.VkPhysicalDevice) Result

pub type PFN_vkEnumeratePhysicalDevices = fn (C.VkInstance, &u32, C.VkPhysicalDevice) Result

@[inline]
pub fn enumerate_physical_devices(instance C.VkInstance,
	p_physical_device_count &u32,
	p_physical_devices C.VkPhysicalDevice) Result {
	return C.vkEnumeratePhysicalDevices(instance, p_physical_device_count, p_physical_devices)
}

fn C.vkGetPhysicalDeviceFeatures(C.VkPhysicalDevice, &PhysicalDeviceFeatures)

pub type PFN_vkGetPhysicalDeviceFeatures = fn (C.VkPhysicalDevice, &PhysicalDeviceFeatures)

@[inline]
pub fn get_physical_device_features(physical_device C.VkPhysicalDevice,
	p_features &PhysicalDeviceFeatures) {
	C.vkGetPhysicalDeviceFeatures(physical_device, p_features)
}

fn C.vkGetPhysicalDeviceFormatProperties(C.VkPhysicalDevice, Format, &FormatProperties)

pub type PFN_vkGetPhysicalDeviceFormatProperties = fn (C.VkPhysicalDevice, Format, &FormatProperties)

@[inline]
pub fn get_physical_device_format_properties(physical_device C.VkPhysicalDevice,
	format Format,
	p_format_properties &FormatProperties) {
	C.vkGetPhysicalDeviceFormatProperties(physical_device, format, p_format_properties)
}

fn C.vkGetPhysicalDeviceImageFormatProperties(C.VkPhysicalDevice, Format, ImageType, ImageTiling, ImageUsageFlags, ImageCreateFlags, &ImageFormatProperties) Result

pub type PFN_vkGetPhysicalDeviceImageFormatProperties = fn (C.VkPhysicalDevice, Format, ImageType, ImageTiling, ImageUsageFlags, ImageCreateFlags, &ImageFormatProperties) Result

@[inline]
pub fn get_physical_device_image_format_properties(physical_device C.VkPhysicalDevice,
	format Format,
	type ImageType,
	tiling ImageTiling,
	usage ImageUsageFlags,
	flags ImageCreateFlags,
	p_image_format_properties &ImageFormatProperties) Result {
	return C.vkGetPhysicalDeviceImageFormatProperties(physical_device, format, type, tiling,
		usage, flags, p_image_format_properties)
}

fn C.vkGetPhysicalDeviceProperties(C.VkPhysicalDevice, &PhysicalDeviceProperties)

pub type PFN_vkGetPhysicalDeviceProperties = fn (C.VkPhysicalDevice, &PhysicalDeviceProperties)

@[inline]
pub fn get_physical_device_properties(physical_device C.VkPhysicalDevice,
	p_properties &PhysicalDeviceProperties) {
	C.vkGetPhysicalDeviceProperties(physical_device, p_properties)
}

fn C.vkGetPhysicalDeviceQueueFamilyProperties(C.VkPhysicalDevice, &u32, &QueueFamilyProperties)

pub type PFN_vkGetPhysicalDeviceQueueFamilyProperties = fn (C.VkPhysicalDevice, &u32, &QueueFamilyProperties)

@[inline]
pub fn get_physical_device_queue_family_properties(physical_device C.VkPhysicalDevice,
	p_queue_family_property_count &u32,
	p_queue_family_properties &QueueFamilyProperties) {
	C.vkGetPhysicalDeviceQueueFamilyProperties(physical_device, p_queue_family_property_count,
		p_queue_family_properties)
}

fn C.vkGetPhysicalDeviceMemoryProperties(C.VkPhysicalDevice, &PhysicalDeviceMemoryProperties)

pub type PFN_vkGetPhysicalDeviceMemoryProperties = fn (C.VkPhysicalDevice, &PhysicalDeviceMemoryProperties)

@[inline]
pub fn get_physical_device_memory_properties(physical_device C.VkPhysicalDevice,
	p_memory_properties &PhysicalDeviceMemoryProperties) {
	C.vkGetPhysicalDeviceMemoryProperties(physical_device, p_memory_properties)
}

fn C.vkGetInstanceProcAddr(C.VkInstance, &char)

pub type PFN_vkGetInstanceProcAddr = fn (C.VkInstance, &char)

@[inline]
pub fn get_instance_proc_addr(instance C.VkInstance,
	p_name &char) {
	C.vkGetInstanceProcAddr(instance, p_name)
}

fn C.vkGetDeviceProcAddr(C.VkDevice, &char)

pub type PFN_vkGetDeviceProcAddr = fn (C.VkDevice, &char)

@[inline]
pub fn get_device_proc_addr(device C.VkDevice,
	p_name &char) {
	C.vkGetDeviceProcAddr(device, p_name)
}

fn C.vkCreateDevice(C.VkPhysicalDevice, &DeviceCreateInfo, &AllocationCallbacks, C.VkDevice) Result

pub type PFN_vkCreateDevice = fn (C.VkPhysicalDevice, &DeviceCreateInfo, &AllocationCallbacks, C.VkDevice) Result

@[inline]
pub fn create_device(physical_device C.VkPhysicalDevice,
	p_create_info &DeviceCreateInfo,
	p_allocator &AllocationCallbacks,
	p_device C.VkDevice) Result {
	return C.vkCreateDevice(physical_device, p_create_info, p_allocator, p_device)
}

fn C.vkDestroyDevice(C.VkDevice, &AllocationCallbacks)

pub type PFN_vkDestroyDevice = fn (C.VkDevice, &AllocationCallbacks)

@[inline]
pub fn destroy_device(device C.VkDevice,
	p_allocator &AllocationCallbacks) {
	C.vkDestroyDevice(device, p_allocator)
}

fn C.vkEnumerateInstanceExtensionProperties(&char, &u32, &ExtensionProperties) Result

pub type PFN_vkEnumerateInstanceExtensionProperties = fn (&char, &u32, &ExtensionProperties) Result

@[inline]
pub fn enumerate_instance_extension_properties(p_layer_name &char,
	p_property_count &u32,
	p_properties &ExtensionProperties) Result {
	return C.vkEnumerateInstanceExtensionProperties(p_layer_name, p_property_count, p_properties)
}

fn C.vkEnumerateDeviceExtensionProperties(C.VkPhysicalDevice, &char, &u32, &ExtensionProperties) Result

pub type PFN_vkEnumerateDeviceExtensionProperties = fn (C.VkPhysicalDevice, &char, &u32, &ExtensionProperties) Result

@[inline]
pub fn enumerate_device_extension_properties(physical_device C.VkPhysicalDevice,
	p_layer_name &char,
	p_property_count &u32,
	p_properties &ExtensionProperties) Result {
	return C.vkEnumerateDeviceExtensionProperties(physical_device, p_layer_name, p_property_count,
		p_properties)
}

fn C.vkEnumerateInstanceLayerProperties(&u32, &LayerProperties) Result

pub type PFN_vkEnumerateInstanceLayerProperties = fn (&u32, &LayerProperties) Result

@[inline]
pub fn enumerate_instance_layer_properties(p_property_count &u32,
	p_properties &LayerProperties) Result {
	return C.vkEnumerateInstanceLayerProperties(p_property_count, p_properties)
}

fn C.vkEnumerateDeviceLayerProperties(C.VkPhysicalDevice, &u32, &LayerProperties) Result

pub type PFN_vkEnumerateDeviceLayerProperties = fn (C.VkPhysicalDevice, &u32, &LayerProperties) Result

@[inline]
pub fn enumerate_device_layer_properties(physical_device C.VkPhysicalDevice,
	p_property_count &u32,
	p_properties &LayerProperties) Result {
	return C.vkEnumerateDeviceLayerProperties(physical_device, p_property_count, p_properties)
}

fn C.vkGetDeviceQueue(C.VkDevice, u32, u32, C.VkQueue)

pub type PFN_vkGetDeviceQueue = fn (C.VkDevice, u32, u32, C.VkQueue)

@[inline]
pub fn get_device_queue(device C.VkDevice,
	queue_family_index u32,
	queue_index u32,
	p_queue C.VkQueue) {
	C.vkGetDeviceQueue(device, queue_family_index, queue_index, p_queue)
}

fn C.vkQueueSubmit(C.VkQueue, u32, &SubmitInfo, C.VkFence) Result

pub type PFN_vkQueueSubmit = fn (C.VkQueue, u32, &SubmitInfo, C.VkFence) Result

@[inline]
pub fn queue_submit(queue C.VkQueue,
	submit_count u32,
	p_submits &SubmitInfo,
	fence C.VkFence) Result {
	return C.vkQueueSubmit(queue, submit_count, p_submits, fence)
}

fn C.vkQueueWaitIdle(C.VkQueue) Result

pub type PFN_vkQueueWaitIdle = fn (C.VkQueue) Result

@[inline]
pub fn queue_wait_idle(queue C.VkQueue) Result {
	return C.vkQueueWaitIdle(queue)
}

fn C.vkDeviceWaitIdle(C.VkDevice) Result

pub type PFN_vkDeviceWaitIdle = fn (C.VkDevice) Result

@[inline]
pub fn device_wait_idle(device C.VkDevice) Result {
	return C.vkDeviceWaitIdle(device)
}

fn C.vkAllocateMemory(C.VkDevice, &MemoryAllocateInfo, &AllocationCallbacks, C.VkDeviceMemory) Result

pub type PFN_vkAllocateMemory = fn (C.VkDevice, &MemoryAllocateInfo, &AllocationCallbacks, C.VkDeviceMemory) Result

@[inline]
pub fn allocate_memory(device C.VkDevice,
	p_allocate_info &MemoryAllocateInfo,
	p_allocator &AllocationCallbacks,
	p_memory C.VkDeviceMemory) Result {
	return C.vkAllocateMemory(device, p_allocate_info, p_allocator, p_memory)
}

fn C.vkFreeMemory(C.VkDevice, C.VkDeviceMemory, &AllocationCallbacks)

pub type PFN_vkFreeMemory = fn (C.VkDevice, C.VkDeviceMemory, &AllocationCallbacks)

@[inline]
pub fn free_memory(device C.VkDevice,
	memory C.VkDeviceMemory,
	p_allocator &AllocationCallbacks) {
	C.vkFreeMemory(device, memory, p_allocator)
}

fn C.vkMapMemory(C.VkDevice, C.VkDeviceMemory, DeviceSize, DeviceSize, MemoryMapFlags, &voidptr) Result

pub type PFN_vkMapMemory = fn (C.VkDevice, C.VkDeviceMemory, DeviceSize, DeviceSize, MemoryMapFlags, &voidptr) Result

@[inline]
pub fn map_memory(device C.VkDevice,
	memory C.VkDeviceMemory,
	offset DeviceSize,
	size DeviceSize,
	flags MemoryMapFlags,
	pp_data &voidptr) Result {
	return C.vkMapMemory(device, memory, offset, size, flags, pp_data)
}

fn C.vkUnmapMemory(C.VkDevice, C.VkDeviceMemory)

pub type PFN_vkUnmapMemory = fn (C.VkDevice, C.VkDeviceMemory)

@[inline]
pub fn unmap_memory(device C.VkDevice,
	memory C.VkDeviceMemory) {
	C.vkUnmapMemory(device, memory)
}

fn C.vkFlushMappedMemoryRanges(C.VkDevice, u32, &MappedMemoryRange) Result

pub type PFN_vkFlushMappedMemoryRanges = fn (C.VkDevice, u32, &MappedMemoryRange) Result

@[inline]
pub fn flush_mapped_memory_ranges(device C.VkDevice,
	memory_range_count u32,
	p_memory_ranges &MappedMemoryRange) Result {
	return C.vkFlushMappedMemoryRanges(device, memory_range_count, p_memory_ranges)
}

fn C.vkInvalidateMappedMemoryRanges(C.VkDevice, u32, &MappedMemoryRange) Result

pub type PFN_vkInvalidateMappedMemoryRanges = fn (C.VkDevice, u32, &MappedMemoryRange) Result

@[inline]
pub fn invalidate_mapped_memory_ranges(device C.VkDevice,
	memory_range_count u32,
	p_memory_ranges &MappedMemoryRange) Result {
	return C.vkInvalidateMappedMemoryRanges(device, memory_range_count, p_memory_ranges)
}

fn C.vkGetDeviceMemoryCommitment(C.VkDevice, C.VkDeviceMemory, &DeviceSize)

pub type PFN_vkGetDeviceMemoryCommitment = fn (C.VkDevice, C.VkDeviceMemory, &DeviceSize)

@[inline]
pub fn get_device_memory_commitment(device C.VkDevice,
	memory C.VkDeviceMemory,
	p_committed_memory_in_bytes &DeviceSize) {
	C.vkGetDeviceMemoryCommitment(device, memory, p_committed_memory_in_bytes)
}

fn C.vkBindBufferMemory(C.VkDevice, C.VkBuffer, C.VkDeviceMemory, DeviceSize) Result

pub type PFN_vkBindBufferMemory = fn (C.VkDevice, C.VkBuffer, C.VkDeviceMemory, DeviceSize) Result

@[inline]
pub fn bind_buffer_memory(device C.VkDevice,
	buffer C.VkBuffer,
	memory C.VkDeviceMemory,
	memory_offset DeviceSize) Result {
	return C.vkBindBufferMemory(device, buffer, memory, memory_offset)
}

fn C.vkBindImageMemory(C.VkDevice, C.VkImage, C.VkDeviceMemory, DeviceSize) Result

pub type PFN_vkBindImageMemory = fn (C.VkDevice, C.VkImage, C.VkDeviceMemory, DeviceSize) Result

@[inline]
pub fn bind_image_memory(device C.VkDevice,
	image C.VkImage,
	memory C.VkDeviceMemory,
	memory_offset DeviceSize) Result {
	return C.vkBindImageMemory(device, image, memory, memory_offset)
}

fn C.vkGetBufferMemoryRequirements(C.VkDevice, C.VkBuffer, &MemoryRequirements)

pub type PFN_vkGetBufferMemoryRequirements = fn (C.VkDevice, C.VkBuffer, &MemoryRequirements)

@[inline]
pub fn get_buffer_memory_requirements(device C.VkDevice,
	buffer C.VkBuffer,
	p_memory_requirements &MemoryRequirements) {
	C.vkGetBufferMemoryRequirements(device, buffer, p_memory_requirements)
}

fn C.vkGetImageMemoryRequirements(C.VkDevice, C.VkImage, &MemoryRequirements)

pub type PFN_vkGetImageMemoryRequirements = fn (C.VkDevice, C.VkImage, &MemoryRequirements)

@[inline]
pub fn get_image_memory_requirements(device C.VkDevice,
	image C.VkImage,
	p_memory_requirements &MemoryRequirements) {
	C.vkGetImageMemoryRequirements(device, image, p_memory_requirements)
}

fn C.vkGetImageSparseMemoryRequirements(C.VkDevice, C.VkImage, &u32, &SparseImageMemoryRequirements)

pub type PFN_vkGetImageSparseMemoryRequirements = fn (C.VkDevice, C.VkImage, &u32, &SparseImageMemoryRequirements)

@[inline]
pub fn get_image_sparse_memory_requirements(device C.VkDevice,
	image C.VkImage,
	p_sparse_memory_requirement_count &u32,
	p_sparse_memory_requirements &SparseImageMemoryRequirements) {
	C.vkGetImageSparseMemoryRequirements(device, image, p_sparse_memory_requirement_count,
		p_sparse_memory_requirements)
}

fn C.vkGetPhysicalDeviceSparseImageFormatProperties(C.VkPhysicalDevice, Format, ImageType, SampleCountFlagBits, ImageUsageFlags, ImageTiling, &u32, &SparseImageFormatProperties)

pub type PFN_vkGetPhysicalDeviceSparseImageFormatProperties = fn (C.VkPhysicalDevice, Format, ImageType, SampleCountFlagBits, ImageUsageFlags, ImageTiling, &u32, &SparseImageFormatProperties)

@[inline]
pub fn get_physical_device_sparse_image_format_properties(physical_device C.VkPhysicalDevice,
	format Format,
	type ImageType,
	samples SampleCountFlagBits,
	usage ImageUsageFlags,
	tiling ImageTiling,
	p_property_count &u32,
	p_properties &SparseImageFormatProperties) {
	C.vkGetPhysicalDeviceSparseImageFormatProperties(physical_device, format, type, samples,
		usage, tiling, p_property_count, p_properties)
}

fn C.vkQueueBindSparse(C.VkQueue, u32, &BindSparseInfo, C.VkFence) Result

pub type PFN_vkQueueBindSparse = fn (C.VkQueue, u32, &BindSparseInfo, C.VkFence) Result

@[inline]
pub fn queue_bind_sparse(queue C.VkQueue,
	bind_info_count u32,
	p_bind_info &BindSparseInfo,
	fence C.VkFence) Result {
	return C.vkQueueBindSparse(queue, bind_info_count, p_bind_info, fence)
}

fn C.vkCreateFence(C.VkDevice, &FenceCreateInfo, &AllocationCallbacks, C.VkFence) Result

pub type PFN_vkCreateFence = fn (C.VkDevice, &FenceCreateInfo, &AllocationCallbacks, C.VkFence) Result

@[inline]
pub fn create_fence(device C.VkDevice,
	p_create_info &FenceCreateInfo,
	p_allocator &AllocationCallbacks,
	p_fence C.VkFence) Result {
	return C.vkCreateFence(device, p_create_info, p_allocator, p_fence)
}

fn C.vkDestroyFence(C.VkDevice, C.VkFence, &AllocationCallbacks)

pub type PFN_vkDestroyFence = fn (C.VkDevice, C.VkFence, &AllocationCallbacks)

@[inline]
pub fn destroy_fence(device C.VkDevice,
	fence C.VkFence,
	p_allocator &AllocationCallbacks) {
	C.vkDestroyFence(device, fence, p_allocator)
}

fn C.vkResetFences(C.VkDevice, u32, C.VkFence) Result

pub type PFN_vkResetFences = fn (C.VkDevice, u32, C.VkFence) Result

@[inline]
pub fn reset_fences(device C.VkDevice,
	fence_count u32,
	p_fences C.VkFence) Result {
	return C.vkResetFences(device, fence_count, p_fences)
}

fn C.vkGetFenceStatus(C.VkDevice, C.VkFence) Result

pub type PFN_vkGetFenceStatus = fn (C.VkDevice, C.VkFence) Result

@[inline]
pub fn get_fence_status(device C.VkDevice,
	fence C.VkFence) Result {
	return C.vkGetFenceStatus(device, fence)
}

fn C.vkWaitForFences(C.VkDevice, u32, C.VkFence, Bool32, u64) Result

pub type PFN_vkWaitForFences = fn (C.VkDevice, u32, C.VkFence, Bool32, u64) Result

@[inline]
pub fn wait_for_fences(device C.VkDevice,
	fence_count u32,
	p_fences C.VkFence,
	wait_all Bool32,
	timeout u64) Result {
	return C.vkWaitForFences(device, fence_count, p_fences, wait_all, timeout)
}

fn C.vkCreateSemaphore(C.VkDevice, &SemaphoreCreateInfo, &AllocationCallbacks, C.VkSemaphore) Result

pub type PFN_vkCreateSemaphore = fn (C.VkDevice, &SemaphoreCreateInfo, &AllocationCallbacks, C.VkSemaphore) Result

@[inline]
pub fn create_semaphore(device C.VkDevice,
	p_create_info &SemaphoreCreateInfo,
	p_allocator &AllocationCallbacks,
	p_semaphore C.VkSemaphore) Result {
	return C.vkCreateSemaphore(device, p_create_info, p_allocator, p_semaphore)
}

fn C.vkDestroySemaphore(C.VkDevice, C.VkSemaphore, &AllocationCallbacks)

pub type PFN_vkDestroySemaphore = fn (C.VkDevice, C.VkSemaphore, &AllocationCallbacks)

@[inline]
pub fn destroy_semaphore(device C.VkDevice,
	semaphore C.VkSemaphore,
	p_allocator &AllocationCallbacks) {
	C.vkDestroySemaphore(device, semaphore, p_allocator)
}

fn C.vkCreateEvent(C.VkDevice, &EventCreateInfo, &AllocationCallbacks, C.VkEvent) Result

pub type PFN_vkCreateEvent = fn (C.VkDevice, &EventCreateInfo, &AllocationCallbacks, C.VkEvent) Result

@[inline]
pub fn create_event(device C.VkDevice,
	p_create_info &EventCreateInfo,
	p_allocator &AllocationCallbacks,
	p_event C.VkEvent) Result {
	return C.vkCreateEvent(device, p_create_info, p_allocator, p_event)
}

fn C.vkDestroyEvent(C.VkDevice, C.VkEvent, &AllocationCallbacks)

pub type PFN_vkDestroyEvent = fn (C.VkDevice, C.VkEvent, &AllocationCallbacks)

@[inline]
pub fn destroy_event(device C.VkDevice,
	event C.VkEvent,
	p_allocator &AllocationCallbacks) {
	C.vkDestroyEvent(device, event, p_allocator)
}

fn C.vkGetEventStatus(C.VkDevice, C.VkEvent) Result

pub type PFN_vkGetEventStatus = fn (C.VkDevice, C.VkEvent) Result

@[inline]
pub fn get_event_status(device C.VkDevice,
	event C.VkEvent) Result {
	return C.vkGetEventStatus(device, event)
}

fn C.vkSetEvent(C.VkDevice, C.VkEvent) Result

pub type PFN_vkSetEvent = fn (C.VkDevice, C.VkEvent) Result

@[inline]
pub fn set_event(device C.VkDevice,
	event C.VkEvent) Result {
	return C.vkSetEvent(device, event)
}

fn C.vkResetEvent(C.VkDevice, C.VkEvent) Result

pub type PFN_vkResetEvent = fn (C.VkDevice, C.VkEvent) Result

@[inline]
pub fn reset_event(device C.VkDevice,
	event C.VkEvent) Result {
	return C.vkResetEvent(device, event)
}

fn C.vkCreateQueryPool(C.VkDevice, &QueryPoolCreateInfo, &AllocationCallbacks, C.VkQueryPool) Result

pub type PFN_vkCreateQueryPool = fn (C.VkDevice, &QueryPoolCreateInfo, &AllocationCallbacks, C.VkQueryPool) Result

@[inline]
pub fn create_query_pool(device C.VkDevice,
	p_create_info &QueryPoolCreateInfo,
	p_allocator &AllocationCallbacks,
	p_query_pool C.VkQueryPool) Result {
	return C.vkCreateQueryPool(device, p_create_info, p_allocator, p_query_pool)
}

fn C.vkDestroyQueryPool(C.VkDevice, C.VkQueryPool, &AllocationCallbacks)

pub type PFN_vkDestroyQueryPool = fn (C.VkDevice, C.VkQueryPool, &AllocationCallbacks)

@[inline]
pub fn destroy_query_pool(device C.VkDevice,
	query_pool C.VkQueryPool,
	p_allocator &AllocationCallbacks) {
	C.vkDestroyQueryPool(device, query_pool, p_allocator)
}

fn C.vkGetQueryPoolResults(C.VkDevice, C.VkQueryPool, u32, u32, usize, voidptr, DeviceSize, QueryResultFlags) Result

pub type PFN_vkGetQueryPoolResults = fn (C.VkDevice, C.VkQueryPool, u32, u32, usize, voidptr, DeviceSize, QueryResultFlags) Result

@[inline]
pub fn get_query_pool_results(device C.VkDevice,
	query_pool C.VkQueryPool,
	first_query u32,
	query_count u32,
	data_size usize,
	p_data voidptr,
	stride DeviceSize,
	flags QueryResultFlags) Result {
	return C.vkGetQueryPoolResults(device, query_pool, first_query, query_count, data_size,
		p_data, stride, flags)
}

fn C.vkCreateBuffer(C.VkDevice, &BufferCreateInfo, &AllocationCallbacks, C.VkBuffer) Result

pub type PFN_vkCreateBuffer = fn (C.VkDevice, &BufferCreateInfo, &AllocationCallbacks, C.VkBuffer) Result

@[inline]
pub fn create_buffer(device C.VkDevice,
	p_create_info &BufferCreateInfo,
	p_allocator &AllocationCallbacks,
	p_buffer C.VkBuffer) Result {
	return C.vkCreateBuffer(device, p_create_info, p_allocator, p_buffer)
}

fn C.vkDestroyBuffer(C.VkDevice, C.VkBuffer, &AllocationCallbacks)

pub type PFN_vkDestroyBuffer = fn (C.VkDevice, C.VkBuffer, &AllocationCallbacks)

@[inline]
pub fn destroy_buffer(device C.VkDevice,
	buffer C.VkBuffer,
	p_allocator &AllocationCallbacks) {
	C.vkDestroyBuffer(device, buffer, p_allocator)
}

fn C.vkCreateBufferView(C.VkDevice, &BufferViewCreateInfo, &AllocationCallbacks, C.VkBufferView) Result

pub type PFN_vkCreateBufferView = fn (C.VkDevice, &BufferViewCreateInfo, &AllocationCallbacks, C.VkBufferView) Result

@[inline]
pub fn create_buffer_view(device C.VkDevice,
	p_create_info &BufferViewCreateInfo,
	p_allocator &AllocationCallbacks,
	p_view C.VkBufferView) Result {
	return C.vkCreateBufferView(device, p_create_info, p_allocator, p_view)
}

fn C.vkDestroyBufferView(C.VkDevice, C.VkBufferView, &AllocationCallbacks)

pub type PFN_vkDestroyBufferView = fn (C.VkDevice, C.VkBufferView, &AllocationCallbacks)

@[inline]
pub fn destroy_buffer_view(device C.VkDevice,
	buffer_view C.VkBufferView,
	p_allocator &AllocationCallbacks) {
	C.vkDestroyBufferView(device, buffer_view, p_allocator)
}

fn C.vkCreateImage(C.VkDevice, &ImageCreateInfo, &AllocationCallbacks, C.VkImage) Result

pub type PFN_vkCreateImage = fn (C.VkDevice, &ImageCreateInfo, &AllocationCallbacks, C.VkImage) Result

@[inline]
pub fn create_image(device C.VkDevice,
	p_create_info &ImageCreateInfo,
	p_allocator &AllocationCallbacks,
	p_image C.VkImage) Result {
	return C.vkCreateImage(device, p_create_info, p_allocator, p_image)
}

fn C.vkDestroyImage(C.VkDevice, C.VkImage, &AllocationCallbacks)

pub type PFN_vkDestroyImage = fn (C.VkDevice, C.VkImage, &AllocationCallbacks)

@[inline]
pub fn destroy_image(device C.VkDevice,
	image C.VkImage,
	p_allocator &AllocationCallbacks) {
	C.vkDestroyImage(device, image, p_allocator)
}

fn C.vkGetImageSubresourceLayout(C.VkDevice, C.VkImage, &ImageSubresource, &SubresourceLayout)

pub type PFN_vkGetImageSubresourceLayout = fn (C.VkDevice, C.VkImage, &ImageSubresource, &SubresourceLayout)

@[inline]
pub fn get_image_subresource_layout(device C.VkDevice,
	image C.VkImage,
	p_subresource &ImageSubresource,
	p_layout &SubresourceLayout) {
	C.vkGetImageSubresourceLayout(device, image, p_subresource, p_layout)
}

fn C.vkCreateImageView(C.VkDevice, &ImageViewCreateInfo, &AllocationCallbacks, C.VkImageView) Result

pub type PFN_vkCreateImageView = fn (C.VkDevice, &ImageViewCreateInfo, &AllocationCallbacks, C.VkImageView) Result

@[inline]
pub fn create_image_view(device C.VkDevice,
	p_create_info &ImageViewCreateInfo,
	p_allocator &AllocationCallbacks,
	p_view C.VkImageView) Result {
	return C.vkCreateImageView(device, p_create_info, p_allocator, p_view)
}

fn C.vkDestroyImageView(C.VkDevice, C.VkImageView, &AllocationCallbacks)

pub type PFN_vkDestroyImageView = fn (C.VkDevice, C.VkImageView, &AllocationCallbacks)

@[inline]
pub fn destroy_image_view(device C.VkDevice,
	image_view C.VkImageView,
	p_allocator &AllocationCallbacks) {
	C.vkDestroyImageView(device, image_view, p_allocator)
}

fn C.vkCreateShaderModule(C.VkDevice, &ShaderModuleCreateInfo, &AllocationCallbacks, C.VkShaderModule) Result

pub type PFN_vkCreateShaderModule = fn (C.VkDevice, &ShaderModuleCreateInfo, &AllocationCallbacks, C.VkShaderModule) Result

@[inline]
pub fn create_shader_module(device C.VkDevice,
	p_create_info &ShaderModuleCreateInfo,
	p_allocator &AllocationCallbacks,
	p_shader_module C.VkShaderModule) Result {
	return C.vkCreateShaderModule(device, p_create_info, p_allocator, p_shader_module)
}

fn C.vkDestroyShaderModule(C.VkDevice, C.VkShaderModule, &AllocationCallbacks)

pub type PFN_vkDestroyShaderModule = fn (C.VkDevice, C.VkShaderModule, &AllocationCallbacks)

@[inline]
pub fn destroy_shader_module(device C.VkDevice,
	shader_module C.VkShaderModule,
	p_allocator &AllocationCallbacks) {
	C.vkDestroyShaderModule(device, shader_module, p_allocator)
}

fn C.vkCreatePipelineCache(C.VkDevice, &PipelineCacheCreateInfo, &AllocationCallbacks, C.VkPipelineCache) Result

pub type PFN_vkCreatePipelineCache = fn (C.VkDevice, &PipelineCacheCreateInfo, &AllocationCallbacks, C.VkPipelineCache) Result

@[inline]
pub fn create_pipeline_cache(device C.VkDevice,
	p_create_info &PipelineCacheCreateInfo,
	p_allocator &AllocationCallbacks,
	p_pipeline_cache C.VkPipelineCache) Result {
	return C.vkCreatePipelineCache(device, p_create_info, p_allocator, p_pipeline_cache)
}

fn C.vkDestroyPipelineCache(C.VkDevice, C.VkPipelineCache, &AllocationCallbacks)

pub type PFN_vkDestroyPipelineCache = fn (C.VkDevice, C.VkPipelineCache, &AllocationCallbacks)

@[inline]
pub fn destroy_pipeline_cache(device C.VkDevice,
	pipeline_cache C.VkPipelineCache,
	p_allocator &AllocationCallbacks) {
	C.vkDestroyPipelineCache(device, pipeline_cache, p_allocator)
}

fn C.vkGetPipelineCacheData(C.VkDevice, C.VkPipelineCache, &usize, voidptr) Result

pub type PFN_vkGetPipelineCacheData = fn (C.VkDevice, C.VkPipelineCache, &usize, voidptr) Result

@[inline]
pub fn get_pipeline_cache_data(device C.VkDevice,
	pipeline_cache C.VkPipelineCache,
	p_data_size &usize,
	p_data voidptr) Result {
	return C.vkGetPipelineCacheData(device, pipeline_cache, p_data_size, p_data)
}

fn C.vkMergePipelineCaches(C.VkDevice, C.VkPipelineCache, u32, C.VkPipelineCache) Result

pub type PFN_vkMergePipelineCaches = fn (C.VkDevice, C.VkPipelineCache, u32, C.VkPipelineCache) Result

@[inline]
pub fn merge_pipeline_caches(device C.VkDevice,
	dst_cache C.VkPipelineCache,
	src_cache_count u32,
	p_src_caches C.VkPipelineCache) Result {
	return C.vkMergePipelineCaches(device, dst_cache, src_cache_count, p_src_caches)
}

fn C.vkCreateGraphicsPipelines(C.VkDevice, C.VkPipelineCache, u32, &GraphicsPipelineCreateInfo, &AllocationCallbacks, C.VkPipeline) Result

pub type PFN_vkCreateGraphicsPipelines = fn (C.VkDevice, C.VkPipelineCache, u32, &GraphicsPipelineCreateInfo, &AllocationCallbacks, C.VkPipeline) Result

@[inline]
pub fn create_graphics_pipelines(device C.VkDevice,
	pipeline_cache C.VkPipelineCache,
	create_info_count u32,
	p_create_infos &GraphicsPipelineCreateInfo,
	p_allocator &AllocationCallbacks,
	p_pipelines C.VkPipeline) Result {
	return C.vkCreateGraphicsPipelines(device, pipeline_cache, create_info_count, p_create_infos,
		p_allocator, p_pipelines)
}

fn C.vkCreateComputePipelines(C.VkDevice, C.VkPipelineCache, u32, &ComputePipelineCreateInfo, &AllocationCallbacks, C.VkPipeline) Result

pub type PFN_vkCreateComputePipelines = fn (C.VkDevice, C.VkPipelineCache, u32, &ComputePipelineCreateInfo, &AllocationCallbacks, C.VkPipeline) Result

@[inline]
pub fn create_compute_pipelines(device C.VkDevice,
	pipeline_cache C.VkPipelineCache,
	create_info_count u32,
	p_create_infos &ComputePipelineCreateInfo,
	p_allocator &AllocationCallbacks,
	p_pipelines C.VkPipeline) Result {
	return C.vkCreateComputePipelines(device, pipeline_cache, create_info_count, p_create_infos,
		p_allocator, p_pipelines)
}

fn C.vkDestroyPipeline(C.VkDevice, C.VkPipeline, &AllocationCallbacks)

pub type PFN_vkDestroyPipeline = fn (C.VkDevice, C.VkPipeline, &AllocationCallbacks)

@[inline]
pub fn destroy_pipeline(device C.VkDevice,
	pipeline C.VkPipeline,
	p_allocator &AllocationCallbacks) {
	C.vkDestroyPipeline(device, pipeline, p_allocator)
}

fn C.vkCreatePipelineLayout(C.VkDevice, &PipelineLayoutCreateInfo, &AllocationCallbacks, C.VkPipelineLayout) Result

pub type PFN_vkCreatePipelineLayout = fn (C.VkDevice, &PipelineLayoutCreateInfo, &AllocationCallbacks, C.VkPipelineLayout) Result

@[inline]
pub fn create_pipeline_layout(device C.VkDevice,
	p_create_info &PipelineLayoutCreateInfo,
	p_allocator &AllocationCallbacks,
	p_pipeline_layout C.VkPipelineLayout) Result {
	return C.vkCreatePipelineLayout(device, p_create_info, p_allocator, p_pipeline_layout)
}

fn C.vkDestroyPipelineLayout(C.VkDevice, C.VkPipelineLayout, &AllocationCallbacks)

pub type PFN_vkDestroyPipelineLayout = fn (C.VkDevice, C.VkPipelineLayout, &AllocationCallbacks)

@[inline]
pub fn destroy_pipeline_layout(device C.VkDevice,
	pipeline_layout C.VkPipelineLayout,
	p_allocator &AllocationCallbacks) {
	C.vkDestroyPipelineLayout(device, pipeline_layout, p_allocator)
}

fn C.vkCreateSampler(C.VkDevice, &SamplerCreateInfo, &AllocationCallbacks, C.VkSampler) Result

pub type PFN_vkCreateSampler = fn (C.VkDevice, &SamplerCreateInfo, &AllocationCallbacks, C.VkSampler) Result

@[inline]
pub fn create_sampler(device C.VkDevice,
	p_create_info &SamplerCreateInfo,
	p_allocator &AllocationCallbacks,
	p_sampler C.VkSampler) Result {
	return C.vkCreateSampler(device, p_create_info, p_allocator, p_sampler)
}

fn C.vkDestroySampler(C.VkDevice, C.VkSampler, &AllocationCallbacks)

pub type PFN_vkDestroySampler = fn (C.VkDevice, C.VkSampler, &AllocationCallbacks)

@[inline]
pub fn destroy_sampler(device C.VkDevice,
	sampler C.VkSampler,
	p_allocator &AllocationCallbacks) {
	C.vkDestroySampler(device, sampler, p_allocator)
}

fn C.vkCreateDescriptorSetLayout(C.VkDevice, &DescriptorSetLayoutCreateInfo, &AllocationCallbacks, C.VkDescriptorSetLayout) Result

pub type PFN_vkCreateDescriptorSetLayout = fn (C.VkDevice, &DescriptorSetLayoutCreateInfo, &AllocationCallbacks, C.VkDescriptorSetLayout) Result

@[inline]
pub fn create_descriptor_set_layout(device C.VkDevice,
	p_create_info &DescriptorSetLayoutCreateInfo,
	p_allocator &AllocationCallbacks,
	p_set_layout C.VkDescriptorSetLayout) Result {
	return C.vkCreateDescriptorSetLayout(device, p_create_info, p_allocator, p_set_layout)
}

fn C.vkDestroyDescriptorSetLayout(C.VkDevice, C.VkDescriptorSetLayout, &AllocationCallbacks)

pub type PFN_vkDestroyDescriptorSetLayout = fn (C.VkDevice, C.VkDescriptorSetLayout, &AllocationCallbacks)

@[inline]
pub fn destroy_descriptor_set_layout(device C.VkDevice,
	descriptor_set_layout C.VkDescriptorSetLayout,
	p_allocator &AllocationCallbacks) {
	C.vkDestroyDescriptorSetLayout(device, descriptor_set_layout, p_allocator)
}

fn C.vkCreateDescriptorPool(C.VkDevice, &DescriptorPoolCreateInfo, &AllocationCallbacks, C.VkDescriptorPool) Result

pub type PFN_vkCreateDescriptorPool = fn (C.VkDevice, &DescriptorPoolCreateInfo, &AllocationCallbacks, C.VkDescriptorPool) Result

@[inline]
pub fn create_descriptor_pool(device C.VkDevice,
	p_create_info &DescriptorPoolCreateInfo,
	p_allocator &AllocationCallbacks,
	p_descriptor_pool C.VkDescriptorPool) Result {
	return C.vkCreateDescriptorPool(device, p_create_info, p_allocator, p_descriptor_pool)
}

fn C.vkDestroyDescriptorPool(C.VkDevice, C.VkDescriptorPool, &AllocationCallbacks)

pub type PFN_vkDestroyDescriptorPool = fn (C.VkDevice, C.VkDescriptorPool, &AllocationCallbacks)

@[inline]
pub fn destroy_descriptor_pool(device C.VkDevice,
	descriptor_pool C.VkDescriptorPool,
	p_allocator &AllocationCallbacks) {
	C.vkDestroyDescriptorPool(device, descriptor_pool, p_allocator)
}

fn C.vkResetDescriptorPool(C.VkDevice, C.VkDescriptorPool, DescriptorPoolResetFlags) Result

pub type PFN_vkResetDescriptorPool = fn (C.VkDevice, C.VkDescriptorPool, DescriptorPoolResetFlags) Result

@[inline]
pub fn reset_descriptor_pool(device C.VkDevice,
	descriptor_pool C.VkDescriptorPool,
	flags DescriptorPoolResetFlags) Result {
	return C.vkResetDescriptorPool(device, descriptor_pool, flags)
}

fn C.vkAllocateDescriptorSets(C.VkDevice, &DescriptorSetAllocateInfo, C.VkDescriptorSet) Result

pub type PFN_vkAllocateDescriptorSets = fn (C.VkDevice, &DescriptorSetAllocateInfo, C.VkDescriptorSet) Result

@[inline]
pub fn allocate_descriptor_sets(device C.VkDevice,
	p_allocate_info &DescriptorSetAllocateInfo,
	p_descriptor_sets C.VkDescriptorSet) Result {
	return C.vkAllocateDescriptorSets(device, p_allocate_info, p_descriptor_sets)
}

fn C.vkFreeDescriptorSets(C.VkDevice, C.VkDescriptorPool, u32, C.VkDescriptorSet) Result

pub type PFN_vkFreeDescriptorSets = fn (C.VkDevice, C.VkDescriptorPool, u32, C.VkDescriptorSet) Result

@[inline]
pub fn free_descriptor_sets(device C.VkDevice,
	descriptor_pool C.VkDescriptorPool,
	descriptor_set_count u32,
	p_descriptor_sets C.VkDescriptorSet) Result {
	return C.vkFreeDescriptorSets(device, descriptor_pool, descriptor_set_count, p_descriptor_sets)
}

fn C.vkUpdateDescriptorSets(C.VkDevice, u32, &WriteDescriptorSet, u32, &CopyDescriptorSet)

pub type PFN_vkUpdateDescriptorSets = fn (C.VkDevice, u32, &WriteDescriptorSet, u32, &CopyDescriptorSet)

@[inline]
pub fn update_descriptor_sets(device C.VkDevice,
	descriptor_write_count u32,
	p_descriptor_writes &WriteDescriptorSet,
	descriptor_copy_count u32,
	p_descriptor_copies &CopyDescriptorSet) {
	C.vkUpdateDescriptorSets(device, descriptor_write_count, p_descriptor_writes, descriptor_copy_count,
		p_descriptor_copies)
}

fn C.vkCreateFramebuffer(C.VkDevice, &FramebufferCreateInfo, &AllocationCallbacks, C.VkFramebuffer) Result

pub type PFN_vkCreateFramebuffer = fn (C.VkDevice, &FramebufferCreateInfo, &AllocationCallbacks, C.VkFramebuffer) Result

@[inline]
pub fn create_framebuffer(device C.VkDevice,
	p_create_info &FramebufferCreateInfo,
	p_allocator &AllocationCallbacks,
	p_framebuffer C.VkFramebuffer) Result {
	return C.vkCreateFramebuffer(device, p_create_info, p_allocator, p_framebuffer)
}

fn C.vkDestroyFramebuffer(C.VkDevice, C.VkFramebuffer, &AllocationCallbacks)

pub type PFN_vkDestroyFramebuffer = fn (C.VkDevice, C.VkFramebuffer, &AllocationCallbacks)

@[inline]
pub fn destroy_framebuffer(device C.VkDevice,
	framebuffer C.VkFramebuffer,
	p_allocator &AllocationCallbacks) {
	C.vkDestroyFramebuffer(device, framebuffer, p_allocator)
}

fn C.vkCreateRenderPass(C.VkDevice, &RenderPassCreateInfo, &AllocationCallbacks, C.VkRenderPass) Result

pub type PFN_vkCreateRenderPass = fn (C.VkDevice, &RenderPassCreateInfo, &AllocationCallbacks, C.VkRenderPass) Result

@[inline]
pub fn create_render_pass(device C.VkDevice,
	p_create_info &RenderPassCreateInfo,
	p_allocator &AllocationCallbacks,
	p_render_pass C.VkRenderPass) Result {
	return C.vkCreateRenderPass(device, p_create_info, p_allocator, p_render_pass)
}

fn C.vkDestroyRenderPass(C.VkDevice, C.VkRenderPass, &AllocationCallbacks)

pub type PFN_vkDestroyRenderPass = fn (C.VkDevice, C.VkRenderPass, &AllocationCallbacks)

@[inline]
pub fn destroy_render_pass(device C.VkDevice,
	render_pass C.VkRenderPass,
	p_allocator &AllocationCallbacks) {
	C.vkDestroyRenderPass(device, render_pass, p_allocator)
}

fn C.vkGetRenderAreaGranularity(C.VkDevice, C.VkRenderPass, &Extent2D)

pub type PFN_vkGetRenderAreaGranularity = fn (C.VkDevice, C.VkRenderPass, &Extent2D)

@[inline]
pub fn get_render_area_granularity(device C.VkDevice,
	render_pass C.VkRenderPass,
	p_granularity &Extent2D) {
	C.vkGetRenderAreaGranularity(device, render_pass, p_granularity)
}

fn C.vkCreateCommandPool(C.VkDevice, &CommandPoolCreateInfo, &AllocationCallbacks, C.VkCommandPool) Result

pub type PFN_vkCreateCommandPool = fn (C.VkDevice, &CommandPoolCreateInfo, &AllocationCallbacks, C.VkCommandPool) Result

@[inline]
pub fn create_command_pool(device C.VkDevice,
	p_create_info &CommandPoolCreateInfo,
	p_allocator &AllocationCallbacks,
	p_command_pool C.VkCommandPool) Result {
	return C.vkCreateCommandPool(device, p_create_info, p_allocator, p_command_pool)
}

fn C.vkDestroyCommandPool(C.VkDevice, C.VkCommandPool, &AllocationCallbacks)

pub type PFN_vkDestroyCommandPool = fn (C.VkDevice, C.VkCommandPool, &AllocationCallbacks)

@[inline]
pub fn destroy_command_pool(device C.VkDevice,
	command_pool C.VkCommandPool,
	p_allocator &AllocationCallbacks) {
	C.vkDestroyCommandPool(device, command_pool, p_allocator)
}

fn C.vkResetCommandPool(C.VkDevice, C.VkCommandPool, CommandPoolResetFlags) Result

pub type PFN_vkResetCommandPool = fn (C.VkDevice, C.VkCommandPool, CommandPoolResetFlags) Result

@[inline]
pub fn reset_command_pool(device C.VkDevice,
	command_pool C.VkCommandPool,
	flags CommandPoolResetFlags) Result {
	return C.vkResetCommandPool(device, command_pool, flags)
}

fn C.vkAllocateCommandBuffers(C.VkDevice, &CommandBufferAllocateInfo, C.VkCommandBuffer) Result

pub type PFN_vkAllocateCommandBuffers = fn (C.VkDevice, &CommandBufferAllocateInfo, C.VkCommandBuffer) Result

@[inline]
pub fn allocate_command_buffers(device C.VkDevice,
	p_allocate_info &CommandBufferAllocateInfo,
	p_command_buffers C.VkCommandBuffer) Result {
	return C.vkAllocateCommandBuffers(device, p_allocate_info, p_command_buffers)
}

fn C.vkFreeCommandBuffers(C.VkDevice, C.VkCommandPool, u32, C.VkCommandBuffer)

pub type PFN_vkFreeCommandBuffers = fn (C.VkDevice, C.VkCommandPool, u32, C.VkCommandBuffer)

@[inline]
pub fn free_command_buffers(device C.VkDevice,
	command_pool C.VkCommandPool,
	command_buffer_count u32,
	p_command_buffers C.VkCommandBuffer) {
	C.vkFreeCommandBuffers(device, command_pool, command_buffer_count, p_command_buffers)
}

fn C.vkBeginCommandBuffer(C.VkCommandBuffer, &CommandBufferBeginInfo) Result

pub type PFN_vkBeginCommandBuffer = fn (C.VkCommandBuffer, &CommandBufferBeginInfo) Result

@[inline]
pub fn begin_command_buffer(command_buffer C.VkCommandBuffer,
	p_begin_info &CommandBufferBeginInfo) Result {
	return C.vkBeginCommandBuffer(command_buffer, p_begin_info)
}

fn C.vkEndCommandBuffer(C.VkCommandBuffer) Result

pub type PFN_vkEndCommandBuffer = fn (C.VkCommandBuffer) Result

@[inline]
pub fn end_command_buffer(command_buffer C.VkCommandBuffer) Result {
	return C.vkEndCommandBuffer(command_buffer)
}

fn C.vkResetCommandBuffer(C.VkCommandBuffer, CommandBufferResetFlags) Result

pub type PFN_vkResetCommandBuffer = fn (C.VkCommandBuffer, CommandBufferResetFlags) Result

@[inline]
pub fn reset_command_buffer(command_buffer C.VkCommandBuffer,
	flags CommandBufferResetFlags) Result {
	return C.vkResetCommandBuffer(command_buffer, flags)
}

fn C.vkCmdBindPipeline(C.VkCommandBuffer, PipelineBindPoint, C.VkPipeline)

pub type PFN_vkCmdBindPipeline = fn (C.VkCommandBuffer, PipelineBindPoint, C.VkPipeline)

@[inline]
pub fn cmd_bind_pipeline(command_buffer C.VkCommandBuffer,
	pipeline_bind_point PipelineBindPoint,
	pipeline C.VkPipeline) {
	C.vkCmdBindPipeline(command_buffer, pipeline_bind_point, pipeline)
}

fn C.vkCmdSetViewport(C.VkCommandBuffer, u32, u32, &Viewport)

pub type PFN_vkCmdSetViewport = fn (C.VkCommandBuffer, u32, u32, &Viewport)

@[inline]
pub fn cmd_set_viewport(command_buffer C.VkCommandBuffer,
	first_viewport u32,
	viewport_count u32,
	p_viewports &Viewport) {
	C.vkCmdSetViewport(command_buffer, first_viewport, viewport_count, p_viewports)
}

fn C.vkCmdSetScissor(C.VkCommandBuffer, u32, u32, &Rect2D)

pub type PFN_vkCmdSetScissor = fn (C.VkCommandBuffer, u32, u32, &Rect2D)

@[inline]
pub fn cmd_set_scissor(command_buffer C.VkCommandBuffer,
	first_scissor u32,
	scissor_count u32,
	p_scissors &Rect2D) {
	C.vkCmdSetScissor(command_buffer, first_scissor, scissor_count, p_scissors)
}

fn C.vkCmdSetLineWidth(C.VkCommandBuffer, f32)

pub type PFN_vkCmdSetLineWidth = fn (C.VkCommandBuffer, f32)

@[inline]
pub fn cmd_set_line_width(command_buffer C.VkCommandBuffer,
	line_width f32) {
	C.vkCmdSetLineWidth(command_buffer, line_width)
}

fn C.vkCmdSetDepthBias(C.VkCommandBuffer, f32, f32, f32)

pub type PFN_vkCmdSetDepthBias = fn (C.VkCommandBuffer, f32, f32, f32)

@[inline]
pub fn cmd_set_depth_bias(command_buffer C.VkCommandBuffer,
	depth_bias_constant_factor f32,
	depth_bias_clamp f32,
	depth_bias_slope_factor f32) {
	C.vkCmdSetDepthBias(command_buffer, depth_bias_constant_factor, depth_bias_clamp,
		depth_bias_slope_factor)
}

fn C.vkCmdSetBlendConstants(C.VkCommandBuffer, voidptr)

pub type PFN_vkCmdSetBlendConstants = fn (C.VkCommandBuffer, voidptr)

@[inline]
pub fn cmd_set_blend_constants(command_buffer C.VkCommandBuffer,
	blend_constants [4]f32) {
	C.vkCmdSetBlendConstants(command_buffer, blend_constants)
}

fn C.vkCmdSetDepthBounds(C.VkCommandBuffer, f32, f32)

pub type PFN_vkCmdSetDepthBounds = fn (C.VkCommandBuffer, f32, f32)

@[inline]
pub fn cmd_set_depth_bounds(command_buffer C.VkCommandBuffer,
	min_depth_bounds f32,
	max_depth_bounds f32) {
	C.vkCmdSetDepthBounds(command_buffer, min_depth_bounds, max_depth_bounds)
}

fn C.vkCmdSetStencilCompareMask(C.VkCommandBuffer, StencilFaceFlags, u32)

pub type PFN_vkCmdSetStencilCompareMask = fn (C.VkCommandBuffer, StencilFaceFlags, u32)

@[inline]
pub fn cmd_set_stencil_compare_mask(command_buffer C.VkCommandBuffer,
	face_mask StencilFaceFlags,
	compare_mask u32) {
	C.vkCmdSetStencilCompareMask(command_buffer, face_mask, compare_mask)
}

fn C.vkCmdSetStencilWriteMask(C.VkCommandBuffer, StencilFaceFlags, u32)

pub type PFN_vkCmdSetStencilWriteMask = fn (C.VkCommandBuffer, StencilFaceFlags, u32)

@[inline]
pub fn cmd_set_stencil_write_mask(command_buffer C.VkCommandBuffer,
	face_mask StencilFaceFlags,
	write_mask u32) {
	C.vkCmdSetStencilWriteMask(command_buffer, face_mask, write_mask)
}

fn C.vkCmdSetStencilReference(C.VkCommandBuffer, StencilFaceFlags, u32)

pub type PFN_vkCmdSetStencilReference = fn (C.VkCommandBuffer, StencilFaceFlags, u32)

@[inline]
pub fn cmd_set_stencil_reference(command_buffer C.VkCommandBuffer,
	face_mask StencilFaceFlags,
	reference u32) {
	C.vkCmdSetStencilReference(command_buffer, face_mask, reference)
}

fn C.vkCmdBindDescriptorSets(C.VkCommandBuffer, PipelineBindPoint, C.VkPipelineLayout, u32, u32, C.VkDescriptorSet, u32, &u32)

pub type PFN_vkCmdBindDescriptorSets = fn (C.VkCommandBuffer, PipelineBindPoint, C.VkPipelineLayout, u32, u32, C.VkDescriptorSet, u32, &u32)

@[inline]
pub fn cmd_bind_descriptor_sets(command_buffer C.VkCommandBuffer,
	pipeline_bind_point PipelineBindPoint,
	layout C.VkPipelineLayout,
	first_set u32,
	descriptor_set_count u32,
	p_descriptor_sets C.VkDescriptorSet,
	dynamic_offset_count u32,
	p_dynamic_offsets &u32) {
	C.vkCmdBindDescriptorSets(command_buffer, pipeline_bind_point, layout, first_set,
		descriptor_set_count, p_descriptor_sets, dynamic_offset_count, p_dynamic_offsets)
}

fn C.vkCmdBindIndexBuffer(C.VkCommandBuffer, C.VkBuffer, DeviceSize, IndexType)

pub type PFN_vkCmdBindIndexBuffer = fn (C.VkCommandBuffer, C.VkBuffer, DeviceSize, IndexType)

@[inline]
pub fn cmd_bind_index_buffer(command_buffer C.VkCommandBuffer,
	buffer C.VkBuffer,
	offset DeviceSize,
	index_type IndexType) {
	C.vkCmdBindIndexBuffer(command_buffer, buffer, offset, index_type)
}

fn C.vkCmdBindVertexBuffers(C.VkCommandBuffer, u32, u32, C.VkBuffer, &DeviceSize)

pub type PFN_vkCmdBindVertexBuffers = fn (C.VkCommandBuffer, u32, u32, C.VkBuffer, &DeviceSize)

@[inline]
pub fn cmd_bind_vertex_buffers(command_buffer C.VkCommandBuffer,
	first_binding u32,
	binding_count u32,
	p_buffers C.VkBuffer,
	p_offsets &DeviceSize) {
	C.vkCmdBindVertexBuffers(command_buffer, first_binding, binding_count, p_buffers,
		p_offsets)
}

fn C.vkCmdDraw(C.VkCommandBuffer, u32, u32, u32, u32)

pub type PFN_vkCmdDraw = fn (C.VkCommandBuffer, u32, u32, u32, u32)

@[inline]
pub fn cmd_draw(command_buffer C.VkCommandBuffer,
	vertex_count u32,
	instance_count u32,
	first_vertex u32,
	first_instance u32) {
	C.vkCmdDraw(command_buffer, vertex_count, instance_count, first_vertex, first_instance)
}

fn C.vkCmdDrawIndexed(C.VkCommandBuffer, u32, u32, u32, i32, u32)

pub type PFN_vkCmdDrawIndexed = fn (C.VkCommandBuffer, u32, u32, u32, i32, u32)

@[inline]
pub fn cmd_draw_indexed(command_buffer C.VkCommandBuffer,
	index_count u32,
	instance_count u32,
	first_index u32,
	vertex_offset i32,
	first_instance u32) {
	C.vkCmdDrawIndexed(command_buffer, index_count, instance_count, first_index, vertex_offset,
		first_instance)
}

fn C.vkCmdDrawIndirect(C.VkCommandBuffer, C.VkBuffer, DeviceSize, u32, u32)

pub type PFN_vkCmdDrawIndirect = fn (C.VkCommandBuffer, C.VkBuffer, DeviceSize, u32, u32)

@[inline]
pub fn cmd_draw_indirect(command_buffer C.VkCommandBuffer,
	buffer C.VkBuffer,
	offset DeviceSize,
	draw_count u32,
	stride u32) {
	C.vkCmdDrawIndirect(command_buffer, buffer, offset, draw_count, stride)
}

fn C.vkCmdDrawIndexedIndirect(C.VkCommandBuffer, C.VkBuffer, DeviceSize, u32, u32)

pub type PFN_vkCmdDrawIndexedIndirect = fn (C.VkCommandBuffer, C.VkBuffer, DeviceSize, u32, u32)

@[inline]
pub fn cmd_draw_indexed_indirect(command_buffer C.VkCommandBuffer,
	buffer C.VkBuffer,
	offset DeviceSize,
	draw_count u32,
	stride u32) {
	C.vkCmdDrawIndexedIndirect(command_buffer, buffer, offset, draw_count, stride)
}

fn C.vkCmdDispatch(C.VkCommandBuffer, u32, u32, u32)

pub type PFN_vkCmdDispatch = fn (C.VkCommandBuffer, u32, u32, u32)

@[inline]
pub fn cmd_dispatch(command_buffer C.VkCommandBuffer,
	group_count_x u32,
	group_count_y u32,
	group_count_z u32) {
	C.vkCmdDispatch(command_buffer, group_count_x, group_count_y, group_count_z)
}

fn C.vkCmdDispatchIndirect(C.VkCommandBuffer, C.VkBuffer, DeviceSize)

pub type PFN_vkCmdDispatchIndirect = fn (C.VkCommandBuffer, C.VkBuffer, DeviceSize)

@[inline]
pub fn cmd_dispatch_indirect(command_buffer C.VkCommandBuffer,
	buffer C.VkBuffer,
	offset DeviceSize) {
	C.vkCmdDispatchIndirect(command_buffer, buffer, offset)
}

fn C.vkCmdCopyBuffer(C.VkCommandBuffer, C.VkBuffer, C.VkBuffer, u32, &BufferCopy)

pub type PFN_vkCmdCopyBuffer = fn (C.VkCommandBuffer, C.VkBuffer, C.VkBuffer, u32, &BufferCopy)

@[inline]
pub fn cmd_copy_buffer(command_buffer C.VkCommandBuffer,
	src_buffer C.VkBuffer,
	dst_buffer C.VkBuffer,
	region_count u32,
	p_regions &BufferCopy) {
	C.vkCmdCopyBuffer(command_buffer, src_buffer, dst_buffer, region_count, p_regions)
}

fn C.vkCmdCopyImage(C.VkCommandBuffer, C.VkImage, ImageLayout, C.VkImage, ImageLayout, u32, &ImageCopy)

pub type PFN_vkCmdCopyImage = fn (C.VkCommandBuffer, C.VkImage, ImageLayout, C.VkImage, ImageLayout, u32, &ImageCopy)

@[inline]
pub fn cmd_copy_image(command_buffer C.VkCommandBuffer,
	src_image C.VkImage,
	src_image_layout ImageLayout,
	dst_image C.VkImage,
	dst_image_layout ImageLayout,
	region_count u32,
	p_regions &ImageCopy) {
	C.vkCmdCopyImage(command_buffer, src_image, src_image_layout, dst_image, dst_image_layout,
		region_count, p_regions)
}

fn C.vkCmdBlitImage(C.VkCommandBuffer, C.VkImage, ImageLayout, C.VkImage, ImageLayout, u32, &ImageBlit, Filter)

pub type PFN_vkCmdBlitImage = fn (C.VkCommandBuffer, C.VkImage, ImageLayout, C.VkImage, ImageLayout, u32, &ImageBlit, Filter)

@[inline]
pub fn cmd_blit_image(command_buffer C.VkCommandBuffer,
	src_image C.VkImage,
	src_image_layout ImageLayout,
	dst_image C.VkImage,
	dst_image_layout ImageLayout,
	region_count u32,
	p_regions &ImageBlit,
	filter Filter) {
	C.vkCmdBlitImage(command_buffer, src_image, src_image_layout, dst_image, dst_image_layout,
		region_count, p_regions, filter)
}

fn C.vkCmdCopyBufferToImage(C.VkCommandBuffer, C.VkBuffer, C.VkImage, ImageLayout, u32, &BufferImageCopy)

pub type PFN_vkCmdCopyBufferToImage = fn (C.VkCommandBuffer, C.VkBuffer, C.VkImage, ImageLayout, u32, &BufferImageCopy)

@[inline]
pub fn cmd_copy_buffer_to_image(command_buffer C.VkCommandBuffer,
	src_buffer C.VkBuffer,
	dst_image C.VkImage,
	dst_image_layout ImageLayout,
	region_count u32,
	p_regions &BufferImageCopy) {
	C.vkCmdCopyBufferToImage(command_buffer, src_buffer, dst_image, dst_image_layout,
		region_count, p_regions)
}

fn C.vkCmdCopyImageToBuffer(C.VkCommandBuffer, C.VkImage, ImageLayout, C.VkBuffer, u32, &BufferImageCopy)

pub type PFN_vkCmdCopyImageToBuffer = fn (C.VkCommandBuffer, C.VkImage, ImageLayout, C.VkBuffer, u32, &BufferImageCopy)

@[inline]
pub fn cmd_copy_image_to_buffer(command_buffer C.VkCommandBuffer,
	src_image C.VkImage,
	src_image_layout ImageLayout,
	dst_buffer C.VkBuffer,
	region_count u32,
	p_regions &BufferImageCopy) {
	C.vkCmdCopyImageToBuffer(command_buffer, src_image, src_image_layout, dst_buffer,
		region_count, p_regions)
}

fn C.vkCmdUpdateBuffer(C.VkCommandBuffer, C.VkBuffer, DeviceSize, DeviceSize, voidptr)

pub type PFN_vkCmdUpdateBuffer = fn (C.VkCommandBuffer, C.VkBuffer, DeviceSize, DeviceSize, voidptr)

@[inline]
pub fn cmd_update_buffer(command_buffer C.VkCommandBuffer,
	dst_buffer C.VkBuffer,
	dst_offset DeviceSize,
	data_size DeviceSize,
	p_data voidptr) {
	C.vkCmdUpdateBuffer(command_buffer, dst_buffer, dst_offset, data_size, p_data)
}

fn C.vkCmdFillBuffer(C.VkCommandBuffer, C.VkBuffer, DeviceSize, DeviceSize, u32)

pub type PFN_vkCmdFillBuffer = fn (C.VkCommandBuffer, C.VkBuffer, DeviceSize, DeviceSize, u32)

@[inline]
pub fn cmd_fill_buffer(command_buffer C.VkCommandBuffer,
	dst_buffer C.VkBuffer,
	dst_offset DeviceSize,
	size DeviceSize,
	data u32) {
	C.vkCmdFillBuffer(command_buffer, dst_buffer, dst_offset, size, data)
}

fn C.vkCmdClearColorImage(C.VkCommandBuffer, C.VkImage, ImageLayout, &ClearColorValue, u32, &ImageSubresourceRange)

pub type PFN_vkCmdClearColorImage = fn (C.VkCommandBuffer, C.VkImage, ImageLayout, &ClearColorValue, u32, &ImageSubresourceRange)

@[inline]
pub fn cmd_clear_color_image(command_buffer C.VkCommandBuffer,
	image C.VkImage,
	image_layout ImageLayout,
	p_color &ClearColorValue,
	range_count u32,
	p_ranges &ImageSubresourceRange) {
	C.vkCmdClearColorImage(command_buffer, image, image_layout, p_color, range_count,
		p_ranges)
}

fn C.vkCmdClearDepthStencilImage(C.VkCommandBuffer, C.VkImage, ImageLayout, &ClearDepthStencilValue, u32, &ImageSubresourceRange)

pub type PFN_vkCmdClearDepthStencilImage = fn (C.VkCommandBuffer, C.VkImage, ImageLayout, &ClearDepthStencilValue, u32, &ImageSubresourceRange)

@[inline]
pub fn cmd_clear_depth_stencil_image(command_buffer C.VkCommandBuffer,
	image C.VkImage,
	image_layout ImageLayout,
	p_depth_stencil &ClearDepthStencilValue,
	range_count u32,
	p_ranges &ImageSubresourceRange) {
	C.vkCmdClearDepthStencilImage(command_buffer, image, image_layout, p_depth_stencil,
		range_count, p_ranges)
}

fn C.vkCmdClearAttachments(C.VkCommandBuffer, u32, &ClearAttachment, u32, &ClearRect)

pub type PFN_vkCmdClearAttachments = fn (C.VkCommandBuffer, u32, &ClearAttachment, u32, &ClearRect)

@[inline]
pub fn cmd_clear_attachments(command_buffer C.VkCommandBuffer,
	attachment_count u32,
	p_attachments &ClearAttachment,
	rect_count u32,
	p_rects &ClearRect) {
	C.vkCmdClearAttachments(command_buffer, attachment_count, p_attachments, rect_count,
		p_rects)
}

fn C.vkCmdResolveImage(C.VkCommandBuffer, C.VkImage, ImageLayout, C.VkImage, ImageLayout, u32, &ImageResolve)

pub type PFN_vkCmdResolveImage = fn (C.VkCommandBuffer, C.VkImage, ImageLayout, C.VkImage, ImageLayout, u32, &ImageResolve)

@[inline]
pub fn cmd_resolve_image(command_buffer C.VkCommandBuffer,
	src_image C.VkImage,
	src_image_layout ImageLayout,
	dst_image C.VkImage,
	dst_image_layout ImageLayout,
	region_count u32,
	p_regions &ImageResolve) {
	C.vkCmdResolveImage(command_buffer, src_image, src_image_layout, dst_image, dst_image_layout,
		region_count, p_regions)
}

fn C.vkCmdSetEvent(C.VkCommandBuffer, C.VkEvent, PipelineStageFlags)

pub type PFN_vkCmdSetEvent = fn (C.VkCommandBuffer, C.VkEvent, PipelineStageFlags)

@[inline]
pub fn cmd_set_event(command_buffer C.VkCommandBuffer,
	event C.VkEvent,
	stage_mask PipelineStageFlags) {
	C.vkCmdSetEvent(command_buffer, event, stage_mask)
}

fn C.vkCmdResetEvent(C.VkCommandBuffer, C.VkEvent, PipelineStageFlags)

pub type PFN_vkCmdResetEvent = fn (C.VkCommandBuffer, C.VkEvent, PipelineStageFlags)

@[inline]
pub fn cmd_reset_event(command_buffer C.VkCommandBuffer,
	event C.VkEvent,
	stage_mask PipelineStageFlags) {
	C.vkCmdResetEvent(command_buffer, event, stage_mask)
}

fn C.vkCmdWaitEvents(C.VkCommandBuffer, u32, C.VkEvent, PipelineStageFlags, PipelineStageFlags, u32, &MemoryBarrier, u32, &BufferMemoryBarrier, u32, &ImageMemoryBarrier)

pub type PFN_vkCmdWaitEvents = fn (C.VkCommandBuffer, u32, C.VkEvent, PipelineStageFlags, PipelineStageFlags, u32, &MemoryBarrier, u32, &BufferMemoryBarrier, u32, &ImageMemoryBarrier)

@[inline]
pub fn cmd_wait_events(command_buffer C.VkCommandBuffer,
	event_count u32,
	p_events C.VkEvent,
	src_stage_mask PipelineStageFlags,
	dst_stage_mask PipelineStageFlags,
	memory_barrier_count u32,
	p_memory_barriers &MemoryBarrier,
	buffer_memory_barrier_count u32,
	p_buffer_memory_barriers &BufferMemoryBarrier,
	image_memory_barrier_count u32,
	p_image_memory_barriers &ImageMemoryBarrier) {
	C.vkCmdWaitEvents(command_buffer, event_count, p_events, src_stage_mask, dst_stage_mask,
		memory_barrier_count, p_memory_barriers, buffer_memory_barrier_count, p_buffer_memory_barriers,
		image_memory_barrier_count, p_image_memory_barriers)
}

fn C.vkCmdPipelineBarrier(C.VkCommandBuffer, PipelineStageFlags, PipelineStageFlags, DependencyFlags, u32, &MemoryBarrier, u32, &BufferMemoryBarrier, u32, &ImageMemoryBarrier)

pub type PFN_vkCmdPipelineBarrier = fn (C.VkCommandBuffer, PipelineStageFlags, PipelineStageFlags, DependencyFlags, u32, &MemoryBarrier, u32, &BufferMemoryBarrier, u32, &ImageMemoryBarrier)

@[inline]
pub fn cmd_pipeline_barrier(command_buffer C.VkCommandBuffer,
	src_stage_mask PipelineStageFlags,
	dst_stage_mask PipelineStageFlags,
	dependency_flags DependencyFlags,
	memory_barrier_count u32,
	p_memory_barriers &MemoryBarrier,
	buffer_memory_barrier_count u32,
	p_buffer_memory_barriers &BufferMemoryBarrier,
	image_memory_barrier_count u32,
	p_image_memory_barriers &ImageMemoryBarrier) {
	C.vkCmdPipelineBarrier(command_buffer, src_stage_mask, dst_stage_mask, dependency_flags,
		memory_barrier_count, p_memory_barriers, buffer_memory_barrier_count, p_buffer_memory_barriers,
		image_memory_barrier_count, p_image_memory_barriers)
}

fn C.vkCmdBeginQuery(C.VkCommandBuffer, C.VkQueryPool, u32, QueryControlFlags)

pub type PFN_vkCmdBeginQuery = fn (C.VkCommandBuffer, C.VkQueryPool, u32, QueryControlFlags)

@[inline]
pub fn cmd_begin_query(command_buffer C.VkCommandBuffer,
	query_pool C.VkQueryPool,
	query u32,
	flags QueryControlFlags) {
	C.vkCmdBeginQuery(command_buffer, query_pool, query, flags)
}

fn C.vkCmdEndQuery(C.VkCommandBuffer, C.VkQueryPool, u32)

pub type PFN_vkCmdEndQuery = fn (C.VkCommandBuffer, C.VkQueryPool, u32)

@[inline]
pub fn cmd_end_query(command_buffer C.VkCommandBuffer,
	query_pool C.VkQueryPool,
	query u32) {
	C.vkCmdEndQuery(command_buffer, query_pool, query)
}

fn C.vkCmdResetQueryPool(C.VkCommandBuffer, C.VkQueryPool, u32, u32)

pub type PFN_vkCmdResetQueryPool = fn (C.VkCommandBuffer, C.VkQueryPool, u32, u32)

@[inline]
pub fn cmd_reset_query_pool(command_buffer C.VkCommandBuffer,
	query_pool C.VkQueryPool,
	first_query u32,
	query_count u32) {
	C.vkCmdResetQueryPool(command_buffer, query_pool, first_query, query_count)
}

fn C.vkCmdWriteTimestamp(C.VkCommandBuffer, PipelineStageFlagBits, C.VkQueryPool, u32)

pub type PFN_vkCmdWriteTimestamp = fn (C.VkCommandBuffer, PipelineStageFlagBits, C.VkQueryPool, u32)

@[inline]
pub fn cmd_write_timestamp(command_buffer C.VkCommandBuffer,
	pipeline_stage PipelineStageFlagBits,
	query_pool C.VkQueryPool,
	query u32) {
	C.vkCmdWriteTimestamp(command_buffer, pipeline_stage, query_pool, query)
}

fn C.vkCmdCopyQueryPoolResults(C.VkCommandBuffer, C.VkQueryPool, u32, u32, C.VkBuffer, DeviceSize, DeviceSize, QueryResultFlags)

pub type PFN_vkCmdCopyQueryPoolResults = fn (C.VkCommandBuffer, C.VkQueryPool, u32, u32, C.VkBuffer, DeviceSize, DeviceSize, QueryResultFlags)

@[inline]
pub fn cmd_copy_query_pool_results(command_buffer C.VkCommandBuffer,
	query_pool C.VkQueryPool,
	first_query u32,
	query_count u32,
	dst_buffer C.VkBuffer,
	dst_offset DeviceSize,
	stride DeviceSize,
	flags QueryResultFlags) {
	C.vkCmdCopyQueryPoolResults(command_buffer, query_pool, first_query, query_count,
		dst_buffer, dst_offset, stride, flags)
}

fn C.vkCmdPushConstants(C.VkCommandBuffer, C.VkPipelineLayout, ShaderStageFlags, u32, u32, voidptr)

pub type PFN_vkCmdPushConstants = fn (C.VkCommandBuffer, C.VkPipelineLayout, ShaderStageFlags, u32, u32, voidptr)

@[inline]
pub fn cmd_push_constants(command_buffer C.VkCommandBuffer,
	layout C.VkPipelineLayout,
	stage_flags ShaderStageFlags,
	offset u32,
	size u32,
	p_values voidptr) {
	C.vkCmdPushConstants(command_buffer, layout, stage_flags, offset, size, p_values)
}

fn C.vkCmdBeginRenderPass(C.VkCommandBuffer, &RenderPassBeginInfo, SubpassContents)

pub type PFN_vkCmdBeginRenderPass = fn (C.VkCommandBuffer, &RenderPassBeginInfo, SubpassContents)

@[inline]
pub fn cmd_begin_render_pass(command_buffer C.VkCommandBuffer,
	p_render_pass_begin &RenderPassBeginInfo,
	contents SubpassContents) {
	C.vkCmdBeginRenderPass(command_buffer, p_render_pass_begin, contents)
}

fn C.vkCmdNextSubpass(C.VkCommandBuffer, SubpassContents)

pub type PFN_vkCmdNextSubpass = fn (C.VkCommandBuffer, SubpassContents)

@[inline]
pub fn cmd_next_subpass(command_buffer C.VkCommandBuffer,
	contents SubpassContents) {
	C.vkCmdNextSubpass(command_buffer, contents)
}

fn C.vkCmdEndRenderPass(C.VkCommandBuffer)

pub type PFN_vkCmdEndRenderPass = fn (C.VkCommandBuffer)

@[inline]
pub fn cmd_end_render_pass(command_buffer C.VkCommandBuffer) {
	C.vkCmdEndRenderPass(command_buffer)
}

fn C.vkCmdExecuteCommands(C.VkCommandBuffer, u32, C.VkCommandBuffer)

pub type PFN_vkCmdExecuteCommands = fn (C.VkCommandBuffer, u32, C.VkCommandBuffer)

@[inline]
pub fn cmd_execute_commands(command_buffer C.VkCommandBuffer,
	command_buffer_count u32,
	p_command_buffers C.VkCommandBuffer) {
	C.vkCmdExecuteCommands(command_buffer, command_buffer_count, p_command_buffers)
}

// Vulkan 1.1 version number
pub const api_version_1_1 = make_api_version(0, 1, 1, 0) // Patch version should always be set to 0

pub type C.VkSamplerYcbcrConversion = voidptr
pub type C.VkDescriptorUpdateTemplate = voidptr

pub const max_device_group_size = u32(32)
pub const luid_size = u32(8)
pub const queue_family_external = ~u32(1)

pub enum PointClippingBehavior {
	all_clip_planes       = 0
	user_clip_planes_only = 1
	max_enum              = max_int
}

pub enum TessellationDomainOrigin {
	upper_left = 0
	lower_left = 1
	max_enum   = max_int
}

pub enum SamplerYcbcrModelConversion {
	rgb_identity   = 0
	ycbcr_identity = 1
	ycbcr709       = 2
	ycbcr601       = 3
	ycbcr2020      = 4
	max_enum       = max_int
}

pub enum SamplerYcbcrRange {
	itu_full   = 0
	itu_narrow = 1
	max_enum   = max_int
}

pub enum ChromaLocation {
	cosited_even = 0
	midpoint     = 1
	max_enum     = max_int
}

pub enum DescriptorUpdateTemplateType {
	descriptor_set       = 0
	push_descriptors_khr = 1
	max_enum             = max_int
}

pub enum SubgroupFeatureFlagBits {
	basic_bit            = int(0x00000001)
	vote_bit             = int(0x00000002)
	arithmetic_bit       = int(0x00000004)
	ballot_bit           = int(0x00000008)
	shuffle_bit          = int(0x00000010)
	shuffle_relative_bit = int(0x00000020)
	clustered_bit        = int(0x00000040)
	quad_bit             = int(0x00000080)
	partitioned_bit_nv   = int(0x00000100)
	max_enum             = max_int
}

pub type SubgroupFeatureFlags = u32

pub enum PeerMemoryFeatureFlagBits {
	copy_src_bit    = int(0x00000001)
	copy_dst_bit    = int(0x00000002)
	generic_src_bit = int(0x00000004)
	generic_dst_bit = int(0x00000008)
	max_enum        = max_int
}

pub type PeerMemoryFeatureFlags = u32

pub enum MemoryAllocateFlagBits {
	device_mask_bit                   = int(0x00000001)
	device_address_bit                = int(0x00000002)
	device_address_capture_replay_bit = int(0x00000004)
	max_enum                          = max_int
}

pub type MemoryAllocateFlags = u32
pub type CommandPoolTrimFlags = u32
pub type DescriptorUpdateTemplateCreateFlags = u32

pub enum ExternalMemoryHandleTypeFlagBits {
	opaque_fd_bit                       = int(0x00000001)
	opaque_win32_bit                    = int(0x00000002)
	opaque_win32_kmt_bit                = int(0x00000004)
	d3d11_texture_bit                   = int(0x00000008)
	d3d11_texture_kmt_bit               = int(0x00000010)
	d3d12_heap_bit                      = int(0x00000020)
	d3d12_resource_bit                  = int(0x00000040)
	dma_buf_bit_ext                     = int(0x00000200)
	android_hardware_buffer_bit_android = int(0x00000400)
	host_allocation_bit_ext             = int(0x00000080)
	host_mapped_foreign_memory_bit_ext  = int(0x00000100)
	zircon_vmo_bit_fuchsia              = int(0x00000800)
	rdma_address_bit_nv                 = int(0x00001000)
	screen_buffer_bit_qnx               = int(0x00004000)
	max_enum                            = max_int
}

pub type ExternalMemoryHandleTypeFlags = u32

pub enum ExternalMemoryFeatureFlagBits {
	dedicated_only_bit = int(0x00000001)
	exportable_bit     = int(0x00000002)
	importable_bit     = int(0x00000004)
	max_enum           = max_int
}

pub type ExternalMemoryFeatureFlags = u32

pub enum ExternalFenceHandleTypeFlagBits {
	opaque_fd_bit        = int(0x00000001)
	opaque_win32_bit     = int(0x00000002)
	opaque_win32_kmt_bit = int(0x00000004)
	sync_fd_bit          = int(0x00000008)
	max_enum             = max_int
}

pub type ExternalFenceHandleTypeFlags = u32

pub enum ExternalFenceFeatureFlagBits {
	exportable_bit = int(0x00000001)
	importable_bit = int(0x00000002)
	max_enum       = max_int
}

pub type ExternalFenceFeatureFlags = u32

pub enum FenceImportFlagBits {
	temporary_bit = int(0x00000001)
	max_enum      = max_int
}

pub type FenceImportFlags = u32

pub enum SemaphoreImportFlagBits {
	temporary_bit = int(0x00000001)
	max_enum      = max_int
}

pub type SemaphoreImportFlags = u32

pub enum ExternalSemaphoreHandleTypeFlagBits {
	opaque_fd_bit            = int(0x00000001)
	opaque_win32_bit         = int(0x00000002)
	opaque_win32_kmt_bit     = int(0x00000004)
	d3d12_fence_bit          = int(0x00000008)
	sync_fd_bit              = int(0x00000010)
	zircon_event_bit_fuchsia = int(0x00000080)
	max_enum                 = max_int
}

pub type ExternalSemaphoreHandleTypeFlags = u32

pub enum ExternalSemaphoreFeatureFlagBits {
	exportable_bit = int(0x00000001)
	importable_bit = int(0x00000002)
	max_enum       = max_int
}

pub type ExternalSemaphoreFeatureFlags = u32
pub type PhysicalDeviceSubgroupProperties = C.VkPhysicalDeviceSubgroupProperties

@[typedef]
pub struct C.VkPhysicalDeviceSubgroupProperties {
pub mut:
	sType                     StructureType = StructureType.physical_device_subgroup_properties
	pNext                     voidptr       = unsafe { nil }
	subgroupSize              u32
	supportedStages           ShaderStageFlags
	supportedOperations       SubgroupFeatureFlags
	quadOperationsInAllStages Bool32
}

pub type BindBufferMemoryInfo = C.VkBindBufferMemoryInfo

@[typedef]
pub struct C.VkBindBufferMemoryInfo {
pub mut:
	sType        StructureType = StructureType.bind_buffer_memory_info
	pNext        voidptr       = unsafe { nil }
	buffer       C.VkBuffer
	memory       C.VkDeviceMemory
	memoryOffset DeviceSize
}

pub type BindImageMemoryInfo = C.VkBindImageMemoryInfo

@[typedef]
pub struct C.VkBindImageMemoryInfo {
pub mut:
	sType        StructureType = StructureType.bind_image_memory_info
	pNext        voidptr       = unsafe { nil }
	image        C.VkImage
	memory       C.VkDeviceMemory
	memoryOffset DeviceSize
}

pub type PhysicalDevice16BitStorageFeatures = C.VkPhysicalDevice16BitStorageFeatures

@[typedef]
pub struct C.VkPhysicalDevice16BitStorageFeatures {
pub mut:
	sType                              StructureType
	pNext                              voidptr = unsafe { nil }
	storageBuffer16BitAccess           Bool32
	uniformAndStorageBuffer16BitAccess Bool32
	storagePushConstant16              Bool32
	storageInputOutput16               Bool32
}

pub type MemoryDedicatedRequirements = C.VkMemoryDedicatedRequirements

@[typedef]
pub struct C.VkMemoryDedicatedRequirements {
pub mut:
	sType                       StructureType = StructureType.memory_dedicated_requirements
	pNext                       voidptr       = unsafe { nil }
	prefersDedicatedAllocation  Bool32
	requiresDedicatedAllocation Bool32
}

pub type MemoryDedicatedAllocateInfo = C.VkMemoryDedicatedAllocateInfo

@[typedef]
pub struct C.VkMemoryDedicatedAllocateInfo {
pub mut:
	sType  StructureType = StructureType.memory_dedicated_allocate_info
	pNext  voidptr       = unsafe { nil }
	image  C.VkImage
	buffer C.VkBuffer
}

pub type MemoryAllocateFlagsInfo = C.VkMemoryAllocateFlagsInfo

@[typedef]
pub struct C.VkMemoryAllocateFlagsInfo {
pub mut:
	sType      StructureType = StructureType.memory_allocate_flags_info
	pNext      voidptr       = unsafe { nil }
	flags      MemoryAllocateFlags
	deviceMask u32
}

pub type DeviceGroupRenderPassBeginInfo = C.VkDeviceGroupRenderPassBeginInfo

@[typedef]
pub struct C.VkDeviceGroupRenderPassBeginInfo {
pub mut:
	sType                 StructureType = StructureType.device_group_render_pass_begin_info
	pNext                 voidptr       = unsafe { nil }
	deviceMask            u32
	deviceRenderAreaCount u32
	pDeviceRenderAreas    &Rect2D
}

pub type DeviceGroupCommandBufferBeginInfo = C.VkDeviceGroupCommandBufferBeginInfo

@[typedef]
pub struct C.VkDeviceGroupCommandBufferBeginInfo {
pub mut:
	sType      StructureType = StructureType.device_group_command_buffer_begin_info
	pNext      voidptr       = unsafe { nil }
	deviceMask u32
}

pub type DeviceGroupSubmitInfo = C.VkDeviceGroupSubmitInfo

@[typedef]
pub struct C.VkDeviceGroupSubmitInfo {
pub mut:
	sType                         StructureType = StructureType.device_group_submit_info
	pNext                         voidptr       = unsafe { nil }
	waitSemaphoreCount            u32
	pWaitSemaphoreDeviceIndices   &u32
	commandBufferCount            u32
	pCommandBufferDeviceMasks     &u32
	signalSemaphoreCount          u32
	pSignalSemaphoreDeviceIndices &u32
}

pub type DeviceGroupBindSparseInfo = C.VkDeviceGroupBindSparseInfo

@[typedef]
pub struct C.VkDeviceGroupBindSparseInfo {
pub mut:
	sType               StructureType = StructureType.device_group_bind_sparse_info
	pNext               voidptr       = unsafe { nil }
	resourceDeviceIndex u32
	memoryDeviceIndex   u32
}

pub type BindBufferMemoryDeviceGroupInfo = C.VkBindBufferMemoryDeviceGroupInfo

@[typedef]
pub struct C.VkBindBufferMemoryDeviceGroupInfo {
pub mut:
	sType            StructureType = StructureType.bind_buffer_memory_device_group_info
	pNext            voidptr       = unsafe { nil }
	deviceIndexCount u32
	pDeviceIndices   &u32
}

pub type BindImageMemoryDeviceGroupInfo = C.VkBindImageMemoryDeviceGroupInfo

@[typedef]
pub struct C.VkBindImageMemoryDeviceGroupInfo {
pub mut:
	sType                        StructureType = StructureType.bind_image_memory_device_group_info
	pNext                        voidptr       = unsafe { nil }
	deviceIndexCount             u32
	pDeviceIndices               &u32
	splitInstanceBindRegionCount u32
	pSplitInstanceBindRegions    &Rect2D
}

pub type PhysicalDeviceGroupProperties = C.VkPhysicalDeviceGroupProperties

@[typedef]
pub struct C.VkPhysicalDeviceGroupProperties {
pub mut:
	sType               StructureType = StructureType.physical_device_group_properties
	pNext               voidptr       = unsafe { nil }
	physicalDeviceCount u32
	physicalDevices     [max_device_group_size]C.VkPhysicalDevice
	subsetAllocation    Bool32
}

pub type DeviceGroupDeviceCreateInfo = C.VkDeviceGroupDeviceCreateInfo

@[typedef]
pub struct C.VkDeviceGroupDeviceCreateInfo {
pub mut:
	sType               StructureType = StructureType.device_group_device_create_info
	pNext               voidptr       = unsafe { nil }
	physicalDeviceCount u32
	pPhysicalDevices    C.VkPhysicalDevice
}

pub type BufferMemoryRequirementsInfo2 = C.VkBufferMemoryRequirementsInfo2

@[typedef]
pub struct C.VkBufferMemoryRequirementsInfo2 {
pub mut:
	sType  StructureType = StructureType.buffer_memory_requirements_info2
	pNext  voidptr       = unsafe { nil }
	buffer C.VkBuffer
}

pub type ImageMemoryRequirementsInfo2 = C.VkImageMemoryRequirementsInfo2

@[typedef]
pub struct C.VkImageMemoryRequirementsInfo2 {
pub mut:
	sType StructureType = StructureType.image_memory_requirements_info2
	pNext voidptr       = unsafe { nil }
	image C.VkImage
}

pub type ImageSparseMemoryRequirementsInfo2 = C.VkImageSparseMemoryRequirementsInfo2

@[typedef]
pub struct C.VkImageSparseMemoryRequirementsInfo2 {
pub mut:
	sType StructureType = StructureType.image_sparse_memory_requirements_info2
	pNext voidptr       = unsafe { nil }
	image C.VkImage
}

pub type MemoryRequirements2 = C.VkMemoryRequirements2

@[typedef]
pub struct C.VkMemoryRequirements2 {
pub mut:
	sType              StructureType = StructureType.memory_requirements2
	pNext              voidptr       = unsafe { nil }
	memoryRequirements MemoryRequirements
}

pub type SparseImageMemoryRequirements2 = C.VkSparseImageMemoryRequirements2

@[typedef]
pub struct C.VkSparseImageMemoryRequirements2 {
pub mut:
	sType              StructureType = StructureType.sparse_image_memory_requirements2
	pNext              voidptr       = unsafe { nil }
	memoryRequirements SparseImageMemoryRequirements
}

pub type PhysicalDeviceFeatures2 = C.VkPhysicalDeviceFeatures2

@[typedef]
pub struct C.VkPhysicalDeviceFeatures2 {
pub mut:
	sType    StructureType = StructureType.physical_device_features2
	pNext    voidptr       = unsafe { nil }
	features PhysicalDeviceFeatures
}

pub type PhysicalDeviceProperties2 = C.VkPhysicalDeviceProperties2

@[typedef]
pub struct C.VkPhysicalDeviceProperties2 {
pub mut:
	sType      StructureType = StructureType.physical_device_properties2
	pNext      voidptr       = unsafe { nil }
	properties PhysicalDeviceProperties
}

pub type FormatProperties2 = C.VkFormatProperties2

@[typedef]
pub struct C.VkFormatProperties2 {
pub mut:
	sType            StructureType = StructureType.format_properties2
	pNext            voidptr       = unsafe { nil }
	formatProperties FormatProperties
}

pub type ImageFormatProperties2 = C.VkImageFormatProperties2

@[typedef]
pub struct C.VkImageFormatProperties2 {
pub mut:
	sType                 StructureType = StructureType.image_format_properties2
	pNext                 voidptr       = unsafe { nil }
	imageFormatProperties ImageFormatProperties
}

pub type PhysicalDeviceImageFormatInfo2 = C.VkPhysicalDeviceImageFormatInfo2

@[typedef]
pub struct C.VkPhysicalDeviceImageFormatInfo2 {
pub mut:
	sType  StructureType = StructureType.physical_device_image_format_info2
	pNext  voidptr       = unsafe { nil }
	format Format
	type   ImageType
	tiling ImageTiling
	usage  ImageUsageFlags
	flags  ImageCreateFlags
}

pub type QueueFamilyProperties2 = C.VkQueueFamilyProperties2

@[typedef]
pub struct C.VkQueueFamilyProperties2 {
pub mut:
	sType                 StructureType = StructureType.queue_family_properties2
	pNext                 voidptr       = unsafe { nil }
	queueFamilyProperties QueueFamilyProperties
}

pub type PhysicalDeviceMemoryProperties2 = C.VkPhysicalDeviceMemoryProperties2

@[typedef]
pub struct C.VkPhysicalDeviceMemoryProperties2 {
pub mut:
	sType            StructureType = StructureType.physical_device_memory_properties2
	pNext            voidptr       = unsafe { nil }
	memoryProperties PhysicalDeviceMemoryProperties
}

pub type SparseImageFormatProperties2 = C.VkSparseImageFormatProperties2

@[typedef]
pub struct C.VkSparseImageFormatProperties2 {
pub mut:
	sType      StructureType = StructureType.sparse_image_format_properties2
	pNext      voidptr       = unsafe { nil }
	properties SparseImageFormatProperties
}

pub type PhysicalDeviceSparseImageFormatInfo2 = C.VkPhysicalDeviceSparseImageFormatInfo2

@[typedef]
pub struct C.VkPhysicalDeviceSparseImageFormatInfo2 {
pub mut:
	sType   StructureType = StructureType.physical_device_sparse_image_format_info2
	pNext   voidptr       = unsafe { nil }
	format  Format
	type    ImageType
	samples SampleCountFlagBits
	usage   ImageUsageFlags
	tiling  ImageTiling
}

pub type PhysicalDevicePointClippingProperties = C.VkPhysicalDevicePointClippingProperties

@[typedef]
pub struct C.VkPhysicalDevicePointClippingProperties {
pub mut:
	sType                 StructureType = StructureType.physical_device_point_clipping_properties
	pNext                 voidptr       = unsafe { nil }
	pointClippingBehavior PointClippingBehavior
}

pub type InputAttachmentAspectReference = C.VkInputAttachmentAspectReference

@[typedef]
pub struct C.VkInputAttachmentAspectReference {
pub mut:
	subpass              u32
	inputAttachmentIndex u32
	aspectMask           ImageAspectFlags
}

pub type RenderPassInputAttachmentAspectCreateInfo = C.VkRenderPassInputAttachmentAspectCreateInfo

@[typedef]
pub struct C.VkRenderPassInputAttachmentAspectCreateInfo {
pub mut:
	sType                StructureType = StructureType.render_pass_input_attachment_aspect_create_info
	pNext                voidptr       = unsafe { nil }
	aspectReferenceCount u32
	pAspectReferences    &InputAttachmentAspectReference
}

pub type ImageViewUsageCreateInfo = C.VkImageViewUsageCreateInfo

@[typedef]
pub struct C.VkImageViewUsageCreateInfo {
pub mut:
	sType StructureType = StructureType.image_view_usage_create_info
	pNext voidptr       = unsafe { nil }
	usage ImageUsageFlags
}

pub type PipelineTessellationDomainOriginStateCreateInfo = C.VkPipelineTessellationDomainOriginStateCreateInfo

@[typedef]
pub struct C.VkPipelineTessellationDomainOriginStateCreateInfo {
pub mut:
	sType        StructureType = StructureType.pipeline_tessellation_domain_origin_state_create_info
	pNext        voidptr       = unsafe { nil }
	domainOrigin TessellationDomainOrigin
}

pub type RenderPassMultiviewCreateInfo = C.VkRenderPassMultiviewCreateInfo

@[typedef]
pub struct C.VkRenderPassMultiviewCreateInfo {
pub mut:
	sType                StructureType = StructureType.render_pass_multiview_create_info
	pNext                voidptr       = unsafe { nil }
	subpassCount         u32
	pViewMasks           &u32
	dependencyCount      u32
	pViewOffsets         &i32
	correlationMaskCount u32
	pCorrelationMasks    &u32
}

pub type PhysicalDeviceMultiviewFeatures = C.VkPhysicalDeviceMultiviewFeatures

@[typedef]
pub struct C.VkPhysicalDeviceMultiviewFeatures {
pub mut:
	sType                       StructureType = StructureType.physical_device_multiview_features
	pNext                       voidptr       = unsafe { nil }
	multiview                   Bool32
	multiviewGeometryShader     Bool32
	multiviewTessellationShader Bool32
}

pub type PhysicalDeviceMultiviewProperties = C.VkPhysicalDeviceMultiviewProperties

@[typedef]
pub struct C.VkPhysicalDeviceMultiviewProperties {
pub mut:
	sType                     StructureType = StructureType.physical_device_multiview_properties
	pNext                     voidptr       = unsafe { nil }
	maxMultiviewViewCount     u32
	maxMultiviewInstanceIndex u32
}

pub type PhysicalDeviceVariablePointersFeatures = C.VkPhysicalDeviceVariablePointersFeatures

@[typedef]
pub struct C.VkPhysicalDeviceVariablePointersFeatures {
pub mut:
	sType                         StructureType = StructureType.physical_device_variable_pointers_features
	pNext                         voidptr       = unsafe { nil }
	variablePointersStorageBuffer Bool32
	variablePointers              Bool32
}

pub type PhysicalDeviceVariablePointerFeatures = C.VkPhysicalDeviceVariablePointersFeatures

pub type PhysicalDeviceProtectedMemoryFeatures = C.VkPhysicalDeviceProtectedMemoryFeatures

@[typedef]
pub struct C.VkPhysicalDeviceProtectedMemoryFeatures {
pub mut:
	sType           StructureType = StructureType.physical_device_protected_memory_features
	pNext           voidptr       = unsafe { nil }
	protectedMemory Bool32
}

pub type PhysicalDeviceProtectedMemoryProperties = C.VkPhysicalDeviceProtectedMemoryProperties

@[typedef]
pub struct C.VkPhysicalDeviceProtectedMemoryProperties {
pub mut:
	sType            StructureType = StructureType.physical_device_protected_memory_properties
	pNext            voidptr       = unsafe { nil }
	protectedNoFault Bool32
}

pub type DeviceQueueInfo2 = C.VkDeviceQueueInfo2

@[typedef]
pub struct C.VkDeviceQueueInfo2 {
pub mut:
	sType            StructureType = StructureType.device_queue_info2
	pNext            voidptr       = unsafe { nil }
	flags            DeviceQueueCreateFlags
	queueFamilyIndex u32
	queueIndex       u32
}

pub type ProtectedSubmitInfo = C.VkProtectedSubmitInfo

@[typedef]
pub struct C.VkProtectedSubmitInfo {
pub mut:
	sType           StructureType = StructureType.protected_submit_info
	pNext           voidptr       = unsafe { nil }
	protectedSubmit Bool32
}

pub type SamplerYcbcrConversionCreateInfo = C.VkSamplerYcbcrConversionCreateInfo

@[typedef]
pub struct C.VkSamplerYcbcrConversionCreateInfo {
pub mut:
	sType                       StructureType = StructureType.sampler_ycbcr_conversion_create_info
	pNext                       voidptr       = unsafe { nil }
	format                      Format
	ycbcrModel                  SamplerYcbcrModelConversion
	ycbcrRange                  SamplerYcbcrRange
	components                  ComponentMapping
	xChromaOffset               ChromaLocation
	yChromaOffset               ChromaLocation
	chromaFilter                Filter
	forceExplicitReconstruction Bool32
}

pub type SamplerYcbcrConversionInfo = C.VkSamplerYcbcrConversionInfo

@[typedef]
pub struct C.VkSamplerYcbcrConversionInfo {
pub mut:
	sType      StructureType = StructureType.sampler_ycbcr_conversion_info
	pNext      voidptr       = unsafe { nil }
	conversion C.VkSamplerYcbcrConversion
}

pub type BindImagePlaneMemoryInfo = C.VkBindImagePlaneMemoryInfo

@[typedef]
pub struct C.VkBindImagePlaneMemoryInfo {
pub mut:
	sType       StructureType = StructureType.bind_image_plane_memory_info
	pNext       voidptr       = unsafe { nil }
	planeAspect ImageAspectFlagBits
}

pub type ImagePlaneMemoryRequirementsInfo = C.VkImagePlaneMemoryRequirementsInfo

@[typedef]
pub struct C.VkImagePlaneMemoryRequirementsInfo {
pub mut:
	sType       StructureType = StructureType.image_plane_memory_requirements_info
	pNext       voidptr       = unsafe { nil }
	planeAspect ImageAspectFlagBits
}

pub type PhysicalDeviceSamplerYcbcrConversionFeatures = C.VkPhysicalDeviceSamplerYcbcrConversionFeatures

@[typedef]
pub struct C.VkPhysicalDeviceSamplerYcbcrConversionFeatures {
pub mut:
	sType                  StructureType = StructureType.physical_device_sampler_ycbcr_conversion_features
	pNext                  voidptr       = unsafe { nil }
	samplerYcbcrConversion Bool32
}

pub type SamplerYcbcrConversionImageFormatProperties = C.VkSamplerYcbcrConversionImageFormatProperties

@[typedef]
pub struct C.VkSamplerYcbcrConversionImageFormatProperties {
pub mut:
	sType                               StructureType = StructureType.sampler_ycbcr_conversion_image_format_properties
	pNext                               voidptr       = unsafe { nil }
	combinedImageSamplerDescriptorCount u32
}

pub type DescriptorUpdateTemplateEntry = C.VkDescriptorUpdateTemplateEntry

@[typedef]
pub struct C.VkDescriptorUpdateTemplateEntry {
pub mut:
	dstBinding      u32
	dstArrayElement u32
	descriptorCount u32
	descriptorType  DescriptorType
	offset          usize
	stride          usize
}

pub type DescriptorUpdateTemplateCreateInfo = C.VkDescriptorUpdateTemplateCreateInfo

@[typedef]
pub struct C.VkDescriptorUpdateTemplateCreateInfo {
pub mut:
	sType                      StructureType = StructureType.descriptor_update_template_create_info
	pNext                      voidptr       = unsafe { nil }
	flags                      DescriptorUpdateTemplateCreateFlags
	descriptorUpdateEntryCount u32
	pDescriptorUpdateEntries   &DescriptorUpdateTemplateEntry
	templateType               DescriptorUpdateTemplateType
	descriptorSetLayout        C.VkDescriptorSetLayout
	pipelineBindPoint          PipelineBindPoint
	pipelineLayout             C.VkPipelineLayout
	set                        u32
}

pub type ExternalMemoryProperties = C.VkExternalMemoryProperties

@[typedef]
pub struct C.VkExternalMemoryProperties {
pub mut:
	externalMemoryFeatures        ExternalMemoryFeatureFlags
	exportFromImportedHandleTypes ExternalMemoryHandleTypeFlags
	compatibleHandleTypes         ExternalMemoryHandleTypeFlags
}

pub type PhysicalDeviceExternalImageFormatInfo = C.VkPhysicalDeviceExternalImageFormatInfo

@[typedef]
pub struct C.VkPhysicalDeviceExternalImageFormatInfo {
pub mut:
	sType      StructureType = StructureType.physical_device_external_image_format_info
	pNext      voidptr       = unsafe { nil }
	handleType ExternalMemoryHandleTypeFlagBits
}

pub type ExternalImageFormatProperties = C.VkExternalImageFormatProperties

@[typedef]
pub struct C.VkExternalImageFormatProperties {
pub mut:
	sType                    StructureType = StructureType.external_image_format_properties
	pNext                    voidptr       = unsafe { nil }
	externalMemoryProperties ExternalMemoryProperties
}

pub type PhysicalDeviceExternalBufferInfo = C.VkPhysicalDeviceExternalBufferInfo

@[typedef]
pub struct C.VkPhysicalDeviceExternalBufferInfo {
pub mut:
	sType      StructureType = StructureType.physical_device_external_buffer_info
	pNext      voidptr       = unsafe { nil }
	flags      BufferCreateFlags
	usage      BufferUsageFlags
	handleType ExternalMemoryHandleTypeFlagBits
}

pub type ExternalBufferProperties = C.VkExternalBufferProperties

@[typedef]
pub struct C.VkExternalBufferProperties {
pub mut:
	sType                    StructureType = StructureType.external_buffer_properties
	pNext                    voidptr       = unsafe { nil }
	externalMemoryProperties ExternalMemoryProperties
}

pub type PhysicalDeviceIDProperties = C.VkPhysicalDeviceIDProperties

@[typedef]
pub struct C.VkPhysicalDeviceIDProperties {
pub mut:
	sType           StructureType = StructureType.physical_device_id_properties
	pNext           voidptr       = unsafe { nil }
	deviceUUID      [uuid_size]u8
	driverUUID      [uuid_size]u8
	deviceLUID      [luid_size]u8
	deviceNodeMask  u32
	deviceLUIDValid Bool32
}

pub type ExternalMemoryImageCreateInfo = C.VkExternalMemoryImageCreateInfo

@[typedef]
pub struct C.VkExternalMemoryImageCreateInfo {
pub mut:
	sType       StructureType = StructureType.external_memory_image_create_info
	pNext       voidptr       = unsafe { nil }
	handleTypes ExternalMemoryHandleTypeFlags
}

pub type ExternalMemoryBufferCreateInfo = C.VkExternalMemoryBufferCreateInfo

@[typedef]
pub struct C.VkExternalMemoryBufferCreateInfo {
pub mut:
	sType       StructureType = StructureType.external_memory_buffer_create_info
	pNext       voidptr       = unsafe { nil }
	handleTypes ExternalMemoryHandleTypeFlags
}

pub type ExportMemoryAllocateInfo = C.VkExportMemoryAllocateInfo

@[typedef]
pub struct C.VkExportMemoryAllocateInfo {
pub mut:
	sType       StructureType = StructureType.export_memory_allocate_info
	pNext       voidptr       = unsafe { nil }
	handleTypes ExternalMemoryHandleTypeFlags
}

pub type PhysicalDeviceExternalFenceInfo = C.VkPhysicalDeviceExternalFenceInfo

@[typedef]
pub struct C.VkPhysicalDeviceExternalFenceInfo {
pub mut:
	sType      StructureType = StructureType.physical_device_external_fence_info
	pNext      voidptr       = unsafe { nil }
	handleType ExternalFenceHandleTypeFlagBits
}

pub type ExternalFenceProperties = C.VkExternalFenceProperties

@[typedef]
pub struct C.VkExternalFenceProperties {
pub mut:
	sType                         StructureType = StructureType.external_fence_properties
	pNext                         voidptr       = unsafe { nil }
	exportFromImportedHandleTypes ExternalFenceHandleTypeFlags
	compatibleHandleTypes         ExternalFenceHandleTypeFlags
	externalFenceFeatures         ExternalFenceFeatureFlags
}

pub type ExportFenceCreateInfo = C.VkExportFenceCreateInfo

@[typedef]
pub struct C.VkExportFenceCreateInfo {
pub mut:
	sType       StructureType = StructureType.export_fence_create_info
	pNext       voidptr       = unsafe { nil }
	handleTypes ExternalFenceHandleTypeFlags
}

pub type ExportSemaphoreCreateInfo = C.VkExportSemaphoreCreateInfo

@[typedef]
pub struct C.VkExportSemaphoreCreateInfo {
pub mut:
	sType       StructureType = StructureType.export_semaphore_create_info
	pNext       voidptr       = unsafe { nil }
	handleTypes ExternalSemaphoreHandleTypeFlags
}

pub type PhysicalDeviceExternalSemaphoreInfo = C.VkPhysicalDeviceExternalSemaphoreInfo

@[typedef]
pub struct C.VkPhysicalDeviceExternalSemaphoreInfo {
pub mut:
	sType      StructureType = StructureType.physical_device_external_semaphore_info
	pNext      voidptr       = unsafe { nil }
	handleType ExternalSemaphoreHandleTypeFlagBits
}

pub type ExternalSemaphoreProperties = C.VkExternalSemaphoreProperties

@[typedef]
pub struct C.VkExternalSemaphoreProperties {
pub mut:
	sType                         StructureType = StructureType.external_semaphore_properties
	pNext                         voidptr       = unsafe { nil }
	exportFromImportedHandleTypes ExternalSemaphoreHandleTypeFlags
	compatibleHandleTypes         ExternalSemaphoreHandleTypeFlags
	externalSemaphoreFeatures     ExternalSemaphoreFeatureFlags
}

pub type PhysicalDeviceMaintenance3Properties = C.VkPhysicalDeviceMaintenance3Properties

@[typedef]
pub struct C.VkPhysicalDeviceMaintenance3Properties {
pub mut:
	sType                   StructureType = StructureType.physical_device_maintenance3_properties
	pNext                   voidptr       = unsafe { nil }
	maxPerSetDescriptors    u32
	maxMemoryAllocationSize DeviceSize
}

pub type DescriptorSetLayoutSupport = C.VkDescriptorSetLayoutSupport

@[typedef]
pub struct C.VkDescriptorSetLayoutSupport {
pub mut:
	sType     StructureType = StructureType.descriptor_set_layout_support
	pNext     voidptr       = unsafe { nil }
	supported Bool32
}

pub type PhysicalDeviceShaderDrawParametersFeatures = C.VkPhysicalDeviceShaderDrawParametersFeatures

@[typedef]
pub struct C.VkPhysicalDeviceShaderDrawParametersFeatures {
pub mut:
	sType                StructureType = StructureType.physical_device_shader_draw_parameters_features
	pNext                voidptr       = unsafe { nil }
	shaderDrawParameters Bool32
}

pub type PhysicalDeviceShaderDrawParameterFeatures = C.VkPhysicalDeviceShaderDrawParametersFeatures

fn C.vkEnumerateInstanceVersion(&u32) Result

pub type PFN_vkEnumerateInstanceVersion = fn (&u32) Result

@[inline]
pub fn enumerate_instance_version(p_api_version &u32) Result {
	return C.vkEnumerateInstanceVersion(p_api_version)
}

fn C.vkBindBufferMemory2(C.VkDevice, u32, &BindBufferMemoryInfo) Result

pub type PFN_vkBindBufferMemory2 = fn (C.VkDevice, u32, &BindBufferMemoryInfo) Result

@[inline]
pub fn bind_buffer_memory2(device C.VkDevice,
	bind_info_count u32,
	p_bind_infos &BindBufferMemoryInfo) Result {
	return C.vkBindBufferMemory2(device, bind_info_count, p_bind_infos)
}

fn C.vkBindImageMemory2(C.VkDevice, u32, &BindImageMemoryInfo) Result

pub type PFN_vkBindImageMemory2 = fn (C.VkDevice, u32, &BindImageMemoryInfo) Result

@[inline]
pub fn bind_image_memory2(device C.VkDevice,
	bind_info_count u32,
	p_bind_infos &BindImageMemoryInfo) Result {
	return C.vkBindImageMemory2(device, bind_info_count, p_bind_infos)
}

fn C.vkGetDeviceGroupPeerMemoryFeatures(C.VkDevice, u32, u32, u32, &PeerMemoryFeatureFlags)

pub type PFN_vkGetDeviceGroupPeerMemoryFeatures = fn (C.VkDevice, u32, u32, u32, &PeerMemoryFeatureFlags)

@[inline]
pub fn get_device_group_peer_memory_features(device C.VkDevice,
	heap_index u32,
	local_device_index u32,
	remote_device_index u32,
	p_peer_memory_features &PeerMemoryFeatureFlags) {
	C.vkGetDeviceGroupPeerMemoryFeatures(device, heap_index, local_device_index, remote_device_index,
		p_peer_memory_features)
}

fn C.vkCmdSetDeviceMask(C.VkCommandBuffer, u32)

pub type PFN_vkCmdSetDeviceMask = fn (C.VkCommandBuffer, u32)

@[inline]
pub fn cmd_set_device_mask(command_buffer C.VkCommandBuffer,
	device_mask u32) {
	C.vkCmdSetDeviceMask(command_buffer, device_mask)
}

fn C.vkCmdDispatchBase(C.VkCommandBuffer, u32, u32, u32, u32, u32, u32)

pub type PFN_vkCmdDispatchBase = fn (C.VkCommandBuffer, u32, u32, u32, u32, u32, u32)

@[inline]
pub fn cmd_dispatch_base(command_buffer C.VkCommandBuffer,
	base_group_x u32,
	base_group_y u32,
	base_group_z u32,
	group_count_x u32,
	group_count_y u32,
	group_count_z u32) {
	C.vkCmdDispatchBase(command_buffer, base_group_x, base_group_y, base_group_z, group_count_x,
		group_count_y, group_count_z)
}

fn C.vkEnumeratePhysicalDeviceGroups(C.VkInstance, &u32, &PhysicalDeviceGroupProperties) Result

pub type PFN_vkEnumeratePhysicalDeviceGroups = fn (C.VkInstance, &u32, &PhysicalDeviceGroupProperties) Result

@[inline]
pub fn enumerate_physical_device_groups(instance C.VkInstance,
	p_physical_device_group_count &u32,
	p_physical_device_group_properties &PhysicalDeviceGroupProperties) Result {
	return C.vkEnumeratePhysicalDeviceGroups(instance, p_physical_device_group_count,
		p_physical_device_group_properties)
}

fn C.vkGetImageMemoryRequirements2(C.VkDevice, &ImageMemoryRequirementsInfo2, &MemoryRequirements2)

pub type PFN_vkGetImageMemoryRequirements2 = fn (C.VkDevice, &ImageMemoryRequirementsInfo2, &MemoryRequirements2)

@[inline]
pub fn get_image_memory_requirements2(device C.VkDevice,
	p_info &ImageMemoryRequirementsInfo2,
	p_memory_requirements &MemoryRequirements2) {
	C.vkGetImageMemoryRequirements2(device, p_info, p_memory_requirements)
}

fn C.vkGetBufferMemoryRequirements2(C.VkDevice, &BufferMemoryRequirementsInfo2, &MemoryRequirements2)

pub type PFN_vkGetBufferMemoryRequirements2 = fn (C.VkDevice, &BufferMemoryRequirementsInfo2, &MemoryRequirements2)

@[inline]
pub fn get_buffer_memory_requirements2(device C.VkDevice,
	p_info &BufferMemoryRequirementsInfo2,
	p_memory_requirements &MemoryRequirements2) {
	C.vkGetBufferMemoryRequirements2(device, p_info, p_memory_requirements)
}

fn C.vkGetImageSparseMemoryRequirements2(C.VkDevice, &ImageSparseMemoryRequirementsInfo2, &u32, &SparseImageMemoryRequirements2)

pub type PFN_vkGetImageSparseMemoryRequirements2 = fn (C.VkDevice, &ImageSparseMemoryRequirementsInfo2, &u32, &SparseImageMemoryRequirements2)

@[inline]
pub fn get_image_sparse_memory_requirements2(device C.VkDevice,
	p_info &ImageSparseMemoryRequirementsInfo2,
	p_sparse_memory_requirement_count &u32,
	p_sparse_memory_requirements &SparseImageMemoryRequirements2) {
	C.vkGetImageSparseMemoryRequirements2(device, p_info, p_sparse_memory_requirement_count,
		p_sparse_memory_requirements)
}

fn C.vkGetPhysicalDeviceFeatures2(C.VkPhysicalDevice, &PhysicalDeviceFeatures2)

pub type PFN_vkGetPhysicalDeviceFeatures2 = fn (C.VkPhysicalDevice, &PhysicalDeviceFeatures2)

@[inline]
pub fn get_physical_device_features2(physical_device C.VkPhysicalDevice,
	p_features &PhysicalDeviceFeatures2) {
	C.vkGetPhysicalDeviceFeatures2(physical_device, p_features)
}

fn C.vkGetPhysicalDeviceProperties2(C.VkPhysicalDevice, &PhysicalDeviceProperties2)

pub type PFN_vkGetPhysicalDeviceProperties2 = fn (C.VkPhysicalDevice, &PhysicalDeviceProperties2)

@[inline]
pub fn get_physical_device_properties2(physical_device C.VkPhysicalDevice,
	p_properties &PhysicalDeviceProperties2) {
	C.vkGetPhysicalDeviceProperties2(physical_device, p_properties)
}

fn C.vkGetPhysicalDeviceFormatProperties2(C.VkPhysicalDevice, Format, &FormatProperties2)

pub type PFN_vkGetPhysicalDeviceFormatProperties2 = fn (C.VkPhysicalDevice, Format, &FormatProperties2)

@[inline]
pub fn get_physical_device_format_properties2(physical_device C.VkPhysicalDevice,
	format Format,
	p_format_properties &FormatProperties2) {
	C.vkGetPhysicalDeviceFormatProperties2(physical_device, format, p_format_properties)
}

fn C.vkGetPhysicalDeviceImageFormatProperties2(C.VkPhysicalDevice, &PhysicalDeviceImageFormatInfo2, &ImageFormatProperties2) Result

pub type PFN_vkGetPhysicalDeviceImageFormatProperties2 = fn (C.VkPhysicalDevice, &PhysicalDeviceImageFormatInfo2, &ImageFormatProperties2) Result

@[inline]
pub fn get_physical_device_image_format_properties2(physical_device C.VkPhysicalDevice,
	p_image_format_info &PhysicalDeviceImageFormatInfo2,
	p_image_format_properties &ImageFormatProperties2) Result {
	return C.vkGetPhysicalDeviceImageFormatProperties2(physical_device, p_image_format_info,
		p_image_format_properties)
}

fn C.vkGetPhysicalDeviceQueueFamilyProperties2(C.VkPhysicalDevice, &u32, &QueueFamilyProperties2)

pub type PFN_vkGetPhysicalDeviceQueueFamilyProperties2 = fn (C.VkPhysicalDevice, &u32, &QueueFamilyProperties2)

@[inline]
pub fn get_physical_device_queue_family_properties2(physical_device C.VkPhysicalDevice,
	p_queue_family_property_count &u32,
	p_queue_family_properties &QueueFamilyProperties2) {
	C.vkGetPhysicalDeviceQueueFamilyProperties2(physical_device, p_queue_family_property_count,
		p_queue_family_properties)
}

fn C.vkGetPhysicalDeviceMemoryProperties2(C.VkPhysicalDevice, &PhysicalDeviceMemoryProperties2)

pub type PFN_vkGetPhysicalDeviceMemoryProperties2 = fn (C.VkPhysicalDevice, &PhysicalDeviceMemoryProperties2)

@[inline]
pub fn get_physical_device_memory_properties2(physical_device C.VkPhysicalDevice,
	p_memory_properties &PhysicalDeviceMemoryProperties2) {
	C.vkGetPhysicalDeviceMemoryProperties2(physical_device, p_memory_properties)
}

fn C.vkGetPhysicalDeviceSparseImageFormatProperties2(C.VkPhysicalDevice, &PhysicalDeviceSparseImageFormatInfo2, &u32, &SparseImageFormatProperties2)

pub type PFN_vkGetPhysicalDeviceSparseImageFormatProperties2 = fn (C.VkPhysicalDevice, &PhysicalDeviceSparseImageFormatInfo2, &u32, &SparseImageFormatProperties2)

@[inline]
pub fn get_physical_device_sparse_image_format_properties2(physical_device C.VkPhysicalDevice,
	p_format_info &PhysicalDeviceSparseImageFormatInfo2,
	p_property_count &u32,
	p_properties &SparseImageFormatProperties2) {
	C.vkGetPhysicalDeviceSparseImageFormatProperties2(physical_device, p_format_info,
		p_property_count, p_properties)
}

fn C.vkTrimCommandPool(C.VkDevice, C.VkCommandPool, CommandPoolTrimFlags)

pub type PFN_vkTrimCommandPool = fn (C.VkDevice, C.VkCommandPool, CommandPoolTrimFlags)

@[inline]
pub fn trim_command_pool(device C.VkDevice,
	command_pool C.VkCommandPool,
	flags CommandPoolTrimFlags) {
	C.vkTrimCommandPool(device, command_pool, flags)
}

fn C.vkGetDeviceQueue2(C.VkDevice, &DeviceQueueInfo2, C.VkQueue)

pub type PFN_vkGetDeviceQueue2 = fn (C.VkDevice, &DeviceQueueInfo2, C.VkQueue)

@[inline]
pub fn get_device_queue2(device C.VkDevice,
	p_queue_info &DeviceQueueInfo2,
	p_queue C.VkQueue) {
	C.vkGetDeviceQueue2(device, p_queue_info, p_queue)
}

fn C.vkCreateSamplerYcbcrConversion(C.VkDevice, &SamplerYcbcrConversionCreateInfo, &AllocationCallbacks, C.VkSamplerYcbcrConversion) Result

pub type PFN_vkCreateSamplerYcbcrConversion = fn (C.VkDevice, &SamplerYcbcrConversionCreateInfo, &AllocationCallbacks, C.VkSamplerYcbcrConversion) Result

@[inline]
pub fn create_sampler_ycbcr_conversion(device C.VkDevice,
	p_create_info &SamplerYcbcrConversionCreateInfo,
	p_allocator &AllocationCallbacks,
	p_ycbcr_conversion C.VkSamplerYcbcrConversion) Result {
	return C.vkCreateSamplerYcbcrConversion(device, p_create_info, p_allocator, p_ycbcr_conversion)
}

fn C.vkDestroySamplerYcbcrConversion(C.VkDevice, C.VkSamplerYcbcrConversion, &AllocationCallbacks)

pub type PFN_vkDestroySamplerYcbcrConversion = fn (C.VkDevice, C.VkSamplerYcbcrConversion, &AllocationCallbacks)

@[inline]
pub fn destroy_sampler_ycbcr_conversion(device C.VkDevice,
	ycbcr_conversion C.VkSamplerYcbcrConversion,
	p_allocator &AllocationCallbacks) {
	C.vkDestroySamplerYcbcrConversion(device, ycbcr_conversion, p_allocator)
}

fn C.vkCreateDescriptorUpdateTemplate(C.VkDevice, &DescriptorUpdateTemplateCreateInfo, &AllocationCallbacks, C.VkDescriptorUpdateTemplate) Result

pub type PFN_vkCreateDescriptorUpdateTemplate = fn (C.VkDevice, &DescriptorUpdateTemplateCreateInfo, &AllocationCallbacks, C.VkDescriptorUpdateTemplate) Result

@[inline]
pub fn create_descriptor_update_template(device C.VkDevice,
	p_create_info &DescriptorUpdateTemplateCreateInfo,
	p_allocator &AllocationCallbacks,
	p_descriptor_update_template C.VkDescriptorUpdateTemplate) Result {
	return C.vkCreateDescriptorUpdateTemplate(device, p_create_info, p_allocator, p_descriptor_update_template)
}

fn C.vkDestroyDescriptorUpdateTemplate(C.VkDevice, C.VkDescriptorUpdateTemplate, &AllocationCallbacks)

pub type PFN_vkDestroyDescriptorUpdateTemplate = fn (C.VkDevice, C.VkDescriptorUpdateTemplate, &AllocationCallbacks)

@[inline]
pub fn destroy_descriptor_update_template(device C.VkDevice,
	descriptor_update_template C.VkDescriptorUpdateTemplate,
	p_allocator &AllocationCallbacks) {
	C.vkDestroyDescriptorUpdateTemplate(device, descriptor_update_template, p_allocator)
}

fn C.vkUpdateDescriptorSetWithTemplate(C.VkDevice, C.VkDescriptorSet, C.VkDescriptorUpdateTemplate, voidptr)

pub type PFN_vkUpdateDescriptorSetWithTemplate = fn (C.VkDevice, C.VkDescriptorSet, C.VkDescriptorUpdateTemplate, voidptr)

@[inline]
pub fn update_descriptor_set_with_template(device C.VkDevice,
	descriptor_set C.VkDescriptorSet,
	descriptor_update_template C.VkDescriptorUpdateTemplate,
	p_data voidptr) {
	C.vkUpdateDescriptorSetWithTemplate(device, descriptor_set, descriptor_update_template,
		p_data)
}

fn C.vkGetPhysicalDeviceExternalBufferProperties(C.VkPhysicalDevice, &PhysicalDeviceExternalBufferInfo, &ExternalBufferProperties)

pub type PFN_vkGetPhysicalDeviceExternalBufferProperties = fn (C.VkPhysicalDevice, &PhysicalDeviceExternalBufferInfo, &ExternalBufferProperties)

@[inline]
pub fn get_physical_device_external_buffer_properties(physical_device C.VkPhysicalDevice,
	p_external_buffer_info &PhysicalDeviceExternalBufferInfo,
	p_external_buffer_properties &ExternalBufferProperties) {
	C.vkGetPhysicalDeviceExternalBufferProperties(physical_device, p_external_buffer_info,
		p_external_buffer_properties)
}

fn C.vkGetPhysicalDeviceExternalFenceProperties(C.VkPhysicalDevice, &PhysicalDeviceExternalFenceInfo, &ExternalFenceProperties)

pub type PFN_vkGetPhysicalDeviceExternalFenceProperties = fn (C.VkPhysicalDevice, &PhysicalDeviceExternalFenceInfo, &ExternalFenceProperties)

@[inline]
pub fn get_physical_device_external_fence_properties(physical_device C.VkPhysicalDevice,
	p_external_fence_info &PhysicalDeviceExternalFenceInfo,
	p_external_fence_properties &ExternalFenceProperties) {
	C.vkGetPhysicalDeviceExternalFenceProperties(physical_device, p_external_fence_info,
		p_external_fence_properties)
}

fn C.vkGetPhysicalDeviceExternalSemaphoreProperties(C.VkPhysicalDevice, &PhysicalDeviceExternalSemaphoreInfo, &ExternalSemaphoreProperties)

pub type PFN_vkGetPhysicalDeviceExternalSemaphoreProperties = fn (C.VkPhysicalDevice, &PhysicalDeviceExternalSemaphoreInfo, &ExternalSemaphoreProperties)

@[inline]
pub fn get_physical_device_external_semaphore_properties(physical_device C.VkPhysicalDevice,
	p_external_semaphore_info &PhysicalDeviceExternalSemaphoreInfo,
	p_external_semaphore_properties &ExternalSemaphoreProperties) {
	C.vkGetPhysicalDeviceExternalSemaphoreProperties(physical_device, p_external_semaphore_info,
		p_external_semaphore_properties)
}

fn C.vkGetDescriptorSetLayoutSupport(C.VkDevice, &DescriptorSetLayoutCreateInfo, &DescriptorSetLayoutSupport)

pub type PFN_vkGetDescriptorSetLayoutSupport = fn (C.VkDevice, &DescriptorSetLayoutCreateInfo, &DescriptorSetLayoutSupport)

@[inline]
pub fn get_descriptor_set_layout_support(device C.VkDevice,
	p_create_info &DescriptorSetLayoutCreateInfo,
	p_support &DescriptorSetLayoutSupport) {
	C.vkGetDescriptorSetLayoutSupport(device, p_create_info, p_support)
}

// Vulkan 1.2 version number
pub const api_version_1_2 = make_api_version(0, 1, 2, 0) // Patch version should always be set to 0

pub const max_driver_name_size = u32(256)
pub const max_driver_info_size = u32(256)

pub enum DriverId {
	amd_proprietary              = 1
	amd_open_source              = 2
	mesa_radv                    = 3
	nvidia_proprietary           = 4
	intel_proprietary_windows    = 5
	intel_open_source_mesa       = 6
	imagination_proprietary      = 7
	qualcomm_proprietary         = 8
	arm_proprietary              = 9
	google_swiftshader           = 10
	ggp_proprietary              = 11
	broadcom_proprietary         = 12
	mesa_llvmpipe                = 13
	moltenvk                     = 14
	coreavi_proprietary          = 15
	juice_proprietary            = 16
	verisilicon_proprietary      = 17
	mesa_turnip                  = 18
	mesa_v3dv                    = 19
	mesa_panvk                   = 20
	samsung_proprietary          = 21
	mesa_venus                   = 22
	mesa_dozen                   = 23
	mesa_nvk                     = 24
	imagination_open_source_mesa = 25
	mesa_agxv                    = 26
	max_enum                     = max_int
}

pub enum ShaderFloatControlsIndependence {
	_32_bit_only = 0
	all          = 1
	none         = 2
	max_enum     = max_int
}

pub enum SamplerReductionMode {
	weighted_average                 = 0
	min                              = 1
	max                              = 2
	weighted_average_rangeclamp_qcom = 1000521000
	max_enum                         = max_int
}

pub enum SemaphoreType {
	binary   = 0
	timeline = 1
	max_enum = max_int
}

pub enum ResolveModeFlagBits {
	none                               = 0
	sample_zero_bit                    = int(0x00000001)
	average_bit                        = int(0x00000002)
	min_bit                            = int(0x00000004)
	max_bit                            = int(0x00000008)
	external_format_downsample_android = int(0x00000010)
	max_enum                           = max_int
}

pub type ResolveModeFlags = u32

pub enum DescriptorBindingFlagBits {
	update_after_bind_bit           = int(0x00000001)
	update_unused_while_pending_bit = int(0x00000002)
	partially_bound_bit             = int(0x00000004)
	variable_descriptor_count_bit   = int(0x00000008)
	max_enum                        = max_int
}

pub type DescriptorBindingFlags = u32

pub enum SemaphoreWaitFlagBits {
	any_bit  = int(0x00000001)
	max_enum = max_int
}

pub type SemaphoreWaitFlags = u32
pub type PhysicalDeviceVulkan11Features = C.VkPhysicalDeviceVulkan11Features

@[typedef]
pub struct C.VkPhysicalDeviceVulkan11Features {
pub mut:
	sType                              StructureType
	pNext                              voidptr = unsafe { nil }
	storageBuffer16BitAccess           Bool32
	uniformAndStorageBuffer16BitAccess Bool32
	storagePushConstant16              Bool32
	storageInputOutput16               Bool32
	multiview                          Bool32
	multiviewGeometryShader            Bool32
	multiviewTessellationShader        Bool32
	variablePointersStorageBuffer      Bool32
	variablePointers                   Bool32
	protectedMemory                    Bool32
	samplerYcbcrConversion             Bool32
	shaderDrawParameters               Bool32
}

pub type PhysicalDeviceVulkan11Properties = C.VkPhysicalDeviceVulkan11Properties

@[typedef]
pub struct C.VkPhysicalDeviceVulkan11Properties {
pub mut:
	sType                             StructureType
	pNext                             voidptr = unsafe { nil }
	deviceUUID                        [uuid_size]u8
	driverUUID                        [uuid_size]u8
	deviceLUID                        [luid_size]u8
	deviceNodeMask                    u32
	deviceLUIDValid                   Bool32
	subgroupSize                      u32
	subgroupSupportedStages           ShaderStageFlags
	subgroupSupportedOperations       SubgroupFeatureFlags
	subgroupQuadOperationsInAllStages Bool32
	pointClippingBehavior             PointClippingBehavior
	maxMultiviewViewCount             u32
	maxMultiviewInstanceIndex         u32
	protectedNoFault                  Bool32
	maxPerSetDescriptors              u32
	maxMemoryAllocationSize           DeviceSize
}

pub type PhysicalDeviceVulkan12Features = C.VkPhysicalDeviceVulkan12Features

@[typedef]
pub struct C.VkPhysicalDeviceVulkan12Features {
pub mut:
	sType                                              StructureType
	pNext                                              voidptr = unsafe { nil }
	samplerMirrorClampToEdge                           Bool32
	drawIndirectCount                                  Bool32
	storageBuffer8BitAccess                            Bool32
	uniformAndStorageBuffer8BitAccess                  Bool32
	storagePushConstant8                               Bool32
	shaderBufferInt64Atomics                           Bool32
	shaderSharedInt64Atomics                           Bool32
	shaderFloat16                                      Bool32
	shaderInt8                                         Bool32
	descriptorIndexing                                 Bool32
	shaderInputAttachmentArrayDynamicIndexing          Bool32
	shaderUniformTexelBufferArrayDynamicIndexing       Bool32
	shaderStorageTexelBufferArrayDynamicIndexing       Bool32
	shaderUniformBufferArrayNonUniformIndexing         Bool32
	shaderSampledImageArrayNonUniformIndexing          Bool32
	shaderStorageBufferArrayNonUniformIndexing         Bool32
	shaderStorageImageArrayNonUniformIndexing          Bool32
	shaderInputAttachmentArrayNonUniformIndexing       Bool32
	shaderUniformTexelBufferArrayNonUniformIndexing    Bool32
	shaderStorageTexelBufferArrayNonUniformIndexing    Bool32
	descriptorBindingUniformBufferUpdateAfterBind      Bool32
	descriptorBindingSampledImageUpdateAfterBind       Bool32
	descriptorBindingStorageImageUpdateAfterBind       Bool32
	descriptorBindingStorageBufferUpdateAfterBind      Bool32
	descriptorBindingUniformTexelBufferUpdateAfterBind Bool32
	descriptorBindingStorageTexelBufferUpdateAfterBind Bool32
	descriptorBindingUpdateUnusedWhilePending          Bool32
	descriptorBindingPartiallyBound                    Bool32
	descriptorBindingVariableDescriptorCount           Bool32
	runtimeDescriptorArray                             Bool32
	samplerFilterMinmax                                Bool32
	scalarBlockLayout                                  Bool32
	imagelessFramebuffer                               Bool32
	uniformBufferStandardLayout                        Bool32
	shaderSubgroupExtendedTypes                        Bool32
	separateDepthStencilLayouts                        Bool32
	hostQueryReset                                     Bool32
	timelineSemaphore                                  Bool32
	bufferDeviceAddress                                Bool32
	bufferDeviceAddressCaptureReplay                   Bool32
	bufferDeviceAddressMultiDevice                     Bool32
	vulkanMemoryModel                                  Bool32
	vulkanMemoryModelDeviceScope                       Bool32
	vulkanMemoryModelAvailabilityVisibilityChains      Bool32
	shaderOutputViewportIndex                          Bool32
	shaderOutputLayer                                  Bool32
	subgroupBroadcastDynamicId                         Bool32
}

pub type ConformanceVersion = C.VkConformanceVersion

@[typedef]
pub struct C.VkConformanceVersion {
pub mut:
	major    u8
	minor    u8
	subminor u8
	patch    u8
}

pub type PhysicalDeviceVulkan12Properties = C.VkPhysicalDeviceVulkan12Properties

@[typedef]
pub struct C.VkPhysicalDeviceVulkan12Properties {
pub mut:
	sType                                                StructureType
	pNext                                                voidptr = unsafe { nil }
	driverID                                             DriverId
	driverName                                           [max_driver_name_size]char
	driverInfo                                           [max_driver_info_size]char
	conformanceVersion                                   ConformanceVersion
	denormBehaviorIndependence                           ShaderFloatControlsIndependence
	roundingModeIndependence                             ShaderFloatControlsIndependence
	shaderSignedZeroInfNanPreserveFloat16                Bool32
	shaderSignedZeroInfNanPreserveFloat32                Bool32
	shaderSignedZeroInfNanPreserveFloat64                Bool32
	shaderDenormPreserveFloat16                          Bool32
	shaderDenormPreserveFloat32                          Bool32
	shaderDenormPreserveFloat64                          Bool32
	shaderDenormFlushToZeroFloat16                       Bool32
	shaderDenormFlushToZeroFloat32                       Bool32
	shaderDenormFlushToZeroFloat64                       Bool32
	shaderRoundingModeRTEFloat16                         Bool32
	shaderRoundingModeRTEFloat32                         Bool32
	shaderRoundingModeRTEFloat64                         Bool32
	shaderRoundingModeRTZFloat16                         Bool32
	shaderRoundingModeRTZFloat32                         Bool32
	shaderRoundingModeRTZFloat64                         Bool32
	maxUpdateAfterBindDescriptorsInAllPools              u32
	shaderUniformBufferArrayNonUniformIndexingNative     Bool32
	shaderSampledImageArrayNonUniformIndexingNative      Bool32
	shaderStorageBufferArrayNonUniformIndexingNative     Bool32
	shaderStorageImageArrayNonUniformIndexingNative      Bool32
	shaderInputAttachmentArrayNonUniformIndexingNative   Bool32
	robustBufferAccessUpdateAfterBind                    Bool32
	quadDivergentImplicitLod                             Bool32
	maxPerStageDescriptorUpdateAfterBindSamplers         u32
	maxPerStageDescriptorUpdateAfterBindUniformBuffers   u32
	maxPerStageDescriptorUpdateAfterBindStorageBuffers   u32
	maxPerStageDescriptorUpdateAfterBindSampledImages    u32
	maxPerStageDescriptorUpdateAfterBindStorageImages    u32
	maxPerStageDescriptorUpdateAfterBindInputAttachments u32
	maxPerStageUpdateAfterBindResources                  u32
	maxDescriptorSetUpdateAfterBindSamplers              u32
	maxDescriptorSetUpdateAfterBindUniformBuffers        u32
	maxDescriptorSetUpdateAfterBindUniformBuffersDynamic u32
	maxDescriptorSetUpdateAfterBindStorageBuffers        u32
	maxDescriptorSetUpdateAfterBindStorageBuffersDynamic u32
	maxDescriptorSetUpdateAfterBindSampledImages         u32
	maxDescriptorSetUpdateAfterBindStorageImages         u32
	maxDescriptorSetUpdateAfterBindInputAttachments      u32
	supportedDepthResolveModes                           ResolveModeFlags
	supportedStencilResolveModes                         ResolveModeFlags
	independentResolveNone                               Bool32
	independentResolve                                   Bool32
	filterMinmaxSingleComponentFormats                   Bool32
	filterMinmaxImageComponentMapping                    Bool32
	maxTimelineSemaphoreValueDifference                  u64
	framebufferIntegerColorSampleCounts                  SampleCountFlags
}

pub type ImageFormatListCreateInfo = C.VkImageFormatListCreateInfo

@[typedef]
pub struct C.VkImageFormatListCreateInfo {
pub mut:
	sType           StructureType = StructureType.image_format_list_create_info
	pNext           voidptr       = unsafe { nil }
	viewFormatCount u32
	pViewFormats    &Format
}

pub type AttachmentDescription2 = C.VkAttachmentDescription2

@[typedef]
pub struct C.VkAttachmentDescription2 {
pub mut:
	sType          StructureType = StructureType.attachment_description2
	pNext          voidptr       = unsafe { nil }
	flags          AttachmentDescriptionFlags
	format         Format
	samples        SampleCountFlagBits
	loadOp         AttachmentLoadOp
	storeOp        AttachmentStoreOp
	stencilLoadOp  AttachmentLoadOp
	stencilStoreOp AttachmentStoreOp
	initialLayout  ImageLayout
	finalLayout    ImageLayout
}

pub type AttachmentReference2 = C.VkAttachmentReference2

@[typedef]
pub struct C.VkAttachmentReference2 {
pub mut:
	sType      StructureType = StructureType.attachment_reference2
	pNext      voidptr       = unsafe { nil }
	attachment u32
	layout     ImageLayout
	aspectMask ImageAspectFlags
}

pub type SubpassDescription2 = C.VkSubpassDescription2

@[typedef]
pub struct C.VkSubpassDescription2 {
pub mut:
	sType                   StructureType = StructureType.subpass_description2
	pNext                   voidptr       = unsafe { nil }
	flags                   SubpassDescriptionFlags
	pipelineBindPoint       PipelineBindPoint
	viewMask                u32
	inputAttachmentCount    u32
	pInputAttachments       &AttachmentReference2
	colorAttachmentCount    u32
	pColorAttachments       &AttachmentReference2
	pResolveAttachments     &AttachmentReference2
	pDepthStencilAttachment &AttachmentReference2
	preserveAttachmentCount u32
	pPreserveAttachments    &u32
}

pub type SubpassDependency2 = C.VkSubpassDependency2

@[typedef]
pub struct C.VkSubpassDependency2 {
pub mut:
	sType           StructureType = StructureType.subpass_dependency2
	pNext           voidptr       = unsafe { nil }
	srcSubpass      u32
	dstSubpass      u32
	srcStageMask    PipelineStageFlags
	dstStageMask    PipelineStageFlags
	srcAccessMask   AccessFlags
	dstAccessMask   AccessFlags
	dependencyFlags DependencyFlags
	viewOffset      i32
}

pub type RenderPassCreateInfo2 = C.VkRenderPassCreateInfo2

@[typedef]
pub struct C.VkRenderPassCreateInfo2 {
pub mut:
	sType                   StructureType = StructureType.render_pass_create_info2
	pNext                   voidptr       = unsafe { nil }
	flags                   RenderPassCreateFlags
	attachmentCount         u32
	pAttachments            &AttachmentDescription2
	subpassCount            u32
	pSubpasses              &SubpassDescription2
	dependencyCount         u32
	pDependencies           &SubpassDependency2
	correlatedViewMaskCount u32
	pCorrelatedViewMasks    &u32
}

pub type SubpassBeginInfo = C.VkSubpassBeginInfo

@[typedef]
pub struct C.VkSubpassBeginInfo {
pub mut:
	sType    StructureType = StructureType.subpass_begin_info
	pNext    voidptr       = unsafe { nil }
	contents SubpassContents
}

pub type SubpassEndInfo = C.VkSubpassEndInfo

@[typedef]
pub struct C.VkSubpassEndInfo {
pub mut:
	sType StructureType = StructureType.subpass_end_info
	pNext voidptr       = unsafe { nil }
}

pub type PhysicalDevice8BitStorageFeatures = C.VkPhysicalDevice8BitStorageFeatures

@[typedef]
pub struct C.VkPhysicalDevice8BitStorageFeatures {
pub mut:
	sType                             StructureType
	pNext                             voidptr = unsafe { nil }
	storageBuffer8BitAccess           Bool32
	uniformAndStorageBuffer8BitAccess Bool32
	storagePushConstant8              Bool32
}

pub type PhysicalDeviceDriverProperties = C.VkPhysicalDeviceDriverProperties

@[typedef]
pub struct C.VkPhysicalDeviceDriverProperties {
pub mut:
	sType              StructureType = StructureType.physical_device_driver_properties
	pNext              voidptr       = unsafe { nil }
	driverID           DriverId
	driverName         [max_driver_name_size]char
	driverInfo         [max_driver_info_size]char
	conformanceVersion ConformanceVersion
}

pub type PhysicalDeviceShaderAtomicInt64Features = C.VkPhysicalDeviceShaderAtomicInt64Features

@[typedef]
pub struct C.VkPhysicalDeviceShaderAtomicInt64Features {
pub mut:
	sType                    StructureType = StructureType.physical_device_shader_atomic_int64_features
	pNext                    voidptr       = unsafe { nil }
	shaderBufferInt64Atomics Bool32
	shaderSharedInt64Atomics Bool32
}

pub type PhysicalDeviceShaderFloat16Int8Features = C.VkPhysicalDeviceShaderFloat16Int8Features

@[typedef]
pub struct C.VkPhysicalDeviceShaderFloat16Int8Features {
pub mut:
	sType         StructureType = StructureType.physical_device_shader_float16_int8_features
	pNext         voidptr       = unsafe { nil }
	shaderFloat16 Bool32
	shaderInt8    Bool32
}

pub type PhysicalDeviceFloatControlsProperties = C.VkPhysicalDeviceFloatControlsProperties

@[typedef]
pub struct C.VkPhysicalDeviceFloatControlsProperties {
pub mut:
	sType                                 StructureType = StructureType.physical_device_float_controls_properties
	pNext                                 voidptr       = unsafe { nil }
	denormBehaviorIndependence            ShaderFloatControlsIndependence
	roundingModeIndependence              ShaderFloatControlsIndependence
	shaderSignedZeroInfNanPreserveFloat16 Bool32
	shaderSignedZeroInfNanPreserveFloat32 Bool32
	shaderSignedZeroInfNanPreserveFloat64 Bool32
	shaderDenormPreserveFloat16           Bool32
	shaderDenormPreserveFloat32           Bool32
	shaderDenormPreserveFloat64           Bool32
	shaderDenormFlushToZeroFloat16        Bool32
	shaderDenormFlushToZeroFloat32        Bool32
	shaderDenormFlushToZeroFloat64        Bool32
	shaderRoundingModeRTEFloat16          Bool32
	shaderRoundingModeRTEFloat32          Bool32
	shaderRoundingModeRTEFloat64          Bool32
	shaderRoundingModeRTZFloat16          Bool32
	shaderRoundingModeRTZFloat32          Bool32
	shaderRoundingModeRTZFloat64          Bool32
}

pub type DescriptorSetLayoutBindingFlagsCreateInfo = C.VkDescriptorSetLayoutBindingFlagsCreateInfo

@[typedef]
pub struct C.VkDescriptorSetLayoutBindingFlagsCreateInfo {
pub mut:
	sType         StructureType = StructureType.descriptor_set_layout_binding_flags_create_info
	pNext         voidptr       = unsafe { nil }
	bindingCount  u32
	pBindingFlags &DescriptorBindingFlags
}

pub type PhysicalDeviceDescriptorIndexingFeatures = C.VkPhysicalDeviceDescriptorIndexingFeatures

@[typedef]
pub struct C.VkPhysicalDeviceDescriptorIndexingFeatures {
pub mut:
	sType                                              StructureType = StructureType.physical_device_descriptor_indexing_features
	pNext                                              voidptr       = unsafe { nil }
	shaderInputAttachmentArrayDynamicIndexing          Bool32
	shaderUniformTexelBufferArrayDynamicIndexing       Bool32
	shaderStorageTexelBufferArrayDynamicIndexing       Bool32
	shaderUniformBufferArrayNonUniformIndexing         Bool32
	shaderSampledImageArrayNonUniformIndexing          Bool32
	shaderStorageBufferArrayNonUniformIndexing         Bool32
	shaderStorageImageArrayNonUniformIndexing          Bool32
	shaderInputAttachmentArrayNonUniformIndexing       Bool32
	shaderUniformTexelBufferArrayNonUniformIndexing    Bool32
	shaderStorageTexelBufferArrayNonUniformIndexing    Bool32
	descriptorBindingUniformBufferUpdateAfterBind      Bool32
	descriptorBindingSampledImageUpdateAfterBind       Bool32
	descriptorBindingStorageImageUpdateAfterBind       Bool32
	descriptorBindingStorageBufferUpdateAfterBind      Bool32
	descriptorBindingUniformTexelBufferUpdateAfterBind Bool32
	descriptorBindingStorageTexelBufferUpdateAfterBind Bool32
	descriptorBindingUpdateUnusedWhilePending          Bool32
	descriptorBindingPartiallyBound                    Bool32
	descriptorBindingVariableDescriptorCount           Bool32
	runtimeDescriptorArray                             Bool32
}

pub type PhysicalDeviceDescriptorIndexingProperties = C.VkPhysicalDeviceDescriptorIndexingProperties

@[typedef]
pub struct C.VkPhysicalDeviceDescriptorIndexingProperties {
pub mut:
	sType                                                StructureType = StructureType.physical_device_descriptor_indexing_properties
	pNext                                                voidptr       = unsafe { nil }
	maxUpdateAfterBindDescriptorsInAllPools              u32
	shaderUniformBufferArrayNonUniformIndexingNative     Bool32
	shaderSampledImageArrayNonUniformIndexingNative      Bool32
	shaderStorageBufferArrayNonUniformIndexingNative     Bool32
	shaderStorageImageArrayNonUniformIndexingNative      Bool32
	shaderInputAttachmentArrayNonUniformIndexingNative   Bool32
	robustBufferAccessUpdateAfterBind                    Bool32
	quadDivergentImplicitLod                             Bool32
	maxPerStageDescriptorUpdateAfterBindSamplers         u32
	maxPerStageDescriptorUpdateAfterBindUniformBuffers   u32
	maxPerStageDescriptorUpdateAfterBindStorageBuffers   u32
	maxPerStageDescriptorUpdateAfterBindSampledImages    u32
	maxPerStageDescriptorUpdateAfterBindStorageImages    u32
	maxPerStageDescriptorUpdateAfterBindInputAttachments u32
	maxPerStageUpdateAfterBindResources                  u32
	maxDescriptorSetUpdateAfterBindSamplers              u32
	maxDescriptorSetUpdateAfterBindUniformBuffers        u32
	maxDescriptorSetUpdateAfterBindUniformBuffersDynamic u32
	maxDescriptorSetUpdateAfterBindStorageBuffers        u32
	maxDescriptorSetUpdateAfterBindStorageBuffersDynamic u32
	maxDescriptorSetUpdateAfterBindSampledImages         u32
	maxDescriptorSetUpdateAfterBindStorageImages         u32
	maxDescriptorSetUpdateAfterBindInputAttachments      u32
}

pub type DescriptorSetVariableDescriptorCountAllocateInfo = C.VkDescriptorSetVariableDescriptorCountAllocateInfo

@[typedef]
pub struct C.VkDescriptorSetVariableDescriptorCountAllocateInfo {
pub mut:
	sType              StructureType = StructureType.descriptor_set_variable_descriptor_count_allocate_info
	pNext              voidptr       = unsafe { nil }
	descriptorSetCount u32
	pDescriptorCounts  &u32
}

pub type DescriptorSetVariableDescriptorCountLayoutSupport = C.VkDescriptorSetVariableDescriptorCountLayoutSupport

@[typedef]
pub struct C.VkDescriptorSetVariableDescriptorCountLayoutSupport {
pub mut:
	sType                      StructureType = StructureType.descriptor_set_variable_descriptor_count_layout_support
	pNext                      voidptr       = unsafe { nil }
	maxVariableDescriptorCount u32
}

pub type SubpassDescriptionDepthStencilResolve = C.VkSubpassDescriptionDepthStencilResolve

@[typedef]
pub struct C.VkSubpassDescriptionDepthStencilResolve {
pub mut:
	sType                          StructureType = StructureType.subpass_description_depth_stencil_resolve
	pNext                          voidptr       = unsafe { nil }
	depthResolveMode               ResolveModeFlagBits
	stencilResolveMode             ResolveModeFlagBits
	pDepthStencilResolveAttachment &AttachmentReference2
}

pub type PhysicalDeviceDepthStencilResolveProperties = C.VkPhysicalDeviceDepthStencilResolveProperties

@[typedef]
pub struct C.VkPhysicalDeviceDepthStencilResolveProperties {
pub mut:
	sType                        StructureType = StructureType.physical_device_depth_stencil_resolve_properties
	pNext                        voidptr       = unsafe { nil }
	supportedDepthResolveModes   ResolveModeFlags
	supportedStencilResolveModes ResolveModeFlags
	independentResolveNone       Bool32
	independentResolve           Bool32
}

pub type PhysicalDeviceScalarBlockLayoutFeatures = C.VkPhysicalDeviceScalarBlockLayoutFeatures

@[typedef]
pub struct C.VkPhysicalDeviceScalarBlockLayoutFeatures {
pub mut:
	sType             StructureType = StructureType.physical_device_scalar_block_layout_features
	pNext             voidptr       = unsafe { nil }
	scalarBlockLayout Bool32
}

pub type ImageStencilUsageCreateInfo = C.VkImageStencilUsageCreateInfo

@[typedef]
pub struct C.VkImageStencilUsageCreateInfo {
pub mut:
	sType        StructureType = StructureType.image_stencil_usage_create_info
	pNext        voidptr       = unsafe { nil }
	stencilUsage ImageUsageFlags
}

pub type SamplerReductionModeCreateInfo = C.VkSamplerReductionModeCreateInfo

@[typedef]
pub struct C.VkSamplerReductionModeCreateInfo {
pub mut:
	sType         StructureType = StructureType.sampler_reduction_mode_create_info
	pNext         voidptr       = unsafe { nil }
	reductionMode SamplerReductionMode
}

pub type PhysicalDeviceSamplerFilterMinmaxProperties = C.VkPhysicalDeviceSamplerFilterMinmaxProperties

@[typedef]
pub struct C.VkPhysicalDeviceSamplerFilterMinmaxProperties {
pub mut:
	sType                              StructureType = StructureType.physical_device_sampler_filter_minmax_properties
	pNext                              voidptr       = unsafe { nil }
	filterMinmaxSingleComponentFormats Bool32
	filterMinmaxImageComponentMapping  Bool32
}

pub type PhysicalDeviceVulkanMemoryModelFeatures = C.VkPhysicalDeviceVulkanMemoryModelFeatures

@[typedef]
pub struct C.VkPhysicalDeviceVulkanMemoryModelFeatures {
pub mut:
	sType                                         StructureType = StructureType.physical_device_vulkan_memory_model_features
	pNext                                         voidptr       = unsafe { nil }
	vulkanMemoryModel                             Bool32
	vulkanMemoryModelDeviceScope                  Bool32
	vulkanMemoryModelAvailabilityVisibilityChains Bool32
}

pub type PhysicalDeviceImagelessFramebufferFeatures = C.VkPhysicalDeviceImagelessFramebufferFeatures

@[typedef]
pub struct C.VkPhysicalDeviceImagelessFramebufferFeatures {
pub mut:
	sType                StructureType = StructureType.physical_device_imageless_framebuffer_features
	pNext                voidptr       = unsafe { nil }
	imagelessFramebuffer Bool32
}

pub type FramebufferAttachmentImageInfo = C.VkFramebufferAttachmentImageInfo

@[typedef]
pub struct C.VkFramebufferAttachmentImageInfo {
pub mut:
	sType           StructureType = StructureType.framebuffer_attachment_image_info
	pNext           voidptr       = unsafe { nil }
	flags           ImageCreateFlags
	usage           ImageUsageFlags
	width           u32
	height          u32
	layerCount      u32
	viewFormatCount u32
	pViewFormats    &Format
}

pub type FramebufferAttachmentsCreateInfo = C.VkFramebufferAttachmentsCreateInfo

@[typedef]
pub struct C.VkFramebufferAttachmentsCreateInfo {
pub mut:
	sType                    StructureType = StructureType.framebuffer_attachments_create_info
	pNext                    voidptr       = unsafe { nil }
	attachmentImageInfoCount u32
	pAttachmentImageInfos    &FramebufferAttachmentImageInfo
}

pub type RenderPassAttachmentBeginInfo = C.VkRenderPassAttachmentBeginInfo

@[typedef]
pub struct C.VkRenderPassAttachmentBeginInfo {
pub mut:
	sType           StructureType = StructureType.render_pass_attachment_begin_info
	pNext           voidptr       = unsafe { nil }
	attachmentCount u32
	pAttachments    C.VkImageView
}

pub type PhysicalDeviceUniformBufferStandardLayoutFeatures = C.VkPhysicalDeviceUniformBufferStandardLayoutFeatures

@[typedef]
pub struct C.VkPhysicalDeviceUniformBufferStandardLayoutFeatures {
pub mut:
	sType                       StructureType = StructureType.physical_device_uniform_buffer_standard_layout_features
	pNext                       voidptr       = unsafe { nil }
	uniformBufferStandardLayout Bool32
}

pub type PhysicalDeviceShaderSubgroupExtendedTypesFeatures = C.VkPhysicalDeviceShaderSubgroupExtendedTypesFeatures

@[typedef]
pub struct C.VkPhysicalDeviceShaderSubgroupExtendedTypesFeatures {
pub mut:
	sType                       StructureType = StructureType.physical_device_shader_subgroup_extended_types_features
	pNext                       voidptr       = unsafe { nil }
	shaderSubgroupExtendedTypes Bool32
}

pub type PhysicalDeviceSeparateDepthStencilLayoutsFeatures = C.VkPhysicalDeviceSeparateDepthStencilLayoutsFeatures

@[typedef]
pub struct C.VkPhysicalDeviceSeparateDepthStencilLayoutsFeatures {
pub mut:
	sType                       StructureType = StructureType.physical_device_separate_depth_stencil_layouts_features
	pNext                       voidptr       = unsafe { nil }
	separateDepthStencilLayouts Bool32
}

pub type AttachmentReferenceStencilLayout = C.VkAttachmentReferenceStencilLayout

@[typedef]
pub struct C.VkAttachmentReferenceStencilLayout {
pub mut:
	sType         StructureType = StructureType.attachment_reference_stencil_layout
	pNext         voidptr       = unsafe { nil }
	stencilLayout ImageLayout
}

pub type AttachmentDescriptionStencilLayout = C.VkAttachmentDescriptionStencilLayout

@[typedef]
pub struct C.VkAttachmentDescriptionStencilLayout {
pub mut:
	sType                StructureType = StructureType.attachment_description_stencil_layout
	pNext                voidptr       = unsafe { nil }
	stencilInitialLayout ImageLayout
	stencilFinalLayout   ImageLayout
}

pub type PhysicalDeviceHostQueryResetFeatures = C.VkPhysicalDeviceHostQueryResetFeatures

@[typedef]
pub struct C.VkPhysicalDeviceHostQueryResetFeatures {
pub mut:
	sType          StructureType = StructureType.physical_device_host_query_reset_features
	pNext          voidptr       = unsafe { nil }
	hostQueryReset Bool32
}

pub type PhysicalDeviceTimelineSemaphoreFeatures = C.VkPhysicalDeviceTimelineSemaphoreFeatures

@[typedef]
pub struct C.VkPhysicalDeviceTimelineSemaphoreFeatures {
pub mut:
	sType             StructureType = StructureType.physical_device_timeline_semaphore_features
	pNext             voidptr       = unsafe { nil }
	timelineSemaphore Bool32
}

pub type PhysicalDeviceTimelineSemaphoreProperties = C.VkPhysicalDeviceTimelineSemaphoreProperties

@[typedef]
pub struct C.VkPhysicalDeviceTimelineSemaphoreProperties {
pub mut:
	sType                               StructureType = StructureType.physical_device_timeline_semaphore_properties
	pNext                               voidptr       = unsafe { nil }
	maxTimelineSemaphoreValueDifference u64
}

pub type SemaphoreTypeCreateInfo = C.VkSemaphoreTypeCreateInfo

@[typedef]
pub struct C.VkSemaphoreTypeCreateInfo {
pub mut:
	sType         StructureType = StructureType.semaphore_type_create_info
	pNext         voidptr       = unsafe { nil }
	semaphoreType SemaphoreType
	initialValue  u64
}

pub type TimelineSemaphoreSubmitInfo = C.VkTimelineSemaphoreSubmitInfo

@[typedef]
pub struct C.VkTimelineSemaphoreSubmitInfo {
pub mut:
	sType                     StructureType = StructureType.timeline_semaphore_submit_info
	pNext                     voidptr       = unsafe { nil }
	waitSemaphoreValueCount   u32
	pWaitSemaphoreValues      &u64
	signalSemaphoreValueCount u32
	pSignalSemaphoreValues    &u64
}

pub type SemaphoreWaitInfo = C.VkSemaphoreWaitInfo

@[typedef]
pub struct C.VkSemaphoreWaitInfo {
pub mut:
	sType          StructureType = StructureType.semaphore_wait_info
	pNext          voidptr       = unsafe { nil }
	flags          SemaphoreWaitFlags
	semaphoreCount u32
	pSemaphores    C.VkSemaphore
	pValues        &u64
}

pub type SemaphoreSignalInfo = C.VkSemaphoreSignalInfo

@[typedef]
pub struct C.VkSemaphoreSignalInfo {
pub mut:
	sType     StructureType = StructureType.semaphore_signal_info
	pNext     voidptr       = unsafe { nil }
	semaphore C.VkSemaphore
	value     u64
}

pub type PhysicalDeviceBufferDeviceAddressFeatures = C.VkPhysicalDeviceBufferDeviceAddressFeatures

@[typedef]
pub struct C.VkPhysicalDeviceBufferDeviceAddressFeatures {
pub mut:
	sType                            StructureType = StructureType.physical_device_buffer_device_address_features
	pNext                            voidptr       = unsafe { nil }
	bufferDeviceAddress              Bool32
	bufferDeviceAddressCaptureReplay Bool32
	bufferDeviceAddressMultiDevice   Bool32
}

pub type BufferDeviceAddressInfo = C.VkBufferDeviceAddressInfo

@[typedef]
pub struct C.VkBufferDeviceAddressInfo {
pub mut:
	sType  StructureType = StructureType.buffer_device_address_info
	pNext  voidptr       = unsafe { nil }
	buffer C.VkBuffer
}

pub type BufferOpaqueCaptureAddressCreateInfo = C.VkBufferOpaqueCaptureAddressCreateInfo

@[typedef]
pub struct C.VkBufferOpaqueCaptureAddressCreateInfo {
pub mut:
	sType                StructureType = StructureType.buffer_opaque_capture_address_create_info
	pNext                voidptr       = unsafe { nil }
	opaqueCaptureAddress u64
}

pub type MemoryOpaqueCaptureAddressAllocateInfo = C.VkMemoryOpaqueCaptureAddressAllocateInfo

@[typedef]
pub struct C.VkMemoryOpaqueCaptureAddressAllocateInfo {
pub mut:
	sType                StructureType = StructureType.memory_opaque_capture_address_allocate_info
	pNext                voidptr       = unsafe { nil }
	opaqueCaptureAddress u64
}

pub type DeviceMemoryOpaqueCaptureAddressInfo = C.VkDeviceMemoryOpaqueCaptureAddressInfo

@[typedef]
pub struct C.VkDeviceMemoryOpaqueCaptureAddressInfo {
pub mut:
	sType  StructureType = StructureType.device_memory_opaque_capture_address_info
	pNext  voidptr       = unsafe { nil }
	memory C.VkDeviceMemory
}

fn C.vkCmdDrawIndirectCount(C.VkCommandBuffer, C.VkBuffer, DeviceSize, C.VkBuffer, DeviceSize, u32, u32)

pub type PFN_vkCmdDrawIndirectCount = fn (C.VkCommandBuffer, C.VkBuffer, DeviceSize, C.VkBuffer, DeviceSize, u32, u32)

@[inline]
pub fn cmd_draw_indirect_count(command_buffer C.VkCommandBuffer,
	buffer C.VkBuffer,
	offset DeviceSize,
	count_buffer C.VkBuffer,
	count_buffer_offset DeviceSize,
	max_draw_count u32,
	stride u32) {
	C.vkCmdDrawIndirectCount(command_buffer, buffer, offset, count_buffer, count_buffer_offset,
		max_draw_count, stride)
}

fn C.vkCmdDrawIndexedIndirectCount(C.VkCommandBuffer, C.VkBuffer, DeviceSize, C.VkBuffer, DeviceSize, u32, u32)

pub type PFN_vkCmdDrawIndexedIndirectCount = fn (C.VkCommandBuffer, C.VkBuffer, DeviceSize, C.VkBuffer, DeviceSize, u32, u32)

@[inline]
pub fn cmd_draw_indexed_indirect_count(command_buffer C.VkCommandBuffer,
	buffer C.VkBuffer,
	offset DeviceSize,
	count_buffer C.VkBuffer,
	count_buffer_offset DeviceSize,
	max_draw_count u32,
	stride u32) {
	C.vkCmdDrawIndexedIndirectCount(command_buffer, buffer, offset, count_buffer, count_buffer_offset,
		max_draw_count, stride)
}

fn C.vkCreateRenderPass2(C.VkDevice, &RenderPassCreateInfo2, &AllocationCallbacks, C.VkRenderPass) Result

pub type PFN_vkCreateRenderPass2 = fn (C.VkDevice, &RenderPassCreateInfo2, &AllocationCallbacks, C.VkRenderPass) Result

@[inline]
pub fn create_render_pass2(device C.VkDevice,
	p_create_info &RenderPassCreateInfo2,
	p_allocator &AllocationCallbacks,
	p_render_pass C.VkRenderPass) Result {
	return C.vkCreateRenderPass2(device, p_create_info, p_allocator, p_render_pass)
}

fn C.vkCmdBeginRenderPass2(C.VkCommandBuffer, &RenderPassBeginInfo, &SubpassBeginInfo)

pub type PFN_vkCmdBeginRenderPass2 = fn (C.VkCommandBuffer, &RenderPassBeginInfo, &SubpassBeginInfo)

@[inline]
pub fn cmd_begin_render_pass2(command_buffer C.VkCommandBuffer,
	p_render_pass_begin &RenderPassBeginInfo,
	p_subpass_begin_info &SubpassBeginInfo) {
	C.vkCmdBeginRenderPass2(command_buffer, p_render_pass_begin, p_subpass_begin_info)
}

fn C.vkCmdNextSubpass2(C.VkCommandBuffer, &SubpassBeginInfo, &SubpassEndInfo)

pub type PFN_vkCmdNextSubpass2 = fn (C.VkCommandBuffer, &SubpassBeginInfo, &SubpassEndInfo)

@[inline]
pub fn cmd_next_subpass2(command_buffer C.VkCommandBuffer,
	p_subpass_begin_info &SubpassBeginInfo,
	p_subpass_end_info &SubpassEndInfo) {
	C.vkCmdNextSubpass2(command_buffer, p_subpass_begin_info, p_subpass_end_info)
}

fn C.vkCmdEndRenderPass2(C.VkCommandBuffer, &SubpassEndInfo)

pub type PFN_vkCmdEndRenderPass2 = fn (C.VkCommandBuffer, &SubpassEndInfo)

@[inline]
pub fn cmd_end_render_pass2(command_buffer C.VkCommandBuffer,
	p_subpass_end_info &SubpassEndInfo) {
	C.vkCmdEndRenderPass2(command_buffer, p_subpass_end_info)
}

fn C.vkResetQueryPool(C.VkDevice, C.VkQueryPool, u32, u32)

pub type PFN_vkResetQueryPool = fn (C.VkDevice, C.VkQueryPool, u32, u32)

@[inline]
pub fn reset_query_pool(device C.VkDevice,
	query_pool C.VkQueryPool,
	first_query u32,
	query_count u32) {
	C.vkResetQueryPool(device, query_pool, first_query, query_count)
}

fn C.vkGetSemaphoreCounterValue(C.VkDevice, C.VkSemaphore, &u64) Result

pub type PFN_vkGetSemaphoreCounterValue = fn (C.VkDevice, C.VkSemaphore, &u64) Result

@[inline]
pub fn get_semaphore_counter_value(device C.VkDevice,
	semaphore C.VkSemaphore,
	p_value &u64) Result {
	return C.vkGetSemaphoreCounterValue(device, semaphore, p_value)
}

fn C.vkWaitSemaphores(C.VkDevice, &SemaphoreWaitInfo, u64) Result

pub type PFN_vkWaitSemaphores = fn (C.VkDevice, &SemaphoreWaitInfo, u64) Result

@[inline]
pub fn wait_semaphores(device C.VkDevice,
	p_wait_info &SemaphoreWaitInfo,
	timeout u64) Result {
	return C.vkWaitSemaphores(device, p_wait_info, timeout)
}

fn C.vkSignalSemaphore(C.VkDevice, &SemaphoreSignalInfo) Result

pub type PFN_vkSignalSemaphore = fn (C.VkDevice, &SemaphoreSignalInfo) Result

@[inline]
pub fn signal_semaphore(device C.VkDevice,
	p_signal_info &SemaphoreSignalInfo) Result {
	return C.vkSignalSemaphore(device, p_signal_info)
}

fn C.vkGetBufferDeviceAddress(C.VkDevice, &BufferDeviceAddressInfo) DeviceAddress

pub type PFN_vkGetBufferDeviceAddress = fn (C.VkDevice, &BufferDeviceAddressInfo) DeviceAddress

@[inline]
pub fn get_buffer_device_address(device C.VkDevice,
	p_info &BufferDeviceAddressInfo) DeviceAddress {
	return C.vkGetBufferDeviceAddress(device, p_info)
}

fn C.vkGetBufferOpaqueCaptureAddress(C.VkDevice, &BufferDeviceAddressInfo) u64

pub type PFN_vkGetBufferOpaqueCaptureAddress = fn (C.VkDevice, &BufferDeviceAddressInfo) u64

@[inline]
pub fn get_buffer_opaque_capture_address(device C.VkDevice,
	p_info &BufferDeviceAddressInfo) u64 {
	return C.vkGetBufferOpaqueCaptureAddress(device, p_info)
}

fn C.vkGetDeviceMemoryOpaqueCaptureAddress(C.VkDevice, &DeviceMemoryOpaqueCaptureAddressInfo) u64

pub type PFN_vkGetDeviceMemoryOpaqueCaptureAddress = fn (C.VkDevice, &DeviceMemoryOpaqueCaptureAddressInfo) u64

@[inline]
pub fn get_device_memory_opaque_capture_address(device C.VkDevice,
	p_info &DeviceMemoryOpaqueCaptureAddressInfo) u64 {
	return C.vkGetDeviceMemoryOpaqueCaptureAddress(device, p_info)
}

// Vulkan 1.3 version number
pub const api_version_1_3 = make_api_version(0, 1, 3, 0) // Patch version should always be set to 0

pub type Flags64 = u64
pub type C.VkPrivateDataSlot = voidptr

pub enum PipelineCreationFeedbackFlagBits {
	valid_bit                          = int(0x00000001)
	application_pipeline_cache_hit_bit = int(0x00000002)
	base_pipeline_acceleration_bit     = int(0x00000004)
	max_enum                           = max_int
}

pub type PipelineCreationFeedbackFlags = u32

pub enum ToolPurposeFlagBits {
	validation_bit          = int(0x00000001)
	profiling_bit           = int(0x00000002)
	tracing_bit             = int(0x00000004)
	additional_features_bit = int(0x00000008)
	modifying_features_bit  = int(0x00000010)
	debug_reporting_bit_ext = int(0x00000020)
	debug_markers_bit_ext   = int(0x00000040)
	max_enum                = max_int
}

pub type ToolPurposeFlags = u32
pub type PrivateDataSlotCreateFlags = u32
pub type PipelineStageFlags2 = u64

// Flag bits for PipelineStageFlagBits2
pub type PipelineStageFlagBits2 = u64

pub const pipeline_stage_2_none = u64(0)
pub const pipeline_stage_2_none_khr = pipeline_stage_2_none
pub const pipeline_stage_2_top_of_pipe_bit = u64(0x00000001)
pub const pipeline_stage_2_top_of_pipe_bit_khr = pipeline_stage_2_top_of_pipe_bit
pub const pipeline_stage_2_draw_indirect_bit = u64(0x00000002)
pub const pipeline_stage_2_draw_indirect_bit_khr = pipeline_stage_2_draw_indirect_bit
pub const pipeline_stage_2_vertex_input_bit = u64(0x00000004)
pub const pipeline_stage_2_vertex_input_bit_khr = u32(pipeline_stage_2_vertex_input_bit)
pub const pipeline_stage_2_vertex_shader_bit = u64(0x00000008)
pub const pipeline_stage_2_vertex_shader_bit_khr = pipeline_stage_2_vertex_shader_bit
pub const pipeline_stage_2_tessellation_control_shader_bit = u64(0x00000010)
pub const pipeline_stage_2_tessellation_control_shader_bit_khr = pipeline_stage_2_tessellation_control_shader_bit
pub const pipeline_stage_2_tessellation_evaluation_shader_bit = u64(0x00000020)
pub const pipeline_stage_2_tessellation_evaluation_shader_bit_khr = u32(pipeline_stage_2_tessellation_evaluation_shader_bit)
pub const pipeline_stage_2_geometry_shader_bit = u64(0x00000040)
pub const pipeline_stage_2_geometry_shader_bit_khr = pipeline_stage_2_geometry_shader_bit
pub const pipeline_stage_2_fragment_shader_bit = u64(0x00000080)
pub const pipeline_stage_2_fragment_shader_bit_khr = pipeline_stage_2_fragment_shader_bit
pub const pipeline_stage_2_early_fragment_tests_bit = u64(0x00000100)
pub const pipeline_stage_2_early_fragment_tests_bit_khr = pipeline_stage_2_early_fragment_tests_bit
pub const pipeline_stage_2_late_fragment_tests_bit = u64(0x00000200)
pub const pipeline_stage_2_late_fragment_tests_bit_khr = pipeline_stage_2_late_fragment_tests_bit
pub const pipeline_stage_2_color_attachment_output_bit = u64(0x00000400)
pub const pipeline_stage_2_color_attachment_output_bit_khr = u32(pipeline_stage_2_color_attachment_output_bit)
pub const pipeline_stage_2_compute_shader_bit = u64(0x00000800)
pub const pipeline_stage_2_compute_shader_bit_khr = u32(pipeline_stage_2_compute_shader_bit)
pub const pipeline_stage_2_all_transfer_bit = u64(0x00001000)
pub const pipeline_stage_2_all_transfer_bit_khr = pipeline_stage_2_all_transfer_bit
pub const pipeline_stage_2_transfer_bit = pipeline_stage_2_all_transfer_bit_khr
pub const pipeline_stage_2_transfer_bit_khr = pipeline_stage_2_all_transfer_bit
pub const pipeline_stage_2_bottom_of_pipe_bit = u64(0x00002000)
pub const pipeline_stage_2_bottom_of_pipe_bit_khr = pipeline_stage_2_bottom_of_pipe_bit
pub const pipeline_stage_2_host_bit = u64(0x00004000)
pub const pipeline_stage_2_host_bit_khr = pipeline_stage_2_host_bit
pub const pipeline_stage_2_all_graphics_bit = u64(0x00008000)
pub const pipeline_stage_2_all_graphics_bit_khr = pipeline_stage_2_all_graphics_bit
pub const pipeline_stage_2_all_commands_bit = u64(0x00010000)
pub const pipeline_stage_2_all_commands_bit_khr = pipeline_stage_2_all_commands_bit
pub const pipeline_stage_2_copy_bit = u64(0x100000000)
pub const pipeline_stage_2_copy_bit_khr = pipeline_stage_2_copy_bit
pub const pipeline_stage_2_resolve_bit = u64(0x200000000)
pub const pipeline_stage_2_resolve_bit_khr = pipeline_stage_2_resolve_bit
pub const pipeline_stage_2_blit_bit = u64(0x400000000)
pub const pipeline_stage_2_blit_bit_khr = pipeline_stage_2_blit_bit
pub const pipeline_stage_2_clear_bit = u64(0x800000000)
pub const pipeline_stage_2_clear_bit_khr = pipeline_stage_2_clear_bit
pub const pipeline_stage_2_index_input_bit = u64(0x1000000000)
pub const pipeline_stage_2_index_input_bit_khr = u32(pipeline_stage_2_index_input_bit)
pub const pipeline_stage_2_vertex_attribute_input_bit = u64(0x2000000000)
pub const pipeline_stage_2_vertex_attribute_input_bit_khr = u32(pipeline_stage_2_vertex_attribute_input_bit)
pub const pipeline_stage_2_pre_rasterization_shaders_bit = u64(0x4000000000)
pub const pipeline_stage_2_pre_rasterization_shaders_bit_khr = pipeline_stage_2_pre_rasterization_shaders_bit
pub const pipeline_stage_2_video_decode_bit_khr = u64(0x04000000)
pub const pipeline_stage_2_video_encode_bit_khr = u64(0x08000000)
pub const pipeline_stage_2_transform_feedback_bit_ext = u64(0x01000000)
pub const pipeline_stage_2_conditional_rendering_bit_ext = u64(0x00040000)
pub const pipeline_stage_2_command_preprocess_bit_nv = u64(0x00020000)
pub const pipeline_stage_2_fragment_shading_rate_attachment_bit_khr = u64(0x00400000)
pub const pipeline_stage_2_shading_rate_image_bit_nv = pipeline_stage_2_fragment_shading_rate_attachment_bit_khr
pub const pipeline_stage_2_acceleration_structure_build_bit_khr = u64(0x02000000)
pub const pipeline_stage_2_ray_tracing_shader_bit_khr = u64(0x00200000)
pub const pipeline_stage_2_ray_tracing_shader_bit_nv = pipeline_stage_2_ray_tracing_shader_bit_khr
pub const pipeline_stage_2_acceleration_structure_build_bit_nv = u32(pipeline_stage_2_acceleration_structure_build_bit_khr)
pub const pipeline_stage_2_fragment_density_process_bit_ext = u64(0x00800000)
pub const pipeline_stage_2_task_shader_bit_nv = pipeline_stage_2_task_shader_bit_ext
pub const pipeline_stage_2_mesh_shader_bit_nv = pipeline_stage_2_mesh_shader_bit_ext
pub const pipeline_stage_2_task_shader_bit_ext = u64(0x00080000)
pub const pipeline_stage_2_mesh_shader_bit_ext = u64(0x00100000)
pub const pipeline_stage_2_subpass_shader_bit_huawei = u64(0x8000000000)
// VK_PIPELINE_STAGE_2_SUBPASS_SHADING_BIT_HUAWEI is a deprecated alias
pub const pipeline_stage_2_subpass_shading_bit_huawei = u32(pipeline_stage_2_subpass_shader_bit_huawei)
pub const pipeline_stage_2_invocation_mask_bit_huawei = u64(0x10000000000)
pub const pipeline_stage_2_acceleration_structure_copy_bit_khr = u64(0x10000000)
pub const pipeline_stage_2_micromap_build_bit_ext = u64(0x40000000)
pub const pipeline_stage_2_cluster_culling_shader_bit_huawei = u64(0x20000000000)
pub const pipeline_stage_2_optical_flow_bit_nv = u64(0x20000000)

pub type AccessFlags2 = u64

// Flag bits for AccessFlagBits2
pub type AccessFlagBits2 = u64

pub const access_2_none = u64(0)
pub const access_2_none_khr = access_2_none
pub const access_2_indirect_command_read_bit = u64(0x00000001)
pub const access_2_indirect_command_read_bit_khr = access_2_indirect_command_read_bit
pub const access_2_index_read_bit = u64(0x00000002)
pub const access_2_index_read_bit_khr = access_2_index_read_bit
pub const access_2_vertex_attribute_read_bit = u64(0x00000004)
pub const access_2_vertex_attribute_read_bit_khr = u32(access_2_vertex_attribute_read_bit)
pub const access_2_uniform_read_bit = u64(0x00000008)
pub const access_2_uniform_read_bit_khr = u32(access_2_uniform_read_bit)
pub const access_2_input_attachment_read_bit = u64(0x00000010)
pub const access_2_input_attachment_read_bit_khr = u32(access_2_input_attachment_read_bit)
pub const access_2_shader_read_bit = u64(0x00000020)
pub const access_2_shader_read_bit_khr = access_2_shader_read_bit
pub const access_2_shader_write_bit = u64(0x00000040)
pub const access_2_shader_write_bit_khr = access_2_shader_write_bit
pub const access_2_color_attachment_read_bit = u64(0x00000080)
pub const access_2_color_attachment_read_bit_khr = access_2_color_attachment_read_bit
pub const access_2_color_attachment_write_bit = u64(0x00000100)
pub const access_2_color_attachment_write_bit_khr = access_2_color_attachment_write_bit
pub const access_2_depth_stencil_attachment_read_bit = u64(0x00000200)
pub const access_2_depth_stencil_attachment_read_bit_khr = access_2_depth_stencil_attachment_read_bit
pub const access_2_depth_stencil_attachment_write_bit = u64(0x00000400)
pub const access_2_depth_stencil_attachment_write_bit_khr = access_2_depth_stencil_attachment_write_bit
pub const access_2_transfer_read_bit = u64(0x00000800)
pub const access_2_transfer_read_bit_khr = access_2_transfer_read_bit
pub const access_2_transfer_write_bit = u64(0x00001000)
pub const access_2_transfer_write_bit_khr = access_2_transfer_write_bit
pub const access_2_host_read_bit = u64(0x00002000)
pub const access_2_host_read_bit_khr = access_2_host_read_bit
pub const access_2_host_write_bit = u64(0x00004000)
pub const access_2_host_write_bit_khr = access_2_host_write_bit
pub const access_2_memory_read_bit = u64(0x00008000)
pub const access_2_memory_read_bit_khr = access_2_memory_read_bit
pub const access_2_memory_write_bit = u64(0x00010000)
pub const access_2_memory_write_bit_khr = access_2_memory_write_bit
pub const access_2_shader_sampled_read_bit = u64(0x100000000)
pub const access_2_shader_sampled_read_bit_khr = access_2_shader_sampled_read_bit
pub const access_2_shader_storage_read_bit = u64(0x200000000)
pub const access_2_shader_storage_read_bit_khr = access_2_shader_storage_read_bit
pub const access_2_shader_storage_write_bit = u64(0x400000000)
pub const access_2_shader_storage_write_bit_khr = access_2_shader_storage_write_bit
pub const access_2_video_decode_read_bit_khr = u64(0x800000000)
pub const access_2_video_decode_write_bit_khr = u64(0x1000000000)
pub const access_2_video_encode_read_bit_khr = u64(0x2000000000)
pub const access_2_video_encode_write_bit_khr = u64(0x4000000000)
pub const access_2_transform_feedback_write_bit_ext = u64(0x02000000)
pub const access_2_transform_feedback_counter_read_bit_ext = u64(0x04000000)
pub const access_2_transform_feedback_counter_write_bit_ext = u64(0x08000000)
pub const access_2_conditional_rendering_read_bit_ext = u64(0x00100000)
pub const access_2_command_preprocess_read_bit_nv = u64(0x00020000)
pub const access_2_command_preprocess_write_bit_nv = u64(0x00040000)
pub const access_2_fragment_shading_rate_attachment_read_bit_khr = u64(0x00800000)
pub const access_2_shading_rate_image_read_bit_nv = access_2_fragment_shading_rate_attachment_read_bit_khr
pub const access_2_acceleration_structure_read_bit_khr = u64(0x00200000)
pub const access_2_acceleration_structure_write_bit_khr = u64(0x00400000)
pub const access_2_acceleration_structure_read_bit_nv = u32(access_2_acceleration_structure_read_bit_khr)
pub const access_2_acceleration_structure_write_bit_nv = u32(access_2_acceleration_structure_write_bit_khr)
pub const access_2_fragment_density_map_read_bit_ext = u64(0x01000000)
pub const access_2_color_attachment_read_noncoherent_bit_ext = u64(0x00080000)
pub const access_2_descriptor_buffer_read_bit_ext = u64(0x20000000000)
pub const access_2_invocation_mask_read_bit_huawei = u64(0x8000000000)
pub const access_2_shader_binding_table_read_bit_khr = u64(0x10000000000)
pub const access_2_micromap_read_bit_ext = u64(0x100000000000)
pub const access_2_micromap_write_bit_ext = u64(0x200000000000)
pub const access_2_optical_flow_read_bit_nv = u64(0x40000000000)
pub const access_2_optical_flow_write_bit_nv = u64(0x80000000000)

pub enum SubmitFlagBits {
	protected_bit = int(0x00000001)
	max_enum      = max_int
}

pub type SubmitFlags = u32

pub enum RenderingFlagBits {
	contents_secondary_command_buffers_bit = int(0x00000001)
	suspending_bit                         = int(0x00000002)
	resuming_bit                           = int(0x00000004)
	contents_inline_bit_ext                = int(0x00000010)
	enable_legacy_dithering_bit_ext        = int(0x00000008)
	max_enum                               = max_int
}

pub type RenderingFlags = u32
pub type FormatFeatureFlags2 = u64

// Flag bits for FormatFeatureFlagBits2
pub type FormatFeatureFlagBits2 = u64

pub const format_feature_2_sampled_image_bit = u64(0x00000001)
pub const format_feature_2_sampled_image_bit_khr = u32(format_feature_2_sampled_image_bit)
pub const format_feature_2_storage_image_bit = u64(0x00000002)
pub const format_feature_2_storage_image_bit_khr = u32(format_feature_2_storage_image_bit)
pub const format_feature_2_storage_image_atomic_bit = u64(0x00000004)
pub const format_feature_2_storage_image_atomic_bit_khr = u32(format_feature_2_storage_image_atomic_bit)
pub const format_feature_2_uniform_texel_buffer_bit = u64(0x00000008)
pub const format_feature_2_uniform_texel_buffer_bit_khr = u32(format_feature_2_uniform_texel_buffer_bit)
pub const format_feature_2_storage_texel_buffer_bit = u64(0x00000010)
pub const format_feature_2_storage_texel_buffer_bit_khr = u32(format_feature_2_storage_texel_buffer_bit)
pub const format_feature_2_storage_texel_buffer_atomic_bit = u64(0x00000020)
pub const format_feature_2_storage_texel_buffer_atomic_bit_khr = u32(format_feature_2_storage_texel_buffer_atomic_bit)
pub const format_feature_2_vertex_buffer_bit = u64(0x00000040)
pub const format_feature_2_vertex_buffer_bit_khr = u32(format_feature_2_vertex_buffer_bit)
pub const format_feature_2_color_attachment_bit = u64(0x00000080)
pub const format_feature_2_color_attachment_bit_khr = u32(format_feature_2_color_attachment_bit)
pub const format_feature_2_color_attachment_blend_bit = u64(0x00000100)
pub const format_feature_2_color_attachment_blend_bit_khr = u32(format_feature_2_color_attachment_blend_bit)
pub const format_feature_2_depth_stencil_attachment_bit = u64(0x00000200)
pub const format_feature_2_depth_stencil_attachment_bit_khr = u32(format_feature_2_depth_stencil_attachment_bit)
pub const format_feature_2_blit_src_bit = u64(0x00000400)
pub const format_feature_2_blit_src_bit_khr = u32(format_feature_2_blit_src_bit)
pub const format_feature_2_blit_dst_bit = u64(0x00000800)
pub const format_feature_2_blit_dst_bit_khr = u32(format_feature_2_blit_dst_bit)
pub const format_feature_2_sampled_image_filter_linear_bit = u64(0x00001000)
pub const format_feature_2_sampled_image_filter_linear_bit_khr = u32(format_feature_2_sampled_image_filter_linear_bit)
pub const format_feature_2_sampled_image_filter_cubic_bit = u64(0x00002000)
pub const format_feature_2_sampled_image_filter_cubic_bit_ext = u32(format_feature_2_sampled_image_filter_cubic_bit)
pub const format_feature_2_transfer_src_bit = u64(0x00004000)
pub const format_feature_2_transfer_src_bit_khr = u32(format_feature_2_transfer_src_bit)
pub const format_feature_2_transfer_dst_bit = u64(0x00008000)
pub const format_feature_2_transfer_dst_bit_khr = u32(format_feature_2_transfer_dst_bit)
pub const format_feature_2_sampled_image_filter_minmax_bit = u64(0x00010000)
pub const format_feature_2_sampled_image_filter_minmax_bit_khr = u32(format_feature_2_sampled_image_filter_minmax_bit)
pub const format_feature_2_midpoint_chroma_samples_bit = u64(0x00020000)
pub const format_feature_2_midpoint_chroma_samples_bit_khr = u32(format_feature_2_midpoint_chroma_samples_bit)
pub const format_feature_2_sampled_image_ycbcr_conversion_linear_filter_bit = u64(0x00040000)
pub const format_feature_2_sampled_image_ycbcr_conversion_linear_filter_bit_khr = u32(format_feature_2_sampled_image_ycbcr_conversion_linear_filter_bit)
pub const format_feature_2_sampled_image_ycbcr_conversion_separate_reconstruction_filter_bit = u64(0x00080000)
pub const format_feature_2_sampled_image_ycbcr_conversion_separate_reconstruction_filter_bit_khr = u32(format_feature_2_sampled_image_ycbcr_conversion_separate_reconstruction_filter_bit)
pub const format_feature_2_sampled_image_ycbcr_conversion_chroma_reconstruction_explicit_bit = u64(0x00100000)
pub const format_feature_2_sampled_image_ycbcr_conversion_chroma_reconstruction_explicit_bit_khr = u32(format_feature_2_sampled_image_ycbcr_conversion_chroma_reconstruction_explicit_bit)
pub const format_feature_2_sampled_image_ycbcr_conversion_chroma_reconstruction_explicit_forceable_bit = u64(0x00200000)
pub const format_feature_2_sampled_image_ycbcr_conversion_chroma_reconstruction_explicit_forceable_bit_khr = u32(format_feature_2_sampled_image_ycbcr_conversion_chroma_reconstruction_explicit_forceable_bit)
pub const format_feature_2_disjoint_bit = u64(0x00400000)
pub const format_feature_2_disjoint_bit_khr = u32(format_feature_2_disjoint_bit)
pub const format_feature_2_cosited_chroma_samples_bit = u64(0x00800000)
pub const format_feature_2_cosited_chroma_samples_bit_khr = u32(format_feature_2_cosited_chroma_samples_bit)
pub const format_feature_2_storage_read_without_format_bit = u64(0x80000000)
pub const format_feature_2_storage_read_without_format_bit_khr = u32(format_feature_2_storage_read_without_format_bit)
pub const format_feature_2_storage_write_without_format_bit = u64(0x100000000)
pub const format_feature_2_storage_write_without_format_bit_khr = u32(format_feature_2_storage_write_without_format_bit)
pub const format_feature_2_sampled_image_depth_comparison_bit = u64(0x200000000)
pub const format_feature_2_sampled_image_depth_comparison_bit_khr = u32(format_feature_2_sampled_image_depth_comparison_bit)
pub const format_feature_2_video_decode_output_bit_khr = u64(0x02000000)
pub const format_feature_2_video_decode_dpb_bit_khr = u64(0x04000000)
pub const format_feature_2_acceleration_structure_vertex_buffer_bit_khr = u64(0x20000000)
pub const format_feature_2_fragment_density_map_bit_ext = u64(0x01000000)
pub const format_feature_2_fragment_shading_rate_attachment_bit_khr = u64(0x40000000)
pub const format_feature_2_host_image_transfer_bit_ext = u64(0x400000000000)
pub const format_feature_2_video_encode_input_bit_khr = u64(0x08000000)
pub const format_feature_2_video_encode_dpb_bit_khr = u64(0x10000000)
pub const format_feature_2_linear_color_attachment_bit_nv = u64(0x4000000000)
pub const format_feature_2_weight_image_bit_qcom = u64(0x400000000)
pub const format_feature_2_weight_sampled_image_bit_qcom = u64(0x800000000)
pub const format_feature_2_block_matching_bit_qcom = u64(0x1000000000)
pub const format_feature_2_box_filter_sampled_bit_qcom = u64(0x2000000000)
pub const format_feature_2_optical_flow_image_bit_nv = u64(0x10000000000)
pub const format_feature_2_optical_flow_vector_bit_nv = u64(0x20000000000)
pub const format_feature_2_optical_flow_cost_bit_nv = u64(0x40000000000)

pub type PhysicalDeviceVulkan13Features = C.VkPhysicalDeviceVulkan13Features

@[typedef]
pub struct C.VkPhysicalDeviceVulkan13Features {
pub mut:
	sType                                              StructureType
	pNext                                              voidptr = unsafe { nil }
	robustImageAccess                                  Bool32
	inlineUniformBlock                                 Bool32
	descriptorBindingInlineUniformBlockUpdateAfterBind Bool32
	pipelineCreationCacheControl                       Bool32
	privateData                                        Bool32
	shaderDemoteToHelperInvocation                     Bool32
	shaderTerminateInvocation                          Bool32
	subgroupSizeControl                                Bool32
	computeFullSubgroups                               Bool32
	synchronization2                                   Bool32
	textureCompressionASTC_HDR                         Bool32
	shaderZeroInitializeWorkgroupMemory                Bool32
	dynamicRendering                                   Bool32
	shaderIntegerDotProduct                            Bool32
	maintenance4                                       Bool32
}

pub type PhysicalDeviceVulkan13Properties = C.VkPhysicalDeviceVulkan13Properties

@[typedef]
pub struct C.VkPhysicalDeviceVulkan13Properties {
pub mut:
	sType                                                                         StructureType
	pNext                                                                         voidptr = unsafe { nil }
	minSubgroupSize                                                               u32
	maxSubgroupSize                                                               u32
	maxComputeWorkgroupSubgroups                                                  u32
	requiredSubgroupSizeStages                                                    ShaderStageFlags
	maxInlineUniformBlockSize                                                     u32
	maxPerStageDescriptorInlineUniformBlocks                                      u32
	maxPerStageDescriptorUpdateAfterBindInlineUniformBlocks                       u32
	maxDescriptorSetInlineUniformBlocks                                           u32
	maxDescriptorSetUpdateAfterBindInlineUniformBlocks                            u32
	maxInlineUniformTotalSize                                                     u32
	integerDotProduct8BitUnsignedAccelerated                                      Bool32
	integerDotProduct8BitSignedAccelerated                                        Bool32
	integerDotProduct8BitMixedSignednessAccelerated                               Bool32
	integerDotProduct4x8BitPackedUnsignedAccelerated                              Bool32
	integerDotProduct4x8BitPackedSignedAccelerated                                Bool32
	integerDotProduct4x8BitPackedMixedSignednessAccelerated                       Bool32
	integerDotProduct16BitUnsignedAccelerated                                     Bool32
	integerDotProduct16BitSignedAccelerated                                       Bool32
	integerDotProduct16BitMixedSignednessAccelerated                              Bool32
	integerDotProduct32BitUnsignedAccelerated                                     Bool32
	integerDotProduct32BitSignedAccelerated                                       Bool32
	integerDotProduct32BitMixedSignednessAccelerated                              Bool32
	integerDotProduct64BitUnsignedAccelerated                                     Bool32
	integerDotProduct64BitSignedAccelerated                                       Bool32
	integerDotProduct64BitMixedSignednessAccelerated                              Bool32
	integerDotProductAccumulatingSaturating8BitUnsignedAccelerated                Bool32
	integerDotProductAccumulatingSaturating8BitSignedAccelerated                  Bool32
	integerDotProductAccumulatingSaturating8BitMixedSignednessAccelerated         Bool32
	integerDotProductAccumulatingSaturating4x8BitPackedUnsignedAccelerated        Bool32
	integerDotProductAccumulatingSaturating4x8BitPackedSignedAccelerated          Bool32
	integerDotProductAccumulatingSaturating4x8BitPackedMixedSignednessAccelerated Bool32
	integerDotProductAccumulatingSaturating16BitUnsignedAccelerated               Bool32
	integerDotProductAccumulatingSaturating16BitSignedAccelerated                 Bool32
	integerDotProductAccumulatingSaturating16BitMixedSignednessAccelerated        Bool32
	integerDotProductAccumulatingSaturating32BitUnsignedAccelerated               Bool32
	integerDotProductAccumulatingSaturating32BitSignedAccelerated                 Bool32
	integerDotProductAccumulatingSaturating32BitMixedSignednessAccelerated        Bool32
	integerDotProductAccumulatingSaturating64BitUnsignedAccelerated               Bool32
	integerDotProductAccumulatingSaturating64BitSignedAccelerated                 Bool32
	integerDotProductAccumulatingSaturating64BitMixedSignednessAccelerated        Bool32
	storageTexelBufferOffsetAlignmentBytes                                        DeviceSize
	storageTexelBufferOffsetSingleTexelAlignment                                  Bool32
	uniformTexelBufferOffsetAlignmentBytes                                        DeviceSize
	uniformTexelBufferOffsetSingleTexelAlignment                                  Bool32
	maxBufferSize                                                                 DeviceSize
}

pub type PipelineCreationFeedback = C.VkPipelineCreationFeedback

@[typedef]
pub struct C.VkPipelineCreationFeedback {
pub mut:
	flags    PipelineCreationFeedbackFlags
	duration u64
}

pub type PipelineCreationFeedbackCreateInfo = C.VkPipelineCreationFeedbackCreateInfo

@[typedef]
pub struct C.VkPipelineCreationFeedbackCreateInfo {
pub mut:
	sType                              StructureType = StructureType.pipeline_creation_feedback_create_info
	pNext                              voidptr       = unsafe { nil }
	pPipelineCreationFeedback          &PipelineCreationFeedback
	pipelineStageCreationFeedbackCount u32
	pPipelineStageCreationFeedbacks    &PipelineCreationFeedback
}

pub type PhysicalDeviceShaderTerminateInvocationFeatures = C.VkPhysicalDeviceShaderTerminateInvocationFeatures

@[typedef]
pub struct C.VkPhysicalDeviceShaderTerminateInvocationFeatures {
pub mut:
	sType                     StructureType = StructureType.physical_device_shader_terminate_invocation_features
	pNext                     voidptr       = unsafe { nil }
	shaderTerminateInvocation Bool32
}

pub type PhysicalDeviceToolProperties = C.VkPhysicalDeviceToolProperties

@[typedef]
pub struct C.VkPhysicalDeviceToolProperties {
pub mut:
	sType       StructureType = StructureType.physical_device_tool_properties
	pNext       voidptr       = unsafe { nil }
	name        [max_extension_name_size]char
	version     [max_extension_name_size]char
	purposes    ToolPurposeFlags
	description [max_description_size]char
	layer       [max_extension_name_size]char
}

pub type PhysicalDeviceShaderDemoteToHelperInvocationFeatures = C.VkPhysicalDeviceShaderDemoteToHelperInvocationFeatures

@[typedef]
pub struct C.VkPhysicalDeviceShaderDemoteToHelperInvocationFeatures {
pub mut:
	sType                          StructureType = StructureType.physical_device_shader_demote_to_helper_invocation_features
	pNext                          voidptr       = unsafe { nil }
	shaderDemoteToHelperInvocation Bool32
}

pub type PhysicalDevicePrivateDataFeatures = C.VkPhysicalDevicePrivateDataFeatures

@[typedef]
pub struct C.VkPhysicalDevicePrivateDataFeatures {
pub mut:
	sType       StructureType = StructureType.physical_device_private_data_features
	pNext       voidptr       = unsafe { nil }
	privateData Bool32
}

pub type DevicePrivateDataCreateInfo = C.VkDevicePrivateDataCreateInfo

@[typedef]
pub struct C.VkDevicePrivateDataCreateInfo {
pub mut:
	sType                       StructureType = StructureType.device_private_data_create_info
	pNext                       voidptr       = unsafe { nil }
	privateDataSlotRequestCount u32
}

pub type PrivateDataSlotCreateInfo = C.VkPrivateDataSlotCreateInfo

@[typedef]
pub struct C.VkPrivateDataSlotCreateInfo {
pub mut:
	sType StructureType = StructureType.private_data_slot_create_info
	pNext voidptr       = unsafe { nil }
	flags PrivateDataSlotCreateFlags
}

pub type PhysicalDevicePipelineCreationCacheControlFeatures = C.VkPhysicalDevicePipelineCreationCacheControlFeatures

@[typedef]
pub struct C.VkPhysicalDevicePipelineCreationCacheControlFeatures {
pub mut:
	sType                        StructureType = StructureType.physical_device_pipeline_creation_cache_control_features
	pNext                        voidptr       = unsafe { nil }
	pipelineCreationCacheControl Bool32
}

pub type MemoryBarrier2 = C.VkMemoryBarrier2

@[typedef]
pub struct C.VkMemoryBarrier2 {
pub mut:
	sType         StructureType = StructureType.memory_barrier2
	pNext         voidptr       = unsafe { nil }
	srcStageMask  PipelineStageFlags2
	srcAccessMask AccessFlags2
	dstStageMask  PipelineStageFlags2
	dstAccessMask AccessFlags2
}

pub type BufferMemoryBarrier2 = C.VkBufferMemoryBarrier2

@[typedef]
pub struct C.VkBufferMemoryBarrier2 {
pub mut:
	sType               StructureType = StructureType.buffer_memory_barrier2
	pNext               voidptr       = unsafe { nil }
	srcStageMask        PipelineStageFlags2
	srcAccessMask       AccessFlags2
	dstStageMask        PipelineStageFlags2
	dstAccessMask       AccessFlags2
	srcQueueFamilyIndex u32
	dstQueueFamilyIndex u32
	buffer              C.VkBuffer
	offset              DeviceSize
	size                DeviceSize
}

pub type ImageMemoryBarrier2 = C.VkImageMemoryBarrier2

@[typedef]
pub struct C.VkImageMemoryBarrier2 {
pub mut:
	sType               StructureType = StructureType.image_memory_barrier2
	pNext               voidptr       = unsafe { nil }
	srcStageMask        PipelineStageFlags2
	srcAccessMask       AccessFlags2
	dstStageMask        PipelineStageFlags2
	dstAccessMask       AccessFlags2
	oldLayout           ImageLayout
	newLayout           ImageLayout
	srcQueueFamilyIndex u32
	dstQueueFamilyIndex u32
	image               C.VkImage
	subresourceRange    ImageSubresourceRange
}

pub type DependencyInfo = C.VkDependencyInfo

@[typedef]
pub struct C.VkDependencyInfo {
pub mut:
	sType                    StructureType = StructureType.dependency_info
	pNext                    voidptr       = unsafe { nil }
	dependencyFlags          DependencyFlags
	memoryBarrierCount       u32
	pMemoryBarriers          &MemoryBarrier2
	bufferMemoryBarrierCount u32
	pBufferMemoryBarriers    &BufferMemoryBarrier2
	imageMemoryBarrierCount  u32
	pImageMemoryBarriers     &ImageMemoryBarrier2
}

pub type SemaphoreSubmitInfo = C.VkSemaphoreSubmitInfo

@[typedef]
pub struct C.VkSemaphoreSubmitInfo {
pub mut:
	sType       StructureType = StructureType.semaphore_submit_info
	pNext       voidptr       = unsafe { nil }
	semaphore   C.VkSemaphore
	value       u64
	stageMask   PipelineStageFlags2
	deviceIndex u32
}

pub type CommandBufferSubmitInfo = C.VkCommandBufferSubmitInfo

@[typedef]
pub struct C.VkCommandBufferSubmitInfo {
pub mut:
	sType         StructureType = StructureType.command_buffer_submit_info
	pNext         voidptr       = unsafe { nil }
	commandBuffer C.VkCommandBuffer
	deviceMask    u32
}

pub type SubmitInfo2 = C.VkSubmitInfo2

@[typedef]
pub struct C.VkSubmitInfo2 {
pub mut:
	sType                    StructureType = StructureType.submit_info2
	pNext                    voidptr       = unsafe { nil }
	flags                    SubmitFlags
	waitSemaphoreInfoCount   u32
	pWaitSemaphoreInfos      &SemaphoreSubmitInfo
	commandBufferInfoCount   u32
	pCommandBufferInfos      &CommandBufferSubmitInfo
	signalSemaphoreInfoCount u32
	pSignalSemaphoreInfos    &SemaphoreSubmitInfo
}

pub type PhysicalDeviceSynchronization2Features = C.VkPhysicalDeviceSynchronization2Features

@[typedef]
pub struct C.VkPhysicalDeviceSynchronization2Features {
pub mut:
	sType            StructureType = StructureType.physical_device_synchronization2_features
	pNext            voidptr       = unsafe { nil }
	synchronization2 Bool32
}

pub type PhysicalDeviceZeroInitializeWorkgroupMemoryFeatures = C.VkPhysicalDeviceZeroInitializeWorkgroupMemoryFeatures

@[typedef]
pub struct C.VkPhysicalDeviceZeroInitializeWorkgroupMemoryFeatures {
pub mut:
	sType                               StructureType = StructureType.physical_device_zero_initialize_workgroup_memory_features
	pNext                               voidptr       = unsafe { nil }
	shaderZeroInitializeWorkgroupMemory Bool32
}

pub type PhysicalDeviceImageRobustnessFeatures = C.VkPhysicalDeviceImageRobustnessFeatures

@[typedef]
pub struct C.VkPhysicalDeviceImageRobustnessFeatures {
pub mut:
	sType             StructureType = StructureType.physical_device_image_robustness_features
	pNext             voidptr       = unsafe { nil }
	robustImageAccess Bool32
}

pub type BufferCopy2 = C.VkBufferCopy2

@[typedef]
pub struct C.VkBufferCopy2 {
pub mut:
	sType     StructureType = StructureType.buffer_copy2
	pNext     voidptr       = unsafe { nil }
	srcOffset DeviceSize
	dstOffset DeviceSize
	size      DeviceSize
}

pub type CopyBufferInfo2 = C.VkCopyBufferInfo2

@[typedef]
pub struct C.VkCopyBufferInfo2 {
pub mut:
	sType       StructureType = StructureType.copy_buffer_info2
	pNext       voidptr       = unsafe { nil }
	srcBuffer   C.VkBuffer
	dstBuffer   C.VkBuffer
	regionCount u32
	pRegions    &BufferCopy2
}

pub type ImageCopy2 = C.VkImageCopy2

@[typedef]
pub struct C.VkImageCopy2 {
pub mut:
	sType          StructureType = StructureType.image_copy2
	pNext          voidptr       = unsafe { nil }
	srcSubresource ImageSubresourceLayers
	srcOffset      Offset3D
	dstSubresource ImageSubresourceLayers
	dstOffset      Offset3D
	extent         Extent3D
}

pub type CopyImageInfo2 = C.VkCopyImageInfo2

@[typedef]
pub struct C.VkCopyImageInfo2 {
pub mut:
	sType          StructureType = StructureType.copy_image_info2
	pNext          voidptr       = unsafe { nil }
	srcImage       C.VkImage
	srcImageLayout ImageLayout
	dstImage       C.VkImage
	dstImageLayout ImageLayout
	regionCount    u32
	pRegions       &ImageCopy2
}

pub type BufferImageCopy2 = C.VkBufferImageCopy2

@[typedef]
pub struct C.VkBufferImageCopy2 {
pub mut:
	sType             StructureType = StructureType.buffer_image_copy2
	pNext             voidptr       = unsafe { nil }
	bufferOffset      DeviceSize
	bufferRowLength   u32
	bufferImageHeight u32
	imageSubresource  ImageSubresourceLayers
	imageOffset       Offset3D
	imageExtent       Extent3D
}

pub type CopyBufferToImageInfo2 = C.VkCopyBufferToImageInfo2

@[typedef]
pub struct C.VkCopyBufferToImageInfo2 {
pub mut:
	sType          StructureType = StructureType.copy_buffer_to_image_info2
	pNext          voidptr       = unsafe { nil }
	srcBuffer      C.VkBuffer
	dstImage       C.VkImage
	dstImageLayout ImageLayout
	regionCount    u32
	pRegions       &BufferImageCopy2
}

pub type CopyImageToBufferInfo2 = C.VkCopyImageToBufferInfo2

@[typedef]
pub struct C.VkCopyImageToBufferInfo2 {
pub mut:
	sType          StructureType = StructureType.copy_image_to_buffer_info2
	pNext          voidptr       = unsafe { nil }
	srcImage       C.VkImage
	srcImageLayout ImageLayout
	dstBuffer      C.VkBuffer
	regionCount    u32
	pRegions       &BufferImageCopy2
}

pub type ImageBlit2 = C.VkImageBlit2

@[typedef]
pub struct C.VkImageBlit2 {
pub mut:
	sType          StructureType = StructureType.image_blit2
	pNext          voidptr       = unsafe { nil }
	srcSubresource ImageSubresourceLayers
	srcOffsets     [2]Offset3D
	dstSubresource ImageSubresourceLayers
	dstOffsets     [2]Offset3D
}

pub type BlitImageInfo2 = C.VkBlitImageInfo2

@[typedef]
pub struct C.VkBlitImageInfo2 {
pub mut:
	sType          StructureType = StructureType.blit_image_info2
	pNext          voidptr       = unsafe { nil }
	srcImage       C.VkImage
	srcImageLayout ImageLayout
	dstImage       C.VkImage
	dstImageLayout ImageLayout
	regionCount    u32
	pRegions       &ImageBlit2
	filter         Filter
}

pub type ImageResolve2 = C.VkImageResolve2

@[typedef]
pub struct C.VkImageResolve2 {
pub mut:
	sType          StructureType = StructureType.image_resolve2
	pNext          voidptr       = unsafe { nil }
	srcSubresource ImageSubresourceLayers
	srcOffset      Offset3D
	dstSubresource ImageSubresourceLayers
	dstOffset      Offset3D
	extent         Extent3D
}

pub type ResolveImageInfo2 = C.VkResolveImageInfo2

@[typedef]
pub struct C.VkResolveImageInfo2 {
pub mut:
	sType          StructureType = StructureType.resolve_image_info2
	pNext          voidptr       = unsafe { nil }
	srcImage       C.VkImage
	srcImageLayout ImageLayout
	dstImage       C.VkImage
	dstImageLayout ImageLayout
	regionCount    u32
	pRegions       &ImageResolve2
}

pub type PhysicalDeviceSubgroupSizeControlFeatures = C.VkPhysicalDeviceSubgroupSizeControlFeatures

@[typedef]
pub struct C.VkPhysicalDeviceSubgroupSizeControlFeatures {
pub mut:
	sType                StructureType = StructureType.physical_device_subgroup_size_control_features
	pNext                voidptr       = unsafe { nil }
	subgroupSizeControl  Bool32
	computeFullSubgroups Bool32
}

pub type PhysicalDeviceSubgroupSizeControlProperties = C.VkPhysicalDeviceSubgroupSizeControlProperties

@[typedef]
pub struct C.VkPhysicalDeviceSubgroupSizeControlProperties {
pub mut:
	sType                        StructureType = StructureType.physical_device_subgroup_size_control_properties
	pNext                        voidptr       = unsafe { nil }
	minSubgroupSize              u32
	maxSubgroupSize              u32
	maxComputeWorkgroupSubgroups u32
	requiredSubgroupSizeStages   ShaderStageFlags
}

pub type PipelineShaderStageRequiredSubgroupSizeCreateInfo = C.VkPipelineShaderStageRequiredSubgroupSizeCreateInfo

@[typedef]
pub struct C.VkPipelineShaderStageRequiredSubgroupSizeCreateInfo {
pub mut:
	sType                StructureType = StructureType.pipeline_shader_stage_required_subgroup_size_create_info
	pNext                voidptr       = unsafe { nil }
	requiredSubgroupSize u32
}

pub type PhysicalDeviceInlineUniformBlockFeatures = C.VkPhysicalDeviceInlineUniformBlockFeatures

@[typedef]
pub struct C.VkPhysicalDeviceInlineUniformBlockFeatures {
pub mut:
	sType                                              StructureType = StructureType.physical_device_inline_uniform_block_features
	pNext                                              voidptr       = unsafe { nil }
	inlineUniformBlock                                 Bool32
	descriptorBindingInlineUniformBlockUpdateAfterBind Bool32
}

pub type PhysicalDeviceInlineUniformBlockProperties = C.VkPhysicalDeviceInlineUniformBlockProperties

@[typedef]
pub struct C.VkPhysicalDeviceInlineUniformBlockProperties {
pub mut:
	sType                                                   StructureType = StructureType.physical_device_inline_uniform_block_properties
	pNext                                                   voidptr       = unsafe { nil }
	maxInlineUniformBlockSize                               u32
	maxPerStageDescriptorInlineUniformBlocks                u32
	maxPerStageDescriptorUpdateAfterBindInlineUniformBlocks u32
	maxDescriptorSetInlineUniformBlocks                     u32
	maxDescriptorSetUpdateAfterBindInlineUniformBlocks      u32
}

pub type WriteDescriptorSetInlineUniformBlock = C.VkWriteDescriptorSetInlineUniformBlock

@[typedef]
pub struct C.VkWriteDescriptorSetInlineUniformBlock {
pub mut:
	sType    StructureType = StructureType.write_descriptor_set_inline_uniform_block
	pNext    voidptr       = unsafe { nil }
	dataSize u32
	pData    voidptr
}

pub type DescriptorPoolInlineUniformBlockCreateInfo = C.VkDescriptorPoolInlineUniformBlockCreateInfo

@[typedef]
pub struct C.VkDescriptorPoolInlineUniformBlockCreateInfo {
pub mut:
	sType                         StructureType = StructureType.descriptor_pool_inline_uniform_block_create_info
	pNext                         voidptr       = unsafe { nil }
	maxInlineUniformBlockBindings u32
}

pub type PhysicalDeviceTextureCompressionASTCHDRFeatures = C.VkPhysicalDeviceTextureCompressionASTCHDRFeatures

@[typedef]
pub struct C.VkPhysicalDeviceTextureCompressionASTCHDRFeatures {
pub mut:
	sType                      StructureType
	pNext                      voidptr = unsafe { nil }
	textureCompressionASTC_HDR Bool32
}

pub type RenderingAttachmentInfo = C.VkRenderingAttachmentInfo

@[typedef]
pub struct C.VkRenderingAttachmentInfo {
pub mut:
	sType              StructureType = StructureType.rendering_attachment_info
	pNext              voidptr       = unsafe { nil }
	imageView          C.VkImageView
	imageLayout        ImageLayout
	resolveMode        ResolveModeFlagBits
	resolveImageView   C.VkImageView
	resolveImageLayout ImageLayout
	loadOp             AttachmentLoadOp
	storeOp            AttachmentStoreOp
	clearValue         ClearValue
}

pub type RenderingInfo = C.VkRenderingInfo

@[typedef]
pub struct C.VkRenderingInfo {
pub mut:
	sType                StructureType = StructureType.rendering_info
	pNext                voidptr       = unsafe { nil }
	flags                RenderingFlags
	renderArea           Rect2D
	layerCount           u32
	viewMask             u32
	colorAttachmentCount u32
	pColorAttachments    &RenderingAttachmentInfo
	pDepthAttachment     &RenderingAttachmentInfo
	pStencilAttachment   &RenderingAttachmentInfo
}

pub type PipelineRenderingCreateInfo = C.VkPipelineRenderingCreateInfo

@[typedef]
pub struct C.VkPipelineRenderingCreateInfo {
pub mut:
	sType                   StructureType = StructureType.pipeline_rendering_create_info
	pNext                   voidptr       = unsafe { nil }
	viewMask                u32
	colorAttachmentCount    u32
	pColorAttachmentFormats &Format
	depthAttachmentFormat   Format
	stencilAttachmentFormat Format
}

pub type PhysicalDeviceDynamicRenderingFeatures = C.VkPhysicalDeviceDynamicRenderingFeatures

@[typedef]
pub struct C.VkPhysicalDeviceDynamicRenderingFeatures {
pub mut:
	sType            StructureType = StructureType.physical_device_dynamic_rendering_features
	pNext            voidptr       = unsafe { nil }
	dynamicRendering Bool32
}

pub type CommandBufferInheritanceRenderingInfo = C.VkCommandBufferInheritanceRenderingInfo

@[typedef]
pub struct C.VkCommandBufferInheritanceRenderingInfo {
pub mut:
	sType                   StructureType = StructureType.command_buffer_inheritance_rendering_info
	pNext                   voidptr       = unsafe { nil }
	flags                   RenderingFlags
	viewMask                u32
	colorAttachmentCount    u32
	pColorAttachmentFormats &Format
	depthAttachmentFormat   Format
	stencilAttachmentFormat Format
	rasterizationSamples    SampleCountFlagBits
}

pub type PhysicalDeviceShaderIntegerDotProductFeatures = C.VkPhysicalDeviceShaderIntegerDotProductFeatures

@[typedef]
pub struct C.VkPhysicalDeviceShaderIntegerDotProductFeatures {
pub mut:
	sType                   StructureType = StructureType.physical_device_shader_integer_dot_product_features
	pNext                   voidptr       = unsafe { nil }
	shaderIntegerDotProduct Bool32
}

pub type PhysicalDeviceShaderIntegerDotProductProperties = C.VkPhysicalDeviceShaderIntegerDotProductProperties

@[typedef]
pub struct C.VkPhysicalDeviceShaderIntegerDotProductProperties {
pub mut:
	sType                                                                         StructureType = StructureType.physical_device_shader_integer_dot_product_properties
	pNext                                                                         voidptr       = unsafe { nil }
	integerDotProduct8BitUnsignedAccelerated                                      Bool32
	integerDotProduct8BitSignedAccelerated                                        Bool32
	integerDotProduct8BitMixedSignednessAccelerated                               Bool32
	integerDotProduct4x8BitPackedUnsignedAccelerated                              Bool32
	integerDotProduct4x8BitPackedSignedAccelerated                                Bool32
	integerDotProduct4x8BitPackedMixedSignednessAccelerated                       Bool32
	integerDotProduct16BitUnsignedAccelerated                                     Bool32
	integerDotProduct16BitSignedAccelerated                                       Bool32
	integerDotProduct16BitMixedSignednessAccelerated                              Bool32
	integerDotProduct32BitUnsignedAccelerated                                     Bool32
	integerDotProduct32BitSignedAccelerated                                       Bool32
	integerDotProduct32BitMixedSignednessAccelerated                              Bool32
	integerDotProduct64BitUnsignedAccelerated                                     Bool32
	integerDotProduct64BitSignedAccelerated                                       Bool32
	integerDotProduct64BitMixedSignednessAccelerated                              Bool32
	integerDotProductAccumulatingSaturating8BitUnsignedAccelerated                Bool32
	integerDotProductAccumulatingSaturating8BitSignedAccelerated                  Bool32
	integerDotProductAccumulatingSaturating8BitMixedSignednessAccelerated         Bool32
	integerDotProductAccumulatingSaturating4x8BitPackedUnsignedAccelerated        Bool32
	integerDotProductAccumulatingSaturating4x8BitPackedSignedAccelerated          Bool32
	integerDotProductAccumulatingSaturating4x8BitPackedMixedSignednessAccelerated Bool32
	integerDotProductAccumulatingSaturating16BitUnsignedAccelerated               Bool32
	integerDotProductAccumulatingSaturating16BitSignedAccelerated                 Bool32
	integerDotProductAccumulatingSaturating16BitMixedSignednessAccelerated        Bool32
	integerDotProductAccumulatingSaturating32BitUnsignedAccelerated               Bool32
	integerDotProductAccumulatingSaturating32BitSignedAccelerated                 Bool32
	integerDotProductAccumulatingSaturating32BitMixedSignednessAccelerated        Bool32
	integerDotProductAccumulatingSaturating64BitUnsignedAccelerated               Bool32
	integerDotProductAccumulatingSaturating64BitSignedAccelerated                 Bool32
	integerDotProductAccumulatingSaturating64BitMixedSignednessAccelerated        Bool32
}

pub type PhysicalDeviceTexelBufferAlignmentProperties = C.VkPhysicalDeviceTexelBufferAlignmentProperties

@[typedef]
pub struct C.VkPhysicalDeviceTexelBufferAlignmentProperties {
pub mut:
	sType                                        StructureType = StructureType.physical_device_texel_buffer_alignment_properties
	pNext                                        voidptr       = unsafe { nil }
	storageTexelBufferOffsetAlignmentBytes       DeviceSize
	storageTexelBufferOffsetSingleTexelAlignment Bool32
	uniformTexelBufferOffsetAlignmentBytes       DeviceSize
	uniformTexelBufferOffsetSingleTexelAlignment Bool32
}

pub type FormatProperties3 = C.VkFormatProperties3

@[typedef]
pub struct C.VkFormatProperties3 {
pub mut:
	sType                 StructureType = StructureType.format_properties3
	pNext                 voidptr       = unsafe { nil }
	linearTilingFeatures  FormatFeatureFlags2
	optimalTilingFeatures FormatFeatureFlags2
	bufferFeatures        FormatFeatureFlags2
}

pub type PhysicalDeviceMaintenance4Features = C.VkPhysicalDeviceMaintenance4Features

@[typedef]
pub struct C.VkPhysicalDeviceMaintenance4Features {
pub mut:
	sType        StructureType = StructureType.physical_device_maintenance4_features
	pNext        voidptr       = unsafe { nil }
	maintenance4 Bool32
}

pub type PhysicalDeviceMaintenance4Properties = C.VkPhysicalDeviceMaintenance4Properties

@[typedef]
pub struct C.VkPhysicalDeviceMaintenance4Properties {
pub mut:
	sType         StructureType = StructureType.physical_device_maintenance4_properties
	pNext         voidptr       = unsafe { nil }
	maxBufferSize DeviceSize
}

pub type DeviceBufferMemoryRequirements = C.VkDeviceBufferMemoryRequirements

@[typedef]
pub struct C.VkDeviceBufferMemoryRequirements {
pub mut:
	sType       StructureType = StructureType.device_buffer_memory_requirements
	pNext       voidptr       = unsafe { nil }
	pCreateInfo &BufferCreateInfo
}

pub type DeviceImageMemoryRequirements = C.VkDeviceImageMemoryRequirements

@[typedef]
pub struct C.VkDeviceImageMemoryRequirements {
pub mut:
	sType       StructureType = StructureType.device_image_memory_requirements
	pNext       voidptr       = unsafe { nil }
	pCreateInfo &ImageCreateInfo
	planeAspect ImageAspectFlagBits
}

fn C.vkGetPhysicalDeviceToolProperties(C.VkPhysicalDevice, &u32, &PhysicalDeviceToolProperties) Result

pub type PFN_vkGetPhysicalDeviceToolProperties = fn (C.VkPhysicalDevice, &u32, &PhysicalDeviceToolProperties) Result

@[inline]
pub fn get_physical_device_tool_properties(physical_device C.VkPhysicalDevice,
	p_tool_count &u32,
	p_tool_properties &PhysicalDeviceToolProperties) Result {
	return C.vkGetPhysicalDeviceToolProperties(physical_device, p_tool_count, p_tool_properties)
}

fn C.vkCreatePrivateDataSlot(C.VkDevice, &PrivateDataSlotCreateInfo, &AllocationCallbacks, C.VkPrivateDataSlot) Result

pub type PFN_vkCreatePrivateDataSlot = fn (C.VkDevice, &PrivateDataSlotCreateInfo, &AllocationCallbacks, C.VkPrivateDataSlot) Result

@[inline]
pub fn create_private_data_slot(device C.VkDevice,
	p_create_info &PrivateDataSlotCreateInfo,
	p_allocator &AllocationCallbacks,
	p_private_data_slot C.VkPrivateDataSlot) Result {
	return C.vkCreatePrivateDataSlot(device, p_create_info, p_allocator, p_private_data_slot)
}

fn C.vkDestroyPrivateDataSlot(C.VkDevice, C.VkPrivateDataSlot, &AllocationCallbacks)

pub type PFN_vkDestroyPrivateDataSlot = fn (C.VkDevice, C.VkPrivateDataSlot, &AllocationCallbacks)

@[inline]
pub fn destroy_private_data_slot(device C.VkDevice,
	private_data_slot C.VkPrivateDataSlot,
	p_allocator &AllocationCallbacks) {
	C.vkDestroyPrivateDataSlot(device, private_data_slot, p_allocator)
}

fn C.vkSetPrivateData(C.VkDevice, ObjectType, u64, C.VkPrivateDataSlot, u64) Result

pub type PFN_vkSetPrivateData = fn (C.VkDevice, ObjectType, u64, C.VkPrivateDataSlot, u64) Result

@[inline]
pub fn set_private_data(device C.VkDevice,
	object_type ObjectType,
	object_handle u64,
	private_data_slot C.VkPrivateDataSlot,
	data u64) Result {
	return C.vkSetPrivateData(device, object_type, object_handle, private_data_slot, data)
}

fn C.vkGetPrivateData(C.VkDevice, ObjectType, u64, C.VkPrivateDataSlot, &u64)

pub type PFN_vkGetPrivateData = fn (C.VkDevice, ObjectType, u64, C.VkPrivateDataSlot, &u64)

@[inline]
pub fn get_private_data(device C.VkDevice,
	object_type ObjectType,
	object_handle u64,
	private_data_slot C.VkPrivateDataSlot,
	p_data &u64) {
	C.vkGetPrivateData(device, object_type, object_handle, private_data_slot, p_data)
}

fn C.vkCmdSetEvent2(C.VkCommandBuffer, C.VkEvent, &DependencyInfo)

pub type PFN_vkCmdSetEvent2 = fn (C.VkCommandBuffer, C.VkEvent, &DependencyInfo)

@[inline]
pub fn cmd_set_event2(command_buffer C.VkCommandBuffer,
	event C.VkEvent,
	p_dependency_info &DependencyInfo) {
	C.vkCmdSetEvent2(command_buffer, event, p_dependency_info)
}

fn C.vkCmdResetEvent2(C.VkCommandBuffer, C.VkEvent, PipelineStageFlags2)

pub type PFN_vkCmdResetEvent2 = fn (C.VkCommandBuffer, C.VkEvent, PipelineStageFlags2)

@[inline]
pub fn cmd_reset_event2(command_buffer C.VkCommandBuffer,
	event C.VkEvent,
	stage_mask PipelineStageFlags2) {
	C.vkCmdResetEvent2(command_buffer, event, stage_mask)
}

fn C.vkCmdWaitEvents2(C.VkCommandBuffer, u32, C.VkEvent, &DependencyInfo)

pub type PFN_vkCmdWaitEvents2 = fn (C.VkCommandBuffer, u32, C.VkEvent, &DependencyInfo)

@[inline]
pub fn cmd_wait_events2(command_buffer C.VkCommandBuffer,
	event_count u32,
	p_events C.VkEvent,
	p_dependency_infos &DependencyInfo) {
	C.vkCmdWaitEvents2(command_buffer, event_count, p_events, p_dependency_infos)
}

fn C.vkCmdPipelineBarrier2(C.VkCommandBuffer, &DependencyInfo)

pub type PFN_vkCmdPipelineBarrier2 = fn (C.VkCommandBuffer, &DependencyInfo)

@[inline]
pub fn cmd_pipeline_barrier2(command_buffer C.VkCommandBuffer,
	p_dependency_info &DependencyInfo) {
	C.vkCmdPipelineBarrier2(command_buffer, p_dependency_info)
}

fn C.vkCmdWriteTimestamp2(C.VkCommandBuffer, PipelineStageFlags2, C.VkQueryPool, u32)

pub type PFN_vkCmdWriteTimestamp2 = fn (C.VkCommandBuffer, PipelineStageFlags2, C.VkQueryPool, u32)

@[inline]
pub fn cmd_write_timestamp2(command_buffer C.VkCommandBuffer,
	stage PipelineStageFlags2,
	query_pool C.VkQueryPool,
	query u32) {
	C.vkCmdWriteTimestamp2(command_buffer, stage, query_pool, query)
}

fn C.vkQueueSubmit2(C.VkQueue, u32, &SubmitInfo2, C.VkFence) Result

pub type PFN_vkQueueSubmit2 = fn (C.VkQueue, u32, &SubmitInfo2, C.VkFence) Result

@[inline]
pub fn queue_submit2(queue C.VkQueue,
	submit_count u32,
	p_submits &SubmitInfo2,
	fence C.VkFence) Result {
	return C.vkQueueSubmit2(queue, submit_count, p_submits, fence)
}

fn C.vkCmdCopyBuffer2(C.VkCommandBuffer, &CopyBufferInfo2)

pub type PFN_vkCmdCopyBuffer2 = fn (C.VkCommandBuffer, &CopyBufferInfo2)

@[inline]
pub fn cmd_copy_buffer2(command_buffer C.VkCommandBuffer,
	p_copy_buffer_info &CopyBufferInfo2) {
	C.vkCmdCopyBuffer2(command_buffer, p_copy_buffer_info)
}

fn C.vkCmdCopyImage2(C.VkCommandBuffer, &CopyImageInfo2)

pub type PFN_vkCmdCopyImage2 = fn (C.VkCommandBuffer, &CopyImageInfo2)

@[inline]
pub fn cmd_copy_image2(command_buffer C.VkCommandBuffer,
	p_copy_image_info &CopyImageInfo2) {
	C.vkCmdCopyImage2(command_buffer, p_copy_image_info)
}

fn C.vkCmdCopyBufferToImage2(C.VkCommandBuffer, &CopyBufferToImageInfo2)

pub type PFN_vkCmdCopyBufferToImage2 = fn (C.VkCommandBuffer, &CopyBufferToImageInfo2)

@[inline]
pub fn cmd_copy_buffer_to_image2(command_buffer C.VkCommandBuffer,
	p_copy_buffer_to_image_info &CopyBufferToImageInfo2) {
	C.vkCmdCopyBufferToImage2(command_buffer, p_copy_buffer_to_image_info)
}

fn C.vkCmdCopyImageToBuffer2(C.VkCommandBuffer, &CopyImageToBufferInfo2)

pub type PFN_vkCmdCopyImageToBuffer2 = fn (C.VkCommandBuffer, &CopyImageToBufferInfo2)

@[inline]
pub fn cmd_copy_image_to_buffer2(command_buffer C.VkCommandBuffer,
	p_copy_image_to_buffer_info &CopyImageToBufferInfo2) {
	C.vkCmdCopyImageToBuffer2(command_buffer, p_copy_image_to_buffer_info)
}

fn C.vkCmdBlitImage2(C.VkCommandBuffer, &BlitImageInfo2)

pub type PFN_vkCmdBlitImage2 = fn (C.VkCommandBuffer, &BlitImageInfo2)

@[inline]
pub fn cmd_blit_image2(command_buffer C.VkCommandBuffer,
	p_blit_image_info &BlitImageInfo2) {
	C.vkCmdBlitImage2(command_buffer, p_blit_image_info)
}

fn C.vkCmdResolveImage2(C.VkCommandBuffer, &ResolveImageInfo2)

pub type PFN_vkCmdResolveImage2 = fn (C.VkCommandBuffer, &ResolveImageInfo2)

@[inline]
pub fn cmd_resolve_image2(command_buffer C.VkCommandBuffer,
	p_resolve_image_info &ResolveImageInfo2) {
	C.vkCmdResolveImage2(command_buffer, p_resolve_image_info)
}

fn C.vkCmdBeginRendering(C.VkCommandBuffer, &RenderingInfo)

pub type PFN_vkCmdBeginRendering = fn (C.VkCommandBuffer, &RenderingInfo)

@[inline]
pub fn cmd_begin_rendering(command_buffer C.VkCommandBuffer,
	p_rendering_info &RenderingInfo) {
	C.vkCmdBeginRendering(command_buffer, p_rendering_info)
}

fn C.vkCmdEndRendering(C.VkCommandBuffer)

pub type PFN_vkCmdEndRendering = fn (C.VkCommandBuffer)

@[inline]
pub fn cmd_end_rendering(command_buffer C.VkCommandBuffer) {
	C.vkCmdEndRendering(command_buffer)
}

fn C.vkCmdSetCullMode(C.VkCommandBuffer, CullModeFlags)

pub type PFN_vkCmdSetCullMode = fn (C.VkCommandBuffer, CullModeFlags)

@[inline]
pub fn cmd_set_cull_mode(command_buffer C.VkCommandBuffer,
	cull_mode CullModeFlags) {
	C.vkCmdSetCullMode(command_buffer, cull_mode)
}

fn C.vkCmdSetFrontFace(C.VkCommandBuffer, FrontFace)

pub type PFN_vkCmdSetFrontFace = fn (C.VkCommandBuffer, FrontFace)

@[inline]
pub fn cmd_set_front_face(command_buffer C.VkCommandBuffer,
	front_face FrontFace) {
	C.vkCmdSetFrontFace(command_buffer, front_face)
}

fn C.vkCmdSetPrimitiveTopology(C.VkCommandBuffer, PrimitiveTopology)

pub type PFN_vkCmdSetPrimitiveTopology = fn (C.VkCommandBuffer, PrimitiveTopology)

@[inline]
pub fn cmd_set_primitive_topology(command_buffer C.VkCommandBuffer,
	primitive_topology PrimitiveTopology) {
	C.vkCmdSetPrimitiveTopology(command_buffer, primitive_topology)
}

fn C.vkCmdSetViewportWithCount(C.VkCommandBuffer, u32, &Viewport)

pub type PFN_vkCmdSetViewportWithCount = fn (C.VkCommandBuffer, u32, &Viewport)

@[inline]
pub fn cmd_set_viewport_with_count(command_buffer C.VkCommandBuffer,
	viewport_count u32,
	p_viewports &Viewport) {
	C.vkCmdSetViewportWithCount(command_buffer, viewport_count, p_viewports)
}

fn C.vkCmdSetScissorWithCount(C.VkCommandBuffer, u32, &Rect2D)

pub type PFN_vkCmdSetScissorWithCount = fn (C.VkCommandBuffer, u32, &Rect2D)

@[inline]
pub fn cmd_set_scissor_with_count(command_buffer C.VkCommandBuffer,
	scissor_count u32,
	p_scissors &Rect2D) {
	C.vkCmdSetScissorWithCount(command_buffer, scissor_count, p_scissors)
}

fn C.vkCmdBindVertexBuffers2(C.VkCommandBuffer, u32, u32, C.VkBuffer, &DeviceSize, &DeviceSize, &DeviceSize)

pub type PFN_vkCmdBindVertexBuffers2 = fn (C.VkCommandBuffer, u32, u32, C.VkBuffer, &DeviceSize, &DeviceSize, &DeviceSize)

@[inline]
pub fn cmd_bind_vertex_buffers2(command_buffer C.VkCommandBuffer,
	first_binding u32,
	binding_count u32,
	p_buffers C.VkBuffer,
	p_offsets &DeviceSize,
	p_sizes &DeviceSize,
	p_strides &DeviceSize) {
	C.vkCmdBindVertexBuffers2(command_buffer, first_binding, binding_count, p_buffers,
		p_offsets, p_sizes, p_strides)
}

fn C.vkCmdSetDepthTestEnable(C.VkCommandBuffer, Bool32)

pub type PFN_vkCmdSetDepthTestEnable = fn (C.VkCommandBuffer, Bool32)

@[inline]
pub fn cmd_set_depth_test_enable(command_buffer C.VkCommandBuffer,
	depth_test_enable Bool32) {
	C.vkCmdSetDepthTestEnable(command_buffer, depth_test_enable)
}

fn C.vkCmdSetDepthWriteEnable(C.VkCommandBuffer, Bool32)

pub type PFN_vkCmdSetDepthWriteEnable = fn (C.VkCommandBuffer, Bool32)

@[inline]
pub fn cmd_set_depth_write_enable(command_buffer C.VkCommandBuffer,
	depth_write_enable Bool32) {
	C.vkCmdSetDepthWriteEnable(command_buffer, depth_write_enable)
}

fn C.vkCmdSetDepthCompareOp(C.VkCommandBuffer, CompareOp)

pub type PFN_vkCmdSetDepthCompareOp = fn (C.VkCommandBuffer, CompareOp)

@[inline]
pub fn cmd_set_depth_compare_op(command_buffer C.VkCommandBuffer,
	depth_compare_op CompareOp) {
	C.vkCmdSetDepthCompareOp(command_buffer, depth_compare_op)
}

fn C.vkCmdSetDepthBoundsTestEnable(C.VkCommandBuffer, Bool32)

pub type PFN_vkCmdSetDepthBoundsTestEnable = fn (C.VkCommandBuffer, Bool32)

@[inline]
pub fn cmd_set_depth_bounds_test_enable(command_buffer C.VkCommandBuffer,
	depth_bounds_test_enable Bool32) {
	C.vkCmdSetDepthBoundsTestEnable(command_buffer, depth_bounds_test_enable)
}

fn C.vkCmdSetStencilTestEnable(C.VkCommandBuffer, Bool32)

pub type PFN_vkCmdSetStencilTestEnable = fn (C.VkCommandBuffer, Bool32)

@[inline]
pub fn cmd_set_stencil_test_enable(command_buffer C.VkCommandBuffer,
	stencil_test_enable Bool32) {
	C.vkCmdSetStencilTestEnable(command_buffer, stencil_test_enable)
}

fn C.vkCmdSetStencilOp(C.VkCommandBuffer, StencilFaceFlags, StencilOp, StencilOp, StencilOp, CompareOp)

pub type PFN_vkCmdSetStencilOp = fn (C.VkCommandBuffer, StencilFaceFlags, StencilOp, StencilOp, StencilOp, CompareOp)

@[inline]
pub fn cmd_set_stencil_op(command_buffer C.VkCommandBuffer,
	face_mask StencilFaceFlags,
	fail_op StencilOp,
	pass_op StencilOp,
	depth_fail_op StencilOp,
	compare_op CompareOp) {
	C.vkCmdSetStencilOp(command_buffer, face_mask, fail_op, pass_op, depth_fail_op, compare_op)
}

fn C.vkCmdSetRasterizerDiscardEnable(C.VkCommandBuffer, Bool32)

pub type PFN_vkCmdSetRasterizerDiscardEnable = fn (C.VkCommandBuffer, Bool32)

@[inline]
pub fn cmd_set_rasterizer_discard_enable(command_buffer C.VkCommandBuffer,
	rasterizer_discard_enable Bool32) {
	C.vkCmdSetRasterizerDiscardEnable(command_buffer, rasterizer_discard_enable)
}

fn C.vkCmdSetDepthBiasEnable(C.VkCommandBuffer, Bool32)

pub type PFN_vkCmdSetDepthBiasEnable = fn (C.VkCommandBuffer, Bool32)

@[inline]
pub fn cmd_set_depth_bias_enable(command_buffer C.VkCommandBuffer,
	depth_bias_enable Bool32) {
	C.vkCmdSetDepthBiasEnable(command_buffer, depth_bias_enable)
}

fn C.vkCmdSetPrimitiveRestartEnable(C.VkCommandBuffer, Bool32)

pub type PFN_vkCmdSetPrimitiveRestartEnable = fn (C.VkCommandBuffer, Bool32)

@[inline]
pub fn cmd_set_primitive_restart_enable(command_buffer C.VkCommandBuffer,
	primitive_restart_enable Bool32) {
	C.vkCmdSetPrimitiveRestartEnable(command_buffer, primitive_restart_enable)
}

fn C.vkGetDeviceBufferMemoryRequirements(C.VkDevice, &DeviceBufferMemoryRequirements, &MemoryRequirements2)

pub type PFN_vkGetDeviceBufferMemoryRequirements = fn (C.VkDevice, &DeviceBufferMemoryRequirements, &MemoryRequirements2)

@[inline]
pub fn get_device_buffer_memory_requirements(device C.VkDevice,
	p_info &DeviceBufferMemoryRequirements,
	p_memory_requirements &MemoryRequirements2) {
	C.vkGetDeviceBufferMemoryRequirements(device, p_info, p_memory_requirements)
}

fn C.vkGetDeviceImageMemoryRequirements(C.VkDevice, &DeviceImageMemoryRequirements, &MemoryRequirements2)

pub type PFN_vkGetDeviceImageMemoryRequirements = fn (C.VkDevice, &DeviceImageMemoryRequirements, &MemoryRequirements2)

@[inline]
pub fn get_device_image_memory_requirements(device C.VkDevice,
	p_info &DeviceImageMemoryRequirements,
	p_memory_requirements &MemoryRequirements2) {
	C.vkGetDeviceImageMemoryRequirements(device, p_info, p_memory_requirements)
}

fn C.vkGetDeviceImageSparseMemoryRequirements(C.VkDevice, &DeviceImageMemoryRequirements, &u32, &SparseImageMemoryRequirements2)

pub type PFN_vkGetDeviceImageSparseMemoryRequirements = fn (C.VkDevice, &DeviceImageMemoryRequirements, &u32, &SparseImageMemoryRequirements2)

@[inline]
pub fn get_device_image_sparse_memory_requirements(device C.VkDevice,
	p_info &DeviceImageMemoryRequirements,
	p_sparse_memory_requirement_count &u32,
	p_sparse_memory_requirements &SparseImageMemoryRequirements2) {
	C.vkGetDeviceImageSparseMemoryRequirements(device, p_info, p_sparse_memory_requirement_count,
		p_sparse_memory_requirements)
}

pub type C.VkSurfaceKHR = voidptr

pub const khr_surface_spec_version = 25
pub const khr_surface_extension_name = 'VK_KHR_surface'

pub enum PresentModeKHR {
	immediate_khr                 = 0
	mailbox_khr                   = 1
	fifo_khr                      = 2
	fifo_relaxed_khr              = 3
	shared_demand_refresh_khr     = 1000111000
	shared_continuous_refresh_khr = 1000111001
	max_enum_khr                  = max_int
}

pub enum ColorSpaceKHR {
	srgb_nonlinear_khr          = 0
	display_p3_nonlinear_ext    = 1000104001
	extended_srgb_linear_ext    = 1000104002
	display_p3_linear_ext       = 1000104003
	dci_p3_nonlinear_ext        = 1000104004
	bt709_linear_ext            = 1000104005
	bt709_nonlinear_ext         = 1000104006
	bt2020_linear_ext           = 1000104007
	hdr10_st2084_ext            = 1000104008
	dolbyvision_ext             = 1000104009
	hdr10_hlg_ext               = 1000104010
	adobergb_linear_ext         = 1000104011
	adobergb_nonlinear_ext      = 1000104012
	pass_through_ext            = 1000104013
	extended_srgb_nonlinear_ext = 1000104014
	display_native_amd          = 1000213000
	max_enum_khr                = max_int
}

pub enum SurfaceTransformFlagBitsKHR {
	identity_bit_khr                    = int(0x00000001)
	rotate90_bit_khr                    = int(0x00000002)
	rotate180_bit_khr                   = int(0x00000004)
	rotate270_bit_khr                   = int(0x00000008)
	horizontal_mirror_bit_khr           = int(0x00000010)
	horizontal_mirror_rotate90_bit_khr  = int(0x00000020)
	horizontal_mirror_rotate180_bit_khr = int(0x00000040)
	horizontal_mirror_rotate270_bit_khr = int(0x00000080)
	inherit_bit_khr                     = int(0x00000100)
	max_enum_khr                        = max_int
}

pub enum CompositeAlphaFlagBitsKHR {
	opaque_bit_khr          = int(0x00000001)
	pre_multiplied_bit_khr  = int(0x00000002)
	post_multiplied_bit_khr = int(0x00000004)
	inherit_bit_khr         = int(0x00000008)
	max_enum_khr            = max_int
}

pub type CompositeAlphaFlagsKHR = u32
pub type SurfaceTransformFlagsKHR = u32
pub type SurfaceCapabilitiesKHR = C.VkSurfaceCapabilitiesKHR

@[typedef]
pub struct C.VkSurfaceCapabilitiesKHR {
pub mut:
	minImageCount           u32
	maxImageCount           u32
	currentExtent           Extent2D
	minImageExtent          Extent2D
	maxImageExtent          Extent2D
	maxImageArrayLayers     u32
	supportedTransforms     SurfaceTransformFlagsKHR
	currentTransform        SurfaceTransformFlagBitsKHR
	supportedCompositeAlpha CompositeAlphaFlagsKHR
	supportedUsageFlags     ImageUsageFlags
}

pub type SurfaceFormatKHR = C.VkSurfaceFormatKHR

@[typedef]
pub struct C.VkSurfaceFormatKHR {
pub mut:
	format     Format
	colorSpace ColorSpaceKHR
}

fn C.vkDestroySurfaceKHR(C.VkInstance, C.VkSurfaceKHR, &AllocationCallbacks)

pub type PFN_vkDestroySurfaceKHR = fn (C.VkInstance, C.VkSurfaceKHR, &AllocationCallbacks)

@[inline]
pub fn destroy_surface_khr(instance C.VkInstance,
	surface C.VkSurfaceKHR,
	p_allocator &AllocationCallbacks) {
	C.vkDestroySurfaceKHR(instance, surface, p_allocator)
}

fn C.vkGetPhysicalDeviceSurfaceSupportKHR(C.VkPhysicalDevice, u32, C.VkSurfaceKHR, &Bool32) Result

pub type PFN_vkGetPhysicalDeviceSurfaceSupportKHR = fn (C.VkPhysicalDevice, u32, C.VkSurfaceKHR, &Bool32) Result

@[inline]
pub fn get_physical_device_surface_support_khr(physical_device C.VkPhysicalDevice,
	queue_family_index u32,
	surface C.VkSurfaceKHR,
	p_supported &Bool32) Result {
	return C.vkGetPhysicalDeviceSurfaceSupportKHR(physical_device, queue_family_index,
		surface, p_supported)
}

fn C.vkGetPhysicalDeviceSurfaceCapabilitiesKHR(C.VkPhysicalDevice, C.VkSurfaceKHR, &SurfaceCapabilitiesKHR) Result

pub type PFN_vkGetPhysicalDeviceSurfaceCapabilitiesKHR = fn (C.VkPhysicalDevice, C.VkSurfaceKHR, &SurfaceCapabilitiesKHR) Result

@[inline]
pub fn get_physical_device_surface_capabilities_khr(physical_device C.VkPhysicalDevice,
	surface C.VkSurfaceKHR,
	p_surface_capabilities &SurfaceCapabilitiesKHR) Result {
	return C.vkGetPhysicalDeviceSurfaceCapabilitiesKHR(physical_device, surface, p_surface_capabilities)
}

fn C.vkGetPhysicalDeviceSurfaceFormatsKHR(C.VkPhysicalDevice, C.VkSurfaceKHR, &u32, &SurfaceFormatKHR) Result

pub type PFN_vkGetPhysicalDeviceSurfaceFormatsKHR = fn (C.VkPhysicalDevice, C.VkSurfaceKHR, &u32, &SurfaceFormatKHR) Result

@[inline]
pub fn get_physical_device_surface_formats_khr(physical_device C.VkPhysicalDevice,
	surface C.VkSurfaceKHR,
	p_surface_format_count &u32,
	p_surface_formats &SurfaceFormatKHR) Result {
	return C.vkGetPhysicalDeviceSurfaceFormatsKHR(physical_device, surface, p_surface_format_count,
		p_surface_formats)
}

fn C.vkGetPhysicalDeviceSurfacePresentModesKHR(C.VkPhysicalDevice, C.VkSurfaceKHR, &u32, &PresentModeKHR) Result

pub type PFN_vkGetPhysicalDeviceSurfacePresentModesKHR = fn (C.VkPhysicalDevice, C.VkSurfaceKHR, &u32, &PresentModeKHR) Result

@[inline]
pub fn get_physical_device_surface_present_modes_khr(physical_device C.VkPhysicalDevice,
	surface C.VkSurfaceKHR,
	p_present_mode_count &u32,
	p_present_modes &PresentModeKHR) Result {
	return C.vkGetPhysicalDeviceSurfacePresentModesKHR(physical_device, surface, p_present_mode_count,
		p_present_modes)
}

pub type C.VkSwapchainKHR = voidptr

pub const khr_swapchain_spec_version = 70
pub const khr_swapchain_extension_name = 'VK_KHR_swapchain'

pub enum SwapchainCreateFlagBitsKHR {
	split_instance_bind_regions_bit_khr = int(0x00000001)
	protected_bit_khr                   = int(0x00000002)
	mutable_format_bit_khr              = int(0x00000004)
	deferred_memory_allocation_bit_ext  = int(0x00000008)
	max_enum_khr                        = max_int
}

pub type SwapchainCreateFlagsKHR = u32

pub enum DeviceGroupPresentModeFlagBitsKHR {
	local_bit_khr              = int(0x00000001)
	remote_bit_khr             = int(0x00000002)
	sum_bit_khr                = int(0x00000004)
	local_multi_device_bit_khr = int(0x00000008)
	max_enum_khr               = max_int
}

pub type DeviceGroupPresentModeFlagsKHR = u32
pub type SwapchainCreateInfoKHR = C.VkSwapchainCreateInfoKHR

@[typedef]
pub struct C.VkSwapchainCreateInfoKHR {
pub mut:
	sType                 StructureType = StructureType.swapchain_create_info_khr
	pNext                 voidptr       = unsafe { nil }
	flags                 SwapchainCreateFlagsKHR
	surface               C.VkSurfaceKHR
	minImageCount         u32
	imageFormat           Format
	imageColorSpace       ColorSpaceKHR
	imageExtent           Extent2D
	imageArrayLayers      u32
	imageUsage            ImageUsageFlags
	imageSharingMode      SharingMode
	queueFamilyIndexCount u32
	pQueueFamilyIndices   &u32
	preTransform          SurfaceTransformFlagBitsKHR
	compositeAlpha        CompositeAlphaFlagBitsKHR
	presentMode           PresentModeKHR
	clipped               Bool32
	oldSwapchain          C.VkSwapchainKHR
}

pub type PresentInfoKHR = C.VkPresentInfoKHR

@[typedef]
pub struct C.VkPresentInfoKHR {
pub mut:
	sType              StructureType = StructureType.present_info_khr
	pNext              voidptr       = unsafe { nil }
	waitSemaphoreCount u32
	pWaitSemaphores    C.VkSemaphore
	swapchainCount     u32
	pSwapchains        C.VkSwapchainKHR
	pImageIndices      &u32
	pResults           &Result
}

pub type ImageSwapchainCreateInfoKHR = C.VkImageSwapchainCreateInfoKHR

@[typedef]
pub struct C.VkImageSwapchainCreateInfoKHR {
pub mut:
	sType     StructureType = StructureType.image_swapchain_create_info_khr
	pNext     voidptr       = unsafe { nil }
	swapchain C.VkSwapchainKHR
}

pub type BindImageMemorySwapchainInfoKHR = C.VkBindImageMemorySwapchainInfoKHR

@[typedef]
pub struct C.VkBindImageMemorySwapchainInfoKHR {
pub mut:
	sType      StructureType = StructureType.bind_image_memory_swapchain_info_khr
	pNext      voidptr       = unsafe { nil }
	swapchain  C.VkSwapchainKHR
	imageIndex u32
}

pub type AcquireNextImageInfoKHR = C.VkAcquireNextImageInfoKHR

@[typedef]
pub struct C.VkAcquireNextImageInfoKHR {
pub mut:
	sType      StructureType = StructureType.acquire_next_image_info_khr
	pNext      voidptr       = unsafe { nil }
	swapchain  C.VkSwapchainKHR
	timeout    u64
	semaphore  C.VkSemaphore
	fence      C.VkFence
	deviceMask u32
}

pub type DeviceGroupPresentCapabilitiesKHR = C.VkDeviceGroupPresentCapabilitiesKHR

@[typedef]
pub struct C.VkDeviceGroupPresentCapabilitiesKHR {
pub mut:
	sType       StructureType = StructureType.device_group_present_capabilities_khr
	pNext       voidptr       = unsafe { nil }
	presentMask [max_device_group_size]u32
	modes       DeviceGroupPresentModeFlagsKHR
}

pub type DeviceGroupPresentInfoKHR = C.VkDeviceGroupPresentInfoKHR

@[typedef]
pub struct C.VkDeviceGroupPresentInfoKHR {
pub mut:
	sType          StructureType = StructureType.device_group_present_info_khr
	pNext          voidptr       = unsafe { nil }
	swapchainCount u32
	pDeviceMasks   &u32
	mode           DeviceGroupPresentModeFlagBitsKHR
}

pub type DeviceGroupSwapchainCreateInfoKHR = C.VkDeviceGroupSwapchainCreateInfoKHR

@[typedef]
pub struct C.VkDeviceGroupSwapchainCreateInfoKHR {
pub mut:
	sType StructureType = StructureType.device_group_swapchain_create_info_khr
	pNext voidptr       = unsafe { nil }
	modes DeviceGroupPresentModeFlagsKHR
}

fn C.vkCreateSwapchainKHR(C.VkDevice, &SwapchainCreateInfoKHR, &AllocationCallbacks, C.VkSwapchainKHR) Result

pub type PFN_vkCreateSwapchainKHR = fn (C.VkDevice, &SwapchainCreateInfoKHR, &AllocationCallbacks, C.VkSwapchainKHR) Result

@[inline]
pub fn create_swapchain_khr(device C.VkDevice,
	p_create_info &SwapchainCreateInfoKHR,
	p_allocator &AllocationCallbacks,
	p_swapchain C.VkSwapchainKHR) Result {
	return C.vkCreateSwapchainKHR(device, p_create_info, p_allocator, p_swapchain)
}

fn C.vkDestroySwapchainKHR(C.VkDevice, C.VkSwapchainKHR, &AllocationCallbacks)

pub type PFN_vkDestroySwapchainKHR = fn (C.VkDevice, C.VkSwapchainKHR, &AllocationCallbacks)

@[inline]
pub fn destroy_swapchain_khr(device C.VkDevice,
	swapchain C.VkSwapchainKHR,
	p_allocator &AllocationCallbacks) {
	C.vkDestroySwapchainKHR(device, swapchain, p_allocator)
}

fn C.vkGetSwapchainImagesKHR(C.VkDevice, C.VkSwapchainKHR, &u32, C.VkImage) Result

pub type PFN_vkGetSwapchainImagesKHR = fn (C.VkDevice, C.VkSwapchainKHR, &u32, C.VkImage) Result

@[inline]
pub fn get_swapchain_images_khr(device C.VkDevice,
	swapchain C.VkSwapchainKHR,
	p_swapchain_image_count &u32,
	p_swapchain_images C.VkImage) Result {
	return C.vkGetSwapchainImagesKHR(device, swapchain, p_swapchain_image_count, p_swapchain_images)
}

fn C.vkAcquireNextImageKHR(C.VkDevice, C.VkSwapchainKHR, u64, C.VkSemaphore, C.VkFence, &u32) Result

pub type PFN_vkAcquireNextImageKHR = fn (C.VkDevice, C.VkSwapchainKHR, u64, C.VkSemaphore, C.VkFence, &u32) Result

@[inline]
pub fn acquire_next_image_khr(device C.VkDevice,
	swapchain C.VkSwapchainKHR,
	timeout u64,
	semaphore C.VkSemaphore,
	fence C.VkFence,
	p_image_index &u32) Result {
	return C.vkAcquireNextImageKHR(device, swapchain, timeout, semaphore, fence, p_image_index)
}

fn C.vkQueuePresentKHR(C.VkQueue, &PresentInfoKHR) Result

pub type PFN_vkQueuePresentKHR = fn (C.VkQueue, &PresentInfoKHR) Result

@[inline]
pub fn queue_present_khr(queue C.VkQueue,
	p_present_info &PresentInfoKHR) Result {
	return C.vkQueuePresentKHR(queue, p_present_info)
}

fn C.vkGetDeviceGroupPresentCapabilitiesKHR(C.VkDevice, &DeviceGroupPresentCapabilitiesKHR) Result

pub type PFN_vkGetDeviceGroupPresentCapabilitiesKHR = fn (C.VkDevice, &DeviceGroupPresentCapabilitiesKHR) Result

@[inline]
pub fn get_device_group_present_capabilities_khr(device C.VkDevice,
	p_device_group_present_capabilities &DeviceGroupPresentCapabilitiesKHR) Result {
	return C.vkGetDeviceGroupPresentCapabilitiesKHR(device, p_device_group_present_capabilities)
}

fn C.vkGetDeviceGroupSurfacePresentModesKHR(C.VkDevice, C.VkSurfaceKHR, &DeviceGroupPresentModeFlagsKHR) Result

pub type PFN_vkGetDeviceGroupSurfacePresentModesKHR = fn (C.VkDevice, C.VkSurfaceKHR, &DeviceGroupPresentModeFlagsKHR) Result

@[inline]
pub fn get_device_group_surface_present_modes_khr(device C.VkDevice,
	surface C.VkSurfaceKHR,
	p_modes &DeviceGroupPresentModeFlagsKHR) Result {
	return C.vkGetDeviceGroupSurfacePresentModesKHR(device, surface, p_modes)
}

fn C.vkGetPhysicalDevicePresentRectanglesKHR(C.VkPhysicalDevice, C.VkSurfaceKHR, &u32, &Rect2D) Result

pub type PFN_vkGetPhysicalDevicePresentRectanglesKHR = fn (C.VkPhysicalDevice, C.VkSurfaceKHR, &u32, &Rect2D) Result

@[inline]
pub fn get_physical_device_present_rectangles_khr(physical_device C.VkPhysicalDevice,
	surface C.VkSurfaceKHR,
	p_rect_count &u32,
	p_rects &Rect2D) Result {
	return C.vkGetPhysicalDevicePresentRectanglesKHR(physical_device, surface, p_rect_count,
		p_rects)
}

fn C.vkAcquireNextImage2KHR(C.VkDevice, &AcquireNextImageInfoKHR, &u32) Result

pub type PFN_vkAcquireNextImage2KHR = fn (C.VkDevice, &AcquireNextImageInfoKHR, &u32) Result

@[inline]
pub fn acquire_next_image2_khr(device C.VkDevice,
	p_acquire_info &AcquireNextImageInfoKHR,
	p_image_index &u32) Result {
	return C.vkAcquireNextImage2KHR(device, p_acquire_info, p_image_index)
}

pub type C.VkDisplayKHR = voidptr
pub type C.VkDisplayModeKHR = voidptr

pub const khr_display_spec_version = 23
pub const khr_display_extension_name = 'VK_KHR_display'

pub type DisplayModeCreateFlagsKHR = u32

pub enum DisplayPlaneAlphaFlagBitsKHR {
	opaque_bit_khr                  = int(0x00000001)
	global_bit_khr                  = int(0x00000002)
	per_pixel_bit_khr               = int(0x00000004)
	per_pixel_premultiplied_bit_khr = int(0x00000008)
	max_enum_khr                    = max_int
}

pub type DisplayPlaneAlphaFlagsKHR = u32
pub type DisplaySurfaceCreateFlagsKHR = u32
pub type DisplayModeParametersKHR = C.VkDisplayModeParametersKHR

@[typedef]
pub struct C.VkDisplayModeParametersKHR {
pub mut:
	visibleRegion Extent2D
	refreshRate   u32
}

pub type DisplayModeCreateInfoKHR = C.VkDisplayModeCreateInfoKHR

@[typedef]
pub struct C.VkDisplayModeCreateInfoKHR {
pub mut:
	sType      StructureType = StructureType.display_mode_create_info_khr
	pNext      voidptr       = unsafe { nil }
	flags      DisplayModeCreateFlagsKHR
	parameters DisplayModeParametersKHR
}

pub type DisplayModePropertiesKHR = C.VkDisplayModePropertiesKHR

@[typedef]
pub struct C.VkDisplayModePropertiesKHR {
pub mut:
	displayMode C.VkDisplayModeKHR
	parameters  DisplayModeParametersKHR
}

pub type DisplayPlaneCapabilitiesKHR = C.VkDisplayPlaneCapabilitiesKHR

@[typedef]
pub struct C.VkDisplayPlaneCapabilitiesKHR {
pub mut:
	supportedAlpha DisplayPlaneAlphaFlagsKHR
	minSrcPosition Offset2D
	maxSrcPosition Offset2D
	minSrcExtent   Extent2D
	maxSrcExtent   Extent2D
	minDstPosition Offset2D
	maxDstPosition Offset2D
	minDstExtent   Extent2D
	maxDstExtent   Extent2D
}

pub type DisplayPlanePropertiesKHR = C.VkDisplayPlanePropertiesKHR

@[typedef]
pub struct C.VkDisplayPlanePropertiesKHR {
pub mut:
	currentDisplay    C.VkDisplayKHR
	currentStackIndex u32
}

pub type DisplayPropertiesKHR = C.VkDisplayPropertiesKHR

@[typedef]
pub struct C.VkDisplayPropertiesKHR {
pub mut:
	display              C.VkDisplayKHR
	displayName          &char
	physicalDimensions   Extent2D
	physicalResolution   Extent2D
	supportedTransforms  SurfaceTransformFlagsKHR
	planeReorderPossible Bool32
	persistentContent    Bool32
}

pub type DisplaySurfaceCreateInfoKHR = C.VkDisplaySurfaceCreateInfoKHR

@[typedef]
pub struct C.VkDisplaySurfaceCreateInfoKHR {
pub mut:
	sType           StructureType = StructureType.display_surface_create_info_khr
	pNext           voidptr       = unsafe { nil }
	flags           DisplaySurfaceCreateFlagsKHR
	displayMode     C.VkDisplayModeKHR
	planeIndex      u32
	planeStackIndex u32
	transform       SurfaceTransformFlagBitsKHR
	globalAlpha     f32
	alphaMode       DisplayPlaneAlphaFlagBitsKHR
	imageExtent     Extent2D
}

fn C.vkGetPhysicalDeviceDisplayPropertiesKHR(C.VkPhysicalDevice, &u32, &DisplayPropertiesKHR) Result

pub type PFN_vkGetPhysicalDeviceDisplayPropertiesKHR = fn (C.VkPhysicalDevice, &u32, &DisplayPropertiesKHR) Result

@[inline]
pub fn get_physical_device_display_properties_khr(physical_device C.VkPhysicalDevice,
	p_property_count &u32,
	p_properties &DisplayPropertiesKHR) Result {
	return C.vkGetPhysicalDeviceDisplayPropertiesKHR(physical_device, p_property_count,
		p_properties)
}

fn C.vkGetPhysicalDeviceDisplayPlanePropertiesKHR(C.VkPhysicalDevice, &u32, &DisplayPlanePropertiesKHR) Result

pub type PFN_vkGetPhysicalDeviceDisplayPlanePropertiesKHR = fn (C.VkPhysicalDevice, &u32, &DisplayPlanePropertiesKHR) Result

@[inline]
pub fn get_physical_device_display_plane_properties_khr(physical_device C.VkPhysicalDevice,
	p_property_count &u32,
	p_properties &DisplayPlanePropertiesKHR) Result {
	return C.vkGetPhysicalDeviceDisplayPlanePropertiesKHR(physical_device, p_property_count,
		p_properties)
}

fn C.vkGetDisplayPlaneSupportedDisplaysKHR(C.VkPhysicalDevice, u32, &u32, C.VkDisplayKHR) Result

pub type PFN_vkGetDisplayPlaneSupportedDisplaysKHR = fn (C.VkPhysicalDevice, u32, &u32, C.VkDisplayKHR) Result

@[inline]
pub fn get_display_plane_supported_displays_khr(physical_device C.VkPhysicalDevice,
	plane_index u32,
	p_display_count &u32,
	p_displays C.VkDisplayKHR) Result {
	return C.vkGetDisplayPlaneSupportedDisplaysKHR(physical_device, plane_index, p_display_count,
		p_displays)
}

fn C.vkGetDisplayModePropertiesKHR(C.VkPhysicalDevice, C.VkDisplayKHR, &u32, &DisplayModePropertiesKHR) Result

pub type PFN_vkGetDisplayModePropertiesKHR = fn (C.VkPhysicalDevice, C.VkDisplayKHR, &u32, &DisplayModePropertiesKHR) Result

@[inline]
pub fn get_display_mode_properties_khr(physical_device C.VkPhysicalDevice,
	display C.VkDisplayKHR,
	p_property_count &u32,
	p_properties &DisplayModePropertiesKHR) Result {
	return C.vkGetDisplayModePropertiesKHR(physical_device, display, p_property_count,
		p_properties)
}

fn C.vkCreateDisplayModeKHR(C.VkPhysicalDevice, C.VkDisplayKHR, &DisplayModeCreateInfoKHR, &AllocationCallbacks, C.VkDisplayModeKHR) Result

pub type PFN_vkCreateDisplayModeKHR = fn (C.VkPhysicalDevice, C.VkDisplayKHR, &DisplayModeCreateInfoKHR, &AllocationCallbacks, C.VkDisplayModeKHR) Result

@[inline]
pub fn create_display_mode_khr(physical_device C.VkPhysicalDevice,
	display C.VkDisplayKHR,
	p_create_info &DisplayModeCreateInfoKHR,
	p_allocator &AllocationCallbacks,
	p_mode C.VkDisplayModeKHR) Result {
	return C.vkCreateDisplayModeKHR(physical_device, display, p_create_info, p_allocator,
		p_mode)
}

fn C.vkGetDisplayPlaneCapabilitiesKHR(C.VkPhysicalDevice, C.VkDisplayModeKHR, u32, &DisplayPlaneCapabilitiesKHR) Result

pub type PFN_vkGetDisplayPlaneCapabilitiesKHR = fn (C.VkPhysicalDevice, C.VkDisplayModeKHR, u32, &DisplayPlaneCapabilitiesKHR) Result

@[inline]
pub fn get_display_plane_capabilities_khr(physical_device C.VkPhysicalDevice,
	mode C.VkDisplayModeKHR,
	plane_index u32,
	p_capabilities &DisplayPlaneCapabilitiesKHR) Result {
	return C.vkGetDisplayPlaneCapabilitiesKHR(physical_device, mode, plane_index, p_capabilities)
}

fn C.vkCreateDisplayPlaneSurfaceKHR(C.VkInstance, &DisplaySurfaceCreateInfoKHR, &AllocationCallbacks, C.VkSurfaceKHR) Result

pub type PFN_vkCreateDisplayPlaneSurfaceKHR = fn (C.VkInstance, &DisplaySurfaceCreateInfoKHR, &AllocationCallbacks, C.VkSurfaceKHR) Result

@[inline]
pub fn create_display_plane_surface_khr(instance C.VkInstance,
	p_create_info &DisplaySurfaceCreateInfoKHR,
	p_allocator &AllocationCallbacks,
	p_surface C.VkSurfaceKHR) Result {
	return C.vkCreateDisplayPlaneSurfaceKHR(instance, p_create_info, p_allocator, p_surface)
}

pub const khr_display_swapchain_spec_version = 10
pub const khr_display_swapchain_extension_name = 'VK_KHR_display_swapchain'

pub type DisplayPresentInfoKHR = C.VkDisplayPresentInfoKHR

@[typedef]
pub struct C.VkDisplayPresentInfoKHR {
pub mut:
	sType      StructureType = StructureType.display_present_info_khr
	pNext      voidptr       = unsafe { nil }
	srcRect    Rect2D
	dstRect    Rect2D
	persistent Bool32
}

fn C.vkCreateSharedSwapchainsKHR(C.VkDevice, u32, &SwapchainCreateInfoKHR, &AllocationCallbacks, C.VkSwapchainKHR) Result

pub type PFN_vkCreateSharedSwapchainsKHR = fn (C.VkDevice, u32, &SwapchainCreateInfoKHR, &AllocationCallbacks, C.VkSwapchainKHR) Result

@[inline]
pub fn create_shared_swapchains_khr(device C.VkDevice,
	swapchain_count u32,
	p_create_infos &SwapchainCreateInfoKHR,
	p_allocator &AllocationCallbacks,
	p_swapchains C.VkSwapchainKHR) Result {
	return C.vkCreateSharedSwapchainsKHR(device, swapchain_count, p_create_infos, p_allocator,
		p_swapchains)
}

pub const khr_sampler_mirror_clamp_to_edge_spec_version = 3
pub const khr_sampler_mirror_clamp_to_edge_extension_name = 'VK_KHR_sampler_mirror_clamp_to_edge'

pub type C.VkVideoSessionKHR = voidptr
pub type C.VkVideoSessionParametersKHR = voidptr

pub const khr_video_queue_spec_version = 8
pub const khr_video_queue_extension_name = 'VK_KHR_video_queue'

pub enum QueryResultStatusKHR {
	error_khr                               = -1
	not_ready_khr                           = 0
	complete_khr                            = 1
	insufficient_bitstream_buffer_range_khr = -1000299000
	max_enum_khr                            = max_int
}

pub enum VideoCodecOperationFlagBitsKHR {
	none_khr            = 0
	encode_h264_bit_khr = int(0x00010000)
	encode_h265_bit_khr = int(0x00020000)
	decode_h264_bit_khr = int(0x00000001)
	decode_h265_bit_khr = int(0x00000002)
	max_enum_khr        = max_int
}

pub type VideoCodecOperationFlagsKHR = u32

pub enum VideoChromaSubsamplingFlagBitsKHR {
	invalid_khr        = 0
	monochrome_bit_khr = int(0x00000001)
	_420_bit_khr       = int(0x00000002)
	_422_bit_khr       = int(0x00000004)
	_444_bit_khr       = int(0x00000008)
	max_enum_khr       = max_int
}

pub type VideoChromaSubsamplingFlagsKHR = u32

pub enum VideoComponentBitDepthFlagBitsKHR {
	invalid_khr  = 0
	_8_bit_khr   = int(0x00000001)
	_10_bit_khr  = int(0x00000004)
	_12_bit_khr  = int(0x00000010)
	max_enum_khr = max_int
}

pub type VideoComponentBitDepthFlagsKHR = u32

pub enum VideoCapabilityFlagBitsKHR {
	protected_content_bit_khr         = int(0x00000001)
	separate_reference_images_bit_khr = int(0x00000002)
	max_enum_khr                      = max_int
}

pub type VideoCapabilityFlagsKHR = u32

pub enum VideoSessionCreateFlagBitsKHR {
	protected_content_bit_khr                    = int(0x00000001)
	allow_encode_parameter_optimizations_bit_khr = int(0x00000002)
	inline_queries_bit_khr                       = int(0x00000004)
	max_enum_khr                                 = max_int
}

pub type VideoSessionCreateFlagsKHR = u32
pub type VideoSessionParametersCreateFlagsKHR = u32
pub type VideoBeginCodingFlagsKHR = u32
pub type VideoEndCodingFlagsKHR = u32

pub enum VideoCodingControlFlagBitsKHR {
	reset_bit_khr                = int(0x00000001)
	encode_rate_control_bit_khr  = int(0x00000002)
	encode_quality_level_bit_khr = int(0x00000004)
	max_enum_khr                 = max_int
}

pub type VideoCodingControlFlagsKHR = u32
pub type QueueFamilyQueryResultStatusPropertiesKHR = C.VkQueueFamilyQueryResultStatusPropertiesKHR

@[typedef]
pub struct C.VkQueueFamilyQueryResultStatusPropertiesKHR {
pub mut:
	sType                    StructureType = StructureType.queue_family_query_result_status_properties_khr
	pNext                    voidptr       = unsafe { nil }
	queryResultStatusSupport Bool32
}

pub type QueueFamilyVideoPropertiesKHR = C.VkQueueFamilyVideoPropertiesKHR

@[typedef]
pub struct C.VkQueueFamilyVideoPropertiesKHR {
pub mut:
	sType                StructureType = StructureType.queue_family_video_properties_khr
	pNext                voidptr       = unsafe { nil }
	videoCodecOperations VideoCodecOperationFlagsKHR
}

pub type VideoProfileInfoKHR = C.VkVideoProfileInfoKHR

@[typedef]
pub struct C.VkVideoProfileInfoKHR {
pub mut:
	sType               StructureType = StructureType.video_profile_info_khr
	pNext               voidptr       = unsafe { nil }
	videoCodecOperation VideoCodecOperationFlagBitsKHR
	chromaSubsampling   VideoChromaSubsamplingFlagsKHR
	lumaBitDepth        VideoComponentBitDepthFlagsKHR
	chromaBitDepth      VideoComponentBitDepthFlagsKHR
}

pub type VideoProfileListInfoKHR = C.VkVideoProfileListInfoKHR

@[typedef]
pub struct C.VkVideoProfileListInfoKHR {
pub mut:
	sType        StructureType = StructureType.video_profile_list_info_khr
	pNext        voidptr       = unsafe { nil }
	profileCount u32
	pProfiles    &VideoProfileInfoKHR
}

pub type VideoCapabilitiesKHR = C.VkVideoCapabilitiesKHR

@[typedef]
pub struct C.VkVideoCapabilitiesKHR {
pub mut:
	sType                             StructureType = StructureType.video_capabilities_khr
	pNext                             voidptr       = unsafe { nil }
	flags                             VideoCapabilityFlagsKHR
	minBitstreamBufferOffsetAlignment DeviceSize
	minBitstreamBufferSizeAlignment   DeviceSize
	pictureAccessGranularity          Extent2D
	minCodedExtent                    Extent2D
	maxCodedExtent                    Extent2D
	maxDpbSlots                       u32
	maxActiveReferencePictures        u32
	stdHeaderVersion                  ExtensionProperties
}

pub type PhysicalDeviceVideoFormatInfoKHR = C.VkPhysicalDeviceVideoFormatInfoKHR

@[typedef]
pub struct C.VkPhysicalDeviceVideoFormatInfoKHR {
pub mut:
	sType      StructureType = StructureType.physical_device_video_format_info_khr
	pNext      voidptr       = unsafe { nil }
	imageUsage ImageUsageFlags
}

pub type VideoFormatPropertiesKHR = C.VkVideoFormatPropertiesKHR

@[typedef]
pub struct C.VkVideoFormatPropertiesKHR {
pub mut:
	sType            StructureType = StructureType.video_format_properties_khr
	pNext            voidptr       = unsafe { nil }
	format           Format
	componentMapping ComponentMapping
	imageCreateFlags ImageCreateFlags
	imageType        ImageType
	imageTiling      ImageTiling
	imageUsageFlags  ImageUsageFlags
}

pub type VideoPictureResourceInfoKHR = C.VkVideoPictureResourceInfoKHR

@[typedef]
pub struct C.VkVideoPictureResourceInfoKHR {
pub mut:
	sType            StructureType = StructureType.video_picture_resource_info_khr
	pNext            voidptr       = unsafe { nil }
	codedOffset      Offset2D
	codedExtent      Extent2D
	baseArrayLayer   u32
	imageViewBinding C.VkImageView
}

pub type VideoReferenceSlotInfoKHR = C.VkVideoReferenceSlotInfoKHR

@[typedef]
pub struct C.VkVideoReferenceSlotInfoKHR {
pub mut:
	sType            StructureType = StructureType.video_reference_slot_info_khr
	pNext            voidptr       = unsafe { nil }
	slotIndex        i32
	pPictureResource &VideoPictureResourceInfoKHR
}

pub type VideoSessionMemoryRequirementsKHR = C.VkVideoSessionMemoryRequirementsKHR

@[typedef]
pub struct C.VkVideoSessionMemoryRequirementsKHR {
pub mut:
	sType              StructureType = StructureType.video_session_memory_requirements_khr
	pNext              voidptr       = unsafe { nil }
	memoryBindIndex    u32
	memoryRequirements MemoryRequirements
}

pub type BindVideoSessionMemoryInfoKHR = C.VkBindVideoSessionMemoryInfoKHR

@[typedef]
pub struct C.VkBindVideoSessionMemoryInfoKHR {
pub mut:
	sType           StructureType = StructureType.bind_video_session_memory_info_khr
	pNext           voidptr       = unsafe { nil }
	memoryBindIndex u32
	memory          C.VkDeviceMemory
	memoryOffset    DeviceSize
	memorySize      DeviceSize
}

pub type VideoSessionCreateInfoKHR = C.VkVideoSessionCreateInfoKHR

@[typedef]
pub struct C.VkVideoSessionCreateInfoKHR {
pub mut:
	sType                      StructureType = StructureType.video_session_create_info_khr
	pNext                      voidptr       = unsafe { nil }
	queueFamilyIndex           u32
	flags                      VideoSessionCreateFlagsKHR
	pVideoProfile              &VideoProfileInfoKHR
	pictureFormat              Format
	maxCodedExtent             Extent2D
	referencePictureFormat     Format
	maxDpbSlots                u32
	maxActiveReferencePictures u32
	pStdHeaderVersion          &ExtensionProperties
}

pub type VideoSessionParametersCreateInfoKHR = C.VkVideoSessionParametersCreateInfoKHR

@[typedef]
pub struct C.VkVideoSessionParametersCreateInfoKHR {
pub mut:
	sType                          StructureType = StructureType.video_session_parameters_create_info_khr
	pNext                          voidptr       = unsafe { nil }
	flags                          VideoSessionParametersCreateFlagsKHR
	videoSessionParametersTemplate C.VkVideoSessionParametersKHR
	videoSession                   C.VkVideoSessionKHR
}

pub type VideoSessionParametersUpdateInfoKHR = C.VkVideoSessionParametersUpdateInfoKHR

@[typedef]
pub struct C.VkVideoSessionParametersUpdateInfoKHR {
pub mut:
	sType               StructureType = StructureType.video_session_parameters_update_info_khr
	pNext               voidptr       = unsafe { nil }
	updateSequenceCount u32
}

pub type VideoBeginCodingInfoKHR = C.VkVideoBeginCodingInfoKHR

@[typedef]
pub struct C.VkVideoBeginCodingInfoKHR {
pub mut:
	sType                  StructureType = StructureType.video_begin_coding_info_khr
	pNext                  voidptr       = unsafe { nil }
	flags                  VideoBeginCodingFlagsKHR
	videoSession           C.VkVideoSessionKHR
	videoSessionParameters C.VkVideoSessionParametersKHR
	referenceSlotCount     u32
	pReferenceSlots        &VideoReferenceSlotInfoKHR
}

pub type VideoEndCodingInfoKHR = C.VkVideoEndCodingInfoKHR

@[typedef]
pub struct C.VkVideoEndCodingInfoKHR {
pub mut:
	sType StructureType = StructureType.video_end_coding_info_khr
	pNext voidptr       = unsafe { nil }
	flags VideoEndCodingFlagsKHR
}

pub type VideoCodingControlInfoKHR = C.VkVideoCodingControlInfoKHR

@[typedef]
pub struct C.VkVideoCodingControlInfoKHR {
pub mut:
	sType StructureType = StructureType.video_coding_control_info_khr
	pNext voidptr       = unsafe { nil }
	flags VideoCodingControlFlagsKHR
}

fn C.vkGetPhysicalDeviceVideoCapabilitiesKHR(C.VkPhysicalDevice, &VideoProfileInfoKHR, &VideoCapabilitiesKHR) Result

pub type PFN_vkGetPhysicalDeviceVideoCapabilitiesKHR = fn (C.VkPhysicalDevice, &VideoProfileInfoKHR, &VideoCapabilitiesKHR) Result

@[inline]
pub fn get_physical_device_video_capabilities_khr(physical_device C.VkPhysicalDevice,
	p_video_profile &VideoProfileInfoKHR,
	p_capabilities &VideoCapabilitiesKHR) Result {
	return C.vkGetPhysicalDeviceVideoCapabilitiesKHR(physical_device, p_video_profile,
		p_capabilities)
}

fn C.vkGetPhysicalDeviceVideoFormatPropertiesKHR(C.VkPhysicalDevice, &PhysicalDeviceVideoFormatInfoKHR, &u32, &VideoFormatPropertiesKHR) Result

pub type PFN_vkGetPhysicalDeviceVideoFormatPropertiesKHR = fn (C.VkPhysicalDevice, &PhysicalDeviceVideoFormatInfoKHR, &u32, &VideoFormatPropertiesKHR) Result

@[inline]
pub fn get_physical_device_video_format_properties_khr(physical_device C.VkPhysicalDevice,
	p_video_format_info &PhysicalDeviceVideoFormatInfoKHR,
	p_video_format_property_count &u32,
	p_video_format_properties &VideoFormatPropertiesKHR) Result {
	return C.vkGetPhysicalDeviceVideoFormatPropertiesKHR(physical_device, p_video_format_info,
		p_video_format_property_count, p_video_format_properties)
}

fn C.vkCreateVideoSessionKHR(C.VkDevice, &VideoSessionCreateInfoKHR, &AllocationCallbacks, C.VkVideoSessionKHR) Result

pub type PFN_vkCreateVideoSessionKHR = fn (C.VkDevice, &VideoSessionCreateInfoKHR, &AllocationCallbacks, C.VkVideoSessionKHR) Result

@[inline]
pub fn create_video_session_khr(device C.VkDevice,
	p_create_info &VideoSessionCreateInfoKHR,
	p_allocator &AllocationCallbacks,
	p_video_session C.VkVideoSessionKHR) Result {
	return C.vkCreateVideoSessionKHR(device, p_create_info, p_allocator, p_video_session)
}

fn C.vkDestroyVideoSessionKHR(C.VkDevice, C.VkVideoSessionKHR, &AllocationCallbacks)

pub type PFN_vkDestroyVideoSessionKHR = fn (C.VkDevice, C.VkVideoSessionKHR, &AllocationCallbacks)

@[inline]
pub fn destroy_video_session_khr(device C.VkDevice,
	video_session C.VkVideoSessionKHR,
	p_allocator &AllocationCallbacks) {
	C.vkDestroyVideoSessionKHR(device, video_session, p_allocator)
}

fn C.vkGetVideoSessionMemoryRequirementsKHR(C.VkDevice, C.VkVideoSessionKHR, &u32, &VideoSessionMemoryRequirementsKHR) Result

pub type PFN_vkGetVideoSessionMemoryRequirementsKHR = fn (C.VkDevice, C.VkVideoSessionKHR, &u32, &VideoSessionMemoryRequirementsKHR) Result

@[inline]
pub fn get_video_session_memory_requirements_khr(device C.VkDevice,
	video_session C.VkVideoSessionKHR,
	p_memory_requirements_count &u32,
	p_memory_requirements &VideoSessionMemoryRequirementsKHR) Result {
	return C.vkGetVideoSessionMemoryRequirementsKHR(device, video_session, p_memory_requirements_count,
		p_memory_requirements)
}

fn C.vkBindVideoSessionMemoryKHR(C.VkDevice, C.VkVideoSessionKHR, u32, &BindVideoSessionMemoryInfoKHR) Result

pub type PFN_vkBindVideoSessionMemoryKHR = fn (C.VkDevice, C.VkVideoSessionKHR, u32, &BindVideoSessionMemoryInfoKHR) Result

@[inline]
pub fn bind_video_session_memory_khr(device C.VkDevice,
	video_session C.VkVideoSessionKHR,
	bind_session_memory_info_count u32,
	p_bind_session_memory_infos &BindVideoSessionMemoryInfoKHR) Result {
	return C.vkBindVideoSessionMemoryKHR(device, video_session, bind_session_memory_info_count,
		p_bind_session_memory_infos)
}

fn C.vkCreateVideoSessionParametersKHR(C.VkDevice, &VideoSessionParametersCreateInfoKHR, &AllocationCallbacks, C.VkVideoSessionParametersKHR) Result

pub type PFN_vkCreateVideoSessionParametersKHR = fn (C.VkDevice, &VideoSessionParametersCreateInfoKHR, &AllocationCallbacks, C.VkVideoSessionParametersKHR) Result

@[inline]
pub fn create_video_session_parameters_khr(device C.VkDevice,
	p_create_info &VideoSessionParametersCreateInfoKHR,
	p_allocator &AllocationCallbacks,
	p_video_session_parameters C.VkVideoSessionParametersKHR) Result {
	return C.vkCreateVideoSessionParametersKHR(device, p_create_info, p_allocator, p_video_session_parameters)
}

fn C.vkUpdateVideoSessionParametersKHR(C.VkDevice, C.VkVideoSessionParametersKHR, &VideoSessionParametersUpdateInfoKHR) Result

pub type PFN_vkUpdateVideoSessionParametersKHR = fn (C.VkDevice, C.VkVideoSessionParametersKHR, &VideoSessionParametersUpdateInfoKHR) Result

@[inline]
pub fn update_video_session_parameters_khr(device C.VkDevice,
	video_session_parameters C.VkVideoSessionParametersKHR,
	p_update_info &VideoSessionParametersUpdateInfoKHR) Result {
	return C.vkUpdateVideoSessionParametersKHR(device, video_session_parameters, p_update_info)
}

fn C.vkDestroyVideoSessionParametersKHR(C.VkDevice, C.VkVideoSessionParametersKHR, &AllocationCallbacks)

pub type PFN_vkDestroyVideoSessionParametersKHR = fn (C.VkDevice, C.VkVideoSessionParametersKHR, &AllocationCallbacks)

@[inline]
pub fn destroy_video_session_parameters_khr(device C.VkDevice,
	video_session_parameters C.VkVideoSessionParametersKHR,
	p_allocator &AllocationCallbacks) {
	C.vkDestroyVideoSessionParametersKHR(device, video_session_parameters, p_allocator)
}

fn C.vkCmdBeginVideoCodingKHR(C.VkCommandBuffer, &VideoBeginCodingInfoKHR)

pub type PFN_vkCmdBeginVideoCodingKHR = fn (C.VkCommandBuffer, &VideoBeginCodingInfoKHR)

@[inline]
pub fn cmd_begin_video_coding_khr(command_buffer C.VkCommandBuffer,
	p_begin_info &VideoBeginCodingInfoKHR) {
	C.vkCmdBeginVideoCodingKHR(command_buffer, p_begin_info)
}

fn C.vkCmdEndVideoCodingKHR(C.VkCommandBuffer, &VideoEndCodingInfoKHR)

pub type PFN_vkCmdEndVideoCodingKHR = fn (C.VkCommandBuffer, &VideoEndCodingInfoKHR)

@[inline]
pub fn cmd_end_video_coding_khr(command_buffer C.VkCommandBuffer,
	p_end_coding_info &VideoEndCodingInfoKHR) {
	C.vkCmdEndVideoCodingKHR(command_buffer, p_end_coding_info)
}

fn C.vkCmdControlVideoCodingKHR(C.VkCommandBuffer, &VideoCodingControlInfoKHR)

pub type PFN_vkCmdControlVideoCodingKHR = fn (C.VkCommandBuffer, &VideoCodingControlInfoKHR)

@[inline]
pub fn cmd_control_video_coding_khr(command_buffer C.VkCommandBuffer,
	p_coding_control_info &VideoCodingControlInfoKHR) {
	C.vkCmdControlVideoCodingKHR(command_buffer, p_coding_control_info)
}

pub const khr_video_decode_queue_spec_version = 8
pub const khr_video_decode_queue_extension_name = 'VK_KHR_video_decode_queue'

pub enum VideoDecodeCapabilityFlagBitsKHR {
	dpb_and_output_coincide_bit_khr = int(0x00000001)
	dpb_and_output_distinct_bit_khr = int(0x00000002)
	max_enum_khr                    = max_int
}

pub type VideoDecodeCapabilityFlagsKHR = u32

pub enum VideoDecodeUsageFlagBitsKHR {
	default_khr         = 0
	transcoding_bit_khr = int(0x00000001)
	offline_bit_khr     = int(0x00000002)
	streaming_bit_khr   = int(0x00000004)
	max_enum_khr        = max_int
}

pub type VideoDecodeUsageFlagsKHR = u32
pub type VideoDecodeFlagsKHR = u32
pub type VideoDecodeCapabilitiesKHR = C.VkVideoDecodeCapabilitiesKHR

@[typedef]
pub struct C.VkVideoDecodeCapabilitiesKHR {
pub mut:
	sType StructureType = StructureType.video_decode_capabilities_khr
	pNext voidptr       = unsafe { nil }
	flags VideoDecodeCapabilityFlagsKHR
}

pub type VideoDecodeUsageInfoKHR = C.VkVideoDecodeUsageInfoKHR

@[typedef]
pub struct C.VkVideoDecodeUsageInfoKHR {
pub mut:
	sType           StructureType = StructureType.video_decode_usage_info_khr
	pNext           voidptr       = unsafe { nil }
	videoUsageHints VideoDecodeUsageFlagsKHR
}

pub type VideoDecodeInfoKHR = C.VkVideoDecodeInfoKHR

@[typedef]
pub struct C.VkVideoDecodeInfoKHR {
pub mut:
	sType               StructureType = StructureType.video_decode_info_khr
	pNext               voidptr       = unsafe { nil }
	flags               VideoDecodeFlagsKHR
	srcBuffer           C.VkBuffer
	srcBufferOffset     DeviceSize
	srcBufferRange      DeviceSize
	dstPictureResource  VideoPictureResourceInfoKHR
	pSetupReferenceSlot &VideoReferenceSlotInfoKHR
	referenceSlotCount  u32
	pReferenceSlots     &VideoReferenceSlotInfoKHR
}

fn C.vkCmdDecodeVideoKHR(C.VkCommandBuffer, &VideoDecodeInfoKHR)

pub type PFN_vkCmdDecodeVideoKHR = fn (C.VkCommandBuffer, &VideoDecodeInfoKHR)

@[inline]
pub fn cmd_decode_video_khr(command_buffer C.VkCommandBuffer,
	p_decode_info &VideoDecodeInfoKHR) {
	C.vkCmdDecodeVideoKHR(command_buffer, p_decode_info)
}

pub const khr_video_encode_h264_spec_version = 14
pub const khr_video_encode_h264_extension_name = 'VK_KHR_video_encode_h264'

pub enum VideoEncodeH264CapabilityFlagBitsKHR {
	hrd_compliance_bit_khr                    = int(0x00000001)
	prediction_weight_table_generated_bit_khr = int(0x00000002)
	row_unaligned_slice_bit_khr               = int(0x00000004)
	different_slice_type_bit_khr              = int(0x00000008)
	b_frame_in_l0_list_bit_khr                = int(0x00000010)
	b_frame_in_l1_list_bit_khr                = int(0x00000020)
	per_picture_type_min_max_qp_bit_khr       = int(0x00000040)
	per_slice_constant_qp_bit_khr             = int(0x00000080)
	generate_prefix_nalu_bit_khr              = int(0x00000100)
	max_enum_khr                              = max_int
}

pub type VideoEncodeH264CapabilityFlagsKHR = u32

pub enum VideoEncodeH264StdFlagBitsKHR {
	separate_color_plane_flag_set_bit_khr            = int(0x00000001)
	qpprime_y_zero_transform_bypass_flag_set_bit_khr = int(0x00000002)
	scaling_matrix_present_flag_set_bit_khr          = int(0x00000004)
	chroma_qp_index_offset_bit_khr                   = int(0x00000008)
	second_chroma_qp_index_offset_bit_khr            = int(0x00000010)
	pic_init_qp_minus26_bit_khr                      = int(0x00000020)
	weighted_pred_flag_set_bit_khr                   = int(0x00000040)
	weighted_bipred_idc_explicit_bit_khr             = int(0x00000080)
	weighted_bipred_idc_implicit_bit_khr             = int(0x00000100)
	transform8x8_mode_flag_set_bit_khr               = int(0x00000200)
	direct_spatial_mv_pred_flag_unset_bit_khr        = int(0x00000400)
	entropy_coding_mode_flag_unset_bit_khr           = int(0x00000800)
	entropy_coding_mode_flag_set_bit_khr             = int(0x00001000)
	direct8x8_inference_flag_unset_bit_khr           = int(0x00002000)
	constrained_intra_pred_flag_set_bit_khr          = int(0x00004000)
	deblocking_filter_disabled_bit_khr               = int(0x00008000)
	deblocking_filter_enabled_bit_khr                = int(0x00010000)
	deblocking_filter_partial_bit_khr                = int(0x00020000)
	slice_qp_delta_bit_khr                           = int(0x00080000)
	different_slice_qp_delta_bit_khr                 = int(0x00100000)
	max_enum_khr                                     = max_int
}

pub type VideoEncodeH264StdFlagsKHR = u32

pub enum VideoEncodeH264RateControlFlagBitsKHR {
	attempt_hrd_compliance_bit_khr        = int(0x00000001)
	regular_gop_bit_khr                   = int(0x00000002)
	reference_pattern_flat_bit_khr        = int(0x00000004)
	reference_pattern_dyadic_bit_khr      = int(0x00000008)
	temporal_layer_pattern_dyadic_bit_khr = int(0x00000010)
	max_enum_khr                          = max_int
}

pub type VideoEncodeH264RateControlFlagsKHR = u32
pub type VideoEncodeH264CapabilitiesKHR = C.VkVideoEncodeH264CapabilitiesKHR

@[typedef]
pub struct C.VkVideoEncodeH264CapabilitiesKHR {
pub mut:
	sType                            StructureType = StructureType.video_encode_h264_capabilities_khr
	pNext                            voidptr       = unsafe { nil }
	flags                            VideoEncodeH264CapabilityFlagsKHR
	maxLevelIdc                      StdVideoH264LevelIdc
	maxSliceCount                    u32
	maxPPictureL0ReferenceCount      u32
	maxBPictureL0ReferenceCount      u32
	maxL1ReferenceCount              u32
	maxTemporalLayerCount            u32
	expectDyadicTemporalLayerPattern Bool32
	minQp                            i32
	maxQp                            i32
	prefersGopRemainingFrames        Bool32
	requiresGopRemainingFrames       Bool32
	stdSyntaxFlags                   VideoEncodeH264StdFlagsKHR
}

pub type VideoEncodeH264QpKHR = C.VkVideoEncodeH264QpKHR

@[typedef]
pub struct C.VkVideoEncodeH264QpKHR {
pub mut:
	qpI i32
	qpP i32
	qpB i32
}

pub type VideoEncodeH264QualityLevelPropertiesKHR = C.VkVideoEncodeH264QualityLevelPropertiesKHR

@[typedef]
pub struct C.VkVideoEncodeH264QualityLevelPropertiesKHR {
pub mut:
	sType                             StructureType = StructureType.video_encode_h264_quality_level_properties_khr
	pNext                             voidptr       = unsafe { nil }
	preferredRateControlFlags         VideoEncodeH264RateControlFlagsKHR
	preferredGopFrameCount            u32
	preferredIdrPeriod                u32
	preferredConsecutiveBFrameCount   u32
	preferredTemporalLayerCount       u32
	preferredConstantQp               VideoEncodeH264QpKHR
	preferredMaxL0ReferenceCount      u32
	preferredMaxL1ReferenceCount      u32
	preferredStdEntropyCodingModeFlag Bool32
}

pub type VideoEncodeH264SessionCreateInfoKHR = C.VkVideoEncodeH264SessionCreateInfoKHR

@[typedef]
pub struct C.VkVideoEncodeH264SessionCreateInfoKHR {
pub mut:
	sType          StructureType = StructureType.video_encode_h264_session_create_info_khr
	pNext          voidptr       = unsafe { nil }
	useMaxLevelIdc Bool32
	maxLevelIdc    StdVideoH264LevelIdc
}

pub type VideoEncodeH264SessionParametersAddInfoKHR = C.VkVideoEncodeH264SessionParametersAddInfoKHR

@[typedef]
pub struct C.VkVideoEncodeH264SessionParametersAddInfoKHR {
pub mut:
	sType       StructureType = StructureType.video_encode_h264_session_parameters_add_info_khr
	pNext       voidptr       = unsafe { nil }
	stdSPSCount u32
	pStdSPSs    &StdVideoH264SequenceParameterSet
	stdPPSCount u32
	pStdPPSs    &StdVideoH264PictureParameterSet
}

pub type VideoEncodeH264SessionParametersCreateInfoKHR = C.VkVideoEncodeH264SessionParametersCreateInfoKHR

@[typedef]
pub struct C.VkVideoEncodeH264SessionParametersCreateInfoKHR {
pub mut:
	sType              StructureType = StructureType.video_encode_h264_session_parameters_create_info_khr
	pNext              voidptr       = unsafe { nil }
	maxStdSPSCount     u32
	maxStdPPSCount     u32
	pParametersAddInfo &VideoEncodeH264SessionParametersAddInfoKHR
}

pub type VideoEncodeH264SessionParametersGetInfoKHR = C.VkVideoEncodeH264SessionParametersGetInfoKHR

@[typedef]
pub struct C.VkVideoEncodeH264SessionParametersGetInfoKHR {
pub mut:
	sType       StructureType = StructureType.video_encode_h264_session_parameters_get_info_khr
	pNext       voidptr       = unsafe { nil }
	writeStdSPS Bool32
	writeStdPPS Bool32
	stdSPSId    u32
	stdPPSId    u32
}

pub type VideoEncodeH264SessionParametersFeedbackInfoKHR = C.VkVideoEncodeH264SessionParametersFeedbackInfoKHR

@[typedef]
pub struct C.VkVideoEncodeH264SessionParametersFeedbackInfoKHR {
pub mut:
	sType              StructureType = StructureType.video_encode_h264_session_parameters_feedback_info_khr
	pNext              voidptr       = unsafe { nil }
	hasStdSPSOverrides Bool32
	hasStdPPSOverrides Bool32
}

pub type VideoEncodeH264NaluSliceInfoKHR = C.VkVideoEncodeH264NaluSliceInfoKHR

@[typedef]
pub struct C.VkVideoEncodeH264NaluSliceInfoKHR {
pub mut:
	sType           StructureType = StructureType.video_encode_h264_nalu_slice_info_khr
	pNext           voidptr       = unsafe { nil }
	constantQp      i32
	pStdSliceHeader &StdVideoEncodeH264SliceHeader
}

pub type VideoEncodeH264PictureInfoKHR = C.VkVideoEncodeH264PictureInfoKHR

@[typedef]
pub struct C.VkVideoEncodeH264PictureInfoKHR {
pub mut:
	sType               StructureType = StructureType.video_encode_h264_picture_info_khr
	pNext               voidptr       = unsafe { nil }
	naluSliceEntryCount u32
	pNaluSliceEntries   &VideoEncodeH264NaluSliceInfoKHR
	pStdPictureInfo     &StdVideoEncodeH264PictureInfo
	generatePrefixNalu  Bool32
}

pub type VideoEncodeH264DpbSlotInfoKHR = C.VkVideoEncodeH264DpbSlotInfoKHR

@[typedef]
pub struct C.VkVideoEncodeH264DpbSlotInfoKHR {
pub mut:
	sType             StructureType = StructureType.video_encode_h264_dpb_slot_info_khr
	pNext             voidptr       = unsafe { nil }
	pStdReferenceInfo &StdVideoEncodeH264ReferenceInfo
}

pub type VideoEncodeH264ProfileInfoKHR = C.VkVideoEncodeH264ProfileInfoKHR

@[typedef]
pub struct C.VkVideoEncodeH264ProfileInfoKHR {
pub mut:
	sType         StructureType = StructureType.video_encode_h264_profile_info_khr
	pNext         voidptr       = unsafe { nil }
	stdProfileIdc StdVideoH264ProfileIdc
}

pub type VideoEncodeH264RateControlInfoKHR = C.VkVideoEncodeH264RateControlInfoKHR

@[typedef]
pub struct C.VkVideoEncodeH264RateControlInfoKHR {
pub mut:
	sType                  StructureType = StructureType.video_encode_h264_rate_control_info_khr
	pNext                  voidptr       = unsafe { nil }
	flags                  VideoEncodeH264RateControlFlagsKHR
	gopFrameCount          u32
	idrPeriod              u32
	consecutiveBFrameCount u32
	temporalLayerCount     u32
}

pub type VideoEncodeH264FrameSizeKHR = C.VkVideoEncodeH264FrameSizeKHR

@[typedef]
pub struct C.VkVideoEncodeH264FrameSizeKHR {
pub mut:
	frameISize u32
	framePSize u32
	frameBSize u32
}

pub type VideoEncodeH264RateControlLayerInfoKHR = C.VkVideoEncodeH264RateControlLayerInfoKHR

@[typedef]
pub struct C.VkVideoEncodeH264RateControlLayerInfoKHR {
pub mut:
	sType           StructureType = StructureType.video_encode_h264_rate_control_layer_info_khr
	pNext           voidptr       = unsafe { nil }
	useMinQp        Bool32
	minQp           VideoEncodeH264QpKHR
	useMaxQp        Bool32
	maxQp           VideoEncodeH264QpKHR
	useMaxFrameSize Bool32
	maxFrameSize    VideoEncodeH264FrameSizeKHR
}

pub type VideoEncodeH264GopRemainingFrameInfoKHR = C.VkVideoEncodeH264GopRemainingFrameInfoKHR

@[typedef]
pub struct C.VkVideoEncodeH264GopRemainingFrameInfoKHR {
pub mut:
	sType                 StructureType = StructureType.video_encode_h264_gop_remaining_frame_info_khr
	pNext                 voidptr       = unsafe { nil }
	useGopRemainingFrames Bool32
	gopRemainingI         u32
	gopRemainingP         u32
	gopRemainingB         u32
}

pub const khr_video_encode_h265_spec_version = 14
pub const khr_video_encode_h265_extension_name = 'VK_KHR_video_encode_h265'

pub enum VideoEncodeH265CapabilityFlagBitsKHR {
	hrd_compliance_bit_khr                    = int(0x00000001)
	prediction_weight_table_generated_bit_khr = int(0x00000002)
	row_unaligned_slice_segment_bit_khr       = int(0x00000004)
	different_slice_segment_type_bit_khr      = int(0x00000008)
	b_frame_in_l0_list_bit_khr                = int(0x00000010)
	b_frame_in_l1_list_bit_khr                = int(0x00000020)
	per_picture_type_min_max_qp_bit_khr       = int(0x00000040)
	per_slice_segment_constant_qp_bit_khr     = int(0x00000080)
	multiple_tiles_per_slice_segment_bit_khr  = int(0x00000100)
	multiple_slice_segments_per_tile_bit_khr  = int(0x00000200)
	max_enum_khr                              = max_int
}

pub type VideoEncodeH265CapabilityFlagsKHR = u32

pub enum VideoEncodeH265StdFlagBitsKHR {
	separate_color_plane_flag_set_bit_khr                = int(0x00000001)
	sample_adaptive_offset_enabled_flag_set_bit_khr      = int(0x00000002)
	scaling_list_data_present_flag_set_bit_khr           = int(0x00000004)
	pcm_enabled_flag_set_bit_khr                         = int(0x00000008)
	sps_temporal_mvp_enabled_flag_set_bit_khr            = int(0x00000010)
	init_qp_minus26_bit_khr                              = int(0x00000020)
	weighted_pred_flag_set_bit_khr                       = int(0x00000040)
	weighted_bipred_flag_set_bit_khr                     = int(0x00000080)
	log2_parallel_merge_level_minus2_bit_khr             = int(0x00000100)
	sign_data_hiding_enabled_flag_set_bit_khr            = int(0x00000200)
	transform_skip_enabled_flag_set_bit_khr              = int(0x00000400)
	transform_skip_enabled_flag_unset_bit_khr            = int(0x00000800)
	pps_slice_chroma_qp_offsets_present_flag_set_bit_khr = int(0x00001000)
	transquant_bypass_enabled_flag_set_bit_khr           = int(0x00002000)
	constrained_intra_pred_flag_set_bit_khr              = int(0x00004000)
	entropy_coding_sync_enabled_flag_set_bit_khr         = int(0x00008000)
	deblocking_filter_override_enabled_flag_set_bit_khr  = int(0x00010000)
	dependent_slice_segments_enabled_flag_set_bit_khr    = int(0x00020000)
	dependent_slice_segment_flag_set_bit_khr             = int(0x00040000)
	slice_qp_delta_bit_khr                               = int(0x00080000)
	different_slice_qp_delta_bit_khr                     = int(0x00100000)
	max_enum_khr                                         = max_int
}

pub type VideoEncodeH265StdFlagsKHR = u32

pub enum VideoEncodeH265CtbSizeFlagBitsKHR {
	_16_bit_khr  = int(0x00000001)
	_32_bit_khr  = int(0x00000002)
	_64_bit_khr  = int(0x00000004)
	max_enum_khr = max_int
}

pub type VideoEncodeH265CtbSizeFlagsKHR = u32

pub enum VideoEncodeH265TransformBlockSizeFlagBitsKHR {
	_4_bit_khr   = int(0x00000001)
	_8_bit_khr   = int(0x00000002)
	_16_bit_khr  = int(0x00000004)
	_32_bit_khr  = int(0x00000008)
	max_enum_khr = max_int
}

pub type VideoEncodeH265TransformBlockSizeFlagsKHR = u32

pub enum VideoEncodeH265RateControlFlagBitsKHR {
	attempt_hrd_compliance_bit_khr            = int(0x00000001)
	regular_gop_bit_khr                       = int(0x00000002)
	reference_pattern_flat_bit_khr            = int(0x00000004)
	reference_pattern_dyadic_bit_khr          = int(0x00000008)
	temporal_sub_layer_pattern_dyadic_bit_khr = int(0x00000010)
	max_enum_khr                              = max_int
}

pub type VideoEncodeH265RateControlFlagsKHR = u32
pub type VideoEncodeH265CapabilitiesKHR = C.VkVideoEncodeH265CapabilitiesKHR

@[typedef]
pub struct C.VkVideoEncodeH265CapabilitiesKHR {
pub mut:
	sType                               StructureType = StructureType.video_encode_h265_capabilities_khr
	pNext                               voidptr       = unsafe { nil }
	flags                               VideoEncodeH265CapabilityFlagsKHR
	maxLevelIdc                         StdVideoH265LevelIdc
	maxSliceSegmentCount                u32
	maxTiles                            Extent2D
	ctbSizes                            VideoEncodeH265CtbSizeFlagsKHR
	transformBlockSizes                 VideoEncodeH265TransformBlockSizeFlagsKHR
	maxPPictureL0ReferenceCount         u32
	maxBPictureL0ReferenceCount         u32
	maxL1ReferenceCount                 u32
	maxSubLayerCount                    u32
	expectDyadicTemporalSubLayerPattern Bool32
	minQp                               i32
	maxQp                               i32
	prefersGopRemainingFrames           Bool32
	requiresGopRemainingFrames          Bool32
	stdSyntaxFlags                      VideoEncodeH265StdFlagsKHR
}

pub type VideoEncodeH265SessionCreateInfoKHR = C.VkVideoEncodeH265SessionCreateInfoKHR

@[typedef]
pub struct C.VkVideoEncodeH265SessionCreateInfoKHR {
pub mut:
	sType          StructureType = StructureType.video_encode_h265_session_create_info_khr
	pNext          voidptr       = unsafe { nil }
	useMaxLevelIdc Bool32
	maxLevelIdc    StdVideoH265LevelIdc
}

pub type VideoEncodeH265QpKHR = C.VkVideoEncodeH265QpKHR

@[typedef]
pub struct C.VkVideoEncodeH265QpKHR {
pub mut:
	qpI i32
	qpP i32
	qpB i32
}

pub type VideoEncodeH265QualityLevelPropertiesKHR = C.VkVideoEncodeH265QualityLevelPropertiesKHR

@[typedef]
pub struct C.VkVideoEncodeH265QualityLevelPropertiesKHR {
pub mut:
	sType                           StructureType = StructureType.video_encode_h265_quality_level_properties_khr
	pNext                           voidptr       = unsafe { nil }
	preferredRateControlFlags       VideoEncodeH265RateControlFlagsKHR
	preferredGopFrameCount          u32
	preferredIdrPeriod              u32
	preferredConsecutiveBFrameCount u32
	preferredSubLayerCount          u32
	preferredConstantQp             VideoEncodeH265QpKHR
	preferredMaxL0ReferenceCount    u32
	preferredMaxL1ReferenceCount    u32
}

pub type VideoEncodeH265SessionParametersAddInfoKHR = C.VkVideoEncodeH265SessionParametersAddInfoKHR

@[typedef]
pub struct C.VkVideoEncodeH265SessionParametersAddInfoKHR {
pub mut:
	sType       StructureType = StructureType.video_encode_h265_session_parameters_add_info_khr
	pNext       voidptr       = unsafe { nil }
	stdVPSCount u32
	pStdVPSs    &StdVideoH265VideoParameterSet
	stdSPSCount u32
	pStdSPSs    &StdVideoH265SequenceParameterSet
	stdPPSCount u32
	pStdPPSs    &StdVideoH265PictureParameterSet
}

pub type VideoEncodeH265SessionParametersCreateInfoKHR = C.VkVideoEncodeH265SessionParametersCreateInfoKHR

@[typedef]
pub struct C.VkVideoEncodeH265SessionParametersCreateInfoKHR {
pub mut:
	sType              StructureType = StructureType.video_encode_h265_session_parameters_create_info_khr
	pNext              voidptr       = unsafe { nil }
	maxStdVPSCount     u32
	maxStdSPSCount     u32
	maxStdPPSCount     u32
	pParametersAddInfo &VideoEncodeH265SessionParametersAddInfoKHR
}

pub type VideoEncodeH265SessionParametersGetInfoKHR = C.VkVideoEncodeH265SessionParametersGetInfoKHR

@[typedef]
pub struct C.VkVideoEncodeH265SessionParametersGetInfoKHR {
pub mut:
	sType       StructureType = StructureType.video_encode_h265_session_parameters_get_info_khr
	pNext       voidptr       = unsafe { nil }
	writeStdVPS Bool32
	writeStdSPS Bool32
	writeStdPPS Bool32
	stdVPSId    u32
	stdSPSId    u32
	stdPPSId    u32
}

pub type VideoEncodeH265SessionParametersFeedbackInfoKHR = C.VkVideoEncodeH265SessionParametersFeedbackInfoKHR

@[typedef]
pub struct C.VkVideoEncodeH265SessionParametersFeedbackInfoKHR {
pub mut:
	sType              StructureType = StructureType.video_encode_h265_session_parameters_feedback_info_khr
	pNext              voidptr       = unsafe { nil }
	hasStdVPSOverrides Bool32
	hasStdSPSOverrides Bool32
	hasStdPPSOverrides Bool32
}

pub type VideoEncodeH265NaluSliceSegmentInfoKHR = C.VkVideoEncodeH265NaluSliceSegmentInfoKHR

@[typedef]
pub struct C.VkVideoEncodeH265NaluSliceSegmentInfoKHR {
pub mut:
	sType                  StructureType = StructureType.video_encode_h265_nalu_slice_segment_info_khr
	pNext                  voidptr       = unsafe { nil }
	constantQp             i32
	pStdSliceSegmentHeader &StdVideoEncodeH265SliceSegmentHeader
}

pub type VideoEncodeH265PictureInfoKHR = C.VkVideoEncodeH265PictureInfoKHR

@[typedef]
pub struct C.VkVideoEncodeH265PictureInfoKHR {
pub mut:
	sType                      StructureType = StructureType.video_encode_h265_picture_info_khr
	pNext                      voidptr       = unsafe { nil }
	naluSliceSegmentEntryCount u32
	pNaluSliceSegmentEntries   &VideoEncodeH265NaluSliceSegmentInfoKHR
	pStdPictureInfo            &StdVideoEncodeH265PictureInfo
}

pub type VideoEncodeH265DpbSlotInfoKHR = C.VkVideoEncodeH265DpbSlotInfoKHR

@[typedef]
pub struct C.VkVideoEncodeH265DpbSlotInfoKHR {
pub mut:
	sType             StructureType = StructureType.video_encode_h265_dpb_slot_info_khr
	pNext             voidptr       = unsafe { nil }
	pStdReferenceInfo &StdVideoEncodeH265ReferenceInfo
}

pub type VideoEncodeH265ProfileInfoKHR = C.VkVideoEncodeH265ProfileInfoKHR

@[typedef]
pub struct C.VkVideoEncodeH265ProfileInfoKHR {
pub mut:
	sType         StructureType = StructureType.video_encode_h265_profile_info_khr
	pNext         voidptr       = unsafe { nil }
	stdProfileIdc StdVideoH265ProfileIdc
}

pub type VideoEncodeH265RateControlInfoKHR = C.VkVideoEncodeH265RateControlInfoKHR

@[typedef]
pub struct C.VkVideoEncodeH265RateControlInfoKHR {
pub mut:
	sType                  StructureType = StructureType.video_encode_h265_rate_control_info_khr
	pNext                  voidptr       = unsafe { nil }
	flags                  VideoEncodeH265RateControlFlagsKHR
	gopFrameCount          u32
	idrPeriod              u32
	consecutiveBFrameCount u32
	subLayerCount          u32
}

pub type VideoEncodeH265FrameSizeKHR = C.VkVideoEncodeH265FrameSizeKHR

@[typedef]
pub struct C.VkVideoEncodeH265FrameSizeKHR {
pub mut:
	frameISize u32
	framePSize u32
	frameBSize u32
}

pub type VideoEncodeH265RateControlLayerInfoKHR = C.VkVideoEncodeH265RateControlLayerInfoKHR

@[typedef]
pub struct C.VkVideoEncodeH265RateControlLayerInfoKHR {
pub mut:
	sType           StructureType = StructureType.video_encode_h265_rate_control_layer_info_khr
	pNext           voidptr       = unsafe { nil }
	useMinQp        Bool32
	minQp           VideoEncodeH265QpKHR
	useMaxQp        Bool32
	maxQp           VideoEncodeH265QpKHR
	useMaxFrameSize Bool32
	maxFrameSize    VideoEncodeH265FrameSizeKHR
}

pub type VideoEncodeH265GopRemainingFrameInfoKHR = C.VkVideoEncodeH265GopRemainingFrameInfoKHR

@[typedef]
pub struct C.VkVideoEncodeH265GopRemainingFrameInfoKHR {
pub mut:
	sType                 StructureType = StructureType.video_encode_h265_gop_remaining_frame_info_khr
	pNext                 voidptr       = unsafe { nil }
	useGopRemainingFrames Bool32
	gopRemainingI         u32
	gopRemainingP         u32
	gopRemainingB         u32
}

pub const khr_video_decode_h264_spec_version = 9
pub const khr_video_decode_h264_extension_name = 'VK_KHR_video_decode_h264'

pub enum VideoDecodeH264PictureLayoutFlagBitsKHR {
	progressive_khr                      = 0
	interlaced_interleaved_lines_bit_khr = int(0x00000001)
	interlaced_separate_planes_bit_khr   = int(0x00000002)
	max_enum_khr                         = max_int
}

pub type VideoDecodeH264PictureLayoutFlagsKHR = u32
pub type VideoDecodeH264ProfileInfoKHR = C.VkVideoDecodeH264ProfileInfoKHR

@[typedef]
pub struct C.VkVideoDecodeH264ProfileInfoKHR {
pub mut:
	sType         StructureType = StructureType.video_decode_h264_profile_info_khr
	pNext         voidptr       = unsafe { nil }
	stdProfileIdc StdVideoH264ProfileIdc
	pictureLayout VideoDecodeH264PictureLayoutFlagBitsKHR
}

pub type VideoDecodeH264CapabilitiesKHR = C.VkVideoDecodeH264CapabilitiesKHR

@[typedef]
pub struct C.VkVideoDecodeH264CapabilitiesKHR {
pub mut:
	sType                  StructureType = StructureType.video_decode_h264_capabilities_khr
	pNext                  voidptr       = unsafe { nil }
	maxLevelIdc            StdVideoH264LevelIdc
	fieldOffsetGranularity Offset2D
}

pub type VideoDecodeH264SessionParametersAddInfoKHR = C.VkVideoDecodeH264SessionParametersAddInfoKHR

@[typedef]
pub struct C.VkVideoDecodeH264SessionParametersAddInfoKHR {
pub mut:
	sType       StructureType = StructureType.video_decode_h264_session_parameters_add_info_khr
	pNext       voidptr       = unsafe { nil }
	stdSPSCount u32
	pStdSPSs    &StdVideoH264SequenceParameterSet
	stdPPSCount u32
	pStdPPSs    &StdVideoH264PictureParameterSet
}

pub type VideoDecodeH264SessionParametersCreateInfoKHR = C.VkVideoDecodeH264SessionParametersCreateInfoKHR

@[typedef]
pub struct C.VkVideoDecodeH264SessionParametersCreateInfoKHR {
pub mut:
	sType              StructureType = StructureType.video_decode_h264_session_parameters_create_info_khr
	pNext              voidptr       = unsafe { nil }
	maxStdSPSCount     u32
	maxStdPPSCount     u32
	pParametersAddInfo &VideoDecodeH264SessionParametersAddInfoKHR
}

pub type VideoDecodeH264PictureInfoKHR = C.VkVideoDecodeH264PictureInfoKHR

@[typedef]
pub struct C.VkVideoDecodeH264PictureInfoKHR {
pub mut:
	sType           StructureType = StructureType.video_decode_h264_picture_info_khr
	pNext           voidptr       = unsafe { nil }
	pStdPictureInfo &StdVideoDecodeH264PictureInfo
	sliceCount      u32
	pSliceOffsets   &u32
}

pub type VideoDecodeH264DpbSlotInfoKHR = C.VkVideoDecodeH264DpbSlotInfoKHR

@[typedef]
pub struct C.VkVideoDecodeH264DpbSlotInfoKHR {
pub mut:
	sType             StructureType = StructureType.video_decode_h264_dpb_slot_info_khr
	pNext             voidptr       = unsafe { nil }
	pStdReferenceInfo &StdVideoDecodeH264ReferenceInfo
}

pub const khr_dynamic_rendering_spec_version = 1
pub const khr_dynamic_rendering_extension_name = 'VK_KHR_dynamic_rendering'

pub type RenderingFlagsKHR = u32
pub type RenderingFlagBitsKHR = RenderingFlagBits

pub type RenderingInfoKHR = C.VkRenderingInfo

pub type RenderingAttachmentInfoKHR = C.VkRenderingAttachmentInfo

pub type PipelineRenderingCreateInfoKHR = C.VkPipelineRenderingCreateInfo

pub type PhysicalDeviceDynamicRenderingFeaturesKHR = C.VkPhysicalDeviceDynamicRenderingFeatures

pub type CommandBufferInheritanceRenderingInfoKHR = C.VkCommandBufferInheritanceRenderingInfo

pub type RenderingFragmentShadingRateAttachmentInfoKHR = C.VkRenderingFragmentShadingRateAttachmentInfoKHR

@[typedef]
pub struct C.VkRenderingFragmentShadingRateAttachmentInfoKHR {
pub mut:
	sType                          StructureType = StructureType.rendering_fragment_shading_rate_attachment_info_khr
	pNext                          voidptr       = unsafe { nil }
	imageView                      C.VkImageView
	imageLayout                    ImageLayout
	shadingRateAttachmentTexelSize Extent2D
}

pub type RenderingFragmentDensityMapAttachmentInfoEXT = C.VkRenderingFragmentDensityMapAttachmentInfoEXT

@[typedef]
pub struct C.VkRenderingFragmentDensityMapAttachmentInfoEXT {
pub mut:
	sType       StructureType = StructureType.rendering_fragment_density_map_attachment_info_ext
	pNext       voidptr       = unsafe { nil }
	imageView   C.VkImageView
	imageLayout ImageLayout
}

pub type AttachmentSampleCountInfoAMD = C.VkAttachmentSampleCountInfoAMD

@[typedef]
pub struct C.VkAttachmentSampleCountInfoAMD {
pub mut:
	sType                         StructureType = StructureType.attachment_sample_count_info_amd
	pNext                         voidptr       = unsafe { nil }
	colorAttachmentCount          u32
	pColorAttachmentSamples       &SampleCountFlagBits
	depthStencilAttachmentSamples SampleCountFlagBits
}

pub type AttachmentSampleCountInfoNV = C.VkAttachmentSampleCountInfoAMD

pub type MultiviewPerViewAttributesInfoNVX = C.VkMultiviewPerViewAttributesInfoNVX

@[typedef]
pub struct C.VkMultiviewPerViewAttributesInfoNVX {
pub mut:
	sType                          StructureType = StructureType.multiview_per_view_attributes_info_nvx
	pNext                          voidptr       = unsafe { nil }
	perViewAttributes              Bool32
	perViewAttributesPositionXOnly Bool32
}

pub const khr_multiview_spec_version = 1
pub const khr_multiview_extension_name = 'VK_KHR_multiview'

pub type RenderPassMultiviewCreateInfoKHR = C.VkRenderPassMultiviewCreateInfo

pub type PhysicalDeviceMultiviewFeaturesKHR = C.VkPhysicalDeviceMultiviewFeatures

pub type PhysicalDeviceMultiviewPropertiesKHR = C.VkPhysicalDeviceMultiviewProperties

pub const khr_get_physical_device_properties_2_spec_version = 2
pub const khr_get_physical_device_properties_2_extension_name = 'VK_KHR_get_physical_device_properties2'

pub type PhysicalDeviceFeatures2KHR = C.VkPhysicalDeviceFeatures2

pub type PhysicalDeviceProperties2KHR = C.VkPhysicalDeviceProperties2

pub type FormatProperties2KHR = C.VkFormatProperties2

pub type ImageFormatProperties2KHR = C.VkImageFormatProperties2

pub type PhysicalDeviceImageFormatInfo2KHR = C.VkPhysicalDeviceImageFormatInfo2

pub type QueueFamilyProperties2KHR = C.VkQueueFamilyProperties2

pub type PhysicalDeviceMemoryProperties2KHR = C.VkPhysicalDeviceMemoryProperties2

pub type SparseImageFormatProperties2KHR = C.VkSparseImageFormatProperties2

pub type PhysicalDeviceSparseImageFormatInfo2KHR = C.VkPhysicalDeviceSparseImageFormatInfo2

pub const khr_device_group_spec_version = 4
pub const khr_device_group_extension_name = 'VK_KHR_device_group'

pub type PeerMemoryFeatureFlagsKHR = u32
pub type PeerMemoryFeatureFlagBitsKHR = PeerMemoryFeatureFlagBits

pub type MemoryAllocateFlagsKHR = u32
pub type MemoryAllocateFlagBitsKHR = MemoryAllocateFlagBits

pub type MemoryAllocateFlagsInfoKHR = C.VkMemoryAllocateFlagsInfo

pub type DeviceGroupRenderPassBeginInfoKHR = C.VkDeviceGroupRenderPassBeginInfo

pub type DeviceGroupCommandBufferBeginInfoKHR = C.VkDeviceGroupCommandBufferBeginInfo

pub type DeviceGroupSubmitInfoKHR = C.VkDeviceGroupSubmitInfo

pub type DeviceGroupBindSparseInfoKHR = C.VkDeviceGroupBindSparseInfo

pub type BindBufferMemoryDeviceGroupInfoKHR = C.VkBindBufferMemoryDeviceGroupInfo

pub type BindImageMemoryDeviceGroupInfoKHR = C.VkBindImageMemoryDeviceGroupInfo

pub const khr_shader_draw_parameters_spec_version = 1
pub const khr_shader_draw_parameters_extension_name = 'VK_KHR_shader_draw_parameters'

pub const khr_maintenance_1_spec_version = 2
pub const khr_maintenance_1_extension_name = 'VK_KHR_maintenance1'
// VK_KHR_MAINTENANCE1_SPEC_VERSION is a deprecated alias
pub const khr_maintenance1_spec_version = khr_maintenance_1_spec_version
// VK_KHR_MAINTENANCE1_EXTENSION_NAME is a deprecated alias
pub const khr_maintenance1_extension_name = khr_maintenance_1_extension_name

pub type CommandPoolTrimFlagsKHR = u32

pub const khr_device_group_creation_spec_version = 1
pub const khr_device_group_creation_extension_name = 'VK_KHR_device_group_creation'
pub const max_device_group_size_khr = max_device_group_size

pub type PhysicalDeviceGroupPropertiesKHR = C.VkPhysicalDeviceGroupProperties

pub type DeviceGroupDeviceCreateInfoKHR = C.VkDeviceGroupDeviceCreateInfo

pub const khr_external_memory_capabilities_spec_version = 1
pub const khr_external_memory_capabilities_extension_name = 'VK_KHR_external_memory_capabilities'
pub const luid_size_khr = luid_size

pub type ExternalMemoryHandleTypeFlagsKHR = u32
pub type ExternalMemoryHandleTypeFlagBitsKHR = ExternalMemoryHandleTypeFlagBits

pub type ExternalMemoryFeatureFlagsKHR = u32
pub type ExternalMemoryFeatureFlagBitsKHR = ExternalMemoryFeatureFlagBits

pub type ExternalMemoryPropertiesKHR = C.VkExternalMemoryProperties

pub type PhysicalDeviceExternalImageFormatInfoKHR = C.VkPhysicalDeviceExternalImageFormatInfo

pub type ExternalImageFormatPropertiesKHR = C.VkExternalImageFormatProperties

pub type PhysicalDeviceExternalBufferInfoKHR = C.VkPhysicalDeviceExternalBufferInfo

pub type ExternalBufferPropertiesKHR = C.VkExternalBufferProperties

pub type PhysicalDeviceIDPropertiesKHR = C.VkPhysicalDeviceIDProperties

pub const khr_external_memory_spec_version = 1
pub const khr_external_memory_extension_name = 'VK_KHR_external_memory'
pub const queue_family_external_khr = queue_family_external

pub type ExternalMemoryImageCreateInfoKHR = C.VkExternalMemoryImageCreateInfo

pub type ExternalMemoryBufferCreateInfoKHR = C.VkExternalMemoryBufferCreateInfo

pub type ExportMemoryAllocateInfoKHR = C.VkExportMemoryAllocateInfo

pub const khr_external_memory_fd_spec_version = 1
pub const khr_external_memory_fd_extension_name = 'VK_KHR_external_memory_fd'

pub type ImportMemoryFdInfoKHR = C.VkImportMemoryFdInfoKHR

@[typedef]
pub struct C.VkImportMemoryFdInfoKHR {
pub mut:
	sType      StructureType = StructureType.import_memory_fd_info_khr
	pNext      voidptr       = unsafe { nil }
	handleType ExternalMemoryHandleTypeFlagBits
	fd         int
}

pub type MemoryFdPropertiesKHR = C.VkMemoryFdPropertiesKHR

@[typedef]
pub struct C.VkMemoryFdPropertiesKHR {
pub mut:
	sType          StructureType = StructureType.memory_fd_properties_khr
	pNext          voidptr       = unsafe { nil }
	memoryTypeBits u32
}

pub type MemoryGetFdInfoKHR = C.VkMemoryGetFdInfoKHR

@[typedef]
pub struct C.VkMemoryGetFdInfoKHR {
pub mut:
	sType      StructureType = StructureType.memory_get_fd_info_khr
	pNext      voidptr       = unsafe { nil }
	memory     C.VkDeviceMemory
	handleType ExternalMemoryHandleTypeFlagBits
}

fn C.vkGetMemoryFdKHR(C.VkDevice, &MemoryGetFdInfoKHR, &int) Result

pub type PFN_vkGetMemoryFdKHR = fn (C.VkDevice, &MemoryGetFdInfoKHR, &int) Result

@[inline]
pub fn get_memory_fd_khr(device C.VkDevice,
	p_get_fd_info &MemoryGetFdInfoKHR,
	p_fd &int) Result {
	return C.vkGetMemoryFdKHR(device, p_get_fd_info, p_fd)
}

fn C.vkGetMemoryFdPropertiesKHR(C.VkDevice, ExternalMemoryHandleTypeFlagBits, int, &MemoryFdPropertiesKHR) Result

pub type PFN_vkGetMemoryFdPropertiesKHR = fn (C.VkDevice, ExternalMemoryHandleTypeFlagBits, int, &MemoryFdPropertiesKHR) Result

@[inline]
pub fn get_memory_fd_properties_khr(device C.VkDevice,
	handle_type ExternalMemoryHandleTypeFlagBits,
	fd int,
	p_memory_fd_properties &MemoryFdPropertiesKHR) Result {
	return C.vkGetMemoryFdPropertiesKHR(device, handle_type, fd, p_memory_fd_properties)
}

pub const khr_external_semaphore_capabilities_spec_version = 1
pub const khr_external_semaphore_capabilities_extension_name = 'VK_KHR_external_semaphore_capabilities'

pub type ExternalSemaphoreHandleTypeFlagsKHR = u32
pub type ExternalSemaphoreHandleTypeFlagBitsKHR = ExternalSemaphoreHandleTypeFlagBits

pub type ExternalSemaphoreFeatureFlagsKHR = u32
pub type ExternalSemaphoreFeatureFlagBitsKHR = ExternalSemaphoreFeatureFlagBits

pub type PhysicalDeviceExternalSemaphoreInfoKHR = C.VkPhysicalDeviceExternalSemaphoreInfo

pub type ExternalSemaphorePropertiesKHR = C.VkExternalSemaphoreProperties

pub const khr_external_semaphore_spec_version = 1
pub const khr_external_semaphore_extension_name = 'VK_KHR_external_semaphore'

pub type SemaphoreImportFlagsKHR = u32
pub type SemaphoreImportFlagBitsKHR = SemaphoreImportFlagBits

pub type ExportSemaphoreCreateInfoKHR = C.VkExportSemaphoreCreateInfo

pub const khr_external_semaphore_fd_spec_version = 1
pub const khr_external_semaphore_fd_extension_name = 'VK_KHR_external_semaphore_fd'

pub type ImportSemaphoreFdInfoKHR = C.VkImportSemaphoreFdInfoKHR

@[typedef]
pub struct C.VkImportSemaphoreFdInfoKHR {
pub mut:
	sType      StructureType = StructureType.import_semaphore_fd_info_khr
	pNext      voidptr       = unsafe { nil }
	semaphore  C.VkSemaphore
	flags      SemaphoreImportFlags
	handleType ExternalSemaphoreHandleTypeFlagBits
	fd         int
}

pub type SemaphoreGetFdInfoKHR = C.VkSemaphoreGetFdInfoKHR

@[typedef]
pub struct C.VkSemaphoreGetFdInfoKHR {
pub mut:
	sType      StructureType = StructureType.semaphore_get_fd_info_khr
	pNext      voidptr       = unsafe { nil }
	semaphore  C.VkSemaphore
	handleType ExternalSemaphoreHandleTypeFlagBits
}

fn C.vkImportSemaphoreFdKHR(C.VkDevice, &ImportSemaphoreFdInfoKHR) Result

pub type PFN_vkImportSemaphoreFdKHR = fn (C.VkDevice, &ImportSemaphoreFdInfoKHR) Result

@[inline]
pub fn import_semaphore_fd_khr(device C.VkDevice,
	p_import_semaphore_fd_info &ImportSemaphoreFdInfoKHR) Result {
	return C.vkImportSemaphoreFdKHR(device, p_import_semaphore_fd_info)
}

fn C.vkGetSemaphoreFdKHR(C.VkDevice, &SemaphoreGetFdInfoKHR, &int) Result

pub type PFN_vkGetSemaphoreFdKHR = fn (C.VkDevice, &SemaphoreGetFdInfoKHR, &int) Result

@[inline]
pub fn get_semaphore_fd_khr(device C.VkDevice,
	p_get_fd_info &SemaphoreGetFdInfoKHR,
	p_fd &int) Result {
	return C.vkGetSemaphoreFdKHR(device, p_get_fd_info, p_fd)
}

pub const khr_push_descriptor_spec_version = 2
pub const khr_push_descriptor_extension_name = 'VK_KHR_push_descriptor'

pub type PhysicalDevicePushDescriptorPropertiesKHR = C.VkPhysicalDevicePushDescriptorPropertiesKHR

@[typedef]
pub struct C.VkPhysicalDevicePushDescriptorPropertiesKHR {
pub mut:
	sType              StructureType = StructureType.physical_device_push_descriptor_properties_khr
	pNext              voidptr       = unsafe { nil }
	maxPushDescriptors u32
}

fn C.vkCmdPushDescriptorSetKHR(C.VkCommandBuffer, PipelineBindPoint, C.VkPipelineLayout, u32, u32, &WriteDescriptorSet)

pub type PFN_vkCmdPushDescriptorSetKHR = fn (C.VkCommandBuffer, PipelineBindPoint, C.VkPipelineLayout, u32, u32, &WriteDescriptorSet)

@[inline]
pub fn cmd_push_descriptor_set_khr(command_buffer C.VkCommandBuffer,
	pipeline_bind_point PipelineBindPoint,
	layout C.VkPipelineLayout,
	set u32,
	descriptor_write_count u32,
	p_descriptor_writes &WriteDescriptorSet) {
	C.vkCmdPushDescriptorSetKHR(command_buffer, pipeline_bind_point, layout, set, descriptor_write_count,
		p_descriptor_writes)
}

fn C.vkCmdPushDescriptorSetWithTemplateKHR(C.VkCommandBuffer, C.VkDescriptorUpdateTemplate, C.VkPipelineLayout, u32, voidptr)

pub type PFN_vkCmdPushDescriptorSetWithTemplateKHR = fn (C.VkCommandBuffer, C.VkDescriptorUpdateTemplate, C.VkPipelineLayout, u32, voidptr)

@[inline]
pub fn cmd_push_descriptor_set_with_template_khr(command_buffer C.VkCommandBuffer,
	descriptor_update_template C.VkDescriptorUpdateTemplate,
	layout C.VkPipelineLayout,
	set u32,
	p_data voidptr) {
	C.vkCmdPushDescriptorSetWithTemplateKHR(command_buffer, descriptor_update_template,
		layout, set, p_data)
}

pub const khr_shader_float16_int8_spec_version = 1
pub const khr_shader_float16_int8_extension_name = 'VK_KHR_shader_float16_int8'

pub type PhysicalDeviceShaderFloat16Int8FeaturesKHR = C.VkPhysicalDeviceShaderFloat16Int8Features

pub type PhysicalDeviceFloat16Int8FeaturesKHR = C.VkPhysicalDeviceShaderFloat16Int8Features

pub const khr_16bit_storage_spec_version = 1
pub const khr_16bit_storage_extension_name = 'VK_KHR_16bit_storage'

pub type PhysicalDevice16BitStorageFeaturesKHR = C.VkPhysicalDevice16BitStorageFeatures

pub const khr_incremental_present_spec_version = 2
pub const khr_incremental_present_extension_name = 'VK_KHR_incremental_present'

pub type RectLayerKHR = C.VkRectLayerKHR

@[typedef]
pub struct C.VkRectLayerKHR {
pub mut:
	offset Offset2D
	extent Extent2D
	layer  u32
}

pub type PresentRegionKHR = C.VkPresentRegionKHR

@[typedef]
pub struct C.VkPresentRegionKHR {
pub mut:
	rectangleCount u32
	pRectangles    &RectLayerKHR
}

pub type PresentRegionsKHR = C.VkPresentRegionsKHR

@[typedef]
pub struct C.VkPresentRegionsKHR {
pub mut:
	sType          StructureType = StructureType.present_regions_khr
	pNext          voidptr       = unsafe { nil }
	swapchainCount u32
	pRegions       &PresentRegionKHR
}

pub type DescriptorUpdateTemplateKHR = voidptr

pub const khr_descriptor_update_template_spec_version = 1
pub const khr_descriptor_update_template_extension_name = 'VK_KHR_descriptor_update_template'

pub type DescriptorUpdateTemplateTypeKHR = DescriptorUpdateTemplateType

pub type DescriptorUpdateTemplateCreateFlagsKHR = u32
pub type DescriptorUpdateTemplateEntryKHR = C.VkDescriptorUpdateTemplateEntry

pub type DescriptorUpdateTemplateCreateInfoKHR = C.VkDescriptorUpdateTemplateCreateInfo

pub const khr_imageless_framebuffer_spec_version = 1
pub const khr_imageless_framebuffer_extension_name = 'VK_KHR_imageless_framebuffer'

pub type PhysicalDeviceImagelessFramebufferFeaturesKHR = C.VkPhysicalDeviceImagelessFramebufferFeatures

pub type FramebufferAttachmentsCreateInfoKHR = C.VkFramebufferAttachmentsCreateInfo

pub type FramebufferAttachmentImageInfoKHR = C.VkFramebufferAttachmentImageInfo

pub type RenderPassAttachmentBeginInfoKHR = C.VkRenderPassAttachmentBeginInfo

pub const khr_create_renderpass_2_spec_version = 1
pub const khr_create_renderpass_2_extension_name = 'VK_KHR_create_renderpass2'

pub type RenderPassCreateInfo2KHR = C.VkRenderPassCreateInfo2

pub type AttachmentDescription2KHR = C.VkAttachmentDescription2

pub type AttachmentReference2KHR = C.VkAttachmentReference2

pub type SubpassDescription2KHR = C.VkSubpassDescription2

pub type SubpassDependency2KHR = C.VkSubpassDependency2

pub type SubpassBeginInfoKHR = C.VkSubpassBeginInfo

pub type SubpassEndInfoKHR = C.VkSubpassEndInfo

pub const khr_shared_presentable_image_spec_version = 1
pub const khr_shared_presentable_image_extension_name = 'VK_KHR_shared_presentable_image'

pub type SharedPresentSurfaceCapabilitiesKHR = C.VkSharedPresentSurfaceCapabilitiesKHR

@[typedef]
pub struct C.VkSharedPresentSurfaceCapabilitiesKHR {
pub mut:
	sType                            StructureType = StructureType.shared_present_surface_capabilities_khr
	pNext                            voidptr       = unsafe { nil }
	sharedPresentSupportedUsageFlags ImageUsageFlags
}

fn C.vkGetSwapchainStatusKHR(C.VkDevice, C.VkSwapchainKHR) Result

pub type PFN_vkGetSwapchainStatusKHR = fn (C.VkDevice, C.VkSwapchainKHR) Result

@[inline]
pub fn get_swapchain_status_khr(device C.VkDevice,
	swapchain C.VkSwapchainKHR) Result {
	return C.vkGetSwapchainStatusKHR(device, swapchain)
}

pub const khr_external_fence_capabilities_spec_version = 1
pub const khr_external_fence_capabilities_extension_name = 'VK_KHR_external_fence_capabilities'

pub type ExternalFenceHandleTypeFlagsKHR = u32
pub type ExternalFenceHandleTypeFlagBitsKHR = ExternalFenceHandleTypeFlagBits

pub type ExternalFenceFeatureFlagsKHR = u32
pub type ExternalFenceFeatureFlagBitsKHR = ExternalFenceFeatureFlagBits

pub type PhysicalDeviceExternalFenceInfoKHR = C.VkPhysicalDeviceExternalFenceInfo

pub type ExternalFencePropertiesKHR = C.VkExternalFenceProperties

pub const khr_external_fence_spec_version = 1
pub const khr_external_fence_extension_name = 'VK_KHR_external_fence'

pub type FenceImportFlagsKHR = u32
pub type FenceImportFlagBitsKHR = FenceImportFlagBits

pub type ExportFenceCreateInfoKHR = C.VkExportFenceCreateInfo

pub const khr_external_fence_fd_spec_version = 1
pub const khr_external_fence_fd_extension_name = 'VK_KHR_external_fence_fd'

pub type ImportFenceFdInfoKHR = C.VkImportFenceFdInfoKHR

@[typedef]
pub struct C.VkImportFenceFdInfoKHR {
pub mut:
	sType      StructureType = StructureType.import_fence_fd_info_khr
	pNext      voidptr       = unsafe { nil }
	fence      C.VkFence
	flags      FenceImportFlags
	handleType ExternalFenceHandleTypeFlagBits
	fd         int
}

pub type FenceGetFdInfoKHR = C.VkFenceGetFdInfoKHR

@[typedef]
pub struct C.VkFenceGetFdInfoKHR {
pub mut:
	sType      StructureType = StructureType.fence_get_fd_info_khr
	pNext      voidptr       = unsafe { nil }
	fence      C.VkFence
	handleType ExternalFenceHandleTypeFlagBits
}

fn C.vkImportFenceFdKHR(C.VkDevice, &ImportFenceFdInfoKHR) Result

pub type PFN_vkImportFenceFdKHR = fn (C.VkDevice, &ImportFenceFdInfoKHR) Result

@[inline]
pub fn import_fence_fd_khr(device C.VkDevice,
	p_import_fence_fd_info &ImportFenceFdInfoKHR) Result {
	return C.vkImportFenceFdKHR(device, p_import_fence_fd_info)
}

fn C.vkGetFenceFdKHR(C.VkDevice, &FenceGetFdInfoKHR, &int) Result

pub type PFN_vkGetFenceFdKHR = fn (C.VkDevice, &FenceGetFdInfoKHR, &int) Result

@[inline]
pub fn get_fence_fd_khr(device C.VkDevice,
	p_get_fd_info &FenceGetFdInfoKHR,
	p_fd &int) Result {
	return C.vkGetFenceFdKHR(device, p_get_fd_info, p_fd)
}

pub const khr_performance_query_spec_version = 1
pub const khr_performance_query_extension_name = 'VK_KHR_performance_query'

pub enum PerformanceCounterUnitKHR {
	generic_khr          = 0
	percentage_khr       = 1
	nanoseconds_khr      = 2
	bytes_khr            = 3
	bytes_per_second_khr = 4
	kelvin_khr           = 5
	watts_khr            = 6
	volts_khr            = 7
	amps_khr             = 8
	hertz_khr            = 9
	cycles_khr           = 10
	max_enum_khr         = max_int
}

pub enum PerformanceCounterScopeKHR {
	command_buffer_khr = 0
	render_pass_khr    = 1
	command_khr        = 2
	max_enum_khr       = max_int
}

pub enum PerformanceCounterStorageKHR {
	int32_khr    = 0
	int64_khr    = 1
	uint32_khr   = 2
	uint64_khr   = 3
	float32_khr  = 4
	float64_khr  = 5
	max_enum_khr = max_int
}

pub enum PerformanceCounterDescriptionFlagBitsKHR {
	performance_impacting_bit_khr = int(0x00000001)
	concurrently_impacted_bit_khr = int(0x00000002)
	max_enum_khr                  = max_int
}

pub type PerformanceCounterDescriptionFlagsKHR = u32

pub enum AcquireProfilingLockFlagBitsKHR {
	max_enum_khr = max_int
}

pub type AcquireProfilingLockFlagsKHR = u32
pub type PhysicalDevicePerformanceQueryFeaturesKHR = C.VkPhysicalDevicePerformanceQueryFeaturesKHR

@[typedef]
pub struct C.VkPhysicalDevicePerformanceQueryFeaturesKHR {
pub mut:
	sType                                StructureType = StructureType.physical_device_performance_query_features_khr
	pNext                                voidptr       = unsafe { nil }
	performanceCounterQueryPools         Bool32
	performanceCounterMultipleQueryPools Bool32
}

pub type PhysicalDevicePerformanceQueryPropertiesKHR = C.VkPhysicalDevicePerformanceQueryPropertiesKHR

@[typedef]
pub struct C.VkPhysicalDevicePerformanceQueryPropertiesKHR {
pub mut:
	sType                         StructureType = StructureType.physical_device_performance_query_properties_khr
	pNext                         voidptr       = unsafe { nil }
	allowCommandBufferQueryCopies Bool32
}

pub type PerformanceCounterKHR = C.VkPerformanceCounterKHR

@[typedef]
pub struct C.VkPerformanceCounterKHR {
pub mut:
	sType   StructureType = StructureType.performance_counter_khr
	pNext   voidptr       = unsafe { nil }
	unit    PerformanceCounterUnitKHR
	scope   PerformanceCounterScopeKHR
	storage PerformanceCounterStorageKHR
	uuid    [uuid_size]u8
}

pub type PerformanceCounterDescriptionKHR = C.VkPerformanceCounterDescriptionKHR

@[typedef]
pub struct C.VkPerformanceCounterDescriptionKHR {
pub mut:
	sType       StructureType = StructureType.performance_counter_description_khr
	pNext       voidptr       = unsafe { nil }
	flags       PerformanceCounterDescriptionFlagsKHR
	name        [max_description_size]char
	category    [max_description_size]char
	description [max_description_size]char
}

pub type QueryPoolPerformanceCreateInfoKHR = C.VkQueryPoolPerformanceCreateInfoKHR

@[typedef]
pub struct C.VkQueryPoolPerformanceCreateInfoKHR {
pub mut:
	sType             StructureType = StructureType.query_pool_performance_create_info_khr
	pNext             voidptr       = unsafe { nil }
	queueFamilyIndex  u32
	counterIndexCount u32
	pCounterIndices   &u32
}

pub type PerformanceCounterResultKHR = C.VkPerformanceCounterResultKHR

@[typedef]
pub union C.VkPerformanceCounterResultKHR {
pub mut:
	int32   i32
	int64   i64
	uint32  u32
	uint64  u64
	float32 f32
	float64 f64
}

pub type AcquireProfilingLockInfoKHR = C.VkAcquireProfilingLockInfoKHR

@[typedef]
pub struct C.VkAcquireProfilingLockInfoKHR {
pub mut:
	sType   StructureType = StructureType.acquire_profiling_lock_info_khr
	pNext   voidptr       = unsafe { nil }
	flags   AcquireProfilingLockFlagsKHR
	timeout u64
}

pub type PerformanceQuerySubmitInfoKHR = C.VkPerformanceQuerySubmitInfoKHR

@[typedef]
pub struct C.VkPerformanceQuerySubmitInfoKHR {
pub mut:
	sType            StructureType = StructureType.performance_query_submit_info_khr
	pNext            voidptr       = unsafe { nil }
	counterPassIndex u32
}

fn C.vkEnumeratePhysicalDeviceQueueFamilyPerformanceQueryCountersKHR(C.VkPhysicalDevice, u32, &u32, &PerformanceCounterKHR, &PerformanceCounterDescriptionKHR) Result

pub type PFN_vkEnumeratePhysicalDeviceQueueFamilyPerformanceQueryCountersKHR = fn (C.VkPhysicalDevice, u32, &u32, &PerformanceCounterKHR, &PerformanceCounterDescriptionKHR) Result

@[inline]
pub fn enumerate_physical_device_queue_family_performance_query_counters_khr(physical_device C.VkPhysicalDevice,
	queue_family_index u32,
	p_counter_count &u32,
	p_counters &PerformanceCounterKHR,
	p_counter_descriptions &PerformanceCounterDescriptionKHR) Result {
	return C.vkEnumeratePhysicalDeviceQueueFamilyPerformanceQueryCountersKHR(physical_device,
		queue_family_index, p_counter_count, p_counters, p_counter_descriptions)
}

fn C.vkGetPhysicalDeviceQueueFamilyPerformanceQueryPassesKHR(C.VkPhysicalDevice, &QueryPoolPerformanceCreateInfoKHR, &u32)

pub type PFN_vkGetPhysicalDeviceQueueFamilyPerformanceQueryPassesKHR = fn (C.VkPhysicalDevice, &QueryPoolPerformanceCreateInfoKHR, &u32)

@[inline]
pub fn get_physical_device_queue_family_performance_query_passes_khr(physical_device C.VkPhysicalDevice,
	p_performance_query_create_info &QueryPoolPerformanceCreateInfoKHR,
	p_num_passes &u32) {
	C.vkGetPhysicalDeviceQueueFamilyPerformanceQueryPassesKHR(physical_device, p_performance_query_create_info,
		p_num_passes)
}

fn C.vkAcquireProfilingLockKHR(C.VkDevice, &AcquireProfilingLockInfoKHR) Result

pub type PFN_vkAcquireProfilingLockKHR = fn (C.VkDevice, &AcquireProfilingLockInfoKHR) Result

@[inline]
pub fn acquire_profiling_lock_khr(device C.VkDevice,
	p_info &AcquireProfilingLockInfoKHR) Result {
	return C.vkAcquireProfilingLockKHR(device, p_info)
}

fn C.vkReleaseProfilingLockKHR(C.VkDevice)

pub type PFN_vkReleaseProfilingLockKHR = fn (C.VkDevice)

@[inline]
pub fn release_profiling_lock_khr(device C.VkDevice) {
	C.vkReleaseProfilingLockKHR(device)
}

pub const khr_maintenance_2_spec_version = 1
pub const khr_maintenance_2_extension_name = 'VK_KHR_maintenance2'
// VK_KHR_MAINTENANCE2_SPEC_VERSION is a deprecated alias
pub const khr_maintenance2_spec_version = khr_maintenance_2_spec_version
// VK_KHR_MAINTENANCE2_EXTENSION_NAME is a deprecated alias
pub const khr_maintenance2_extension_name = khr_maintenance_2_extension_name

pub type PointClippingBehaviorKHR = PointClippingBehavior

pub type TessellationDomainOriginKHR = TessellationDomainOrigin

pub type PhysicalDevicePointClippingPropertiesKHR = C.VkPhysicalDevicePointClippingProperties

pub type RenderPassInputAttachmentAspectCreateInfoKHR = C.VkRenderPassInputAttachmentAspectCreateInfo

pub type InputAttachmentAspectReferenceKHR = C.VkInputAttachmentAspectReference

pub type ImageViewUsageCreateInfoKHR = C.VkImageViewUsageCreateInfo

pub type PipelineTessellationDomainOriginStateCreateInfoKHR = C.VkPipelineTessellationDomainOriginStateCreateInfo

pub const khr_get_surface_capabilities_2_spec_version = 1
pub const khr_get_surface_capabilities_2_extension_name = 'VK_KHR_get_surface_capabilities2'

pub type PhysicalDeviceSurfaceInfo2KHR = C.VkPhysicalDeviceSurfaceInfo2KHR

@[typedef]
pub struct C.VkPhysicalDeviceSurfaceInfo2KHR {
pub mut:
	sType   StructureType = StructureType.physical_device_surface_info2_khr
	pNext   voidptr       = unsafe { nil }
	surface C.VkSurfaceKHR
}

pub type SurfaceCapabilities2KHR = C.VkSurfaceCapabilities2KHR

@[typedef]
pub struct C.VkSurfaceCapabilities2KHR {
pub mut:
	sType               StructureType = StructureType.surface_capabilities2_khr
	pNext               voidptr       = unsafe { nil }
	surfaceCapabilities SurfaceCapabilitiesKHR
}

pub type SurfaceFormat2KHR = C.VkSurfaceFormat2KHR

@[typedef]
pub struct C.VkSurfaceFormat2KHR {
pub mut:
	sType         StructureType = StructureType.surface_format2_khr
	pNext         voidptr       = unsafe { nil }
	surfaceFormat SurfaceFormatKHR
}

fn C.vkGetPhysicalDeviceSurfaceCapabilities2KHR(C.VkPhysicalDevice, &PhysicalDeviceSurfaceInfo2KHR, &SurfaceCapabilities2KHR) Result

pub type PFN_vkGetPhysicalDeviceSurfaceCapabilities2KHR = fn (C.VkPhysicalDevice, &PhysicalDeviceSurfaceInfo2KHR, &SurfaceCapabilities2KHR) Result

@[inline]
pub fn get_physical_device_surface_capabilities2_khr(physical_device C.VkPhysicalDevice,
	p_surface_info &PhysicalDeviceSurfaceInfo2KHR,
	p_surface_capabilities &SurfaceCapabilities2KHR) Result {
	return C.vkGetPhysicalDeviceSurfaceCapabilities2KHR(physical_device, p_surface_info,
		p_surface_capabilities)
}

fn C.vkGetPhysicalDeviceSurfaceFormats2KHR(C.VkPhysicalDevice, &PhysicalDeviceSurfaceInfo2KHR, &u32, &SurfaceFormat2KHR) Result

pub type PFN_vkGetPhysicalDeviceSurfaceFormats2KHR = fn (C.VkPhysicalDevice, &PhysicalDeviceSurfaceInfo2KHR, &u32, &SurfaceFormat2KHR) Result

@[inline]
pub fn get_physical_device_surface_formats2_khr(physical_device C.VkPhysicalDevice,
	p_surface_info &PhysicalDeviceSurfaceInfo2KHR,
	p_surface_format_count &u32,
	p_surface_formats &SurfaceFormat2KHR) Result {
	return C.vkGetPhysicalDeviceSurfaceFormats2KHR(physical_device, p_surface_info, p_surface_format_count,
		p_surface_formats)
}

pub const khr_variable_pointers_spec_version = 1
pub const khr_variable_pointers_extension_name = 'VK_KHR_variable_pointers'

pub type PhysicalDeviceVariablePointerFeaturesKHR = C.VkPhysicalDeviceVariablePointersFeatures

pub type PhysicalDeviceVariablePointersFeaturesKHR = C.VkPhysicalDeviceVariablePointersFeatures

pub const khr_get_display_properties_2_spec_version = 1
pub const khr_get_display_properties_2_extension_name = 'VK_KHR_get_display_properties2'

pub type DisplayProperties2KHR = C.VkDisplayProperties2KHR

@[typedef]
pub struct C.VkDisplayProperties2KHR {
pub mut:
	sType             StructureType = StructureType.display_properties2_khr
	pNext             voidptr       = unsafe { nil }
	displayProperties DisplayPropertiesKHR
}

pub type DisplayPlaneProperties2KHR = C.VkDisplayPlaneProperties2KHR

@[typedef]
pub struct C.VkDisplayPlaneProperties2KHR {
pub mut:
	sType                  StructureType = StructureType.display_plane_properties2_khr
	pNext                  voidptr       = unsafe { nil }
	displayPlaneProperties DisplayPlanePropertiesKHR
}

pub type DisplayModeProperties2KHR = C.VkDisplayModeProperties2KHR

@[typedef]
pub struct C.VkDisplayModeProperties2KHR {
pub mut:
	sType                 StructureType = StructureType.display_mode_properties2_khr
	pNext                 voidptr       = unsafe { nil }
	displayModeProperties DisplayModePropertiesKHR
}

pub type DisplayPlaneInfo2KHR = C.VkDisplayPlaneInfo2KHR

@[typedef]
pub struct C.VkDisplayPlaneInfo2KHR {
pub mut:
	sType      StructureType = StructureType.display_plane_info2_khr
	pNext      voidptr       = unsafe { nil }
	mode       C.VkDisplayModeKHR
	planeIndex u32
}

pub type DisplayPlaneCapabilities2KHR = C.VkDisplayPlaneCapabilities2KHR

@[typedef]
pub struct C.VkDisplayPlaneCapabilities2KHR {
pub mut:
	sType        StructureType = StructureType.display_plane_capabilities2_khr
	pNext        voidptr       = unsafe { nil }
	capabilities DisplayPlaneCapabilitiesKHR
}

fn C.vkGetPhysicalDeviceDisplayProperties2KHR(C.VkPhysicalDevice, &u32, &DisplayProperties2KHR) Result

pub type PFN_vkGetPhysicalDeviceDisplayProperties2KHR = fn (C.VkPhysicalDevice, &u32, &DisplayProperties2KHR) Result

@[inline]
pub fn get_physical_device_display_properties2_khr(physical_device C.VkPhysicalDevice,
	p_property_count &u32,
	p_properties &DisplayProperties2KHR) Result {
	return C.vkGetPhysicalDeviceDisplayProperties2KHR(physical_device, p_property_count,
		p_properties)
}

fn C.vkGetPhysicalDeviceDisplayPlaneProperties2KHR(C.VkPhysicalDevice, &u32, &DisplayPlaneProperties2KHR) Result

pub type PFN_vkGetPhysicalDeviceDisplayPlaneProperties2KHR = fn (C.VkPhysicalDevice, &u32, &DisplayPlaneProperties2KHR) Result

@[inline]
pub fn get_physical_device_display_plane_properties2_khr(physical_device C.VkPhysicalDevice,
	p_property_count &u32,
	p_properties &DisplayPlaneProperties2KHR) Result {
	return C.vkGetPhysicalDeviceDisplayPlaneProperties2KHR(physical_device, p_property_count,
		p_properties)
}

fn C.vkGetDisplayModeProperties2KHR(C.VkPhysicalDevice, C.VkDisplayKHR, &u32, &DisplayModeProperties2KHR) Result

pub type PFN_vkGetDisplayModeProperties2KHR = fn (C.VkPhysicalDevice, C.VkDisplayKHR, &u32, &DisplayModeProperties2KHR) Result

@[inline]
pub fn get_display_mode_properties2_khr(physical_device C.VkPhysicalDevice,
	display C.VkDisplayKHR,
	p_property_count &u32,
	p_properties &DisplayModeProperties2KHR) Result {
	return C.vkGetDisplayModeProperties2KHR(physical_device, display, p_property_count,
		p_properties)
}

fn C.vkGetDisplayPlaneCapabilities2KHR(C.VkPhysicalDevice, &DisplayPlaneInfo2KHR, &DisplayPlaneCapabilities2KHR) Result

pub type PFN_vkGetDisplayPlaneCapabilities2KHR = fn (C.VkPhysicalDevice, &DisplayPlaneInfo2KHR, &DisplayPlaneCapabilities2KHR) Result

@[inline]
pub fn get_display_plane_capabilities2_khr(physical_device C.VkPhysicalDevice,
	p_display_plane_info &DisplayPlaneInfo2KHR,
	p_capabilities &DisplayPlaneCapabilities2KHR) Result {
	return C.vkGetDisplayPlaneCapabilities2KHR(physical_device, p_display_plane_info,
		p_capabilities)
}

pub const khr_dedicated_allocation_spec_version = 3
pub const khr_dedicated_allocation_extension_name = 'VK_KHR_dedicated_allocation'

pub type MemoryDedicatedRequirementsKHR = C.VkMemoryDedicatedRequirements

pub type MemoryDedicatedAllocateInfoKHR = C.VkMemoryDedicatedAllocateInfo

pub const khr_storage_buffer_storage_class_spec_version = 1
pub const khr_storage_buffer_storage_class_extension_name = 'VK_KHR_storage_buffer_storage_class'

pub const khr_relaxed_block_layout_spec_version = 1
pub const khr_relaxed_block_layout_extension_name = 'VK_KHR_relaxed_block_layout'

pub const khr_get_memory_requirements_2_spec_version = 1
pub const khr_get_memory_requirements_2_extension_name = 'VK_KHR_get_memory_requirements2'

pub type BufferMemoryRequirementsInfo2KHR = C.VkBufferMemoryRequirementsInfo2

pub type ImageMemoryRequirementsInfo2KHR = C.VkImageMemoryRequirementsInfo2

pub type ImageSparseMemoryRequirementsInfo2KHR = C.VkImageSparseMemoryRequirementsInfo2

pub type MemoryRequirements2KHR = C.VkMemoryRequirements2

pub type SparseImageMemoryRequirements2KHR = C.VkSparseImageMemoryRequirements2

pub const khr_image_format_list_spec_version = 1
pub const khr_image_format_list_extension_name = 'VK_KHR_image_format_list'

pub type ImageFormatListCreateInfoKHR = C.VkImageFormatListCreateInfo

pub type SamplerYcbcrConversionKHR = voidptr

pub const khr_sampler_ycbcr_conversion_spec_version = 14
pub const khr_sampler_ycbcr_conversion_extension_name = 'VK_KHR_sampler_ycbcr_conversion'

pub type SamplerYcbcrModelConversionKHR = SamplerYcbcrModelConversion

pub type SamplerYcbcrRangeKHR = SamplerYcbcrRange

pub type ChromaLocationKHR = ChromaLocation

pub type SamplerYcbcrConversionCreateInfoKHR = C.VkSamplerYcbcrConversionCreateInfo

pub type SamplerYcbcrConversionInfoKHR = C.VkSamplerYcbcrConversionInfo

pub type BindImagePlaneMemoryInfoKHR = C.VkBindImagePlaneMemoryInfo

pub type ImagePlaneMemoryRequirementsInfoKHR = C.VkImagePlaneMemoryRequirementsInfo

pub type PhysicalDeviceSamplerYcbcrConversionFeaturesKHR = C.VkPhysicalDeviceSamplerYcbcrConversionFeatures

pub type SamplerYcbcrConversionImageFormatPropertiesKHR = C.VkSamplerYcbcrConversionImageFormatProperties

pub const khr_bind_memory_2_spec_version = 1
pub const khr_bind_memory_2_extension_name = 'VK_KHR_bind_memory2'

pub type BindBufferMemoryInfoKHR = C.VkBindBufferMemoryInfo

pub type BindImageMemoryInfoKHR = C.VkBindImageMemoryInfo

pub const khr_maintenance_3_spec_version = 1
pub const khr_maintenance_3_extension_name = 'VK_KHR_maintenance3'
// VK_KHR_MAINTENANCE3_SPEC_VERSION is a deprecated alias
pub const khr_maintenance3_spec_version = khr_maintenance_3_spec_version
// VK_KHR_MAINTENANCE3_EXTENSION_NAME is a deprecated alias
pub const khr_maintenance3_extension_name = khr_maintenance_3_extension_name

pub type PhysicalDeviceMaintenance3PropertiesKHR = C.VkPhysicalDeviceMaintenance3Properties

pub type DescriptorSetLayoutSupportKHR = C.VkDescriptorSetLayoutSupport

pub const khr_draw_indirect_count_spec_version = 1
pub const khr_draw_indirect_count_extension_name = 'VK_KHR_draw_indirect_count'

pub const khr_shader_subgroup_extended_types_spec_version = 1
pub const khr_shader_subgroup_extended_types_extension_name = 'VK_KHR_shader_subgroup_extended_types'

pub type PhysicalDeviceShaderSubgroupExtendedTypesFeaturesKHR = C.VkPhysicalDeviceShaderSubgroupExtendedTypesFeatures

pub const khr_8bit_storage_spec_version = 1
pub const khr_8bit_storage_extension_name = 'VK_KHR_8bit_storage'

pub type PhysicalDevice8BitStorageFeaturesKHR = C.VkPhysicalDevice8BitStorageFeatures

pub const khr_shader_atomic_int64_spec_version = 1
pub const khr_shader_atomic_int64_extension_name = 'VK_KHR_shader_atomic_int64'

pub type PhysicalDeviceShaderAtomicInt64FeaturesKHR = C.VkPhysicalDeviceShaderAtomicInt64Features

pub const khr_shader_clock_spec_version = 1
pub const khr_shader_clock_extension_name = 'VK_KHR_shader_clock'

pub type PhysicalDeviceShaderClockFeaturesKHR = C.VkPhysicalDeviceShaderClockFeaturesKHR

@[typedef]
pub struct C.VkPhysicalDeviceShaderClockFeaturesKHR {
pub mut:
	sType               StructureType = StructureType.physical_device_shader_clock_features_khr
	pNext               voidptr       = unsafe { nil }
	shaderSubgroupClock Bool32
	shaderDeviceClock   Bool32
}

pub const khr_video_decode_h265_spec_version = 8
pub const khr_video_decode_h265_extension_name = 'VK_KHR_video_decode_h265'

pub type VideoDecodeH265ProfileInfoKHR = C.VkVideoDecodeH265ProfileInfoKHR

@[typedef]
pub struct C.VkVideoDecodeH265ProfileInfoKHR {
pub mut:
	sType         StructureType = StructureType.video_decode_h265_profile_info_khr
	pNext         voidptr       = unsafe { nil }
	stdProfileIdc StdVideoH265ProfileIdc
}

pub type VideoDecodeH265CapabilitiesKHR = C.VkVideoDecodeH265CapabilitiesKHR

@[typedef]
pub struct C.VkVideoDecodeH265CapabilitiesKHR {
pub mut:
	sType       StructureType = StructureType.video_decode_h265_capabilities_khr
	pNext       voidptr       = unsafe { nil }
	maxLevelIdc StdVideoH265LevelIdc
}

pub type VideoDecodeH265SessionParametersAddInfoKHR = C.VkVideoDecodeH265SessionParametersAddInfoKHR

@[typedef]
pub struct C.VkVideoDecodeH265SessionParametersAddInfoKHR {
pub mut:
	sType       StructureType = StructureType.video_decode_h265_session_parameters_add_info_khr
	pNext       voidptr       = unsafe { nil }
	stdVPSCount u32
	pStdVPSs    &StdVideoH265VideoParameterSet
	stdSPSCount u32
	pStdSPSs    &StdVideoH265SequenceParameterSet
	stdPPSCount u32
	pStdPPSs    &StdVideoH265PictureParameterSet
}

pub type VideoDecodeH265SessionParametersCreateInfoKHR = C.VkVideoDecodeH265SessionParametersCreateInfoKHR

@[typedef]
pub struct C.VkVideoDecodeH265SessionParametersCreateInfoKHR {
pub mut:
	sType              StructureType = StructureType.video_decode_h265_session_parameters_create_info_khr
	pNext              voidptr       = unsafe { nil }
	maxStdVPSCount     u32
	maxStdSPSCount     u32
	maxStdPPSCount     u32
	pParametersAddInfo &VideoDecodeH265SessionParametersAddInfoKHR
}

pub type VideoDecodeH265PictureInfoKHR = C.VkVideoDecodeH265PictureInfoKHR

@[typedef]
pub struct C.VkVideoDecodeH265PictureInfoKHR {
pub mut:
	sType                StructureType = StructureType.video_decode_h265_picture_info_khr
	pNext                voidptr       = unsafe { nil }
	pStdPictureInfo      &StdVideoDecodeH265PictureInfo
	sliceSegmentCount    u32
	pSliceSegmentOffsets &u32
}

pub type VideoDecodeH265DpbSlotInfoKHR = C.VkVideoDecodeH265DpbSlotInfoKHR

@[typedef]
pub struct C.VkVideoDecodeH265DpbSlotInfoKHR {
pub mut:
	sType             StructureType = StructureType.video_decode_h265_dpb_slot_info_khr
	pNext             voidptr       = unsafe { nil }
	pStdReferenceInfo &StdVideoDecodeH265ReferenceInfo
}

pub const max_global_priority_size_khr = u32(16)
pub const khr_global_priority_spec_version = 1
pub const khr_global_priority_extension_name = 'VK_KHR_global_priority'

pub enum QueueGlobalPriorityKHR {
	low_khr      = 128
	medium_khr   = 256
	high_khr     = 512
	realtime_khr = 1024
	max_enum_khr = max_int
}

pub type DeviceQueueGlobalPriorityCreateInfoKHR = C.VkDeviceQueueGlobalPriorityCreateInfoKHR

@[typedef]
pub struct C.VkDeviceQueueGlobalPriorityCreateInfoKHR {
pub mut:
	sType          StructureType = StructureType.device_queue_global_priority_create_info_khr
	pNext          voidptr       = unsafe { nil }
	globalPriority QueueGlobalPriorityKHR
}

pub type PhysicalDeviceGlobalPriorityQueryFeaturesKHR = C.VkPhysicalDeviceGlobalPriorityQueryFeaturesKHR

@[typedef]
pub struct C.VkPhysicalDeviceGlobalPriorityQueryFeaturesKHR {
pub mut:
	sType               StructureType = StructureType.physical_device_global_priority_query_features_khr
	pNext               voidptr       = unsafe { nil }
	globalPriorityQuery Bool32
}

pub type QueueFamilyGlobalPriorityPropertiesKHR = C.VkQueueFamilyGlobalPriorityPropertiesKHR

@[typedef]
pub struct C.VkQueueFamilyGlobalPriorityPropertiesKHR {
pub mut:
	sType         StructureType = StructureType.queue_family_global_priority_properties_khr
	pNext         voidptr       = unsafe { nil }
	priorityCount u32
	priorities    [max_global_priority_size_khr]QueueGlobalPriorityKHR
}

pub const khr_driver_properties_spec_version = 1
pub const khr_driver_properties_extension_name = 'VK_KHR_driver_properties'
pub const max_driver_name_size_khr = max_driver_name_size
pub const max_driver_info_size_khr = max_driver_info_size

pub type DriverIdKHR = DriverId

pub type ConformanceVersionKHR = C.VkConformanceVersion

pub type PhysicalDeviceDriverPropertiesKHR = C.VkPhysicalDeviceDriverProperties

pub const khr_shader_float_controls_spec_version = 4
pub const khr_shader_float_controls_extension_name = 'VK_KHR_shader_float_controls'

pub type ShaderFloatControlsIndependenceKHR = ShaderFloatControlsIndependence

pub type PhysicalDeviceFloatControlsPropertiesKHR = C.VkPhysicalDeviceFloatControlsProperties

pub const khr_depth_stencil_resolve_spec_version = 1
pub const khr_depth_stencil_resolve_extension_name = 'VK_KHR_depth_stencil_resolve'

pub type ResolveModeFlagBitsKHR = ResolveModeFlagBits

pub type ResolveModeFlagsKHR = u32
pub type SubpassDescriptionDepthStencilResolveKHR = C.VkSubpassDescriptionDepthStencilResolve

pub type PhysicalDeviceDepthStencilResolvePropertiesKHR = C.VkPhysicalDeviceDepthStencilResolveProperties

pub const khr_swapchain_mutable_format_spec_version = 1
pub const khr_swapchain_mutable_format_extension_name = 'VK_KHR_swapchain_mutable_format'

pub const khr_timeline_semaphore_spec_version = 2
pub const khr_timeline_semaphore_extension_name = 'VK_KHR_timeline_semaphore'

pub type SemaphoreTypeKHR = SemaphoreType

pub type SemaphoreWaitFlagBitsKHR = SemaphoreWaitFlagBits

pub type SemaphoreWaitFlagsKHR = u32
pub type PhysicalDeviceTimelineSemaphoreFeaturesKHR = C.VkPhysicalDeviceTimelineSemaphoreFeatures

pub type PhysicalDeviceTimelineSemaphorePropertiesKHR = C.VkPhysicalDeviceTimelineSemaphoreProperties

pub type SemaphoreTypeCreateInfoKHR = C.VkSemaphoreTypeCreateInfo

pub type TimelineSemaphoreSubmitInfoKHR = C.VkTimelineSemaphoreSubmitInfo

pub type SemaphoreWaitInfoKHR = C.VkSemaphoreWaitInfo

pub type SemaphoreSignalInfoKHR = C.VkSemaphoreSignalInfo

pub const khr_vulkan_memory_model_spec_version = 3
pub const khr_vulkan_memory_model_extension_name = 'VK_KHR_vulkan_memory_model'

pub type PhysicalDeviceVulkanMemoryModelFeaturesKHR = C.VkPhysicalDeviceVulkanMemoryModelFeatures

pub const khr_shader_terminate_invocation_spec_version = 1
pub const khr_shader_terminate_invocation_extension_name = 'VK_KHR_shader_terminate_invocation'

pub type PhysicalDeviceShaderTerminateInvocationFeaturesKHR = C.VkPhysicalDeviceShaderTerminateInvocationFeatures

pub const khr_fragment_shading_rate_spec_version = 2
pub const khr_fragment_shading_rate_extension_name = 'VK_KHR_fragment_shading_rate'

pub enum FragmentShadingRateCombinerOpKHR {
	keep_khr     = 0
	replace_khr  = 1
	min_khr      = 2
	max_khr      = 3
	mul_khr      = 4
	max_enum_khr = max_int
}

pub type FragmentShadingRateAttachmentInfoKHR = C.VkFragmentShadingRateAttachmentInfoKHR

@[typedef]
pub struct C.VkFragmentShadingRateAttachmentInfoKHR {
pub mut:
	sType                          StructureType = StructureType.fragment_shading_rate_attachment_info_khr
	pNext                          voidptr       = unsafe { nil }
	pFragmentShadingRateAttachment &AttachmentReference2
	shadingRateAttachmentTexelSize Extent2D
}

pub type PipelineFragmentShadingRateStateCreateInfoKHR = C.VkPipelineFragmentShadingRateStateCreateInfoKHR

@[typedef]
pub struct C.VkPipelineFragmentShadingRateStateCreateInfoKHR {
pub mut:
	sType        StructureType = StructureType.pipeline_fragment_shading_rate_state_create_info_khr
	pNext        voidptr       = unsafe { nil }
	fragmentSize Extent2D
	combinerOps  [2]FragmentShadingRateCombinerOpKHR
}

pub type PhysicalDeviceFragmentShadingRateFeaturesKHR = C.VkPhysicalDeviceFragmentShadingRateFeaturesKHR

@[typedef]
pub struct C.VkPhysicalDeviceFragmentShadingRateFeaturesKHR {
pub mut:
	sType                         StructureType = StructureType.physical_device_fragment_shading_rate_features_khr
	pNext                         voidptr       = unsafe { nil }
	pipelineFragmentShadingRate   Bool32
	primitiveFragmentShadingRate  Bool32
	attachmentFragmentShadingRate Bool32
}

pub type PhysicalDeviceFragmentShadingRatePropertiesKHR = C.VkPhysicalDeviceFragmentShadingRatePropertiesKHR

@[typedef]
pub struct C.VkPhysicalDeviceFragmentShadingRatePropertiesKHR {
pub mut:
	sType                                                StructureType = StructureType.physical_device_fragment_shading_rate_properties_khr
	pNext                                                voidptr       = unsafe { nil }
	minFragmentShadingRateAttachmentTexelSize            Extent2D
	maxFragmentShadingRateAttachmentTexelSize            Extent2D
	maxFragmentShadingRateAttachmentTexelSizeAspectRatio u32
	primitiveFragmentShadingRateWithMultipleViewports    Bool32
	layeredShadingRateAttachments                        Bool32
	fragmentShadingRateNonTrivialCombinerOps             Bool32
	maxFragmentSize                                      Extent2D
	maxFragmentSizeAspectRatio                           u32
	maxFragmentShadingRateCoverageSamples                u32
	maxFragmentShadingRateRasterizationSamples           SampleCountFlagBits
	fragmentShadingRateWithShaderDepthStencilWrites      Bool32
	fragmentShadingRateWithSampleMask                    Bool32
	fragmentShadingRateWithShaderSampleMask              Bool32
	fragmentShadingRateWithConservativeRasterization     Bool32
	fragmentShadingRateWithFragmentShaderInterlock       Bool32
	fragmentShadingRateWithCustomSampleLocations         Bool32
	fragmentShadingRateStrictMultiplyCombiner            Bool32
}

pub type PhysicalDeviceFragmentShadingRateKHR = C.VkPhysicalDeviceFragmentShadingRateKHR

@[typedef]
pub struct C.VkPhysicalDeviceFragmentShadingRateKHR {
pub mut:
	sType        StructureType = StructureType.physical_device_fragment_shading_rate_khr
	pNext        voidptr       = unsafe { nil }
	sampleCounts SampleCountFlags
	fragmentSize Extent2D
}

fn C.vkGetPhysicalDeviceFragmentShadingRatesKHR(C.VkPhysicalDevice, &u32, &PhysicalDeviceFragmentShadingRateKHR) Result

pub type PFN_vkGetPhysicalDeviceFragmentShadingRatesKHR = fn (C.VkPhysicalDevice, &u32, &PhysicalDeviceFragmentShadingRateKHR) Result

@[inline]
pub fn get_physical_device_fragment_shading_rates_khr(physical_device C.VkPhysicalDevice,
	p_fragment_shading_rate_count &u32,
	p_fragment_shading_rates &PhysicalDeviceFragmentShadingRateKHR) Result {
	return C.vkGetPhysicalDeviceFragmentShadingRatesKHR(physical_device, p_fragment_shading_rate_count,
		p_fragment_shading_rates)
}

fn C.vkCmdSetFragmentShadingRateKHR(C.VkCommandBuffer, &Extent2D, voidptr)

pub type PFN_vkCmdSetFragmentShadingRateKHR = fn (C.VkCommandBuffer, &Extent2D, voidptr)

@[inline]
pub fn cmd_set_fragment_shading_rate_khr(command_buffer C.VkCommandBuffer,
	p_fragment_size &Extent2D,
	combiner_ops [2]FragmentShadingRateCombinerOpKHR) {
	C.vkCmdSetFragmentShadingRateKHR(command_buffer, p_fragment_size, combiner_ops)
}

pub const khr_spirv_1_4_spec_version = 1
pub const khr_spirv_1_4_extension_name = 'VK_KHR_spirv_1_4'

pub const khr_surface_protected_capabilities_spec_version = 1
pub const khr_surface_protected_capabilities_extension_name = 'VK_KHR_surface_protected_capabilities'

pub type SurfaceProtectedCapabilitiesKHR = C.VkSurfaceProtectedCapabilitiesKHR

@[typedef]
pub struct C.VkSurfaceProtectedCapabilitiesKHR {
pub mut:
	sType             StructureType = StructureType.surface_protected_capabilities_khr
	pNext             voidptr       = unsafe { nil }
	supportsProtected Bool32
}

pub const khr_separate_depth_stencil_layouts_spec_version = 1
pub const khr_separate_depth_stencil_layouts_extension_name = 'VK_KHR_separate_depth_stencil_layouts'

pub type PhysicalDeviceSeparateDepthStencilLayoutsFeaturesKHR = C.VkPhysicalDeviceSeparateDepthStencilLayoutsFeatures

pub type AttachmentReferenceStencilLayoutKHR = C.VkAttachmentReferenceStencilLayout

pub type AttachmentDescriptionStencilLayoutKHR = C.VkAttachmentDescriptionStencilLayout

pub const khr_present_wait_spec_version = 1
pub const khr_present_wait_extension_name = 'VK_KHR_present_wait'

pub type PhysicalDevicePresentWaitFeaturesKHR = C.VkPhysicalDevicePresentWaitFeaturesKHR

@[typedef]
pub struct C.VkPhysicalDevicePresentWaitFeaturesKHR {
pub mut:
	sType       StructureType = StructureType.physical_device_present_wait_features_khr
	pNext       voidptr       = unsafe { nil }
	presentWait Bool32
}

fn C.vkWaitForPresentKHR(C.VkDevice, C.VkSwapchainKHR, u64, u64) Result

pub type PFN_vkWaitForPresentKHR = fn (C.VkDevice, C.VkSwapchainKHR, u64, u64) Result

@[inline]
pub fn wait_for_present_khr(device C.VkDevice,
	swapchain C.VkSwapchainKHR,
	present_id u64,
	timeout u64) Result {
	return C.vkWaitForPresentKHR(device, swapchain, present_id, timeout)
}

pub const khr_uniform_buffer_standard_layout_spec_version = 1
pub const khr_uniform_buffer_standard_layout_extension_name = 'VK_KHR_uniform_buffer_standard_layout'

pub type PhysicalDeviceUniformBufferStandardLayoutFeaturesKHR = C.VkPhysicalDeviceUniformBufferStandardLayoutFeatures

pub const khr_buffer_device_address_spec_version = 1
pub const khr_buffer_device_address_extension_name = 'VK_KHR_buffer_device_address'

pub type PhysicalDeviceBufferDeviceAddressFeaturesKHR = C.VkPhysicalDeviceBufferDeviceAddressFeatures

pub type BufferDeviceAddressInfoKHR = C.VkBufferDeviceAddressInfo

pub type BufferOpaqueCaptureAddressCreateInfoKHR = C.VkBufferOpaqueCaptureAddressCreateInfo

pub type MemoryOpaqueCaptureAddressAllocateInfoKHR = C.VkMemoryOpaqueCaptureAddressAllocateInfo

pub type DeviceMemoryOpaqueCaptureAddressInfoKHR = C.VkDeviceMemoryOpaqueCaptureAddressInfo

pub type C.VkDeferredOperationKHR = voidptr

pub const khr_deferred_host_operations_spec_version = 4
pub const khr_deferred_host_operations_extension_name = 'VK_KHR_deferred_host_operations'

fn C.vkCreateDeferredOperationKHR(C.VkDevice, &AllocationCallbacks, C.VkDeferredOperationKHR) Result

pub type PFN_vkCreateDeferredOperationKHR = fn (C.VkDevice, &AllocationCallbacks, C.VkDeferredOperationKHR) Result

@[inline]
pub fn create_deferred_operation_khr(device C.VkDevice,
	p_allocator &AllocationCallbacks,
	p_deferred_operation C.VkDeferredOperationKHR) Result {
	return C.vkCreateDeferredOperationKHR(device, p_allocator, p_deferred_operation)
}

fn C.vkDestroyDeferredOperationKHR(C.VkDevice, C.VkDeferredOperationKHR, &AllocationCallbacks)

pub type PFN_vkDestroyDeferredOperationKHR = fn (C.VkDevice, C.VkDeferredOperationKHR, &AllocationCallbacks)

@[inline]
pub fn destroy_deferred_operation_khr(device C.VkDevice,
	operation C.VkDeferredOperationKHR,
	p_allocator &AllocationCallbacks) {
	C.vkDestroyDeferredOperationKHR(device, operation, p_allocator)
}

fn C.vkGetDeferredOperationMaxConcurrencyKHR(C.VkDevice, C.VkDeferredOperationKHR) u32

pub type PFN_vkGetDeferredOperationMaxConcurrencyKHR = fn (C.VkDevice, C.VkDeferredOperationKHR) u32

@[inline]
pub fn get_deferred_operation_max_concurrency_khr(device C.VkDevice,
	operation C.VkDeferredOperationKHR) u32 {
	return C.vkGetDeferredOperationMaxConcurrencyKHR(device, operation)
}

fn C.vkGetDeferredOperationResultKHR(C.VkDevice, C.VkDeferredOperationKHR) Result

pub type PFN_vkGetDeferredOperationResultKHR = fn (C.VkDevice, C.VkDeferredOperationKHR) Result

@[inline]
pub fn get_deferred_operation_result_khr(device C.VkDevice,
	operation C.VkDeferredOperationKHR) Result {
	return C.vkGetDeferredOperationResultKHR(device, operation)
}

fn C.vkDeferredOperationJoinKHR(C.VkDevice, C.VkDeferredOperationKHR) Result

pub type PFN_vkDeferredOperationJoinKHR = fn (C.VkDevice, C.VkDeferredOperationKHR) Result

@[inline]
pub fn deferred_operation_join_khr(device C.VkDevice,
	operation C.VkDeferredOperationKHR) Result {
	return C.vkDeferredOperationJoinKHR(device, operation)
}

pub const khr_pipeline_executable_properties_spec_version = 1
pub const khr_pipeline_executable_properties_extension_name = 'VK_KHR_pipeline_executable_properties'

pub enum PipelineExecutableStatisticFormatKHR {
	bool32_khr   = 0
	int64_khr    = 1
	uint64_khr   = 2
	float64_khr  = 3
	max_enum_khr = max_int
}

pub type PhysicalDevicePipelineExecutablePropertiesFeaturesKHR = C.VkPhysicalDevicePipelineExecutablePropertiesFeaturesKHR

@[typedef]
pub struct C.VkPhysicalDevicePipelineExecutablePropertiesFeaturesKHR {
pub mut:
	sType                  StructureType = StructureType.physical_device_pipeline_executable_properties_features_khr
	pNext                  voidptr       = unsafe { nil }
	pipelineExecutableInfo Bool32
}

pub type PipelineInfoKHR = C.VkPipelineInfoKHR

@[typedef]
pub struct C.VkPipelineInfoKHR {
pub mut:
	sType    StructureType = StructureType.pipeline_info_khr
	pNext    voidptr       = unsafe { nil }
	pipeline C.VkPipeline
}

pub type PipelineExecutablePropertiesKHR = C.VkPipelineExecutablePropertiesKHR

@[typedef]
pub struct C.VkPipelineExecutablePropertiesKHR {
pub mut:
	sType        StructureType = StructureType.pipeline_executable_properties_khr
	pNext        voidptr       = unsafe { nil }
	stages       ShaderStageFlags
	name         [max_description_size]char
	description  [max_description_size]char
	subgroupSize u32
}

pub type PipelineExecutableInfoKHR = C.VkPipelineExecutableInfoKHR

@[typedef]
pub struct C.VkPipelineExecutableInfoKHR {
pub mut:
	sType           StructureType = StructureType.pipeline_executable_info_khr
	pNext           voidptr       = unsafe { nil }
	pipeline        C.VkPipeline
	executableIndex u32
}

pub type PipelineExecutableStatisticValueKHR = C.VkPipelineExecutableStatisticValueKHR

@[typedef]
pub union C.VkPipelineExecutableStatisticValueKHR {
pub mut:
	b32 Bool32
	i64 i64
	u64 u64
	f64 f64
}

pub type PipelineExecutableStatisticKHR = C.VkPipelineExecutableStatisticKHR

@[typedef]
pub struct C.VkPipelineExecutableStatisticKHR {
pub mut:
	sType       StructureType = StructureType.pipeline_executable_statistic_khr
	pNext       voidptr       = unsafe { nil }
	name        [max_description_size]char
	description [max_description_size]char
	format      PipelineExecutableStatisticFormatKHR
	value       PipelineExecutableStatisticValueKHR
}

pub type PipelineExecutableInternalRepresentationKHR = C.VkPipelineExecutableInternalRepresentationKHR

@[typedef]
pub struct C.VkPipelineExecutableInternalRepresentationKHR {
pub mut:
	sType       StructureType = StructureType.pipeline_executable_internal_representation_khr
	pNext       voidptr       = unsafe { nil }
	name        [max_description_size]char
	description [max_description_size]char
	isText      Bool32
	dataSize    usize
	pData       voidptr
}

fn C.vkGetPipelineExecutablePropertiesKHR(C.VkDevice, &PipelineInfoKHR, &u32, &PipelineExecutablePropertiesKHR) Result

pub type PFN_vkGetPipelineExecutablePropertiesKHR = fn (C.VkDevice, &PipelineInfoKHR, &u32, &PipelineExecutablePropertiesKHR) Result

@[inline]
pub fn get_pipeline_executable_properties_khr(device C.VkDevice,
	p_pipeline_info &PipelineInfoKHR,
	p_executable_count &u32,
	p_properties &PipelineExecutablePropertiesKHR) Result {
	return C.vkGetPipelineExecutablePropertiesKHR(device, p_pipeline_info, p_executable_count,
		p_properties)
}

fn C.vkGetPipelineExecutableStatisticsKHR(C.VkDevice, &PipelineExecutableInfoKHR, &u32, &PipelineExecutableStatisticKHR) Result

pub type PFN_vkGetPipelineExecutableStatisticsKHR = fn (C.VkDevice, &PipelineExecutableInfoKHR, &u32, &PipelineExecutableStatisticKHR) Result

@[inline]
pub fn get_pipeline_executable_statistics_khr(device C.VkDevice,
	p_executable_info &PipelineExecutableInfoKHR,
	p_statistic_count &u32,
	p_statistics &PipelineExecutableStatisticKHR) Result {
	return C.vkGetPipelineExecutableStatisticsKHR(device, p_executable_info, p_statistic_count,
		p_statistics)
}

fn C.vkGetPipelineExecutableInternalRepresentationsKHR(C.VkDevice, &PipelineExecutableInfoKHR, &u32, &PipelineExecutableInternalRepresentationKHR) Result

pub type PFN_vkGetPipelineExecutableInternalRepresentationsKHR = fn (C.VkDevice, &PipelineExecutableInfoKHR, &u32, &PipelineExecutableInternalRepresentationKHR) Result

@[inline]
pub fn get_pipeline_executable_internal_representations_khr(device C.VkDevice,
	p_executable_info &PipelineExecutableInfoKHR,
	p_internal_representation_count &u32,
	p_internal_representations &PipelineExecutableInternalRepresentationKHR) Result {
	return C.vkGetPipelineExecutableInternalRepresentationsKHR(device, p_executable_info,
		p_internal_representation_count, p_internal_representations)
}

pub const khr_map_memory_2_spec_version = 1
pub const khr_map_memory_2_extension_name = 'VK_KHR_map_memory2'

pub type MemoryUnmapFlagsKHR = u32
pub type MemoryMapInfoKHR = C.VkMemoryMapInfoKHR

@[typedef]
pub struct C.VkMemoryMapInfoKHR {
pub mut:
	sType  StructureType = StructureType.memory_map_info_khr
	pNext  voidptr       = unsafe { nil }
	flags  MemoryMapFlags
	memory C.VkDeviceMemory
	offset DeviceSize
	size   DeviceSize
}

pub type MemoryUnmapInfoKHR = C.VkMemoryUnmapInfoKHR

@[typedef]
pub struct C.VkMemoryUnmapInfoKHR {
pub mut:
	sType  StructureType = StructureType.memory_unmap_info_khr
	pNext  voidptr       = unsafe { nil }
	flags  MemoryUnmapFlagsKHR
	memory C.VkDeviceMemory
}

fn C.vkMapMemory2KHR(C.VkDevice, &MemoryMapInfoKHR, &voidptr) Result

pub type PFN_vkMapMemory2KHR = fn (C.VkDevice, &MemoryMapInfoKHR, &voidptr) Result

@[inline]
pub fn map_memory2_khr(device C.VkDevice,
	p_memory_map_info &MemoryMapInfoKHR,
	pp_data &voidptr) Result {
	return C.vkMapMemory2KHR(device, p_memory_map_info, pp_data)
}

fn C.vkUnmapMemory2KHR(C.VkDevice, &MemoryUnmapInfoKHR) Result

pub type PFN_vkUnmapMemory2KHR = fn (C.VkDevice, &MemoryUnmapInfoKHR) Result

@[inline]
pub fn unmap_memory2_khr(device C.VkDevice,
	p_memory_unmap_info &MemoryUnmapInfoKHR) Result {
	return C.vkUnmapMemory2KHR(device, p_memory_unmap_info)
}

pub const khr_shader_integer_dot_product_spec_version = 1
pub const khr_shader_integer_dot_product_extension_name = 'VK_KHR_shader_integer_dot_product'

pub type PhysicalDeviceShaderIntegerDotProductFeaturesKHR = C.VkPhysicalDeviceShaderIntegerDotProductFeatures

pub type PhysicalDeviceShaderIntegerDotProductPropertiesKHR = C.VkPhysicalDeviceShaderIntegerDotProductProperties

pub const khr_pipeline_library_spec_version = 1
pub const khr_pipeline_library_extension_name = 'VK_KHR_pipeline_library'

pub type PipelineLibraryCreateInfoKHR = C.VkPipelineLibraryCreateInfoKHR

@[typedef]
pub struct C.VkPipelineLibraryCreateInfoKHR {
pub mut:
	sType        StructureType = StructureType.pipeline_library_create_info_khr
	pNext        voidptr       = unsafe { nil }
	libraryCount u32
	pLibraries   C.VkPipeline
}

pub const khr_shader_non_semantic_info_spec_version = 1
pub const khr_shader_non_semantic_info_extension_name = 'VK_KHR_shader_non_semantic_info'

pub const khr_present_id_spec_version = 1
pub const khr_present_id_extension_name = 'VK_KHR_present_id'

pub type PresentIdKHR = C.VkPresentIdKHR

@[typedef]
pub struct C.VkPresentIdKHR {
pub mut:
	sType          StructureType = StructureType.present_id_khr
	pNext          voidptr       = unsafe { nil }
	swapchainCount u32
	pPresentIds    &u64
}

pub type PhysicalDevicePresentIdFeaturesKHR = C.VkPhysicalDevicePresentIdFeaturesKHR

@[typedef]
pub struct C.VkPhysicalDevicePresentIdFeaturesKHR {
pub mut:
	sType     StructureType = StructureType.physical_device_present_id_features_khr
	pNext     voidptr       = unsafe { nil }
	presentId Bool32
}

pub const khr_video_encode_queue_spec_version = 12
pub const khr_video_encode_queue_extension_name = 'VK_KHR_video_encode_queue'

pub enum VideoEncodeTuningModeKHR {
	default_khr           = 0
	high_quality_khr      = 1
	low_latency_khr       = 2
	ultra_low_latency_khr = 3
	lossless_khr          = 4
	max_enum_khr          = max_int
}

pub type VideoEncodeFlagsKHR = u32

pub enum VideoEncodeCapabilityFlagBitsKHR {
	preceding_externally_encoded_bytes_bit_khr            = int(0x00000001)
	insufficient_bitstream_buffer_range_detection_bit_khr = int(0x00000002)
	max_enum_khr                                          = max_int
}

pub type VideoEncodeCapabilityFlagsKHR = u32

pub enum VideoEncodeRateControlModeFlagBitsKHR {
	default_khr      = 0
	disabled_bit_khr = int(0x00000001)
	cbr_bit_khr      = int(0x00000002)
	vbr_bit_khr      = int(0x00000004)
	max_enum_khr     = max_int
}

pub type VideoEncodeRateControlModeFlagsKHR = u32

pub enum VideoEncodeFeedbackFlagBitsKHR {
	bitstream_buffer_offset_bit_khr = int(0x00000001)
	bitstream_bytes_written_bit_khr = int(0x00000002)
	bitstream_has_overrides_bit_khr = int(0x00000004)
	max_enum_khr                    = max_int
}

pub type VideoEncodeFeedbackFlagsKHR = u32

pub enum VideoEncodeUsageFlagBitsKHR {
	default_khr          = 0
	transcoding_bit_khr  = int(0x00000001)
	streaming_bit_khr    = int(0x00000002)
	recording_bit_khr    = int(0x00000004)
	conferencing_bit_khr = int(0x00000008)
	max_enum_khr         = max_int
}

pub type VideoEncodeUsageFlagsKHR = u32

pub enum VideoEncodeContentFlagBitsKHR {
	default_khr      = 0
	camera_bit_khr   = int(0x00000001)
	desktop_bit_khr  = int(0x00000002)
	rendered_bit_khr = int(0x00000004)
	max_enum_khr     = max_int
}

pub type VideoEncodeContentFlagsKHR = u32
pub type VideoEncodeRateControlFlagsKHR = u32
pub type VideoEncodeInfoKHR = C.VkVideoEncodeInfoKHR

@[typedef]
pub struct C.VkVideoEncodeInfoKHR {
pub mut:
	sType                           StructureType = StructureType.video_encode_info_khr
	pNext                           voidptr       = unsafe { nil }
	flags                           VideoEncodeFlagsKHR
	dstBuffer                       C.VkBuffer
	dstBufferOffset                 DeviceSize
	dstBufferRange                  DeviceSize
	srcPictureResource              VideoPictureResourceInfoKHR
	pSetupReferenceSlot             &VideoReferenceSlotInfoKHR
	referenceSlotCount              u32
	pReferenceSlots                 &VideoReferenceSlotInfoKHR
	precedingExternallyEncodedBytes u32
}

pub type VideoEncodeCapabilitiesKHR = C.VkVideoEncodeCapabilitiesKHR

@[typedef]
pub struct C.VkVideoEncodeCapabilitiesKHR {
pub mut:
	sType                         StructureType = StructureType.video_encode_capabilities_khr
	pNext                         voidptr       = unsafe { nil }
	flags                         VideoEncodeCapabilityFlagsKHR
	rateControlModes              VideoEncodeRateControlModeFlagsKHR
	maxRateControlLayers          u32
	maxBitrate                    u64
	maxQualityLevels              u32
	encodeInputPictureGranularity Extent2D
	supportedEncodeFeedbackFlags  VideoEncodeFeedbackFlagsKHR
}

pub type QueryPoolVideoEncodeFeedbackCreateInfoKHR = C.VkQueryPoolVideoEncodeFeedbackCreateInfoKHR

@[typedef]
pub struct C.VkQueryPoolVideoEncodeFeedbackCreateInfoKHR {
pub mut:
	sType               StructureType = StructureType.query_pool_video_encode_feedback_create_info_khr
	pNext               voidptr       = unsafe { nil }
	encodeFeedbackFlags VideoEncodeFeedbackFlagsKHR
}

pub type VideoEncodeUsageInfoKHR = C.VkVideoEncodeUsageInfoKHR

@[typedef]
pub struct C.VkVideoEncodeUsageInfoKHR {
pub mut:
	sType             StructureType = StructureType.video_encode_usage_info_khr
	pNext             voidptr       = unsafe { nil }
	videoUsageHints   VideoEncodeUsageFlagsKHR
	videoContentHints VideoEncodeContentFlagsKHR
	tuningMode        VideoEncodeTuningModeKHR
}

pub type VideoEncodeRateControlLayerInfoKHR = C.VkVideoEncodeRateControlLayerInfoKHR

@[typedef]
pub struct C.VkVideoEncodeRateControlLayerInfoKHR {
pub mut:
	sType                StructureType = StructureType.video_encode_rate_control_layer_info_khr
	pNext                voidptr       = unsafe { nil }
	averageBitrate       u64
	maxBitrate           u64
	frameRateNumerator   u32
	frameRateDenominator u32
}

pub type VideoEncodeRateControlInfoKHR = C.VkVideoEncodeRateControlInfoKHR

@[typedef]
pub struct C.VkVideoEncodeRateControlInfoKHR {
pub mut:
	sType                        StructureType = StructureType.video_encode_rate_control_info_khr
	pNext                        voidptr       = unsafe { nil }
	flags                        VideoEncodeRateControlFlagsKHR
	rateControlMode              VideoEncodeRateControlModeFlagBitsKHR
	layerCount                   u32
	pLayers                      &VideoEncodeRateControlLayerInfoKHR
	virtualBufferSizeInMs        u32
	initialVirtualBufferSizeInMs u32
}

pub type PhysicalDeviceVideoEncodeQualityLevelInfoKHR = C.VkPhysicalDeviceVideoEncodeQualityLevelInfoKHR

@[typedef]
pub struct C.VkPhysicalDeviceVideoEncodeQualityLevelInfoKHR {
pub mut:
	sType         StructureType = StructureType.physical_device_video_encode_quality_level_info_khr
	pNext         voidptr       = unsafe { nil }
	pVideoProfile &VideoProfileInfoKHR
	qualityLevel  u32
}

pub type VideoEncodeQualityLevelPropertiesKHR = C.VkVideoEncodeQualityLevelPropertiesKHR

@[typedef]
pub struct C.VkVideoEncodeQualityLevelPropertiesKHR {
pub mut:
	sType                          StructureType = StructureType.video_encode_quality_level_properties_khr
	pNext                          voidptr       = unsafe { nil }
	preferredRateControlMode       VideoEncodeRateControlModeFlagBitsKHR
	preferredRateControlLayerCount u32
}

pub type VideoEncodeQualityLevelInfoKHR = C.VkVideoEncodeQualityLevelInfoKHR

@[typedef]
pub struct C.VkVideoEncodeQualityLevelInfoKHR {
pub mut:
	sType        StructureType = StructureType.video_encode_quality_level_info_khr
	pNext        voidptr       = unsafe { nil }
	qualityLevel u32
}

pub type VideoEncodeSessionParametersGetInfoKHR = C.VkVideoEncodeSessionParametersGetInfoKHR

@[typedef]
pub struct C.VkVideoEncodeSessionParametersGetInfoKHR {
pub mut:
	sType                  StructureType = StructureType.video_encode_session_parameters_get_info_khr
	pNext                  voidptr       = unsafe { nil }
	videoSessionParameters C.VkVideoSessionParametersKHR
}

pub type VideoEncodeSessionParametersFeedbackInfoKHR = C.VkVideoEncodeSessionParametersFeedbackInfoKHR

@[typedef]
pub struct C.VkVideoEncodeSessionParametersFeedbackInfoKHR {
pub mut:
	sType        StructureType = StructureType.video_encode_session_parameters_feedback_info_khr
	pNext        voidptr       = unsafe { nil }
	hasOverrides Bool32
}

fn C.vkGetPhysicalDeviceVideoEncodeQualityLevelPropertiesKHR(C.VkPhysicalDevice, &PhysicalDeviceVideoEncodeQualityLevelInfoKHR, &VideoEncodeQualityLevelPropertiesKHR) Result

pub type PFN_vkGetPhysicalDeviceVideoEncodeQualityLevelPropertiesKHR = fn (C.VkPhysicalDevice, &PhysicalDeviceVideoEncodeQualityLevelInfoKHR, &VideoEncodeQualityLevelPropertiesKHR) Result

@[inline]
pub fn get_physical_device_video_encode_quality_level_properties_khr(physical_device C.VkPhysicalDevice,
	p_quality_level_info &PhysicalDeviceVideoEncodeQualityLevelInfoKHR,
	p_quality_level_properties &VideoEncodeQualityLevelPropertiesKHR) Result {
	return C.vkGetPhysicalDeviceVideoEncodeQualityLevelPropertiesKHR(physical_device,
		p_quality_level_info, p_quality_level_properties)
}

fn C.vkGetEncodedVideoSessionParametersKHR(C.VkDevice, &VideoEncodeSessionParametersGetInfoKHR, &VideoEncodeSessionParametersFeedbackInfoKHR, &usize, voidptr) Result

pub type PFN_vkGetEncodedVideoSessionParametersKHR = fn (C.VkDevice, &VideoEncodeSessionParametersGetInfoKHR, &VideoEncodeSessionParametersFeedbackInfoKHR, &usize, voidptr) Result

@[inline]
pub fn get_encoded_video_session_parameters_khr(device C.VkDevice,
	p_video_session_parameters_info &VideoEncodeSessionParametersGetInfoKHR,
	p_feedback_info &VideoEncodeSessionParametersFeedbackInfoKHR,
	p_data_size &usize,
	p_data voidptr) Result {
	return C.vkGetEncodedVideoSessionParametersKHR(device, p_video_session_parameters_info,
		p_feedback_info, p_data_size, p_data)
}

fn C.vkCmdEncodeVideoKHR(C.VkCommandBuffer, &VideoEncodeInfoKHR)

pub type PFN_vkCmdEncodeVideoKHR = fn (C.VkCommandBuffer, &VideoEncodeInfoKHR)

@[inline]
pub fn cmd_encode_video_khr(command_buffer C.VkCommandBuffer,
	p_encode_info &VideoEncodeInfoKHR) {
	C.vkCmdEncodeVideoKHR(command_buffer, p_encode_info)
}

pub const khr_synchronization_2_spec_version = 1
pub const khr_synchronization_2_extension_name = 'VK_KHR_synchronization2'

pub type PipelineStageFlags2KHR = u64
pub type PipelineStageFlagBits2KHR = u64

pub type AccessFlags2KHR = u64
pub type AccessFlagBits2KHR = u64

pub type SubmitFlagBitsKHR = SubmitFlagBits

pub type SubmitFlagsKHR = u32
pub type MemoryBarrier2KHR = C.VkMemoryBarrier2

pub type BufferMemoryBarrier2KHR = C.VkBufferMemoryBarrier2

pub type ImageMemoryBarrier2KHR = C.VkImageMemoryBarrier2

pub type DependencyInfoKHR = C.VkDependencyInfo

pub type SubmitInfo2KHR = C.VkSubmitInfo2

pub type SemaphoreSubmitInfoKHR = C.VkSemaphoreSubmitInfo

pub type CommandBufferSubmitInfoKHR = C.VkCommandBufferSubmitInfo

pub type PhysicalDeviceSynchronization2FeaturesKHR = C.VkPhysicalDeviceSynchronization2Features

pub type QueueFamilyCheckpointProperties2NV = C.VkQueueFamilyCheckpointProperties2NV

@[typedef]
pub struct C.VkQueueFamilyCheckpointProperties2NV {
pub mut:
	sType                        StructureType = StructureType.queue_family_checkpoint_properties2_nv
	pNext                        voidptr       = unsafe { nil }
	checkpointExecutionStageMask PipelineStageFlags2
}

pub type CheckpointData2NV = C.VkCheckpointData2NV

@[typedef]
pub struct C.VkCheckpointData2NV {
pub mut:
	sType             StructureType = StructureType.checkpoint_data2_nv
	pNext             voidptr       = unsafe { nil }
	stage             PipelineStageFlags2
	pCheckpointMarker voidptr
}

fn C.vkCmdWriteBufferMarker2AMD(C.VkCommandBuffer, PipelineStageFlags2, C.VkBuffer, DeviceSize, u32)

pub type PFN_vkCmdWriteBufferMarker2AMD = fn (C.VkCommandBuffer, PipelineStageFlags2, C.VkBuffer, DeviceSize, u32)

@[inline]
pub fn cmd_write_buffer_marker2_amd(command_buffer C.VkCommandBuffer,
	stage PipelineStageFlags2,
	dst_buffer C.VkBuffer,
	dst_offset DeviceSize,
	marker u32) {
	C.vkCmdWriteBufferMarker2AMD(command_buffer, stage, dst_buffer, dst_offset, marker)
}

fn C.vkGetQueueCheckpointData2NV(C.VkQueue, &u32, &CheckpointData2NV)

pub type PFN_vkGetQueueCheckpointData2NV = fn (C.VkQueue, &u32, &CheckpointData2NV)

@[inline]
pub fn get_queue_checkpoint_data2_nv(queue C.VkQueue,
	p_checkpoint_data_count &u32,
	p_checkpoint_data &CheckpointData2NV) {
	C.vkGetQueueCheckpointData2NV(queue, p_checkpoint_data_count, p_checkpoint_data)
}

pub const khr_fragment_shader_barycentric_spec_version = 1
pub const khr_fragment_shader_barycentric_extension_name = 'VK_KHR_fragment_shader_barycentric'

pub type PhysicalDeviceFragmentShaderBarycentricFeaturesKHR = C.VkPhysicalDeviceFragmentShaderBarycentricFeaturesKHR

@[typedef]
pub struct C.VkPhysicalDeviceFragmentShaderBarycentricFeaturesKHR {
pub mut:
	sType                     StructureType = StructureType.physical_device_fragment_shader_barycentric_features_khr
	pNext                     voidptr       = unsafe { nil }
	fragmentShaderBarycentric Bool32
}

pub type PhysicalDeviceFragmentShaderBarycentricPropertiesKHR = C.VkPhysicalDeviceFragmentShaderBarycentricPropertiesKHR

@[typedef]
pub struct C.VkPhysicalDeviceFragmentShaderBarycentricPropertiesKHR {
pub mut:
	sType                                           StructureType = StructureType.physical_device_fragment_shader_barycentric_properties_khr
	pNext                                           voidptr       = unsafe { nil }
	triStripVertexOrderIndependentOfProvokingVertex Bool32
}

pub const khr_shader_subgroup_uniform_control_flow_spec_version = 1
pub const khr_shader_subgroup_uniform_control_flow_extension_name = 'VK_KHR_shader_subgroup_uniform_control_flow'

pub type PhysicalDeviceShaderSubgroupUniformControlFlowFeaturesKHR = C.VkPhysicalDeviceShaderSubgroupUniformControlFlowFeaturesKHR

@[typedef]
pub struct C.VkPhysicalDeviceShaderSubgroupUniformControlFlowFeaturesKHR {
pub mut:
	sType                            StructureType = StructureType.physical_device_shader_subgroup_uniform_control_flow_features_khr
	pNext                            voidptr       = unsafe { nil }
	shaderSubgroupUniformControlFlow Bool32
}

pub const khr_zero_initialize_workgroup_memory_spec_version = 1
pub const khr_zero_initialize_workgroup_memory_extension_name = 'VK_KHR_zero_initialize_workgroup_memory'

pub type PhysicalDeviceZeroInitializeWorkgroupMemoryFeaturesKHR = C.VkPhysicalDeviceZeroInitializeWorkgroupMemoryFeatures

pub const khr_workgroup_memory_explicit_layout_spec_version = 1
pub const khr_workgroup_memory_explicit_layout_extension_name = 'VK_KHR_workgroup_memory_explicit_layout'

pub type PhysicalDeviceWorkgroupMemoryExplicitLayoutFeaturesKHR = C.VkPhysicalDeviceWorkgroupMemoryExplicitLayoutFeaturesKHR

@[typedef]
pub struct C.VkPhysicalDeviceWorkgroupMemoryExplicitLayoutFeaturesKHR {
pub mut:
	sType                                          StructureType = StructureType.physical_device_workgroup_memory_explicit_layout_features_khr
	pNext                                          voidptr       = unsafe { nil }
	workgroupMemoryExplicitLayout                  Bool32
	workgroupMemoryExplicitLayoutScalarBlockLayout Bool32
	workgroupMemoryExplicitLayout8BitAccess        Bool32
	workgroupMemoryExplicitLayout16BitAccess       Bool32
}

pub const khr_copy_commands_2_spec_version = 1
pub const khr_copy_commands_2_extension_name = 'VK_KHR_copy_commands2'

pub type CopyBufferInfo2KHR = C.VkCopyBufferInfo2

pub type CopyImageInfo2KHR = C.VkCopyImageInfo2

pub type CopyBufferToImageInfo2KHR = C.VkCopyBufferToImageInfo2

pub type CopyImageToBufferInfo2KHR = C.VkCopyImageToBufferInfo2

pub type BlitImageInfo2KHR = C.VkBlitImageInfo2

pub type ResolveImageInfo2KHR = C.VkResolveImageInfo2

pub type BufferCopy2KHR = C.VkBufferCopy2

pub type ImageCopy2KHR = C.VkImageCopy2

pub type ImageBlit2KHR = C.VkImageBlit2

pub type BufferImageCopy2KHR = C.VkBufferImageCopy2

pub type ImageResolve2KHR = C.VkImageResolve2

pub const khr_format_feature_flags_2_spec_version = 2
pub const khr_format_feature_flags_2_extension_name = 'VK_KHR_format_feature_flags2'

pub type FormatFeatureFlags2KHR = u64
pub type FormatFeatureFlagBits2KHR = u64

pub type FormatProperties3KHR = C.VkFormatProperties3

pub const khr_ray_tracing_maintenance_1_spec_version = 1
pub const khr_ray_tracing_maintenance_1_extension_name = 'VK_KHR_ray_tracing_maintenance1'

pub type PhysicalDeviceRayTracingMaintenance1FeaturesKHR = C.VkPhysicalDeviceRayTracingMaintenance1FeaturesKHR

@[typedef]
pub struct C.VkPhysicalDeviceRayTracingMaintenance1FeaturesKHR {
pub mut:
	sType                                StructureType = StructureType.physical_device_ray_tracing_maintenance1_features_khr
	pNext                                voidptr       = unsafe { nil }
	rayTracingMaintenance1               Bool32
	rayTracingPipelineTraceRaysIndirect2 Bool32
}

pub type TraceRaysIndirectCommand2KHR = C.VkTraceRaysIndirectCommand2KHR

@[typedef]
pub struct C.VkTraceRaysIndirectCommand2KHR {
pub mut:
	raygenShaderRecordAddress         DeviceAddress
	raygenShaderRecordSize            DeviceSize
	missShaderBindingTableAddress     DeviceAddress
	missShaderBindingTableSize        DeviceSize
	missShaderBindingTableStride      DeviceSize
	hitShaderBindingTableAddress      DeviceAddress
	hitShaderBindingTableSize         DeviceSize
	hitShaderBindingTableStride       DeviceSize
	callableShaderBindingTableAddress DeviceAddress
	callableShaderBindingTableSize    DeviceSize
	callableShaderBindingTableStride  DeviceSize
	width                             u32
	height                            u32
	depth                             u32
}

fn C.vkCmdTraceRaysIndirect2KHR(C.VkCommandBuffer, DeviceAddress)

pub type PFN_vkCmdTraceRaysIndirect2KHR = fn (C.VkCommandBuffer, DeviceAddress)

@[inline]
pub fn cmd_trace_rays_indirect2_khr(command_buffer C.VkCommandBuffer,
	indirect_device_address DeviceAddress) {
	C.vkCmdTraceRaysIndirect2KHR(command_buffer, indirect_device_address)
}

pub const khr_portability_enumeration_spec_version = 1
pub const khr_portability_enumeration_extension_name = 'VK_KHR_portability_enumeration'

pub const khr_maintenance_4_spec_version = 2
pub const khr_maintenance_4_extension_name = 'VK_KHR_maintenance4'

pub type PhysicalDeviceMaintenance4FeaturesKHR = C.VkPhysicalDeviceMaintenance4Features

pub type PhysicalDeviceMaintenance4PropertiesKHR = C.VkPhysicalDeviceMaintenance4Properties

pub type DeviceBufferMemoryRequirementsKHR = C.VkDeviceBufferMemoryRequirements

pub type DeviceImageMemoryRequirementsKHR = C.VkDeviceImageMemoryRequirements

pub const khr_maintenance_5_spec_version = 1
pub const khr_maintenance_5_extension_name = 'VK_KHR_maintenance5'

pub type PipelineCreateFlags2KHR = u64

// Flag bits for PipelineCreateFlagBits2KHR
pub type PipelineCreateFlagBits2KHR = u64

pub const pipeline_create_2_disable_optimization_bit_khr = u64(0x00000001)
pub const pipeline_create_2_allow_derivatives_bit_khr = u64(0x00000002)
pub const pipeline_create_2_derivative_bit_khr = u64(0x00000004)
pub const pipeline_create_2_view_index_from_device_index_bit_khr = u64(0x00000008)
pub const pipeline_create_2_dispatch_base_bit_khr = u64(0x00000010)
pub const pipeline_create_2_defer_compile_bit_nv = u64(0x00000020)
pub const pipeline_create_2_capture_statistics_bit_khr = u64(0x00000040)
pub const pipeline_create_2_capture_internal_representations_bit_khr = u64(0x00000080)
pub const pipeline_create_2_fail_on_pipeline_compile_required_bit_khr = u64(0x00000100)
pub const pipeline_create_2_early_return_on_failure_bit_khr = u64(0x00000200)
pub const pipeline_create_2_link_time_optimization_bit_ext = u64(0x00000400)
pub const pipeline_create_2_retain_link_time_optimization_info_bit_ext = u64(0x00800000)
pub const pipeline_create_2_library_bit_khr = u64(0x00000800)
pub const pipeline_create_2_ray_tracing_skip_triangles_bit_khr = u64(0x00001000)
pub const pipeline_create_2_ray_tracing_skip_aabbs_bit_khr = u64(0x00002000)
pub const pipeline_create_2_ray_tracing_no_null_any_hit_shaders_bit_khr = u64(0x00004000)
pub const pipeline_create_2_ray_tracing_no_null_closest_hit_shaders_bit_khr = u64(0x00008000)
pub const pipeline_create_2_ray_tracing_no_null_miss_shaders_bit_khr = u64(0x00010000)
pub const pipeline_create_2_ray_tracing_no_null_intersection_shaders_bit_khr = u64(0x00020000)
pub const pipeline_create_2_ray_tracing_shader_group_handle_capture_replay_bit_khr = u64(0x00080000)
pub const pipeline_create_2_indirect_bindable_bit_nv = u64(0x00040000)
pub const pipeline_create_2_ray_tracing_allow_motion_bit_nv = u64(0x00100000)
pub const pipeline_create_2_rendering_fragment_shading_rate_attachment_bit_khr = u64(0x00200000)
pub const pipeline_create_2_rendering_fragment_density_map_attachment_bit_ext = u64(0x00400000)
pub const pipeline_create_2_ray_tracing_opacity_micromap_bit_ext = u64(0x01000000)
pub const pipeline_create_2_color_attachment_feedback_loop_bit_ext = u64(0x02000000)
pub const pipeline_create_2_depth_stencil_attachment_feedback_loop_bit_ext = u64(0x04000000)
pub const pipeline_create_2_no_protected_access_bit_ext = u64(0x08000000)
pub const pipeline_create_2_protected_access_only_bit_ext = u64(0x40000000)
pub const pipeline_create_2_ray_tracing_displacement_micromap_bit_nv = u64(0x10000000)
pub const pipeline_create_2_descriptor_buffer_bit_ext = u64(0x20000000)

pub type BufferUsageFlags2KHR = u64

// Flag bits for BufferUsageFlagBits2KHR
pub type BufferUsageFlagBits2KHR = u64

pub const buffer_usage_2_transfer_src_bit_khr = u64(0x00000001)
pub const buffer_usage_2_transfer_dst_bit_khr = u64(0x00000002)
pub const buffer_usage_2_uniform_texel_buffer_bit_khr = u64(0x00000004)
pub const buffer_usage_2_storage_texel_buffer_bit_khr = u64(0x00000008)
pub const buffer_usage_2_uniform_buffer_bit_khr = u64(0x00000010)
pub const buffer_usage_2_storage_buffer_bit_khr = u64(0x00000020)
pub const buffer_usage_2_index_buffer_bit_khr = u64(0x00000040)
pub const buffer_usage_2_vertex_buffer_bit_khr = u64(0x00000080)
pub const buffer_usage_2_indirect_buffer_bit_khr = u64(0x00000100)
pub const buffer_usage_2_execution_graph_scratch_bit_amdx = u64(0x02000000)
pub const buffer_usage_2_conditional_rendering_bit_ext = u64(0x00000200)
pub const buffer_usage_2_shader_binding_table_bit_khr = u64(0x00000400)
pub const buffer_usage_2_ray_tracing_bit_nv = u32(buffer_usage_2_shader_binding_table_bit_khr)
pub const buffer_usage_2_transform_feedback_buffer_bit_ext = u64(0x00000800)
pub const buffer_usage_2_transform_feedback_counter_buffer_bit_ext = u64(0x00001000)
pub const buffer_usage_2_video_decode_src_bit_khr = u64(0x00002000)
pub const buffer_usage_2_video_decode_dst_bit_khr = u64(0x00004000)
pub const buffer_usage_2_video_encode_dst_bit_khr = u64(0x00008000)
pub const buffer_usage_2_video_encode_src_bit_khr = u64(0x00010000)
pub const buffer_usage_2_shader_device_address_bit_khr = u64(0x00020000)
pub const buffer_usage_2_acceleration_structure_build_input_read_only_bit_khr = u64(0x00080000)
pub const buffer_usage_2_acceleration_structure_storage_bit_khr = u64(0x00100000)
pub const buffer_usage_2_sampler_descriptor_buffer_bit_ext = u64(0x00200000)
pub const buffer_usage_2_resource_descriptor_buffer_bit_ext = u64(0x00400000)
pub const buffer_usage_2_push_descriptors_descriptor_buffer_bit_ext = u64(0x04000000)
pub const buffer_usage_2_micromap_build_input_read_only_bit_ext = u64(0x00800000)
pub const buffer_usage_2_micromap_storage_bit_ext = u64(0x01000000)

pub type PhysicalDeviceMaintenance5FeaturesKHR = C.VkPhysicalDeviceMaintenance5FeaturesKHR

@[typedef]
pub struct C.VkPhysicalDeviceMaintenance5FeaturesKHR {
pub mut:
	sType        StructureType = StructureType.physical_device_maintenance5_features_khr
	pNext        voidptr       = unsafe { nil }
	maintenance5 Bool32
}

pub type PhysicalDeviceMaintenance5PropertiesKHR = C.VkPhysicalDeviceMaintenance5PropertiesKHR

@[typedef]
pub struct C.VkPhysicalDeviceMaintenance5PropertiesKHR {
pub mut:
	sType                                               StructureType = StructureType.physical_device_maintenance5_properties_khr
	pNext                                               voidptr       = unsafe { nil }
	earlyFragmentMultisampleCoverageAfterSampleCounting Bool32
	earlyFragmentSampleMaskTestBeforeSampleCounting     Bool32
	depthStencilSwizzleOneSupport                       Bool32
	polygonModePointSize                                Bool32
	nonStrictSinglePixelWideLinesUseParallelogram       Bool32
	nonStrictWideLinesUseParallelogram                  Bool32
}

pub type RenderingAreaInfoKHR = C.VkRenderingAreaInfoKHR

@[typedef]
pub struct C.VkRenderingAreaInfoKHR {
pub mut:
	sType                   StructureType = StructureType.rendering_area_info_khr
	pNext                   voidptr       = unsafe { nil }
	viewMask                u32
	colorAttachmentCount    u32
	pColorAttachmentFormats &Format
	depthAttachmentFormat   Format
	stencilAttachmentFormat Format
}

pub type ImageSubresource2KHR = C.VkImageSubresource2KHR

@[typedef]
pub struct C.VkImageSubresource2KHR {
pub mut:
	sType            StructureType = StructureType.image_subresource2_khr
	pNext            voidptr       = unsafe { nil }
	imageSubresource ImageSubresource
}

pub type DeviceImageSubresourceInfoKHR = C.VkDeviceImageSubresourceInfoKHR

@[typedef]
pub struct C.VkDeviceImageSubresourceInfoKHR {
pub mut:
	sType        StructureType = StructureType.device_image_subresource_info_khr
	pNext        voidptr       = unsafe { nil }
	pCreateInfo  &ImageCreateInfo
	pSubresource &ImageSubresource2KHR
}

pub type SubresourceLayout2KHR = C.VkSubresourceLayout2KHR

@[typedef]
pub struct C.VkSubresourceLayout2KHR {
pub mut:
	sType             StructureType = StructureType.subresource_layout2_khr
	pNext             voidptr       = unsafe { nil }
	subresourceLayout SubresourceLayout
}

pub type PipelineCreateFlags2CreateInfoKHR = C.VkPipelineCreateFlags2CreateInfoKHR

@[typedef]
pub struct C.VkPipelineCreateFlags2CreateInfoKHR {
pub mut:
	sType StructureType = StructureType.pipeline_create_flags2_create_info_khr
	pNext voidptr       = unsafe { nil }
	flags PipelineCreateFlags2KHR
}

pub type BufferUsageFlags2CreateInfoKHR = C.VkBufferUsageFlags2CreateInfoKHR

@[typedef]
pub struct C.VkBufferUsageFlags2CreateInfoKHR {
pub mut:
	sType StructureType = StructureType.buffer_usage_flags2_create_info_khr
	pNext voidptr       = unsafe { nil }
	usage BufferUsageFlags2KHR
}

fn C.vkCmdBindIndexBuffer2KHR(C.VkCommandBuffer, C.VkBuffer, DeviceSize, DeviceSize, IndexType)

pub type PFN_vkCmdBindIndexBuffer2KHR = fn (C.VkCommandBuffer, C.VkBuffer, DeviceSize, DeviceSize, IndexType)

@[inline]
pub fn cmd_bind_index_buffer2_khr(command_buffer C.VkCommandBuffer,
	buffer C.VkBuffer,
	offset DeviceSize,
	size DeviceSize,
	index_type IndexType) {
	C.vkCmdBindIndexBuffer2KHR(command_buffer, buffer, offset, size, index_type)
}

fn C.vkGetRenderingAreaGranularityKHR(C.VkDevice, &RenderingAreaInfoKHR, &Extent2D)

pub type PFN_vkGetRenderingAreaGranularityKHR = fn (C.VkDevice, &RenderingAreaInfoKHR, &Extent2D)

@[inline]
pub fn get_rendering_area_granularity_khr(device C.VkDevice,
	p_rendering_area_info &RenderingAreaInfoKHR,
	p_granularity &Extent2D) {
	C.vkGetRenderingAreaGranularityKHR(device, p_rendering_area_info, p_granularity)
}

fn C.vkGetDeviceImageSubresourceLayoutKHR(C.VkDevice, &DeviceImageSubresourceInfoKHR, &SubresourceLayout2KHR)

pub type PFN_vkGetDeviceImageSubresourceLayoutKHR = fn (C.VkDevice, &DeviceImageSubresourceInfoKHR, &SubresourceLayout2KHR)

@[inline]
pub fn get_device_image_subresource_layout_khr(device C.VkDevice,
	p_info &DeviceImageSubresourceInfoKHR,
	p_layout &SubresourceLayout2KHR) {
	C.vkGetDeviceImageSubresourceLayoutKHR(device, p_info, p_layout)
}

fn C.vkGetImageSubresourceLayout2KHR(C.VkDevice, C.VkImage, &ImageSubresource2KHR, &SubresourceLayout2KHR)

pub type PFN_vkGetImageSubresourceLayout2KHR = fn (C.VkDevice, C.VkImage, &ImageSubresource2KHR, &SubresourceLayout2KHR)

@[inline]
pub fn get_image_subresource_layout2_khr(device C.VkDevice,
	image C.VkImage,
	p_subresource &ImageSubresource2KHR,
	p_layout &SubresourceLayout2KHR) {
	C.vkGetImageSubresourceLayout2KHR(device, image, p_subresource, p_layout)
}

pub const khr_ray_tracing_position_fetch_spec_version = 1
pub const khr_ray_tracing_position_fetch_extension_name = 'VK_KHR_ray_tracing_position_fetch'

pub type PhysicalDeviceRayTracingPositionFetchFeaturesKHR = C.VkPhysicalDeviceRayTracingPositionFetchFeaturesKHR

@[typedef]
pub struct C.VkPhysicalDeviceRayTracingPositionFetchFeaturesKHR {
pub mut:
	sType                   StructureType = StructureType.physical_device_ray_tracing_position_fetch_features_khr
	pNext                   voidptr       = unsafe { nil }
	rayTracingPositionFetch Bool32
}

pub const khr_cooperative_matrix_spec_version = 2
pub const khr_cooperative_matrix_extension_name = 'VK_KHR_cooperative_matrix'

pub enum ComponentTypeKHR {
	float16_khr  = 0
	float32_khr  = 1
	float64_khr  = 2
	sint8_khr    = 3
	sint16_khr   = 4
	sint32_khr   = 5
	sint64_khr   = 6
	uint8_khr    = 7
	uint16_khr   = 8
	uint32_khr   = 9
	uint64_khr   = 10
	max_enum_khr = max_int
}

pub enum ScopeKHR {
	device_khr       = 1
	workgroup_khr    = 2
	subgroup_khr     = 3
	queue_family_khr = 5
	max_enum_khr     = max_int
}

pub type CooperativeMatrixPropertiesKHR = C.VkCooperativeMatrixPropertiesKHR

@[typedef]
pub struct C.VkCooperativeMatrixPropertiesKHR {
pub mut:
	sType                  StructureType = StructureType.cooperative_matrix_properties_khr
	pNext                  voidptr       = unsafe { nil }
	MSize                  u32
	NSize                  u32
	KSize                  u32
	AType                  ComponentTypeKHR
	BType                  ComponentTypeKHR
	CType                  ComponentTypeKHR
	ResultType             ComponentTypeKHR
	saturatingAccumulation Bool32
	scope                  ScopeKHR
}

pub type PhysicalDeviceCooperativeMatrixFeaturesKHR = C.VkPhysicalDeviceCooperativeMatrixFeaturesKHR

@[typedef]
pub struct C.VkPhysicalDeviceCooperativeMatrixFeaturesKHR {
pub mut:
	sType                               StructureType = StructureType.physical_device_cooperative_matrix_features_khr
	pNext                               voidptr       = unsafe { nil }
	cooperativeMatrix                   Bool32
	cooperativeMatrixRobustBufferAccess Bool32
}

pub type PhysicalDeviceCooperativeMatrixPropertiesKHR = C.VkPhysicalDeviceCooperativeMatrixPropertiesKHR

@[typedef]
pub struct C.VkPhysicalDeviceCooperativeMatrixPropertiesKHR {
pub mut:
	sType                            StructureType = StructureType.physical_device_cooperative_matrix_properties_khr
	pNext                            voidptr       = unsafe { nil }
	cooperativeMatrixSupportedStages ShaderStageFlags
}

fn C.vkGetPhysicalDeviceCooperativeMatrixPropertiesKHR(C.VkPhysicalDevice, &u32, &CooperativeMatrixPropertiesKHR) Result

pub type PFN_vkGetPhysicalDeviceCooperativeMatrixPropertiesKHR = fn (C.VkPhysicalDevice, &u32, &CooperativeMatrixPropertiesKHR) Result

@[inline]
pub fn get_physical_device_cooperative_matrix_properties_khr(physical_device C.VkPhysicalDevice,
	p_property_count &u32,
	p_properties &CooperativeMatrixPropertiesKHR) Result {
	return C.vkGetPhysicalDeviceCooperativeMatrixPropertiesKHR(physical_device, p_property_count,
		p_properties)
}

pub const khr_video_maintenance_1_spec_version = 1
pub const khr_video_maintenance_1_extension_name = 'VK_KHR_video_maintenance1'

pub type PhysicalDeviceVideoMaintenance1FeaturesKHR = C.VkPhysicalDeviceVideoMaintenance1FeaturesKHR

@[typedef]
pub struct C.VkPhysicalDeviceVideoMaintenance1FeaturesKHR {
pub mut:
	sType             StructureType = StructureType.physical_device_video_maintenance1_features_khr
	pNext             voidptr       = unsafe { nil }
	videoMaintenance1 Bool32
}

pub type VideoInlineQueryInfoKHR = C.VkVideoInlineQueryInfoKHR

@[typedef]
pub struct C.VkVideoInlineQueryInfoKHR {
pub mut:
	sType      StructureType = StructureType.video_inline_query_info_khr
	pNext      voidptr       = unsafe { nil }
	queryPool  C.VkQueryPool
	firstQuery u32
	queryCount u32
}

pub const khr_vertex_attribute_divisor_spec_version = 1
pub const khr_vertex_attribute_divisor_extension_name = 'VK_KHR_vertex_attribute_divisor'

pub type PhysicalDeviceVertexAttributeDivisorPropertiesKHR = C.VkPhysicalDeviceVertexAttributeDivisorPropertiesKHR

@[typedef]
pub struct C.VkPhysicalDeviceVertexAttributeDivisorPropertiesKHR {
pub mut:
	sType                        StructureType = StructureType.physical_device_vertex_attribute_divisor_properties_khr
	pNext                        voidptr       = unsafe { nil }
	maxVertexAttribDivisor       u32
	supportsNonZeroFirstInstance Bool32
}

pub type VertexInputBindingDivisorDescriptionKHR = C.VkVertexInputBindingDivisorDescriptionKHR

@[typedef]
pub struct C.VkVertexInputBindingDivisorDescriptionKHR {
pub mut:
	binding u32
	divisor u32
}

pub type PipelineVertexInputDivisorStateCreateInfoKHR = C.VkPipelineVertexInputDivisorStateCreateInfoKHR

@[typedef]
pub struct C.VkPipelineVertexInputDivisorStateCreateInfoKHR {
pub mut:
	sType                     StructureType = StructureType.pipeline_vertex_input_divisor_state_create_info_khr
	pNext                     voidptr       = unsafe { nil }
	vertexBindingDivisorCount u32
	pVertexBindingDivisors    &VertexInputBindingDivisorDescriptionKHR
}

pub type PhysicalDeviceVertexAttributeDivisorFeaturesKHR = C.VkPhysicalDeviceVertexAttributeDivisorFeaturesKHR

@[typedef]
pub struct C.VkPhysicalDeviceVertexAttributeDivisorFeaturesKHR {
pub mut:
	sType                                  StructureType = StructureType.physical_device_vertex_attribute_divisor_features_khr
	pNext                                  voidptr       = unsafe { nil }
	vertexAttributeInstanceRateDivisor     Bool32
	vertexAttributeInstanceRateZeroDivisor Bool32
}

pub const khr_calibrated_timestamps_spec_version = 1
pub const khr_calibrated_timestamps_extension_name = 'VK_KHR_calibrated_timestamps'

pub enum TimeDomainKHR {
	device_khr                    = 0
	clock_monotonic_khr           = 1
	clock_monotonic_raw_khr       = 2
	query_performance_counter_khr = 3
	max_enum_khr                  = max_int
}

pub type CalibratedTimestampInfoKHR = C.VkCalibratedTimestampInfoKHR

@[typedef]
pub struct C.VkCalibratedTimestampInfoKHR {
pub mut:
	sType      StructureType = StructureType.calibrated_timestamp_info_khr
	pNext      voidptr       = unsafe { nil }
	timeDomain TimeDomainKHR
}

fn C.vkGetPhysicalDeviceCalibrateableTimeDomainsKHR(C.VkPhysicalDevice, &u32, &TimeDomainKHR) Result

pub type PFN_vkGetPhysicalDeviceCalibrateableTimeDomainsKHR = fn (C.VkPhysicalDevice, &u32, &TimeDomainKHR) Result

@[inline]
pub fn get_physical_device_calibrateable_time_domains_khr(physical_device C.VkPhysicalDevice,
	p_time_domain_count &u32,
	p_time_domains &TimeDomainKHR) Result {
	return C.vkGetPhysicalDeviceCalibrateableTimeDomainsKHR(physical_device, p_time_domain_count,
		p_time_domains)
}

fn C.vkGetCalibratedTimestampsKHR(C.VkDevice, u32, &CalibratedTimestampInfoKHR, &u64, &u64) Result

pub type PFN_vkGetCalibratedTimestampsKHR = fn (C.VkDevice, u32, &CalibratedTimestampInfoKHR, &u64, &u64) Result

@[inline]
pub fn get_calibrated_timestamps_khr(device C.VkDevice,
	timestamp_count u32,
	p_timestamp_infos &CalibratedTimestampInfoKHR,
	p_timestamps &u64,
	p_max_deviation &u64) Result {
	return C.vkGetCalibratedTimestampsKHR(device, timestamp_count, p_timestamp_infos,
		p_timestamps, p_max_deviation)
}

pub const khr_maintenance_6_spec_version = 1
pub const khr_maintenance_6_extension_name = 'VK_KHR_maintenance6'

pub type PhysicalDeviceMaintenance6FeaturesKHR = C.VkPhysicalDeviceMaintenance6FeaturesKHR

@[typedef]
pub struct C.VkPhysicalDeviceMaintenance6FeaturesKHR {
pub mut:
	sType        StructureType = StructureType.physical_device_maintenance6_features_khr
	pNext        voidptr       = unsafe { nil }
	maintenance6 Bool32
}

pub type PhysicalDeviceMaintenance6PropertiesKHR = C.VkPhysicalDeviceMaintenance6PropertiesKHR

@[typedef]
pub struct C.VkPhysicalDeviceMaintenance6PropertiesKHR {
pub mut:
	sType                                  StructureType = StructureType.physical_device_maintenance6_properties_khr
	pNext                                  voidptr       = unsafe { nil }
	blockTexelViewCompatibleMultipleLayers Bool32
	maxCombinedImageSamplerDescriptorCount u32
	fragmentShadingRateClampCombinerInputs Bool32
}

pub type BindMemoryStatusKHR = C.VkBindMemoryStatusKHR

@[typedef]
pub struct C.VkBindMemoryStatusKHR {
pub mut:
	sType   StructureType = StructureType.bind_memory_status_khr
	pNext   voidptr       = unsafe { nil }
	pResult &Result
}

pub type BindDescriptorSetsInfoKHR = C.VkBindDescriptorSetsInfoKHR

@[typedef]
pub struct C.VkBindDescriptorSetsInfoKHR {
pub mut:
	sType              StructureType = StructureType.bind_descriptor_sets_info_khr
	pNext              voidptr       = unsafe { nil }
	stageFlags         ShaderStageFlags
	layout             C.VkPipelineLayout
	firstSet           u32
	descriptorSetCount u32
	pDescriptorSets    C.VkDescriptorSet
	dynamicOffsetCount u32
	pDynamicOffsets    &u32
}

pub type PushConstantsInfoKHR = C.VkPushConstantsInfoKHR

@[typedef]
pub struct C.VkPushConstantsInfoKHR {
pub mut:
	sType      StructureType = StructureType.push_constants_info_khr
	pNext      voidptr       = unsafe { nil }
	layout     C.VkPipelineLayout
	stageFlags ShaderStageFlags
	offset     u32
	size       u32
	pValues    voidptr
}

pub type PushDescriptorSetInfoKHR = C.VkPushDescriptorSetInfoKHR

@[typedef]
pub struct C.VkPushDescriptorSetInfoKHR {
pub mut:
	sType                StructureType = StructureType.push_descriptor_set_info_khr
	pNext                voidptr       = unsafe { nil }
	stageFlags           ShaderStageFlags
	layout               C.VkPipelineLayout
	set                  u32
	descriptorWriteCount u32
	pDescriptorWrites    &WriteDescriptorSet
}

pub type PushDescriptorSetWithTemplateInfoKHR = C.VkPushDescriptorSetWithTemplateInfoKHR

@[typedef]
pub struct C.VkPushDescriptorSetWithTemplateInfoKHR {
pub mut:
	sType                    StructureType = StructureType.push_descriptor_set_with_template_info_khr
	pNext                    voidptr       = unsafe { nil }
	descriptorUpdateTemplate C.VkDescriptorUpdateTemplate
	layout                   C.VkPipelineLayout
	set                      u32
	pData                    voidptr
}

pub type SetDescriptorBufferOffsetsInfoEXT = C.VkSetDescriptorBufferOffsetsInfoEXT

@[typedef]
pub struct C.VkSetDescriptorBufferOffsetsInfoEXT {
pub mut:
	sType          StructureType = StructureType.set_descriptor_buffer_offsets_info_ext
	pNext          voidptr       = unsafe { nil }
	stageFlags     ShaderStageFlags
	layout         C.VkPipelineLayout
	firstSet       u32
	setCount       u32
	pBufferIndices &u32
	pOffsets       &DeviceSize
}

pub type BindDescriptorBufferEmbeddedSamplersInfoEXT = C.VkBindDescriptorBufferEmbeddedSamplersInfoEXT

@[typedef]
pub struct C.VkBindDescriptorBufferEmbeddedSamplersInfoEXT {
pub mut:
	sType      StructureType = StructureType.bind_descriptor_buffer_embedded_samplers_info_ext
	pNext      voidptr       = unsafe { nil }
	stageFlags ShaderStageFlags
	layout     C.VkPipelineLayout
	set        u32
}

fn C.vkCmdBindDescriptorSets2KHR(C.VkCommandBuffer, &BindDescriptorSetsInfoKHR)

pub type PFN_vkCmdBindDescriptorSets2KHR = fn (C.VkCommandBuffer, &BindDescriptorSetsInfoKHR)

@[inline]
pub fn cmd_bind_descriptor_sets2_khr(command_buffer C.VkCommandBuffer,
	p_bind_descriptor_sets_info &BindDescriptorSetsInfoKHR) {
	C.vkCmdBindDescriptorSets2KHR(command_buffer, p_bind_descriptor_sets_info)
}

fn C.vkCmdPushConstants2KHR(C.VkCommandBuffer, &PushConstantsInfoKHR)

pub type PFN_vkCmdPushConstants2KHR = fn (C.VkCommandBuffer, &PushConstantsInfoKHR)

@[inline]
pub fn cmd_push_constants2_khr(command_buffer C.VkCommandBuffer,
	p_push_constants_info &PushConstantsInfoKHR) {
	C.vkCmdPushConstants2KHR(command_buffer, p_push_constants_info)
}

fn C.vkCmdPushDescriptorSet2KHR(C.VkCommandBuffer, &PushDescriptorSetInfoKHR)

pub type PFN_vkCmdPushDescriptorSet2KHR = fn (C.VkCommandBuffer, &PushDescriptorSetInfoKHR)

@[inline]
pub fn cmd_push_descriptor_set2_khr(command_buffer C.VkCommandBuffer,
	p_push_descriptor_set_info &PushDescriptorSetInfoKHR) {
	C.vkCmdPushDescriptorSet2KHR(command_buffer, p_push_descriptor_set_info)
}

fn C.vkCmdPushDescriptorSetWithTemplate2KHR(C.VkCommandBuffer, &PushDescriptorSetWithTemplateInfoKHR)

pub type PFN_vkCmdPushDescriptorSetWithTemplate2KHR = fn (C.VkCommandBuffer, &PushDescriptorSetWithTemplateInfoKHR)

@[inline]
pub fn cmd_push_descriptor_set_with_template2_khr(command_buffer C.VkCommandBuffer,
	p_push_descriptor_set_with_template_info &PushDescriptorSetWithTemplateInfoKHR) {
	C.vkCmdPushDescriptorSetWithTemplate2KHR(command_buffer, p_push_descriptor_set_with_template_info)
}

fn C.vkCmdSetDescriptorBufferOffsets2EXT(C.VkCommandBuffer, &SetDescriptorBufferOffsetsInfoEXT)

pub type PFN_vkCmdSetDescriptorBufferOffsets2EXT = fn (C.VkCommandBuffer, &SetDescriptorBufferOffsetsInfoEXT)

@[inline]
pub fn cmd_set_descriptor_buffer_offsets2_ext(command_buffer C.VkCommandBuffer,
	p_set_descriptor_buffer_offsets_info &SetDescriptorBufferOffsetsInfoEXT) {
	C.vkCmdSetDescriptorBufferOffsets2EXT(command_buffer, p_set_descriptor_buffer_offsets_info)
}

fn C.vkCmdBindDescriptorBufferEmbeddedSamplers2EXT(C.VkCommandBuffer, &BindDescriptorBufferEmbeddedSamplersInfoEXT)

pub type PFN_vkCmdBindDescriptorBufferEmbeddedSamplers2EXT = fn (C.VkCommandBuffer, &BindDescriptorBufferEmbeddedSamplersInfoEXT)

@[inline]
pub fn cmd_bind_descriptor_buffer_embedded_samplers2_ext(command_buffer C.VkCommandBuffer,
	p_bind_descriptor_buffer_embedded_samplers_info &BindDescriptorBufferEmbeddedSamplersInfoEXT) {
	C.vkCmdBindDescriptorBufferEmbeddedSamplers2EXT(command_buffer, p_bind_descriptor_buffer_embedded_samplers_info)
}

pub type C.VkDebugReportCallbackEXT = voidptr

pub const ext_debug_report_spec_version = 10
pub const ext_debug_report_extension_name = 'VK_EXT_debug_report'

pub enum DebugReportObjectTypeEXT {
	unknown_ext                    = 0
	instance_ext                   = 1
	physical_device_ext            = 2
	device_ext                     = 3
	queue_ext                      = 4
	semaphore_ext                  = 5
	command_buffer_ext             = 6
	fence_ext                      = 7
	device_memory_ext              = 8
	buffer_ext                     = 9
	image_ext                      = 10
	event_ext                      = 11
	query_pool_ext                 = 12
	buffer_view_ext                = 13
	image_view_ext                 = 14
	shader_module_ext              = 15
	pipeline_cache_ext             = 16
	pipeline_layout_ext            = 17
	render_pass_ext                = 18
	pipeline_ext                   = 19
	descriptor_set_layout_ext      = 20
	sampler_ext                    = 21
	descriptor_pool_ext            = 22
	descriptor_set_ext             = 23
	framebuffer_ext                = 24
	command_pool_ext               = 25
	surface_khr_ext                = 26
	swapchain_khr_ext              = 27
	debug_report_callback_ext_ext  = 28
	display_khr_ext                = 29
	display_mode_khr_ext           = 30
	validation_cache_ext_ext       = 33
	sampler_ycbcr_conversion_ext   = 1000156000
	descriptor_update_template_ext = 1000085000
	cu_module_nvx_ext              = 1000029000
	cu_function_nvx_ext            = 1000029001
	acceleration_structure_khr_ext = 1000150000
	acceleration_structure_nv_ext  = 1000165000
	cuda_module_nv_ext             = 1000307000
	cuda_function_nv_ext           = 1000307001
	buffer_collection_fuchsia_ext  = 1000366000
	max_enum_ext                   = max_int
}

pub enum DebugReportFlagBitsEXT {
	information_bit_ext         = int(0x00000001)
	warning_bit_ext             = int(0x00000002)
	performance_warning_bit_ext = int(0x00000004)
	error_bit_ext               = int(0x00000008)
	debug_bit_ext               = int(0x00000010)
	max_enum_ext                = max_int
}

pub type DebugReportFlagsEXT = u32
pub type PFN_vkDebugReportCallbackEXT = fn (flags DebugReportFlagsEXT, objectType DebugReportObjectTypeEXT, object u64, location usize, messageCode i32, pLayerPrefix &char, pMessage &char, pUserData voidptr)

pub type DebugReportCallbackCreateInfoEXT = C.VkDebugReportCallbackCreateInfoEXT

@[typedef]
pub struct C.VkDebugReportCallbackCreateInfoEXT {
pub mut:
	sType       StructureType = StructureType.debug_report_callback_create_info_ext
	pNext       voidptr       = unsafe { nil }
	flags       DebugReportFlagsEXT
	pfnCallback PFN_vkDebugReportCallbackEXT = unsafe { nil }
	pUserData   voidptr                      = unsafe { nil }
}

fn C.vkCreateDebugReportCallbackEXT(C.VkInstance, &DebugReportCallbackCreateInfoEXT, &AllocationCallbacks, C.VkDebugReportCallbackEXT) Result

pub type PFN_vkCreateDebugReportCallbackEXT = fn (C.VkInstance, &DebugReportCallbackCreateInfoEXT, &AllocationCallbacks, C.VkDebugReportCallbackEXT) Result

@[inline]
pub fn create_debug_report_callback_ext(instance C.VkInstance,
	p_create_info &DebugReportCallbackCreateInfoEXT,
	p_allocator &AllocationCallbacks,
	p_callback C.VkDebugReportCallbackEXT) Result {
	return C.vkCreateDebugReportCallbackEXT(instance, p_create_info, p_allocator, p_callback)
}

fn C.vkDestroyDebugReportCallbackEXT(C.VkInstance, C.VkDebugReportCallbackEXT, &AllocationCallbacks)

pub type PFN_vkDestroyDebugReportCallbackEXT = fn (C.VkInstance, C.VkDebugReportCallbackEXT, &AllocationCallbacks)

@[inline]
pub fn destroy_debug_report_callback_ext(instance C.VkInstance,
	callback C.VkDebugReportCallbackEXT,
	p_allocator &AllocationCallbacks) {
	C.vkDestroyDebugReportCallbackEXT(instance, callback, p_allocator)
}

fn C.vkDebugReportMessageEXT(C.VkInstance, DebugReportFlagsEXT, DebugReportObjectTypeEXT, u64, usize, i32, &char, &char)

pub type PFN_vkDebugReportMessageEXT = fn (C.VkInstance, DebugReportFlagsEXT, DebugReportObjectTypeEXT, u64, usize, i32, &char, &char)

@[inline]
pub fn debug_report_message_ext(instance C.VkInstance,
	flags DebugReportFlagsEXT,
	object_type DebugReportObjectTypeEXT,
	object u64,
	location usize,
	message_code i32,
	p_layer_prefix &char,
	p_message &char) {
	C.vkDebugReportMessageEXT(instance, flags, object_type, object, location, message_code,
		p_layer_prefix, p_message)
}

pub const nv_glsl_shader_spec_version = 1
pub const nv_glsl_shader_extension_name = 'VK_NV_glsl_shader'

pub const ext_depth_range_unrestricted_spec_version = 1
pub const ext_depth_range_unrestricted_extension_name = 'VK_EXT_depth_range_unrestricted'

pub const img_filter_cubic_spec_version = 1
pub const img_filter_cubic_extension_name = 'VK_IMG_filter_cubic'

pub const amd_rasterization_order_spec_version = 1
pub const amd_rasterization_order_extension_name = 'VK_AMD_rasterization_order'

pub enum RasterizationOrderAMD {
	strict_amd   = 0
	relaxed_amd  = 1
	max_enum_amd = max_int
}

pub type PipelineRasterizationStateRasterizationOrderAMD = C.VkPipelineRasterizationStateRasterizationOrderAMD

@[typedef]
pub struct C.VkPipelineRasterizationStateRasterizationOrderAMD {
pub mut:
	sType              StructureType = StructureType.pipeline_rasterization_state_rasterization_order_amd
	pNext              voidptr       = unsafe { nil }
	rasterizationOrder RasterizationOrderAMD
}

pub const amd_shader_trinary_minmax_spec_version = 1
pub const amd_shader_trinary_minmax_extension_name = 'VK_AMD_shader_trinary_minmax'

pub const amd_shader_explicit_vertex_parameter_spec_version = 1
pub const amd_shader_explicit_vertex_parameter_extension_name = 'VK_AMD_shader_explicit_vertex_parameter'

pub const ext_debug_marker_spec_version = 4
pub const ext_debug_marker_extension_name = 'VK_EXT_debug_marker'

pub type DebugMarkerObjectNameInfoEXT = C.VkDebugMarkerObjectNameInfoEXT

@[typedef]
pub struct C.VkDebugMarkerObjectNameInfoEXT {
pub mut:
	sType       StructureType = StructureType.debug_marker_object_name_info_ext
	pNext       voidptr       = unsafe { nil }
	objectType  DebugReportObjectTypeEXT
	object      u64
	pObjectName &char
}

pub type DebugMarkerObjectTagInfoEXT = C.VkDebugMarkerObjectTagInfoEXT

@[typedef]
pub struct C.VkDebugMarkerObjectTagInfoEXT {
pub mut:
	sType      StructureType = StructureType.debug_marker_object_tag_info_ext
	pNext      voidptr       = unsafe { nil }
	objectType DebugReportObjectTypeEXT
	object     u64
	tagName    u64
	tagSize    usize
	pTag       voidptr
}

pub type DebugMarkerMarkerInfoEXT = C.VkDebugMarkerMarkerInfoEXT

@[typedef]
pub struct C.VkDebugMarkerMarkerInfoEXT {
pub mut:
	sType       StructureType = StructureType.debug_marker_marker_info_ext
	pNext       voidptr       = unsafe { nil }
	pMarkerName &char
	color       [4]f32
}

fn C.vkDebugMarkerSetObjectTagEXT(C.VkDevice, &DebugMarkerObjectTagInfoEXT) Result

pub type PFN_vkDebugMarkerSetObjectTagEXT = fn (C.VkDevice, &DebugMarkerObjectTagInfoEXT) Result

@[inline]
pub fn debug_marker_set_object_tag_ext(device C.VkDevice,
	p_tag_info &DebugMarkerObjectTagInfoEXT) Result {
	return C.vkDebugMarkerSetObjectTagEXT(device, p_tag_info)
}

fn C.vkDebugMarkerSetObjectNameEXT(C.VkDevice, &DebugMarkerObjectNameInfoEXT) Result

pub type PFN_vkDebugMarkerSetObjectNameEXT = fn (C.VkDevice, &DebugMarkerObjectNameInfoEXT) Result

@[inline]
pub fn debug_marker_set_object_name_ext(device C.VkDevice,
	p_name_info &DebugMarkerObjectNameInfoEXT) Result {
	return C.vkDebugMarkerSetObjectNameEXT(device, p_name_info)
}

fn C.vkCmdDebugMarkerBeginEXT(C.VkCommandBuffer, &DebugMarkerMarkerInfoEXT)

pub type PFN_vkCmdDebugMarkerBeginEXT = fn (C.VkCommandBuffer, &DebugMarkerMarkerInfoEXT)

@[inline]
pub fn cmd_debug_marker_begin_ext(command_buffer C.VkCommandBuffer,
	p_marker_info &DebugMarkerMarkerInfoEXT) {
	C.vkCmdDebugMarkerBeginEXT(command_buffer, p_marker_info)
}

fn C.vkCmdDebugMarkerEndEXT(C.VkCommandBuffer)

pub type PFN_vkCmdDebugMarkerEndEXT = fn (C.VkCommandBuffer)

@[inline]
pub fn cmd_debug_marker_end_ext(command_buffer C.VkCommandBuffer) {
	C.vkCmdDebugMarkerEndEXT(command_buffer)
}

fn C.vkCmdDebugMarkerInsertEXT(C.VkCommandBuffer, &DebugMarkerMarkerInfoEXT)

pub type PFN_vkCmdDebugMarkerInsertEXT = fn (C.VkCommandBuffer, &DebugMarkerMarkerInfoEXT)

@[inline]
pub fn cmd_debug_marker_insert_ext(command_buffer C.VkCommandBuffer,
	p_marker_info &DebugMarkerMarkerInfoEXT) {
	C.vkCmdDebugMarkerInsertEXT(command_buffer, p_marker_info)
}

pub const amd_gcn_shader_spec_version = 1
pub const amd_gcn_shader_extension_name = 'VK_AMD_gcn_shader'

pub const nv_dedicated_allocation_spec_version = 1
pub const nv_dedicated_allocation_extension_name = 'VK_NV_dedicated_allocation'

pub type DedicatedAllocationImageCreateInfoNV = C.VkDedicatedAllocationImageCreateInfoNV

@[typedef]
pub struct C.VkDedicatedAllocationImageCreateInfoNV {
pub mut:
	sType               StructureType = StructureType.dedicated_allocation_image_create_info_nv
	pNext               voidptr       = unsafe { nil }
	dedicatedAllocation Bool32
}

pub type DedicatedAllocationBufferCreateInfoNV = C.VkDedicatedAllocationBufferCreateInfoNV

@[typedef]
pub struct C.VkDedicatedAllocationBufferCreateInfoNV {
pub mut:
	sType               StructureType = StructureType.dedicated_allocation_buffer_create_info_nv
	pNext               voidptr       = unsafe { nil }
	dedicatedAllocation Bool32
}

pub type DedicatedAllocationMemoryAllocateInfoNV = C.VkDedicatedAllocationMemoryAllocateInfoNV

@[typedef]
pub struct C.VkDedicatedAllocationMemoryAllocateInfoNV {
pub mut:
	sType  StructureType = StructureType.dedicated_allocation_memory_allocate_info_nv
	pNext  voidptr       = unsafe { nil }
	image  C.VkImage
	buffer C.VkBuffer
}

pub const ext_transform_feedback_spec_version = 1
pub const ext_transform_feedback_extension_name = 'VK_EXT_transform_feedback'

pub type PipelineRasterizationStateStreamCreateFlagsEXT = u32
pub type PhysicalDeviceTransformFeedbackFeaturesEXT = C.VkPhysicalDeviceTransformFeedbackFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceTransformFeedbackFeaturesEXT {
pub mut:
	sType             StructureType = StructureType.physical_device_transform_feedback_features_ext
	pNext             voidptr       = unsafe { nil }
	transformFeedback Bool32
	geometryStreams   Bool32
}

pub type PhysicalDeviceTransformFeedbackPropertiesEXT = C.VkPhysicalDeviceTransformFeedbackPropertiesEXT

@[typedef]
pub struct C.VkPhysicalDeviceTransformFeedbackPropertiesEXT {
pub mut:
	sType                                      StructureType = StructureType.physical_device_transform_feedback_properties_ext
	pNext                                      voidptr       = unsafe { nil }
	maxTransformFeedbackStreams                u32
	maxTransformFeedbackBuffers                u32
	maxTransformFeedbackBufferSize             DeviceSize
	maxTransformFeedbackStreamDataSize         u32
	maxTransformFeedbackBufferDataSize         u32
	maxTransformFeedbackBufferDataStride       u32
	transformFeedbackQueries                   Bool32
	transformFeedbackStreamsLinesTriangles     Bool32
	transformFeedbackRasterizationStreamSelect Bool32
	transformFeedbackDraw                      Bool32
}

pub type PipelineRasterizationStateStreamCreateInfoEXT = C.VkPipelineRasterizationStateStreamCreateInfoEXT

@[typedef]
pub struct C.VkPipelineRasterizationStateStreamCreateInfoEXT {
pub mut:
	sType               StructureType = StructureType.pipeline_rasterization_state_stream_create_info_ext
	pNext               voidptr       = unsafe { nil }
	flags               PipelineRasterizationStateStreamCreateFlagsEXT
	rasterizationStream u32
}

fn C.vkCmdBindTransformFeedbackBuffersEXT(C.VkCommandBuffer, u32, u32, C.VkBuffer, &DeviceSize, &DeviceSize)

pub type PFN_vkCmdBindTransformFeedbackBuffersEXT = fn (C.VkCommandBuffer, u32, u32, C.VkBuffer, &DeviceSize, &DeviceSize)

@[inline]
pub fn cmd_bind_transform_feedback_buffers_ext(command_buffer C.VkCommandBuffer,
	first_binding u32,
	binding_count u32,
	p_buffers C.VkBuffer,
	p_offsets &DeviceSize,
	p_sizes &DeviceSize) {
	C.vkCmdBindTransformFeedbackBuffersEXT(command_buffer, first_binding, binding_count,
		p_buffers, p_offsets, p_sizes)
}

fn C.vkCmdBeginTransformFeedbackEXT(C.VkCommandBuffer, u32, u32, C.VkBuffer, &DeviceSize)

pub type PFN_vkCmdBeginTransformFeedbackEXT = fn (C.VkCommandBuffer, u32, u32, C.VkBuffer, &DeviceSize)

@[inline]
pub fn cmd_begin_transform_feedback_ext(command_buffer C.VkCommandBuffer,
	first_counter_buffer u32,
	counter_buffer_count u32,
	p_counter_buffers C.VkBuffer,
	p_counter_buffer_offsets &DeviceSize) {
	C.vkCmdBeginTransformFeedbackEXT(command_buffer, first_counter_buffer, counter_buffer_count,
		p_counter_buffers, p_counter_buffer_offsets)
}

fn C.vkCmdEndTransformFeedbackEXT(C.VkCommandBuffer, u32, u32, C.VkBuffer, &DeviceSize)

pub type PFN_vkCmdEndTransformFeedbackEXT = fn (C.VkCommandBuffer, u32, u32, C.VkBuffer, &DeviceSize)

@[inline]
pub fn cmd_end_transform_feedback_ext(command_buffer C.VkCommandBuffer,
	first_counter_buffer u32,
	counter_buffer_count u32,
	p_counter_buffers C.VkBuffer,
	p_counter_buffer_offsets &DeviceSize) {
	C.vkCmdEndTransformFeedbackEXT(command_buffer, first_counter_buffer, counter_buffer_count,
		p_counter_buffers, p_counter_buffer_offsets)
}

fn C.vkCmdBeginQueryIndexedEXT(C.VkCommandBuffer, C.VkQueryPool, u32, QueryControlFlags, u32)

pub type PFN_vkCmdBeginQueryIndexedEXT = fn (C.VkCommandBuffer, C.VkQueryPool, u32, QueryControlFlags, u32)

@[inline]
pub fn cmd_begin_query_indexed_ext(command_buffer C.VkCommandBuffer,
	query_pool C.VkQueryPool,
	query u32,
	flags QueryControlFlags,
	index u32) {
	C.vkCmdBeginQueryIndexedEXT(command_buffer, query_pool, query, flags, index)
}

fn C.vkCmdEndQueryIndexedEXT(C.VkCommandBuffer, C.VkQueryPool, u32, u32)

pub type PFN_vkCmdEndQueryIndexedEXT = fn (C.VkCommandBuffer, C.VkQueryPool, u32, u32)

@[inline]
pub fn cmd_end_query_indexed_ext(command_buffer C.VkCommandBuffer,
	query_pool C.VkQueryPool,
	query u32,
	index u32) {
	C.vkCmdEndQueryIndexedEXT(command_buffer, query_pool, query, index)
}

fn C.vkCmdDrawIndirectByteCountEXT(C.VkCommandBuffer, u32, u32, C.VkBuffer, DeviceSize, u32, u32)

pub type PFN_vkCmdDrawIndirectByteCountEXT = fn (C.VkCommandBuffer, u32, u32, C.VkBuffer, DeviceSize, u32, u32)

@[inline]
pub fn cmd_draw_indirect_byte_count_ext(command_buffer C.VkCommandBuffer,
	instance_count u32,
	first_instance u32,
	counter_buffer C.VkBuffer,
	counter_buffer_offset DeviceSize,
	counter_offset u32,
	vertex_stride u32) {
	C.vkCmdDrawIndirectByteCountEXT(command_buffer, instance_count, first_instance, counter_buffer,
		counter_buffer_offset, counter_offset, vertex_stride)
}

pub type C.VkCuModuleNVX = voidptr
pub type C.VkCuFunctionNVX = voidptr

pub const nvx_binary_import_spec_version = 1
pub const nvx_binary_import_extension_name = 'VK_NVX_binary_import'

pub type CuModuleCreateInfoNVX = C.VkCuModuleCreateInfoNVX

@[typedef]
pub struct C.VkCuModuleCreateInfoNVX {
pub mut:
	sType    StructureType = StructureType.cu_module_create_info_nvx
	pNext    voidptr       = unsafe { nil }
	dataSize usize
	pData    voidptr
}

pub type CuFunctionCreateInfoNVX = C.VkCuFunctionCreateInfoNVX

@[typedef]
pub struct C.VkCuFunctionCreateInfoNVX {
pub mut:
	sType    StructureType = StructureType.cu_function_create_info_nvx
	pNext    voidptr       = unsafe { nil }
	vkmodule C.VkCuModuleNVX
	pName    &char
}

pub type CuLaunchInfoNVX = C.VkCuLaunchInfoNVX

@[typedef]
pub struct C.VkCuLaunchInfoNVX {
pub mut:
	sType          StructureType = StructureType.cu_launch_info_nvx
	pNext          voidptr       = unsafe { nil }
	function       C.VkCuFunctionNVX
	gridDimX       u32
	gridDimY       u32
	gridDimZ       u32
	blockDimX      u32
	blockDimY      u32
	blockDimZ      u32
	sharedMemBytes u32
	paramCount     usize
	pParams        &&voidptr
	extraCount     usize
	pExtras        &&voidptr
}

fn C.vkCreateCuModuleNVX(C.VkDevice, &CuModuleCreateInfoNVX, &AllocationCallbacks, C.VkCuModuleNVX) Result

pub type PFN_vkCreateCuModuleNVX = fn (C.VkDevice, &CuModuleCreateInfoNVX, &AllocationCallbacks, C.VkCuModuleNVX) Result

@[inline]
pub fn create_cu_module_nvx(device C.VkDevice,
	p_create_info &CuModuleCreateInfoNVX,
	p_allocator &AllocationCallbacks,
	p_module C.VkCuModuleNVX) Result {
	return C.vkCreateCuModuleNVX(device, p_create_info, p_allocator, p_module)
}

fn C.vkCreateCuFunctionNVX(C.VkDevice, &CuFunctionCreateInfoNVX, &AllocationCallbacks, C.VkCuFunctionNVX) Result

pub type PFN_vkCreateCuFunctionNVX = fn (C.VkDevice, &CuFunctionCreateInfoNVX, &AllocationCallbacks, C.VkCuFunctionNVX) Result

@[inline]
pub fn create_cu_function_nvx(device C.VkDevice,
	p_create_info &CuFunctionCreateInfoNVX,
	p_allocator &AllocationCallbacks,
	p_function C.VkCuFunctionNVX) Result {
	return C.vkCreateCuFunctionNVX(device, p_create_info, p_allocator, p_function)
}

fn C.vkDestroyCuModuleNVX(C.VkDevice, C.VkCuModuleNVX, &AllocationCallbacks)

pub type PFN_vkDestroyCuModuleNVX = fn (C.VkDevice, C.VkCuModuleNVX, &AllocationCallbacks)

@[inline]
pub fn destroy_cu_module_nvx(device C.VkDevice,
	vkmodule C.VkCuModuleNVX,
	p_allocator &AllocationCallbacks) {
	C.vkDestroyCuModuleNVX(device, vkmodule, p_allocator)
}

fn C.vkDestroyCuFunctionNVX(C.VkDevice, C.VkCuFunctionNVX, &AllocationCallbacks)

pub type PFN_vkDestroyCuFunctionNVX = fn (C.VkDevice, C.VkCuFunctionNVX, &AllocationCallbacks)

@[inline]
pub fn destroy_cu_function_nvx(device C.VkDevice,
	function C.VkCuFunctionNVX,
	p_allocator &AllocationCallbacks) {
	C.vkDestroyCuFunctionNVX(device, function, p_allocator)
}

fn C.vkCmdCuLaunchKernelNVX(C.VkCommandBuffer, &CuLaunchInfoNVX)

pub type PFN_vkCmdCuLaunchKernelNVX = fn (C.VkCommandBuffer, &CuLaunchInfoNVX)

@[inline]
pub fn cmd_cu_launch_kernel_nvx(command_buffer C.VkCommandBuffer,
	p_launch_info &CuLaunchInfoNVX) {
	C.vkCmdCuLaunchKernelNVX(command_buffer, p_launch_info)
}

pub const nvx_image_view_handle_spec_version = 2
pub const nvx_image_view_handle_extension_name = 'VK_NVX_image_view_handle'

pub type ImageViewHandleInfoNVX = C.VkImageViewHandleInfoNVX

@[typedef]
pub struct C.VkImageViewHandleInfoNVX {
pub mut:
	sType          StructureType = StructureType.image_view_handle_info_nvx
	pNext          voidptr       = unsafe { nil }
	imageView      C.VkImageView
	descriptorType DescriptorType
	sampler        C.VkSampler
}

pub type ImageViewAddressPropertiesNVX = C.VkImageViewAddressPropertiesNVX

@[typedef]
pub struct C.VkImageViewAddressPropertiesNVX {
pub mut:
	sType         StructureType = StructureType.image_view_address_properties_nvx
	pNext         voidptr       = unsafe { nil }
	deviceAddress DeviceAddress
	size          DeviceSize
}

fn C.vkGetImageViewHandleNVX(C.VkDevice, &ImageViewHandleInfoNVX) u32

pub type PFN_vkGetImageViewHandleNVX = fn (C.VkDevice, &ImageViewHandleInfoNVX) u32

@[inline]
pub fn get_image_view_handle_nvx(device C.VkDevice,
	p_info &ImageViewHandleInfoNVX) u32 {
	return C.vkGetImageViewHandleNVX(device, p_info)
}

fn C.vkGetImageViewAddressNVX(C.VkDevice, C.VkImageView, &ImageViewAddressPropertiesNVX) Result

pub type PFN_vkGetImageViewAddressNVX = fn (C.VkDevice, C.VkImageView, &ImageViewAddressPropertiesNVX) Result

@[inline]
pub fn get_image_view_address_nvx(device C.VkDevice,
	image_view C.VkImageView,
	p_properties &ImageViewAddressPropertiesNVX) Result {
	return C.vkGetImageViewAddressNVX(device, image_view, p_properties)
}

pub const amd_draw_indirect_count_spec_version = 2
pub const amd_draw_indirect_count_extension_name = 'VK_AMD_draw_indirect_count'

pub const amd_negative_viewport_height_spec_version = 1
pub const amd_negative_viewport_height_extension_name = 'VK_AMD_negative_viewport_height'

pub const amd_gpu_shader_half_float_spec_version = 2
pub const amd_gpu_shader_half_float_extension_name = 'VK_AMD_gpu_shader_half_float'

pub const amd_shader_ballot_spec_version = 1
pub const amd_shader_ballot_extension_name = 'VK_AMD_shader_ballot'

pub const amd_texture_gather_bias_lod_spec_version = 1
pub const amd_texture_gather_bias_lod_extension_name = 'VK_AMD_texture_gather_bias_lod'

pub type TextureLODGatherFormatPropertiesAMD = C.VkTextureLODGatherFormatPropertiesAMD

@[typedef]
pub struct C.VkTextureLODGatherFormatPropertiesAMD {
pub mut:
	sType                           StructureType = StructureType.texture_lod_gather_format_properties_amd
	pNext                           voidptr       = unsafe { nil }
	supportsTextureGatherLODBiasAMD Bool32
}

pub const amd_shader_info_spec_version = 1
pub const amd_shader_info_extension_name = 'VK_AMD_shader_info'

pub enum ShaderInfoTypeAMD {
	statistics_amd  = 0
	binary_amd      = 1
	disassembly_amd = 2
	max_enum_amd    = max_int
}

pub type ShaderResourceUsageAMD = C.VkShaderResourceUsageAMD

@[typedef]
pub struct C.VkShaderResourceUsageAMD {
pub mut:
	numUsedVgprs             u32
	numUsedSgprs             u32
	ldsSizePerLocalWorkGroup u32
	ldsUsageSizeInBytes      usize
	scratchMemUsageInBytes   usize
}

pub type ShaderStatisticsInfoAMD = C.VkShaderStatisticsInfoAMD

@[typedef]
pub struct C.VkShaderStatisticsInfoAMD {
pub mut:
	shaderStageMask      ShaderStageFlags
	resourceUsage        ShaderResourceUsageAMD
	numPhysicalVgprs     u32
	numPhysicalSgprs     u32
	numAvailableVgprs    u32
	numAvailableSgprs    u32
	computeWorkGroupSize [3]u32
}

fn C.vkGetShaderInfoAMD(C.VkDevice, C.VkPipeline, ShaderStageFlagBits, ShaderInfoTypeAMD, &usize, voidptr) Result

pub type PFN_vkGetShaderInfoAMD = fn (C.VkDevice, C.VkPipeline, ShaderStageFlagBits, ShaderInfoTypeAMD, &usize, voidptr) Result

@[inline]
pub fn get_shader_info_amd(device C.VkDevice,
	pipeline C.VkPipeline,
	shader_stage ShaderStageFlagBits,
	info_type ShaderInfoTypeAMD,
	p_info_size &usize,
	p_info voidptr) Result {
	return C.vkGetShaderInfoAMD(device, pipeline, shader_stage, info_type, p_info_size,
		p_info)
}

pub const amd_shader_image_load_store_lod_spec_version = 1
pub const amd_shader_image_load_store_lod_extension_name = 'VK_AMD_shader_image_load_store_lod'

pub const nv_corner_sampled_image_spec_version = 2
pub const nv_corner_sampled_image_extension_name = 'VK_NV_corner_sampled_image'

pub type PhysicalDeviceCornerSampledImageFeaturesNV = C.VkPhysicalDeviceCornerSampledImageFeaturesNV

@[typedef]
pub struct C.VkPhysicalDeviceCornerSampledImageFeaturesNV {
pub mut:
	sType              StructureType = StructureType.physical_device_corner_sampled_image_features_nv
	pNext              voidptr       = unsafe { nil }
	cornerSampledImage Bool32
}

pub const img_format_pvrtc_spec_version = 1
pub const img_format_pvrtc_extension_name = 'VK_IMG_format_pvrtc'

pub const nv_external_memory_capabilities_spec_version = 1
pub const nv_external_memory_capabilities_extension_name = 'VK_NV_external_memory_capabilities'

pub enum ExternalMemoryHandleTypeFlagBitsNV {
	opaque_win32_bit_nv     = int(0x00000001)
	opaque_win32_kmt_bit_nv = int(0x00000002)
	d3d11_image_bit_nv      = int(0x00000004)
	d3d11_image_kmt_bit_nv  = int(0x00000008)
	max_enum_nv             = max_int
}

pub type ExternalMemoryHandleTypeFlagsNV = u32

pub enum ExternalMemoryFeatureFlagBitsNV {
	dedicated_only_bit_nv = int(0x00000001)
	exportable_bit_nv     = int(0x00000002)
	importable_bit_nv     = int(0x00000004)
	max_enum_nv           = max_int
}

pub type ExternalMemoryFeatureFlagsNV = u32
pub type ExternalImageFormatPropertiesNV = C.VkExternalImageFormatPropertiesNV

@[typedef]
pub struct C.VkExternalImageFormatPropertiesNV {
pub mut:
	imageFormatProperties         ImageFormatProperties
	externalMemoryFeatures        ExternalMemoryFeatureFlagsNV
	exportFromImportedHandleTypes ExternalMemoryHandleTypeFlagsNV
	compatibleHandleTypes         ExternalMemoryHandleTypeFlagsNV
}

fn C.vkGetPhysicalDeviceExternalImageFormatPropertiesNV(C.VkPhysicalDevice, Format, ImageType, ImageTiling, ImageUsageFlags, ImageCreateFlags, ExternalMemoryHandleTypeFlagsNV, &ExternalImageFormatPropertiesNV) Result

pub type PFN_vkGetPhysicalDeviceExternalImageFormatPropertiesNV = fn (C.VkPhysicalDevice, Format, ImageType, ImageTiling, ImageUsageFlags, ImageCreateFlags, ExternalMemoryHandleTypeFlagsNV, &ExternalImageFormatPropertiesNV) Result

@[inline]
pub fn get_physical_device_external_image_format_properties_nv(physical_device C.VkPhysicalDevice,
	format Format,
	type ImageType,
	tiling ImageTiling,
	usage ImageUsageFlags,
	flags ImageCreateFlags,
	external_handle_type ExternalMemoryHandleTypeFlagsNV,
	p_external_image_format_properties &ExternalImageFormatPropertiesNV) Result {
	return C.vkGetPhysicalDeviceExternalImageFormatPropertiesNV(physical_device, format,
		type, tiling, usage, flags, external_handle_type, p_external_image_format_properties)
}

pub const nv_external_memory_spec_version = 1
pub const nv_external_memory_extension_name = 'VK_NV_external_memory'

pub type ExternalMemoryImageCreateInfoNV = C.VkExternalMemoryImageCreateInfoNV

@[typedef]
pub struct C.VkExternalMemoryImageCreateInfoNV {
pub mut:
	sType       StructureType = StructureType.external_memory_image_create_info_nv
	pNext       voidptr       = unsafe { nil }
	handleTypes ExternalMemoryHandleTypeFlagsNV
}

pub type ExportMemoryAllocateInfoNV = C.VkExportMemoryAllocateInfoNV

@[typedef]
pub struct C.VkExportMemoryAllocateInfoNV {
pub mut:
	sType       StructureType = StructureType.export_memory_allocate_info_nv
	pNext       voidptr       = unsafe { nil }
	handleTypes ExternalMemoryHandleTypeFlagsNV
}

pub const ext_validation_flags_spec_version = 3
pub const ext_validation_flags_extension_name = 'VK_EXT_validation_flags'

pub enum ValidationCheckEXT {
	all_ext      = 0
	shaders_ext  = 1
	max_enum_ext = max_int
}

pub type ValidationFlagsEXT = C.VkValidationFlagsEXT

@[typedef]
pub struct C.VkValidationFlagsEXT {
pub mut:
	sType                        StructureType = StructureType.validation_flags_ext
	pNext                        voidptr       = unsafe { nil }
	disabledValidationCheckCount u32
	pDisabledValidationChecks    &ValidationCheckEXT
}

pub const ext_shader_subgroup_ballot_spec_version = 1
pub const ext_shader_subgroup_ballot_extension_name = 'VK_EXT_shader_subgroup_ballot'

pub const ext_shader_subgroup_vote_spec_version = 1
pub const ext_shader_subgroup_vote_extension_name = 'VK_EXT_shader_subgroup_vote'

pub const ext_texture_compression_astc_hdr_spec_version = 1
pub const ext_texture_compression_astc_hdr_extension_name = 'VK_EXT_texture_compression_astc_hdr'

pub type PhysicalDeviceTextureCompressionASTCHDRFeaturesEXT = C.VkPhysicalDeviceTextureCompressionASTCHDRFeatures

pub const ext_astc_decode_mode_spec_version = 1
pub const ext_astc_decode_mode_extension_name = 'VK_EXT_astc_decode_mode'

pub type ImageViewASTCDecodeModeEXT = C.VkImageViewASTCDecodeModeEXT

@[typedef]
pub struct C.VkImageViewASTCDecodeModeEXT {
pub mut:
	sType      StructureType = StructureType.image_view_astc_decode_mode_ext
	pNext      voidptr       = unsafe { nil }
	decodeMode Format
}

pub type PhysicalDeviceASTCDecodeFeaturesEXT = C.VkPhysicalDeviceASTCDecodeFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceASTCDecodeFeaturesEXT {
pub mut:
	sType                    StructureType = StructureType.physical_device_astc_decode_features_ext
	pNext                    voidptr       = unsafe { nil }
	decodeModeSharedExponent Bool32
}

pub const ext_pipeline_robustness_spec_version = 1
pub const ext_pipeline_robustness_extension_name = 'VK_EXT_pipeline_robustness'

pub enum PipelineRobustnessBufferBehaviorEXT {
	device_default_ext        = 0
	disabled_ext              = 1
	robust_buffer_access_ext  = 2
	robust_buffer_access2_ext = 3
	max_enum_ext              = max_int
}

pub enum PipelineRobustnessImageBehaviorEXT {
	device_default_ext       = 0
	disabled_ext             = 1
	robust_image_access_ext  = 2
	robust_image_access2_ext = 3
	max_enum_ext             = max_int
}

pub type PhysicalDevicePipelineRobustnessFeaturesEXT = C.VkPhysicalDevicePipelineRobustnessFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDevicePipelineRobustnessFeaturesEXT {
pub mut:
	sType              StructureType = StructureType.physical_device_pipeline_robustness_features_ext
	pNext              voidptr       = unsafe { nil }
	pipelineRobustness Bool32
}

pub type PhysicalDevicePipelineRobustnessPropertiesEXT = C.VkPhysicalDevicePipelineRobustnessPropertiesEXT

@[typedef]
pub struct C.VkPhysicalDevicePipelineRobustnessPropertiesEXT {
pub mut:
	sType                           StructureType = StructureType.physical_device_pipeline_robustness_properties_ext
	pNext                           voidptr       = unsafe { nil }
	defaultRobustnessStorageBuffers PipelineRobustnessBufferBehaviorEXT
	defaultRobustnessUniformBuffers PipelineRobustnessBufferBehaviorEXT
	defaultRobustnessVertexInputs   PipelineRobustnessBufferBehaviorEXT
	defaultRobustnessImages         PipelineRobustnessImageBehaviorEXT
}

pub type PipelineRobustnessCreateInfoEXT = C.VkPipelineRobustnessCreateInfoEXT

@[typedef]
pub struct C.VkPipelineRobustnessCreateInfoEXT {
pub mut:
	sType          StructureType = StructureType.pipeline_robustness_create_info_ext
	pNext          voidptr       = unsafe { nil }
	storageBuffers PipelineRobustnessBufferBehaviorEXT
	uniformBuffers PipelineRobustnessBufferBehaviorEXT
	vertexInputs   PipelineRobustnessBufferBehaviorEXT
	images         PipelineRobustnessImageBehaviorEXT
}

pub const ext_conditional_rendering_spec_version = 2
pub const ext_conditional_rendering_extension_name = 'VK_EXT_conditional_rendering'

pub enum ConditionalRenderingFlagBitsEXT {
	inverted_bit_ext = int(0x00000001)
	max_enum_ext     = max_int
}

pub type ConditionalRenderingFlagsEXT = u32
pub type ConditionalRenderingBeginInfoEXT = C.VkConditionalRenderingBeginInfoEXT

@[typedef]
pub struct C.VkConditionalRenderingBeginInfoEXT {
pub mut:
	sType  StructureType = StructureType.conditional_rendering_begin_info_ext
	pNext  voidptr       = unsafe { nil }
	buffer C.VkBuffer
	offset DeviceSize
	flags  ConditionalRenderingFlagsEXT
}

pub type PhysicalDeviceConditionalRenderingFeaturesEXT = C.VkPhysicalDeviceConditionalRenderingFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceConditionalRenderingFeaturesEXT {
pub mut:
	sType                         StructureType = StructureType.physical_device_conditional_rendering_features_ext
	pNext                         voidptr       = unsafe { nil }
	conditionalRendering          Bool32
	inheritedConditionalRendering Bool32
}

pub type CommandBufferInheritanceConditionalRenderingInfoEXT = C.VkCommandBufferInheritanceConditionalRenderingInfoEXT

@[typedef]
pub struct C.VkCommandBufferInheritanceConditionalRenderingInfoEXT {
pub mut:
	sType                      StructureType = StructureType.command_buffer_inheritance_conditional_rendering_info_ext
	pNext                      voidptr       = unsafe { nil }
	conditionalRenderingEnable Bool32
}

fn C.vkCmdBeginConditionalRenderingEXT(C.VkCommandBuffer, &ConditionalRenderingBeginInfoEXT)

pub type PFN_vkCmdBeginConditionalRenderingEXT = fn (C.VkCommandBuffer, &ConditionalRenderingBeginInfoEXT)

@[inline]
pub fn cmd_begin_conditional_rendering_ext(command_buffer C.VkCommandBuffer,
	p_conditional_rendering_begin &ConditionalRenderingBeginInfoEXT) {
	C.vkCmdBeginConditionalRenderingEXT(command_buffer, p_conditional_rendering_begin)
}

fn C.vkCmdEndConditionalRenderingEXT(C.VkCommandBuffer)

pub type PFN_vkCmdEndConditionalRenderingEXT = fn (C.VkCommandBuffer)

@[inline]
pub fn cmd_end_conditional_rendering_ext(command_buffer C.VkCommandBuffer) {
	C.vkCmdEndConditionalRenderingEXT(command_buffer)
}

pub const nv_clip_space_w_scaling_spec_version = 1
pub const nv_clip_space_w_scaling_extension_name = 'VK_NV_clip_space_w_scaling'

pub type ViewportWScalingNV = C.VkViewportWScalingNV

@[typedef]
pub struct C.VkViewportWScalingNV {
pub mut:
	xcoeff f32
	ycoeff f32
}

pub type PipelineViewportWScalingStateCreateInfoNV = C.VkPipelineViewportWScalingStateCreateInfoNV

@[typedef]
pub struct C.VkPipelineViewportWScalingStateCreateInfoNV {
pub mut:
	sType                  StructureType = StructureType.pipeline_viewport_w_scaling_state_create_info_nv
	pNext                  voidptr       = unsafe { nil }
	viewportWScalingEnable Bool32
	viewportCount          u32
	pViewportWScalings     &ViewportWScalingNV
}

fn C.vkCmdSetViewportWScalingNV(C.VkCommandBuffer, u32, u32, &ViewportWScalingNV)

pub type PFN_vkCmdSetViewportWScalingNV = fn (C.VkCommandBuffer, u32, u32, &ViewportWScalingNV)

@[inline]
pub fn cmd_set_viewport_w_scaling_nv(command_buffer C.VkCommandBuffer,
	first_viewport u32,
	viewport_count u32,
	p_viewport_w_scalings &ViewportWScalingNV) {
	C.vkCmdSetViewportWScalingNV(command_buffer, first_viewport, viewport_count, p_viewport_w_scalings)
}

pub const ext_direct_mode_display_spec_version = 1
pub const ext_direct_mode_display_extension_name = 'VK_EXT_direct_mode_display'

fn C.vkReleaseDisplayEXT(C.VkPhysicalDevice, C.VkDisplayKHR) Result

pub type PFN_vkReleaseDisplayEXT = fn (C.VkPhysicalDevice, C.VkDisplayKHR) Result

@[inline]
pub fn release_display_ext(physical_device C.VkPhysicalDevice,
	display C.VkDisplayKHR) Result {
	return C.vkReleaseDisplayEXT(physical_device, display)
}

pub const ext_display_surface_counter_spec_version = 1
pub const ext_display_surface_counter_extension_name = 'VK_EXT_display_surface_counter'

pub enum SurfaceCounterFlagBitsEXT {
	vblank_bit_ext = int(0x00000001)
	max_enum_ext   = max_int
}

pub type SurfaceCounterFlagsEXT = u32
pub type SurfaceCapabilities2EXT = C.VkSurfaceCapabilities2EXT

@[typedef]
pub struct C.VkSurfaceCapabilities2EXT {
pub mut:
	sType                    StructureType = StructureType.surface_capabilities2_ext
	pNext                    voidptr       = unsafe { nil }
	minImageCount            u32
	maxImageCount            u32
	currentExtent            Extent2D
	minImageExtent           Extent2D
	maxImageExtent           Extent2D
	maxImageArrayLayers      u32
	supportedTransforms      SurfaceTransformFlagsKHR
	currentTransform         SurfaceTransformFlagBitsKHR
	supportedCompositeAlpha  CompositeAlphaFlagsKHR
	supportedUsageFlags      ImageUsageFlags
	supportedSurfaceCounters SurfaceCounterFlagsEXT
}

fn C.vkGetPhysicalDeviceSurfaceCapabilities2EXT(C.VkPhysicalDevice, C.VkSurfaceKHR, &SurfaceCapabilities2EXT) Result

pub type PFN_vkGetPhysicalDeviceSurfaceCapabilities2EXT = fn (C.VkPhysicalDevice, C.VkSurfaceKHR, &SurfaceCapabilities2EXT) Result

@[inline]
pub fn get_physical_device_surface_capabilities2_ext(physical_device C.VkPhysicalDevice,
	surface C.VkSurfaceKHR,
	p_surface_capabilities &SurfaceCapabilities2EXT) Result {
	return C.vkGetPhysicalDeviceSurfaceCapabilities2EXT(physical_device, surface, p_surface_capabilities)
}

pub const ext_display_control_spec_version = 1
pub const ext_display_control_extension_name = 'VK_EXT_display_control'

pub enum DisplayPowerStateEXT {
	off_ext      = 0
	suspend_ext  = 1
	on_ext       = 2
	max_enum_ext = max_int
}

pub enum DeviceEventTypeEXT {
	display_hotplug_ext = 0
	max_enum_ext        = max_int
}

pub enum DisplayEventTypeEXT {
	first_pixel_out_ext = 0
	max_enum_ext        = max_int
}

pub type DisplayPowerInfoEXT = C.VkDisplayPowerInfoEXT

@[typedef]
pub struct C.VkDisplayPowerInfoEXT {
pub mut:
	sType      StructureType = StructureType.display_power_info_ext
	pNext      voidptr       = unsafe { nil }
	powerState DisplayPowerStateEXT
}

pub type DeviceEventInfoEXT = C.VkDeviceEventInfoEXT

@[typedef]
pub struct C.VkDeviceEventInfoEXT {
pub mut:
	sType       StructureType = StructureType.device_event_info_ext
	pNext       voidptr       = unsafe { nil }
	deviceEvent DeviceEventTypeEXT
}

pub type DisplayEventInfoEXT = C.VkDisplayEventInfoEXT

@[typedef]
pub struct C.VkDisplayEventInfoEXT {
pub mut:
	sType        StructureType = StructureType.display_event_info_ext
	pNext        voidptr       = unsafe { nil }
	displayEvent DisplayEventTypeEXT
}

pub type SwapchainCounterCreateInfoEXT = C.VkSwapchainCounterCreateInfoEXT

@[typedef]
pub struct C.VkSwapchainCounterCreateInfoEXT {
pub mut:
	sType           StructureType = StructureType.swapchain_counter_create_info_ext
	pNext           voidptr       = unsafe { nil }
	surfaceCounters SurfaceCounterFlagsEXT
}

fn C.vkDisplayPowerControlEXT(C.VkDevice, C.VkDisplayKHR, &DisplayPowerInfoEXT) Result

pub type PFN_vkDisplayPowerControlEXT = fn (C.VkDevice, C.VkDisplayKHR, &DisplayPowerInfoEXT) Result

@[inline]
pub fn display_power_control_ext(device C.VkDevice,
	display C.VkDisplayKHR,
	p_display_power_info &DisplayPowerInfoEXT) Result {
	return C.vkDisplayPowerControlEXT(device, display, p_display_power_info)
}

fn C.vkRegisterDeviceEventEXT(C.VkDevice, &DeviceEventInfoEXT, &AllocationCallbacks, C.VkFence) Result

pub type PFN_vkRegisterDeviceEventEXT = fn (C.VkDevice, &DeviceEventInfoEXT, &AllocationCallbacks, C.VkFence) Result

@[inline]
pub fn register_device_event_ext(device C.VkDevice,
	p_device_event_info &DeviceEventInfoEXT,
	p_allocator &AllocationCallbacks,
	p_fence C.VkFence) Result {
	return C.vkRegisterDeviceEventEXT(device, p_device_event_info, p_allocator, p_fence)
}

fn C.vkRegisterDisplayEventEXT(C.VkDevice, C.VkDisplayKHR, &DisplayEventInfoEXT, &AllocationCallbacks, C.VkFence) Result

pub type PFN_vkRegisterDisplayEventEXT = fn (C.VkDevice, C.VkDisplayKHR, &DisplayEventInfoEXT, &AllocationCallbacks, C.VkFence) Result

@[inline]
pub fn register_display_event_ext(device C.VkDevice,
	display C.VkDisplayKHR,
	p_display_event_info &DisplayEventInfoEXT,
	p_allocator &AllocationCallbacks,
	p_fence C.VkFence) Result {
	return C.vkRegisterDisplayEventEXT(device, display, p_display_event_info, p_allocator,
		p_fence)
}

fn C.vkGetSwapchainCounterEXT(C.VkDevice, C.VkSwapchainKHR, SurfaceCounterFlagBitsEXT, &u64) Result

pub type PFN_vkGetSwapchainCounterEXT = fn (C.VkDevice, C.VkSwapchainKHR, SurfaceCounterFlagBitsEXT, &u64) Result

@[inline]
pub fn get_swapchain_counter_ext(device C.VkDevice,
	swapchain C.VkSwapchainKHR,
	counter SurfaceCounterFlagBitsEXT,
	p_counter_value &u64) Result {
	return C.vkGetSwapchainCounterEXT(device, swapchain, counter, p_counter_value)
}

pub const google_display_timing_spec_version = 1
pub const google_display_timing_extension_name = 'VK_GOOGE_display_timing'

pub type RefreshCycleDurationGOOGLE = C.VkRefreshCycleDurationGOOGLE

@[typedef]
pub struct C.VkRefreshCycleDurationGOOGLE {
pub mut:
	refreshDuration u64
}

pub type PastPresentationTimingGOOGLE = C.VkPastPresentationTimingGOOGLE

@[typedef]
pub struct C.VkPastPresentationTimingGOOGLE {
pub mut:
	presentID           u32
	desiredPresentTime  u64
	actualPresentTime   u64
	earliestPresentTime u64
	presentMargin       u64
}

pub type PresentTimeGOOGLE = C.VkPresentTimeGOOGLE

@[typedef]
pub struct C.VkPresentTimeGOOGLE {
pub mut:
	presentID          u32
	desiredPresentTime u64
}

pub type PresentTimesInfoGOOGLE = C.VkPresentTimesInfoGOOGLE

@[typedef]
pub struct C.VkPresentTimesInfoGOOGLE {
pub mut:
	sType          StructureType = StructureType.present_times_info_google
	pNext          voidptr       = unsafe { nil }
	swapchainCount u32
	pTimes         &PresentTimeGOOGLE
}

fn C.vkGetRefreshCycleDurationGOOGLE(C.VkDevice, C.VkSwapchainKHR, &RefreshCycleDurationGOOGLE) Result

pub type PFN_vkGetRefreshCycleDurationGOOGLE = fn (C.VkDevice, C.VkSwapchainKHR, &RefreshCycleDurationGOOGLE) Result

@[inline]
pub fn get_refresh_cycle_duration_google(device C.VkDevice,
	swapchain C.VkSwapchainKHR,
	p_display_timing_properties &RefreshCycleDurationGOOGLE) Result {
	return C.vkGetRefreshCycleDurationGOOGLE(device, swapchain, p_display_timing_properties)
}

fn C.vkGetPastPresentationTimingGOOGLE(C.VkDevice, C.VkSwapchainKHR, &u32, &PastPresentationTimingGOOGLE) Result

pub type PFN_vkGetPastPresentationTimingGOOGLE = fn (C.VkDevice, C.VkSwapchainKHR, &u32, &PastPresentationTimingGOOGLE) Result

@[inline]
pub fn get_past_presentation_timing_google(device C.VkDevice,
	swapchain C.VkSwapchainKHR,
	p_presentation_timing_count &u32,
	p_presentation_timings &PastPresentationTimingGOOGLE) Result {
	return C.vkGetPastPresentationTimingGOOGLE(device, swapchain, p_presentation_timing_count,
		p_presentation_timings)
}

pub const nv_sample_mask_override_coverage_spec_version = 1
pub const nv_sample_mask_override_coverage_extension_name = 'VK_NV_sample_mask_override_coverage'

pub const nv_geometry_shader_passthrough_spec_version = 1
pub const nv_geometry_shader_passthrough_extension_name = 'VK_NV_geometry_shader_passthrough'

pub const nv_viewport_array_2_spec_version = 1
pub const nv_viewport_array_2_extension_name = 'VK_NV_viewport_array2'
// VK_NV_VIEWPORT_ARRAY2_SPEC_VERSION is a deprecated alias
pub const nv_viewport_array2_spec_version = nv_viewport_array_2_spec_version
// VK_NV_VIEWPORT_ARRAY2_EXTENSION_NAME is a deprecated alias
pub const nv_viewport_array2_extension_name = nv_viewport_array_2_extension_name

pub const nvx_multiview_per_view_attributes_spec_version = 1
pub const nvx_multiview_per_view_attributes_extension_name = 'VK_NVX_multiview_per_view_attributes'

pub type PhysicalDeviceMultiviewPerViewAttributesPropertiesNVX = C.VkPhysicalDeviceMultiviewPerViewAttributesPropertiesNVX

@[typedef]
pub struct C.VkPhysicalDeviceMultiviewPerViewAttributesPropertiesNVX {
pub mut:
	sType                        StructureType = StructureType.physical_device_multiview_per_view_attributes_properties_nvx
	pNext                        voidptr       = unsafe { nil }
	perViewPositionAllComponents Bool32
}

pub const nv_viewport_swizzle_spec_version = 1
pub const nv_viewport_swizzle_extension_name = 'VK_NV_viewport_swizzle'

pub enum ViewportCoordinateSwizzleNV {
	positive_x_nv = 0
	negative_x_nv = 1
	positive_y_nv = 2
	negative_y_nv = 3
	positive_z_nv = 4
	negative_z_nv = 5
	positive_w_nv = 6
	negative_w_nv = 7
	max_enum_nv   = max_int
}

pub type PipelineViewportSwizzleStateCreateFlagsNV = u32
pub type ViewportSwizzleNV = C.VkViewportSwizzleNV

@[typedef]
pub struct C.VkViewportSwizzleNV {
pub mut:
	x ViewportCoordinateSwizzleNV
	y ViewportCoordinateSwizzleNV
	z ViewportCoordinateSwizzleNV
	w ViewportCoordinateSwizzleNV
}

pub type PipelineViewportSwizzleStateCreateInfoNV = C.VkPipelineViewportSwizzleStateCreateInfoNV

@[typedef]
pub struct C.VkPipelineViewportSwizzleStateCreateInfoNV {
pub mut:
	sType             StructureType = StructureType.pipeline_viewport_swizzle_state_create_info_nv
	pNext             voidptr       = unsafe { nil }
	flags             PipelineViewportSwizzleStateCreateFlagsNV
	viewportCount     u32
	pViewportSwizzles &ViewportSwizzleNV
}

pub const ext_discard_rectangles_spec_version = 2
pub const ext_discard_rectangles_extension_name = 'VK_EXT_discard_rectangles'

pub enum DiscardRectangleModeEXT {
	inclusive_ext = 0
	exclusive_ext = 1
	max_enum_ext  = max_int
}

pub type PipelineDiscardRectangleStateCreateFlagsEXT = u32
pub type PhysicalDeviceDiscardRectanglePropertiesEXT = C.VkPhysicalDeviceDiscardRectanglePropertiesEXT

@[typedef]
pub struct C.VkPhysicalDeviceDiscardRectanglePropertiesEXT {
pub mut:
	sType                StructureType = StructureType.physical_device_discard_rectangle_properties_ext
	pNext                voidptr       = unsafe { nil }
	maxDiscardRectangles u32
}

pub type PipelineDiscardRectangleStateCreateInfoEXT = C.VkPipelineDiscardRectangleStateCreateInfoEXT

@[typedef]
pub struct C.VkPipelineDiscardRectangleStateCreateInfoEXT {
pub mut:
	sType                 StructureType = StructureType.pipeline_discard_rectangle_state_create_info_ext
	pNext                 voidptr       = unsafe { nil }
	flags                 PipelineDiscardRectangleStateCreateFlagsEXT
	discardRectangleMode  DiscardRectangleModeEXT
	discardRectangleCount u32
	pDiscardRectangles    &Rect2D
}

fn C.vkCmdSetDiscardRectangleEXT(C.VkCommandBuffer, u32, u32, &Rect2D)

pub type PFN_vkCmdSetDiscardRectangleEXT = fn (C.VkCommandBuffer, u32, u32, &Rect2D)

@[inline]
pub fn cmd_set_discard_rectangle_ext(command_buffer C.VkCommandBuffer,
	first_discard_rectangle u32,
	discard_rectangle_count u32,
	p_discard_rectangles &Rect2D) {
	C.vkCmdSetDiscardRectangleEXT(command_buffer, first_discard_rectangle, discard_rectangle_count,
		p_discard_rectangles)
}

fn C.vkCmdSetDiscardRectangleEnableEXT(C.VkCommandBuffer, Bool32)

pub type PFN_vkCmdSetDiscardRectangleEnableEXT = fn (C.VkCommandBuffer, Bool32)

@[inline]
pub fn cmd_set_discard_rectangle_enable_ext(command_buffer C.VkCommandBuffer,
	discard_rectangle_enable Bool32) {
	C.vkCmdSetDiscardRectangleEnableEXT(command_buffer, discard_rectangle_enable)
}

fn C.vkCmdSetDiscardRectangleModeEXT(C.VkCommandBuffer, DiscardRectangleModeEXT)

pub type PFN_vkCmdSetDiscardRectangleModeEXT = fn (C.VkCommandBuffer, DiscardRectangleModeEXT)

@[inline]
pub fn cmd_set_discard_rectangle_mode_ext(command_buffer C.VkCommandBuffer,
	discard_rectangle_mode DiscardRectangleModeEXT) {
	C.vkCmdSetDiscardRectangleModeEXT(command_buffer, discard_rectangle_mode)
}

pub const ext_conservative_rasterization_spec_version = 1
pub const ext_conservative_rasterization_extension_name = 'VK_EXT_conservative_rasterization'

pub enum ConservativeRasterizationModeEXT {
	disabled_ext      = 0
	overestimate_ext  = 1
	underestimate_ext = 2
	max_enum_ext      = max_int
}

pub type PipelineRasterizationConservativeStateCreateFlagsEXT = u32
pub type PhysicalDeviceConservativeRasterizationPropertiesEXT = C.VkPhysicalDeviceConservativeRasterizationPropertiesEXT

@[typedef]
pub struct C.VkPhysicalDeviceConservativeRasterizationPropertiesEXT {
pub mut:
	sType                                       StructureType = StructureType.physical_device_conservative_rasterization_properties_ext
	pNext                                       voidptr       = unsafe { nil }
	primitiveOverestimationSize                 f32
	maxExtraPrimitiveOverestimationSize         f32
	extraPrimitiveOverestimationSizeGranularity f32
	primitiveUnderestimation                    Bool32
	conservativePointAndLineRasterization       Bool32
	degenerateTrianglesRasterized               Bool32
	degenerateLinesRasterized                   Bool32
	fullyCoveredFragmentShaderInputVariable     Bool32
	conservativeRasterizationPostDepthCoverage  Bool32
}

pub type PipelineRasterizationConservativeStateCreateInfoEXT = C.VkPipelineRasterizationConservativeStateCreateInfoEXT

@[typedef]
pub struct C.VkPipelineRasterizationConservativeStateCreateInfoEXT {
pub mut:
	sType                            StructureType = StructureType.pipeline_rasterization_conservative_state_create_info_ext
	pNext                            voidptr       = unsafe { nil }
	flags                            PipelineRasterizationConservativeStateCreateFlagsEXT
	conservativeRasterizationMode    ConservativeRasterizationModeEXT
	extraPrimitiveOverestimationSize f32
}

pub const ext_depth_clip_enable_spec_version = 1
pub const ext_depth_clip_enable_extension_name = 'VK_EXT_depth_clip_enable'

pub type PipelineRasterizationDepthClipStateCreateFlagsEXT = u32
pub type PhysicalDeviceDepthClipEnableFeaturesEXT = C.VkPhysicalDeviceDepthClipEnableFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceDepthClipEnableFeaturesEXT {
pub mut:
	sType           StructureType = StructureType.physical_device_depth_clip_enable_features_ext
	pNext           voidptr       = unsafe { nil }
	depthClipEnable Bool32
}

pub type PipelineRasterizationDepthClipStateCreateInfoEXT = C.VkPipelineRasterizationDepthClipStateCreateInfoEXT

@[typedef]
pub struct C.VkPipelineRasterizationDepthClipStateCreateInfoEXT {
pub mut:
	sType           StructureType = StructureType.pipeline_rasterization_depth_clip_state_create_info_ext
	pNext           voidptr       = unsafe { nil }
	flags           PipelineRasterizationDepthClipStateCreateFlagsEXT
	depthClipEnable Bool32
}

pub const ext_swapchain_color_space_spec_version = 4
pub const ext_swapchain_color_space_extension_name = 'VK_EXT_swapchain_colorspace'

pub const ext_hdr_metadata_spec_version = 2
pub const ext_hdr_metadata_extension_name = 'VK_EXT_hdr_metadata'

pub type XYColorEXT = C.VkXYColorEXT

@[typedef]
pub struct C.VkXYColorEXT {
pub mut:
	x f32
	y f32
}

pub type HdrMetadataEXT = C.VkHdrMetadataEXT

@[typedef]
pub struct C.VkHdrMetadataEXT {
pub mut:
	sType                     StructureType = StructureType.hdr_metadata_ext
	pNext                     voidptr       = unsafe { nil }
	displayPrimaryRed         XYColorEXT
	displayPrimaryGreen       XYColorEXT
	displayPrimaryBlue        XYColorEXT
	whitePoint                XYColorEXT
	maxLuminance              f32
	minLuminance              f32
	maxContentLightLevel      f32
	maxFrameAverageLightLevel f32
}

fn C.vkSetHdrMetadataEXT(C.VkDevice, u32, C.VkSwapchainKHR, &HdrMetadataEXT)

pub type PFN_vkSetHdrMetadataEXT = fn (C.VkDevice, u32, C.VkSwapchainKHR, &HdrMetadataEXT)

@[inline]
pub fn set_hdr_metadata_ext(device C.VkDevice,
	swapchain_count u32,
	p_swapchains C.VkSwapchainKHR,
	p_metadata &HdrMetadataEXT) {
	C.vkSetHdrMetadataEXT(device, swapchain_count, p_swapchains, p_metadata)
}

pub const img_relaxed_line_rasterization_spec_version = 1
pub const img_relaxed_line_rasterization_extension_name = 'VK_IMG_relaxed_line_rasterization'

pub type PhysicalDeviceRelaxedLineRasterizationFeaturesIMG = C.VkPhysicalDeviceRelaxedLineRasterizationFeaturesIMG

@[typedef]
pub struct C.VkPhysicalDeviceRelaxedLineRasterizationFeaturesIMG {
pub mut:
	sType                    StructureType = StructureType.physical_device_relaxed_line_rasterization_features_img
	pNext                    voidptr       = unsafe { nil }
	relaxedLineRasterization Bool32
}

pub const ext_external_memory_dma_buf_spec_version = 1
pub const ext_external_memory_dma_buf_extension_name = 'VK_EXT_external_memory_dma_buf'

pub const ext_queue_family_foreign_spec_version = 1
pub const ext_queue_family_foreign_extension_name = 'VK_EXT_queue_family_foreign'
pub const queue_family_foreign_ext = ~u32(2)

pub type C.VkDebugUtilsMessengerEXT = voidptr

pub const ext_debug_utils_spec_version = 2
pub const ext_debug_utils_extension_name = 'VK_EXT_debug_utils'

pub type DebugUtilsMessengerCallbackDataFlagsEXT = u32

pub enum DebugUtilsMessageSeverityFlagBitsEXT {
	verbose_bit_ext = int(0x00000001)
	info_bit_ext    = int(0x00000010)
	warning_bit_ext = int(0x00000100)
	error_bit_ext   = int(0x00001000)
	max_enum_ext    = max_int
}

pub enum DebugUtilsMessageTypeFlagBitsEXT {
	general_bit_ext                = int(0x00000001)
	validation_bit_ext             = int(0x00000002)
	performance_bit_ext            = int(0x00000004)
	device_address_binding_bit_ext = int(0x00000008)
	max_enum_ext                   = max_int
}

pub type DebugUtilsMessageTypeFlagsEXT = u32
pub type DebugUtilsMessageSeverityFlagsEXT = u32
pub type DebugUtilsMessengerCreateFlagsEXT = u32
pub type DebugUtilsLabelEXT = C.VkDebugUtilsLabelEXT

@[typedef]
pub struct C.VkDebugUtilsLabelEXT {
pub mut:
	sType      StructureType = StructureType.debug_utils_label_ext
	pNext      voidptr       = unsafe { nil }
	pLabelName &char
	color      [4]f32
}

pub type DebugUtilsObjectNameInfoEXT = C.VkDebugUtilsObjectNameInfoEXT

@[typedef]
pub struct C.VkDebugUtilsObjectNameInfoEXT {
pub mut:
	sType        StructureType = StructureType.debug_utils_object_name_info_ext
	pNext        voidptr       = unsafe { nil }
	objectType   ObjectType
	objectHandle u64
	pObjectName  &char
}

pub type DebugUtilsMessengerCallbackDataEXT = C.VkDebugUtilsMessengerCallbackDataEXT

@[typedef]
pub struct C.VkDebugUtilsMessengerCallbackDataEXT {
pub mut:
	sType            StructureType = StructureType.debug_utils_messenger_callback_data_ext
	pNext            voidptr       = unsafe { nil }
	flags            DebugUtilsMessengerCallbackDataFlagsEXT
	pMessageIdName   &char
	messageIdNumber  i32
	pMessage         &char
	queueLabelCount  u32
	pQueueLabels     &DebugUtilsLabelEXT
	cmdBufLabelCount u32
	pCmdBufLabels    &DebugUtilsLabelEXT
	objectCount      u32
	pObjects         &DebugUtilsObjectNameInfoEXT
}

pub type PFN_vkDebugUtilsMessengerCallbackEXT = fn (messageSeverity DebugUtilsMessageSeverityFlagBitsEXT, messageTypes DebugUtilsMessageTypeFlagsEXT, pCallbackData &DebugUtilsMessengerCallbackDataEXT, pUserData voidptr)

pub type DebugUtilsMessengerCreateInfoEXT = C.VkDebugUtilsMessengerCreateInfoEXT

@[typedef]
pub struct C.VkDebugUtilsMessengerCreateInfoEXT {
pub mut:
	sType           StructureType = StructureType.debug_utils_messenger_create_info_ext
	pNext           voidptr       = unsafe { nil }
	flags           DebugUtilsMessengerCreateFlagsEXT
	messageSeverity DebugUtilsMessageSeverityFlagsEXT
	messageType     DebugUtilsMessageTypeFlagsEXT
	pfnUserCallback PFN_vkDebugUtilsMessengerCallbackEXT = unsafe { nil }
	pUserData       voidptr = unsafe { nil }
}

pub type DebugUtilsObjectTagInfoEXT = C.VkDebugUtilsObjectTagInfoEXT

@[typedef]
pub struct C.VkDebugUtilsObjectTagInfoEXT {
pub mut:
	sType        StructureType = StructureType.debug_utils_object_tag_info_ext
	pNext        voidptr       = unsafe { nil }
	objectType   ObjectType
	objectHandle u64
	tagName      u64
	tagSize      usize
	pTag         voidptr
}

fn C.vkSetDebugUtilsObjectNameEXT(C.VkDevice, &DebugUtilsObjectNameInfoEXT) Result

pub type PFN_vkSetDebugUtilsObjectNameEXT = fn (C.VkDevice, &DebugUtilsObjectNameInfoEXT) Result

@[inline]
pub fn set_debug_utils_object_name_ext(device C.VkDevice,
	p_name_info &DebugUtilsObjectNameInfoEXT) Result {
	return C.vkSetDebugUtilsObjectNameEXT(device, p_name_info)
}

fn C.vkSetDebugUtilsObjectTagEXT(C.VkDevice, &DebugUtilsObjectTagInfoEXT) Result

pub type PFN_vkSetDebugUtilsObjectTagEXT = fn (C.VkDevice, &DebugUtilsObjectTagInfoEXT) Result

@[inline]
pub fn set_debug_utils_object_tag_ext(device C.VkDevice,
	p_tag_info &DebugUtilsObjectTagInfoEXT) Result {
	return C.vkSetDebugUtilsObjectTagEXT(device, p_tag_info)
}

fn C.vkQueueBeginDebugUtilsLabelEXT(C.VkQueue, &DebugUtilsLabelEXT)

pub type PFN_vkQueueBeginDebugUtilsLabelEXT = fn (C.VkQueue, &DebugUtilsLabelEXT)

@[inline]
pub fn queue_begin_debug_utils_label_ext(queue C.VkQueue,
	p_label_info &DebugUtilsLabelEXT) {
	C.vkQueueBeginDebugUtilsLabelEXT(queue, p_label_info)
}

fn C.vkQueueEndDebugUtilsLabelEXT(C.VkQueue)

pub type PFN_vkQueueEndDebugUtilsLabelEXT = fn (C.VkQueue)

@[inline]
pub fn queue_end_debug_utils_label_ext(queue C.VkQueue) {
	C.vkQueueEndDebugUtilsLabelEXT(queue)
}

fn C.vkQueueInsertDebugUtilsLabelEXT(C.VkQueue, &DebugUtilsLabelEXT)

pub type PFN_vkQueueInsertDebugUtilsLabelEXT = fn (C.VkQueue, &DebugUtilsLabelEXT)

@[inline]
pub fn queue_insert_debug_utils_label_ext(queue C.VkQueue,
	p_label_info &DebugUtilsLabelEXT) {
	C.vkQueueInsertDebugUtilsLabelEXT(queue, p_label_info)
}

fn C.vkCmdBeginDebugUtilsLabelEXT(C.VkCommandBuffer, &DebugUtilsLabelEXT)

pub type PFN_vkCmdBeginDebugUtilsLabelEXT = fn (C.VkCommandBuffer, &DebugUtilsLabelEXT)

@[inline]
pub fn cmd_begin_debug_utils_label_ext(command_buffer C.VkCommandBuffer,
	p_label_info &DebugUtilsLabelEXT) {
	C.vkCmdBeginDebugUtilsLabelEXT(command_buffer, p_label_info)
}

fn C.vkCmdEndDebugUtilsLabelEXT(C.VkCommandBuffer)

pub type PFN_vkCmdEndDebugUtilsLabelEXT = fn (C.VkCommandBuffer)

@[inline]
pub fn cmd_end_debug_utils_label_ext(command_buffer C.VkCommandBuffer) {
	C.vkCmdEndDebugUtilsLabelEXT(command_buffer)
}

fn C.vkCmdInsertDebugUtilsLabelEXT(C.VkCommandBuffer, &DebugUtilsLabelEXT)

pub type PFN_vkCmdInsertDebugUtilsLabelEXT = fn (C.VkCommandBuffer, &DebugUtilsLabelEXT)

@[inline]
pub fn cmd_insert_debug_utils_label_ext(command_buffer C.VkCommandBuffer,
	p_label_info &DebugUtilsLabelEXT) {
	C.vkCmdInsertDebugUtilsLabelEXT(command_buffer, p_label_info)
}

fn C.vkCreateDebugUtilsMessengerEXT(C.VkInstance, &DebugUtilsMessengerCreateInfoEXT, &AllocationCallbacks, C.VkDebugUtilsMessengerEXT) Result

pub type PFN_vkCreateDebugUtilsMessengerEXT = fn (C.VkInstance, &DebugUtilsMessengerCreateInfoEXT, &AllocationCallbacks, C.VkDebugUtilsMessengerEXT) Result

@[inline]
pub fn create_debug_utils_messenger_ext(instance C.VkInstance,
	p_create_info &DebugUtilsMessengerCreateInfoEXT,
	p_allocator &AllocationCallbacks,
	p_messenger C.VkDebugUtilsMessengerEXT) Result {
	return C.vkCreateDebugUtilsMessengerEXT(instance, p_create_info, p_allocator, p_messenger)
}

fn C.vkDestroyDebugUtilsMessengerEXT(C.VkInstance, C.VkDebugUtilsMessengerEXT, &AllocationCallbacks)

pub type PFN_vkDestroyDebugUtilsMessengerEXT = fn (C.VkInstance, C.VkDebugUtilsMessengerEXT, &AllocationCallbacks)

@[inline]
pub fn destroy_debug_utils_messenger_ext(instance C.VkInstance,
	messenger C.VkDebugUtilsMessengerEXT,
	p_allocator &AllocationCallbacks) {
	C.vkDestroyDebugUtilsMessengerEXT(instance, messenger, p_allocator)
}

fn C.vkSubmitDebugUtilsMessageEXT(C.VkInstance, DebugUtilsMessageSeverityFlagBitsEXT, DebugUtilsMessageTypeFlagsEXT, &DebugUtilsMessengerCallbackDataEXT)

pub type PFN_vkSubmitDebugUtilsMessageEXT = fn (C.VkInstance, DebugUtilsMessageSeverityFlagBitsEXT, DebugUtilsMessageTypeFlagsEXT, &DebugUtilsMessengerCallbackDataEXT)

@[inline]
pub fn submit_debug_utils_message_ext(instance C.VkInstance,
	message_severity DebugUtilsMessageSeverityFlagBitsEXT,
	message_types DebugUtilsMessageTypeFlagsEXT,
	p_callback_data &DebugUtilsMessengerCallbackDataEXT) {
	C.vkSubmitDebugUtilsMessageEXT(instance, message_severity, message_types, p_callback_data)
}

pub const ext_sampler_filter_minmax_spec_version = 2
pub const ext_sampler_filter_minmax_extension_name = 'VK_EXT_sampler_filter_minmax'

pub type SamplerReductionModeEXT = SamplerReductionMode

pub type SamplerReductionModeCreateInfoEXT = C.VkSamplerReductionModeCreateInfo

pub type PhysicalDeviceSamplerFilterMinmaxPropertiesEXT = C.VkPhysicalDeviceSamplerFilterMinmaxProperties

pub const amd_gpu_shader_int16_spec_version = 2
pub const amd_gpu_shader_int16_extension_name = 'VK_AMD_gpu_shader_int16'

pub const amd_mixed_attachment_samples_spec_version = 1
pub const amd_mixed_attachment_samples_extension_name = 'VK_AMD_mixed_attachment_samples'

pub const amd_shader_fragment_mask_spec_version = 1
pub const amd_shader_fragment_mask_extension_name = 'VK_AMD_shader_fragment_mask'

pub const ext_inline_uniform_block_spec_version = 1
pub const ext_inline_uniform_block_extension_name = 'VK_EXT_inline_uniform_block'

pub type PhysicalDeviceInlineUniformBlockFeaturesEXT = C.VkPhysicalDeviceInlineUniformBlockFeatures

pub type PhysicalDeviceInlineUniformBlockPropertiesEXT = C.VkPhysicalDeviceInlineUniformBlockProperties

pub type WriteDescriptorSetInlineUniformBlockEXT = C.VkWriteDescriptorSetInlineUniformBlock

pub type DescriptorPoolInlineUniformBlockCreateInfoEXT = C.VkDescriptorPoolInlineUniformBlockCreateInfo

pub const ext_shader_stencil_export_spec_version = 1
pub const ext_shader_stencil_export_extension_name = 'VK_EXT_shader_stencil_export'

pub const ext_sample_locations_spec_version = 1
pub const ext_sample_locations_extension_name = 'VK_EXT_sample_locations'

pub type SampleLocationEXT = C.VkSampleLocationEXT

@[typedef]
pub struct C.VkSampleLocationEXT {
pub mut:
	x f32
	y f32
}

pub type SampleLocationsInfoEXT = C.VkSampleLocationsInfoEXT

@[typedef]
pub struct C.VkSampleLocationsInfoEXT {
pub mut:
	sType                   StructureType = StructureType.sample_locations_info_ext
	pNext                   voidptr       = unsafe { nil }
	sampleLocationsPerPixel SampleCountFlagBits
	sampleLocationGridSize  Extent2D
	sampleLocationsCount    u32
	pSampleLocations        &SampleLocationEXT
}

pub type AttachmentSampleLocationsEXT = C.VkAttachmentSampleLocationsEXT

@[typedef]
pub struct C.VkAttachmentSampleLocationsEXT {
pub mut:
	attachmentIndex     u32
	sampleLocationsInfo SampleLocationsInfoEXT
}

pub type SubpassSampleLocationsEXT = C.VkSubpassSampleLocationsEXT

@[typedef]
pub struct C.VkSubpassSampleLocationsEXT {
pub mut:
	subpassIndex        u32
	sampleLocationsInfo SampleLocationsInfoEXT
}

pub type RenderPassSampleLocationsBeginInfoEXT = C.VkRenderPassSampleLocationsBeginInfoEXT

@[typedef]
pub struct C.VkRenderPassSampleLocationsBeginInfoEXT {
pub mut:
	sType                                 StructureType = StructureType.render_pass_sample_locations_begin_info_ext
	pNext                                 voidptr       = unsafe { nil }
	attachmentInitialSampleLocationsCount u32
	pAttachmentInitialSampleLocations     &AttachmentSampleLocationsEXT
	postSubpassSampleLocationsCount       u32
	pPostSubpassSampleLocations           &SubpassSampleLocationsEXT
}

pub type PipelineSampleLocationsStateCreateInfoEXT = C.VkPipelineSampleLocationsStateCreateInfoEXT

@[typedef]
pub struct C.VkPipelineSampleLocationsStateCreateInfoEXT {
pub mut:
	sType                 StructureType = StructureType.pipeline_sample_locations_state_create_info_ext
	pNext                 voidptr       = unsafe { nil }
	sampleLocationsEnable Bool32
	sampleLocationsInfo   SampleLocationsInfoEXT
}

pub type PhysicalDeviceSampleLocationsPropertiesEXT = C.VkPhysicalDeviceSampleLocationsPropertiesEXT

@[typedef]
pub struct C.VkPhysicalDeviceSampleLocationsPropertiesEXT {
pub mut:
	sType                         StructureType = StructureType.physical_device_sample_locations_properties_ext
	pNext                         voidptr       = unsafe { nil }
	sampleLocationSampleCounts    SampleCountFlags
	maxSampleLocationGridSize     Extent2D
	sampleLocationCoordinateRange [2]f32
	sampleLocationSubPixelBits    u32
	variableSampleLocations       Bool32
}

pub type MultisamplePropertiesEXT = C.VkMultisamplePropertiesEXT

@[typedef]
pub struct C.VkMultisamplePropertiesEXT {
pub mut:
	sType                     StructureType = StructureType.multisample_properties_ext
	pNext                     voidptr       = unsafe { nil }
	maxSampleLocationGridSize Extent2D
}

fn C.vkCmdSetSampleLocationsEXT(C.VkCommandBuffer, &SampleLocationsInfoEXT)

pub type PFN_vkCmdSetSampleLocationsEXT = fn (C.VkCommandBuffer, &SampleLocationsInfoEXT)

@[inline]
pub fn cmd_set_sample_locations_ext(command_buffer C.VkCommandBuffer,
	p_sample_locations_info &SampleLocationsInfoEXT) {
	C.vkCmdSetSampleLocationsEXT(command_buffer, p_sample_locations_info)
}

fn C.vkGetPhysicalDeviceMultisamplePropertiesEXT(C.VkPhysicalDevice, SampleCountFlagBits, &MultisamplePropertiesEXT)

pub type PFN_vkGetPhysicalDeviceMultisamplePropertiesEXT = fn (C.VkPhysicalDevice, SampleCountFlagBits, &MultisamplePropertiesEXT)

@[inline]
pub fn get_physical_device_multisample_properties_ext(physical_device C.VkPhysicalDevice,
	samples SampleCountFlagBits,
	p_multisample_properties &MultisamplePropertiesEXT) {
	C.vkGetPhysicalDeviceMultisamplePropertiesEXT(physical_device, samples, p_multisample_properties)
}

pub const ext_blend_operation_advanced_spec_version = 2
pub const ext_blend_operation_advanced_extension_name = 'VK_EXT_blend_operation_advanced'

pub enum BlendOverlapEXT {
	uncorrelated_ext = 0
	disjoint_ext     = 1
	conjoint_ext     = 2
	max_enum_ext     = max_int
}

pub type PhysicalDeviceBlendOperationAdvancedFeaturesEXT = C.VkPhysicalDeviceBlendOperationAdvancedFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceBlendOperationAdvancedFeaturesEXT {
pub mut:
	sType                           StructureType = StructureType.physical_device_blend_operation_advanced_features_ext
	pNext                           voidptr       = unsafe { nil }
	advancedBlendCoherentOperations Bool32
}

pub type PhysicalDeviceBlendOperationAdvancedPropertiesEXT = C.VkPhysicalDeviceBlendOperationAdvancedPropertiesEXT

@[typedef]
pub struct C.VkPhysicalDeviceBlendOperationAdvancedPropertiesEXT {
pub mut:
	sType                                 StructureType = StructureType.physical_device_blend_operation_advanced_properties_ext
	pNext                                 voidptr       = unsafe { nil }
	advancedBlendMaxColorAttachments      u32
	advancedBlendIndependentBlend         Bool32
	advancedBlendNonPremultipliedSrcColor Bool32
	advancedBlendNonPremultipliedDstColor Bool32
	advancedBlendCorrelatedOverlap        Bool32
	advancedBlendAllOperations            Bool32
}

pub type PipelineColorBlendAdvancedStateCreateInfoEXT = C.VkPipelineColorBlendAdvancedStateCreateInfoEXT

@[typedef]
pub struct C.VkPipelineColorBlendAdvancedStateCreateInfoEXT {
pub mut:
	sType            StructureType = StructureType.pipeline_color_blend_advanced_state_create_info_ext
	pNext            voidptr       = unsafe { nil }
	srcPremultiplied Bool32
	dstPremultiplied Bool32
	blendOverlap     BlendOverlapEXT
}

pub const nv_fragment_coverage_to_color_spec_version = 1
pub const nv_fragment_coverage_to_color_extension_name = 'VK_NV_fragment_coverage_to_color'

pub type PipelineCoverageToColorStateCreateFlagsNV = u32
pub type PipelineCoverageToColorStateCreateInfoNV = C.VkPipelineCoverageToColorStateCreateInfoNV

@[typedef]
pub struct C.VkPipelineCoverageToColorStateCreateInfoNV {
pub mut:
	sType                   StructureType = StructureType.pipeline_coverage_to_color_state_create_info_nv
	pNext                   voidptr       = unsafe { nil }
	flags                   PipelineCoverageToColorStateCreateFlagsNV
	coverageToColorEnable   Bool32
	coverageToColorLocation u32
}

pub const nv_framebuffer_mixed_samples_spec_version = 1
pub const nv_framebuffer_mixed_samples_extension_name = 'VK_NV_framebuffer_mixed_samples'

pub enum CoverageModulationModeNV {
	none_nv     = 0
	rgb_nv      = 1
	alpha_nv    = 2
	rgba_nv     = 3
	max_enum_nv = max_int
}

pub type PipelineCoverageModulationStateCreateFlagsNV = u32
pub type PipelineCoverageModulationStateCreateInfoNV = C.VkPipelineCoverageModulationStateCreateInfoNV

@[typedef]
pub struct C.VkPipelineCoverageModulationStateCreateInfoNV {
pub mut:
	sType                         StructureType = StructureType.pipeline_coverage_modulation_state_create_info_nv
	pNext                         voidptr       = unsafe { nil }
	flags                         PipelineCoverageModulationStateCreateFlagsNV
	coverageModulationMode        CoverageModulationModeNV
	coverageModulationTableEnable Bool32
	coverageModulationTableCount  u32
	pCoverageModulationTable      &f32
}

pub const nv_fill_rectangle_spec_version = 1
pub const nv_fill_rectangle_extension_name = 'VK_NV_fill_rectangle'

pub const nv_shader_sm_builtins_spec_version = 1
pub const nv_shader_sm_builtins_extension_name = 'VK_NV_shader_sm_builtins'

pub type PhysicalDeviceShaderSMBuiltinsPropertiesNV = C.VkPhysicalDeviceShaderSMBuiltinsPropertiesNV

@[typedef]
pub struct C.VkPhysicalDeviceShaderSMBuiltinsPropertiesNV {
pub mut:
	sType            StructureType = StructureType.physical_device_shader_sm_builtins_properties_nv
	pNext            voidptr       = unsafe { nil }
	shaderSMCount    u32
	shaderWarpsPerSM u32
}

pub type PhysicalDeviceShaderSMBuiltinsFeaturesNV = C.VkPhysicalDeviceShaderSMBuiltinsFeaturesNV

@[typedef]
pub struct C.VkPhysicalDeviceShaderSMBuiltinsFeaturesNV {
pub mut:
	sType            StructureType = StructureType.physical_device_shader_sm_builtins_features_nv
	pNext            voidptr       = unsafe { nil }
	shaderSMBuiltins Bool32
}

pub const ext_post_depth_coverage_spec_version = 1
pub const ext_post_depth_coverage_extension_name = 'VK_EXT_post_depth_coverage'

pub const ext_image_drm_format_modifier_spec_version = 2
pub const ext_image_drm_format_modifier_extension_name = 'VK_EXT_image_drm_format_modifier'

pub type DrmFormatModifierPropertiesEXT = C.VkDrmFormatModifierPropertiesEXT

@[typedef]
pub struct C.VkDrmFormatModifierPropertiesEXT {
pub mut:
	drmFormatModifier               u64
	drmFormatModifierPlaneCount     u32
	drmFormatModifierTilingFeatures FormatFeatureFlags
}

pub type DrmFormatModifierPropertiesListEXT = C.VkDrmFormatModifierPropertiesListEXT

@[typedef]
pub struct C.VkDrmFormatModifierPropertiesListEXT {
pub mut:
	sType                        StructureType = StructureType.drm_format_modifier_properties_list_ext
	pNext                        voidptr       = unsafe { nil }
	drmFormatModifierCount       u32
	pDrmFormatModifierProperties &DrmFormatModifierPropertiesEXT
}

pub type PhysicalDeviceImageDrmFormatModifierInfoEXT = C.VkPhysicalDeviceImageDrmFormatModifierInfoEXT

@[typedef]
pub struct C.VkPhysicalDeviceImageDrmFormatModifierInfoEXT {
pub mut:
	sType                 StructureType = StructureType.physical_device_image_drm_format_modifier_info_ext
	pNext                 voidptr       = unsafe { nil }
	drmFormatModifier     u64
	sharingMode           SharingMode
	queueFamilyIndexCount u32
	pQueueFamilyIndices   &u32
}

pub type ImageDrmFormatModifierListCreateInfoEXT = C.VkImageDrmFormatModifierListCreateInfoEXT

@[typedef]
pub struct C.VkImageDrmFormatModifierListCreateInfoEXT {
pub mut:
	sType                  StructureType = StructureType.image_drm_format_modifier_list_create_info_ext
	pNext                  voidptr       = unsafe { nil }
	drmFormatModifierCount u32
	pDrmFormatModifiers    &u64
}

pub type ImageDrmFormatModifierExplicitCreateInfoEXT = C.VkImageDrmFormatModifierExplicitCreateInfoEXT

@[typedef]
pub struct C.VkImageDrmFormatModifierExplicitCreateInfoEXT {
pub mut:
	sType                       StructureType = StructureType.image_drm_format_modifier_explicit_create_info_ext
	pNext                       voidptr       = unsafe { nil }
	drmFormatModifier           u64
	drmFormatModifierPlaneCount u32
	pPlaneLayouts               &SubresourceLayout
}

pub type ImageDrmFormatModifierPropertiesEXT = C.VkImageDrmFormatModifierPropertiesEXT

@[typedef]
pub struct C.VkImageDrmFormatModifierPropertiesEXT {
pub mut:
	sType             StructureType = StructureType.image_drm_format_modifier_properties_ext
	pNext             voidptr       = unsafe { nil }
	drmFormatModifier u64
}

pub type DrmFormatModifierProperties2EXT = C.VkDrmFormatModifierProperties2EXT

@[typedef]
pub struct C.VkDrmFormatModifierProperties2EXT {
pub mut:
	drmFormatModifier               u64
	drmFormatModifierPlaneCount     u32
	drmFormatModifierTilingFeatures FormatFeatureFlags2
}

pub type DrmFormatModifierPropertiesList2EXT = C.VkDrmFormatModifierPropertiesList2EXT

@[typedef]
pub struct C.VkDrmFormatModifierPropertiesList2EXT {
pub mut:
	sType                        StructureType = StructureType.drm_format_modifier_properties_list2_ext
	pNext                        voidptr       = unsafe { nil }
	drmFormatModifierCount       u32
	pDrmFormatModifierProperties &DrmFormatModifierProperties2EXT
}

fn C.vkGetImageDrmFormatModifierPropertiesEXT(C.VkDevice, C.VkImage, &ImageDrmFormatModifierPropertiesEXT) Result

pub type PFN_vkGetImageDrmFormatModifierPropertiesEXT = fn (C.VkDevice, C.VkImage, &ImageDrmFormatModifierPropertiesEXT) Result

@[inline]
pub fn get_image_drm_format_modifier_properties_ext(device C.VkDevice,
	image C.VkImage,
	p_properties &ImageDrmFormatModifierPropertiesEXT) Result {
	return C.vkGetImageDrmFormatModifierPropertiesEXT(device, image, p_properties)
}

pub type C.VkValidationCacheEXT = voidptr

pub const ext_validation_cache_spec_version = 1
pub const ext_validation_cache_extension_name = 'VK_EXT_validation_cache'

pub enum ValidationCacheHeaderVersionEXT {
	one_ext      = 1
	max_enum_ext = max_int
}

pub type ValidationCacheCreateFlagsEXT = u32
pub type ValidationCacheCreateInfoEXT = C.VkValidationCacheCreateInfoEXT

@[typedef]
pub struct C.VkValidationCacheCreateInfoEXT {
pub mut:
	sType           StructureType = StructureType.validation_cache_create_info_ext
	pNext           voidptr       = unsafe { nil }
	flags           ValidationCacheCreateFlagsEXT
	initialDataSize usize
	pInitialData    voidptr
}

pub type ShaderModuleValidationCacheCreateInfoEXT = C.VkShaderModuleValidationCacheCreateInfoEXT

@[typedef]
pub struct C.VkShaderModuleValidationCacheCreateInfoEXT {
pub mut:
	sType           StructureType = StructureType.shader_module_validation_cache_create_info_ext
	pNext           voidptr       = unsafe { nil }
	validationCache C.VkValidationCacheEXT
}

fn C.vkCreateValidationCacheEXT(C.VkDevice, &ValidationCacheCreateInfoEXT, &AllocationCallbacks, C.VkValidationCacheEXT) Result

pub type PFN_vkCreateValidationCacheEXT = fn (C.VkDevice, &ValidationCacheCreateInfoEXT, &AllocationCallbacks, C.VkValidationCacheEXT) Result

@[inline]
pub fn create_validation_cache_ext(device C.VkDevice,
	p_create_info &ValidationCacheCreateInfoEXT,
	p_allocator &AllocationCallbacks,
	p_validation_cache C.VkValidationCacheEXT) Result {
	return C.vkCreateValidationCacheEXT(device, p_create_info, p_allocator, p_validation_cache)
}

fn C.vkDestroyValidationCacheEXT(C.VkDevice, C.VkValidationCacheEXT, &AllocationCallbacks)

pub type PFN_vkDestroyValidationCacheEXT = fn (C.VkDevice, C.VkValidationCacheEXT, &AllocationCallbacks)

@[inline]
pub fn destroy_validation_cache_ext(device C.VkDevice,
	validation_cache C.VkValidationCacheEXT,
	p_allocator &AllocationCallbacks) {
	C.vkDestroyValidationCacheEXT(device, validation_cache, p_allocator)
}

fn C.vkMergeValidationCachesEXT(C.VkDevice, C.VkValidationCacheEXT, u32, C.VkValidationCacheEXT) Result

pub type PFN_vkMergeValidationCachesEXT = fn (C.VkDevice, C.VkValidationCacheEXT, u32, C.VkValidationCacheEXT) Result

@[inline]
pub fn merge_validation_caches_ext(device C.VkDevice,
	dst_cache C.VkValidationCacheEXT,
	src_cache_count u32,
	p_src_caches C.VkValidationCacheEXT) Result {
	return C.vkMergeValidationCachesEXT(device, dst_cache, src_cache_count, p_src_caches)
}

fn C.vkGetValidationCacheDataEXT(C.VkDevice, C.VkValidationCacheEXT, &usize, voidptr) Result

pub type PFN_vkGetValidationCacheDataEXT = fn (C.VkDevice, C.VkValidationCacheEXT, &usize, voidptr) Result

@[inline]
pub fn get_validation_cache_data_ext(device C.VkDevice,
	validation_cache C.VkValidationCacheEXT,
	p_data_size &usize,
	p_data voidptr) Result {
	return C.vkGetValidationCacheDataEXT(device, validation_cache, p_data_size, p_data)
}

pub const ext_descriptor_indexing_spec_version = 2
pub const ext_descriptor_indexing_extension_name = 'VK_EXT_descriptor_indexing'

pub type DescriptorBindingFlagBitsEXT = DescriptorBindingFlagBits

pub type DescriptorBindingFlagsEXT = u32
pub type DescriptorSetLayoutBindingFlagsCreateInfoEXT = C.VkDescriptorSetLayoutBindingFlagsCreateInfo

pub type PhysicalDeviceDescriptorIndexingFeaturesEXT = C.VkPhysicalDeviceDescriptorIndexingFeatures

pub type PhysicalDeviceDescriptorIndexingPropertiesEXT = C.VkPhysicalDeviceDescriptorIndexingProperties

pub type DescriptorSetVariableDescriptorCountAllocateInfoEXT = C.VkDescriptorSetVariableDescriptorCountAllocateInfo

pub type DescriptorSetVariableDescriptorCountLayoutSupportEXT = C.VkDescriptorSetVariableDescriptorCountLayoutSupport

pub const ext_shader_viewport_index_layer_spec_version = 1
pub const ext_shader_viewport_index_layer_extension_name = 'VK_EXT_shader_viewport_index_layer'

pub const nv_shading_rate_image_spec_version = 3
pub const nv_shading_rate_image_extension_name = 'VK_NV_shading_rate_image'

pub enum ShadingRatePaletteEntryNV {
	no_invocations_nv              = 0
	_16_invocations_per_pixel_nv   = 1
	_8_invocations_per_pixel_nv    = 2
	_4_invocations_per_pixel_nv    = 3
	_2_invocations_per_pixel_nv    = 4
	_1_invocation_per_pixel_nv     = 5
	_1_invocation_per2x1_pixels_nv = 6
	_1_invocation_per1x2_pixels_nv = 7
	_1_invocation_per2x2_pixels_nv = 8
	_1_invocation_per4x2_pixels_nv = 9
	_1_invocation_per2x4_pixels_nv = 10
	_1_invocation_per4x4_pixels_nv = 11
	max_enum_nv                    = max_int
}

pub enum CoarseSampleOrderTypeNV {
	default_nv      = 0
	custom_nv       = 1
	pixel_major_nv  = 2
	sample_major_nv = 3
	max_enum_nv     = max_int
}

pub type ShadingRatePaletteNV = C.VkShadingRatePaletteNV

@[typedef]
pub struct C.VkShadingRatePaletteNV {
pub mut:
	shadingRatePaletteEntryCount u32
	pShadingRatePaletteEntries   &ShadingRatePaletteEntryNV
}

pub type PipelineViewportShadingRateImageStateCreateInfoNV = C.VkPipelineViewportShadingRateImageStateCreateInfoNV

@[typedef]
pub struct C.VkPipelineViewportShadingRateImageStateCreateInfoNV {
pub mut:
	sType                  StructureType = StructureType.pipeline_viewport_shading_rate_image_state_create_info_nv
	pNext                  voidptr       = unsafe { nil }
	shadingRateImageEnable Bool32
	viewportCount          u32
	pShadingRatePalettes   &ShadingRatePaletteNV
}

pub type PhysicalDeviceShadingRateImageFeaturesNV = C.VkPhysicalDeviceShadingRateImageFeaturesNV

@[typedef]
pub struct C.VkPhysicalDeviceShadingRateImageFeaturesNV {
pub mut:
	sType                        StructureType = StructureType.physical_device_shading_rate_image_features_nv
	pNext                        voidptr       = unsafe { nil }
	shadingRateImage             Bool32
	shadingRateCoarseSampleOrder Bool32
}

pub type PhysicalDeviceShadingRateImagePropertiesNV = C.VkPhysicalDeviceShadingRateImagePropertiesNV

@[typedef]
pub struct C.VkPhysicalDeviceShadingRateImagePropertiesNV {
pub mut:
	sType                       StructureType = StructureType.physical_device_shading_rate_image_properties_nv
	pNext                       voidptr       = unsafe { nil }
	shadingRateTexelSize        Extent2D
	shadingRatePaletteSize      u32
	shadingRateMaxCoarseSamples u32
}

pub type CoarseSampleLocationNV = C.VkCoarseSampleLocationNV

@[typedef]
pub struct C.VkCoarseSampleLocationNV {
pub mut:
	pixelX u32
	pixelY u32
	sample u32
}

pub type CoarseSampleOrderCustomNV = C.VkCoarseSampleOrderCustomNV

@[typedef]
pub struct C.VkCoarseSampleOrderCustomNV {
pub mut:
	shadingRate         ShadingRatePaletteEntryNV
	sampleCount         u32
	sampleLocationCount u32
	pSampleLocations    &CoarseSampleLocationNV
}

pub type PipelineViewportCoarseSampleOrderStateCreateInfoNV = C.VkPipelineViewportCoarseSampleOrderStateCreateInfoNV

@[typedef]
pub struct C.VkPipelineViewportCoarseSampleOrderStateCreateInfoNV {
pub mut:
	sType                  StructureType = StructureType.pipeline_viewport_coarse_sample_order_state_create_info_nv
	pNext                  voidptr       = unsafe { nil }
	sampleOrderType        CoarseSampleOrderTypeNV
	customSampleOrderCount u32
	pCustomSampleOrders    &CoarseSampleOrderCustomNV
}

fn C.vkCmdBindShadingRateImageNV(C.VkCommandBuffer, C.VkImageView, ImageLayout)

pub type PFN_vkCmdBindShadingRateImageNV = fn (C.VkCommandBuffer, C.VkImageView, ImageLayout)

@[inline]
pub fn cmd_bind_shading_rate_image_nv(command_buffer C.VkCommandBuffer,
	image_view C.VkImageView,
	image_layout ImageLayout) {
	C.vkCmdBindShadingRateImageNV(command_buffer, image_view, image_layout)
}

fn C.vkCmdSetViewportShadingRatePaletteNV(C.VkCommandBuffer, u32, u32, &ShadingRatePaletteNV)

pub type PFN_vkCmdSetViewportShadingRatePaletteNV = fn (C.VkCommandBuffer, u32, u32, &ShadingRatePaletteNV)

@[inline]
pub fn cmd_set_viewport_shading_rate_palette_nv(command_buffer C.VkCommandBuffer,
	first_viewport u32,
	viewport_count u32,
	p_shading_rate_palettes &ShadingRatePaletteNV) {
	C.vkCmdSetViewportShadingRatePaletteNV(command_buffer, first_viewport, viewport_count,
		p_shading_rate_palettes)
}

fn C.vkCmdSetCoarseSampleOrderNV(C.VkCommandBuffer, CoarseSampleOrderTypeNV, u32, &CoarseSampleOrderCustomNV)

pub type PFN_vkCmdSetCoarseSampleOrderNV = fn (C.VkCommandBuffer, CoarseSampleOrderTypeNV, u32, &CoarseSampleOrderCustomNV)

@[inline]
pub fn cmd_set_coarse_sample_order_nv(command_buffer C.VkCommandBuffer,
	sample_order_type CoarseSampleOrderTypeNV,
	custom_sample_order_count u32,
	p_custom_sample_orders &CoarseSampleOrderCustomNV) {
	C.vkCmdSetCoarseSampleOrderNV(command_buffer, sample_order_type, custom_sample_order_count,
		p_custom_sample_orders)
}

pub type C.VkAccelerationStructureNV = voidptr

pub const nv_ray_tracing_spec_version = 3
pub const nv_ray_tracing_extension_name = 'VK_NV_ray_tracing'
pub const shader_unused_khr = ~u32(0)
pub const shader_unused_nv = shader_unused_khr

pub enum RayTracingShaderGroupTypeKHR {
	general_khr              = 0
	triangles_hit_group_khr  = 1
	procedural_hit_group_khr = 2
	max_enum_khr             = max_int
}

pub type RayTracingShaderGroupTypeNV = RayTracingShaderGroupTypeKHR

pub enum GeometryTypeKHR {
	triangles_khr = 0
	aabbs_khr     = 1
	instances_khr = 2
	max_enum_khr  = max_int
}

pub type GeometryTypeNV = GeometryTypeKHR

pub enum AccelerationStructureTypeKHR {
	top_level_khr    = 0
	bottom_level_khr = 1
	generic_khr      = 2
	max_enum_khr     = max_int
}

pub type AccelerationStructureTypeNV = AccelerationStructureTypeKHR

pub enum CopyAccelerationStructureModeKHR {
	clone_khr       = 0
	compact_khr     = 1
	serialize_khr   = 2
	deserialize_khr = 3
	max_enum_khr    = max_int
}

pub type CopyAccelerationStructureModeNV = CopyAccelerationStructureModeKHR

pub enum AccelerationStructureMemoryRequirementsTypeNV {
	object_nv         = 0
	build_scratch_nv  = 1
	update_scratch_nv = 2
	max_enum_nv       = max_int
}

pub enum GeometryFlagBitsKHR {
	opaque_bit_khr                          = int(0x00000001)
	no_duplicate_any_hit_invocation_bit_khr = int(0x00000002)
	max_enum_khr                            = max_int
}

pub type GeometryFlagsKHR = u32
pub type GeometryFlagsNV = u32
pub type GeometryFlagBitsNV = GeometryFlagBitsKHR

pub enum GeometryInstanceFlagBitsKHR {
	triangle_facing_cull_disable_bit_khr = int(0x00000001)
	triangle_flip_facing_bit_khr         = int(0x00000002)
	orce_opaque_bit_khr                  = int(0x00000004)
	orce_no_opaque_bit_khr               = int(0x00000008)
	orce_opacity_micromap2_state_ext     = int(0x00000010)
	disable_opacity_micromaps_ext        = int(0x00000020)
	max_enum_khr                         = max_int
}

pub type GeometryInstanceFlagsKHR = u32
pub type GeometryInstanceFlagsNV = u32
pub type GeometryInstanceFlagBitsNV = GeometryInstanceFlagBitsKHR

pub enum BuildAccelerationStructureFlagBitsKHR {
	allow_update_bit_khr                   = int(0x00000001)
	allow_compaction_bit_khr               = int(0x00000002)
	prefer_fast_trace_bit_khr              = int(0x00000004)
	prefer_fast_build_bit_khr              = int(0x00000008)
	low_memory_bit_khr                     = int(0x00000010)
	motion_bit_nv                          = int(0x00000020)
	allow_opacity_micromap_update_ext      = int(0x00000040)
	allow_disable_opacity_micromaps_ext    = int(0x00000080)
	allow_opacity_micromap_data_update_ext = int(0x00000100)
	allow_data_access_khr                  = int(0x00000800)
	max_enum_khr                           = max_int
}

pub type BuildAccelerationStructureFlagsKHR = u32
pub type BuildAccelerationStructureFlagsNV = u32
pub type BuildAccelerationStructureFlagBitsNV = BuildAccelerationStructureFlagBitsKHR

pub type RayTracingShaderGroupCreateInfoNV = C.VkRayTracingShaderGroupCreateInfoNV

@[typedef]
pub struct C.VkRayTracingShaderGroupCreateInfoNV {
pub mut:
	sType              StructureType = StructureType.ray_tracing_shader_group_create_info_nv
	pNext              voidptr       = unsafe { nil }
	type               RayTracingShaderGroupTypeKHR
	generalShader      u32
	closestHitShader   u32
	anyHitShader       u32
	intersectionShader u32
}

pub type RayTracingPipelineCreateInfoNV = C.VkRayTracingPipelineCreateInfoNV

@[typedef]
pub struct C.VkRayTracingPipelineCreateInfoNV {
pub mut:
	sType              StructureType = StructureType.ray_tracing_pipeline_create_info_nv
	pNext              voidptr       = unsafe { nil }
	flags              PipelineCreateFlags
	stageCount         u32
	pStages            &PipelineShaderStageCreateInfo
	groupCount         u32
	pGroups            &RayTracingShaderGroupCreateInfoNV
	maxRecursionDepth  u32
	layout             C.VkPipelineLayout
	basePipelineHandle C.VkPipeline
	basePipelineIndex  i32
}

pub type GeometryTrianglesNV = C.VkGeometryTrianglesNV

@[typedef]
pub struct C.VkGeometryTrianglesNV {
pub mut:
	sType           StructureType = StructureType.geometry_triangles_nv
	pNext           voidptr       = unsafe { nil }
	vertexData      C.VkBuffer
	vertexOffset    DeviceSize
	vertexCount     u32
	vertexStride    DeviceSize
	vertexFormat    Format
	indexData       C.VkBuffer
	indexOffset     DeviceSize
	indexCount      u32
	indexType       IndexType
	transformData   C.VkBuffer
	transformOffset DeviceSize
}

pub type GeometryAABBNV = C.VkGeometryAABBNV

@[typedef]
pub struct C.VkGeometryAABBNV {
pub mut:
	sType    StructureType
	pNext    voidptr = unsafe { nil }
	aabbData C.VkBuffer
	numAABBs u32
	stride   u32
	offset   DeviceSize
}

pub type GeometryDataNV = C.VkGeometryDataNV

@[typedef]
pub struct C.VkGeometryDataNV {
pub mut:
	triangles GeometryTrianglesNV
	aabbs     GeometryAABBNV
}

pub type GeometryNV = C.VkGeometryNV

@[typedef]
pub struct C.VkGeometryNV {
pub mut:
	sType        StructureType = StructureType.geometry_nv
	pNext        voidptr       = unsafe { nil }
	geometryType GeometryTypeKHR
	geometry     GeometryDataNV
	flags        GeometryFlagsKHR
}

pub type AccelerationStructureInfoNV = C.VkAccelerationStructureInfoNV

@[typedef]
pub struct C.VkAccelerationStructureInfoNV {
pub mut:
	sType         StructureType = StructureType.acceleration_structure_info_nv
	pNext         voidptr       = unsafe { nil }
	type          AccelerationStructureTypeNV
	flags         BuildAccelerationStructureFlagsNV
	instanceCount u32
	geometryCount u32
	pGeometries   &GeometryNV
}

pub type AccelerationStructureCreateInfoNV = C.VkAccelerationStructureCreateInfoNV

@[typedef]
pub struct C.VkAccelerationStructureCreateInfoNV {
pub mut:
	sType         StructureType = StructureType.acceleration_structure_create_info_nv
	pNext         voidptr       = unsafe { nil }
	compactedSize DeviceSize
	info          AccelerationStructureInfoNV
}

pub type BindAccelerationStructureMemoryInfoNV = C.VkBindAccelerationStructureMemoryInfoNV

@[typedef]
pub struct C.VkBindAccelerationStructureMemoryInfoNV {
pub mut:
	sType                 StructureType = StructureType.bind_acceleration_structure_memory_info_nv
	pNext                 voidptr       = unsafe { nil }
	accelerationStructure C.VkAccelerationStructureNV
	memory                C.VkDeviceMemory
	memoryOffset          DeviceSize
	deviceIndexCount      u32
	pDeviceIndices        &u32
}

pub type WriteDescriptorSetAccelerationStructureNV = C.VkWriteDescriptorSetAccelerationStructureNV

@[typedef]
pub struct C.VkWriteDescriptorSetAccelerationStructureNV {
pub mut:
	sType                      StructureType = StructureType.write_descriptor_set_acceleration_structure_nv
	pNext                      voidptr       = unsafe { nil }
	accelerationStructureCount u32
	pAccelerationStructures    C.VkAccelerationStructureNV
}

pub type AccelerationStructureMemoryRequirementsInfoNV = C.VkAccelerationStructureMemoryRequirementsInfoNV

@[typedef]
pub struct C.VkAccelerationStructureMemoryRequirementsInfoNV {
pub mut:
	sType                 StructureType = StructureType.acceleration_structure_memory_requirements_info_nv
	pNext                 voidptr       = unsafe { nil }
	type                  AccelerationStructureMemoryRequirementsTypeNV
	accelerationStructure C.VkAccelerationStructureNV
}

pub type PhysicalDeviceRayTracingPropertiesNV = C.VkPhysicalDeviceRayTracingPropertiesNV

@[typedef]
pub struct C.VkPhysicalDeviceRayTracingPropertiesNV {
pub mut:
	sType                                  StructureType = StructureType.physical_device_ray_tracing_properties_nv
	pNext                                  voidptr       = unsafe { nil }
	shaderGroupHandleSize                  u32
	maxRecursionDepth                      u32
	maxShaderGroupStride                   u32
	shaderGroupBaseAlignment               u32
	maxGeometryCount                       u64
	maxInstanceCount                       u64
	maxTriangleCount                       u64
	maxDescriptorSetAccelerationStructures u32
}

pub type TransformMatrixKHR = C.VkTransformMatrixKHR

@[typedef]
pub struct C.VkTransformMatrixKHR {
pub mut:
	matrix [4][3]f32
}

pub type TransformMatrixNV = C.VkTransformMatrixKHR

pub type AabbPositionsKHR = C.VkAabbPositionsKHR

@[typedef]
pub struct C.VkAabbPositionsKHR {
pub mut:
	minX f32
	minY f32
	minZ f32
	maxX f32
	maxY f32
	maxZ f32
}

pub type AabbPositionsNV = C.VkAabbPositionsKHR

pub type AccelerationStructureInstanceKHR = C.VkAccelerationStructureInstanceKHR

@[typedef]
pub struct C.VkAccelerationStructureInstanceKHR {
pub mut:
	transform                              TransformMatrixKHR
	instanceCustomIndex                    u32
	mask                                   u32
	instanceShaderBindingTableRecordOffset u32
	flags                                  GeometryInstanceFlagsKHR
	accelerationStructureReference         u64
}

pub type AccelerationStructureInstanceNV = C.VkAccelerationStructureInstanceKHR

fn C.vkCreateAccelerationStructureNV(C.VkDevice, &AccelerationStructureCreateInfoNV, &AllocationCallbacks, C.VkAccelerationStructureNV) Result

pub type PFN_vkCreateAccelerationStructureNV = fn (C.VkDevice, &AccelerationStructureCreateInfoNV, &AllocationCallbacks, C.VkAccelerationStructureNV) Result

@[inline]
pub fn create_acceleration_structure_nv(device C.VkDevice,
	p_create_info &AccelerationStructureCreateInfoNV,
	p_allocator &AllocationCallbacks,
	p_acceleration_structure C.VkAccelerationStructureNV) Result {
	return C.vkCreateAccelerationStructureNV(device, p_create_info, p_allocator, p_acceleration_structure)
}

fn C.vkDestroyAccelerationStructureNV(C.VkDevice, C.VkAccelerationStructureNV, &AllocationCallbacks)

pub type PFN_vkDestroyAccelerationStructureNV = fn (C.VkDevice, C.VkAccelerationStructureNV, &AllocationCallbacks)

@[inline]
pub fn destroy_acceleration_structure_nv(device C.VkDevice,
	acceleration_structure C.VkAccelerationStructureNV,
	p_allocator &AllocationCallbacks) {
	C.vkDestroyAccelerationStructureNV(device, acceleration_structure, p_allocator)
}

fn C.vkGetAccelerationStructureMemoryRequirementsNV(C.VkDevice, &AccelerationStructureMemoryRequirementsInfoNV, &MemoryRequirements2KHR)

pub type PFN_vkGetAccelerationStructureMemoryRequirementsNV = fn (C.VkDevice, &AccelerationStructureMemoryRequirementsInfoNV, &MemoryRequirements2KHR)

@[inline]
pub fn get_acceleration_structure_memory_requirements_nv(device C.VkDevice,
	p_info &AccelerationStructureMemoryRequirementsInfoNV,
	p_memory_requirements &MemoryRequirements2KHR) {
	C.vkGetAccelerationStructureMemoryRequirementsNV(device, p_info, p_memory_requirements)
}

fn C.vkBindAccelerationStructureMemoryNV(C.VkDevice, u32, &BindAccelerationStructureMemoryInfoNV) Result

pub type PFN_vkBindAccelerationStructureMemoryNV = fn (C.VkDevice, u32, &BindAccelerationStructureMemoryInfoNV) Result

@[inline]
pub fn bind_acceleration_structure_memory_nv(device C.VkDevice,
	bind_info_count u32,
	p_bind_infos &BindAccelerationStructureMemoryInfoNV) Result {
	return C.vkBindAccelerationStructureMemoryNV(device, bind_info_count, p_bind_infos)
}

fn C.vkCmdBuildAccelerationStructureNV(C.VkCommandBuffer, &AccelerationStructureInfoNV, C.VkBuffer, DeviceSize, Bool32, C.VkAccelerationStructureNV, C.VkAccelerationStructureNV, C.VkBuffer, DeviceSize)

pub type PFN_vkCmdBuildAccelerationStructureNV = fn (C.VkCommandBuffer, &AccelerationStructureInfoNV, C.VkBuffer, DeviceSize, Bool32, C.VkAccelerationStructureNV, C.VkAccelerationStructureNV, C.VkBuffer, DeviceSize)

@[inline]
pub fn cmd_build_acceleration_structure_nv(command_buffer C.VkCommandBuffer,
	p_info &AccelerationStructureInfoNV,
	instance_data C.VkBuffer,
	instance_offset DeviceSize,
	update Bool32,
	dst C.VkAccelerationStructureNV,
	src C.VkAccelerationStructureNV,
	scratch C.VkBuffer,
	scratch_offset DeviceSize) {
	C.vkCmdBuildAccelerationStructureNV(command_buffer, p_info, instance_data, instance_offset,
		update, dst, src, scratch, scratch_offset)
}

fn C.vkCmdCopyAccelerationStructureNV(C.VkCommandBuffer, C.VkAccelerationStructureNV, C.VkAccelerationStructureNV, CopyAccelerationStructureModeKHR)

pub type PFN_vkCmdCopyAccelerationStructureNV = fn (C.VkCommandBuffer, C.VkAccelerationStructureNV, C.VkAccelerationStructureNV, CopyAccelerationStructureModeKHR)

@[inline]
pub fn cmd_copy_acceleration_structure_nv(command_buffer C.VkCommandBuffer,
	dst C.VkAccelerationStructureNV,
	src C.VkAccelerationStructureNV,
	mode CopyAccelerationStructureModeKHR) {
	C.vkCmdCopyAccelerationStructureNV(command_buffer, dst, src, mode)
}

fn C.vkCmdTraceRaysNV(C.VkCommandBuffer, C.VkBuffer, DeviceSize, C.VkBuffer, DeviceSize, DeviceSize, C.VkBuffer, DeviceSize, DeviceSize, C.VkBuffer, DeviceSize, DeviceSize, u32, u32, u32)

pub type PFN_vkCmdTraceRaysNV = fn (C.VkCommandBuffer, C.VkBuffer, DeviceSize, C.VkBuffer, DeviceSize, DeviceSize, C.VkBuffer, DeviceSize, DeviceSize, C.VkBuffer, DeviceSize, DeviceSize, u32, u32, u32)

@[inline]
pub fn cmd_trace_rays_nv(command_buffer C.VkCommandBuffer,
	raygen_shader_binding_table_buffer C.VkBuffer,
	raygen_shader_binding_offset DeviceSize,
	miss_shader_binding_table_buffer C.VkBuffer,
	miss_shader_binding_offset DeviceSize,
	miss_shader_binding_stride DeviceSize,
	hit_shader_binding_table_buffer C.VkBuffer,
	hit_shader_binding_offset DeviceSize,
	hit_shader_binding_stride DeviceSize,
	callable_shader_binding_table_buffer C.VkBuffer,
	callable_shader_binding_offset DeviceSize,
	callable_shader_binding_stride DeviceSize,
	width u32,
	height u32,
	depth u32) {
	C.vkCmdTraceRaysNV(command_buffer, raygen_shader_binding_table_buffer, raygen_shader_binding_offset,
		miss_shader_binding_table_buffer, miss_shader_binding_offset, miss_shader_binding_stride,
		hit_shader_binding_table_buffer, hit_shader_binding_offset, hit_shader_binding_stride,
		callable_shader_binding_table_buffer, callable_shader_binding_offset, callable_shader_binding_stride,
		width, height, depth)
}

fn C.vkCreateRayTracingPipelinesNV(C.VkDevice, C.VkPipelineCache, u32, &RayTracingPipelineCreateInfoNV, &AllocationCallbacks, C.VkPipeline) Result

pub type PFN_vkCreateRayTracingPipelinesNV = fn (C.VkDevice, C.VkPipelineCache, u32, &RayTracingPipelineCreateInfoNV, &AllocationCallbacks, C.VkPipeline) Result

@[inline]
pub fn create_ray_tracing_pipelines_nv(device C.VkDevice,
	pipeline_cache C.VkPipelineCache,
	create_info_count u32,
	p_create_infos &RayTracingPipelineCreateInfoNV,
	p_allocator &AllocationCallbacks,
	p_pipelines C.VkPipeline) Result {
	return C.vkCreateRayTracingPipelinesNV(device, pipeline_cache, create_info_count,
		p_create_infos, p_allocator, p_pipelines)
}

fn C.vkGetRayTracingShaderGroupHandlesKHR(C.VkDevice, C.VkPipeline, u32, u32, usize, voidptr) Result

pub type PFN_vkGetRayTracingShaderGroupHandlesKHR = fn (C.VkDevice, C.VkPipeline, u32, u32, usize, voidptr) Result

@[inline]
pub fn get_ray_tracing_shader_group_handles_khr(device C.VkDevice,
	pipeline C.VkPipeline,
	first_group u32,
	group_count u32,
	data_size usize,
	p_data voidptr) Result {
	return C.vkGetRayTracingShaderGroupHandlesKHR(device, pipeline, first_group, group_count,
		data_size, p_data)
}

fn C.vkGetAccelerationStructureHandleNV(C.VkDevice, C.VkAccelerationStructureNV, usize, voidptr) Result

pub type PFN_vkGetAccelerationStructureHandleNV = fn (C.VkDevice, C.VkAccelerationStructureNV, usize, voidptr) Result

@[inline]
pub fn get_acceleration_structure_handle_nv(device C.VkDevice,
	acceleration_structure C.VkAccelerationStructureNV,
	data_size usize,
	p_data voidptr) Result {
	return C.vkGetAccelerationStructureHandleNV(device, acceleration_structure, data_size,
		p_data)
}

fn C.vkCmdWriteAccelerationStructuresPropertiesNV(C.VkCommandBuffer, u32, C.VkAccelerationStructureNV, QueryType, C.VkQueryPool, u32)

pub type PFN_vkCmdWriteAccelerationStructuresPropertiesNV = fn (C.VkCommandBuffer, u32, C.VkAccelerationStructureNV, QueryType, C.VkQueryPool, u32)

@[inline]
pub fn cmd_write_acceleration_structures_properties_nv(command_buffer C.VkCommandBuffer,
	acceleration_structure_count u32,
	p_acceleration_structures C.VkAccelerationStructureNV,
	query_type QueryType,
	query_pool C.VkQueryPool,
	first_query u32) {
	C.vkCmdWriteAccelerationStructuresPropertiesNV(command_buffer, acceleration_structure_count,
		p_acceleration_structures, query_type, query_pool, first_query)
}

fn C.vkCompileDeferredNV(C.VkDevice, C.VkPipeline, u32) Result

pub type PFN_vkCompileDeferredNV = fn (C.VkDevice, C.VkPipeline, u32) Result

@[inline]
pub fn compile_deferred_nv(device C.VkDevice,
	pipeline C.VkPipeline,
	shader u32) Result {
	return C.vkCompileDeferredNV(device, pipeline, shader)
}

pub const nv_representative_fragment_test_spec_version = 2
pub const nv_representative_fragment_test_extension_name = 'VK_NV_representative_fragment_test'

pub type PhysicalDeviceRepresentativeFragmentTestFeaturesNV = C.VkPhysicalDeviceRepresentativeFragmentTestFeaturesNV

@[typedef]
pub struct C.VkPhysicalDeviceRepresentativeFragmentTestFeaturesNV {
pub mut:
	sType                      StructureType = StructureType.physical_device_representative_fragment_test_features_nv
	pNext                      voidptr       = unsafe { nil }
	representativeFragmentTest Bool32
}

pub type PipelineRepresentativeFragmentTestStateCreateInfoNV = C.VkPipelineRepresentativeFragmentTestStateCreateInfoNV

@[typedef]
pub struct C.VkPipelineRepresentativeFragmentTestStateCreateInfoNV {
pub mut:
	sType                            StructureType = StructureType.pipeline_representative_fragment_test_state_create_info_nv
	pNext                            voidptr       = unsafe { nil }
	representativeFragmentTestEnable Bool32
}

pub const ext_filter_cubic_spec_version = 3
pub const ext_filter_cubic_extension_name = 'VK_EXT_filter_cubic'

pub type PhysicalDeviceImageViewImageFormatInfoEXT = C.VkPhysicalDeviceImageViewImageFormatInfoEXT

@[typedef]
pub struct C.VkPhysicalDeviceImageViewImageFormatInfoEXT {
pub mut:
	sType         StructureType = StructureType.physical_device_image_view_image_format_info_ext
	pNext         voidptr       = unsafe { nil }
	imageViewType ImageViewType
}

pub type FilterCubicImageViewImageFormatPropertiesEXT = C.VkFilterCubicImageViewImageFormatPropertiesEXT

@[typedef]
pub struct C.VkFilterCubicImageViewImageFormatPropertiesEXT {
pub mut:
	sType             StructureType = StructureType.filter_cubic_image_view_image_format_properties_ext
	pNext             voidptr       = unsafe { nil }
	filterCubic       Bool32
	filterCubicMinmax Bool32
}

pub const qcom_render_pass_shader_resolve_spec_version = 4
pub const qcom_render_pass_shader_resolve_extension_name = 'VK_QCOM_render_pass_shader_resolve'

pub const ext_global_priority_spec_version = 2
pub const ext_global_priority_extension_name = 'VK_EXT_global_priority'

pub type QueueGlobalPriorityEXT = QueueGlobalPriorityKHR

pub type DeviceQueueGlobalPriorityCreateInfoEXT = C.VkDeviceQueueGlobalPriorityCreateInfoKHR

pub const ext_external_memory_host_spec_version = 1
pub const ext_external_memory_host_extension_name = 'VK_EXT_external_memory_host'

pub type ImportMemoryHostPointerInfoEXT = C.VkImportMemoryHostPointerInfoEXT

@[typedef]
pub struct C.VkImportMemoryHostPointerInfoEXT {
pub mut:
	sType        StructureType = StructureType.import_memory_host_pointer_info_ext
	pNext        voidptr       = unsafe { nil }
	handleType   ExternalMemoryHandleTypeFlagBits
	pHostPointer voidptr
}

pub type MemoryHostPointerPropertiesEXT = C.VkMemoryHostPointerPropertiesEXT

@[typedef]
pub struct C.VkMemoryHostPointerPropertiesEXT {
pub mut:
	sType          StructureType = StructureType.memory_host_pointer_properties_ext
	pNext          voidptr       = unsafe { nil }
	memoryTypeBits u32
}

pub type PhysicalDeviceExternalMemoryHostPropertiesEXT = C.VkPhysicalDeviceExternalMemoryHostPropertiesEXT

@[typedef]
pub struct C.VkPhysicalDeviceExternalMemoryHostPropertiesEXT {
pub mut:
	sType                           StructureType = StructureType.physical_device_external_memory_host_properties_ext
	pNext                           voidptr       = unsafe { nil }
	minImportedHostPointerAlignment DeviceSize
}

fn C.vkGetMemoryHostPointerPropertiesEXT(C.VkDevice, ExternalMemoryHandleTypeFlagBits, voidptr, &MemoryHostPointerPropertiesEXT) Result

pub type PFN_vkGetMemoryHostPointerPropertiesEXT = fn (C.VkDevice, ExternalMemoryHandleTypeFlagBits, voidptr, &MemoryHostPointerPropertiesEXT) Result

@[inline]
pub fn get_memory_host_pointer_properties_ext(device C.VkDevice,
	handle_type ExternalMemoryHandleTypeFlagBits,
	p_host_pointer voidptr,
	p_memory_host_pointer_properties &MemoryHostPointerPropertiesEXT) Result {
	return C.vkGetMemoryHostPointerPropertiesEXT(device, handle_type, p_host_pointer,
		p_memory_host_pointer_properties)
}

pub const amd_buffer_marker_spec_version = 1
pub const amd_buffer_marker_extension_name = 'VK_AMD_buffer_marker'

fn C.vkCmdWriteBufferMarkerAMD(C.VkCommandBuffer, PipelineStageFlagBits, C.VkBuffer, DeviceSize, u32)

pub type PFN_vkCmdWriteBufferMarkerAMD = fn (C.VkCommandBuffer, PipelineStageFlagBits, C.VkBuffer, DeviceSize, u32)

@[inline]
pub fn cmd_write_buffer_marker_amd(command_buffer C.VkCommandBuffer,
	pipeline_stage PipelineStageFlagBits,
	dst_buffer C.VkBuffer,
	dst_offset DeviceSize,
	marker u32) {
	C.vkCmdWriteBufferMarkerAMD(command_buffer, pipeline_stage, dst_buffer, dst_offset,
		marker)
}

pub const amd_pipeline_compiler_control_spec_version = 1
pub const amd_pipeline_compiler_control_extension_name = 'VK_AMD_pipeline_compiler_control'

pub enum PipelineCompilerControlFlagBitsAMD {
	max_enum_amd = max_int
}

pub type PipelineCompilerControlFlagsAMD = u32
pub type PipelineCompilerControlCreateInfoAMD = C.VkPipelineCompilerControlCreateInfoAMD

@[typedef]
pub struct C.VkPipelineCompilerControlCreateInfoAMD {
pub mut:
	sType                StructureType = StructureType.pipeline_compiler_control_create_info_amd
	pNext                voidptr       = unsafe { nil }
	compilerControlFlags PipelineCompilerControlFlagsAMD
}

pub const ext_calibrated_timestamps_spec_version = 2
pub const ext_calibrated_timestamps_extension_name = 'VK_EXT_calibrated_timestamps'

pub type TimeDomainEXT = TimeDomainKHR

pub type CalibratedTimestampInfoEXT = C.VkCalibratedTimestampInfoKHR

pub const amd_shader_core_properties_spec_version = 2
pub const amd_shader_core_properties_extension_name = 'VK_AMD_shader_core_properties'

pub type PhysicalDeviceShaderCorePropertiesAMD = C.VkPhysicalDeviceShaderCorePropertiesAMD

@[typedef]
pub struct C.VkPhysicalDeviceShaderCorePropertiesAMD {
pub mut:
	sType                      StructureType = StructureType.physical_device_shader_core_properties_amd
	pNext                      voidptr       = unsafe { nil }
	shaderEngineCount          u32
	shaderArraysPerEngineCount u32
	computeUnitsPerShaderArray u32
	simdPerComputeUnit         u32
	wavefrontsPerSimd          u32
	wavefrontSize              u32
	sgprsPerSimd               u32
	minSgprAllocation          u32
	maxSgprAllocation          u32
	sgprAllocationGranularity  u32
	vgprsPerSimd               u32
	minVgprAllocation          u32
	maxVgprAllocation          u32
	vgprAllocationGranularity  u32
}

pub const amd_memory_overallocation_behavior_spec_version = 1
pub const amd_memory_overallocation_behavior_extension_name = 'VK_AMD_memory_overallocation_behavior'

pub enum MemoryOverallocationBehaviorAMD {
	default_amd    = 0
	allowed_amd    = 1
	disallowed_amd = 2
	max_enum_amd   = max_int
}

pub type DeviceMemoryOverallocationCreateInfoAMD = C.VkDeviceMemoryOverallocationCreateInfoAMD

@[typedef]
pub struct C.VkDeviceMemoryOverallocationCreateInfoAMD {
pub mut:
	sType                  StructureType = StructureType.device_memory_overallocation_create_info_amd
	pNext                  voidptr       = unsafe { nil }
	overallocationBehavior MemoryOverallocationBehaviorAMD
}

pub const ext_vertex_attribute_divisor_spec_version = 3
pub const ext_vertex_attribute_divisor_extension_name = 'VK_EXT_vertex_attribute_divisor'

pub type PhysicalDeviceVertexAttributeDivisorPropertiesEXT = C.VkPhysicalDeviceVertexAttributeDivisorPropertiesEXT

@[typedef]
pub struct C.VkPhysicalDeviceVertexAttributeDivisorPropertiesEXT {
pub mut:
	sType                  StructureType = StructureType.physical_device_vertex_attribute_divisor_properties_ext
	pNext                  voidptr       = unsafe { nil }
	maxVertexAttribDivisor u32
}

pub type VertexInputBindingDivisorDescriptionEXT = C.VkVertexInputBindingDivisorDescriptionKHR

pub type PipelineVertexInputDivisorStateCreateInfoEXT = C.VkPipelineVertexInputDivisorStateCreateInfoKHR

pub type PhysicalDeviceVertexAttributeDivisorFeaturesEXT = C.VkPhysicalDeviceVertexAttributeDivisorFeaturesKHR

pub const ext_pipeline_creation_feedback_spec_version = 1
pub const ext_pipeline_creation_feedback_extension_name = 'VK_EXT_pipeline_creation_feedback'

pub type PipelineCreationFeedbackFlagBitsEXT = PipelineCreationFeedbackFlagBits

pub type PipelineCreationFeedbackFlagsEXT = u32
pub type PipelineCreationFeedbackCreateInfoEXT = C.VkPipelineCreationFeedbackCreateInfo

pub type PipelineCreationFeedbackEXT = C.VkPipelineCreationFeedback

pub const nv_shader_subgroup_partitioned_spec_version = 1
pub const nv_shader_subgroup_partitioned_extension_name = 'VK_NV_shader_subgroup_partitioned'

pub const nv_compute_shader_derivatives_spec_version = 1
pub const nv_compute_shader_derivatives_extension_name = 'VK_NV_compute_shader_derivatives'

pub type PhysicalDeviceComputeShaderDerivativesFeaturesNV = C.VkPhysicalDeviceComputeShaderDerivativesFeaturesNV

@[typedef]
pub struct C.VkPhysicalDeviceComputeShaderDerivativesFeaturesNV {
pub mut:
	sType                        StructureType = StructureType.physical_device_compute_shader_derivatives_features_nv
	pNext                        voidptr       = unsafe { nil }
	computeDerivativeGroupQuads  Bool32
	computeDerivativeGroupLinear Bool32
}

pub const nv_mesh_shader_spec_version = 1
pub const nv_mesh_shader_extension_name = 'VK_NV_mesh_shader'

pub type PhysicalDeviceMeshShaderFeaturesNV = C.VkPhysicalDeviceMeshShaderFeaturesNV

@[typedef]
pub struct C.VkPhysicalDeviceMeshShaderFeaturesNV {
pub mut:
	sType      StructureType = StructureType.physical_device_mesh_shader_features_nv
	pNext      voidptr       = unsafe { nil }
	taskShader Bool32
	meshShader Bool32
}

pub type PhysicalDeviceMeshShaderPropertiesNV = C.VkPhysicalDeviceMeshShaderPropertiesNV

@[typedef]
pub struct C.VkPhysicalDeviceMeshShaderPropertiesNV {
pub mut:
	sType                             StructureType = StructureType.physical_device_mesh_shader_properties_nv
	pNext                             voidptr       = unsafe { nil }
	maxDrawMeshTasksCount             u32
	maxTaskWorkGroupInvocations       u32
	maxTaskWorkGroupSize              [3]u32
	maxTaskTotalMemorySize            u32
	maxTaskOutputCount                u32
	maxMeshWorkGroupInvocations       u32
	maxMeshWorkGroupSize              [3]u32
	maxMeshTotalMemorySize            u32
	maxMeshOutputVertices             u32
	maxMeshOutputPrimitives           u32
	maxMeshMultiviewViewCount         u32
	meshOutputPerVertexGranularity    u32
	meshOutputPerPrimitiveGranularity u32
}

pub type DrawMeshTasksIndirectCommandNV = C.VkDrawMeshTasksIndirectCommandNV

@[typedef]
pub struct C.VkDrawMeshTasksIndirectCommandNV {
pub mut:
	taskCount u32
	firstTask u32
}

fn C.vkCmdDrawMeshTasksNV(C.VkCommandBuffer, u32, u32)

pub type PFN_vkCmdDrawMeshTasksNV = fn (C.VkCommandBuffer, u32, u32)

@[inline]
pub fn cmd_draw_mesh_tasks_nv(command_buffer C.VkCommandBuffer,
	task_count u32,
	first_task u32) {
	C.vkCmdDrawMeshTasksNV(command_buffer, task_count, first_task)
}

fn C.vkCmdDrawMeshTasksIndirectNV(C.VkCommandBuffer, C.VkBuffer, DeviceSize, u32, u32)

pub type PFN_vkCmdDrawMeshTasksIndirectNV = fn (C.VkCommandBuffer, C.VkBuffer, DeviceSize, u32, u32)

@[inline]
pub fn cmd_draw_mesh_tasks_indirect_nv(command_buffer C.VkCommandBuffer,
	buffer C.VkBuffer,
	offset DeviceSize,
	draw_count u32,
	stride u32) {
	C.vkCmdDrawMeshTasksIndirectNV(command_buffer, buffer, offset, draw_count, stride)
}

fn C.vkCmdDrawMeshTasksIndirectCountNV(C.VkCommandBuffer, C.VkBuffer, DeviceSize, C.VkBuffer, DeviceSize, u32, u32)

pub type PFN_vkCmdDrawMeshTasksIndirectCountNV = fn (C.VkCommandBuffer, C.VkBuffer, DeviceSize, C.VkBuffer, DeviceSize, u32, u32)

@[inline]
pub fn cmd_draw_mesh_tasks_indirect_count_nv(command_buffer C.VkCommandBuffer,
	buffer C.VkBuffer,
	offset DeviceSize,
	count_buffer C.VkBuffer,
	count_buffer_offset DeviceSize,
	max_draw_count u32,
	stride u32) {
	C.vkCmdDrawMeshTasksIndirectCountNV(command_buffer, buffer, offset, count_buffer,
		count_buffer_offset, max_draw_count, stride)
}

pub const nv_fragment_shader_barycentric_spec_version = 1
pub const nv_fragment_shader_barycentric_extension_name = 'VK_NV_fragment_shader_barycentric'

pub type PhysicalDeviceFragmentShaderBarycentricFeaturesNV = C.VkPhysicalDeviceFragmentShaderBarycentricFeaturesKHR

pub const nv_shader_image_footprint_spec_version = 2
pub const nv_shader_image_footprint_extension_name = 'VK_NV_shader_image_footprint'

pub type PhysicalDeviceShaderImageFootprintFeaturesNV = C.VkPhysicalDeviceShaderImageFootprintFeaturesNV

@[typedef]
pub struct C.VkPhysicalDeviceShaderImageFootprintFeaturesNV {
pub mut:
	sType          StructureType = StructureType.physical_device_shader_image_footprint_features_nv
	pNext          voidptr       = unsafe { nil }
	imageFootprint Bool32
}

pub const nv_scissor_exclusive_spec_version = 2
pub const nv_scissor_exclusive_extension_name = 'VK_NV_scissor_exclusive'

pub type PipelineViewportExclusiveScissorStateCreateInfoNV = C.VkPipelineViewportExclusiveScissorStateCreateInfoNV

@[typedef]
pub struct C.VkPipelineViewportExclusiveScissorStateCreateInfoNV {
pub mut:
	sType                 StructureType = StructureType.pipeline_viewport_exclusive_scissor_state_create_info_nv
	pNext                 voidptr       = unsafe { nil }
	exclusiveScissorCount u32
	pExclusiveScissors    &Rect2D
}

pub type PhysicalDeviceExclusiveScissorFeaturesNV = C.VkPhysicalDeviceExclusiveScissorFeaturesNV

@[typedef]
pub struct C.VkPhysicalDeviceExclusiveScissorFeaturesNV {
pub mut:
	sType            StructureType = StructureType.physical_device_exclusive_scissor_features_nv
	pNext            voidptr       = unsafe { nil }
	exclusiveScissor Bool32
}

fn C.vkCmdSetExclusiveScissorEnableNV(C.VkCommandBuffer, u32, u32, &Bool32)

pub type PFN_vkCmdSetExclusiveScissorEnableNV = fn (C.VkCommandBuffer, u32, u32, &Bool32)

@[inline]
pub fn cmd_set_exclusive_scissor_enable_nv(command_buffer C.VkCommandBuffer,
	first_exclusive_scissor u32,
	exclusive_scissor_count u32,
	p_exclusive_scissor_enables &Bool32) {
	C.vkCmdSetExclusiveScissorEnableNV(command_buffer, first_exclusive_scissor, exclusive_scissor_count,
		p_exclusive_scissor_enables)
}

fn C.vkCmdSetExclusiveScissorNV(C.VkCommandBuffer, u32, u32, &Rect2D)

pub type PFN_vkCmdSetExclusiveScissorNV = fn (C.VkCommandBuffer, u32, u32, &Rect2D)

@[inline]
pub fn cmd_set_exclusive_scissor_nv(command_buffer C.VkCommandBuffer,
	first_exclusive_scissor u32,
	exclusive_scissor_count u32,
	p_exclusive_scissors &Rect2D) {
	C.vkCmdSetExclusiveScissorNV(command_buffer, first_exclusive_scissor, exclusive_scissor_count,
		p_exclusive_scissors)
}

pub const nv_device_diagnostic_checkpoints_spec_version = 2
pub const nv_device_diagnostic_checkpoints_extension_name = 'VK_NV_device_diagnostic_checkpoints'

pub type QueueFamilyCheckpointPropertiesNV = C.VkQueueFamilyCheckpointPropertiesNV

@[typedef]
pub struct C.VkQueueFamilyCheckpointPropertiesNV {
pub mut:
	sType                        StructureType = StructureType.queue_family_checkpoint_properties_nv
	pNext                        voidptr       = unsafe { nil }
	checkpointExecutionStageMask PipelineStageFlags
}

pub type CheckpointDataNV = C.VkCheckpointDataNV

@[typedef]
pub struct C.VkCheckpointDataNV {
pub mut:
	sType             StructureType = StructureType.checkpoint_data_nv
	pNext             voidptr       = unsafe { nil }
	stage             PipelineStageFlagBits
	pCheckpointMarker voidptr
}

fn C.vkCmdSetCheckpointNV(C.VkCommandBuffer, voidptr)

pub type PFN_vkCmdSetCheckpointNV = fn (C.VkCommandBuffer, voidptr)

@[inline]
pub fn cmd_set_checkpoint_nv(command_buffer C.VkCommandBuffer,
	p_checkpoint_marker voidptr) {
	C.vkCmdSetCheckpointNV(command_buffer, p_checkpoint_marker)
}

fn C.vkGetQueueCheckpointDataNV(C.VkQueue, &u32, &CheckpointDataNV)

pub type PFN_vkGetQueueCheckpointDataNV = fn (C.VkQueue, &u32, &CheckpointDataNV)

@[inline]
pub fn get_queue_checkpoint_data_nv(queue C.VkQueue,
	p_checkpoint_data_count &u32,
	p_checkpoint_data &CheckpointDataNV) {
	C.vkGetQueueCheckpointDataNV(queue, p_checkpoint_data_count, p_checkpoint_data)
}

pub const intel_shader_integer_functions_2_spec_version = 1
pub const intel_shader_integer_functions_2_extension_name = 'VK_INTE_shader_integer_functions2'

pub type PhysicalDeviceShaderIntegerFunctions2FeaturesINTEL = C.VkPhysicalDeviceShaderIntegerFunctions2FeaturesINTEL

@[typedef]
pub struct C.VkPhysicalDeviceShaderIntegerFunctions2FeaturesINTEL {
pub mut:
	sType                   StructureType = StructureType.physical_device_shader_integer_functions2_features_intel
	pNext                   voidptr       = unsafe { nil }
	shaderIntegerFunctions2 Bool32
}

pub type C.VkPerformanceConfigurationINTEL = voidptr

pub const intel_performance_query_spec_version = 2
pub const intel_performance_query_extension_name = 'VK_INTE_performance_query'

pub enum PerformanceConfigurationTypeINTEL {
	command_queue_metrics_discovery_activated_intel = 0
	max_enum_intel                                  = max_int
}

pub enum QueryPoolSamplingModeINTEL {
	manual_intel   = 0
	max_enum_intel = max_int
}

pub enum PerformanceOverrideTypeINTEL {
	null_hardware_intel    = 0
	flush_gpu_caches_intel = 1
	max_enum_intel         = max_int
}

pub enum PerformanceParameterTypeINTEL {
	hw_counters_supported_intel    = 0
	stream_marker_valid_bits_intel = 1
	max_enum_intel                 = max_int
}

pub enum PerformanceValueTypeINTEL {
	uint32_intel   = 0
	uint64_intel   = 1
	float_intel    = 2
	bool_intel     = 3
	string_intel   = 4
	max_enum_intel = max_int
}

pub type PerformanceValueDataINTEL = C.VkPerformanceValueDataINTEL

@[typedef]
pub union C.VkPerformanceValueDataINTEL {
pub mut:
	value32     u32
	value64     u64
	valueFloat  f32
	valueBool   Bool32
	valueString &char
}

pub type PerformanceValueINTEL = C.VkPerformanceValueINTEL

@[typedef]
pub struct C.VkPerformanceValueINTEL {
pub mut:
	type PerformanceValueTypeINTEL
	data PerformanceValueDataINTEL
}

pub type InitializePerformanceApiInfoINTEL = C.VkInitializePerformanceApiInfoINTEL

@[typedef]
pub struct C.VkInitializePerformanceApiInfoINTEL {
pub mut:
	sType     StructureType = StructureType.initialize_performance_api_info_intel
	pNext     voidptr       = unsafe { nil }
	pUserData voidptr       = unsafe { nil }
}

pub type QueryPoolPerformanceQueryCreateInfoINTEL = C.VkQueryPoolPerformanceQueryCreateInfoINTEL

@[typedef]
pub struct C.VkQueryPoolPerformanceQueryCreateInfoINTEL {
pub mut:
	sType                       StructureType = StructureType.query_pool_performance_query_create_info_intel
	pNext                       voidptr       = unsafe { nil }
	performanceCountersSampling QueryPoolSamplingModeINTEL
}

pub type QueryPoolCreateInfoINTEL = C.VkQueryPoolPerformanceQueryCreateInfoINTEL

pub type PerformanceMarkerInfoINTEL = C.VkPerformanceMarkerInfoINTEL

@[typedef]
pub struct C.VkPerformanceMarkerInfoINTEL {
pub mut:
	sType  StructureType = StructureType.performance_marker_info_intel
	pNext  voidptr       = unsafe { nil }
	marker u64
}

pub type PerformanceStreamMarkerInfoINTEL = C.VkPerformanceStreamMarkerInfoINTEL

@[typedef]
pub struct C.VkPerformanceStreamMarkerInfoINTEL {
pub mut:
	sType  StructureType = StructureType.performance_stream_marker_info_intel
	pNext  voidptr       = unsafe { nil }
	marker u32
}

pub type PerformanceOverrideInfoINTEL = C.VkPerformanceOverrideInfoINTEL

@[typedef]
pub struct C.VkPerformanceOverrideInfoINTEL {
pub mut:
	sType     StructureType = StructureType.performance_override_info_intel
	pNext     voidptr       = unsafe { nil }
	type      PerformanceOverrideTypeINTEL
	enable    Bool32
	parameter u64
}

pub type PerformanceConfigurationAcquireInfoINTEL = C.VkPerformanceConfigurationAcquireInfoINTEL

@[typedef]
pub struct C.VkPerformanceConfigurationAcquireInfoINTEL {
pub mut:
	sType StructureType = StructureType.performance_configuration_acquire_info_intel
	pNext voidptr       = unsafe { nil }
	type  PerformanceConfigurationTypeINTEL
}

fn C.vkInitializePerformanceApiINTEL(C.VkDevice, &InitializePerformanceApiInfoINTEL) Result

pub type PFN_vkInitializePerformanceApiINTEL = fn (C.VkDevice, &InitializePerformanceApiInfoINTEL) Result

@[inline]
pub fn initialize_performance_api_intel(device C.VkDevice,
	p_initialize_info &InitializePerformanceApiInfoINTEL) Result {
	return C.vkInitializePerformanceApiINTEL(device, p_initialize_info)
}

fn C.vkUninitializePerformanceApiINTEL(C.VkDevice)

pub type PFN_vkUninitializePerformanceApiINTEL = fn (C.VkDevice)

@[inline]
pub fn uninitialize_performance_api_intel(device C.VkDevice) {
	C.vkUninitializePerformanceApiINTEL(device)
}

fn C.vkCmdSetPerformanceMarkerINTEL(C.VkCommandBuffer, &PerformanceMarkerInfoINTEL) Result

pub type PFN_vkCmdSetPerformanceMarkerINTEL = fn (C.VkCommandBuffer, &PerformanceMarkerInfoINTEL) Result

@[inline]
pub fn cmd_set_performance_marker_intel(command_buffer C.VkCommandBuffer,
	p_marker_info &PerformanceMarkerInfoINTEL) Result {
	return C.vkCmdSetPerformanceMarkerINTEL(command_buffer, p_marker_info)
}

fn C.vkCmdSetPerformanceStreamMarkerINTEL(C.VkCommandBuffer, &PerformanceStreamMarkerInfoINTEL) Result

pub type PFN_vkCmdSetPerformanceStreamMarkerINTEL = fn (C.VkCommandBuffer, &PerformanceStreamMarkerInfoINTEL) Result

@[inline]
pub fn cmd_set_performance_stream_marker_intel(command_buffer C.VkCommandBuffer,
	p_marker_info &PerformanceStreamMarkerInfoINTEL) Result {
	return C.vkCmdSetPerformanceStreamMarkerINTEL(command_buffer, p_marker_info)
}

fn C.vkCmdSetPerformanceOverrideINTEL(C.VkCommandBuffer, &PerformanceOverrideInfoINTEL) Result

pub type PFN_vkCmdSetPerformanceOverrideINTEL = fn (C.VkCommandBuffer, &PerformanceOverrideInfoINTEL) Result

@[inline]
pub fn cmd_set_performance_override_intel(command_buffer C.VkCommandBuffer,
	p_override_info &PerformanceOverrideInfoINTEL) Result {
	return C.vkCmdSetPerformanceOverrideINTEL(command_buffer, p_override_info)
}

fn C.vkAcquirePerformanceConfigurationINTEL(C.VkDevice, &PerformanceConfigurationAcquireInfoINTEL, C.VkPerformanceConfigurationINTEL) Result

pub type PFN_vkAcquirePerformanceConfigurationINTEL = fn (C.VkDevice, &PerformanceConfigurationAcquireInfoINTEL, C.VkPerformanceConfigurationINTEL) Result

@[inline]
pub fn acquire_performance_configuration_intel(device C.VkDevice,
	p_acquire_info &PerformanceConfigurationAcquireInfoINTEL,
	p_configuration C.VkPerformanceConfigurationINTEL) Result {
	return C.vkAcquirePerformanceConfigurationINTEL(device, p_acquire_info, p_configuration)
}

fn C.vkReleasePerformanceConfigurationINTEL(C.VkDevice, C.VkPerformanceConfigurationINTEL) Result

pub type PFN_vkReleasePerformanceConfigurationINTEL = fn (C.VkDevice, C.VkPerformanceConfigurationINTEL) Result

@[inline]
pub fn release_performance_configuration_intel(device C.VkDevice,
	configuration C.VkPerformanceConfigurationINTEL) Result {
	return C.vkReleasePerformanceConfigurationINTEL(device, configuration)
}

fn C.vkQueueSetPerformanceConfigurationINTEL(C.VkQueue, C.VkPerformanceConfigurationINTEL) Result

pub type PFN_vkQueueSetPerformanceConfigurationINTEL = fn (C.VkQueue, C.VkPerformanceConfigurationINTEL) Result

@[inline]
pub fn queue_set_performance_configuration_intel(queue C.VkQueue,
	configuration C.VkPerformanceConfigurationINTEL) Result {
	return C.vkQueueSetPerformanceConfigurationINTEL(queue, configuration)
}

fn C.vkGetPerformanceParameterINTEL(C.VkDevice, PerformanceParameterTypeINTEL, &PerformanceValueINTEL) Result

pub type PFN_vkGetPerformanceParameterINTEL = fn (C.VkDevice, PerformanceParameterTypeINTEL, &PerformanceValueINTEL) Result

@[inline]
pub fn get_performance_parameter_intel(device C.VkDevice,
	parameter PerformanceParameterTypeINTEL,
	p_value &PerformanceValueINTEL) Result {
	return C.vkGetPerformanceParameterINTEL(device, parameter, p_value)
}

pub const ext_pci_bus_info_spec_version = 2
pub const ext_pci_bus_info_extension_name = 'VK_EXT_pci_bus_info'

pub type PhysicalDevicePCIBusInfoPropertiesEXT = C.VkPhysicalDevicePCIBusInfoPropertiesEXT

@[typedef]
pub struct C.VkPhysicalDevicePCIBusInfoPropertiesEXT {
pub mut:
	sType       StructureType = StructureType.physical_device_pci_bus_info_properties_ext
	pNext       voidptr       = unsafe { nil }
	pciDomain   u32
	pciBus      u32
	pciDevice   u32
	pciFunction u32
}

pub const amd_display_native_hdr_spec_version = 1
pub const amd_display_native_hdr_extension_name = 'VK_AMD_display_native_hdr'

pub type DisplayNativeHdrSurfaceCapabilitiesAMD = C.VkDisplayNativeHdrSurfaceCapabilitiesAMD

@[typedef]
pub struct C.VkDisplayNativeHdrSurfaceCapabilitiesAMD {
pub mut:
	sType               StructureType = StructureType.display_native_hdr_surface_capabilities_amd
	pNext               voidptr       = unsafe { nil }
	localDimmingSupport Bool32
}

pub type SwapchainDisplayNativeHdrCreateInfoAMD = C.VkSwapchainDisplayNativeHdrCreateInfoAMD

@[typedef]
pub struct C.VkSwapchainDisplayNativeHdrCreateInfoAMD {
pub mut:
	sType              StructureType = StructureType.swapchain_display_native_hdr_create_info_amd
	pNext              voidptr       = unsafe { nil }
	localDimmingEnable Bool32
}

fn C.vkSetLocalDimmingAMD(C.VkDevice, C.VkSwapchainKHR, Bool32)

pub type PFN_vkSetLocalDimmingAMD = fn (C.VkDevice, C.VkSwapchainKHR, Bool32)

@[inline]
pub fn set_local_dimming_amd(device C.VkDevice,
	swap_chain C.VkSwapchainKHR,
	local_dimming_enable Bool32) {
	C.vkSetLocalDimmingAMD(device, swap_chain, local_dimming_enable)
}

pub const ext_fragment_density_map_spec_version = 2
pub const ext_fragment_density_map_extension_name = 'VK_EXT_fragment_density_map'

pub type PhysicalDeviceFragmentDensityMapFeaturesEXT = C.VkPhysicalDeviceFragmentDensityMapFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceFragmentDensityMapFeaturesEXT {
pub mut:
	sType                                 StructureType = StructureType.physical_device_fragment_density_map_features_ext
	pNext                                 voidptr       = unsafe { nil }
	fragmentDensityMap                    Bool32
	fragmentDensityMapDynamic             Bool32
	fragmentDensityMapNonSubsampledImages Bool32
}

pub type PhysicalDeviceFragmentDensityMapPropertiesEXT = C.VkPhysicalDeviceFragmentDensityMapPropertiesEXT

@[typedef]
pub struct C.VkPhysicalDeviceFragmentDensityMapPropertiesEXT {
pub mut:
	sType                       StructureType = StructureType.physical_device_fragment_density_map_properties_ext
	pNext                       voidptr       = unsafe { nil }
	minFragmentDensityTexelSize Extent2D
	maxFragmentDensityTexelSize Extent2D
	fragmentDensityInvocations  Bool32
}

pub type RenderPassFragmentDensityMapCreateInfoEXT = C.VkRenderPassFragmentDensityMapCreateInfoEXT

@[typedef]
pub struct C.VkRenderPassFragmentDensityMapCreateInfoEXT {
pub mut:
	sType                        StructureType = StructureType.render_pass_fragment_density_map_create_info_ext
	pNext                        voidptr       = unsafe { nil }
	fragmentDensityMapAttachment AttachmentReference
}

pub const ext_scalar_block_layout_spec_version = 1
pub const ext_scalar_block_layout_extension_name = 'VK_EXT_scalar_block_layout'

pub type PhysicalDeviceScalarBlockLayoutFeaturesEXT = C.VkPhysicalDeviceScalarBlockLayoutFeatures

pub const google_hlsl_functionality_1_spec_version = 1
pub const google_hlsl_functionality_1_extension_name = 'VK_GOOGE_hlsl_functionality1'
// VK_GOOGLE_HLSL_FUNCTIONALITY1_SPEC_VERSION is a deprecated alias
pub const google_hlsl_functionality1_spec_version = google_hlsl_functionality_1_spec_version
// VK_GOOGLE_HLSL_FUNCTIONALITY1_EXTENSION_NAME is a deprecated alias
pub const google_hlsl_functionality1_extension_name = google_hlsl_functionality_1_extension_name

pub const google_decorate_string_spec_version = 1
pub const google_decorate_string_extension_name = 'VK_GOOGE_decorate_string'

pub const ext_subgroup_size_control_spec_version = 2
pub const ext_subgroup_size_control_extension_name = 'VK_EXT_subgroup_size_control'

pub type PhysicalDeviceSubgroupSizeControlFeaturesEXT = C.VkPhysicalDeviceSubgroupSizeControlFeatures

pub type PhysicalDeviceSubgroupSizeControlPropertiesEXT = C.VkPhysicalDeviceSubgroupSizeControlProperties

pub type PipelineShaderStageRequiredSubgroupSizeCreateInfoEXT = C.VkPipelineShaderStageRequiredSubgroupSizeCreateInfo

pub const amd_shader_core_properties_2_spec_version = 1
pub const amd_shader_core_properties_2_extension_name = 'VK_AMD_shader_core_properties2'

pub enum ShaderCorePropertiesFlagBitsAMD {
	max_enum_amd = max_int
}

pub type ShaderCorePropertiesFlagsAMD = u32
pub type PhysicalDeviceShaderCoreProperties2AMD = C.VkPhysicalDeviceShaderCoreProperties2AMD

@[typedef]
pub struct C.VkPhysicalDeviceShaderCoreProperties2AMD {
pub mut:
	sType                  StructureType = StructureType.physical_device_shader_core_properties2_amd
	pNext                  voidptr       = unsafe { nil }
	shaderCoreFeatures     ShaderCorePropertiesFlagsAMD
	activeComputeUnitCount u32
}

pub const amd_device_coherent_memory_spec_version = 1
pub const amd_device_coherent_memory_extension_name = 'VK_AMD_device_coherent_memory'

pub type PhysicalDeviceCoherentMemoryFeaturesAMD = C.VkPhysicalDeviceCoherentMemoryFeaturesAMD

@[typedef]
pub struct C.VkPhysicalDeviceCoherentMemoryFeaturesAMD {
pub mut:
	sType                StructureType = StructureType.physical_device_coherent_memory_features_amd
	pNext                voidptr       = unsafe { nil }
	deviceCoherentMemory Bool32
}

pub const ext_shader_image_atomic_int64_spec_version = 1
pub const ext_shader_image_atomic_int64_extension_name = 'VK_EXT_shader_image_atomic_int64'

pub type PhysicalDeviceShaderImageAtomicInt64FeaturesEXT = C.VkPhysicalDeviceShaderImageAtomicInt64FeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceShaderImageAtomicInt64FeaturesEXT {
pub mut:
	sType                   StructureType = StructureType.physical_device_shader_image_atomic_int64_features_ext
	pNext                   voidptr       = unsafe { nil }
	shaderImageInt64Atomics Bool32
	sparseImageInt64Atomics Bool32
}

pub const ext_memory_budget_spec_version = 1
pub const ext_memory_budget_extension_name = 'VK_EXT_memory_budget'

pub type PhysicalDeviceMemoryBudgetPropertiesEXT = C.VkPhysicalDeviceMemoryBudgetPropertiesEXT

@[typedef]
pub struct C.VkPhysicalDeviceMemoryBudgetPropertiesEXT {
pub mut:
	sType      StructureType = StructureType.physical_device_memory_budget_properties_ext
	pNext      voidptr       = unsafe { nil }
	heapBudget [max_memory_heaps]DeviceSize
	heapUsage  [max_memory_heaps]DeviceSize
}

pub const ext_memory_priority_spec_version = 1
pub const ext_memory_priority_extension_name = 'VK_EXT_memory_priority'

pub type PhysicalDeviceMemoryPriorityFeaturesEXT = C.VkPhysicalDeviceMemoryPriorityFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceMemoryPriorityFeaturesEXT {
pub mut:
	sType          StructureType = StructureType.physical_device_memory_priority_features_ext
	pNext          voidptr       = unsafe { nil }
	memoryPriority Bool32
}

pub type MemoryPriorityAllocateInfoEXT = C.VkMemoryPriorityAllocateInfoEXT

@[typedef]
pub struct C.VkMemoryPriorityAllocateInfoEXT {
pub mut:
	sType    StructureType = StructureType.memory_priority_allocate_info_ext
	pNext    voidptr       = unsafe { nil }
	priority f32
}

pub const nv_dedicated_allocation_image_aliasing_spec_version = 1
pub const nv_dedicated_allocation_image_aliasing_extension_name = 'VK_NV_dedicated_allocation_image_aliasing'

pub type PhysicalDeviceDedicatedAllocationImageAliasingFeaturesNV = C.VkPhysicalDeviceDedicatedAllocationImageAliasingFeaturesNV

@[typedef]
pub struct C.VkPhysicalDeviceDedicatedAllocationImageAliasingFeaturesNV {
pub mut:
	sType                            StructureType = StructureType.physical_device_dedicated_allocation_image_aliasing_features_nv
	pNext                            voidptr       = unsafe { nil }
	dedicatedAllocationImageAliasing Bool32
}

pub const ext_buffer_device_address_spec_version = 2
pub const ext_buffer_device_address_extension_name = 'VK_EXT_buffer_device_address'

pub type PhysicalDeviceBufferDeviceAddressFeaturesEXT = C.VkPhysicalDeviceBufferDeviceAddressFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceBufferDeviceAddressFeaturesEXT {
pub mut:
	sType                            StructureType = StructureType.physical_device_buffer_device_address_features_ext
	pNext                            voidptr       = unsafe { nil }
	bufferDeviceAddress              Bool32
	bufferDeviceAddressCaptureReplay Bool32
	bufferDeviceAddressMultiDevice   Bool32
}

pub type PhysicalDeviceBufferAddressFeaturesEXT = C.VkPhysicalDeviceBufferDeviceAddressFeaturesEXT

pub type BufferDeviceAddressInfoEXT = C.VkBufferDeviceAddressInfo

pub type BufferDeviceAddressCreateInfoEXT = C.VkBufferDeviceAddressCreateInfoEXT

@[typedef]
pub struct C.VkBufferDeviceAddressCreateInfoEXT {
pub mut:
	sType         StructureType = StructureType.buffer_device_address_create_info_ext
	pNext         voidptr       = unsafe { nil }
	deviceAddress DeviceAddress
}

pub const ext_tooling_info_spec_version = 1
pub const ext_tooling_info_extension_name = 'VK_EXT_tooling_info'

pub type ToolPurposeFlagBitsEXT = ToolPurposeFlagBits

pub type ToolPurposeFlagsEXT = u32
pub type PhysicalDeviceToolPropertiesEXT = C.VkPhysicalDeviceToolProperties

pub const ext_separate_stencil_usage_spec_version = 1
pub const ext_separate_stencil_usage_extension_name = 'VK_EXT_separate_stencil_usage'

pub type ImageStencilUsageCreateInfoEXT = C.VkImageStencilUsageCreateInfo

pub const ext_validation_features_spec_version = 6
pub const ext_validation_features_extension_name = 'VK_EXT_validation_features'

pub enum ValidationFeatureEnableEXT {
	gpu_assisted_ext                      = 0
	gpu_assisted_reserve_binding_slot_ext = 1
	best_practices_ext                    = 2
	debug_printf_ext                      = 3
	synchronization_validation_ext        = 4
	max_enum_ext                          = max_int
}

pub enum ValidationFeatureDisableEXT {
	all_ext                     = 0
	shaders_ext                 = 1
	thread_safety_ext           = 2
	api_parameters_ext          = 3
	object_lifetimes_ext        = 4
	core_checks_ext             = 5
	unique_handles_ext          = 6
	shader_validation_cache_ext = 7
	max_enum_ext                = max_int
}

pub type ValidationFeaturesEXT = C.VkValidationFeaturesEXT

@[typedef]
pub struct C.VkValidationFeaturesEXT {
pub mut:
	sType                          StructureType = StructureType.validation_features_ext
	pNext                          voidptr       = unsafe { nil }
	enabledValidationFeatureCount  u32
	pEnabledValidationFeatures     &ValidationFeatureEnableEXT
	disabledValidationFeatureCount u32
	pDisabledValidationFeatures    &ValidationFeatureDisableEXT
}

pub const nv_cooperative_matrix_spec_version = 1
pub const nv_cooperative_matrix_extension_name = 'VK_NV_cooperative_matrix'

pub type ComponentTypeNV = ComponentTypeKHR

pub type ScopeNV = ScopeKHR

pub type CooperativeMatrixPropertiesNV = C.VkCooperativeMatrixPropertiesNV

@[typedef]
pub struct C.VkCooperativeMatrixPropertiesNV {
pub mut:
	sType StructureType = StructureType.cooperative_matrix_properties_nv
	pNext voidptr       = unsafe { nil }
	MSize u32
	NSize u32
	KSize u32
	AType ComponentTypeNV
	BType ComponentTypeNV
	CType ComponentTypeNV
	DType ComponentTypeNV
	scope ScopeNV
}

pub type PhysicalDeviceCooperativeMatrixFeaturesNV = C.VkPhysicalDeviceCooperativeMatrixFeaturesNV

@[typedef]
pub struct C.VkPhysicalDeviceCooperativeMatrixFeaturesNV {
pub mut:
	sType                               StructureType = StructureType.physical_device_cooperative_matrix_features_nv
	pNext                               voidptr       = unsafe { nil }
	cooperativeMatrix                   Bool32
	cooperativeMatrixRobustBufferAccess Bool32
}

pub type PhysicalDeviceCooperativeMatrixPropertiesNV = C.VkPhysicalDeviceCooperativeMatrixPropertiesNV

@[typedef]
pub struct C.VkPhysicalDeviceCooperativeMatrixPropertiesNV {
pub mut:
	sType                            StructureType = StructureType.physical_device_cooperative_matrix_properties_nv
	pNext                            voidptr       = unsafe { nil }
	cooperativeMatrixSupportedStages ShaderStageFlags
}

fn C.vkGetPhysicalDeviceCooperativeMatrixPropertiesNV(C.VkPhysicalDevice, &u32, &CooperativeMatrixPropertiesNV) Result

pub type PFN_vkGetPhysicalDeviceCooperativeMatrixPropertiesNV = fn (C.VkPhysicalDevice, &u32, &CooperativeMatrixPropertiesNV) Result

@[inline]
pub fn get_physical_device_cooperative_matrix_properties_nv(physical_device C.VkPhysicalDevice,
	p_property_count &u32,
	p_properties &CooperativeMatrixPropertiesNV) Result {
	return C.vkGetPhysicalDeviceCooperativeMatrixPropertiesNV(physical_device, p_property_count,
		p_properties)
}

pub const nv_coverage_reduction_mode_spec_version = 1
pub const nv_coverage_reduction_mode_extension_name = 'VK_NV_coverage_reduction_mode'

pub enum CoverageReductionModeNV {
	merge_nv    = 0
	truncate_nv = 1
	max_enum_nv = max_int
}

pub type PipelineCoverageReductionStateCreateFlagsNV = u32
pub type PhysicalDeviceCoverageReductionModeFeaturesNV = C.VkPhysicalDeviceCoverageReductionModeFeaturesNV

@[typedef]
pub struct C.VkPhysicalDeviceCoverageReductionModeFeaturesNV {
pub mut:
	sType                 StructureType = StructureType.physical_device_coverage_reduction_mode_features_nv
	pNext                 voidptr       = unsafe { nil }
	coverageReductionMode Bool32
}

pub type PipelineCoverageReductionStateCreateInfoNV = C.VkPipelineCoverageReductionStateCreateInfoNV

@[typedef]
pub struct C.VkPipelineCoverageReductionStateCreateInfoNV {
pub mut:
	sType                 StructureType = StructureType.pipeline_coverage_reduction_state_create_info_nv
	pNext                 voidptr       = unsafe { nil }
	flags                 PipelineCoverageReductionStateCreateFlagsNV
	coverageReductionMode CoverageReductionModeNV
}

pub type FramebufferMixedSamplesCombinationNV = C.VkFramebufferMixedSamplesCombinationNV

@[typedef]
pub struct C.VkFramebufferMixedSamplesCombinationNV {
pub mut:
	sType                 StructureType = StructureType.framebuffer_mixed_samples_combination_nv
	pNext                 voidptr       = unsafe { nil }
	coverageReductionMode CoverageReductionModeNV
	rasterizationSamples  SampleCountFlagBits
	depthStencilSamples   SampleCountFlags
	colorSamples          SampleCountFlags
}

fn C.vkGetPhysicalDeviceSupportedFramebufferMixedSamplesCombinationsNV(C.VkPhysicalDevice, &u32, &FramebufferMixedSamplesCombinationNV) Result

pub type PFN_vkGetPhysicalDeviceSupportedFramebufferMixedSamplesCombinationsNV = fn (C.VkPhysicalDevice, &u32, &FramebufferMixedSamplesCombinationNV) Result

@[inline]
pub fn get_physical_device_supported_framebuffer_mixed_samples_combinations_nv(physical_device C.VkPhysicalDevice,
	p_combination_count &u32,
	p_combinations &FramebufferMixedSamplesCombinationNV) Result {
	return C.vkGetPhysicalDeviceSupportedFramebufferMixedSamplesCombinationsNV(physical_device,
		p_combination_count, p_combinations)
}

pub const ext_fragment_shader_interlock_spec_version = 1
pub const ext_fragment_shader_interlock_extension_name = 'VK_EXT_fragment_shader_interlock'

pub type PhysicalDeviceFragmentShaderInterlockFeaturesEXT = C.VkPhysicalDeviceFragmentShaderInterlockFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceFragmentShaderInterlockFeaturesEXT {
pub mut:
	sType                              StructureType = StructureType.physical_device_fragment_shader_interlock_features_ext
	pNext                              voidptr       = unsafe { nil }
	fragmentShaderSampleInterlock      Bool32
	fragmentShaderPixelInterlock       Bool32
	fragmentShaderShadingRateInterlock Bool32
}

pub const ext_ycbcr_image_arrays_spec_version = 1
pub const ext_ycbcr_image_arrays_extension_name = 'VK_EXT_ycbcr_image_arrays'

pub type PhysicalDeviceYcbcrImageArraysFeaturesEXT = C.VkPhysicalDeviceYcbcrImageArraysFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceYcbcrImageArraysFeaturesEXT {
pub mut:
	sType            StructureType = StructureType.physical_device_ycbcr_image_arrays_features_ext
	pNext            voidptr       = unsafe { nil }
	ycbcrImageArrays Bool32
}

pub const ext_provoking_vertex_spec_version = 1
pub const ext_provoking_vertex_extension_name = 'VK_EXT_provoking_vertex'

pub enum ProvokingVertexModeEXT {
	first_vertex_ext = 0
	last_vertex_ext  = 1
	max_enum_ext     = max_int
}

pub type PhysicalDeviceProvokingVertexFeaturesEXT = C.VkPhysicalDeviceProvokingVertexFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceProvokingVertexFeaturesEXT {
pub mut:
	sType                                     StructureType = StructureType.physical_device_provoking_vertex_features_ext
	pNext                                     voidptr       = unsafe { nil }
	provokingVertexLast                       Bool32
	transformFeedbackPreservesProvokingVertex Bool32
}

pub type PhysicalDeviceProvokingVertexPropertiesEXT = C.VkPhysicalDeviceProvokingVertexPropertiesEXT

@[typedef]
pub struct C.VkPhysicalDeviceProvokingVertexPropertiesEXT {
pub mut:
	sType                                                StructureType = StructureType.physical_device_provoking_vertex_properties_ext
	pNext                                                voidptr       = unsafe { nil }
	provokingVertexModePerPipeline                       Bool32
	transformFeedbackPreservesTriangleFanProvokingVertex Bool32
}

pub type PipelineRasterizationProvokingVertexStateCreateInfoEXT = C.VkPipelineRasterizationProvokingVertexStateCreateInfoEXT

@[typedef]
pub struct C.VkPipelineRasterizationProvokingVertexStateCreateInfoEXT {
pub mut:
	sType               StructureType = StructureType.pipeline_rasterization_provoking_vertex_state_create_info_ext
	pNext               voidptr       = unsafe { nil }
	provokingVertexMode ProvokingVertexModeEXT
}

pub const ext_headless_surface_spec_version = 1
pub const ext_headless_surface_extension_name = 'VK_EXT_headless_surface'

pub type HeadlessSurfaceCreateFlagsEXT = u32
pub type HeadlessSurfaceCreateInfoEXT = C.VkHeadlessSurfaceCreateInfoEXT

@[typedef]
pub struct C.VkHeadlessSurfaceCreateInfoEXT {
pub mut:
	sType StructureType = StructureType.headless_surface_create_info_ext
	pNext voidptr       = unsafe { nil }
	flags HeadlessSurfaceCreateFlagsEXT
}

fn C.vkCreateHeadlessSurfaceEXT(C.VkInstance, &HeadlessSurfaceCreateInfoEXT, &AllocationCallbacks, C.VkSurfaceKHR) Result

pub type PFN_vkCreateHeadlessSurfaceEXT = fn (C.VkInstance, &HeadlessSurfaceCreateInfoEXT, &AllocationCallbacks, C.VkSurfaceKHR) Result

@[inline]
pub fn create_headless_surface_ext(instance C.VkInstance,
	p_create_info &HeadlessSurfaceCreateInfoEXT,
	p_allocator &AllocationCallbacks,
	p_surface C.VkSurfaceKHR) Result {
	return C.vkCreateHeadlessSurfaceEXT(instance, p_create_info, p_allocator, p_surface)
}

pub const ext_line_rasterization_spec_version = 1
pub const ext_line_rasterization_extension_name = 'VK_EXT_line_rasterization'

pub enum LineRasterizationModeEXT {
	default_ext            = 0
	rectangular_ext        = 1
	bresenham_ext          = 2
	rectangular_smooth_ext = 3
	max_enum_ext           = max_int
}

pub type PhysicalDeviceLineRasterizationFeaturesEXT = C.VkPhysicalDeviceLineRasterizationFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceLineRasterizationFeaturesEXT {
pub mut:
	sType                    StructureType = StructureType.physical_device_line_rasterization_features_ext
	pNext                    voidptr       = unsafe { nil }
	rectangularLines         Bool32
	bresenhamLines           Bool32
	smoothLines              Bool32
	stippledRectangularLines Bool32
	stippledBresenhamLines   Bool32
	stippledSmoothLines      Bool32
}

pub type PhysicalDeviceLineRasterizationPropertiesEXT = C.VkPhysicalDeviceLineRasterizationPropertiesEXT

@[typedef]
pub struct C.VkPhysicalDeviceLineRasterizationPropertiesEXT {
pub mut:
	sType                     StructureType = StructureType.physical_device_line_rasterization_properties_ext
	pNext                     voidptr       = unsafe { nil }
	lineSubPixelPrecisionBits u32
}

pub type PipelineRasterizationLineStateCreateInfoEXT = C.VkPipelineRasterizationLineStateCreateInfoEXT

@[typedef]
pub struct C.VkPipelineRasterizationLineStateCreateInfoEXT {
pub mut:
	sType                 StructureType = StructureType.pipeline_rasterization_line_state_create_info_ext
	pNext                 voidptr       = unsafe { nil }
	lineRasterizationMode LineRasterizationModeEXT
	stippledLineEnable    Bool32
	lineStippleFactor     u32
	lineStipplePattern    u16
}

fn C.vkCmdSetLineStippleEXT(C.VkCommandBuffer, u32, u16)

pub type PFN_vkCmdSetLineStippleEXT = fn (C.VkCommandBuffer, u32, u16)

@[inline]
pub fn cmd_set_line_stipple_ext(command_buffer C.VkCommandBuffer,
	line_stipple_factor u32,
	line_stipple_pattern u16) {
	C.vkCmdSetLineStippleEXT(command_buffer, line_stipple_factor, line_stipple_pattern)
}

pub const ext_shader_atomic_float_spec_version = 1
pub const ext_shader_atomic_float_extension_name = 'VK_EXT_shader_atomic_float'

pub type PhysicalDeviceShaderAtomicFloatFeaturesEXT = C.VkPhysicalDeviceShaderAtomicFloatFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceShaderAtomicFloatFeaturesEXT {
pub mut:
	sType                        StructureType = StructureType.physical_device_shader_atomic_float_features_ext
	pNext                        voidptr       = unsafe { nil }
	shaderBufferFloat32Atomics   Bool32
	shaderBufferFloat32AtomicAdd Bool32
	shaderBufferFloat64Atomics   Bool32
	shaderBufferFloat64AtomicAdd Bool32
	shaderSharedFloat32Atomics   Bool32
	shaderSharedFloat32AtomicAdd Bool32
	shaderSharedFloat64Atomics   Bool32
	shaderSharedFloat64AtomicAdd Bool32
	shaderImageFloat32Atomics    Bool32
	shaderImageFloat32AtomicAdd  Bool32
	sparseImageFloat32Atomics    Bool32
	sparseImageFloat32AtomicAdd  Bool32
}

pub const ext_host_query_reset_spec_version = 1
pub const ext_host_query_reset_extension_name = 'VK_EXT_host_query_reset'

pub type PhysicalDeviceHostQueryResetFeaturesEXT = C.VkPhysicalDeviceHostQueryResetFeatures

pub const ext_index_type_uint8_spec_version = 1
pub const ext_index_type_uint8_extension_name = 'VK_EXT_index_type_uint8'

pub type PhysicalDeviceIndexTypeUint8FeaturesEXT = C.VkPhysicalDeviceIndexTypeUint8FeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceIndexTypeUint8FeaturesEXT {
pub mut:
	sType          StructureType = StructureType.physical_device_index_type_uint8_features_ext
	pNext          voidptr       = unsafe { nil }
	indexTypeUint8 Bool32
}

pub const ext_extended_dynamic_state_spec_version = 1
pub const ext_extended_dynamic_state_extension_name = 'VK_EXT_extended_dynamic_state'

pub type PhysicalDeviceExtendedDynamicStateFeaturesEXT = C.VkPhysicalDeviceExtendedDynamicStateFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceExtendedDynamicStateFeaturesEXT {
pub mut:
	sType                StructureType = StructureType.physical_device_extended_dynamic_state_features_ext
	pNext                voidptr       = unsafe { nil }
	extendedDynamicState Bool32
}

pub const ext_host_image_copy_spec_version = 1
pub const ext_host_image_copy_extension_name = 'VK_EXT_host_image_copy'

pub enum HostImageCopyFlagBitsEXT {
	memcpy_ext   = int(0x00000001)
	max_enum_ext = max_int
}

pub type HostImageCopyFlagsEXT = u32
pub type PhysicalDeviceHostImageCopyFeaturesEXT = C.VkPhysicalDeviceHostImageCopyFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceHostImageCopyFeaturesEXT {
pub mut:
	sType         StructureType = StructureType.physical_device_host_image_copy_features_ext
	pNext         voidptr       = unsafe { nil }
	hostImageCopy Bool32
}

pub type PhysicalDeviceHostImageCopyPropertiesEXT = C.VkPhysicalDeviceHostImageCopyPropertiesEXT

@[typedef]
pub struct C.VkPhysicalDeviceHostImageCopyPropertiesEXT {
pub mut:
	sType                           StructureType = StructureType.physical_device_host_image_copy_properties_ext
	pNext                           voidptr       = unsafe { nil }
	copySrcLayoutCount              u32
	pCopySrcLayouts                 &ImageLayout
	copyDstLayoutCount              u32
	pCopyDstLayouts                 &ImageLayout
	optimalTilingLayoutUUID         [uuid_size]u8
	identicalMemoryTypeRequirements Bool32
}

pub type MemoryToImageCopyEXT = C.VkMemoryToImageCopyEXT

@[typedef]
pub struct C.VkMemoryToImageCopyEXT {
pub mut:
	sType             StructureType = StructureType.memory_to_image_copy_ext
	pNext             voidptr       = unsafe { nil }
	pHostPointer      voidptr
	memoryRowLength   u32
	memoryImageHeight u32
	imageSubresource  ImageSubresourceLayers
	imageOffset       Offset3D
	imageExtent       Extent3D
}

pub type ImageToMemoryCopyEXT = C.VkImageToMemoryCopyEXT

@[typedef]
pub struct C.VkImageToMemoryCopyEXT {
pub mut:
	sType             StructureType = StructureType.image_to_memory_copy_ext
	pNext             voidptr       = unsafe { nil }
	pHostPointer      voidptr
	memoryRowLength   u32
	memoryImageHeight u32
	imageSubresource  ImageSubresourceLayers
	imageOffset       Offset3D
	imageExtent       Extent3D
}

pub type CopyMemoryToImageInfoEXT = C.VkCopyMemoryToImageInfoEXT

@[typedef]
pub struct C.VkCopyMemoryToImageInfoEXT {
pub mut:
	sType          StructureType = StructureType.copy_memory_to_image_info_ext
	pNext          voidptr       = unsafe { nil }
	flags          HostImageCopyFlagsEXT
	dstImage       C.VkImage
	dstImageLayout ImageLayout
	regionCount    u32
	pRegions       &MemoryToImageCopyEXT
}

pub type CopyImageToMemoryInfoEXT = C.VkCopyImageToMemoryInfoEXT

@[typedef]
pub struct C.VkCopyImageToMemoryInfoEXT {
pub mut:
	sType          StructureType = StructureType.copy_image_to_memory_info_ext
	pNext          voidptr       = unsafe { nil }
	flags          HostImageCopyFlagsEXT
	srcImage       C.VkImage
	srcImageLayout ImageLayout
	regionCount    u32
	pRegions       &ImageToMemoryCopyEXT
}

pub type CopyImageToImageInfoEXT = C.VkCopyImageToImageInfoEXT

@[typedef]
pub struct C.VkCopyImageToImageInfoEXT {
pub mut:
	sType          StructureType = StructureType.copy_image_to_image_info_ext
	pNext          voidptr       = unsafe { nil }
	flags          HostImageCopyFlagsEXT
	srcImage       C.VkImage
	srcImageLayout ImageLayout
	dstImage       C.VkImage
	dstImageLayout ImageLayout
	regionCount    u32
	pRegions       &ImageCopy2
}

pub type HostImageLayoutTransitionInfoEXT = C.VkHostImageLayoutTransitionInfoEXT

@[typedef]
pub struct C.VkHostImageLayoutTransitionInfoEXT {
pub mut:
	sType            StructureType = StructureType.host_image_layout_transition_info_ext
	pNext            voidptr       = unsafe { nil }
	image            C.VkImage
	oldLayout        ImageLayout
	newLayout        ImageLayout
	subresourceRange ImageSubresourceRange
}

pub type SubresourceHostMemcpySizeEXT = C.VkSubresourceHostMemcpySizeEXT

@[typedef]
pub struct C.VkSubresourceHostMemcpySizeEXT {
pub mut:
	sType StructureType = StructureType.subresource_host_memcpy_size_ext
	pNext voidptr       = unsafe { nil }
	size  DeviceSize
}

pub type HostImageCopyDevicePerformanceQueryEXT = C.VkHostImageCopyDevicePerformanceQueryEXT

@[typedef]
pub struct C.VkHostImageCopyDevicePerformanceQueryEXT {
pub mut:
	sType                 StructureType = StructureType.host_image_copy_device_performance_query_ext
	pNext                 voidptr       = unsafe { nil }
	optimalDeviceAccess   Bool32
	identicalMemoryLayout Bool32
}

pub type SubresourceLayout2EXT = C.VkSubresourceLayout2KHR

pub type ImageSubresource2EXT = C.VkImageSubresource2KHR

fn C.vkCopyMemoryToImageEXT(C.VkDevice, &CopyMemoryToImageInfoEXT) Result

pub type PFN_vkCopyMemoryToImageEXT = fn (C.VkDevice, &CopyMemoryToImageInfoEXT) Result

@[inline]
pub fn copy_memory_to_image_ext(device C.VkDevice,
	p_copy_memory_to_image_info &CopyMemoryToImageInfoEXT) Result {
	return C.vkCopyMemoryToImageEXT(device, p_copy_memory_to_image_info)
}

fn C.vkCopyImageToMemoryEXT(C.VkDevice, &CopyImageToMemoryInfoEXT) Result

pub type PFN_vkCopyImageToMemoryEXT = fn (C.VkDevice, &CopyImageToMemoryInfoEXT) Result

@[inline]
pub fn copy_image_to_memory_ext(device C.VkDevice,
	p_copy_image_to_memory_info &CopyImageToMemoryInfoEXT) Result {
	return C.vkCopyImageToMemoryEXT(device, p_copy_image_to_memory_info)
}

fn C.vkCopyImageToImageEXT(C.VkDevice, &CopyImageToImageInfoEXT) Result

pub type PFN_vkCopyImageToImageEXT = fn (C.VkDevice, &CopyImageToImageInfoEXT) Result

@[inline]
pub fn copy_image_to_image_ext(device C.VkDevice,
	p_copy_image_to_image_info &CopyImageToImageInfoEXT) Result {
	return C.vkCopyImageToImageEXT(device, p_copy_image_to_image_info)
}

fn C.vkTransitionImageLayoutEXT(C.VkDevice, u32, &HostImageLayoutTransitionInfoEXT) Result

pub type PFN_vkTransitionImageLayoutEXT = fn (C.VkDevice, u32, &HostImageLayoutTransitionInfoEXT) Result

@[inline]
pub fn transition_image_layout_ext(device C.VkDevice,
	transition_count u32,
	p_transitions &HostImageLayoutTransitionInfoEXT) Result {
	return C.vkTransitionImageLayoutEXT(device, transition_count, p_transitions)
}

pub const ext_shader_atomic_float_2_spec_version = 1
pub const ext_shader_atomic_float_2_extension_name = 'VK_EXT_shader_atomic_float2'

pub type PhysicalDeviceShaderAtomicFloat2FeaturesEXT = C.VkPhysicalDeviceShaderAtomicFloat2FeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceShaderAtomicFloat2FeaturesEXT {
pub mut:
	sType                           StructureType = StructureType.physical_device_shader_atomic_float2_features_ext
	pNext                           voidptr       = unsafe { nil }
	shaderBufferFloat16Atomics      Bool32
	shaderBufferFloat16AtomicAdd    Bool32
	shaderBufferFloat16AtomicMinMax Bool32
	shaderBufferFloat32AtomicMinMax Bool32
	shaderBufferFloat64AtomicMinMax Bool32
	shaderSharedFloat16Atomics      Bool32
	shaderSharedFloat16AtomicAdd    Bool32
	shaderSharedFloat16AtomicMinMax Bool32
	shaderSharedFloat32AtomicMinMax Bool32
	shaderSharedFloat64AtomicMinMax Bool32
	shaderImageFloat32AtomicMinMax  Bool32
	sparseImageFloat32AtomicMinMax  Bool32
}

pub const ext_surface_maintenance_1_spec_version = 1
pub const ext_surface_maintenance_1_extension_name = 'VK_EXT_surface_maintenance1'

pub enum PresentScalingFlagBitsEXT {
	one_to_one_bit_ext           = int(0x00000001)
	aspect_ratio_stretch_bit_ext = int(0x00000002)
	stretch_bit_ext              = int(0x00000004)
	max_enum_ext                 = max_int
}

pub type PresentScalingFlagsEXT = u32

pub enum PresentGravityFlagBitsEXT {
	min_bit_ext      = int(0x00000001)
	max_bit_ext      = int(0x00000002)
	centered_bit_ext = int(0x00000004)
	max_enum_ext     = max_int
}

pub type PresentGravityFlagsEXT = u32
pub type SurfacePresentModeEXT = C.VkSurfacePresentModeEXT

@[typedef]
pub struct C.VkSurfacePresentModeEXT {
pub mut:
	sType       StructureType = StructureType.surface_present_mode_ext
	pNext       voidptr       = unsafe { nil }
	presentMode PresentModeKHR
}

pub type SurfacePresentScalingCapabilitiesEXT = C.VkSurfacePresentScalingCapabilitiesEXT

@[typedef]
pub struct C.VkSurfacePresentScalingCapabilitiesEXT {
pub mut:
	sType                    StructureType = StructureType.surface_present_scaling_capabilities_ext
	pNext                    voidptr       = unsafe { nil }
	supportedPresentScaling  PresentScalingFlagsEXT
	supportedPresentGravityX PresentGravityFlagsEXT
	supportedPresentGravityY PresentGravityFlagsEXT
	minScaledImageExtent     Extent2D
	maxScaledImageExtent     Extent2D
}

pub type SurfacePresentModeCompatibilityEXT = C.VkSurfacePresentModeCompatibilityEXT

@[typedef]
pub struct C.VkSurfacePresentModeCompatibilityEXT {
pub mut:
	sType            StructureType = StructureType.surface_present_mode_compatibility_ext
	pNext            voidptr       = unsafe { nil }
	presentModeCount u32
	pPresentModes    &PresentModeKHR
}

pub const ext_swapchain_maintenance_1_spec_version = 1
pub const ext_swapchain_maintenance_1_extension_name = 'VK_EXT_swapchain_maintenance1'

pub type PhysicalDeviceSwapchainMaintenance1FeaturesEXT = C.VkPhysicalDeviceSwapchainMaintenance1FeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceSwapchainMaintenance1FeaturesEXT {
pub mut:
	sType                 StructureType = StructureType.physical_device_swapchain_maintenance1_features_ext
	pNext                 voidptr       = unsafe { nil }
	swapchainMaintenance1 Bool32
}

pub type SwapchainPresentFenceInfoEXT = C.VkSwapchainPresentFenceInfoEXT

@[typedef]
pub struct C.VkSwapchainPresentFenceInfoEXT {
pub mut:
	sType          StructureType = StructureType.swapchain_present_fence_info_ext
	pNext          voidptr       = unsafe { nil }
	swapchainCount u32
	pFences        C.VkFence
}

pub type SwapchainPresentModesCreateInfoEXT = C.VkSwapchainPresentModesCreateInfoEXT

@[typedef]
pub struct C.VkSwapchainPresentModesCreateInfoEXT {
pub mut:
	sType            StructureType = StructureType.swapchain_present_modes_create_info_ext
	pNext            voidptr       = unsafe { nil }
	presentModeCount u32
	pPresentModes    &PresentModeKHR
}

pub type SwapchainPresentModeInfoEXT = C.VkSwapchainPresentModeInfoEXT

@[typedef]
pub struct C.VkSwapchainPresentModeInfoEXT {
pub mut:
	sType          StructureType = StructureType.swapchain_present_mode_info_ext
	pNext          voidptr       = unsafe { nil }
	swapchainCount u32
	pPresentModes  &PresentModeKHR
}

pub type SwapchainPresentScalingCreateInfoEXT = C.VkSwapchainPresentScalingCreateInfoEXT

@[typedef]
pub struct C.VkSwapchainPresentScalingCreateInfoEXT {
pub mut:
	sType           StructureType = StructureType.swapchain_present_scaling_create_info_ext
	pNext           voidptr       = unsafe { nil }
	scalingBehavior PresentScalingFlagsEXT
	presentGravityX PresentGravityFlagsEXT
	presentGravityY PresentGravityFlagsEXT
}

pub type ReleaseSwapchainImagesInfoEXT = C.VkReleaseSwapchainImagesInfoEXT

@[typedef]
pub struct C.VkReleaseSwapchainImagesInfoEXT {
pub mut:
	sType           StructureType = StructureType.release_swapchain_images_info_ext
	pNext           voidptr       = unsafe { nil }
	swapchain       C.VkSwapchainKHR
	imageIndexCount u32
	pImageIndices   &u32
}

fn C.vkReleaseSwapchainImagesEXT(C.VkDevice, &ReleaseSwapchainImagesInfoEXT) Result

pub type PFN_vkReleaseSwapchainImagesEXT = fn (C.VkDevice, &ReleaseSwapchainImagesInfoEXT) Result

@[inline]
pub fn release_swapchain_images_ext(device C.VkDevice,
	p_release_info &ReleaseSwapchainImagesInfoEXT) Result {
	return C.vkReleaseSwapchainImagesEXT(device, p_release_info)
}

pub const ext_shader_demote_to_helper_invocation_spec_version = 1
pub const ext_shader_demote_to_helper_invocation_extension_name = 'VK_EXT_shader_demote_to_helper_invocation'

pub type PhysicalDeviceShaderDemoteToHelperInvocationFeaturesEXT = C.VkPhysicalDeviceShaderDemoteToHelperInvocationFeatures

pub type C.VkIndirectCommandsLayoutNV = voidptr

pub const nv_device_generated_commands_spec_version = 3
pub const nv_device_generated_commands_extension_name = 'VK_NV_device_generated_commands'

pub enum IndirectCommandsTokenTypeNV {
	shader_group_nv    = 0
	state_flags_nv     = 1
	index_buffer_nv    = 2
	vertex_buffer_nv   = 3
	push_constant_nv   = 4
	draw_indexed_nv    = 5
	draw_nv            = 6
	draw_tasks_nv      = 7
	draw_mesh_tasks_nv = 1000328000
	pipeline_nv        = 1000428003
	dispatch_nv        = 1000428004
	max_enum_nv        = max_int
}

pub enum IndirectStateFlagBitsNV {
	frontface_bit_nv = int(0x00000001)
	max_enum_nv      = max_int
}

pub type IndirectStateFlagsNV = u32

pub enum IndirectCommandsLayoutUsageFlagBitsNV {
	explicit_preprocess_bit_nv = int(0x00000001)
	indexed_sequences_bit_nv   = int(0x00000002)
	unordered_sequences_bit_nv = int(0x00000004)
	max_enum_nv                = max_int
}

pub type IndirectCommandsLayoutUsageFlagsNV = u32
pub type PhysicalDeviceDeviceGeneratedCommandsPropertiesNV = C.VkPhysicalDeviceDeviceGeneratedCommandsPropertiesNV

@[typedef]
pub struct C.VkPhysicalDeviceDeviceGeneratedCommandsPropertiesNV {
pub mut:
	sType                                    StructureType = StructureType.physical_device_device_generated_commands_properties_nv
	pNext                                    voidptr       = unsafe { nil }
	maxGraphicsShaderGroupCount              u32
	maxIndirectSequenceCount                 u32
	maxIndirectCommandsTokenCount            u32
	maxIndirectCommandsStreamCount           u32
	maxIndirectCommandsTokenOffset           u32
	maxIndirectCommandsStreamStride          u32
	minSequencesCountBufferOffsetAlignment   u32
	minSequencesIndexBufferOffsetAlignment   u32
	minIndirectCommandsBufferOffsetAlignment u32
}

pub type PhysicalDeviceDeviceGeneratedCommandsFeaturesNV = C.VkPhysicalDeviceDeviceGeneratedCommandsFeaturesNV

@[typedef]
pub struct C.VkPhysicalDeviceDeviceGeneratedCommandsFeaturesNV {
pub mut:
	sType                   StructureType = StructureType.physical_device_device_generated_commands_features_nv
	pNext                   voidptr       = unsafe { nil }
	deviceGeneratedCommands Bool32
}

pub type GraphicsShaderGroupCreateInfoNV = C.VkGraphicsShaderGroupCreateInfoNV

@[typedef]
pub struct C.VkGraphicsShaderGroupCreateInfoNV {
pub mut:
	sType              StructureType = StructureType.graphics_shader_group_create_info_nv
	pNext              voidptr       = unsafe { nil }
	stageCount         u32
	pStages            &PipelineShaderStageCreateInfo
	pVertexInputState  &PipelineVertexInputStateCreateInfo
	pTessellationState &PipelineTessellationStateCreateInfo
}

pub type GraphicsPipelineShaderGroupsCreateInfoNV = C.VkGraphicsPipelineShaderGroupsCreateInfoNV

@[typedef]
pub struct C.VkGraphicsPipelineShaderGroupsCreateInfoNV {
pub mut:
	sType         StructureType = StructureType.graphics_pipeline_shader_groups_create_info_nv
	pNext         voidptr       = unsafe { nil }
	groupCount    u32
	pGroups       &GraphicsShaderGroupCreateInfoNV
	pipelineCount u32
	pPipelines    C.VkPipeline
}

pub type BindShaderGroupIndirectCommandNV = C.VkBindShaderGroupIndirectCommandNV

@[typedef]
pub struct C.VkBindShaderGroupIndirectCommandNV {
pub mut:
	groupIndex u32
}

pub type BindIndexBufferIndirectCommandNV = C.VkBindIndexBufferIndirectCommandNV

@[typedef]
pub struct C.VkBindIndexBufferIndirectCommandNV {
pub mut:
	bufferAddress DeviceAddress
	size          u32
	indexType     IndexType
}

pub type BindVertexBufferIndirectCommandNV = C.VkBindVertexBufferIndirectCommandNV

@[typedef]
pub struct C.VkBindVertexBufferIndirectCommandNV {
pub mut:
	bufferAddress DeviceAddress
	size          u32
	stride        u32
}

pub type SetStateFlagsIndirectCommandNV = C.VkSetStateFlagsIndirectCommandNV

@[typedef]
pub struct C.VkSetStateFlagsIndirectCommandNV {
pub mut:
	data u32
}

pub type IndirectCommandsStreamNV = C.VkIndirectCommandsStreamNV

@[typedef]
pub struct C.VkIndirectCommandsStreamNV {
pub mut:
	buffer C.VkBuffer
	offset DeviceSize
}

pub type IndirectCommandsLayoutTokenNV = C.VkIndirectCommandsLayoutTokenNV

@[typedef]
pub struct C.VkIndirectCommandsLayoutTokenNV {
pub mut:
	sType                        StructureType = StructureType.indirect_commands_layout_token_nv
	pNext                        voidptr       = unsafe { nil }
	tokenType                    IndirectCommandsTokenTypeNV
	stream                       u32
	offset                       u32
	vertexBindingUnit            u32
	vertexDynamicStride          Bool32
	pushconstantPipelineLayout   C.VkPipelineLayout
	pushconstantShaderStageFlags ShaderStageFlags
	pushconstantOffset           u32
	pushconstantSize             u32
	indirectStateFlags           IndirectStateFlagsNV
	indexTypeCount               u32
	pIndexTypes                  &IndexType
	pIndexTypeValues             &u32
}

pub type IndirectCommandsLayoutCreateInfoNV = C.VkIndirectCommandsLayoutCreateInfoNV

@[typedef]
pub struct C.VkIndirectCommandsLayoutCreateInfoNV {
pub mut:
	sType             StructureType = StructureType.indirect_commands_layout_create_info_nv
	pNext             voidptr       = unsafe { nil }
	flags             IndirectCommandsLayoutUsageFlagsNV
	pipelineBindPoint PipelineBindPoint
	tokenCount        u32
	pTokens           &IndirectCommandsLayoutTokenNV
	streamCount       u32
	pStreamStrides    &u32
}

pub type GeneratedCommandsInfoNV = C.VkGeneratedCommandsInfoNV

@[typedef]
pub struct C.VkGeneratedCommandsInfoNV {
pub mut:
	sType                  StructureType = StructureType.generated_commands_info_nv
	pNext                  voidptr       = unsafe { nil }
	pipelineBindPoint      PipelineBindPoint
	pipeline               C.VkPipeline
	indirectCommandsLayout C.VkIndirectCommandsLayoutNV
	streamCount            u32
	pStreams               &IndirectCommandsStreamNV
	sequencesCount         u32
	preprocessBuffer       C.VkBuffer
	preprocessOffset       DeviceSize
	preprocessSize         DeviceSize
	sequencesCountBuffer   C.VkBuffer
	sequencesCountOffset   DeviceSize
	sequencesIndexBuffer   C.VkBuffer
	sequencesIndexOffset   DeviceSize
}

pub type GeneratedCommandsMemoryRequirementsInfoNV = C.VkGeneratedCommandsMemoryRequirementsInfoNV

@[typedef]
pub struct C.VkGeneratedCommandsMemoryRequirementsInfoNV {
pub mut:
	sType                  StructureType = StructureType.generated_commands_memory_requirements_info_nv
	pNext                  voidptr       = unsafe { nil }
	pipelineBindPoint      PipelineBindPoint
	pipeline               C.VkPipeline
	indirectCommandsLayout C.VkIndirectCommandsLayoutNV
	maxSequencesCount      u32
}

fn C.vkGetGeneratedCommandsMemoryRequirementsNV(C.VkDevice, &GeneratedCommandsMemoryRequirementsInfoNV, &MemoryRequirements2)

pub type PFN_vkGetGeneratedCommandsMemoryRequirementsNV = fn (C.VkDevice, &GeneratedCommandsMemoryRequirementsInfoNV, &MemoryRequirements2)

@[inline]
pub fn get_generated_commands_memory_requirements_nv(device C.VkDevice,
	p_info &GeneratedCommandsMemoryRequirementsInfoNV,
	p_memory_requirements &MemoryRequirements2) {
	C.vkGetGeneratedCommandsMemoryRequirementsNV(device, p_info, p_memory_requirements)
}

fn C.vkCmdPreprocessGeneratedCommandsNV(C.VkCommandBuffer, &GeneratedCommandsInfoNV)

pub type PFN_vkCmdPreprocessGeneratedCommandsNV = fn (C.VkCommandBuffer, &GeneratedCommandsInfoNV)

@[inline]
pub fn cmd_preprocess_generated_commands_nv(command_buffer C.VkCommandBuffer,
	p_generated_commands_info &GeneratedCommandsInfoNV) {
	C.vkCmdPreprocessGeneratedCommandsNV(command_buffer, p_generated_commands_info)
}

fn C.vkCmdExecuteGeneratedCommandsNV(C.VkCommandBuffer, Bool32, &GeneratedCommandsInfoNV)

pub type PFN_vkCmdExecuteGeneratedCommandsNV = fn (C.VkCommandBuffer, Bool32, &GeneratedCommandsInfoNV)

@[inline]
pub fn cmd_execute_generated_commands_nv(command_buffer C.VkCommandBuffer,
	is_preprocessed Bool32,
	p_generated_commands_info &GeneratedCommandsInfoNV) {
	C.vkCmdExecuteGeneratedCommandsNV(command_buffer, is_preprocessed, p_generated_commands_info)
}

fn C.vkCmdBindPipelineShaderGroupNV(C.VkCommandBuffer, PipelineBindPoint, C.VkPipeline, u32)

pub type PFN_vkCmdBindPipelineShaderGroupNV = fn (C.VkCommandBuffer, PipelineBindPoint, C.VkPipeline, u32)

@[inline]
pub fn cmd_bind_pipeline_shader_group_nv(command_buffer C.VkCommandBuffer,
	pipeline_bind_point PipelineBindPoint,
	pipeline C.VkPipeline,
	group_index u32) {
	C.vkCmdBindPipelineShaderGroupNV(command_buffer, pipeline_bind_point, pipeline, group_index)
}

fn C.vkCreateIndirectCommandsLayoutNV(C.VkDevice, &IndirectCommandsLayoutCreateInfoNV, &AllocationCallbacks, C.VkIndirectCommandsLayoutNV) Result

pub type PFN_vkCreateIndirectCommandsLayoutNV = fn (C.VkDevice, &IndirectCommandsLayoutCreateInfoNV, &AllocationCallbacks, C.VkIndirectCommandsLayoutNV) Result

@[inline]
pub fn create_indirect_commands_layout_nv(device C.VkDevice,
	p_create_info &IndirectCommandsLayoutCreateInfoNV,
	p_allocator &AllocationCallbacks,
	p_indirect_commands_layout C.VkIndirectCommandsLayoutNV) Result {
	return C.vkCreateIndirectCommandsLayoutNV(device, p_create_info, p_allocator, p_indirect_commands_layout)
}

fn C.vkDestroyIndirectCommandsLayoutNV(C.VkDevice, C.VkIndirectCommandsLayoutNV, &AllocationCallbacks)

pub type PFN_vkDestroyIndirectCommandsLayoutNV = fn (C.VkDevice, C.VkIndirectCommandsLayoutNV, &AllocationCallbacks)

@[inline]
pub fn destroy_indirect_commands_layout_nv(device C.VkDevice,
	indirect_commands_layout C.VkIndirectCommandsLayoutNV,
	p_allocator &AllocationCallbacks) {
	C.vkDestroyIndirectCommandsLayoutNV(device, indirect_commands_layout, p_allocator)
}

pub const nv_inherited_viewport_scissor_spec_version = 1
pub const nv_inherited_viewport_scissor_extension_name = 'VK_NV_inherited_viewport_scissor'

pub type PhysicalDeviceInheritedViewportScissorFeaturesNV = C.VkPhysicalDeviceInheritedViewportScissorFeaturesNV

@[typedef]
pub struct C.VkPhysicalDeviceInheritedViewportScissorFeaturesNV {
pub mut:
	sType                      StructureType = StructureType.physical_device_inherited_viewport_scissor_features_nv
	pNext                      voidptr       = unsafe { nil }
	inheritedViewportScissor2D Bool32
}

pub type CommandBufferInheritanceViewportScissorInfoNV = C.VkCommandBufferInheritanceViewportScissorInfoNV

@[typedef]
pub struct C.VkCommandBufferInheritanceViewportScissorInfoNV {
pub mut:
	sType              StructureType = StructureType.command_buffer_inheritance_viewport_scissor_info_nv
	pNext              voidptr       = unsafe { nil }
	viewportScissor2D  Bool32
	viewportDepthCount u32
	pViewportDepths    &Viewport
}

pub const ext_texel_buffer_alignment_spec_version = 1
pub const ext_texel_buffer_alignment_extension_name = 'VK_EXT_texel_buffer_alignment'

pub type PhysicalDeviceTexelBufferAlignmentFeaturesEXT = C.VkPhysicalDeviceTexelBufferAlignmentFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceTexelBufferAlignmentFeaturesEXT {
pub mut:
	sType                StructureType = StructureType.physical_device_texel_buffer_alignment_features_ext
	pNext                voidptr       = unsafe { nil }
	texelBufferAlignment Bool32
}

pub type PhysicalDeviceTexelBufferAlignmentPropertiesEXT = C.VkPhysicalDeviceTexelBufferAlignmentProperties

pub const qcom_render_pass_transform_spec_version = 4
pub const qcom_render_pass_transform_extension_name = 'VK_QCOM_render_pass_transform'

pub type RenderPassTransformBeginInfoQCOM = C.VkRenderPassTransformBeginInfoQCOM

@[typedef]
pub struct C.VkRenderPassTransformBeginInfoQCOM {
pub mut:
	sType     StructureType = StructureType.render_pass_transform_begin_info_qcom
	pNext     voidptr       = unsafe { nil }
	transform SurfaceTransformFlagBitsKHR
}

pub type CommandBufferInheritanceRenderPassTransformInfoQCOM = C.VkCommandBufferInheritanceRenderPassTransformInfoQCOM

@[typedef]
pub struct C.VkCommandBufferInheritanceRenderPassTransformInfoQCOM {
pub mut:
	sType      StructureType = StructureType.command_buffer_inheritance_render_pass_transform_info_qcom
	pNext      voidptr       = unsafe { nil }
	transform  SurfaceTransformFlagBitsKHR
	renderArea Rect2D
}

pub const ext_depth_bias_control_spec_version = 1
pub const ext_depth_bias_control_extension_name = 'VK_EXT_depth_bias_control'

pub enum DepthBiasRepresentationEXT {
	least_representable_value_format_ext      = 0
	least_representable_value_force_unorm_ext = 1
	float_ext                                 = 2
	max_enum_ext                              = max_int
}

pub type PhysicalDeviceDepthBiasControlFeaturesEXT = C.VkPhysicalDeviceDepthBiasControlFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceDepthBiasControlFeaturesEXT {
pub mut:
	sType                                           StructureType = StructureType.physical_device_depth_bias_control_features_ext
	pNext                                           voidptr       = unsafe { nil }
	depthBiasControl                                Bool32
	leastRepresentableValueForceUnormRepresentation Bool32
	floatRepresentation                             Bool32
	depthBiasExact                                  Bool32
}

pub type DepthBiasInfoEXT = C.VkDepthBiasInfoEXT

@[typedef]
pub struct C.VkDepthBiasInfoEXT {
pub mut:
	sType                   StructureType = StructureType.depth_bias_info_ext
	pNext                   voidptr       = unsafe { nil }
	depthBiasConstantFactor f32
	depthBiasClamp          f32
	depthBiasSlopeFactor    f32
}

pub type DepthBiasRepresentationInfoEXT = C.VkDepthBiasRepresentationInfoEXT

@[typedef]
pub struct C.VkDepthBiasRepresentationInfoEXT {
pub mut:
	sType                   StructureType = StructureType.depth_bias_representation_info_ext
	pNext                   voidptr       = unsafe { nil }
	depthBiasRepresentation DepthBiasRepresentationEXT
	depthBiasExact          Bool32
}

fn C.vkCmdSetDepthBias2EXT(C.VkCommandBuffer, &DepthBiasInfoEXT)

pub type PFN_vkCmdSetDepthBias2EXT = fn (C.VkCommandBuffer, &DepthBiasInfoEXT)

@[inline]
pub fn cmd_set_depth_bias2_ext(command_buffer C.VkCommandBuffer,
	p_depth_bias_info &DepthBiasInfoEXT) {
	C.vkCmdSetDepthBias2EXT(command_buffer, p_depth_bias_info)
}

pub const ext_device_memory_report_spec_version = 2
pub const ext_device_memory_report_extension_name = 'VK_EXT_device_memory_report'

pub enum DeviceMemoryReportEventTypeEXT {
	allocate_ext          = 0
	free_ext              = 1
	import_ext            = 2
	unimport_ext          = 3
	allocation_failed_ext = 4
	max_enum_ext          = max_int
}

pub type DeviceMemoryReportFlagsEXT = u32
pub type PhysicalDeviceDeviceMemoryReportFeaturesEXT = C.VkPhysicalDeviceDeviceMemoryReportFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceDeviceMemoryReportFeaturesEXT {
pub mut:
	sType              StructureType = StructureType.physical_device_device_memory_report_features_ext
	pNext              voidptr       = unsafe { nil }
	deviceMemoryReport Bool32
}

pub type DeviceMemoryReportCallbackDataEXT = C.VkDeviceMemoryReportCallbackDataEXT

@[typedef]
pub struct C.VkDeviceMemoryReportCallbackDataEXT {
pub mut:
	sType          StructureType = StructureType.device_memory_report_callback_data_ext
	pNext          voidptr       = unsafe { nil }
	flags          DeviceMemoryReportFlagsEXT
	type           DeviceMemoryReportEventTypeEXT
	memoryObjectId u64
	size           DeviceSize
	objectType     ObjectType
	objectHandle   u64
	heapIndex      u32
}

pub type PFN_vkDeviceMemoryReportCallbackEXT = fn (pCallbackData &DeviceMemoryReportCallbackDataEXT, pUserData voidptr)

pub type DeviceDeviceMemoryReportCreateInfoEXT = C.VkDeviceDeviceMemoryReportCreateInfoEXT

@[typedef]
pub struct C.VkDeviceDeviceMemoryReportCreateInfoEXT {
pub mut:
	sType           StructureType = StructureType.device_device_memory_report_create_info_ext
	pNext           voidptr       = unsafe { nil }
	flags           DeviceMemoryReportFlagsEXT
	pfnUserCallback PFN_vkDeviceMemoryReportCallbackEXT = unsafe { nil }
	pUserData       voidptr = unsafe { nil }
}

pub const ext_acquire_drm_display_spec_version = 1
pub const ext_acquire_drm_display_extension_name = 'VK_EXT_acquire_drm_display'

fn C.vkAcquireDrmDisplayEXT(C.VkPhysicalDevice, i32, C.VkDisplayKHR) Result

pub type PFN_vkAcquireDrmDisplayEXT = fn (C.VkPhysicalDevice, i32, C.VkDisplayKHR) Result

@[inline]
pub fn acquire_drm_display_ext(physical_device C.VkPhysicalDevice,
	drm_fd i32,
	display C.VkDisplayKHR) Result {
	return C.vkAcquireDrmDisplayEXT(physical_device, drm_fd, display)
}

fn C.vkGetDrmDisplayEXT(C.VkPhysicalDevice, i32, u32, C.VkDisplayKHR) Result

pub type PFN_vkGetDrmDisplayEXT = fn (C.VkPhysicalDevice, i32, u32, C.VkDisplayKHR) Result

@[inline]
pub fn get_drm_display_ext(physical_device C.VkPhysicalDevice,
	drm_fd i32,
	connector_id u32,
	display C.VkDisplayKHR) Result {
	return C.vkGetDrmDisplayEXT(physical_device, drm_fd, connector_id, display)
}

pub const ext_robustness_2_spec_version = 1
pub const ext_robustness_2_extension_name = 'VK_EXT_robustness2'

pub type PhysicalDeviceRobustness2FeaturesEXT = C.VkPhysicalDeviceRobustness2FeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceRobustness2FeaturesEXT {
pub mut:
	sType               StructureType = StructureType.physical_device_robustness2_features_ext
	pNext               voidptr       = unsafe { nil }
	robustBufferAccess2 Bool32
	robustImageAccess2  Bool32
	nullDescriptor      Bool32
}

pub type PhysicalDeviceRobustness2PropertiesEXT = C.VkPhysicalDeviceRobustness2PropertiesEXT

@[typedef]
pub struct C.VkPhysicalDeviceRobustness2PropertiesEXT {
pub mut:
	sType                                  StructureType = StructureType.physical_device_robustness2_properties_ext
	pNext                                  voidptr       = unsafe { nil }
	robustStorageBufferAccessSizeAlignment DeviceSize
	robustUniformBufferAccessSizeAlignment DeviceSize
}

pub const ext_custom_border_color_spec_version = 12
pub const ext_custom_border_color_extension_name = 'VK_EXT_custom_border_color'

pub type SamplerCustomBorderColorCreateInfoEXT = C.VkSamplerCustomBorderColorCreateInfoEXT

@[typedef]
pub struct C.VkSamplerCustomBorderColorCreateInfoEXT {
pub mut:
	sType             StructureType = StructureType.sampler_custom_border_color_create_info_ext
	pNext             voidptr       = unsafe { nil }
	customBorderColor ClearColorValue
	format            Format
}

pub type PhysicalDeviceCustomBorderColorPropertiesEXT = C.VkPhysicalDeviceCustomBorderColorPropertiesEXT

@[typedef]
pub struct C.VkPhysicalDeviceCustomBorderColorPropertiesEXT {
pub mut:
	sType                        StructureType = StructureType.physical_device_custom_border_color_properties_ext
	pNext                        voidptr       = unsafe { nil }
	maxCustomBorderColorSamplers u32
}

pub type PhysicalDeviceCustomBorderColorFeaturesEXT = C.VkPhysicalDeviceCustomBorderColorFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceCustomBorderColorFeaturesEXT {
pub mut:
	sType                          StructureType = StructureType.physical_device_custom_border_color_features_ext
	pNext                          voidptr       = unsafe { nil }
	customBorderColors             Bool32
	customBorderColorWithoutFormat Bool32
}

pub const google_user_type_spec_version = 1
pub const google_user_type_extension_name = 'VK_GOOGE_user_type'

pub const nv_present_barrier_spec_version = 1
pub const nv_present_barrier_extension_name = 'VK_NV_present_barrier'

pub type PhysicalDevicePresentBarrierFeaturesNV = C.VkPhysicalDevicePresentBarrierFeaturesNV

@[typedef]
pub struct C.VkPhysicalDevicePresentBarrierFeaturesNV {
pub mut:
	sType          StructureType = StructureType.physical_device_present_barrier_features_nv
	pNext          voidptr       = unsafe { nil }
	presentBarrier Bool32
}

pub type SurfaceCapabilitiesPresentBarrierNV = C.VkSurfaceCapabilitiesPresentBarrierNV

@[typedef]
pub struct C.VkSurfaceCapabilitiesPresentBarrierNV {
pub mut:
	sType                   StructureType = StructureType.surface_capabilities_present_barrier_nv
	pNext                   voidptr       = unsafe { nil }
	presentBarrierSupported Bool32
}

pub type SwapchainPresentBarrierCreateInfoNV = C.VkSwapchainPresentBarrierCreateInfoNV

@[typedef]
pub struct C.VkSwapchainPresentBarrierCreateInfoNV {
pub mut:
	sType                StructureType = StructureType.swapchain_present_barrier_create_info_nv
	pNext                voidptr       = unsafe { nil }
	presentBarrierEnable Bool32
}

pub type PrivateDataSlotEXT = voidptr

pub const ext_private_data_spec_version = 1
pub const ext_private_data_extension_name = 'VK_EXT_private_data'

pub type PrivateDataSlotCreateFlagsEXT = u32
pub type PhysicalDevicePrivateDataFeaturesEXT = C.VkPhysicalDevicePrivateDataFeatures

pub type DevicePrivateDataCreateInfoEXT = C.VkDevicePrivateDataCreateInfo

pub type PrivateDataSlotCreateInfoEXT = C.VkPrivateDataSlotCreateInfo

pub const ext_pipeline_creation_cache_control_spec_version = 3
pub const ext_pipeline_creation_cache_control_extension_name = 'VK_EXT_pipeline_creation_cache_control'

pub type PhysicalDevicePipelineCreationCacheControlFeaturesEXT = C.VkPhysicalDevicePipelineCreationCacheControlFeatures

pub const nv_device_diagnostics_config_spec_version = 2
pub const nv_device_diagnostics_config_extension_name = 'VK_NV_device_diagnostics_config'

pub enum DeviceDiagnosticsConfigFlagBitsNV {
	enable_shader_debug_info_bit_nv      = int(0x00000001)
	enable_resource_tracking_bit_nv      = int(0x00000002)
	enable_automatic_checkpoints_bit_nv  = int(0x00000004)
	enable_shader_error_reporting_bit_nv = int(0x00000008)
	max_enum_nv                          = max_int
}

pub type DeviceDiagnosticsConfigFlagsNV = u32
pub type PhysicalDeviceDiagnosticsConfigFeaturesNV = C.VkPhysicalDeviceDiagnosticsConfigFeaturesNV

@[typedef]
pub struct C.VkPhysicalDeviceDiagnosticsConfigFeaturesNV {
pub mut:
	sType             StructureType = StructureType.physical_device_diagnostics_config_features_nv
	pNext             voidptr       = unsafe { nil }
	diagnosticsConfig Bool32
}

pub type DeviceDiagnosticsConfigCreateInfoNV = C.VkDeviceDiagnosticsConfigCreateInfoNV

@[typedef]
pub struct C.VkDeviceDiagnosticsConfigCreateInfoNV {
pub mut:
	sType StructureType = StructureType.device_diagnostics_config_create_info_nv
	pNext voidptr       = unsafe { nil }
	flags DeviceDiagnosticsConfigFlagsNV
}

pub const qcom_render_pass_store_ops_spec_version = 2
pub const qcom_render_pass_store_ops_extension_name = 'VK_QCOM_render_pass_store_ops'

pub type C.VkCudaModuleNV = voidptr
pub type C.VkCudaFunctionNV = voidptr

pub const nv_cuda_kernel_launch_spec_version = 2
pub const nv_cuda_kernel_launch_extension_name = 'VK_NV_cuda_kernel_launch'

pub type CudaModuleCreateInfoNV = C.VkCudaModuleCreateInfoNV

@[typedef]
pub struct C.VkCudaModuleCreateInfoNV {
pub mut:
	sType    StructureType = StructureType.cuda_module_create_info_nv
	pNext    voidptr       = unsafe { nil }
	dataSize usize
	pData    voidptr
}

pub type CudaFunctionCreateInfoNV = C.VkCudaFunctionCreateInfoNV

@[typedef]
pub struct C.VkCudaFunctionCreateInfoNV {
pub mut:
	sType    StructureType = StructureType.cuda_function_create_info_nv
	pNext    voidptr       = unsafe { nil }
	vkmodule C.VkCudaModuleNV
	pName    &char
}

pub type CudaLaunchInfoNV = C.VkCudaLaunchInfoNV

@[typedef]
pub struct C.VkCudaLaunchInfoNV {
pub mut:
	sType          StructureType = StructureType.cuda_launch_info_nv
	pNext          voidptr       = unsafe { nil }
	function       C.VkCudaFunctionNV
	gridDimX       u32
	gridDimY       u32
	gridDimZ       u32
	blockDimX      u32
	blockDimY      u32
	blockDimZ      u32
	sharedMemBytes u32
	paramCount     usize
	pParams        &&voidptr
	extraCount     usize
	pExtras        &&voidptr
}

pub type PhysicalDeviceCudaKernelLaunchFeaturesNV = C.VkPhysicalDeviceCudaKernelLaunchFeaturesNV

@[typedef]
pub struct C.VkPhysicalDeviceCudaKernelLaunchFeaturesNV {
pub mut:
	sType                    StructureType = StructureType.physical_device_cuda_kernel_launch_features_nv
	pNext                    voidptr       = unsafe { nil }
	cudaKernelLaunchFeatures Bool32
}

pub type PhysicalDeviceCudaKernelLaunchPropertiesNV = C.VkPhysicalDeviceCudaKernelLaunchPropertiesNV

@[typedef]
pub struct C.VkPhysicalDeviceCudaKernelLaunchPropertiesNV {
pub mut:
	sType                  StructureType = StructureType.physical_device_cuda_kernel_launch_properties_nv
	pNext                  voidptr       = unsafe { nil }
	computeCapabilityMinor u32
	computeCapabilityMajor u32
}

fn C.vkCreateCudaModuleNV(C.VkDevice, &CudaModuleCreateInfoNV, &AllocationCallbacks, C.VkCudaModuleNV) Result

pub type PFN_vkCreateCudaModuleNV = fn (C.VkDevice, &CudaModuleCreateInfoNV, &AllocationCallbacks, C.VkCudaModuleNV) Result

@[inline]
pub fn create_cuda_module_nv(device C.VkDevice,
	p_create_info &CudaModuleCreateInfoNV,
	p_allocator &AllocationCallbacks,
	p_module C.VkCudaModuleNV) Result {
	return C.vkCreateCudaModuleNV(device, p_create_info, p_allocator, p_module)
}

fn C.vkGetCudaModuleCacheNV(C.VkDevice, C.VkCudaModuleNV, &usize, voidptr) Result

pub type PFN_vkGetCudaModuleCacheNV = fn (C.VkDevice, C.VkCudaModuleNV, &usize, voidptr) Result

@[inline]
pub fn get_cuda_module_cache_nv(device C.VkDevice,
	vkmodule C.VkCudaModuleNV,
	p_cache_size &usize,
	p_cache_data voidptr) Result {
	return C.vkGetCudaModuleCacheNV(device, vkmodule, p_cache_size, p_cache_data)
}

fn C.vkCreateCudaFunctionNV(C.VkDevice, &CudaFunctionCreateInfoNV, &AllocationCallbacks, C.VkCudaFunctionNV) Result

pub type PFN_vkCreateCudaFunctionNV = fn (C.VkDevice, &CudaFunctionCreateInfoNV, &AllocationCallbacks, C.VkCudaFunctionNV) Result

@[inline]
pub fn create_cuda_function_nv(device C.VkDevice,
	p_create_info &CudaFunctionCreateInfoNV,
	p_allocator &AllocationCallbacks,
	p_function C.VkCudaFunctionNV) Result {
	return C.vkCreateCudaFunctionNV(device, p_create_info, p_allocator, p_function)
}

fn C.vkDestroyCudaModuleNV(C.VkDevice, C.VkCudaModuleNV, &AllocationCallbacks)

pub type PFN_vkDestroyCudaModuleNV = fn (C.VkDevice, C.VkCudaModuleNV, &AllocationCallbacks)

@[inline]
pub fn destroy_cuda_module_nv(device C.VkDevice,
	vkmodule C.VkCudaModuleNV,
	p_allocator &AllocationCallbacks) {
	C.vkDestroyCudaModuleNV(device, vkmodule, p_allocator)
}

fn C.vkDestroyCudaFunctionNV(C.VkDevice, C.VkCudaFunctionNV, &AllocationCallbacks)

pub type PFN_vkDestroyCudaFunctionNV = fn (C.VkDevice, C.VkCudaFunctionNV, &AllocationCallbacks)

@[inline]
pub fn destroy_cuda_function_nv(device C.VkDevice,
	function C.VkCudaFunctionNV,
	p_allocator &AllocationCallbacks) {
	C.vkDestroyCudaFunctionNV(device, function, p_allocator)
}

fn C.vkCmdCudaLaunchKernelNV(C.VkCommandBuffer, &CudaLaunchInfoNV)

pub type PFN_vkCmdCudaLaunchKernelNV = fn (C.VkCommandBuffer, &CudaLaunchInfoNV)

@[inline]
pub fn cmd_cuda_launch_kernel_nv(command_buffer C.VkCommandBuffer,
	p_launch_info &CudaLaunchInfoNV) {
	C.vkCmdCudaLaunchKernelNV(command_buffer, p_launch_info)
}

pub const nv_low_latency_spec_version = 1
pub const nv_low_latency_extension_name = 'VK_NV_low_latency'

pub type QueryLowLatencySupportNV = C.VkQueryLowLatencySupportNV

@[typedef]
pub struct C.VkQueryLowLatencySupportNV {
pub mut:
	sType                  StructureType = StructureType.query_low_latency_support_nv
	pNext                  voidptr       = unsafe { nil }
	pQueriedLowLatencyData voidptr
}

pub type C.VkAccelerationStructureKHR = voidptr

pub const ext_descriptor_buffer_spec_version = 1
pub const ext_descriptor_buffer_extension_name = 'VK_EXT_descriptor_buffer'

pub type PhysicalDeviceDescriptorBufferPropertiesEXT = C.VkPhysicalDeviceDescriptorBufferPropertiesEXT

@[typedef]
pub struct C.VkPhysicalDeviceDescriptorBufferPropertiesEXT {
pub mut:
	sType                                                StructureType = StructureType.physical_device_descriptor_buffer_properties_ext
	pNext                                                voidptr       = unsafe { nil }
	combinedImageSamplerDescriptorSingleArray            Bool32
	bufferlessPushDescriptors                            Bool32
	allowSamplerImageViewPostSubmitCreation              Bool32
	descriptorBufferOffsetAlignment                      DeviceSize
	maxDescriptorBufferBindings                          u32
	maxResourceDescriptorBufferBindings                  u32
	maxSamplerDescriptorBufferBindings                   u32
	maxEmbeddedImmutableSamplerBindings                  u32
	maxEmbeddedImmutableSamplers                         u32
	bufferCaptureReplayDescriptorDataSize                usize
	imageCaptureReplayDescriptorDataSize                 usize
	imageViewCaptureReplayDescriptorDataSize             usize
	samplerCaptureReplayDescriptorDataSize               usize
	accelerationStructureCaptureReplayDescriptorDataSize usize
	samplerDescriptorSize                                usize
	combinedImageSamplerDescriptorSize                   usize
	sampledImageDescriptorSize                           usize
	storageImageDescriptorSize                           usize
	uniformTexelBufferDescriptorSize                     usize
	robustUniformTexelBufferDescriptorSize               usize
	storageTexelBufferDescriptorSize                     usize
	robustStorageTexelBufferDescriptorSize               usize
	uniformBufferDescriptorSize                          usize
	robustUniformBufferDescriptorSize                    usize
	storageBufferDescriptorSize                          usize
	robustStorageBufferDescriptorSize                    usize
	inputAttachmentDescriptorSize                        usize
	accelerationStructureDescriptorSize                  usize
	maxSamplerDescriptorBufferRange                      DeviceSize
	maxResourceDescriptorBufferRange                     DeviceSize
	samplerDescriptorBufferAddressSpaceSize              DeviceSize
	resourceDescriptorBufferAddressSpaceSize             DeviceSize
	descriptorBufferAddressSpaceSize                     DeviceSize
}

pub type PhysicalDeviceDescriptorBufferDensityMapPropertiesEXT = C.VkPhysicalDeviceDescriptorBufferDensityMapPropertiesEXT

@[typedef]
pub struct C.VkPhysicalDeviceDescriptorBufferDensityMapPropertiesEXT {
pub mut:
	sType                                        StructureType = StructureType.physical_device_descriptor_buffer_density_map_properties_ext
	pNext                                        voidptr       = unsafe { nil }
	combinedImageSamplerDensityMapDescriptorSize usize
}

pub type PhysicalDeviceDescriptorBufferFeaturesEXT = C.VkPhysicalDeviceDescriptorBufferFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceDescriptorBufferFeaturesEXT {
pub mut:
	sType                              StructureType = StructureType.physical_device_descriptor_buffer_features_ext
	pNext                              voidptr       = unsafe { nil }
	descriptorBuffer                   Bool32
	descriptorBufferCaptureReplay      Bool32
	descriptorBufferImageLayoutIgnored Bool32
	descriptorBufferPushDescriptors    Bool32
}

pub type DescriptorAddressInfoEXT = C.VkDescriptorAddressInfoEXT

@[typedef]
pub struct C.VkDescriptorAddressInfoEXT {
pub mut:
	sType   StructureType = StructureType.descriptor_address_info_ext
	pNext   voidptr       = unsafe { nil }
	address DeviceAddress
	range   DeviceSize
	format  Format
}

pub type DescriptorBufferBindingInfoEXT = C.VkDescriptorBufferBindingInfoEXT

@[typedef]
pub struct C.VkDescriptorBufferBindingInfoEXT {
pub mut:
	sType   StructureType = StructureType.descriptor_buffer_binding_info_ext
	pNext   voidptr       = unsafe { nil }
	address DeviceAddress
	usage   BufferUsageFlags
}

pub type DescriptorBufferBindingPushDescriptorBufferHandleEXT = C.VkDescriptorBufferBindingPushDescriptorBufferHandleEXT

@[typedef]
pub struct C.VkDescriptorBufferBindingPushDescriptorBufferHandleEXT {
pub mut:
	sType  StructureType = StructureType.descriptor_buffer_binding_push_descriptor_buffer_handle_ext
	pNext  voidptr       = unsafe { nil }
	buffer C.VkBuffer
}

pub type DescriptorDataEXT = C.VkDescriptorDataEXT

@[typedef]
pub union C.VkDescriptorDataEXT {
pub mut:
	pSampler              C.VkSampler
	pCombinedImageSampler &DescriptorImageInfo
	pInputAttachmentImage &DescriptorImageInfo
	pSampledImage         &DescriptorImageInfo
	pStorageImage         &DescriptorImageInfo
	pUniformTexelBuffer   &DescriptorAddressInfoEXT
	pStorageTexelBuffer   &DescriptorAddressInfoEXT
	pUniformBuffer        &DescriptorAddressInfoEXT
	pStorageBuffer        &DescriptorAddressInfoEXT
	accelerationStructure DeviceAddress
}

pub type DescriptorGetInfoEXT = C.VkDescriptorGetInfoEXT

@[typedef]
pub struct C.VkDescriptorGetInfoEXT {
pub mut:
	sType StructureType = StructureType.descriptor_get_info_ext
	pNext voidptr       = unsafe { nil }
	type  DescriptorType
	data  DescriptorDataEXT
}

pub type BufferCaptureDescriptorDataInfoEXT = C.VkBufferCaptureDescriptorDataInfoEXT

@[typedef]
pub struct C.VkBufferCaptureDescriptorDataInfoEXT {
pub mut:
	sType  StructureType = StructureType.buffer_capture_descriptor_data_info_ext
	pNext  voidptr       = unsafe { nil }
	buffer C.VkBuffer
}

pub type ImageCaptureDescriptorDataInfoEXT = C.VkImageCaptureDescriptorDataInfoEXT

@[typedef]
pub struct C.VkImageCaptureDescriptorDataInfoEXT {
pub mut:
	sType StructureType = StructureType.image_capture_descriptor_data_info_ext
	pNext voidptr       = unsafe { nil }
	image C.VkImage
}

pub type ImageViewCaptureDescriptorDataInfoEXT = C.VkImageViewCaptureDescriptorDataInfoEXT

@[typedef]
pub struct C.VkImageViewCaptureDescriptorDataInfoEXT {
pub mut:
	sType     StructureType = StructureType.image_view_capture_descriptor_data_info_ext
	pNext     voidptr       = unsafe { nil }
	imageView C.VkImageView
}

pub type SamplerCaptureDescriptorDataInfoEXT = C.VkSamplerCaptureDescriptorDataInfoEXT

@[typedef]
pub struct C.VkSamplerCaptureDescriptorDataInfoEXT {
pub mut:
	sType   StructureType = StructureType.sampler_capture_descriptor_data_info_ext
	pNext   voidptr       = unsafe { nil }
	sampler C.VkSampler
}

pub type OpaqueCaptureDescriptorDataCreateInfoEXT = C.VkOpaqueCaptureDescriptorDataCreateInfoEXT

@[typedef]
pub struct C.VkOpaqueCaptureDescriptorDataCreateInfoEXT {
pub mut:
	sType                       StructureType = StructureType.opaque_capture_descriptor_data_create_info_ext
	pNext                       voidptr       = unsafe { nil }
	opaqueCaptureDescriptorData voidptr
}

pub type AccelerationStructureCaptureDescriptorDataInfoEXT = C.VkAccelerationStructureCaptureDescriptorDataInfoEXT

@[typedef]
pub struct C.VkAccelerationStructureCaptureDescriptorDataInfoEXT {
pub mut:
	sType                   StructureType = StructureType.acceleration_structure_capture_descriptor_data_info_ext
	pNext                   voidptr       = unsafe { nil }
	accelerationStructure   C.VkAccelerationStructureKHR
	accelerationStructureNV C.VkAccelerationStructureNV
}

fn C.vkGetDescriptorSetLayoutSizeEXT(C.VkDevice, C.VkDescriptorSetLayout, &DeviceSize)

pub type PFN_vkGetDescriptorSetLayoutSizeEXT = fn (C.VkDevice, C.VkDescriptorSetLayout, &DeviceSize)

@[inline]
pub fn get_descriptor_set_layout_size_ext(device C.VkDevice,
	layout C.VkDescriptorSetLayout,
	p_layout_size_in_bytes &DeviceSize) {
	C.vkGetDescriptorSetLayoutSizeEXT(device, layout, p_layout_size_in_bytes)
}

fn C.vkGetDescriptorSetLayoutBindingOffsetEXT(C.VkDevice, C.VkDescriptorSetLayout, u32, &DeviceSize)

pub type PFN_vkGetDescriptorSetLayoutBindingOffsetEXT = fn (C.VkDevice, C.VkDescriptorSetLayout, u32, &DeviceSize)

@[inline]
pub fn get_descriptor_set_layout_binding_offset_ext(device C.VkDevice,
	layout C.VkDescriptorSetLayout,
	binding u32,
	p_offset &DeviceSize) {
	C.vkGetDescriptorSetLayoutBindingOffsetEXT(device, layout, binding, p_offset)
}

fn C.vkGetDescriptorEXT(C.VkDevice, &DescriptorGetInfoEXT, usize, voidptr)

pub type PFN_vkGetDescriptorEXT = fn (C.VkDevice, &DescriptorGetInfoEXT, usize, voidptr)

@[inline]
pub fn get_descriptor_ext(device C.VkDevice,
	p_descriptor_info &DescriptorGetInfoEXT,
	data_size usize,
	p_descriptor voidptr) {
	C.vkGetDescriptorEXT(device, p_descriptor_info, data_size, p_descriptor)
}

fn C.vkCmdBindDescriptorBuffersEXT(C.VkCommandBuffer, u32, &DescriptorBufferBindingInfoEXT)

pub type PFN_vkCmdBindDescriptorBuffersEXT = fn (C.VkCommandBuffer, u32, &DescriptorBufferBindingInfoEXT)

@[inline]
pub fn cmd_bind_descriptor_buffers_ext(command_buffer C.VkCommandBuffer,
	buffer_count u32,
	p_binding_infos &DescriptorBufferBindingInfoEXT) {
	C.vkCmdBindDescriptorBuffersEXT(command_buffer, buffer_count, p_binding_infos)
}

fn C.vkCmdSetDescriptorBufferOffsetsEXT(C.VkCommandBuffer, PipelineBindPoint, C.VkPipelineLayout, u32, u32, &u32, &DeviceSize)

pub type PFN_vkCmdSetDescriptorBufferOffsetsEXT = fn (C.VkCommandBuffer, PipelineBindPoint, C.VkPipelineLayout, u32, u32, &u32, &DeviceSize)

@[inline]
pub fn cmd_set_descriptor_buffer_offsets_ext(command_buffer C.VkCommandBuffer,
	pipeline_bind_point PipelineBindPoint,
	layout C.VkPipelineLayout,
	first_set u32,
	set_count u32,
	p_buffer_indices &u32,
	p_offsets &DeviceSize) {
	C.vkCmdSetDescriptorBufferOffsetsEXT(command_buffer, pipeline_bind_point, layout,
		first_set, set_count, p_buffer_indices, p_offsets)
}

fn C.vkCmdBindDescriptorBufferEmbeddedSamplersEXT(C.VkCommandBuffer, PipelineBindPoint, C.VkPipelineLayout, u32)

pub type PFN_vkCmdBindDescriptorBufferEmbeddedSamplersEXT = fn (C.VkCommandBuffer, PipelineBindPoint, C.VkPipelineLayout, u32)

@[inline]
pub fn cmd_bind_descriptor_buffer_embedded_samplers_ext(command_buffer C.VkCommandBuffer,
	pipeline_bind_point PipelineBindPoint,
	layout C.VkPipelineLayout,
	set u32) {
	C.vkCmdBindDescriptorBufferEmbeddedSamplersEXT(command_buffer, pipeline_bind_point,
		layout, set)
}

fn C.vkGetBufferOpaqueCaptureDescriptorDataEXT(C.VkDevice, &BufferCaptureDescriptorDataInfoEXT, voidptr) Result

pub type PFN_vkGetBufferOpaqueCaptureDescriptorDataEXT = fn (C.VkDevice, &BufferCaptureDescriptorDataInfoEXT, voidptr) Result

@[inline]
pub fn get_buffer_opaque_capture_descriptor_data_ext(device C.VkDevice,
	p_info &BufferCaptureDescriptorDataInfoEXT,
	p_data voidptr) Result {
	return C.vkGetBufferOpaqueCaptureDescriptorDataEXT(device, p_info, p_data)
}

fn C.vkGetImageOpaqueCaptureDescriptorDataEXT(C.VkDevice, &ImageCaptureDescriptorDataInfoEXT, voidptr) Result

pub type PFN_vkGetImageOpaqueCaptureDescriptorDataEXT = fn (C.VkDevice, &ImageCaptureDescriptorDataInfoEXT, voidptr) Result

@[inline]
pub fn get_image_opaque_capture_descriptor_data_ext(device C.VkDevice,
	p_info &ImageCaptureDescriptorDataInfoEXT,
	p_data voidptr) Result {
	return C.vkGetImageOpaqueCaptureDescriptorDataEXT(device, p_info, p_data)
}

fn C.vkGetImageViewOpaqueCaptureDescriptorDataEXT(C.VkDevice, &ImageViewCaptureDescriptorDataInfoEXT, voidptr) Result

pub type PFN_vkGetImageViewOpaqueCaptureDescriptorDataEXT = fn (C.VkDevice, &ImageViewCaptureDescriptorDataInfoEXT, voidptr) Result

@[inline]
pub fn get_image_view_opaque_capture_descriptor_data_ext(device C.VkDevice,
	p_info &ImageViewCaptureDescriptorDataInfoEXT,
	p_data voidptr) Result {
	return C.vkGetImageViewOpaqueCaptureDescriptorDataEXT(device, p_info, p_data)
}

fn C.vkGetSamplerOpaqueCaptureDescriptorDataEXT(C.VkDevice, &SamplerCaptureDescriptorDataInfoEXT, voidptr) Result

pub type PFN_vkGetSamplerOpaqueCaptureDescriptorDataEXT = fn (C.VkDevice, &SamplerCaptureDescriptorDataInfoEXT, voidptr) Result

@[inline]
pub fn get_sampler_opaque_capture_descriptor_data_ext(device C.VkDevice,
	p_info &SamplerCaptureDescriptorDataInfoEXT,
	p_data voidptr) Result {
	return C.vkGetSamplerOpaqueCaptureDescriptorDataEXT(device, p_info, p_data)
}

fn C.vkGetAccelerationStructureOpaqueCaptureDescriptorDataEXT(C.VkDevice, &AccelerationStructureCaptureDescriptorDataInfoEXT, voidptr) Result

pub type PFN_vkGetAccelerationStructureOpaqueCaptureDescriptorDataEXT = fn (C.VkDevice, &AccelerationStructureCaptureDescriptorDataInfoEXT, voidptr) Result

@[inline]
pub fn get_acceleration_structure_opaque_capture_descriptor_data_ext(device C.VkDevice,
	p_info &AccelerationStructureCaptureDescriptorDataInfoEXT,
	p_data voidptr) Result {
	return C.vkGetAccelerationStructureOpaqueCaptureDescriptorDataEXT(device, p_info,
		p_data)
}

pub const ext_graphics_pipeline_library_spec_version = 1
pub const ext_graphics_pipeline_library_extension_name = 'VK_EXT_graphics_pipeline_library'

pub enum GraphicsPipelineLibraryFlagBitsEXT {
	vertex_input_interface_bit_ext    = int(0x00000001)
	pre_rasterization_shaders_bit_ext = int(0x00000002)
	ragment_shader_bit_ext            = int(0x00000004)
	ragment_output_interface_bit_ext  = int(0x00000008)
	max_enum_ext                      = max_int
}

pub type GraphicsPipelineLibraryFlagsEXT = u32
pub type PhysicalDeviceGraphicsPipelineLibraryFeaturesEXT = C.VkPhysicalDeviceGraphicsPipelineLibraryFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceGraphicsPipelineLibraryFeaturesEXT {
pub mut:
	sType                   StructureType = StructureType.physical_device_graphics_pipeline_library_features_ext
	pNext                   voidptr       = unsafe { nil }
	graphicsPipelineLibrary Bool32
}

pub type PhysicalDeviceGraphicsPipelineLibraryPropertiesEXT = C.VkPhysicalDeviceGraphicsPipelineLibraryPropertiesEXT

@[typedef]
pub struct C.VkPhysicalDeviceGraphicsPipelineLibraryPropertiesEXT {
pub mut:
	sType                                                     StructureType = StructureType.physical_device_graphics_pipeline_library_properties_ext
	pNext                                                     voidptr       = unsafe { nil }
	graphicsPipelineLibraryFastLinking                        Bool32
	graphicsPipelineLibraryIndependentInterpolationDecoration Bool32
}

pub type GraphicsPipelineLibraryCreateInfoEXT = C.VkGraphicsPipelineLibraryCreateInfoEXT

@[typedef]
pub struct C.VkGraphicsPipelineLibraryCreateInfoEXT {
pub mut:
	sType StructureType = StructureType.graphics_pipeline_library_create_info_ext
	pNext voidptr       = unsafe { nil }
	flags GraphicsPipelineLibraryFlagsEXT
}

pub const amd_shader_early_and_late_fragment_tests_spec_version = 1
pub const amd_shader_early_and_late_fragment_tests_extension_name = 'VK_AMD_shader_early_and_late_fragment_tests'

pub type PhysicalDeviceShaderEarlyAndLateFragmentTestsFeaturesAMD = C.VkPhysicalDeviceShaderEarlyAndLateFragmentTestsFeaturesAMD

@[typedef]
pub struct C.VkPhysicalDeviceShaderEarlyAndLateFragmentTestsFeaturesAMD {
pub mut:
	sType                           StructureType = StructureType.physical_device_shader_early_and_late_fragment_tests_features_amd
	pNext                           voidptr       = unsafe { nil }
	shaderEarlyAndLateFragmentTests Bool32
}

pub const nv_fragment_shading_rate_enums_spec_version = 1
pub const nv_fragment_shading_rate_enums_extension_name = 'VK_NV_fragment_shading_rate_enums'

pub enum FragmentShadingRateTypeNV {
	fragment_size_nv = 0
	enums_nv         = 1
	max_enum_nv      = max_int
}

pub enum FragmentShadingRateNV {
	_1_invocation_per_pixel_nv     = 0
	_1_invocation_per1x2_pixels_nv = 1
	_1_invocation_per2x1_pixels_nv = 4
	_1_invocation_per2x2_pixels_nv = 5
	_1_invocation_per2x4_pixels_nv = 6
	_1_invocation_per4x2_pixels_nv = 9
	_1_invocation_per4x4_pixels_nv = 10
	_2_invocations_per_pixel_nv    = 11
	_4_invocations_per_pixel_nv    = 12
	_8_invocations_per_pixel_nv    = 13
	_16_invocations_per_pixel_nv   = 14
	no_invocations_nv              = 15
	max_enum_nv                    = max_int
}

pub type PhysicalDeviceFragmentShadingRateEnumsFeaturesNV = C.VkPhysicalDeviceFragmentShadingRateEnumsFeaturesNV

@[typedef]
pub struct C.VkPhysicalDeviceFragmentShadingRateEnumsFeaturesNV {
pub mut:
	sType                            StructureType = StructureType.physical_device_fragment_shading_rate_enums_features_nv
	pNext                            voidptr       = unsafe { nil }
	fragmentShadingRateEnums         Bool32
	supersampleFragmentShadingRates  Bool32
	noInvocationFragmentShadingRates Bool32
}

pub type PhysicalDeviceFragmentShadingRateEnumsPropertiesNV = C.VkPhysicalDeviceFragmentShadingRateEnumsPropertiesNV

@[typedef]
pub struct C.VkPhysicalDeviceFragmentShadingRateEnumsPropertiesNV {
pub mut:
	sType                                 StructureType = StructureType.physical_device_fragment_shading_rate_enums_properties_nv
	pNext                                 voidptr       = unsafe { nil }
	maxFragmentShadingRateInvocationCount SampleCountFlagBits
}

pub type PipelineFragmentShadingRateEnumStateCreateInfoNV = C.VkPipelineFragmentShadingRateEnumStateCreateInfoNV

@[typedef]
pub struct C.VkPipelineFragmentShadingRateEnumStateCreateInfoNV {
pub mut:
	sType           StructureType = StructureType.pipeline_fragment_shading_rate_enum_state_create_info_nv
	pNext           voidptr       = unsafe { nil }
	shadingRateType FragmentShadingRateTypeNV
	shadingRate     FragmentShadingRateNV
	combinerOps     [2]FragmentShadingRateCombinerOpKHR
}

fn C.vkCmdSetFragmentShadingRateEnumNV(C.VkCommandBuffer, FragmentShadingRateNV, voidptr)

pub type PFN_vkCmdSetFragmentShadingRateEnumNV = fn (C.VkCommandBuffer, FragmentShadingRateNV, voidptr)

@[inline]
pub fn cmd_set_fragment_shading_rate_enum_nv(command_buffer C.VkCommandBuffer,
	shading_rate FragmentShadingRateNV,
	combiner_ops [2]FragmentShadingRateCombinerOpKHR) {
	C.vkCmdSetFragmentShadingRateEnumNV(command_buffer, shading_rate, combiner_ops)
}

pub const nv_ray_tracing_motion_blur_spec_version = 1
pub const nv_ray_tracing_motion_blur_extension_name = 'VK_NV_ray_tracing_motion_blur'

pub enum AccelerationStructureMotionInstanceTypeNV {
	static_nv        = 0
	matrix_motion_nv = 1
	srt_motion_nv    = 2
	max_enum_nv      = max_int
}

pub type AccelerationStructureMotionInfoFlagsNV = u32
pub type AccelerationStructureMotionInstanceFlagsNV = u32
pub type DeviceOrHostAddressConstKHR = C.VkDeviceOrHostAddressConstKHR

@[typedef]
pub union C.VkDeviceOrHostAddressConstKHR {
pub mut:
	deviceAddress DeviceAddress
	hostAddress   voidptr
}

pub type AccelerationStructureGeometryMotionTrianglesDataNV = C.VkAccelerationStructureGeometryMotionTrianglesDataNV

@[typedef]
pub struct C.VkAccelerationStructureGeometryMotionTrianglesDataNV {
pub mut:
	sType      StructureType = StructureType.acceleration_structure_geometry_motion_triangles_data_nv
	pNext      voidptr       = unsafe { nil }
	vertexData DeviceOrHostAddressConstKHR
}

pub type AccelerationStructureMotionInfoNV = C.VkAccelerationStructureMotionInfoNV

@[typedef]
pub struct C.VkAccelerationStructureMotionInfoNV {
pub mut:
	sType        StructureType = StructureType.acceleration_structure_motion_info_nv
	pNext        voidptr       = unsafe { nil }
	maxInstances u32
	flags        AccelerationStructureMotionInfoFlagsNV
}

pub type AccelerationStructureMatrixMotionInstanceNV = C.VkAccelerationStructureMatrixMotionInstanceNV

@[typedef]
pub struct C.VkAccelerationStructureMatrixMotionInstanceNV {
pub mut:
	transformT0                            TransformMatrixKHR
	transformT1                            TransformMatrixKHR
	instanceCustomIndex                    u32
	mask                                   u32
	instanceShaderBindingTableRecordOffset u32
	flags                                  GeometryInstanceFlagsKHR
	accelerationStructureReference         u64
}

pub type SRTDataNV = C.VkSRTDataNV

@[typedef]
pub struct C.VkSRTDataNV {
pub mut:
	sx  f32
	a   f32
	b   f32
	pvx f32
	sy  f32
	c   f32
	pvy f32
	sz  f32
	pvz f32
	qx  f32
	qy  f32
	qz  f32
	qw  f32
	tx  f32
	ty  f32
	tz  f32
}

pub type AccelerationStructureSRTMotionInstanceNV = C.VkAccelerationStructureSRTMotionInstanceNV

@[typedef]
pub struct C.VkAccelerationStructureSRTMotionInstanceNV {
pub mut:
	transformT0                            SRTDataNV
	transformT1                            SRTDataNV
	instanceCustomIndex                    u32
	mask                                   u32
	instanceShaderBindingTableRecordOffset u32
	flags                                  GeometryInstanceFlagsKHR
	accelerationStructureReference         u64
}

pub type AccelerationStructureMotionInstanceDataNV = C.VkAccelerationStructureMotionInstanceDataNV

@[typedef]
pub union C.VkAccelerationStructureMotionInstanceDataNV {
pub mut:
	staticInstance       AccelerationStructureInstanceKHR
	matrixMotionInstance AccelerationStructureMatrixMotionInstanceNV
	srtMotionInstance    AccelerationStructureSRTMotionInstanceNV
}

pub type AccelerationStructureMotionInstanceNV = C.VkAccelerationStructureMotionInstanceNV

@[typedef]
pub struct C.VkAccelerationStructureMotionInstanceNV {
pub mut:
	type  AccelerationStructureMotionInstanceTypeNV
	flags AccelerationStructureMotionInstanceFlagsNV
	data  AccelerationStructureMotionInstanceDataNV
}

pub type PhysicalDeviceRayTracingMotionBlurFeaturesNV = C.VkPhysicalDeviceRayTracingMotionBlurFeaturesNV

@[typedef]
pub struct C.VkPhysicalDeviceRayTracingMotionBlurFeaturesNV {
pub mut:
	sType                                         StructureType = StructureType.physical_device_ray_tracing_motion_blur_features_nv
	pNext                                         voidptr       = unsafe { nil }
	rayTracingMotionBlur                          Bool32
	rayTracingMotionBlurPipelineTraceRaysIndirect Bool32
}

pub const ext_ycbcr_2plane_444_formats_spec_version = 1
pub const ext_ycbcr_2plane_444_formats_extension_name = 'VK_EXT_ycbcr_2plane_444_formats'

pub type PhysicalDeviceYcbcr2Plane444FormatsFeaturesEXT = C.VkPhysicalDeviceYcbcr2Plane444FormatsFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceYcbcr2Plane444FormatsFeaturesEXT {
pub mut:
	sType                 StructureType = StructureType.physical_device_ycbcr2_plane444_formats_features_ext
	pNext                 voidptr       = unsafe { nil }
	ycbcr2plane444Formats Bool32
}

pub const ext_fragment_density_map_2_spec_version = 1
pub const ext_fragment_density_map_2_extension_name = 'VK_EXT_fragment_density_map2'

pub type PhysicalDeviceFragmentDensityMap2FeaturesEXT = C.VkPhysicalDeviceFragmentDensityMap2FeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceFragmentDensityMap2FeaturesEXT {
pub mut:
	sType                      StructureType = StructureType.physical_device_fragment_density_map2_features_ext
	pNext                      voidptr       = unsafe { nil }
	fragmentDensityMapDeferred Bool32
}

pub type PhysicalDeviceFragmentDensityMap2PropertiesEXT = C.VkPhysicalDeviceFragmentDensityMap2PropertiesEXT

@[typedef]
pub struct C.VkPhysicalDeviceFragmentDensityMap2PropertiesEXT {
pub mut:
	sType                                     StructureType = StructureType.physical_device_fragment_density_map2_properties_ext
	pNext                                     voidptr       = unsafe { nil }
	subsampledLoads                           Bool32
	subsampledCoarseReconstructionEarlyAccess Bool32
	maxSubsampledArrayLayers                  u32
	maxDescriptorSetSubsampledSamplers        u32
}

pub const qcom_rotated_copy_commands_spec_version = 2
pub const qcom_rotated_copy_commands_extension_name = 'VK_QCOM_rotated_copy_commands'

pub type CopyCommandTransformInfoQCOM = C.VkCopyCommandTransformInfoQCOM

@[typedef]
pub struct C.VkCopyCommandTransformInfoQCOM {
pub mut:
	sType     StructureType = StructureType.copy_command_transform_info_qcom
	pNext     voidptr       = unsafe { nil }
	transform SurfaceTransformFlagBitsKHR
}

pub const ext_image_robustness_spec_version = 1
pub const ext_image_robustness_extension_name = 'VK_EXT_image_robustness'

pub type PhysicalDeviceImageRobustnessFeaturesEXT = C.VkPhysicalDeviceImageRobustnessFeatures

pub const ext_image_compression_control_spec_version = 1
pub const ext_image_compression_control_extension_name = 'VK_EXT_image_compression_control'

pub enum ImageCompressionFlagBitsEXT {
	default_ext            = 0
	ixed_rate_default_ext  = int(0x00000001)
	ixed_rate_explicit_ext = int(0x00000002)
	disabled_ext           = int(0x00000004)
	max_enum_ext           = max_int
}

pub type ImageCompressionFlagsEXT = u32

pub enum ImageCompressionFixedRateFlagBitsEXT {
	none_ext       = 0
	_1bpc_bit_ext  = int(0x00000001)
	_2bpc_bit_ext  = int(0x00000002)
	_3bpc_bit_ext  = int(0x00000004)
	_4bpc_bit_ext  = int(0x00000008)
	_5bpc_bit_ext  = int(0x00000010)
	_6bpc_bit_ext  = int(0x00000020)
	_7bpc_bit_ext  = int(0x00000040)
	_8bpc_bit_ext  = int(0x00000080)
	_9bpc_bit_ext  = int(0x00000100)
	_10bpc_bit_ext = int(0x00000200)
	_11bpc_bit_ext = int(0x00000400)
	_12bpc_bit_ext = int(0x00000800)
	_13bpc_bit_ext = int(0x00001000)
	_14bpc_bit_ext = int(0x00002000)
	_15bpc_bit_ext = int(0x00004000)
	_16bpc_bit_ext = int(0x00008000)
	_17bpc_bit_ext = int(0x00010000)
	_18bpc_bit_ext = int(0x00020000)
	_19bpc_bit_ext = int(0x00040000)
	_20bpc_bit_ext = int(0x00080000)
	_21bpc_bit_ext = int(0x00100000)
	_22bpc_bit_ext = int(0x00200000)
	_23bpc_bit_ext = int(0x00400000)
	_24bpc_bit_ext = int(0x00800000)
	max_enum_ext   = max_int
}

pub type ImageCompressionFixedRateFlagsEXT = u32
pub type PhysicalDeviceImageCompressionControlFeaturesEXT = C.VkPhysicalDeviceImageCompressionControlFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceImageCompressionControlFeaturesEXT {
pub mut:
	sType                   StructureType = StructureType.physical_device_image_compression_control_features_ext
	pNext                   voidptr       = unsafe { nil }
	imageCompressionControl Bool32
}

pub type ImageCompressionControlEXT = C.VkImageCompressionControlEXT

@[typedef]
pub struct C.VkImageCompressionControlEXT {
pub mut:
	sType                        StructureType = StructureType.image_compression_control_ext
	pNext                        voidptr       = unsafe { nil }
	flags                        ImageCompressionFlagsEXT
	compressionControlPlaneCount u32
	pFixedRateFlags              &ImageCompressionFixedRateFlagsEXT
}

pub type ImageCompressionPropertiesEXT = C.VkImageCompressionPropertiesEXT

@[typedef]
pub struct C.VkImageCompressionPropertiesEXT {
pub mut:
	sType                          StructureType = StructureType.image_compression_properties_ext
	pNext                          voidptr       = unsafe { nil }
	imageCompressionFlags          ImageCompressionFlagsEXT
	imageCompressionFixedRateFlags ImageCompressionFixedRateFlagsEXT
}

pub const ext_attachment_feedback_loop_layout_spec_version = 2
pub const ext_attachment_feedback_loop_layout_extension_name = 'VK_EXT_attachment_feedback_loop_layout'

pub type PhysicalDeviceAttachmentFeedbackLoopLayoutFeaturesEXT = C.VkPhysicalDeviceAttachmentFeedbackLoopLayoutFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceAttachmentFeedbackLoopLayoutFeaturesEXT {
pub mut:
	sType                        StructureType = StructureType.physical_device_attachment_feedback_loop_layout_features_ext
	pNext                        voidptr       = unsafe { nil }
	attachmentFeedbackLoopLayout Bool32
}

pub const ext_4444_formats_spec_version = 1
pub const ext_4444_formats_extension_name = 'VK_EXT_4444_formats'

pub type PhysicalDevice4444FormatsFeaturesEXT = C.VkPhysicalDevice4444FormatsFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDevice4444FormatsFeaturesEXT {
pub mut:
	sType          StructureType = StructureType.physical_device4444_formats_features_ext
	pNext          voidptr       = unsafe { nil }
	formatA4R4G4B4 Bool32
	formatA4B4G4R4 Bool32
}

pub const ext_device_fault_spec_version = 2
pub const ext_device_fault_extension_name = 'VK_EXT_device_fault'

pub enum DeviceFaultAddressTypeEXT {
	none_ext                        = 0
	read_invalid_ext                = 1
	write_invalid_ext               = 2
	execute_invalid_ext             = 3
	instruction_pointer_unknown_ext = 4
	instruction_pointer_invalid_ext = 5
	instruction_pointer_fault_ext   = 6
	max_enum_ext                    = max_int
}

pub enum DeviceFaultVendorBinaryHeaderVersionEXT {
	one_ext      = 1
	max_enum_ext = max_int
}

pub type PhysicalDeviceFaultFeaturesEXT = C.VkPhysicalDeviceFaultFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceFaultFeaturesEXT {
pub mut:
	sType                   StructureType = StructureType.physical_device_fault_features_ext
	pNext                   voidptr       = unsafe { nil }
	deviceFault             Bool32
	deviceFaultVendorBinary Bool32
}

pub type DeviceFaultCountsEXT = C.VkDeviceFaultCountsEXT

@[typedef]
pub struct C.VkDeviceFaultCountsEXT {
pub mut:
	sType            StructureType = StructureType.device_fault_counts_ext
	pNext            voidptr       = unsafe { nil }
	addressInfoCount u32
	vendorInfoCount  u32
	vendorBinarySize DeviceSize
}

pub type DeviceFaultAddressInfoEXT = C.VkDeviceFaultAddressInfoEXT

@[typedef]
pub struct C.VkDeviceFaultAddressInfoEXT {
pub mut:
	addressType      DeviceFaultAddressTypeEXT
	reportedAddress  DeviceAddress
	addressPrecision DeviceSize
}

pub type DeviceFaultVendorInfoEXT = C.VkDeviceFaultVendorInfoEXT

@[typedef]
pub struct C.VkDeviceFaultVendorInfoEXT {
pub mut:
	description     [max_description_size]char
	vendorFaultCode u64
	vendorFaultData u64
}

pub type DeviceFaultInfoEXT = C.VkDeviceFaultInfoEXT

@[typedef]
pub struct C.VkDeviceFaultInfoEXT {
pub mut:
	sType             StructureType = StructureType.device_fault_info_ext
	pNext             voidptr       = unsafe { nil }
	description       [max_description_size]char
	pAddressInfos     &DeviceFaultAddressInfoEXT
	pVendorInfos      &DeviceFaultVendorInfoEXT
	pVendorBinaryData voidptr
}

pub type DeviceFaultVendorBinaryHeaderVersionOneEXT = C.VkDeviceFaultVendorBinaryHeaderVersionOneEXT

@[typedef]
pub struct C.VkDeviceFaultVendorBinaryHeaderVersionOneEXT {
pub mut:
	headerSize            u32
	headerVersion         DeviceFaultVendorBinaryHeaderVersionEXT
	vendorID              u32
	deviceID              u32
	driverVersion         u32
	pipelineCacheUUID     [uuid_size]u8
	applicationNameOffset u32
	applicationVersion    u32
	engineNameOffset      u32
	engineVersion         u32
	apiVersion            u32
}

fn C.vkGetDeviceFaultInfoEXT(C.VkDevice, &DeviceFaultCountsEXT, &DeviceFaultInfoEXT) Result

pub type PFN_vkGetDeviceFaultInfoEXT = fn (C.VkDevice, &DeviceFaultCountsEXT, &DeviceFaultInfoEXT) Result

@[inline]
pub fn get_device_fault_info_ext(device C.VkDevice,
	p_fault_counts &DeviceFaultCountsEXT,
	p_fault_info &DeviceFaultInfoEXT) Result {
	return C.vkGetDeviceFaultInfoEXT(device, p_fault_counts, p_fault_info)
}

pub const arm_rasterization_order_attachment_access_spec_version = 1
pub const arm_rasterization_order_attachment_access_extension_name = 'VK_ARM_rasterization_order_attachment_access'

pub type PhysicalDeviceRasterizationOrderAttachmentAccessFeaturesEXT = C.VkPhysicalDeviceRasterizationOrderAttachmentAccessFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceRasterizationOrderAttachmentAccessFeaturesEXT {
pub mut:
	sType                                     StructureType = StructureType.physical_device_rasterization_order_attachment_access_features_ext
	pNext                                     voidptr       = unsafe { nil }
	rasterizationOrderColorAttachmentAccess   Bool32
	rasterizationOrderDepthAttachmentAccess   Bool32
	rasterizationOrderStencilAttachmentAccess Bool32
}

pub type PhysicalDeviceRasterizationOrderAttachmentAccessFeaturesARM = C.VkPhysicalDeviceRasterizationOrderAttachmentAccessFeaturesEXT

pub const ext_rgba10x6_formats_spec_version = 1
pub const ext_rgba10x6_formats_extension_name = 'VK_EXT_rgba10x6_formats'

pub type PhysicalDeviceRGBA10X6FormatsFeaturesEXT = C.VkPhysicalDeviceRGBA10X6FormatsFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceRGBA10X6FormatsFeaturesEXT {
pub mut:
	sType                             StructureType
	pNext                             voidptr = unsafe { nil }
	formatRgba10x6WithoutYCbCrSampler Bool32
}

pub const valve_mutable_descriptor_type_spec_version = 1
pub const valve_mutable_descriptor_type_extension_name = 'VK_VAVE_mutable_descriptor_type'

pub type PhysicalDeviceMutableDescriptorTypeFeaturesEXT = C.VkPhysicalDeviceMutableDescriptorTypeFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceMutableDescriptorTypeFeaturesEXT {
pub mut:
	sType                 StructureType = StructureType.physical_device_mutable_descriptor_type_features_ext
	pNext                 voidptr       = unsafe { nil }
	mutableDescriptorType Bool32
}

pub type PhysicalDeviceMutableDescriptorTypeFeaturesVALVE = C.VkPhysicalDeviceMutableDescriptorTypeFeaturesEXT

pub type MutableDescriptorTypeListEXT = C.VkMutableDescriptorTypeListEXT

@[typedef]
pub struct C.VkMutableDescriptorTypeListEXT {
pub mut:
	descriptorTypeCount u32
	pDescriptorTypes    &DescriptorType
}

pub type MutableDescriptorTypeListVALVE = C.VkMutableDescriptorTypeListEXT

pub type MutableDescriptorTypeCreateInfoEXT = C.VkMutableDescriptorTypeCreateInfoEXT

@[typedef]
pub struct C.VkMutableDescriptorTypeCreateInfoEXT {
pub mut:
	sType                          StructureType = StructureType.mutable_descriptor_type_create_info_ext
	pNext                          voidptr       = unsafe { nil }
	mutableDescriptorTypeListCount u32
	pMutableDescriptorTypeLists    &MutableDescriptorTypeListEXT
}

pub type MutableDescriptorTypeCreateInfoVALVE = C.VkMutableDescriptorTypeCreateInfoEXT

pub const ext_vertex_input_dynamic_state_spec_version = 2
pub const ext_vertex_input_dynamic_state_extension_name = 'VK_EXT_vertex_input_dynamic_state'

pub type PhysicalDeviceVertexInputDynamicStateFeaturesEXT = C.VkPhysicalDeviceVertexInputDynamicStateFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceVertexInputDynamicStateFeaturesEXT {
pub mut:
	sType                   StructureType = StructureType.physical_device_vertex_input_dynamic_state_features_ext
	pNext                   voidptr       = unsafe { nil }
	vertexInputDynamicState Bool32
}

pub type VertexInputBindingDescription2EXT = C.VkVertexInputBindingDescription2EXT

@[typedef]
pub struct C.VkVertexInputBindingDescription2EXT {
pub mut:
	sType     StructureType = StructureType.vertex_input_binding_description2_ext
	pNext     voidptr       = unsafe { nil }
	binding   u32
	stride    u32
	inputRate VertexInputRate
	divisor   u32
}

pub type VertexInputAttributeDescription2EXT = C.VkVertexInputAttributeDescription2EXT

@[typedef]
pub struct C.VkVertexInputAttributeDescription2EXT {
pub mut:
	sType    StructureType = StructureType.vertex_input_attribute_description2_ext
	pNext    voidptr       = unsafe { nil }
	location u32
	binding  u32
	format   Format
	offset   u32
}

fn C.vkCmdSetVertexInputEXT(C.VkCommandBuffer, u32, &VertexInputBindingDescription2EXT, u32, &VertexInputAttributeDescription2EXT)

pub type PFN_vkCmdSetVertexInputEXT = fn (C.VkCommandBuffer, u32, &VertexInputBindingDescription2EXT, u32, &VertexInputAttributeDescription2EXT)

@[inline]
pub fn cmd_set_vertex_input_ext(command_buffer C.VkCommandBuffer,
	vertex_binding_description_count u32,
	p_vertex_binding_descriptions &VertexInputBindingDescription2EXT,
	vertex_attribute_description_count u32,
	p_vertex_attribute_descriptions &VertexInputAttributeDescription2EXT) {
	C.vkCmdSetVertexInputEXT(command_buffer, vertex_binding_description_count, p_vertex_binding_descriptions,
		vertex_attribute_description_count, p_vertex_attribute_descriptions)
}

pub const ext_physical_device_drm_spec_version = 1
pub const ext_physical_device_drm_extension_name = 'VK_EXT_physical_device_drm'

pub type PhysicalDeviceDrmPropertiesEXT = C.VkPhysicalDeviceDrmPropertiesEXT

@[typedef]
pub struct C.VkPhysicalDeviceDrmPropertiesEXT {
pub mut:
	sType        StructureType = StructureType.physical_device_drm_properties_ext
	pNext        voidptr       = unsafe { nil }
	hasPrimary   Bool32
	hasRender    Bool32
	primaryMajor i64
	primaryMinor i64
	renderMajor  i64
	renderMinor  i64
}

pub const ext_device_address_binding_report_spec_version = 1
pub const ext_device_address_binding_report_extension_name = 'VK_EXT_device_address_binding_report'

pub enum DeviceAddressBindingTypeEXT {
	bind_ext     = 0
	unbind_ext   = 1
	max_enum_ext = max_int
}

pub enum DeviceAddressBindingFlagBitsEXT {
	internal_object_bit_ext = int(0x00000001)
	max_enum_ext            = max_int
}

pub type DeviceAddressBindingFlagsEXT = u32
pub type PhysicalDeviceAddressBindingReportFeaturesEXT = C.VkPhysicalDeviceAddressBindingReportFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceAddressBindingReportFeaturesEXT {
pub mut:
	sType                StructureType = StructureType.physical_device_address_binding_report_features_ext
	pNext                voidptr       = unsafe { nil }
	reportAddressBinding Bool32
}

pub type DeviceAddressBindingCallbackDataEXT = C.VkDeviceAddressBindingCallbackDataEXT

@[typedef]
pub struct C.VkDeviceAddressBindingCallbackDataEXT {
pub mut:
	sType       StructureType = StructureType.device_address_binding_callback_data_ext
	pNext       voidptr       = unsafe { nil }
	flags       DeviceAddressBindingFlagsEXT
	baseAddress DeviceAddress
	size        DeviceSize
	bindingType DeviceAddressBindingTypeEXT
}

pub const ext_depth_clip_control_spec_version = 1
pub const ext_depth_clip_control_extension_name = 'VK_EXT_depth_clip_control'

pub type PhysicalDeviceDepthClipControlFeaturesEXT = C.VkPhysicalDeviceDepthClipControlFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceDepthClipControlFeaturesEXT {
pub mut:
	sType            StructureType = StructureType.physical_device_depth_clip_control_features_ext
	pNext            voidptr       = unsafe { nil }
	depthClipControl Bool32
}

pub type PipelineViewportDepthClipControlCreateInfoEXT = C.VkPipelineViewportDepthClipControlCreateInfoEXT

@[typedef]
pub struct C.VkPipelineViewportDepthClipControlCreateInfoEXT {
pub mut:
	sType            StructureType = StructureType.pipeline_viewport_depth_clip_control_create_info_ext
	pNext            voidptr       = unsafe { nil }
	negativeOneToOne Bool32
}

pub const ext_primitive_topology_list_restart_spec_version = 1
pub const ext_primitive_topology_list_restart_extension_name = 'VK_EXT_primitive_topology_list_restart'

pub type PhysicalDevicePrimitiveTopologyListRestartFeaturesEXT = C.VkPhysicalDevicePrimitiveTopologyListRestartFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDevicePrimitiveTopologyListRestartFeaturesEXT {
pub mut:
	sType                             StructureType = StructureType.physical_device_primitive_topology_list_restart_features_ext
	pNext                             voidptr       = unsafe { nil }
	primitiveTopologyListRestart      Bool32
	primitiveTopologyPatchListRestart Bool32
}

pub const huawei_subpass_shading_spec_version = 3
pub const huawei_subpass_shading_extension_name = 'VK_HAWEI_subpass_shading'

pub type SubpassShadingPipelineCreateInfoHUAWEI = C.VkSubpassShadingPipelineCreateInfoHUAWEI

@[typedef]
pub struct C.VkSubpassShadingPipelineCreateInfoHUAWEI {
pub mut:
	sType      StructureType = StructureType.subpass_shading_pipeline_create_info_huawei
	pNext      voidptr       = unsafe { nil }
	renderPass C.VkRenderPass
	subpass    u32
}

pub type PhysicalDeviceSubpassShadingFeaturesHUAWEI = C.VkPhysicalDeviceSubpassShadingFeaturesHUAWEI

@[typedef]
pub struct C.VkPhysicalDeviceSubpassShadingFeaturesHUAWEI {
pub mut:
	sType          StructureType = StructureType.physical_device_subpass_shading_features_huawei
	pNext          voidptr       = unsafe { nil }
	subpassShading Bool32
}

pub type PhysicalDeviceSubpassShadingPropertiesHUAWEI = C.VkPhysicalDeviceSubpassShadingPropertiesHUAWEI

@[typedef]
pub struct C.VkPhysicalDeviceSubpassShadingPropertiesHUAWEI {
pub mut:
	sType                                     StructureType = StructureType.physical_device_subpass_shading_properties_huawei
	pNext                                     voidptr       = unsafe { nil }
	maxSubpassShadingWorkgroupSizeAspectRatio u32
}

fn C.vkGetDeviceSubpassShadingMaxWorkgroupSizeHUAWEI(C.VkDevice, C.VkRenderPass, &Extent2D) Result

pub type PFN_vkGetDeviceSubpassShadingMaxWorkgroupSizeHUAWEI = fn (C.VkDevice, C.VkRenderPass, &Extent2D) Result

@[inline]
pub fn get_device_subpass_shading_max_workgroup_size_huawei(device C.VkDevice,
	renderpass C.VkRenderPass,
	p_max_workgroup_size &Extent2D) Result {
	return C.vkGetDeviceSubpassShadingMaxWorkgroupSizeHUAWEI(device, renderpass, p_max_workgroup_size)
}

fn C.vkCmdSubpassShadingHUAWEI(C.VkCommandBuffer)

pub type PFN_vkCmdSubpassShadingHUAWEI = fn (C.VkCommandBuffer)

@[inline]
pub fn cmd_subpass_shading_huawei(command_buffer C.VkCommandBuffer) {
	C.vkCmdSubpassShadingHUAWEI(command_buffer)
}

pub const huawei_invocation_mask_spec_version = 1
pub const huawei_invocation_mask_extension_name = 'VK_HAWEI_invocation_mask'

pub type PhysicalDeviceInvocationMaskFeaturesHUAWEI = C.VkPhysicalDeviceInvocationMaskFeaturesHUAWEI

@[typedef]
pub struct C.VkPhysicalDeviceInvocationMaskFeaturesHUAWEI {
pub mut:
	sType          StructureType = StructureType.physical_device_invocation_mask_features_huawei
	pNext          voidptr       = unsafe { nil }
	invocationMask Bool32
}

fn C.vkCmdBindInvocationMaskHUAWEI(C.VkCommandBuffer, C.VkImageView, ImageLayout)

pub type PFN_vkCmdBindInvocationMaskHUAWEI = fn (C.VkCommandBuffer, C.VkImageView, ImageLayout)

@[inline]
pub fn cmd_bind_invocation_mask_huawei(command_buffer C.VkCommandBuffer,
	image_view C.VkImageView,
	image_layout ImageLayout) {
	C.vkCmdBindInvocationMaskHUAWEI(command_buffer, image_view, image_layout)
}

pub type RemoteAddressNV = voidptr

pub const nv_external_memory_rdma_spec_version = 1
pub const nv_external_memory_rdma_extension_name = 'VK_NV_external_memory_rdma'

pub type MemoryGetRemoteAddressInfoNV = C.VkMemoryGetRemoteAddressInfoNV

@[typedef]
pub struct C.VkMemoryGetRemoteAddressInfoNV {
pub mut:
	sType      StructureType = StructureType.memory_get_remote_address_info_nv
	pNext      voidptr       = unsafe { nil }
	memory     C.VkDeviceMemory
	handleType ExternalMemoryHandleTypeFlagBits
}

pub type PhysicalDeviceExternalMemoryRDMAFeaturesNV = C.VkPhysicalDeviceExternalMemoryRDMAFeaturesNV

@[typedef]
pub struct C.VkPhysicalDeviceExternalMemoryRDMAFeaturesNV {
pub mut:
	sType              StructureType = StructureType.physical_device_external_memory_rdma_features_nv
	pNext              voidptr       = unsafe { nil }
	externalMemoryRDMA Bool32
}

fn C.vkGetMemoryRemoteAddressNV(C.VkDevice, &MemoryGetRemoteAddressInfoNV, &RemoteAddressNV) Result

pub type PFN_vkGetMemoryRemoteAddressNV = fn (C.VkDevice, &MemoryGetRemoteAddressInfoNV, &RemoteAddressNV) Result

@[inline]
pub fn get_memory_remote_address_nv(device C.VkDevice,
	p_memory_get_remote_address_info &MemoryGetRemoteAddressInfoNV,
	p_address &RemoteAddressNV) Result {
	return C.vkGetMemoryRemoteAddressNV(device, p_memory_get_remote_address_info, p_address)
}

pub const ext_pipeline_properties_spec_version = 1
pub const ext_pipeline_properties_extension_name = 'VK_EXT_pipeline_properties'

pub type PipelineInfoEXT = C.VkPipelineInfoKHR

pub type PipelinePropertiesIdentifierEXT = C.VkPipelinePropertiesIdentifierEXT

@[typedef]
pub struct C.VkPipelinePropertiesIdentifierEXT {
pub mut:
	sType              StructureType = StructureType.pipeline_properties_identifier_ext
	pNext              voidptr       = unsafe { nil }
	pipelineIdentifier [uuid_size]u8
}

pub type PhysicalDevicePipelinePropertiesFeaturesEXT = C.VkPhysicalDevicePipelinePropertiesFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDevicePipelinePropertiesFeaturesEXT {
pub mut:
	sType                        StructureType = StructureType.physical_device_pipeline_properties_features_ext
	pNext                        voidptr       = unsafe { nil }
	pipelinePropertiesIdentifier Bool32
}

fn C.vkGetPipelinePropertiesEXT(C.VkDevice, &PipelineInfoEXT, &BaseOutStructure) Result

pub type PFN_vkGetPipelinePropertiesEXT = fn (C.VkDevice, &PipelineInfoEXT, &BaseOutStructure) Result

@[inline]
pub fn get_pipeline_properties_ext(device C.VkDevice,
	p_pipeline_info &PipelineInfoEXT,
	p_pipeline_properties &BaseOutStructure) Result {
	return C.vkGetPipelinePropertiesEXT(device, p_pipeline_info, p_pipeline_properties)
}

pub const ext_frame_boundary_spec_version = 1
pub const ext_frame_boundary_extension_name = 'VK_EXT_frame_boundary'

pub enum FrameBoundaryFlagBitsEXT {
	rame_end_bit_ext = int(0x00000001)
	max_enum_ext     = max_int
}

pub type FrameBoundaryFlagsEXT = u32
pub type PhysicalDeviceFrameBoundaryFeaturesEXT = C.VkPhysicalDeviceFrameBoundaryFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceFrameBoundaryFeaturesEXT {
pub mut:
	sType         StructureType = StructureType.physical_device_frame_boundary_features_ext
	pNext         voidptr       = unsafe { nil }
	frameBoundary Bool32
}

pub type FrameBoundaryEXT = C.VkFrameBoundaryEXT

@[typedef]
pub struct C.VkFrameBoundaryEXT {
pub mut:
	sType       StructureType = StructureType.frame_boundary_ext
	pNext       voidptr       = unsafe { nil }
	flags       FrameBoundaryFlagsEXT
	frameID     u64
	imageCount  u32
	pImages     C.VkImage
	bufferCount u32
	pBuffers    C.VkBuffer
	tagName     u64
	tagSize     usize
	pTag        voidptr
}

pub const ext_multisampled_render_to_single_sampled_spec_version = 1
pub const ext_multisampled_render_to_single_sampled_extension_name = 'VK_EXT_multisampled_render_to_single_sampled'

pub type PhysicalDeviceMultisampledRenderToSingleSampledFeaturesEXT = C.VkPhysicalDeviceMultisampledRenderToSingleSampledFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceMultisampledRenderToSingleSampledFeaturesEXT {
pub mut:
	sType                             StructureType = StructureType.physical_device_multisampled_render_to_single_sampled_features_ext
	pNext                             voidptr       = unsafe { nil }
	multisampledRenderToSingleSampled Bool32
}

pub type SubpassResolvePerformanceQueryEXT = C.VkSubpassResolvePerformanceQueryEXT

@[typedef]
pub struct C.VkSubpassResolvePerformanceQueryEXT {
pub mut:
	sType   StructureType = StructureType.subpass_resolve_performance_query_ext
	pNext   voidptr       = unsafe { nil }
	optimal Bool32
}

pub type MultisampledRenderToSingleSampledInfoEXT = C.VkMultisampledRenderToSingleSampledInfoEXT

@[typedef]
pub struct C.VkMultisampledRenderToSingleSampledInfoEXT {
pub mut:
	sType                                   StructureType = StructureType.multisampled_render_to_single_sampled_info_ext
	pNext                                   voidptr       = unsafe { nil }
	multisampledRenderToSingleSampledEnable Bool32
	rasterizationSamples                    SampleCountFlagBits
}

pub const ext_extended_dynamic_state_2_spec_version = 1
pub const ext_extended_dynamic_state_2_extension_name = 'VK_EXT_extended_dynamic_state2'

pub type PhysicalDeviceExtendedDynamicState2FeaturesEXT = C.VkPhysicalDeviceExtendedDynamicState2FeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceExtendedDynamicState2FeaturesEXT {
pub mut:
	sType                                   StructureType = StructureType.physical_device_extended_dynamic_state2_features_ext
	pNext                                   voidptr       = unsafe { nil }
	extendedDynamicState2                   Bool32
	extendedDynamicState2LogicOp            Bool32
	extendedDynamicState2PatchControlPoints Bool32
}

fn C.vkCmdSetPatchControlPointsEXT(C.VkCommandBuffer, u32)

pub type PFN_vkCmdSetPatchControlPointsEXT = fn (C.VkCommandBuffer, u32)

@[inline]
pub fn cmd_set_patch_control_points_ext(command_buffer C.VkCommandBuffer,
	patch_control_points u32) {
	C.vkCmdSetPatchControlPointsEXT(command_buffer, patch_control_points)
}

fn C.vkCmdSetLogicOpEXT(C.VkCommandBuffer, LogicOp)

pub type PFN_vkCmdSetLogicOpEXT = fn (C.VkCommandBuffer, LogicOp)

@[inline]
pub fn cmd_set_logic_op_ext(command_buffer C.VkCommandBuffer,
	logic_op LogicOp) {
	C.vkCmdSetLogicOpEXT(command_buffer, logic_op)
}

pub const ext_color_write_enable_spec_version = 1
pub const ext_color_write_enable_extension_name = 'VK_EXT_color_write_enable'

pub type PhysicalDeviceColorWriteEnableFeaturesEXT = C.VkPhysicalDeviceColorWriteEnableFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceColorWriteEnableFeaturesEXT {
pub mut:
	sType            StructureType = StructureType.physical_device_color_write_enable_features_ext
	pNext            voidptr       = unsafe { nil }
	colorWriteEnable Bool32
}

pub type PipelineColorWriteCreateInfoEXT = C.VkPipelineColorWriteCreateInfoEXT

@[typedef]
pub struct C.VkPipelineColorWriteCreateInfoEXT {
pub mut:
	sType              StructureType = StructureType.pipeline_color_write_create_info_ext
	pNext              voidptr       = unsafe { nil }
	attachmentCount    u32
	pColorWriteEnables &Bool32
}

fn C.vkCmdSetColorWriteEnableEXT(C.VkCommandBuffer, u32, &Bool32)

pub type PFN_vkCmdSetColorWriteEnableEXT = fn (C.VkCommandBuffer, u32, &Bool32)

@[inline]
pub fn cmd_set_color_write_enable_ext(command_buffer C.VkCommandBuffer,
	attachment_count u32,
	p_color_write_enables &Bool32) {
	C.vkCmdSetColorWriteEnableEXT(command_buffer, attachment_count, p_color_write_enables)
}

pub const ext_primitives_generated_query_spec_version = 1
pub const ext_primitives_generated_query_extension_name = 'VK_EXT_primitives_generated_query'

pub type PhysicalDevicePrimitivesGeneratedQueryFeaturesEXT = C.VkPhysicalDevicePrimitivesGeneratedQueryFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDevicePrimitivesGeneratedQueryFeaturesEXT {
pub mut:
	sType                                         StructureType = StructureType.physical_device_primitives_generated_query_features_ext
	pNext                                         voidptr       = unsafe { nil }
	primitivesGeneratedQuery                      Bool32
	primitivesGeneratedQueryWithRasterizerDiscard Bool32
	primitivesGeneratedQueryWithNonZeroStreams    Bool32
}

pub const ext_global_priority_query_spec_version = 1
pub const ext_global_priority_query_extension_name = 'VK_EXT_global_priority_query'
pub const max_global_priority_size_ext = max_global_priority_size_khr

pub type PhysicalDeviceGlobalPriorityQueryFeaturesEXT = C.VkPhysicalDeviceGlobalPriorityQueryFeaturesKHR

pub type QueueFamilyGlobalPriorityPropertiesEXT = C.VkQueueFamilyGlobalPriorityPropertiesKHR

pub const ext_image_view_min_lod_spec_version = 1
pub const ext_image_view_min_lod_extension_name = 'VK_EXT_image_view_min_lod'

pub type PhysicalDeviceImageViewMinLodFeaturesEXT = C.VkPhysicalDeviceImageViewMinLodFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceImageViewMinLodFeaturesEXT {
pub mut:
	sType  StructureType = StructureType.physical_device_image_view_min_lod_features_ext
	pNext  voidptr       = unsafe { nil }
	minLod Bool32
}

pub type ImageViewMinLodCreateInfoEXT = C.VkImageViewMinLodCreateInfoEXT

@[typedef]
pub struct C.VkImageViewMinLodCreateInfoEXT {
pub mut:
	sType  StructureType = StructureType.image_view_min_lod_create_info_ext
	pNext  voidptr       = unsafe { nil }
	minLod f32
}

pub const ext_multi_draw_spec_version = 1
pub const ext_multi_draw_extension_name = 'VK_EXT_multi_draw'

pub type PhysicalDeviceMultiDrawFeaturesEXT = C.VkPhysicalDeviceMultiDrawFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceMultiDrawFeaturesEXT {
pub mut:
	sType     StructureType = StructureType.physical_device_multi_draw_features_ext
	pNext     voidptr       = unsafe { nil }
	multiDraw Bool32
}

pub type PhysicalDeviceMultiDrawPropertiesEXT = C.VkPhysicalDeviceMultiDrawPropertiesEXT

@[typedef]
pub struct C.VkPhysicalDeviceMultiDrawPropertiesEXT {
pub mut:
	sType             StructureType = StructureType.physical_device_multi_draw_properties_ext
	pNext             voidptr       = unsafe { nil }
	maxMultiDrawCount u32
}

pub type MultiDrawInfoEXT = C.VkMultiDrawInfoEXT

@[typedef]
pub struct C.VkMultiDrawInfoEXT {
pub mut:
	firstVertex u32
	vertexCount u32
}

pub type MultiDrawIndexedInfoEXT = C.VkMultiDrawIndexedInfoEXT

@[typedef]
pub struct C.VkMultiDrawIndexedInfoEXT {
pub mut:
	firstIndex   u32
	indexCount   u32
	vertexOffset i32
}

fn C.vkCmdDrawMultiEXT(C.VkCommandBuffer, u32, &MultiDrawInfoEXT, u32, u32, u32)

pub type PFN_vkCmdDrawMultiEXT = fn (C.VkCommandBuffer, u32, &MultiDrawInfoEXT, u32, u32, u32)

@[inline]
pub fn cmd_draw_multi_ext(command_buffer C.VkCommandBuffer,
	draw_count u32,
	p_vertex_info &MultiDrawInfoEXT,
	instance_count u32,
	first_instance u32,
	stride u32) {
	C.vkCmdDrawMultiEXT(command_buffer, draw_count, p_vertex_info, instance_count, first_instance,
		stride)
}

fn C.vkCmdDrawMultiIndexedEXT(C.VkCommandBuffer, u32, &MultiDrawIndexedInfoEXT, u32, u32, u32, &i32)

pub type PFN_vkCmdDrawMultiIndexedEXT = fn (C.VkCommandBuffer, u32, &MultiDrawIndexedInfoEXT, u32, u32, u32, &i32)

@[inline]
pub fn cmd_draw_multi_indexed_ext(command_buffer C.VkCommandBuffer,
	draw_count u32,
	p_index_info &MultiDrawIndexedInfoEXT,
	instance_count u32,
	first_instance u32,
	stride u32,
	p_vertex_offset &i32) {
	C.vkCmdDrawMultiIndexedEXT(command_buffer, draw_count, p_index_info, instance_count,
		first_instance, stride, p_vertex_offset)
}

pub const ext_image_2d_view_of_3d_spec_version = 1
pub const ext_image_2d_view_of_3d_extension_name = 'VK_EXT_image_2d_view_of_3d'

pub type PhysicalDeviceImage2DViewOf3DFeaturesEXT = C.VkPhysicalDeviceImage2DViewOf3DFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceImage2DViewOf3DFeaturesEXT {
pub mut:
	sType             StructureType
	pNext             voidptr = unsafe { nil }
	image2DViewOf3D   Bool32
	sampler2DViewOf3D Bool32
}

pub const ext_shader_tile_image_spec_version = 1
pub const ext_shader_tile_image_extension_name = 'VK_EXT_shader_tile_image'

pub type PhysicalDeviceShaderTileImageFeaturesEXT = C.VkPhysicalDeviceShaderTileImageFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceShaderTileImageFeaturesEXT {
pub mut:
	sType                            StructureType = StructureType.physical_device_shader_tile_image_features_ext
	pNext                            voidptr       = unsafe { nil }
	shaderTileImageColorReadAccess   Bool32
	shaderTileImageDepthReadAccess   Bool32
	shaderTileImageStencilReadAccess Bool32
}

pub type PhysicalDeviceShaderTileImagePropertiesEXT = C.VkPhysicalDeviceShaderTileImagePropertiesEXT

@[typedef]
pub struct C.VkPhysicalDeviceShaderTileImagePropertiesEXT {
pub mut:
	sType                                            StructureType = StructureType.physical_device_shader_tile_image_properties_ext
	pNext                                            voidptr       = unsafe { nil }
	shaderTileImageCoherentReadAccelerated           Bool32
	shaderTileImageReadSampleFromPixelRateInvocation Bool32
	shaderTileImageReadFromHelperInvocation          Bool32
}

pub type C.VkMicromapEXT = voidptr

pub const ext_opacity_micromap_spec_version = 2
pub const ext_opacity_micromap_extension_name = 'VK_EXT_opacity_micromap'

pub enum MicromapTypeEXT {
	opacity_micromap_ext = 0
	max_enum_ext         = max_int
}

pub enum BuildMicromapModeEXT {
	build_ext    = 0
	max_enum_ext = max_int
}

pub enum CopyMicromapModeEXT {
	clone_ext       = 0
	serialize_ext   = 1
	deserialize_ext = 2
	compact_ext     = 3
	max_enum_ext    = max_int
}

pub enum OpacityMicromapFormatEXT {
	_2_state_ext = 1
	_4_state_ext = 2
	max_enum_ext = max_int
}

pub enum OpacityMicromapSpecialIndexEXT {
	fully_transparent_ext         = -1
	fully_opaque_ext              = -2
	fully_unknown_transparent_ext = -3
	fully_unknown_opaque_ext      = -4
	max_enum_ext                  = max_int
}

pub enum AccelerationStructureCompatibilityKHR {
	compatible_khr   = 0
	incompatible_khr = 1
	max_enum_khr     = max_int
}

pub enum AccelerationStructureBuildTypeKHR {
	host_khr           = 0
	device_khr         = 1
	host_or_device_khr = 2
	max_enum_khr       = max_int
}

pub enum BuildMicromapFlagBitsEXT {
	prefer_fast_trace_bit_ext = int(0x00000001)
	prefer_fast_build_bit_ext = int(0x00000002)
	allow_compaction_bit_ext  = int(0x00000004)
	max_enum_ext              = max_int
}

pub type BuildMicromapFlagsEXT = u32

pub enum MicromapCreateFlagBitsEXT {
	device_address_capture_replay_bit_ext = int(0x00000001)
	max_enum_ext                          = max_int
}

pub type MicromapCreateFlagsEXT = u32
pub type MicromapUsageEXT = C.VkMicromapUsageEXT

@[typedef]
pub struct C.VkMicromapUsageEXT {
pub mut:
	count            u32
	subdivisionLevel u32
	format           u32
}

pub type DeviceOrHostAddressKHR = C.VkDeviceOrHostAddressKHR

@[typedef]
pub union C.VkDeviceOrHostAddressKHR {
pub mut:
	deviceAddress DeviceAddress
	hostAddress   voidptr
}

pub type MicromapBuildInfoEXT = C.VkMicromapBuildInfoEXT

@[typedef]
pub struct C.VkMicromapBuildInfoEXT {
pub mut:
	sType               StructureType = StructureType.micromap_build_info_ext
	pNext               voidptr       = unsafe { nil }
	type                MicromapTypeEXT
	flags               BuildMicromapFlagsEXT
	mode                BuildMicromapModeEXT
	dstMicromap         C.VkMicromapEXT
	usageCountsCount    u32
	pUsageCounts        &MicromapUsageEXT
	ppUsageCounts       &&MicromapUsageEXT
	data                DeviceOrHostAddressConstKHR
	scratchData         DeviceOrHostAddressKHR
	triangleArray       DeviceOrHostAddressConstKHR
	triangleArrayStride DeviceSize
}

pub type MicromapCreateInfoEXT = C.VkMicromapCreateInfoEXT

@[typedef]
pub struct C.VkMicromapCreateInfoEXT {
pub mut:
	sType         StructureType = StructureType.micromap_create_info_ext
	pNext         voidptr       = unsafe { nil }
	createFlags   MicromapCreateFlagsEXT
	buffer        C.VkBuffer
	offset        DeviceSize
	size          DeviceSize
	type          MicromapTypeEXT
	deviceAddress DeviceAddress
}

pub type PhysicalDeviceOpacityMicromapFeaturesEXT = C.VkPhysicalDeviceOpacityMicromapFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceOpacityMicromapFeaturesEXT {
pub mut:
	sType                 StructureType = StructureType.physical_device_opacity_micromap_features_ext
	pNext                 voidptr       = unsafe { nil }
	micromap              Bool32
	micromapCaptureReplay Bool32
	micromapHostCommands  Bool32
}

pub type PhysicalDeviceOpacityMicromapPropertiesEXT = C.VkPhysicalDeviceOpacityMicromapPropertiesEXT

@[typedef]
pub struct C.VkPhysicalDeviceOpacityMicromapPropertiesEXT {
pub mut:
	sType                            StructureType = StructureType.physical_device_opacity_micromap_properties_ext
	pNext                            voidptr       = unsafe { nil }
	maxOpacity2StateSubdivisionLevel u32
	maxOpacity4StateSubdivisionLevel u32
}

pub type MicromapVersionInfoEXT = C.VkMicromapVersionInfoEXT

@[typedef]
pub struct C.VkMicromapVersionInfoEXT {
pub mut:
	sType        StructureType = StructureType.micromap_version_info_ext
	pNext        voidptr       = unsafe { nil }
	pVersionData &u8
}

pub type CopyMicromapToMemoryInfoEXT = C.VkCopyMicromapToMemoryInfoEXT

@[typedef]
pub struct C.VkCopyMicromapToMemoryInfoEXT {
pub mut:
	sType StructureType = StructureType.copy_micromap_to_memory_info_ext
	pNext voidptr       = unsafe { nil }
	src   C.VkMicromapEXT
	dst   DeviceOrHostAddressKHR
	mode  CopyMicromapModeEXT
}

pub type CopyMemoryToMicromapInfoEXT = C.VkCopyMemoryToMicromapInfoEXT

@[typedef]
pub struct C.VkCopyMemoryToMicromapInfoEXT {
pub mut:
	sType StructureType = StructureType.copy_memory_to_micromap_info_ext
	pNext voidptr       = unsafe { nil }
	src   DeviceOrHostAddressConstKHR
	dst   C.VkMicromapEXT
	mode  CopyMicromapModeEXT
}

pub type CopyMicromapInfoEXT = C.VkCopyMicromapInfoEXT

@[typedef]
pub struct C.VkCopyMicromapInfoEXT {
pub mut:
	sType StructureType = StructureType.copy_micromap_info_ext
	pNext voidptr       = unsafe { nil }
	src   C.VkMicromapEXT
	dst   C.VkMicromapEXT
	mode  CopyMicromapModeEXT
}

pub type MicromapBuildSizesInfoEXT = C.VkMicromapBuildSizesInfoEXT

@[typedef]
pub struct C.VkMicromapBuildSizesInfoEXT {
pub mut:
	sType            StructureType = StructureType.micromap_build_sizes_info_ext
	pNext            voidptr       = unsafe { nil }
	micromapSize     DeviceSize
	buildScratchSize DeviceSize
	discardable      Bool32
}

pub type AccelerationStructureTrianglesOpacityMicromapEXT = C.VkAccelerationStructureTrianglesOpacityMicromapEXT

@[typedef]
pub struct C.VkAccelerationStructureTrianglesOpacityMicromapEXT {
pub mut:
	sType            StructureType = StructureType.acceleration_structure_triangles_opacity_micromap_ext
	pNext            voidptr       = unsafe { nil }
	indexType        IndexType
	indexBuffer      DeviceOrHostAddressConstKHR
	indexStride      DeviceSize
	baseTriangle     u32
	usageCountsCount u32
	pUsageCounts     &MicromapUsageEXT
	ppUsageCounts    &&MicromapUsageEXT
	micromap         C.VkMicromapEXT
}

pub type MicromapTriangleEXT = C.VkMicromapTriangleEXT

@[typedef]
pub struct C.VkMicromapTriangleEXT {
pub mut:
	dataOffset       u32
	subdivisionLevel u16
	format           u16
}

fn C.vkCreateMicromapEXT(C.VkDevice, &MicromapCreateInfoEXT, &AllocationCallbacks, C.VkMicromapEXT) Result

pub type PFN_vkCreateMicromapEXT = fn (C.VkDevice, &MicromapCreateInfoEXT, &AllocationCallbacks, C.VkMicromapEXT) Result

@[inline]
pub fn create_micromap_ext(device C.VkDevice,
	p_create_info &MicromapCreateInfoEXT,
	p_allocator &AllocationCallbacks,
	p_micromap C.VkMicromapEXT) Result {
	return C.vkCreateMicromapEXT(device, p_create_info, p_allocator, p_micromap)
}

fn C.vkDestroyMicromapEXT(C.VkDevice, C.VkMicromapEXT, &AllocationCallbacks)

pub type PFN_vkDestroyMicromapEXT = fn (C.VkDevice, C.VkMicromapEXT, &AllocationCallbacks)

@[inline]
pub fn destroy_micromap_ext(device C.VkDevice,
	micromap C.VkMicromapEXT,
	p_allocator &AllocationCallbacks) {
	C.vkDestroyMicromapEXT(device, micromap, p_allocator)
}

fn C.vkCmdBuildMicromapsEXT(C.VkCommandBuffer, u32, &MicromapBuildInfoEXT)

pub type PFN_vkCmdBuildMicromapsEXT = fn (C.VkCommandBuffer, u32, &MicromapBuildInfoEXT)

@[inline]
pub fn cmd_build_micromaps_ext(command_buffer C.VkCommandBuffer,
	info_count u32,
	p_infos &MicromapBuildInfoEXT) {
	C.vkCmdBuildMicromapsEXT(command_buffer, info_count, p_infos)
}

fn C.vkBuildMicromapsEXT(C.VkDevice, C.VkDeferredOperationKHR, u32, &MicromapBuildInfoEXT) Result

pub type PFN_vkBuildMicromapsEXT = fn (C.VkDevice, C.VkDeferredOperationKHR, u32, &MicromapBuildInfoEXT) Result

@[inline]
pub fn build_micromaps_ext(device C.VkDevice,
	deferred_operation C.VkDeferredOperationKHR,
	info_count u32,
	p_infos &MicromapBuildInfoEXT) Result {
	return C.vkBuildMicromapsEXT(device, deferred_operation, info_count, p_infos)
}

fn C.vkCopyMicromapEXT(C.VkDevice, C.VkDeferredOperationKHR, &CopyMicromapInfoEXT) Result

pub type PFN_vkCopyMicromapEXT = fn (C.VkDevice, C.VkDeferredOperationKHR, &CopyMicromapInfoEXT) Result

@[inline]
pub fn copy_micromap_ext(device C.VkDevice,
	deferred_operation C.VkDeferredOperationKHR,
	p_info &CopyMicromapInfoEXT) Result {
	return C.vkCopyMicromapEXT(device, deferred_operation, p_info)
}

fn C.vkCopyMicromapToMemoryEXT(C.VkDevice, C.VkDeferredOperationKHR, &CopyMicromapToMemoryInfoEXT) Result

pub type PFN_vkCopyMicromapToMemoryEXT = fn (C.VkDevice, C.VkDeferredOperationKHR, &CopyMicromapToMemoryInfoEXT) Result

@[inline]
pub fn copy_micromap_to_memory_ext(device C.VkDevice,
	deferred_operation C.VkDeferredOperationKHR,
	p_info &CopyMicromapToMemoryInfoEXT) Result {
	return C.vkCopyMicromapToMemoryEXT(device, deferred_operation, p_info)
}

fn C.vkCopyMemoryToMicromapEXT(C.VkDevice, C.VkDeferredOperationKHR, &CopyMemoryToMicromapInfoEXT) Result

pub type PFN_vkCopyMemoryToMicromapEXT = fn (C.VkDevice, C.VkDeferredOperationKHR, &CopyMemoryToMicromapInfoEXT) Result

@[inline]
pub fn copy_memory_to_micromap_ext(device C.VkDevice,
	deferred_operation C.VkDeferredOperationKHR,
	p_info &CopyMemoryToMicromapInfoEXT) Result {
	return C.vkCopyMemoryToMicromapEXT(device, deferred_operation, p_info)
}

fn C.vkWriteMicromapsPropertiesEXT(C.VkDevice, u32, C.VkMicromapEXT, QueryType, usize, voidptr, usize) Result

pub type PFN_vkWriteMicromapsPropertiesEXT = fn (C.VkDevice, u32, C.VkMicromapEXT, QueryType, usize, voidptr, usize) Result

@[inline]
pub fn write_micromaps_properties_ext(device C.VkDevice,
	micromap_count u32,
	p_micromaps C.VkMicromapEXT,
	query_type QueryType,
	data_size usize,
	p_data voidptr,
	stride usize) Result {
	return C.vkWriteMicromapsPropertiesEXT(device, micromap_count, p_micromaps, query_type,
		data_size, p_data, stride)
}

fn C.vkCmdCopyMicromapEXT(C.VkCommandBuffer, &CopyMicromapInfoEXT)

pub type PFN_vkCmdCopyMicromapEXT = fn (C.VkCommandBuffer, &CopyMicromapInfoEXT)

@[inline]
pub fn cmd_copy_micromap_ext(command_buffer C.VkCommandBuffer,
	p_info &CopyMicromapInfoEXT) {
	C.vkCmdCopyMicromapEXT(command_buffer, p_info)
}

fn C.vkCmdCopyMicromapToMemoryEXT(C.VkCommandBuffer, &CopyMicromapToMemoryInfoEXT)

pub type PFN_vkCmdCopyMicromapToMemoryEXT = fn (C.VkCommandBuffer, &CopyMicromapToMemoryInfoEXT)

@[inline]
pub fn cmd_copy_micromap_to_memory_ext(command_buffer C.VkCommandBuffer,
	p_info &CopyMicromapToMemoryInfoEXT) {
	C.vkCmdCopyMicromapToMemoryEXT(command_buffer, p_info)
}

fn C.vkCmdCopyMemoryToMicromapEXT(C.VkCommandBuffer, &CopyMemoryToMicromapInfoEXT)

pub type PFN_vkCmdCopyMemoryToMicromapEXT = fn (C.VkCommandBuffer, &CopyMemoryToMicromapInfoEXT)

@[inline]
pub fn cmd_copy_memory_to_micromap_ext(command_buffer C.VkCommandBuffer,
	p_info &CopyMemoryToMicromapInfoEXT) {
	C.vkCmdCopyMemoryToMicromapEXT(command_buffer, p_info)
}

fn C.vkCmdWriteMicromapsPropertiesEXT(C.VkCommandBuffer, u32, C.VkMicromapEXT, QueryType, C.VkQueryPool, u32)

pub type PFN_vkCmdWriteMicromapsPropertiesEXT = fn (C.VkCommandBuffer, u32, C.VkMicromapEXT, QueryType, C.VkQueryPool, u32)

@[inline]
pub fn cmd_write_micromaps_properties_ext(command_buffer C.VkCommandBuffer,
	micromap_count u32,
	p_micromaps C.VkMicromapEXT,
	query_type QueryType,
	query_pool C.VkQueryPool,
	first_query u32) {
	C.vkCmdWriteMicromapsPropertiesEXT(command_buffer, micromap_count, p_micromaps, query_type,
		query_pool, first_query)
}

fn C.vkGetDeviceMicromapCompatibilityEXT(C.VkDevice, &MicromapVersionInfoEXT, &AccelerationStructureCompatibilityKHR)

pub type PFN_vkGetDeviceMicromapCompatibilityEXT = fn (C.VkDevice, &MicromapVersionInfoEXT, &AccelerationStructureCompatibilityKHR)

@[inline]
pub fn get_device_micromap_compatibility_ext(device C.VkDevice,
	p_version_info &MicromapVersionInfoEXT,
	p_compatibility &AccelerationStructureCompatibilityKHR) {
	C.vkGetDeviceMicromapCompatibilityEXT(device, p_version_info, p_compatibility)
}

fn C.vkGetMicromapBuildSizesEXT(C.VkDevice, AccelerationStructureBuildTypeKHR, &MicromapBuildInfoEXT, &MicromapBuildSizesInfoEXT)

pub type PFN_vkGetMicromapBuildSizesEXT = fn (C.VkDevice, AccelerationStructureBuildTypeKHR, &MicromapBuildInfoEXT, &MicromapBuildSizesInfoEXT)

@[inline]
pub fn get_micromap_build_sizes_ext(device C.VkDevice,
	build_type AccelerationStructureBuildTypeKHR,
	p_build_info &MicromapBuildInfoEXT,
	p_size_info &MicromapBuildSizesInfoEXT) {
	C.vkGetMicromapBuildSizesEXT(device, build_type, p_build_info, p_size_info)
}

pub const ext_load_store_op_none_spec_version = 1
pub const ext_load_store_op_none_extension_name = 'VK_EXT_load_store_op_none'

pub const huawei_cluster_culling_shader_spec_version = 3
pub const huawei_cluster_culling_shader_extension_name = 'VK_HAWEI_cluster_culling_shader'

pub type PhysicalDeviceClusterCullingShaderFeaturesHUAWEI = C.VkPhysicalDeviceClusterCullingShaderFeaturesHUAWEI

@[typedef]
pub struct C.VkPhysicalDeviceClusterCullingShaderFeaturesHUAWEI {
pub mut:
	sType                         StructureType = StructureType.physical_device_cluster_culling_shader_features_huawei
	pNext                         voidptr       = unsafe { nil }
	clustercullingShader          Bool32
	multiviewClusterCullingShader Bool32
}

pub type PhysicalDeviceClusterCullingShaderPropertiesHUAWEI = C.VkPhysicalDeviceClusterCullingShaderPropertiesHUAWEI

@[typedef]
pub struct C.VkPhysicalDeviceClusterCullingShaderPropertiesHUAWEI {
pub mut:
	sType                         StructureType = StructureType.physical_device_cluster_culling_shader_properties_huawei
	pNext                         voidptr       = unsafe { nil }
	maxWorkGroupCount             [3]u32
	maxWorkGroupSize              [3]u32
	maxOutputClusterCount         u32
	indirectBufferOffsetAlignment DeviceSize
}

pub type PhysicalDeviceClusterCullingShaderVrsFeaturesHUAWEI = C.VkPhysicalDeviceClusterCullingShaderVrsFeaturesHUAWEI

@[typedef]
pub struct C.VkPhysicalDeviceClusterCullingShaderVrsFeaturesHUAWEI {
pub mut:
	sType              StructureType = StructureType.physical_device_cluster_culling_shader_vrs_features_huawei
	pNext              voidptr       = unsafe { nil }
	clusterShadingRate Bool32
}

fn C.vkCmdDrawClusterHUAWEI(C.VkCommandBuffer, u32, u32, u32)

pub type PFN_vkCmdDrawClusterHUAWEI = fn (C.VkCommandBuffer, u32, u32, u32)

@[inline]
pub fn cmd_draw_cluster_huawei(command_buffer C.VkCommandBuffer,
	group_count_x u32,
	group_count_y u32,
	group_count_z u32) {
	C.vkCmdDrawClusterHUAWEI(command_buffer, group_count_x, group_count_y, group_count_z)
}

fn C.vkCmdDrawClusterIndirectHUAWEI(C.VkCommandBuffer, C.VkBuffer, DeviceSize)

pub type PFN_vkCmdDrawClusterIndirectHUAWEI = fn (C.VkCommandBuffer, C.VkBuffer, DeviceSize)

@[inline]
pub fn cmd_draw_cluster_indirect_huawei(command_buffer C.VkCommandBuffer,
	buffer C.VkBuffer,
	offset DeviceSize) {
	C.vkCmdDrawClusterIndirectHUAWEI(command_buffer, buffer, offset)
}

pub const ext_border_color_swizzle_spec_version = 1
pub const ext_border_color_swizzle_extension_name = 'VK_EXT_border_color_swizzle'

pub type PhysicalDeviceBorderColorSwizzleFeaturesEXT = C.VkPhysicalDeviceBorderColorSwizzleFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceBorderColorSwizzleFeaturesEXT {
pub mut:
	sType                       StructureType = StructureType.physical_device_border_color_swizzle_features_ext
	pNext                       voidptr       = unsafe { nil }
	borderColorSwizzle          Bool32
	borderColorSwizzleFromImage Bool32
}

pub type SamplerBorderColorComponentMappingCreateInfoEXT = C.VkSamplerBorderColorComponentMappingCreateInfoEXT

@[typedef]
pub struct C.VkSamplerBorderColorComponentMappingCreateInfoEXT {
pub mut:
	sType      StructureType = StructureType.sampler_border_color_component_mapping_create_info_ext
	pNext      voidptr       = unsafe { nil }
	components ComponentMapping
	srgb       Bool32
}

pub const ext_pageable_device_local_memory_spec_version = 1
pub const ext_pageable_device_local_memory_extension_name = 'VK_EXT_pageable_device_local_memory'

pub type PhysicalDevicePageableDeviceLocalMemoryFeaturesEXT = C.VkPhysicalDevicePageableDeviceLocalMemoryFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDevicePageableDeviceLocalMemoryFeaturesEXT {
pub mut:
	sType                     StructureType = StructureType.physical_device_pageable_device_local_memory_features_ext
	pNext                     voidptr       = unsafe { nil }
	pageableDeviceLocalMemory Bool32
}

fn C.vkSetDeviceMemoryPriorityEXT(C.VkDevice, C.VkDeviceMemory, f32)

pub type PFN_vkSetDeviceMemoryPriorityEXT = fn (C.VkDevice, C.VkDeviceMemory, f32)

@[inline]
pub fn set_device_memory_priority_ext(device C.VkDevice,
	memory C.VkDeviceMemory,
	priority f32) {
	C.vkSetDeviceMemoryPriorityEXT(device, memory, priority)
}

pub const arm_shader_core_properties_spec_version = 1
pub const arm_shader_core_properties_extension_name = 'VK_ARM_shader_core_properties'

pub type PhysicalDeviceShaderCorePropertiesARM = C.VkPhysicalDeviceShaderCorePropertiesARM

@[typedef]
pub struct C.VkPhysicalDeviceShaderCorePropertiesARM {
pub mut:
	sType     StructureType = StructureType.physical_device_shader_core_properties_arm
	pNext     voidptr       = unsafe { nil }
	pixelRate u32
	texelRate u32
	fmaRate   u32
}

pub const arm_scheduling_controls_spec_version = 1
pub const arm_scheduling_controls_extension_name = 'VK_ARM_scheduling_controls'

pub type PhysicalDeviceSchedulingControlsFlagsARM = u64

// Flag bits for PhysicalDeviceSchedulingControlsFlagBitsARM
pub type PhysicalDeviceSchedulingControlsFlagBitsARM = u64

pub const physical_device_scheduling_controls_shader_core_count_arm = u64(0x00000001)

pub type DeviceQueueShaderCoreControlCreateInfoARM = C.VkDeviceQueueShaderCoreControlCreateInfoARM

@[typedef]
pub struct C.VkDeviceQueueShaderCoreControlCreateInfoARM {
pub mut:
	sType           StructureType = StructureType.device_queue_shader_core_control_create_info_arm
	pNext           voidptr       = unsafe { nil }
	shaderCoreCount u32
}

pub type PhysicalDeviceSchedulingControlsFeaturesARM = C.VkPhysicalDeviceSchedulingControlsFeaturesARM

@[typedef]
pub struct C.VkPhysicalDeviceSchedulingControlsFeaturesARM {
pub mut:
	sType              StructureType = StructureType.physical_device_scheduling_controls_features_arm
	pNext              voidptr       = unsafe { nil }
	schedulingControls Bool32
}

pub type PhysicalDeviceSchedulingControlsPropertiesARM = C.VkPhysicalDeviceSchedulingControlsPropertiesARM

@[typedef]
pub struct C.VkPhysicalDeviceSchedulingControlsPropertiesARM {
pub mut:
	sType                   StructureType = StructureType.physical_device_scheduling_controls_properties_arm
	pNext                   voidptr       = unsafe { nil }
	schedulingControlsFlags PhysicalDeviceSchedulingControlsFlagsARM
}

pub const ext_image_sliced_view_of_3d_spec_version = 1
pub const ext_image_sliced_view_of_3d_extension_name = 'VK_EXT_image_sliced_view_of_3d'
pub const remaining_3d_slices_ext = ~u32(0)

pub type PhysicalDeviceImageSlicedViewOf3DFeaturesEXT = C.VkPhysicalDeviceImageSlicedViewOf3DFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceImageSlicedViewOf3DFeaturesEXT {
pub mut:
	sType               StructureType
	pNext               voidptr = unsafe { nil }
	imageSlicedViewOf3D Bool32
}

pub type ImageViewSlicedCreateInfoEXT = C.VkImageViewSlicedCreateInfoEXT

@[typedef]
pub struct C.VkImageViewSlicedCreateInfoEXT {
pub mut:
	sType       StructureType = StructureType.image_view_sliced_create_info_ext
	pNext       voidptr       = unsafe { nil }
	sliceOffset u32
	sliceCount  u32
}

pub const valve_descriptor_set_host_mapping_spec_version = 1
pub const valve_descriptor_set_host_mapping_extension_name = 'VK_VAVE_descriptor_set_host_mapping'

pub type PhysicalDeviceDescriptorSetHostMappingFeaturesVALVE = C.VkPhysicalDeviceDescriptorSetHostMappingFeaturesVALVE

@[typedef]
pub struct C.VkPhysicalDeviceDescriptorSetHostMappingFeaturesVALVE {
pub mut:
	sType                    StructureType = StructureType.physical_device_descriptor_set_host_mapping_features_valve
	pNext                    voidptr       = unsafe { nil }
	descriptorSetHostMapping Bool32
}

pub type DescriptorSetBindingReferenceVALVE = C.VkDescriptorSetBindingReferenceVALVE

@[typedef]
pub struct C.VkDescriptorSetBindingReferenceVALVE {
pub mut:
	sType               StructureType = StructureType.descriptor_set_binding_reference_valve
	pNext               voidptr       = unsafe { nil }
	descriptorSetLayout C.VkDescriptorSetLayout
	binding             u32
}

pub type DescriptorSetLayoutHostMappingInfoVALVE = C.VkDescriptorSetLayoutHostMappingInfoVALVE

@[typedef]
pub struct C.VkDescriptorSetLayoutHostMappingInfoVALVE {
pub mut:
	sType            StructureType = StructureType.descriptor_set_layout_host_mapping_info_valve
	pNext            voidptr       = unsafe { nil }
	descriptorOffset usize
	descriptorSize   u32
}

fn C.vkGetDescriptorSetLayoutHostMappingInfoVALVE(C.VkDevice, &DescriptorSetBindingReferenceVALVE, &DescriptorSetLayoutHostMappingInfoVALVE)

pub type PFN_vkGetDescriptorSetLayoutHostMappingInfoVALVE = fn (C.VkDevice, &DescriptorSetBindingReferenceVALVE, &DescriptorSetLayoutHostMappingInfoVALVE)

@[inline]
pub fn get_descriptor_set_layout_host_mapping_info_valve(device C.VkDevice,
	p_binding_reference &DescriptorSetBindingReferenceVALVE,
	p_host_mapping &DescriptorSetLayoutHostMappingInfoVALVE) {
	C.vkGetDescriptorSetLayoutHostMappingInfoVALVE(device, p_binding_reference, p_host_mapping)
}

fn C.vkGetDescriptorSetHostMappingVALVE(C.VkDevice, C.VkDescriptorSet, &voidptr)

pub type PFN_vkGetDescriptorSetHostMappingVALVE = fn (C.VkDevice, C.VkDescriptorSet, &voidptr)

@[inline]
pub fn get_descriptor_set_host_mapping_valve(device C.VkDevice,
	descriptor_set C.VkDescriptorSet,
	pp_data &voidptr) {
	C.vkGetDescriptorSetHostMappingVALVE(device, descriptor_set, pp_data)
}

pub const ext_depth_clamp_zero_one_spec_version = 1
pub const ext_depth_clamp_zero_one_extension_name = 'VK_EXT_depth_clamp_zero_one'

pub type PhysicalDeviceDepthClampZeroOneFeaturesEXT = C.VkPhysicalDeviceDepthClampZeroOneFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceDepthClampZeroOneFeaturesEXT {
pub mut:
	sType             StructureType = StructureType.physical_device_depth_clamp_zero_one_features_ext
	pNext             voidptr       = unsafe { nil }
	depthClampZeroOne Bool32
}

pub const ext_non_seamless_cube_map_spec_version = 1
pub const ext_non_seamless_cube_map_extension_name = 'VK_EXT_non_seamless_cube_map'

pub type PhysicalDeviceNonSeamlessCubeMapFeaturesEXT = C.VkPhysicalDeviceNonSeamlessCubeMapFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceNonSeamlessCubeMapFeaturesEXT {
pub mut:
	sType              StructureType = StructureType.physical_device_non_seamless_cube_map_features_ext
	pNext              voidptr       = unsafe { nil }
	nonSeamlessCubeMap Bool32
}

pub const arm_render_pass_striped_spec_version = 1
pub const arm_render_pass_striped_extension_name = 'VK_ARM_render_pass_striped'

pub type PhysicalDeviceRenderPassStripedFeaturesARM = C.VkPhysicalDeviceRenderPassStripedFeaturesARM

@[typedef]
pub struct C.VkPhysicalDeviceRenderPassStripedFeaturesARM {
pub mut:
	sType             StructureType = StructureType.physical_device_render_pass_striped_features_arm
	pNext             voidptr       = unsafe { nil }
	renderPassStriped Bool32
}

pub type PhysicalDeviceRenderPassStripedPropertiesARM = C.VkPhysicalDeviceRenderPassStripedPropertiesARM

@[typedef]
pub struct C.VkPhysicalDeviceRenderPassStripedPropertiesARM {
pub mut:
	sType                       StructureType = StructureType.physical_device_render_pass_striped_properties_arm
	pNext                       voidptr       = unsafe { nil }
	renderPassStripeGranularity Extent2D
	maxRenderPassStripes        u32
}

pub type RenderPassStripeInfoARM = C.VkRenderPassStripeInfoARM

@[typedef]
pub struct C.VkRenderPassStripeInfoARM {
pub mut:
	sType      StructureType = StructureType.render_pass_stripe_info_arm
	pNext      voidptr       = unsafe { nil }
	stripeArea Rect2D
}

pub type RenderPassStripeBeginInfoARM = C.VkRenderPassStripeBeginInfoARM

@[typedef]
pub struct C.VkRenderPassStripeBeginInfoARM {
pub mut:
	sType           StructureType = StructureType.render_pass_stripe_begin_info_arm
	pNext           voidptr       = unsafe { nil }
	stripeInfoCount u32
	pStripeInfos    &RenderPassStripeInfoARM
}

pub type RenderPassStripeSubmitInfoARM = C.VkRenderPassStripeSubmitInfoARM

@[typedef]
pub struct C.VkRenderPassStripeSubmitInfoARM {
pub mut:
	sType                    StructureType = StructureType.render_pass_stripe_submit_info_arm
	pNext                    voidptr       = unsafe { nil }
	stripeSemaphoreInfoCount u32
	pStripeSemaphoreInfos    &SemaphoreSubmitInfo
}

pub const qcom_fragment_density_map_offset_spec_version = 1
pub const qcom_fragment_density_map_offset_extension_name = 'VK_QCOM_fragment_density_map_offset'

pub type PhysicalDeviceFragmentDensityMapOffsetFeaturesQCOM = C.VkPhysicalDeviceFragmentDensityMapOffsetFeaturesQCOM

@[typedef]
pub struct C.VkPhysicalDeviceFragmentDensityMapOffsetFeaturesQCOM {
pub mut:
	sType                    StructureType = StructureType.physical_device_fragment_density_map_offset_features_qcom
	pNext                    voidptr       = unsafe { nil }
	fragmentDensityMapOffset Bool32
}

pub type PhysicalDeviceFragmentDensityMapOffsetPropertiesQCOM = C.VkPhysicalDeviceFragmentDensityMapOffsetPropertiesQCOM

@[typedef]
pub struct C.VkPhysicalDeviceFragmentDensityMapOffsetPropertiesQCOM {
pub mut:
	sType                            StructureType = StructureType.physical_device_fragment_density_map_offset_properties_qcom
	pNext                            voidptr       = unsafe { nil }
	fragmentDensityOffsetGranularity Extent2D
}

pub type SubpassFragmentDensityMapOffsetEndInfoQCOM = C.VkSubpassFragmentDensityMapOffsetEndInfoQCOM

@[typedef]
pub struct C.VkSubpassFragmentDensityMapOffsetEndInfoQCOM {
pub mut:
	sType                      StructureType = StructureType.subpass_fragment_density_map_offset_end_info_qcom
	pNext                      voidptr       = unsafe { nil }
	fragmentDensityOffsetCount u32
	pFragmentDensityOffsets    &Offset2D
}

pub const nv_copy_memory_indirect_spec_version = 1
pub const nv_copy_memory_indirect_extension_name = 'VK_NV_copy_memory_indirect'

pub type CopyMemoryIndirectCommandNV = C.VkCopyMemoryIndirectCommandNV

@[typedef]
pub struct C.VkCopyMemoryIndirectCommandNV {
pub mut:
	srcAddress DeviceAddress
	dstAddress DeviceAddress
	size       DeviceSize
}

pub type CopyMemoryToImageIndirectCommandNV = C.VkCopyMemoryToImageIndirectCommandNV

@[typedef]
pub struct C.VkCopyMemoryToImageIndirectCommandNV {
pub mut:
	srcAddress        DeviceAddress
	bufferRowLength   u32
	bufferImageHeight u32
	imageSubresource  ImageSubresourceLayers
	imageOffset       Offset3D
	imageExtent       Extent3D
}

pub type PhysicalDeviceCopyMemoryIndirectFeaturesNV = C.VkPhysicalDeviceCopyMemoryIndirectFeaturesNV

@[typedef]
pub struct C.VkPhysicalDeviceCopyMemoryIndirectFeaturesNV {
pub mut:
	sType        StructureType = StructureType.physical_device_copy_memory_indirect_features_nv
	pNext        voidptr       = unsafe { nil }
	indirectCopy Bool32
}

pub type PhysicalDeviceCopyMemoryIndirectPropertiesNV = C.VkPhysicalDeviceCopyMemoryIndirectPropertiesNV

@[typedef]
pub struct C.VkPhysicalDeviceCopyMemoryIndirectPropertiesNV {
pub mut:
	sType           StructureType = StructureType.physical_device_copy_memory_indirect_properties_nv
	pNext           voidptr       = unsafe { nil }
	supportedQueues QueueFlags
}

fn C.vkCmdCopyMemoryIndirectNV(C.VkCommandBuffer, DeviceAddress, u32, u32)

pub type PFN_vkCmdCopyMemoryIndirectNV = fn (C.VkCommandBuffer, DeviceAddress, u32, u32)

@[inline]
pub fn cmd_copy_memory_indirect_nv(command_buffer C.VkCommandBuffer,
	copy_buffer_address DeviceAddress,
	copy_count u32,
	stride u32) {
	C.vkCmdCopyMemoryIndirectNV(command_buffer, copy_buffer_address, copy_count, stride)
}

fn C.vkCmdCopyMemoryToImageIndirectNV(C.VkCommandBuffer, DeviceAddress, u32, u32, C.VkImage, ImageLayout, &ImageSubresourceLayers)

pub type PFN_vkCmdCopyMemoryToImageIndirectNV = fn (C.VkCommandBuffer, DeviceAddress, u32, u32, C.VkImage, ImageLayout, &ImageSubresourceLayers)

@[inline]
pub fn cmd_copy_memory_to_image_indirect_nv(command_buffer C.VkCommandBuffer,
	copy_buffer_address DeviceAddress,
	copy_count u32,
	stride u32,
	dst_image C.VkImage,
	dst_image_layout ImageLayout,
	p_image_subresources &ImageSubresourceLayers) {
	C.vkCmdCopyMemoryToImageIndirectNV(command_buffer, copy_buffer_address, copy_count,
		stride, dst_image, dst_image_layout, p_image_subresources)
}

pub const nv_memory_decompression_spec_version = 1
pub const nv_memory_decompression_extension_name = 'VK_NV_memory_decompression'

// Flag bits for MemoryDecompressionMethodFlagBitsNV
pub type MemoryDecompressionMethodFlagBitsNV = u64

pub const memory_decompression_method_gdeflate_1_0_bit_nv = u64(0x00000001)

pub type MemoryDecompressionMethodFlagsNV = u64
pub type DecompressMemoryRegionNV = C.VkDecompressMemoryRegionNV

@[typedef]
pub struct C.VkDecompressMemoryRegionNV {
pub mut:
	srcAddress          DeviceAddress
	dstAddress          DeviceAddress
	compressedSize      DeviceSize
	decompressedSize    DeviceSize
	decompressionMethod MemoryDecompressionMethodFlagsNV
}

pub type PhysicalDeviceMemoryDecompressionFeaturesNV = C.VkPhysicalDeviceMemoryDecompressionFeaturesNV

@[typedef]
pub struct C.VkPhysicalDeviceMemoryDecompressionFeaturesNV {
pub mut:
	sType               StructureType = StructureType.physical_device_memory_decompression_features_nv
	pNext               voidptr       = unsafe { nil }
	memoryDecompression Bool32
}

pub type PhysicalDeviceMemoryDecompressionPropertiesNV = C.VkPhysicalDeviceMemoryDecompressionPropertiesNV

@[typedef]
pub struct C.VkPhysicalDeviceMemoryDecompressionPropertiesNV {
pub mut:
	sType                         StructureType = StructureType.physical_device_memory_decompression_properties_nv
	pNext                         voidptr       = unsafe { nil }
	decompressionMethods          MemoryDecompressionMethodFlagsNV
	maxDecompressionIndirectCount u64
}

fn C.vkCmdDecompressMemoryNV(C.VkCommandBuffer, u32, &DecompressMemoryRegionNV)

pub type PFN_vkCmdDecompressMemoryNV = fn (C.VkCommandBuffer, u32, &DecompressMemoryRegionNV)

@[inline]
pub fn cmd_decompress_memory_nv(command_buffer C.VkCommandBuffer,
	decompress_region_count u32,
	p_decompress_memory_regions &DecompressMemoryRegionNV) {
	C.vkCmdDecompressMemoryNV(command_buffer, decompress_region_count, p_decompress_memory_regions)
}

fn C.vkCmdDecompressMemoryIndirectCountNV(C.VkCommandBuffer, DeviceAddress, DeviceAddress, u32)

pub type PFN_vkCmdDecompressMemoryIndirectCountNV = fn (C.VkCommandBuffer, DeviceAddress, DeviceAddress, u32)

@[inline]
pub fn cmd_decompress_memory_indirect_count_nv(command_buffer C.VkCommandBuffer,
	indirect_commands_address DeviceAddress,
	indirect_commands_count_address DeviceAddress,
	stride u32) {
	C.vkCmdDecompressMemoryIndirectCountNV(command_buffer, indirect_commands_address,
		indirect_commands_count_address, stride)
}

pub const nv_device_generated_commands_compute_spec_version = 2
pub const nv_device_generated_commands_compute_extension_name = 'VK_NV_device_generated_commands_compute'

pub type PhysicalDeviceDeviceGeneratedCommandsComputeFeaturesNV = C.VkPhysicalDeviceDeviceGeneratedCommandsComputeFeaturesNV

@[typedef]
pub struct C.VkPhysicalDeviceDeviceGeneratedCommandsComputeFeaturesNV {
pub mut:
	sType                               StructureType = StructureType.physical_device_device_generated_commands_compute_features_nv
	pNext                               voidptr       = unsafe { nil }
	deviceGeneratedCompute              Bool32
	deviceGeneratedComputePipelines     Bool32
	deviceGeneratedComputeCaptureReplay Bool32
}

pub type ComputePipelineIndirectBufferInfoNV = C.VkComputePipelineIndirectBufferInfoNV

@[typedef]
pub struct C.VkComputePipelineIndirectBufferInfoNV {
pub mut:
	sType                              StructureType = StructureType.compute_pipeline_indirect_buffer_info_nv
	pNext                              voidptr       = unsafe { nil }
	deviceAddress                      DeviceAddress
	size                               DeviceSize
	pipelineDeviceAddressCaptureReplay DeviceAddress
}

pub type PipelineIndirectDeviceAddressInfoNV = C.VkPipelineIndirectDeviceAddressInfoNV

@[typedef]
pub struct C.VkPipelineIndirectDeviceAddressInfoNV {
pub mut:
	sType             StructureType = StructureType.pipeline_indirect_device_address_info_nv
	pNext             voidptr       = unsafe { nil }
	pipelineBindPoint PipelineBindPoint
	pipeline          C.VkPipeline
}

pub type BindPipelineIndirectCommandNV = C.VkBindPipelineIndirectCommandNV

@[typedef]
pub struct C.VkBindPipelineIndirectCommandNV {
pub mut:
	pipelineAddress DeviceAddress
}

fn C.vkGetPipelineIndirectMemoryRequirementsNV(C.VkDevice, &ComputePipelineCreateInfo, &MemoryRequirements2)

pub type PFN_vkGetPipelineIndirectMemoryRequirementsNV = fn (C.VkDevice, &ComputePipelineCreateInfo, &MemoryRequirements2)

@[inline]
pub fn get_pipeline_indirect_memory_requirements_nv(device C.VkDevice,
	p_create_info &ComputePipelineCreateInfo,
	p_memory_requirements &MemoryRequirements2) {
	C.vkGetPipelineIndirectMemoryRequirementsNV(device, p_create_info, p_memory_requirements)
}

fn C.vkCmdUpdatePipelineIndirectBufferNV(C.VkCommandBuffer, PipelineBindPoint, C.VkPipeline)

pub type PFN_vkCmdUpdatePipelineIndirectBufferNV = fn (C.VkCommandBuffer, PipelineBindPoint, C.VkPipeline)

@[inline]
pub fn cmd_update_pipeline_indirect_buffer_nv(command_buffer C.VkCommandBuffer,
	pipeline_bind_point PipelineBindPoint,
	pipeline C.VkPipeline) {
	C.vkCmdUpdatePipelineIndirectBufferNV(command_buffer, pipeline_bind_point, pipeline)
}

fn C.vkGetPipelineIndirectDeviceAddressNV(C.VkDevice, &PipelineIndirectDeviceAddressInfoNV) DeviceAddress

pub type PFN_vkGetPipelineIndirectDeviceAddressNV = fn (C.VkDevice, &PipelineIndirectDeviceAddressInfoNV) DeviceAddress

@[inline]
pub fn get_pipeline_indirect_device_address_nv(device C.VkDevice,
	p_info &PipelineIndirectDeviceAddressInfoNV) DeviceAddress {
	return C.vkGetPipelineIndirectDeviceAddressNV(device, p_info)
}

pub const nv_linear_color_attachment_spec_version = 1
pub const nv_linear_color_attachment_extension_name = 'VK_NV_linear_color_attachment'

pub type PhysicalDeviceLinearColorAttachmentFeaturesNV = C.VkPhysicalDeviceLinearColorAttachmentFeaturesNV

@[typedef]
pub struct C.VkPhysicalDeviceLinearColorAttachmentFeaturesNV {
pub mut:
	sType                 StructureType = StructureType.physical_device_linear_color_attachment_features_nv
	pNext                 voidptr       = unsafe { nil }
	linearColorAttachment Bool32
}

pub const google_surfaceless_query_spec_version = 2
pub const google_surfaceless_query_extension_name = 'VK_GOOGE_surfaceless_query'

pub const ext_image_compression_control_swapchain_spec_version = 1
pub const ext_image_compression_control_swapchain_extension_name = 'VK_EXT_image_compression_control_swapchain'

pub type PhysicalDeviceImageCompressionControlSwapchainFeaturesEXT = C.VkPhysicalDeviceImageCompressionControlSwapchainFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceImageCompressionControlSwapchainFeaturesEXT {
pub mut:
	sType                            StructureType = StructureType.physical_device_image_compression_control_swapchain_features_ext
	pNext                            voidptr       = unsafe { nil }
	imageCompressionControlSwapchain Bool32
}

pub const qcom_image_processing_spec_version = 1
pub const qcom_image_processing_extension_name = 'VK_QCOM_image_processing'

pub type ImageViewSampleWeightCreateInfoQCOM = C.VkImageViewSampleWeightCreateInfoQCOM

@[typedef]
pub struct C.VkImageViewSampleWeightCreateInfoQCOM {
pub mut:
	sType        StructureType = StructureType.image_view_sample_weight_create_info_qcom
	pNext        voidptr       = unsafe { nil }
	filterCenter Offset2D
	filterSize   Extent2D
	numPhases    u32
}

pub type PhysicalDeviceImageProcessingFeaturesQCOM = C.VkPhysicalDeviceImageProcessingFeaturesQCOM

@[typedef]
pub struct C.VkPhysicalDeviceImageProcessingFeaturesQCOM {
pub mut:
	sType                 StructureType = StructureType.physical_device_image_processing_features_qcom
	pNext                 voidptr       = unsafe { nil }
	textureSampleWeighted Bool32
	textureBoxFilter      Bool32
	textureBlockMatch     Bool32
}

pub type PhysicalDeviceImageProcessingPropertiesQCOM = C.VkPhysicalDeviceImageProcessingPropertiesQCOM

@[typedef]
pub struct C.VkPhysicalDeviceImageProcessingPropertiesQCOM {
pub mut:
	sType                    StructureType = StructureType.physical_device_image_processing_properties_qcom
	pNext                    voidptr       = unsafe { nil }
	maxWeightFilterPhases    u32
	maxWeightFilterDimension Extent2D
	maxBlockMatchRegion      Extent2D
	maxBoxFilterBlockSize    Extent2D
}

pub const ext_nested_command_buffer_spec_version = 1
pub const ext_nested_command_buffer_extension_name = 'VK_EXT_nested_command_buffer'

pub type PhysicalDeviceNestedCommandBufferFeaturesEXT = C.VkPhysicalDeviceNestedCommandBufferFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceNestedCommandBufferFeaturesEXT {
pub mut:
	sType                              StructureType = StructureType.physical_device_nested_command_buffer_features_ext
	pNext                              voidptr       = unsafe { nil }
	nestedCommandBuffer                Bool32
	nestedCommandBufferRendering       Bool32
	nestedCommandBufferSimultaneousUse Bool32
}

pub type PhysicalDeviceNestedCommandBufferPropertiesEXT = C.VkPhysicalDeviceNestedCommandBufferPropertiesEXT

@[typedef]
pub struct C.VkPhysicalDeviceNestedCommandBufferPropertiesEXT {
pub mut:
	sType                        StructureType = StructureType.physical_device_nested_command_buffer_properties_ext
	pNext                        voidptr       = unsafe { nil }
	maxCommandBufferNestingLevel u32
}

pub const ext_external_memory_acquire_unmodified_spec_version = 1
pub const ext_external_memory_acquire_unmodified_extension_name = 'VK_EXT_external_memory_acquire_unmodified'

pub type ExternalMemoryAcquireUnmodifiedEXT = C.VkExternalMemoryAcquireUnmodifiedEXT

@[typedef]
pub struct C.VkExternalMemoryAcquireUnmodifiedEXT {
pub mut:
	sType                   StructureType = StructureType.external_memory_acquire_unmodified_ext
	pNext                   voidptr       = unsafe { nil }
	acquireUnmodifiedMemory Bool32
}

pub const ext_extended_dynamic_state_3_spec_version = 2
pub const ext_extended_dynamic_state_3_extension_name = 'VK_EXT_extended_dynamic_state3'

pub type PhysicalDeviceExtendedDynamicState3FeaturesEXT = C.VkPhysicalDeviceExtendedDynamicState3FeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceExtendedDynamicState3FeaturesEXT {
pub mut:
	sType                                                 StructureType = StructureType.physical_device_extended_dynamic_state3_features_ext
	pNext                                                 voidptr       = unsafe { nil }
	extendedDynamicState3TessellationDomainOrigin         Bool32
	extendedDynamicState3DepthClampEnable                 Bool32
	extendedDynamicState3PolygonMode                      Bool32
	extendedDynamicState3RasterizationSamples             Bool32
	extendedDynamicState3SampleMask                       Bool32
	extendedDynamicState3AlphaToCoverageEnable            Bool32
	extendedDynamicState3AlphaToOneEnable                 Bool32
	extendedDynamicState3LogicOpEnable                    Bool32
	extendedDynamicState3ColorBlendEnable                 Bool32
	extendedDynamicState3ColorBlendEquation               Bool32
	extendedDynamicState3ColorWriteMask                   Bool32
	extendedDynamicState3RasterizationStream              Bool32
	extendedDynamicState3ConservativeRasterizationMode    Bool32
	extendedDynamicState3ExtraPrimitiveOverestimationSize Bool32
	extendedDynamicState3DepthClipEnable                  Bool32
	extendedDynamicState3SampleLocationsEnable            Bool32
	extendedDynamicState3ColorBlendAdvanced               Bool32
	extendedDynamicState3ProvokingVertexMode              Bool32
	extendedDynamicState3LineRasterizationMode            Bool32
	extendedDynamicState3LineStippleEnable                Bool32
	extendedDynamicState3DepthClipNegativeOneToOne        Bool32
	extendedDynamicState3ViewportWScalingEnable           Bool32
	extendedDynamicState3ViewportSwizzle                  Bool32
	extendedDynamicState3CoverageToColorEnable            Bool32
	extendedDynamicState3CoverageToColorLocation          Bool32
	extendedDynamicState3CoverageModulationMode           Bool32
	extendedDynamicState3CoverageModulationTableEnable    Bool32
	extendedDynamicState3CoverageModulationTable          Bool32
	extendedDynamicState3CoverageReductionMode            Bool32
	extendedDynamicState3RepresentativeFragmentTestEnable Bool32
	extendedDynamicState3ShadingRateImageEnable           Bool32
}

pub type PhysicalDeviceExtendedDynamicState3PropertiesEXT = C.VkPhysicalDeviceExtendedDynamicState3PropertiesEXT

@[typedef]
pub struct C.VkPhysicalDeviceExtendedDynamicState3PropertiesEXT {
pub mut:
	sType                                StructureType = StructureType.physical_device_extended_dynamic_state3_properties_ext
	pNext                                voidptr       = unsafe { nil }
	dynamicPrimitiveTopologyUnrestricted Bool32
}

pub type ColorBlendEquationEXT = C.VkColorBlendEquationEXT

@[typedef]
pub struct C.VkColorBlendEquationEXT {
pub mut:
	srcColorBlendFactor BlendFactor
	dstColorBlendFactor BlendFactor
	colorBlendOp        BlendOp
	srcAlphaBlendFactor BlendFactor
	dstAlphaBlendFactor BlendFactor
	alphaBlendOp        BlendOp
}

pub type ColorBlendAdvancedEXT = C.VkColorBlendAdvancedEXT

@[typedef]
pub struct C.VkColorBlendAdvancedEXT {
pub mut:
	advancedBlendOp  BlendOp
	srcPremultiplied Bool32
	dstPremultiplied Bool32
	blendOverlap     BlendOverlapEXT
	clampResults     Bool32
}

fn C.vkCmdSetTessellationDomainOriginEXT(C.VkCommandBuffer, TessellationDomainOrigin)

pub type PFN_vkCmdSetTessellationDomainOriginEXT = fn (C.VkCommandBuffer, TessellationDomainOrigin)

@[inline]
pub fn cmd_set_tessellation_domain_origin_ext(command_buffer C.VkCommandBuffer,
	domain_origin TessellationDomainOrigin) {
	C.vkCmdSetTessellationDomainOriginEXT(command_buffer, domain_origin)
}

fn C.vkCmdSetDepthClampEnableEXT(C.VkCommandBuffer, Bool32)

pub type PFN_vkCmdSetDepthClampEnableEXT = fn (C.VkCommandBuffer, Bool32)

@[inline]
pub fn cmd_set_depth_clamp_enable_ext(command_buffer C.VkCommandBuffer,
	depth_clamp_enable Bool32) {
	C.vkCmdSetDepthClampEnableEXT(command_buffer, depth_clamp_enable)
}

fn C.vkCmdSetPolygonModeEXT(C.VkCommandBuffer, PolygonMode)

pub type PFN_vkCmdSetPolygonModeEXT = fn (C.VkCommandBuffer, PolygonMode)

@[inline]
pub fn cmd_set_polygon_mode_ext(command_buffer C.VkCommandBuffer,
	polygon_mode PolygonMode) {
	C.vkCmdSetPolygonModeEXT(command_buffer, polygon_mode)
}

fn C.vkCmdSetRasterizationSamplesEXT(C.VkCommandBuffer, SampleCountFlagBits)

pub type PFN_vkCmdSetRasterizationSamplesEXT = fn (C.VkCommandBuffer, SampleCountFlagBits)

@[inline]
pub fn cmd_set_rasterization_samples_ext(command_buffer C.VkCommandBuffer,
	rasterization_samples SampleCountFlagBits) {
	C.vkCmdSetRasterizationSamplesEXT(command_buffer, rasterization_samples)
}

fn C.vkCmdSetSampleMaskEXT(C.VkCommandBuffer, SampleCountFlagBits, &SampleMask)

pub type PFN_vkCmdSetSampleMaskEXT = fn (C.VkCommandBuffer, SampleCountFlagBits, &SampleMask)

@[inline]
pub fn cmd_set_sample_mask_ext(command_buffer C.VkCommandBuffer,
	samples SampleCountFlagBits,
	p_sample_mask &SampleMask) {
	C.vkCmdSetSampleMaskEXT(command_buffer, samples, p_sample_mask)
}

fn C.vkCmdSetAlphaToCoverageEnableEXT(C.VkCommandBuffer, Bool32)

pub type PFN_vkCmdSetAlphaToCoverageEnableEXT = fn (C.VkCommandBuffer, Bool32)

@[inline]
pub fn cmd_set_alpha_to_coverage_enable_ext(command_buffer C.VkCommandBuffer,
	alpha_to_coverage_enable Bool32) {
	C.vkCmdSetAlphaToCoverageEnableEXT(command_buffer, alpha_to_coverage_enable)
}

fn C.vkCmdSetAlphaToOneEnableEXT(C.VkCommandBuffer, Bool32)

pub type PFN_vkCmdSetAlphaToOneEnableEXT = fn (C.VkCommandBuffer, Bool32)

@[inline]
pub fn cmd_set_alpha_to_one_enable_ext(command_buffer C.VkCommandBuffer,
	alpha_to_one_enable Bool32) {
	C.vkCmdSetAlphaToOneEnableEXT(command_buffer, alpha_to_one_enable)
}

fn C.vkCmdSetLogicOpEnableEXT(C.VkCommandBuffer, Bool32)

pub type PFN_vkCmdSetLogicOpEnableEXT = fn (C.VkCommandBuffer, Bool32)

@[inline]
pub fn cmd_set_logic_op_enable_ext(command_buffer C.VkCommandBuffer,
	logic_op_enable Bool32) {
	C.vkCmdSetLogicOpEnableEXT(command_buffer, logic_op_enable)
}

fn C.vkCmdSetColorBlendEnableEXT(C.VkCommandBuffer, u32, u32, &Bool32)

pub type PFN_vkCmdSetColorBlendEnableEXT = fn (C.VkCommandBuffer, u32, u32, &Bool32)

@[inline]
pub fn cmd_set_color_blend_enable_ext(command_buffer C.VkCommandBuffer,
	first_attachment u32,
	attachment_count u32,
	p_color_blend_enables &Bool32) {
	C.vkCmdSetColorBlendEnableEXT(command_buffer, first_attachment, attachment_count,
		p_color_blend_enables)
}

fn C.vkCmdSetColorBlendEquationEXT(C.VkCommandBuffer, u32, u32, &ColorBlendEquationEXT)

pub type PFN_vkCmdSetColorBlendEquationEXT = fn (C.VkCommandBuffer, u32, u32, &ColorBlendEquationEXT)

@[inline]
pub fn cmd_set_color_blend_equation_ext(command_buffer C.VkCommandBuffer,
	first_attachment u32,
	attachment_count u32,
	p_color_blend_equations &ColorBlendEquationEXT) {
	C.vkCmdSetColorBlendEquationEXT(command_buffer, first_attachment, attachment_count,
		p_color_blend_equations)
}

fn C.vkCmdSetColorWriteMaskEXT(C.VkCommandBuffer, u32, u32, &ColorComponentFlags)

pub type PFN_vkCmdSetColorWriteMaskEXT = fn (C.VkCommandBuffer, u32, u32, &ColorComponentFlags)

@[inline]
pub fn cmd_set_color_write_mask_ext(command_buffer C.VkCommandBuffer,
	first_attachment u32,
	attachment_count u32,
	p_color_write_masks &ColorComponentFlags) {
	C.vkCmdSetColorWriteMaskEXT(command_buffer, first_attachment, attachment_count, p_color_write_masks)
}

fn C.vkCmdSetRasterizationStreamEXT(C.VkCommandBuffer, u32)

pub type PFN_vkCmdSetRasterizationStreamEXT = fn (C.VkCommandBuffer, u32)

@[inline]
pub fn cmd_set_rasterization_stream_ext(command_buffer C.VkCommandBuffer,
	rasterization_stream u32) {
	C.vkCmdSetRasterizationStreamEXT(command_buffer, rasterization_stream)
}

fn C.vkCmdSetConservativeRasterizationModeEXT(C.VkCommandBuffer, ConservativeRasterizationModeEXT)

pub type PFN_vkCmdSetConservativeRasterizationModeEXT = fn (C.VkCommandBuffer, ConservativeRasterizationModeEXT)

@[inline]
pub fn cmd_set_conservative_rasterization_mode_ext(command_buffer C.VkCommandBuffer,
	conservative_rasterization_mode ConservativeRasterizationModeEXT) {
	C.vkCmdSetConservativeRasterizationModeEXT(command_buffer, conservative_rasterization_mode)
}

fn C.vkCmdSetExtraPrimitiveOverestimationSizeEXT(C.VkCommandBuffer, f32)

pub type PFN_vkCmdSetExtraPrimitiveOverestimationSizeEXT = fn (C.VkCommandBuffer, f32)

@[inline]
pub fn cmd_set_extra_primitive_overestimation_size_ext(command_buffer C.VkCommandBuffer,
	extra_primitive_overestimation_size f32) {
	C.vkCmdSetExtraPrimitiveOverestimationSizeEXT(command_buffer, extra_primitive_overestimation_size)
}

fn C.vkCmdSetDepthClipEnableEXT(C.VkCommandBuffer, Bool32)

pub type PFN_vkCmdSetDepthClipEnableEXT = fn (C.VkCommandBuffer, Bool32)

@[inline]
pub fn cmd_set_depth_clip_enable_ext(command_buffer C.VkCommandBuffer,
	depth_clip_enable Bool32) {
	C.vkCmdSetDepthClipEnableEXT(command_buffer, depth_clip_enable)
}

fn C.vkCmdSetSampleLocationsEnableEXT(C.VkCommandBuffer, Bool32)

pub type PFN_vkCmdSetSampleLocationsEnableEXT = fn (C.VkCommandBuffer, Bool32)

@[inline]
pub fn cmd_set_sample_locations_enable_ext(command_buffer C.VkCommandBuffer,
	sample_locations_enable Bool32) {
	C.vkCmdSetSampleLocationsEnableEXT(command_buffer, sample_locations_enable)
}

fn C.vkCmdSetColorBlendAdvancedEXT(C.VkCommandBuffer, u32, u32, &ColorBlendAdvancedEXT)

pub type PFN_vkCmdSetColorBlendAdvancedEXT = fn (C.VkCommandBuffer, u32, u32, &ColorBlendAdvancedEXT)

@[inline]
pub fn cmd_set_color_blend_advanced_ext(command_buffer C.VkCommandBuffer,
	first_attachment u32,
	attachment_count u32,
	p_color_blend_advanced &ColorBlendAdvancedEXT) {
	C.vkCmdSetColorBlendAdvancedEXT(command_buffer, first_attachment, attachment_count,
		p_color_blend_advanced)
}

fn C.vkCmdSetProvokingVertexModeEXT(C.VkCommandBuffer, ProvokingVertexModeEXT)

pub type PFN_vkCmdSetProvokingVertexModeEXT = fn (C.VkCommandBuffer, ProvokingVertexModeEXT)

@[inline]
pub fn cmd_set_provoking_vertex_mode_ext(command_buffer C.VkCommandBuffer,
	provoking_vertex_mode ProvokingVertexModeEXT) {
	C.vkCmdSetProvokingVertexModeEXT(command_buffer, provoking_vertex_mode)
}

fn C.vkCmdSetLineRasterizationModeEXT(C.VkCommandBuffer, LineRasterizationModeEXT)

pub type PFN_vkCmdSetLineRasterizationModeEXT = fn (C.VkCommandBuffer, LineRasterizationModeEXT)

@[inline]
pub fn cmd_set_line_rasterization_mode_ext(command_buffer C.VkCommandBuffer,
	line_rasterization_mode LineRasterizationModeEXT) {
	C.vkCmdSetLineRasterizationModeEXT(command_buffer, line_rasterization_mode)
}

fn C.vkCmdSetLineStippleEnableEXT(C.VkCommandBuffer, Bool32)

pub type PFN_vkCmdSetLineStippleEnableEXT = fn (C.VkCommandBuffer, Bool32)

@[inline]
pub fn cmd_set_line_stipple_enable_ext(command_buffer C.VkCommandBuffer,
	stippled_line_enable Bool32) {
	C.vkCmdSetLineStippleEnableEXT(command_buffer, stippled_line_enable)
}

fn C.vkCmdSetDepthClipNegativeOneToOneEXT(C.VkCommandBuffer, Bool32)

pub type PFN_vkCmdSetDepthClipNegativeOneToOneEXT = fn (C.VkCommandBuffer, Bool32)

@[inline]
pub fn cmd_set_depth_clip_negative_one_to_one_ext(command_buffer C.VkCommandBuffer,
	negative_one_to_one Bool32) {
	C.vkCmdSetDepthClipNegativeOneToOneEXT(command_buffer, negative_one_to_one)
}

fn C.vkCmdSetViewportWScalingEnableNV(C.VkCommandBuffer, Bool32)

pub type PFN_vkCmdSetViewportWScalingEnableNV = fn (C.VkCommandBuffer, Bool32)

@[inline]
pub fn cmd_set_viewport_w_scaling_enable_nv(command_buffer C.VkCommandBuffer,
	viewport_w_scaling_enable Bool32) {
	C.vkCmdSetViewportWScalingEnableNV(command_buffer, viewport_w_scaling_enable)
}

fn C.vkCmdSetViewportSwizzleNV(C.VkCommandBuffer, u32, u32, &ViewportSwizzleNV)

pub type PFN_vkCmdSetViewportSwizzleNV = fn (C.VkCommandBuffer, u32, u32, &ViewportSwizzleNV)

@[inline]
pub fn cmd_set_viewport_swizzle_nv(command_buffer C.VkCommandBuffer,
	first_viewport u32,
	viewport_count u32,
	p_viewport_swizzles &ViewportSwizzleNV) {
	C.vkCmdSetViewportSwizzleNV(command_buffer, first_viewport, viewport_count, p_viewport_swizzles)
}

fn C.vkCmdSetCoverageToColorEnableNV(C.VkCommandBuffer, Bool32)

pub type PFN_vkCmdSetCoverageToColorEnableNV = fn (C.VkCommandBuffer, Bool32)

@[inline]
pub fn cmd_set_coverage_to_color_enable_nv(command_buffer C.VkCommandBuffer,
	coverage_to_color_enable Bool32) {
	C.vkCmdSetCoverageToColorEnableNV(command_buffer, coverage_to_color_enable)
}

fn C.vkCmdSetCoverageToColorLocationNV(C.VkCommandBuffer, u32)

pub type PFN_vkCmdSetCoverageToColorLocationNV = fn (C.VkCommandBuffer, u32)

@[inline]
pub fn cmd_set_coverage_to_color_location_nv(command_buffer C.VkCommandBuffer,
	coverage_to_color_location u32) {
	C.vkCmdSetCoverageToColorLocationNV(command_buffer, coverage_to_color_location)
}

fn C.vkCmdSetCoverageModulationModeNV(C.VkCommandBuffer, CoverageModulationModeNV)

pub type PFN_vkCmdSetCoverageModulationModeNV = fn (C.VkCommandBuffer, CoverageModulationModeNV)

@[inline]
pub fn cmd_set_coverage_modulation_mode_nv(command_buffer C.VkCommandBuffer,
	coverage_modulation_mode CoverageModulationModeNV) {
	C.vkCmdSetCoverageModulationModeNV(command_buffer, coverage_modulation_mode)
}

fn C.vkCmdSetCoverageModulationTableEnableNV(C.VkCommandBuffer, Bool32)

pub type PFN_vkCmdSetCoverageModulationTableEnableNV = fn (C.VkCommandBuffer, Bool32)

@[inline]
pub fn cmd_set_coverage_modulation_table_enable_nv(command_buffer C.VkCommandBuffer,
	coverage_modulation_table_enable Bool32) {
	C.vkCmdSetCoverageModulationTableEnableNV(command_buffer, coverage_modulation_table_enable)
}

fn C.vkCmdSetCoverageModulationTableNV(C.VkCommandBuffer, u32, &f32)

pub type PFN_vkCmdSetCoverageModulationTableNV = fn (C.VkCommandBuffer, u32, &f32)

@[inline]
pub fn cmd_set_coverage_modulation_table_nv(command_buffer C.VkCommandBuffer,
	coverage_modulation_table_count u32,
	p_coverage_modulation_table &f32) {
	C.vkCmdSetCoverageModulationTableNV(command_buffer, coverage_modulation_table_count,
		p_coverage_modulation_table)
}

fn C.vkCmdSetShadingRateImageEnableNV(C.VkCommandBuffer, Bool32)

pub type PFN_vkCmdSetShadingRateImageEnableNV = fn (C.VkCommandBuffer, Bool32)

@[inline]
pub fn cmd_set_shading_rate_image_enable_nv(command_buffer C.VkCommandBuffer,
	shading_rate_image_enable Bool32) {
	C.vkCmdSetShadingRateImageEnableNV(command_buffer, shading_rate_image_enable)
}

fn C.vkCmdSetRepresentativeFragmentTestEnableNV(C.VkCommandBuffer, Bool32)

pub type PFN_vkCmdSetRepresentativeFragmentTestEnableNV = fn (C.VkCommandBuffer, Bool32)

@[inline]
pub fn cmd_set_representative_fragment_test_enable_nv(command_buffer C.VkCommandBuffer,
	representative_fragment_test_enable Bool32) {
	C.vkCmdSetRepresentativeFragmentTestEnableNV(command_buffer, representative_fragment_test_enable)
}

fn C.vkCmdSetCoverageReductionModeNV(C.VkCommandBuffer, CoverageReductionModeNV)

pub type PFN_vkCmdSetCoverageReductionModeNV = fn (C.VkCommandBuffer, CoverageReductionModeNV)

@[inline]
pub fn cmd_set_coverage_reduction_mode_nv(command_buffer C.VkCommandBuffer,
	coverage_reduction_mode CoverageReductionModeNV) {
	C.vkCmdSetCoverageReductionModeNV(command_buffer, coverage_reduction_mode)
}

pub const ext_subpass_merge_feedback_spec_version = 2
pub const ext_subpass_merge_feedback_extension_name = 'VK_EXT_subpass_merge_feedback'

pub enum SubpassMergeStatusEXT {
	merged_ext                                   = 0
	disallowed_ext                               = 1
	not_merged_side_effects_ext                  = 2
	not_merged_samples_mismatch_ext              = 3
	not_merged_views_mismatch_ext                = 4
	not_merged_aliasing_ext                      = 5
	not_merged_dependencies_ext                  = 6
	not_merged_incompatible_input_attachment_ext = 7
	not_merged_too_many_attachments_ext          = 8
	not_merged_insufficient_storage_ext          = 9
	not_merged_depth_stencil_count_ext           = 10
	not_merged_resolve_attachment_reuse_ext      = 11
	not_merged_single_subpass_ext                = 12
	not_merged_unspecified_ext                   = 13
	max_enum_ext                                 = max_int
}

pub type PhysicalDeviceSubpassMergeFeedbackFeaturesEXT = C.VkPhysicalDeviceSubpassMergeFeedbackFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceSubpassMergeFeedbackFeaturesEXT {
pub mut:
	sType                StructureType = StructureType.physical_device_subpass_merge_feedback_features_ext
	pNext                voidptr       = unsafe { nil }
	subpassMergeFeedback Bool32
}

pub type RenderPassCreationControlEXT = C.VkRenderPassCreationControlEXT

@[typedef]
pub struct C.VkRenderPassCreationControlEXT {
pub mut:
	sType           StructureType = StructureType.render_pass_creation_control_ext
	pNext           voidptr       = unsafe { nil }
	disallowMerging Bool32
}

pub type RenderPassCreationFeedbackInfoEXT = C.VkRenderPassCreationFeedbackInfoEXT

@[typedef]
pub struct C.VkRenderPassCreationFeedbackInfoEXT {
pub mut:
	postMergeSubpassCount u32
}

pub type RenderPassCreationFeedbackCreateInfoEXT = C.VkRenderPassCreationFeedbackCreateInfoEXT

@[typedef]
pub struct C.VkRenderPassCreationFeedbackCreateInfoEXT {
pub mut:
	sType               StructureType = StructureType.render_pass_creation_feedback_create_info_ext
	pNext               voidptr       = unsafe { nil }
	pRenderPassFeedback &RenderPassCreationFeedbackInfoEXT
}

pub type RenderPassSubpassFeedbackInfoEXT = C.VkRenderPassSubpassFeedbackInfoEXT

@[typedef]
pub struct C.VkRenderPassSubpassFeedbackInfoEXT {
pub mut:
	subpassMergeStatus SubpassMergeStatusEXT
	description        [max_description_size]char
	postMergeIndex     u32
}

pub type RenderPassSubpassFeedbackCreateInfoEXT = C.VkRenderPassSubpassFeedbackCreateInfoEXT

@[typedef]
pub struct C.VkRenderPassSubpassFeedbackCreateInfoEXT {
pub mut:
	sType            StructureType = StructureType.render_pass_subpass_feedback_create_info_ext
	pNext            voidptr       = unsafe { nil }
	pSubpassFeedback &RenderPassSubpassFeedbackInfoEXT
}

pub const lunarg_direct_driver_loading_spec_version = 1
pub const lunarg_direct_driver_loading_extension_name = 'VK_NARG_direct_driver_loading'

pub enum DirectDriverLoadingModeLUNARG {
	exclusive_lunarg = 0
	inclusive_lunarg = 1
	max_enum_lunarg  = max_int
}

pub type DirectDriverLoadingFlagsLUNARG = u32
pub type PFN_vkGetInstanceProcAddrLUNARG = fn (instanceconst C.VkInstance, pName &char)

pub type DirectDriverLoadingInfoLUNARG = C.VkDirectDriverLoadingInfoLUNARG

@[typedef]
pub struct C.VkDirectDriverLoadingInfoLUNARG {
pub mut:
	sType                  StructureType = StructureType.direct_driver_loading_info_lunarg
	pNext                  voidptr       = unsafe { nil }
	flags                  DirectDriverLoadingFlagsLUNARG
	pfnGetInstanceProcAddr PFN_vkGetInstanceProcAddrLUNARG = unsafe { nil }
}

pub type DirectDriverLoadingListLUNARG = C.VkDirectDriverLoadingListLUNARG

@[typedef]
pub struct C.VkDirectDriverLoadingListLUNARG {
pub mut:
	sType       StructureType = StructureType.direct_driver_loading_list_lunarg
	pNext       voidptr       = unsafe { nil }
	mode        DirectDriverLoadingModeLUNARG
	driverCount u32
	pDrivers    &DirectDriverLoadingInfoLUNARG
}

pub const max_shader_module_identifier_size_ext = u32(32)
pub const ext_shader_module_identifier_spec_version = 1
pub const ext_shader_module_identifier_extension_name = 'VK_EXT_shader_module_identifier'

pub type PhysicalDeviceShaderModuleIdentifierFeaturesEXT = C.VkPhysicalDeviceShaderModuleIdentifierFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceShaderModuleIdentifierFeaturesEXT {
pub mut:
	sType                  StructureType = StructureType.physical_device_shader_module_identifier_features_ext
	pNext                  voidptr       = unsafe { nil }
	shaderModuleIdentifier Bool32
}

pub type PhysicalDeviceShaderModuleIdentifierPropertiesEXT = C.VkPhysicalDeviceShaderModuleIdentifierPropertiesEXT

@[typedef]
pub struct C.VkPhysicalDeviceShaderModuleIdentifierPropertiesEXT {
pub mut:
	sType                               StructureType = StructureType.physical_device_shader_module_identifier_properties_ext
	pNext                               voidptr       = unsafe { nil }
	shaderModuleIdentifierAlgorithmUUID [uuid_size]u8
}

pub type PipelineShaderStageModuleIdentifierCreateInfoEXT = C.VkPipelineShaderStageModuleIdentifierCreateInfoEXT

@[typedef]
pub struct C.VkPipelineShaderStageModuleIdentifierCreateInfoEXT {
pub mut:
	sType          StructureType = StructureType.pipeline_shader_stage_module_identifier_create_info_ext
	pNext          voidptr       = unsafe { nil }
	identifierSize u32
	pIdentifier    &u8
}

pub type ShaderModuleIdentifierEXT = C.VkShaderModuleIdentifierEXT

@[typedef]
pub struct C.VkShaderModuleIdentifierEXT {
pub mut:
	sType          StructureType = StructureType.shader_module_identifier_ext
	pNext          voidptr       = unsafe { nil }
	identifierSize u32
	identifier     [max_shader_module_identifier_size_ext]u8
}

fn C.vkGetShaderModuleIdentifierEXT(C.VkDevice, C.VkShaderModule, &ShaderModuleIdentifierEXT)

pub type PFN_vkGetShaderModuleIdentifierEXT = fn (C.VkDevice, C.VkShaderModule, &ShaderModuleIdentifierEXT)

@[inline]
pub fn get_shader_module_identifier_ext(device C.VkDevice,
	shader_module C.VkShaderModule,
	p_identifier &ShaderModuleIdentifierEXT) {
	C.vkGetShaderModuleIdentifierEXT(device, shader_module, p_identifier)
}

fn C.vkGetShaderModuleCreateInfoIdentifierEXT(C.VkDevice, &ShaderModuleCreateInfo, &ShaderModuleIdentifierEXT)

pub type PFN_vkGetShaderModuleCreateInfoIdentifierEXT = fn (C.VkDevice, &ShaderModuleCreateInfo, &ShaderModuleIdentifierEXT)

@[inline]
pub fn get_shader_module_create_info_identifier_ext(device C.VkDevice,
	p_create_info &ShaderModuleCreateInfo,
	p_identifier &ShaderModuleIdentifierEXT) {
	C.vkGetShaderModuleCreateInfoIdentifierEXT(device, p_create_info, p_identifier)
}

pub const ext_rasterization_order_attachment_access_spec_version = 1
pub const ext_rasterization_order_attachment_access_extension_name = 'VK_EXT_rasterization_order_attachment_access'

pub type C.VkOpticalFlowSessionNV = voidptr

pub const nv_optical_flow_spec_version = 1
pub const nv_optical_flow_extension_name = 'VK_NV_optical_flow'

pub enum OpticalFlowPerformanceLevelNV {
	unknown_nv  = 0
	slow_nv     = 1
	medium_nv   = 2
	fast_nv     = 3
	max_enum_nv = max_int
}

pub enum OpticalFlowSessionBindingPointNV {
	unknown_nv              = 0
	input_nv                = 1
	reference_nv            = 2
	hint_nv                 = 3
	flow_vector_nv          = 4
	backward_flow_vector_nv = 5
	cost_nv                 = 6
	backward_cost_nv        = 7
	global_flow_nv          = 8
	max_enum_nv             = max_int
}

pub enum OpticalFlowGridSizeFlagBitsNV {
	unknown_nv  = 0
	_1x1_bit_nv = int(0x00000001)
	_2x2_bit_nv = int(0x00000002)
	_4x4_bit_nv = int(0x00000004)
	_8x8_bit_nv = int(0x00000008)
	max_enum_nv = max_int
}

pub type OpticalFlowGridSizeFlagsNV = u32

pub enum OpticalFlowUsageFlagBitsNV {
	unknown_nv         = 0
	input_bit_nv       = int(0x00000001)
	output_bit_nv      = int(0x00000002)
	hint_bit_nv        = int(0x00000004)
	cost_bit_nv        = int(0x00000008)
	global_flow_bit_nv = int(0x00000010)
	max_enum_nv        = max_int
}

pub type OpticalFlowUsageFlagsNV = u32

pub enum OpticalFlowSessionCreateFlagBitsNV {
	enable_hint_bit_nv        = int(0x00000001)
	enable_cost_bit_nv        = int(0x00000002)
	enable_global_flow_bit_nv = int(0x00000004)
	allow_regions_bit_nv      = int(0x00000008)
	both_directions_bit_nv    = int(0x00000010)
	max_enum_nv               = max_int
}

pub type OpticalFlowSessionCreateFlagsNV = u32

pub enum OpticalFlowExecuteFlagBitsNV {
	disable_temporal_hints_bit_nv = int(0x00000001)
	max_enum_nv                   = max_int
}

pub type OpticalFlowExecuteFlagsNV = u32
pub type PhysicalDeviceOpticalFlowFeaturesNV = C.VkPhysicalDeviceOpticalFlowFeaturesNV

@[typedef]
pub struct C.VkPhysicalDeviceOpticalFlowFeaturesNV {
pub mut:
	sType       StructureType = StructureType.physical_device_optical_flow_features_nv
	pNext       voidptr       = unsafe { nil }
	opticalFlow Bool32
}

pub type PhysicalDeviceOpticalFlowPropertiesNV = C.VkPhysicalDeviceOpticalFlowPropertiesNV

@[typedef]
pub struct C.VkPhysicalDeviceOpticalFlowPropertiesNV {
pub mut:
	sType                      StructureType = StructureType.physical_device_optical_flow_properties_nv
	pNext                      voidptr       = unsafe { nil }
	supportedOutputGridSizes   OpticalFlowGridSizeFlagsNV
	supportedHintGridSizes     OpticalFlowGridSizeFlagsNV
	hintSupported              Bool32
	costSupported              Bool32
	bidirectionalFlowSupported Bool32
	globalFlowSupported        Bool32
	minWidth                   u32
	minHeight                  u32
	maxWidth                   u32
	maxHeight                  u32
	maxNumRegionsOfInterest    u32
}

pub type OpticalFlowImageFormatInfoNV = C.VkOpticalFlowImageFormatInfoNV

@[typedef]
pub struct C.VkOpticalFlowImageFormatInfoNV {
pub mut:
	sType StructureType = StructureType.optical_flow_image_format_info_nv
	pNext voidptr       = unsafe { nil }
	usage OpticalFlowUsageFlagsNV
}

pub type OpticalFlowImageFormatPropertiesNV = C.VkOpticalFlowImageFormatPropertiesNV

@[typedef]
pub struct C.VkOpticalFlowImageFormatPropertiesNV {
pub mut:
	sType  StructureType = StructureType.optical_flow_image_format_properties_nv
	pNext  voidptr       = unsafe { nil }
	format Format
}

pub type OpticalFlowSessionCreateInfoNV = C.VkOpticalFlowSessionCreateInfoNV

@[typedef]
pub struct C.VkOpticalFlowSessionCreateInfoNV {
pub mut:
	sType            StructureType = StructureType.optical_flow_session_create_info_nv
	pNext            voidptr       = unsafe { nil }
	width            u32
	height           u32
	imageFormat      Format
	flowVectorFormat Format
	costFormat       Format
	outputGridSize   OpticalFlowGridSizeFlagsNV
	hintGridSize     OpticalFlowGridSizeFlagsNV
	performanceLevel OpticalFlowPerformanceLevelNV
	flags            OpticalFlowSessionCreateFlagsNV
}

pub type OpticalFlowSessionCreatePrivateDataInfoNV = C.VkOpticalFlowSessionCreatePrivateDataInfoNV

@[typedef]
pub struct C.VkOpticalFlowSessionCreatePrivateDataInfoNV {
pub mut:
	sType        StructureType = StructureType.optical_flow_session_create_private_data_info_nv
	pNext        voidptr       = unsafe { nil }
	id           u32
	size         u32
	pPrivateData voidptr
}

pub type OpticalFlowExecuteInfoNV = C.VkOpticalFlowExecuteInfoNV

@[typedef]
pub struct C.VkOpticalFlowExecuteInfoNV {
pub mut:
	sType       StructureType = StructureType.optical_flow_execute_info_nv
	pNext       voidptr       = unsafe { nil }
	flags       OpticalFlowExecuteFlagsNV
	regionCount u32
	pRegions    &Rect2D
}

fn C.vkGetPhysicalDeviceOpticalFlowImageFormatsNV(C.VkPhysicalDevice, &OpticalFlowImageFormatInfoNV, &u32, &OpticalFlowImageFormatPropertiesNV) Result

pub type PFN_vkGetPhysicalDeviceOpticalFlowImageFormatsNV = fn (C.VkPhysicalDevice, &OpticalFlowImageFormatInfoNV, &u32, &OpticalFlowImageFormatPropertiesNV) Result

@[inline]
pub fn get_physical_device_optical_flow_image_formats_nv(physical_device C.VkPhysicalDevice,
	p_optical_flow_image_format_info &OpticalFlowImageFormatInfoNV,
	p_format_count &u32,
	p_image_format_properties &OpticalFlowImageFormatPropertiesNV) Result {
	return C.vkGetPhysicalDeviceOpticalFlowImageFormatsNV(physical_device, p_optical_flow_image_format_info,
		p_format_count, p_image_format_properties)
}

fn C.vkCreateOpticalFlowSessionNV(C.VkDevice, &OpticalFlowSessionCreateInfoNV, &AllocationCallbacks, C.VkOpticalFlowSessionNV) Result

pub type PFN_vkCreateOpticalFlowSessionNV = fn (C.VkDevice, &OpticalFlowSessionCreateInfoNV, &AllocationCallbacks, C.VkOpticalFlowSessionNV) Result

@[inline]
pub fn create_optical_flow_session_nv(device C.VkDevice,
	p_create_info &OpticalFlowSessionCreateInfoNV,
	p_allocator &AllocationCallbacks,
	p_session C.VkOpticalFlowSessionNV) Result {
	return C.vkCreateOpticalFlowSessionNV(device, p_create_info, p_allocator, p_session)
}

fn C.vkDestroyOpticalFlowSessionNV(C.VkDevice, C.VkOpticalFlowSessionNV, &AllocationCallbacks)

pub type PFN_vkDestroyOpticalFlowSessionNV = fn (C.VkDevice, C.VkOpticalFlowSessionNV, &AllocationCallbacks)

@[inline]
pub fn destroy_optical_flow_session_nv(device C.VkDevice,
	session C.VkOpticalFlowSessionNV,
	p_allocator &AllocationCallbacks) {
	C.vkDestroyOpticalFlowSessionNV(device, session, p_allocator)
}

fn C.vkBindOpticalFlowSessionImageNV(C.VkDevice, C.VkOpticalFlowSessionNV, OpticalFlowSessionBindingPointNV, C.VkImageView, ImageLayout) Result

pub type PFN_vkBindOpticalFlowSessionImageNV = fn (C.VkDevice, C.VkOpticalFlowSessionNV, OpticalFlowSessionBindingPointNV, C.VkImageView, ImageLayout) Result

@[inline]
pub fn bind_optical_flow_session_image_nv(device C.VkDevice,
	session C.VkOpticalFlowSessionNV,
	binding_point OpticalFlowSessionBindingPointNV,
	view C.VkImageView,
	layout ImageLayout) Result {
	return C.vkBindOpticalFlowSessionImageNV(device, session, binding_point, view, layout)
}

fn C.vkCmdOpticalFlowExecuteNV(C.VkCommandBuffer, C.VkOpticalFlowSessionNV, &OpticalFlowExecuteInfoNV)

pub type PFN_vkCmdOpticalFlowExecuteNV = fn (C.VkCommandBuffer, C.VkOpticalFlowSessionNV, &OpticalFlowExecuteInfoNV)

@[inline]
pub fn cmd_optical_flow_execute_nv(command_buffer C.VkCommandBuffer,
	session C.VkOpticalFlowSessionNV,
	p_execute_info &OpticalFlowExecuteInfoNV) {
	C.vkCmdOpticalFlowExecuteNV(command_buffer, session, p_execute_info)
}

pub const ext_legacy_dithering_spec_version = 1
pub const ext_legacy_dithering_extension_name = 'VK_EXT_legacy_dithering'

pub type PhysicalDeviceLegacyDitheringFeaturesEXT = C.VkPhysicalDeviceLegacyDitheringFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceLegacyDitheringFeaturesEXT {
pub mut:
	sType           StructureType = StructureType.physical_device_legacy_dithering_features_ext
	pNext           voidptr       = unsafe { nil }
	legacyDithering Bool32
}

pub const ext_pipeline_protected_access_spec_version = 1
pub const ext_pipeline_protected_access_extension_name = 'VK_EXT_pipeline_protected_access'

pub type PhysicalDevicePipelineProtectedAccessFeaturesEXT = C.VkPhysicalDevicePipelineProtectedAccessFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDevicePipelineProtectedAccessFeaturesEXT {
pub mut:
	sType                   StructureType = StructureType.physical_device_pipeline_protected_access_features_ext
	pNext                   voidptr       = unsafe { nil }
	pipelineProtectedAccess Bool32
}

pub type C.VkShaderEXT = voidptr

pub const ext_shader_object_spec_version = 1
pub const ext_shader_object_extension_name = 'VK_EXT_shader_object'

pub enum ShaderCodeTypeEXT {
	binary_ext   = 0
	spirv_ext    = 1
	max_enum_ext = max_int
}

pub enum ShaderCreateFlagBitsEXT {
	link_stage_bit_ext                      = int(0x00000001)
	allow_varying_subgroup_size_bit_ext     = int(0x00000002)
	require_full_subgroups_bit_ext          = int(0x00000004)
	no_task_shader_bit_ext                  = int(0x00000008)
	dispatch_base_bit_ext                   = int(0x00000010)
	ragment_shading_rate_attachment_bit_ext = int(0x00000020)
	ragment_density_map_attachment_bit_ext  = int(0x00000040)
	max_enum_ext                            = max_int
}

pub type ShaderCreateFlagsEXT = u32
pub type PhysicalDeviceShaderObjectFeaturesEXT = C.VkPhysicalDeviceShaderObjectFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceShaderObjectFeaturesEXT {
pub mut:
	sType        StructureType = StructureType.physical_device_shader_object_features_ext
	pNext        voidptr       = unsafe { nil }
	shaderObject Bool32
}

pub type PhysicalDeviceShaderObjectPropertiesEXT = C.VkPhysicalDeviceShaderObjectPropertiesEXT

@[typedef]
pub struct C.VkPhysicalDeviceShaderObjectPropertiesEXT {
pub mut:
	sType               StructureType = StructureType.physical_device_shader_object_properties_ext
	pNext               voidptr       = unsafe { nil }
	shaderBinaryUUID    [uuid_size]u8
	shaderBinaryVersion u32
}

pub type ShaderCreateInfoEXT = C.VkShaderCreateInfoEXT

@[typedef]
pub struct C.VkShaderCreateInfoEXT {
pub mut:
	sType                  StructureType = StructureType.shader_create_info_ext
	pNext                  voidptr       = unsafe { nil }
	flags                  ShaderCreateFlagsEXT
	stage                  ShaderStageFlagBits
	nextStage              ShaderStageFlags
	codeType               ShaderCodeTypeEXT
	codeSize               usize
	pCode                  voidptr
	pName                  &char
	setLayoutCount         u32
	pSetLayouts            C.VkDescriptorSetLayout
	pushConstantRangeCount u32
	pPushConstantRanges    &PushConstantRange
	pSpecializationInfo    &SpecializationInfo
}

pub type ShaderRequiredSubgroupSizeCreateInfoEXT = C.VkPipelineShaderStageRequiredSubgroupSizeCreateInfo

fn C.vkCreateShadersEXT(C.VkDevice, u32, &ShaderCreateInfoEXT, &AllocationCallbacks, C.VkShaderEXT) Result

pub type PFN_vkCreateShadersEXT = fn (C.VkDevice, u32, &ShaderCreateInfoEXT, &AllocationCallbacks, C.VkShaderEXT) Result

@[inline]
pub fn create_shaders_ext(device C.VkDevice,
	create_info_count u32,
	p_create_infos &ShaderCreateInfoEXT,
	p_allocator &AllocationCallbacks,
	p_shaders C.VkShaderEXT) Result {
	return C.vkCreateShadersEXT(device, create_info_count, p_create_infos, p_allocator,
		p_shaders)
}

fn C.vkDestroyShaderEXT(C.VkDevice, C.VkShaderEXT, &AllocationCallbacks)

pub type PFN_vkDestroyShaderEXT = fn (C.VkDevice, C.VkShaderEXT, &AllocationCallbacks)

@[inline]
pub fn destroy_shader_ext(device C.VkDevice,
	shader C.VkShaderEXT,
	p_allocator &AllocationCallbacks) {
	C.vkDestroyShaderEXT(device, shader, p_allocator)
}

fn C.vkGetShaderBinaryDataEXT(C.VkDevice, C.VkShaderEXT, &usize, voidptr) Result

pub type PFN_vkGetShaderBinaryDataEXT = fn (C.VkDevice, C.VkShaderEXT, &usize, voidptr) Result

@[inline]
pub fn get_shader_binary_data_ext(device C.VkDevice,
	shader C.VkShaderEXT,
	p_data_size &usize,
	p_data voidptr) Result {
	return C.vkGetShaderBinaryDataEXT(device, shader, p_data_size, p_data)
}

fn C.vkCmdBindShadersEXT(C.VkCommandBuffer, u32, &ShaderStageFlagBits, C.VkShaderEXT)

pub type PFN_vkCmdBindShadersEXT = fn (C.VkCommandBuffer, u32, &ShaderStageFlagBits, C.VkShaderEXT)

@[inline]
pub fn cmd_bind_shaders_ext(command_buffer C.VkCommandBuffer,
	stage_count u32,
	p_stages &ShaderStageFlagBits,
	p_shaders C.VkShaderEXT) {
	C.vkCmdBindShadersEXT(command_buffer, stage_count, p_stages, p_shaders)
}

pub const qcom_tile_properties_spec_version = 1
pub const qcom_tile_properties_extension_name = 'VK_QCOM_tile_properties'

pub type PhysicalDeviceTilePropertiesFeaturesQCOM = C.VkPhysicalDeviceTilePropertiesFeaturesQCOM

@[typedef]
pub struct C.VkPhysicalDeviceTilePropertiesFeaturesQCOM {
pub mut:
	sType          StructureType = StructureType.physical_device_tile_properties_features_qcom
	pNext          voidptr       = unsafe { nil }
	tileProperties Bool32
}

pub type TilePropertiesQCOM = C.VkTilePropertiesQCOM

@[typedef]
pub struct C.VkTilePropertiesQCOM {
pub mut:
	sType     StructureType = StructureType.tile_properties_qcom
	pNext     voidptr       = unsafe { nil }
	tileSize  Extent3D
	apronSize Extent2D
	origin    Offset2D
}

fn C.vkGetFramebufferTilePropertiesQCOM(C.VkDevice, C.VkFramebuffer, &u32, &TilePropertiesQCOM) Result

pub type PFN_vkGetFramebufferTilePropertiesQCOM = fn (C.VkDevice, C.VkFramebuffer, &u32, &TilePropertiesQCOM) Result

@[inline]
pub fn get_framebuffer_tile_properties_qcom(device C.VkDevice,
	framebuffer C.VkFramebuffer,
	p_properties_count &u32,
	p_properties &TilePropertiesQCOM) Result {
	return C.vkGetFramebufferTilePropertiesQCOM(device, framebuffer, p_properties_count,
		p_properties)
}

fn C.vkGetDynamicRenderingTilePropertiesQCOM(C.VkDevice, &RenderingInfo, &TilePropertiesQCOM) Result

pub type PFN_vkGetDynamicRenderingTilePropertiesQCOM = fn (C.VkDevice, &RenderingInfo, &TilePropertiesQCOM) Result

@[inline]
pub fn get_dynamic_rendering_tile_properties_qcom(device C.VkDevice,
	p_rendering_info &RenderingInfo,
	p_properties &TilePropertiesQCOM) Result {
	return C.vkGetDynamicRenderingTilePropertiesQCOM(device, p_rendering_info, p_properties)
}

pub const sec_amigo_profiling_spec_version = 1
pub const sec_amigo_profiling_extension_name = 'VK_SEC_amigo_profiling'

pub type PhysicalDeviceAmigoProfilingFeaturesSEC = C.VkPhysicalDeviceAmigoProfilingFeaturesSEC

@[typedef]
pub struct C.VkPhysicalDeviceAmigoProfilingFeaturesSEC {
pub mut:
	sType          StructureType = StructureType.physical_device_amigo_profiling_features_sec
	pNext          voidptr       = unsafe { nil }
	amigoProfiling Bool32
}

pub type AmigoProfilingSubmitInfoSEC = C.VkAmigoProfilingSubmitInfoSEC

@[typedef]
pub struct C.VkAmigoProfilingSubmitInfoSEC {
pub mut:
	sType               StructureType = StructureType.amigo_profiling_submit_info_sec
	pNext               voidptr       = unsafe { nil }
	firstDrawTimestamp  u64
	swapBufferTimestamp u64
}

pub const qcom_multiview_per_view_viewports_spec_version = 1
pub const qcom_multiview_per_view_viewports_extension_name = 'VK_QCOM_multiview_per_view_viewports'

pub type PhysicalDeviceMultiviewPerViewViewportsFeaturesQCOM = C.VkPhysicalDeviceMultiviewPerViewViewportsFeaturesQCOM

@[typedef]
pub struct C.VkPhysicalDeviceMultiviewPerViewViewportsFeaturesQCOM {
pub mut:
	sType                     StructureType = StructureType.physical_device_multiview_per_view_viewports_features_qcom
	pNext                     voidptr       = unsafe { nil }
	multiviewPerViewViewports Bool32
}

pub const nv_ray_tracing_invocation_reorder_spec_version = 1
pub const nv_ray_tracing_invocation_reorder_extension_name = 'VK_NV_ray_tracing_invocation_reorder'

pub enum RayTracingInvocationReorderModeNV {
	none_nv     = 0
	reorder_nv  = 1
	max_enum_nv = max_int
}

pub type PhysicalDeviceRayTracingInvocationReorderPropertiesNV = C.VkPhysicalDeviceRayTracingInvocationReorderPropertiesNV

@[typedef]
pub struct C.VkPhysicalDeviceRayTracingInvocationReorderPropertiesNV {
pub mut:
	sType                                     StructureType = StructureType.physical_device_ray_tracing_invocation_reorder_properties_nv
	pNext                                     voidptr       = unsafe { nil }
	rayTracingInvocationReorderReorderingHint RayTracingInvocationReorderModeNV
}

pub type PhysicalDeviceRayTracingInvocationReorderFeaturesNV = C.VkPhysicalDeviceRayTracingInvocationReorderFeaturesNV

@[typedef]
pub struct C.VkPhysicalDeviceRayTracingInvocationReorderFeaturesNV {
pub mut:
	sType                       StructureType = StructureType.physical_device_ray_tracing_invocation_reorder_features_nv
	pNext                       voidptr       = unsafe { nil }
	rayTracingInvocationReorder Bool32
}

pub const nv_extended_sparse_address_space_spec_version = 1
pub const nv_extended_sparse_address_space_extension_name = 'VK_NV_extended_sparse_address_space'

pub type PhysicalDeviceExtendedSparseAddressSpaceFeaturesNV = C.VkPhysicalDeviceExtendedSparseAddressSpaceFeaturesNV

@[typedef]
pub struct C.VkPhysicalDeviceExtendedSparseAddressSpaceFeaturesNV {
pub mut:
	sType                      StructureType = StructureType.physical_device_extended_sparse_address_space_features_nv
	pNext                      voidptr       = unsafe { nil }
	extendedSparseAddressSpace Bool32
}

pub type PhysicalDeviceExtendedSparseAddressSpacePropertiesNV = C.VkPhysicalDeviceExtendedSparseAddressSpacePropertiesNV

@[typedef]
pub struct C.VkPhysicalDeviceExtendedSparseAddressSpacePropertiesNV {
pub mut:
	sType                          StructureType = StructureType.physical_device_extended_sparse_address_space_properties_nv
	pNext                          voidptr       = unsafe { nil }
	extendedSparseAddressSpaceSize DeviceSize
	extendedSparseImageUsageFlags  ImageUsageFlags
	extendedSparseBufferUsageFlags BufferUsageFlags
}

pub const ext_mutable_descriptor_type_spec_version = 1
pub const ext_mutable_descriptor_type_extension_name = 'VK_EXT_mutable_descriptor_type'

pub const ext_layer_settings_spec_version = 2
pub const ext_layer_settings_extension_name = 'VK_EXT_layer_settings'

pub enum LayerSettingTypeEXT {
	bool32_ext   = 0
	int32_ext    = 1
	int64_ext    = 2
	uint32_ext   = 3
	uint64_ext   = 4
	float32_ext  = 5
	float64_ext  = 6
	string_ext   = 7
	max_enum_ext = max_int
}

pub type LayerSettingEXT = C.VkLayerSettingEXT

@[typedef]
pub struct C.VkLayerSettingEXT {
pub mut:
	pLayerName   &char
	pSettingName &char
	type         LayerSettingTypeEXT
	valueCount   u32
	pValues      voidptr
}

pub type LayerSettingsCreateInfoEXT = C.VkLayerSettingsCreateInfoEXT

@[typedef]
pub struct C.VkLayerSettingsCreateInfoEXT {
pub mut:
	sType        StructureType = StructureType.layer_settings_create_info_ext
	pNext        voidptr       = unsafe { nil }
	settingCount u32
	pSettings    &LayerSettingEXT
}

pub const arm_shader_core_builtins_spec_version = 2
pub const arm_shader_core_builtins_extension_name = 'VK_ARM_shader_core_builtins'

pub type PhysicalDeviceShaderCoreBuiltinsFeaturesARM = C.VkPhysicalDeviceShaderCoreBuiltinsFeaturesARM

@[typedef]
pub struct C.VkPhysicalDeviceShaderCoreBuiltinsFeaturesARM {
pub mut:
	sType              StructureType = StructureType.physical_device_shader_core_builtins_features_arm
	pNext              voidptr       = unsafe { nil }
	shaderCoreBuiltins Bool32
}

pub type PhysicalDeviceShaderCoreBuiltinsPropertiesARM = C.VkPhysicalDeviceShaderCoreBuiltinsPropertiesARM

@[typedef]
pub struct C.VkPhysicalDeviceShaderCoreBuiltinsPropertiesARM {
pub mut:
	sType              StructureType = StructureType.physical_device_shader_core_builtins_properties_arm
	pNext              voidptr       = unsafe { nil }
	shaderCoreMask     u64
	shaderCoreCount    u32
	shaderWarpsPerCore u32
}

pub const ext_pipeline_library_group_handles_spec_version = 1
pub const ext_pipeline_library_group_handles_extension_name = 'VK_EXT_pipeline_library_group_handles'

pub type PhysicalDevicePipelineLibraryGroupHandlesFeaturesEXT = C.VkPhysicalDevicePipelineLibraryGroupHandlesFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDevicePipelineLibraryGroupHandlesFeaturesEXT {
pub mut:
	sType                       StructureType = StructureType.physical_device_pipeline_library_group_handles_features_ext
	pNext                       voidptr       = unsafe { nil }
	pipelineLibraryGroupHandles Bool32
}

pub const ext_dynamic_rendering_unused_attachments_spec_version = 1
pub const ext_dynamic_rendering_unused_attachments_extension_name = 'VK_EXT_dynamic_rendering_unused_attachments'

pub type PhysicalDeviceDynamicRenderingUnusedAttachmentsFeaturesEXT = C.VkPhysicalDeviceDynamicRenderingUnusedAttachmentsFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceDynamicRenderingUnusedAttachmentsFeaturesEXT {
pub mut:
	sType                             StructureType = StructureType.physical_device_dynamic_rendering_unused_attachments_features_ext
	pNext                             voidptr       = unsafe { nil }
	dynamicRenderingUnusedAttachments Bool32
}

pub const nv_low_latency_2_spec_version = 2
pub const nv_low_latency_2_extension_name = 'VK_NV_low_latency2'

pub enum LatencyMarkerNV {
	simulation_start_nv               = 0
	simulation_end_nv                 = 1
	rendersubmit_start_nv             = 2
	rendersubmit_end_nv               = 3
	present_start_nv                  = 4
	present_end_nv                    = 5
	input_sample_nv                   = 6
	trigger_flash_nv                  = 7
	out_of_band_rendersubmit_start_nv = 8
	out_of_band_rendersubmit_end_nv   = 9
	out_of_band_present_start_nv      = 10
	out_of_band_present_end_nv        = 11
	max_enum_nv                       = max_int
}

pub enum OutOfBandQueueTypeNV {
	render_nv   = 0
	present_nv  = 1
	max_enum_nv = max_int
}

pub type LatencySleepModeInfoNV = C.VkLatencySleepModeInfoNV

@[typedef]
pub struct C.VkLatencySleepModeInfoNV {
pub mut:
	sType             StructureType = StructureType.latency_sleep_mode_info_nv
	pNext             voidptr       = unsafe { nil }
	lowLatencyMode    Bool32
	lowLatencyBoost   Bool32
	minimumIntervalUs u32
}

pub type LatencySleepInfoNV = C.VkLatencySleepInfoNV

@[typedef]
pub struct C.VkLatencySleepInfoNV {
pub mut:
	sType           StructureType = StructureType.latency_sleep_info_nv
	pNext           voidptr       = unsafe { nil }
	signalSemaphore C.VkSemaphore
	value           u64
}

pub type SetLatencyMarkerInfoNV = C.VkSetLatencyMarkerInfoNV

@[typedef]
pub struct C.VkSetLatencyMarkerInfoNV {
pub mut:
	sType     StructureType = StructureType.set_latency_marker_info_nv
	pNext     voidptr       = unsafe { nil }
	presentID u64
	marker    LatencyMarkerNV
}

pub type LatencyTimingsFrameReportNV = C.VkLatencyTimingsFrameReportNV

@[typedef]
pub struct C.VkLatencyTimingsFrameReportNV {
pub mut:
	sType                    StructureType = StructureType.latency_timings_frame_report_nv
	pNext                    voidptr       = unsafe { nil }
	presentID                u64
	inputSampleTimeUs        u64
	simStartTimeUs           u64
	simEndTimeUs             u64
	renderSubmitStartTimeUs  u64
	renderSubmitEndTimeUs    u64
	presentStartTimeUs       u64
	presentEndTimeUs         u64
	driverStartTimeUs        u64
	driverEndTimeUs          u64
	osRenderQueueStartTimeUs u64
	osRenderQueueEndTimeUs   u64
	gpuRenderStartTimeUs     u64
	gpuRenderEndTimeUs       u64
}

pub type GetLatencyMarkerInfoNV = C.VkGetLatencyMarkerInfoNV

@[typedef]
pub struct C.VkGetLatencyMarkerInfoNV {
pub mut:
	sType       StructureType = StructureType.get_latency_marker_info_nv
	pNext       voidptr       = unsafe { nil }
	timingCount u32
	pTimings    &LatencyTimingsFrameReportNV
}

pub type LatencySubmissionPresentIdNV = C.VkLatencySubmissionPresentIdNV

@[typedef]
pub struct C.VkLatencySubmissionPresentIdNV {
pub mut:
	sType     StructureType = StructureType.latency_submission_present_id_nv
	pNext     voidptr       = unsafe { nil }
	presentID u64
}

pub type SwapchainLatencyCreateInfoNV = C.VkSwapchainLatencyCreateInfoNV

@[typedef]
pub struct C.VkSwapchainLatencyCreateInfoNV {
pub mut:
	sType             StructureType = StructureType.swapchain_latency_create_info_nv
	pNext             voidptr       = unsafe { nil }
	latencyModeEnable Bool32
}

pub type OutOfBandQueueTypeInfoNV = C.VkOutOfBandQueueTypeInfoNV

@[typedef]
pub struct C.VkOutOfBandQueueTypeInfoNV {
pub mut:
	sType     StructureType = StructureType.out_of_band_queue_type_info_nv
	pNext     voidptr       = unsafe { nil }
	queueType OutOfBandQueueTypeNV
}

pub type LatencySurfaceCapabilitiesNV = C.VkLatencySurfaceCapabilitiesNV

@[typedef]
pub struct C.VkLatencySurfaceCapabilitiesNV {
pub mut:
	sType            StructureType = StructureType.latency_surface_capabilities_nv
	pNext            voidptr       = unsafe { nil }
	presentModeCount u32
	pPresentModes    &PresentModeKHR
}

fn C.vkSetLatencySleepModeNV(C.VkDevice, C.VkSwapchainKHR, &LatencySleepModeInfoNV) Result

pub type PFN_vkSetLatencySleepModeNV = fn (C.VkDevice, C.VkSwapchainKHR, &LatencySleepModeInfoNV) Result

@[inline]
pub fn set_latency_sleep_mode_nv(device C.VkDevice,
	swapchain C.VkSwapchainKHR,
	p_sleep_mode_info &LatencySleepModeInfoNV) Result {
	return C.vkSetLatencySleepModeNV(device, swapchain, p_sleep_mode_info)
}

fn C.vkLatencySleepNV(C.VkDevice, C.VkSwapchainKHR, &LatencySleepInfoNV) Result

pub type PFN_vkLatencySleepNV = fn (C.VkDevice, C.VkSwapchainKHR, &LatencySleepInfoNV) Result

@[inline]
pub fn latency_sleep_nv(device C.VkDevice,
	swapchain C.VkSwapchainKHR,
	p_sleep_info &LatencySleepInfoNV) Result {
	return C.vkLatencySleepNV(device, swapchain, p_sleep_info)
}

fn C.vkSetLatencyMarkerNV(C.VkDevice, C.VkSwapchainKHR, &SetLatencyMarkerInfoNV)

pub type PFN_vkSetLatencyMarkerNV = fn (C.VkDevice, C.VkSwapchainKHR, &SetLatencyMarkerInfoNV)

@[inline]
pub fn set_latency_marker_nv(device C.VkDevice,
	swapchain C.VkSwapchainKHR,
	p_latency_marker_info &SetLatencyMarkerInfoNV) {
	C.vkSetLatencyMarkerNV(device, swapchain, p_latency_marker_info)
}

fn C.vkGetLatencyTimingsNV(C.VkDevice, C.VkSwapchainKHR, &GetLatencyMarkerInfoNV)

pub type PFN_vkGetLatencyTimingsNV = fn (C.VkDevice, C.VkSwapchainKHR, &GetLatencyMarkerInfoNV)

@[inline]
pub fn get_latency_timings_nv(device C.VkDevice,
	swapchain C.VkSwapchainKHR,
	p_latency_marker_info &GetLatencyMarkerInfoNV) {
	C.vkGetLatencyTimingsNV(device, swapchain, p_latency_marker_info)
}

fn C.vkQueueNotifyOutOfBandNV(C.VkQueue, &OutOfBandQueueTypeInfoNV)

pub type PFN_vkQueueNotifyOutOfBandNV = fn (C.VkQueue, &OutOfBandQueueTypeInfoNV)

@[inline]
pub fn queue_notify_out_of_band_nv(queue C.VkQueue,
	p_queue_type_info &OutOfBandQueueTypeInfoNV) {
	C.vkQueueNotifyOutOfBandNV(queue, p_queue_type_info)
}

pub const qcom_multiview_per_view_render_areas_spec_version = 1
pub const qcom_multiview_per_view_render_areas_extension_name = 'VK_QCOM_multiview_per_view_render_areas'

pub type PhysicalDeviceMultiviewPerViewRenderAreasFeaturesQCOM = C.VkPhysicalDeviceMultiviewPerViewRenderAreasFeaturesQCOM

@[typedef]
pub struct C.VkPhysicalDeviceMultiviewPerViewRenderAreasFeaturesQCOM {
pub mut:
	sType                       StructureType = StructureType.physical_device_multiview_per_view_render_areas_features_qcom
	pNext                       voidptr       = unsafe { nil }
	multiviewPerViewRenderAreas Bool32
}

pub type MultiviewPerViewRenderAreasRenderPassBeginInfoQCOM = C.VkMultiviewPerViewRenderAreasRenderPassBeginInfoQCOM

@[typedef]
pub struct C.VkMultiviewPerViewRenderAreasRenderPassBeginInfoQCOM {
pub mut:
	sType                  StructureType = StructureType.multiview_per_view_render_areas_render_pass_begin_info_qcom
	pNext                  voidptr       = unsafe { nil }
	perViewRenderAreaCount u32
	pPerViewRenderAreas    &Rect2D
}

pub const nv_per_stage_descriptor_set_spec_version = 1
pub const nv_per_stage_descriptor_set_extension_name = 'VK_NV_per_stage_descriptor_set'

pub type PhysicalDevicePerStageDescriptorSetFeaturesNV = C.VkPhysicalDevicePerStageDescriptorSetFeaturesNV

@[typedef]
pub struct C.VkPhysicalDevicePerStageDescriptorSetFeaturesNV {
pub mut:
	sType                 StructureType = StructureType.physical_device_per_stage_descriptor_set_features_nv
	pNext                 voidptr       = unsafe { nil }
	perStageDescriptorSet Bool32
	dynamicPipelineLayout Bool32
}

pub const qcom_image_processing_2_spec_version = 1
pub const qcom_image_processing_2_extension_name = 'VK_QCOM_image_processing2'

pub enum BlockMatchWindowCompareModeQCOM {
	min_qcom      = 0
	max_qcom      = 1
	max_enum_qcom = max_int
}

pub type PhysicalDeviceImageProcessing2FeaturesQCOM = C.VkPhysicalDeviceImageProcessing2FeaturesQCOM

@[typedef]
pub struct C.VkPhysicalDeviceImageProcessing2FeaturesQCOM {
pub mut:
	sType              StructureType = StructureType.physical_device_image_processing2_features_qcom
	pNext              voidptr       = unsafe { nil }
	textureBlockMatch2 Bool32
}

pub type PhysicalDeviceImageProcessing2PropertiesQCOM = C.VkPhysicalDeviceImageProcessing2PropertiesQCOM

@[typedef]
pub struct C.VkPhysicalDeviceImageProcessing2PropertiesQCOM {
pub mut:
	sType               StructureType = StructureType.physical_device_image_processing2_properties_qcom
	pNext               voidptr       = unsafe { nil }
	maxBlockMatchWindow Extent2D
}

pub type SamplerBlockMatchWindowCreateInfoQCOM = C.VkSamplerBlockMatchWindowCreateInfoQCOM

@[typedef]
pub struct C.VkSamplerBlockMatchWindowCreateInfoQCOM {
pub mut:
	sType             StructureType = StructureType.sampler_block_match_window_create_info_qcom
	pNext             voidptr       = unsafe { nil }
	windowExtent      Extent2D
	windowCompareMode BlockMatchWindowCompareModeQCOM
}

pub const qcom_filter_cubic_weights_spec_version = 1
pub const qcom_filter_cubic_weights_extension_name = 'VK_QCOM_filter_cubic_weights'

pub enum CubicFilterWeightsQCOM {
	catmull_rom_qcom           = 0
	zero_tangent_cardinal_qcom = 1
	b_spline_qcom              = 2
	mitchell_netravali_qcom    = 3
	max_enum_qcom              = max_int
}

pub type PhysicalDeviceCubicWeightsFeaturesQCOM = C.VkPhysicalDeviceCubicWeightsFeaturesQCOM

@[typedef]
pub struct C.VkPhysicalDeviceCubicWeightsFeaturesQCOM {
pub mut:
	sType                  StructureType = StructureType.physical_device_cubic_weights_features_qcom
	pNext                  voidptr       = unsafe { nil }
	selectableCubicWeights Bool32
}

pub type SamplerCubicWeightsCreateInfoQCOM = C.VkSamplerCubicWeightsCreateInfoQCOM

@[typedef]
pub struct C.VkSamplerCubicWeightsCreateInfoQCOM {
pub mut:
	sType        StructureType = StructureType.sampler_cubic_weights_create_info_qcom
	pNext        voidptr       = unsafe { nil }
	cubicWeights CubicFilterWeightsQCOM
}

pub type BlitImageCubicWeightsInfoQCOM = C.VkBlitImageCubicWeightsInfoQCOM

@[typedef]
pub struct C.VkBlitImageCubicWeightsInfoQCOM {
pub mut:
	sType        StructureType = StructureType.blit_image_cubic_weights_info_qcom
	pNext        voidptr       = unsafe { nil }
	cubicWeights CubicFilterWeightsQCOM
}

pub const qcom_ycbcr_degamma_spec_version = 1
pub const qcom_ycbcr_degamma_extension_name = 'VK_QCOM_ycbcr_degamma'

pub type PhysicalDeviceYcbcrDegammaFeaturesQCOM = C.VkPhysicalDeviceYcbcrDegammaFeaturesQCOM

@[typedef]
pub struct C.VkPhysicalDeviceYcbcrDegammaFeaturesQCOM {
pub mut:
	sType        StructureType = StructureType.physical_device_ycbcr_degamma_features_qcom
	pNext        voidptr       = unsafe { nil }
	ycbcrDegamma Bool32
}

pub type SamplerYcbcrConversionYcbcrDegammaCreateInfoQCOM = C.VkSamplerYcbcrConversionYcbcrDegammaCreateInfoQCOM

@[typedef]
pub struct C.VkSamplerYcbcrConversionYcbcrDegammaCreateInfoQCOM {
pub mut:
	sType             StructureType = StructureType.sampler_ycbcr_conversion_ycbcr_degamma_create_info_qcom
	pNext             voidptr       = unsafe { nil }
	enableYDegamma    Bool32
	enableCbCrDegamma Bool32
}

pub const qcom_filter_cubic_clamp_spec_version = 1
pub const qcom_filter_cubic_clamp_extension_name = 'VK_QCOM_filter_cubic_clamp'

pub type PhysicalDeviceCubicClampFeaturesQCOM = C.VkPhysicalDeviceCubicClampFeaturesQCOM

@[typedef]
pub struct C.VkPhysicalDeviceCubicClampFeaturesQCOM {
pub mut:
	sType           StructureType = StructureType.physical_device_cubic_clamp_features_qcom
	pNext           voidptr       = unsafe { nil }
	cubicRangeClamp Bool32
}

pub const ext_attachment_feedback_loop_dynamic_state_spec_version = 1
pub const ext_attachment_feedback_loop_dynamic_state_extension_name = 'VK_EXT_attachment_feedback_loop_dynamic_state'

pub type PhysicalDeviceAttachmentFeedbackLoopDynamicStateFeaturesEXT = C.VkPhysicalDeviceAttachmentFeedbackLoopDynamicStateFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceAttachmentFeedbackLoopDynamicStateFeaturesEXT {
pub mut:
	sType                              StructureType = StructureType.physical_device_attachment_feedback_loop_dynamic_state_features_ext
	pNext                              voidptr       = unsafe { nil }
	attachmentFeedbackLoopDynamicState Bool32
}

fn C.vkCmdSetAttachmentFeedbackLoopEnableEXT(C.VkCommandBuffer, ImageAspectFlags)

pub type PFN_vkCmdSetAttachmentFeedbackLoopEnableEXT = fn (C.VkCommandBuffer, ImageAspectFlags)

@[inline]
pub fn cmd_set_attachment_feedback_loop_enable_ext(command_buffer C.VkCommandBuffer,
	aspect_mask ImageAspectFlags) {
	C.vkCmdSetAttachmentFeedbackLoopEnableEXT(command_buffer, aspect_mask)
}

pub const msft_layered_driver_spec_version = 1
pub const msft_layered_driver_extension_name = 'VK_MST_layered_driver'

pub enum LayeredDriverUnderlyingApiMSFT {
	none_msft     = 0
	d3d12_msft    = 1
	max_enum_msft = max_int
}

pub type PhysicalDeviceLayeredDriverPropertiesMSFT = C.VkPhysicalDeviceLayeredDriverPropertiesMSFT

@[typedef]
pub struct C.VkPhysicalDeviceLayeredDriverPropertiesMSFT {
pub mut:
	sType         StructureType = StructureType.physical_device_layered_driver_properties_msft
	pNext         voidptr       = unsafe { nil }
	underlyingAPI LayeredDriverUnderlyingApiMSFT
}

pub const nv_descriptor_pool_overallocation_spec_version = 1
pub const nv_descriptor_pool_overallocation_extension_name = 'VK_NV_descriptor_pool_overallocation'

pub type PhysicalDeviceDescriptorPoolOverallocationFeaturesNV = C.VkPhysicalDeviceDescriptorPoolOverallocationFeaturesNV

@[typedef]
pub struct C.VkPhysicalDeviceDescriptorPoolOverallocationFeaturesNV {
pub mut:
	sType                        StructureType = StructureType.physical_device_descriptor_pool_overallocation_features_nv
	pNext                        voidptr       = unsafe { nil }
	descriptorPoolOverallocation Bool32
}

pub const khr_acceleration_structure_spec_version = 13
pub const khr_acceleration_structure_extension_name = 'VK_KHR_acceleration_structure'

pub enum BuildAccelerationStructureModeKHR {
	build_khr    = 0
	update_khr   = 1
	max_enum_khr = max_int
}

pub enum AccelerationStructureCreateFlagBitsKHR {
	device_address_capture_replay_bit_khr    = int(0x00000001)
	descriptor_buffer_capture_replay_bit_ext = int(0x00000008)
	motion_bit_nv                            = int(0x00000004)
	max_enum_khr                             = max_int
}

pub type AccelerationStructureCreateFlagsKHR = u32
pub type AccelerationStructureBuildRangeInfoKHR = C.VkAccelerationStructureBuildRangeInfoKHR

@[typedef]
pub struct C.VkAccelerationStructureBuildRangeInfoKHR {
pub mut:
	primitiveCount  u32
	primitiveOffset u32
	firstVertex     u32
	transformOffset u32
}

pub type AccelerationStructureGeometryTrianglesDataKHR = C.VkAccelerationStructureGeometryTrianglesDataKHR

@[typedef]
pub struct C.VkAccelerationStructureGeometryTrianglesDataKHR {
pub mut:
	sType         StructureType = StructureType.acceleration_structure_geometry_triangles_data_khr
	pNext         voidptr       = unsafe { nil }
	vertexFormat  Format
	vertexData    DeviceOrHostAddressConstKHR
	vertexStride  DeviceSize
	maxVertex     u32
	indexType     IndexType
	indexData     DeviceOrHostAddressConstKHR
	transformData DeviceOrHostAddressConstKHR
}

pub type AccelerationStructureGeometryAabbsDataKHR = C.VkAccelerationStructureGeometryAabbsDataKHR

@[typedef]
pub struct C.VkAccelerationStructureGeometryAabbsDataKHR {
pub mut:
	sType  StructureType = StructureType.acceleration_structure_geometry_aabbs_data_khr
	pNext  voidptr       = unsafe { nil }
	data   DeviceOrHostAddressConstKHR
	stride DeviceSize
}

pub type AccelerationStructureGeometryInstancesDataKHR = C.VkAccelerationStructureGeometryInstancesDataKHR

@[typedef]
pub struct C.VkAccelerationStructureGeometryInstancesDataKHR {
pub mut:
	sType           StructureType = StructureType.acceleration_structure_geometry_instances_data_khr
	pNext           voidptr       = unsafe { nil }
	arrayOfPointers Bool32
	data            DeviceOrHostAddressConstKHR
}

pub type AccelerationStructureGeometryDataKHR = C.VkAccelerationStructureGeometryDataKHR

@[typedef]
pub union C.VkAccelerationStructureGeometryDataKHR {
pub mut:
	triangles AccelerationStructureGeometryTrianglesDataKHR
	aabbs     AccelerationStructureGeometryAabbsDataKHR
	instances AccelerationStructureGeometryInstancesDataKHR
}

pub type AccelerationStructureGeometryKHR = C.VkAccelerationStructureGeometryKHR

@[typedef]
pub struct C.VkAccelerationStructureGeometryKHR {
pub mut:
	sType        StructureType = StructureType.acceleration_structure_geometry_khr
	pNext        voidptr       = unsafe { nil }
	geometryType GeometryTypeKHR
	geometry     AccelerationStructureGeometryDataKHR
	flags        GeometryFlagsKHR
}

pub type AccelerationStructureBuildGeometryInfoKHR = C.VkAccelerationStructureBuildGeometryInfoKHR

@[typedef]
pub struct C.VkAccelerationStructureBuildGeometryInfoKHR {
pub mut:
	sType                    StructureType = StructureType.acceleration_structure_build_geometry_info_khr
	pNext                    voidptr       = unsafe { nil }
	type                     AccelerationStructureTypeKHR
	flags                    BuildAccelerationStructureFlagsKHR
	mode                     BuildAccelerationStructureModeKHR
	srcAccelerationStructure C.VkAccelerationStructureKHR
	dstAccelerationStructure C.VkAccelerationStructureKHR
	geometryCount            u32
	pGeometries              &AccelerationStructureGeometryKHR
	ppGeometries             &&AccelerationStructureGeometryKHR
	scratchData              DeviceOrHostAddressKHR
}

pub type AccelerationStructureCreateInfoKHR = C.VkAccelerationStructureCreateInfoKHR

@[typedef]
pub struct C.VkAccelerationStructureCreateInfoKHR {
pub mut:
	sType         StructureType = StructureType.acceleration_structure_create_info_khr
	pNext         voidptr       = unsafe { nil }
	createFlags   AccelerationStructureCreateFlagsKHR
	buffer        C.VkBuffer
	offset        DeviceSize
	size          DeviceSize
	type          AccelerationStructureTypeKHR
	deviceAddress DeviceAddress
}

pub type WriteDescriptorSetAccelerationStructureKHR = C.VkWriteDescriptorSetAccelerationStructureKHR

@[typedef]
pub struct C.VkWriteDescriptorSetAccelerationStructureKHR {
pub mut:
	sType                      StructureType = StructureType.write_descriptor_set_acceleration_structure_khr
	pNext                      voidptr       = unsafe { nil }
	accelerationStructureCount u32
	pAccelerationStructures    C.VkAccelerationStructureKHR
}

pub type PhysicalDeviceAccelerationStructureFeaturesKHR = C.VkPhysicalDeviceAccelerationStructureFeaturesKHR

@[typedef]
pub struct C.VkPhysicalDeviceAccelerationStructureFeaturesKHR {
pub mut:
	sType                                                 StructureType = StructureType.physical_device_acceleration_structure_features_khr
	pNext                                                 voidptr       = unsafe { nil }
	accelerationStructure                                 Bool32
	accelerationStructureCaptureReplay                    Bool32
	accelerationStructureIndirectBuild                    Bool32
	accelerationStructureHostCommands                     Bool32
	descriptorBindingAccelerationStructureUpdateAfterBind Bool32
}

pub type PhysicalDeviceAccelerationStructurePropertiesKHR = C.VkPhysicalDeviceAccelerationStructurePropertiesKHR

@[typedef]
pub struct C.VkPhysicalDeviceAccelerationStructurePropertiesKHR {
pub mut:
	sType                                                      StructureType = StructureType.physical_device_acceleration_structure_properties_khr
	pNext                                                      voidptr       = unsafe { nil }
	maxGeometryCount                                           u64
	maxInstanceCount                                           u64
	maxPrimitiveCount                                          u64
	maxPerStageDescriptorAccelerationStructures                u32
	maxPerStageDescriptorUpdateAfterBindAccelerationStructures u32
	maxDescriptorSetAccelerationStructures                     u32
	maxDescriptorSetUpdateAfterBindAccelerationStructures      u32
	minAccelerationStructureScratchOffsetAlignment             u32
}

pub type AccelerationStructureDeviceAddressInfoKHR = C.VkAccelerationStructureDeviceAddressInfoKHR

@[typedef]
pub struct C.VkAccelerationStructureDeviceAddressInfoKHR {
pub mut:
	sType                 StructureType = StructureType.acceleration_structure_device_address_info_khr
	pNext                 voidptr       = unsafe { nil }
	accelerationStructure C.VkAccelerationStructureKHR
}

pub type AccelerationStructureVersionInfoKHR = C.VkAccelerationStructureVersionInfoKHR

@[typedef]
pub struct C.VkAccelerationStructureVersionInfoKHR {
pub mut:
	sType        StructureType = StructureType.acceleration_structure_version_info_khr
	pNext        voidptr       = unsafe { nil }
	pVersionData &u8
}

pub type CopyAccelerationStructureToMemoryInfoKHR = C.VkCopyAccelerationStructureToMemoryInfoKHR

@[typedef]
pub struct C.VkCopyAccelerationStructureToMemoryInfoKHR {
pub mut:
	sType StructureType = StructureType.copy_acceleration_structure_to_memory_info_khr
	pNext voidptr       = unsafe { nil }
	src   C.VkAccelerationStructureKHR
	dst   DeviceOrHostAddressKHR
	mode  CopyAccelerationStructureModeKHR
}

pub type CopyMemoryToAccelerationStructureInfoKHR = C.VkCopyMemoryToAccelerationStructureInfoKHR

@[typedef]
pub struct C.VkCopyMemoryToAccelerationStructureInfoKHR {
pub mut:
	sType StructureType = StructureType.copy_memory_to_acceleration_structure_info_khr
	pNext voidptr       = unsafe { nil }
	src   DeviceOrHostAddressConstKHR
	dst   C.VkAccelerationStructureKHR
	mode  CopyAccelerationStructureModeKHR
}

pub type CopyAccelerationStructureInfoKHR = C.VkCopyAccelerationStructureInfoKHR

@[typedef]
pub struct C.VkCopyAccelerationStructureInfoKHR {
pub mut:
	sType StructureType = StructureType.copy_acceleration_structure_info_khr
	pNext voidptr       = unsafe { nil }
	src   C.VkAccelerationStructureKHR
	dst   C.VkAccelerationStructureKHR
	mode  CopyAccelerationStructureModeKHR
}

pub type AccelerationStructureBuildSizesInfoKHR = C.VkAccelerationStructureBuildSizesInfoKHR

@[typedef]
pub struct C.VkAccelerationStructureBuildSizesInfoKHR {
pub mut:
	sType                     StructureType = StructureType.acceleration_structure_build_sizes_info_khr
	pNext                     voidptr       = unsafe { nil }
	accelerationStructureSize DeviceSize
	updateScratchSize         DeviceSize
	buildScratchSize          DeviceSize
}

fn C.vkCreateAccelerationStructureKHR(C.VkDevice, &AccelerationStructureCreateInfoKHR, &AllocationCallbacks, C.VkAccelerationStructureKHR) Result

pub type PFN_vkCreateAccelerationStructureKHR = fn (C.VkDevice, &AccelerationStructureCreateInfoKHR, &AllocationCallbacks, C.VkAccelerationStructureKHR) Result

@[inline]
pub fn create_acceleration_structure_khr(device C.VkDevice,
	p_create_info &AccelerationStructureCreateInfoKHR,
	p_allocator &AllocationCallbacks,
	p_acceleration_structure C.VkAccelerationStructureKHR) Result {
	return C.vkCreateAccelerationStructureKHR(device, p_create_info, p_allocator, p_acceleration_structure)
}

fn C.vkDestroyAccelerationStructureKHR(C.VkDevice, C.VkAccelerationStructureKHR, &AllocationCallbacks)

pub type PFN_vkDestroyAccelerationStructureKHR = fn (C.VkDevice, C.VkAccelerationStructureKHR, &AllocationCallbacks)

@[inline]
pub fn destroy_acceleration_structure_khr(device C.VkDevice,
	acceleration_structure C.VkAccelerationStructureKHR,
	p_allocator &AllocationCallbacks) {
	C.vkDestroyAccelerationStructureKHR(device, acceleration_structure, p_allocator)
}

fn C.vkCmdBuildAccelerationStructuresKHR(C.VkCommandBuffer, u32, &AccelerationStructureBuildGeometryInfoKHR, &&AccelerationStructureBuildRangeInfoKHR)

pub type PFN_vkCmdBuildAccelerationStructuresKHR = fn (C.VkCommandBuffer, u32, &AccelerationStructureBuildGeometryInfoKHR, &&AccelerationStructureBuildRangeInfoKHR)

@[inline]
pub fn cmd_build_acceleration_structures_khr(command_buffer C.VkCommandBuffer,
	info_count u32,
	p_infos &AccelerationStructureBuildGeometryInfoKHR,
	pp_build_range_infos &&AccelerationStructureBuildRangeInfoKHR) {
	C.vkCmdBuildAccelerationStructuresKHR(command_buffer, info_count, p_infos, pp_build_range_infos)
}

fn C.vkCmdBuildAccelerationStructuresIndirectKHR(C.VkCommandBuffer, u32, &AccelerationStructureBuildGeometryInfoKHR, &DeviceAddress, &u32, &&u32)

pub type PFN_vkCmdBuildAccelerationStructuresIndirectKHR = fn (C.VkCommandBuffer, u32, &AccelerationStructureBuildGeometryInfoKHR, &DeviceAddress, &u32, &&u32)

@[inline]
pub fn cmd_build_acceleration_structures_indirect_khr(command_buffer C.VkCommandBuffer,
	info_count u32,
	p_infos &AccelerationStructureBuildGeometryInfoKHR,
	p_indirect_device_addresses &DeviceAddress,
	p_indirect_strides &u32,
	pp_max_primitive_counts &&u32) {
	C.vkCmdBuildAccelerationStructuresIndirectKHR(command_buffer, info_count, p_infos,
		p_indirect_device_addresses, p_indirect_strides, pp_max_primitive_counts)
}

fn C.vkBuildAccelerationStructuresKHR(C.VkDevice, C.VkDeferredOperationKHR, u32, &AccelerationStructureBuildGeometryInfoKHR, &&AccelerationStructureBuildRangeInfoKHR) Result

pub type PFN_vkBuildAccelerationStructuresKHR = fn (C.VkDevice, C.VkDeferredOperationKHR, u32, &AccelerationStructureBuildGeometryInfoKHR, &&AccelerationStructureBuildRangeInfoKHR) Result

@[inline]
pub fn build_acceleration_structures_khr(device C.VkDevice,
	deferred_operation C.VkDeferredOperationKHR,
	info_count u32,
	p_infos &AccelerationStructureBuildGeometryInfoKHR,
	pp_build_range_infos &&AccelerationStructureBuildRangeInfoKHR) Result {
	return C.vkBuildAccelerationStructuresKHR(device, deferred_operation, info_count,
		p_infos, pp_build_range_infos)
}

fn C.vkCopyAccelerationStructureKHR(C.VkDevice, C.VkDeferredOperationKHR, &CopyAccelerationStructureInfoKHR) Result

pub type PFN_vkCopyAccelerationStructureKHR = fn (C.VkDevice, C.VkDeferredOperationKHR, &CopyAccelerationStructureInfoKHR) Result

@[inline]
pub fn copy_acceleration_structure_khr(device C.VkDevice,
	deferred_operation C.VkDeferredOperationKHR,
	p_info &CopyAccelerationStructureInfoKHR) Result {
	return C.vkCopyAccelerationStructureKHR(device, deferred_operation, p_info)
}

fn C.vkCopyAccelerationStructureToMemoryKHR(C.VkDevice, C.VkDeferredOperationKHR, &CopyAccelerationStructureToMemoryInfoKHR) Result

pub type PFN_vkCopyAccelerationStructureToMemoryKHR = fn (C.VkDevice, C.VkDeferredOperationKHR, &CopyAccelerationStructureToMemoryInfoKHR) Result

@[inline]
pub fn copy_acceleration_structure_to_memory_khr(device C.VkDevice,
	deferred_operation C.VkDeferredOperationKHR,
	p_info &CopyAccelerationStructureToMemoryInfoKHR) Result {
	return C.vkCopyAccelerationStructureToMemoryKHR(device, deferred_operation, p_info)
}

fn C.vkCopyMemoryToAccelerationStructureKHR(C.VkDevice, C.VkDeferredOperationKHR, &CopyMemoryToAccelerationStructureInfoKHR) Result

pub type PFN_vkCopyMemoryToAccelerationStructureKHR = fn (C.VkDevice, C.VkDeferredOperationKHR, &CopyMemoryToAccelerationStructureInfoKHR) Result

@[inline]
pub fn copy_memory_to_acceleration_structure_khr(device C.VkDevice,
	deferred_operation C.VkDeferredOperationKHR,
	p_info &CopyMemoryToAccelerationStructureInfoKHR) Result {
	return C.vkCopyMemoryToAccelerationStructureKHR(device, deferred_operation, p_info)
}

fn C.vkWriteAccelerationStructuresPropertiesKHR(C.VkDevice, u32, C.VkAccelerationStructureKHR, QueryType, usize, voidptr, usize) Result

pub type PFN_vkWriteAccelerationStructuresPropertiesKHR = fn (C.VkDevice, u32, C.VkAccelerationStructureKHR, QueryType, usize, voidptr, usize) Result

@[inline]
pub fn write_acceleration_structures_properties_khr(device C.VkDevice,
	acceleration_structure_count u32,
	p_acceleration_structures C.VkAccelerationStructureKHR,
	query_type QueryType,
	data_size usize,
	p_data voidptr,
	stride usize) Result {
	return C.vkWriteAccelerationStructuresPropertiesKHR(device, acceleration_structure_count,
		p_acceleration_structures, query_type, data_size, p_data, stride)
}

fn C.vkCmdCopyAccelerationStructureKHR(C.VkCommandBuffer, &CopyAccelerationStructureInfoKHR)

pub type PFN_vkCmdCopyAccelerationStructureKHR = fn (C.VkCommandBuffer, &CopyAccelerationStructureInfoKHR)

@[inline]
pub fn cmd_copy_acceleration_structure_khr(command_buffer C.VkCommandBuffer,
	p_info &CopyAccelerationStructureInfoKHR) {
	C.vkCmdCopyAccelerationStructureKHR(command_buffer, p_info)
}

fn C.vkCmdCopyAccelerationStructureToMemoryKHR(C.VkCommandBuffer, &CopyAccelerationStructureToMemoryInfoKHR)

pub type PFN_vkCmdCopyAccelerationStructureToMemoryKHR = fn (C.VkCommandBuffer, &CopyAccelerationStructureToMemoryInfoKHR)

@[inline]
pub fn cmd_copy_acceleration_structure_to_memory_khr(command_buffer C.VkCommandBuffer,
	p_info &CopyAccelerationStructureToMemoryInfoKHR) {
	C.vkCmdCopyAccelerationStructureToMemoryKHR(command_buffer, p_info)
}

fn C.vkCmdCopyMemoryToAccelerationStructureKHR(C.VkCommandBuffer, &CopyMemoryToAccelerationStructureInfoKHR)

pub type PFN_vkCmdCopyMemoryToAccelerationStructureKHR = fn (C.VkCommandBuffer, &CopyMemoryToAccelerationStructureInfoKHR)

@[inline]
pub fn cmd_copy_memory_to_acceleration_structure_khr(command_buffer C.VkCommandBuffer,
	p_info &CopyMemoryToAccelerationStructureInfoKHR) {
	C.vkCmdCopyMemoryToAccelerationStructureKHR(command_buffer, p_info)
}

fn C.vkGetAccelerationStructureDeviceAddressKHR(C.VkDevice, &AccelerationStructureDeviceAddressInfoKHR) DeviceAddress

pub type PFN_vkGetAccelerationStructureDeviceAddressKHR = fn (C.VkDevice, &AccelerationStructureDeviceAddressInfoKHR) DeviceAddress

@[inline]
pub fn get_acceleration_structure_device_address_khr(device C.VkDevice,
	p_info &AccelerationStructureDeviceAddressInfoKHR) DeviceAddress {
	return C.vkGetAccelerationStructureDeviceAddressKHR(device, p_info)
}

fn C.vkCmdWriteAccelerationStructuresPropertiesKHR(C.VkCommandBuffer, u32, C.VkAccelerationStructureKHR, QueryType, C.VkQueryPool, u32)

pub type PFN_vkCmdWriteAccelerationStructuresPropertiesKHR = fn (C.VkCommandBuffer, u32, C.VkAccelerationStructureKHR, QueryType, C.VkQueryPool, u32)

@[inline]
pub fn cmd_write_acceleration_structures_properties_khr(command_buffer C.VkCommandBuffer,
	acceleration_structure_count u32,
	p_acceleration_structures C.VkAccelerationStructureKHR,
	query_type QueryType,
	query_pool C.VkQueryPool,
	first_query u32) {
	C.vkCmdWriteAccelerationStructuresPropertiesKHR(command_buffer, acceleration_structure_count,
		p_acceleration_structures, query_type, query_pool, first_query)
}

fn C.vkGetDeviceAccelerationStructureCompatibilityKHR(C.VkDevice, &AccelerationStructureVersionInfoKHR, &AccelerationStructureCompatibilityKHR)

pub type PFN_vkGetDeviceAccelerationStructureCompatibilityKHR = fn (C.VkDevice, &AccelerationStructureVersionInfoKHR, &AccelerationStructureCompatibilityKHR)

@[inline]
pub fn get_device_acceleration_structure_compatibility_khr(device C.VkDevice,
	p_version_info &AccelerationStructureVersionInfoKHR,
	p_compatibility &AccelerationStructureCompatibilityKHR) {
	C.vkGetDeviceAccelerationStructureCompatibilityKHR(device, p_version_info, p_compatibility)
}

fn C.vkGetAccelerationStructureBuildSizesKHR(C.VkDevice, AccelerationStructureBuildTypeKHR, &AccelerationStructureBuildGeometryInfoKHR, &u32, &AccelerationStructureBuildSizesInfoKHR)

pub type PFN_vkGetAccelerationStructureBuildSizesKHR = fn (C.VkDevice, AccelerationStructureBuildTypeKHR, &AccelerationStructureBuildGeometryInfoKHR, &u32, &AccelerationStructureBuildSizesInfoKHR)

@[inline]
pub fn get_acceleration_structure_build_sizes_khr(device C.VkDevice,
	build_type AccelerationStructureBuildTypeKHR,
	p_build_info &AccelerationStructureBuildGeometryInfoKHR,
	p_max_primitive_counts &u32,
	p_size_info &AccelerationStructureBuildSizesInfoKHR) {
	C.vkGetAccelerationStructureBuildSizesKHR(device, build_type, p_build_info, p_max_primitive_counts,
		p_size_info)
}

pub const khr_ray_tracing_pipeline_spec_version = 1
pub const khr_ray_tracing_pipeline_extension_name = 'VK_KHR_ray_tracing_pipeline'

pub enum ShaderGroupShaderKHR {
	general_khr      = 0
	closest_hit_khr  = 1
	any_hit_khr      = 2
	intersection_khr = 3
	max_enum_khr     = max_int
}

pub type RayTracingShaderGroupCreateInfoKHR = C.VkRayTracingShaderGroupCreateInfoKHR

@[typedef]
pub struct C.VkRayTracingShaderGroupCreateInfoKHR {
pub mut:
	sType                           StructureType = StructureType.ray_tracing_shader_group_create_info_khr
	pNext                           voidptr       = unsafe { nil }
	type                            RayTracingShaderGroupTypeKHR
	generalShader                   u32
	closestHitShader                u32
	anyHitShader                    u32
	intersectionShader              u32
	pShaderGroupCaptureReplayHandle voidptr
}

pub type RayTracingPipelineInterfaceCreateInfoKHR = C.VkRayTracingPipelineInterfaceCreateInfoKHR

@[typedef]
pub struct C.VkRayTracingPipelineInterfaceCreateInfoKHR {
pub mut:
	sType                          StructureType = StructureType.ray_tracing_pipeline_interface_create_info_khr
	pNext                          voidptr       = unsafe { nil }
	maxPipelineRayPayloadSize      u32
	maxPipelineRayHitAttributeSize u32
}

pub type RayTracingPipelineCreateInfoKHR = C.VkRayTracingPipelineCreateInfoKHR

@[typedef]
pub struct C.VkRayTracingPipelineCreateInfoKHR {
pub mut:
	sType                        StructureType = StructureType.ray_tracing_pipeline_create_info_khr
	pNext                        voidptr       = unsafe { nil }
	flags                        PipelineCreateFlags
	stageCount                   u32
	pStages                      &PipelineShaderStageCreateInfo
	groupCount                   u32
	pGroups                      &RayTracingShaderGroupCreateInfoKHR
	maxPipelineRayRecursionDepth u32
	pLibraryInfo                 &PipelineLibraryCreateInfoKHR
	pLibraryInterface            &RayTracingPipelineInterfaceCreateInfoKHR
	pDynamicState                &PipelineDynamicStateCreateInfo
	layout                       C.VkPipelineLayout
	basePipelineHandle           C.VkPipeline
	basePipelineIndex            i32
}

pub type PhysicalDeviceRayTracingPipelineFeaturesKHR = C.VkPhysicalDeviceRayTracingPipelineFeaturesKHR

@[typedef]
pub struct C.VkPhysicalDeviceRayTracingPipelineFeaturesKHR {
pub mut:
	sType                                                 StructureType = StructureType.physical_device_ray_tracing_pipeline_features_khr
	pNext                                                 voidptr       = unsafe { nil }
	rayTracingPipeline                                    Bool32
	rayTracingPipelineShaderGroupHandleCaptureReplay      Bool32
	rayTracingPipelineShaderGroupHandleCaptureReplayMixed Bool32
	rayTracingPipelineTraceRaysIndirect                   Bool32
	rayTraversalPrimitiveCulling                          Bool32
}

pub type PhysicalDeviceRayTracingPipelinePropertiesKHR = C.VkPhysicalDeviceRayTracingPipelinePropertiesKHR

@[typedef]
pub struct C.VkPhysicalDeviceRayTracingPipelinePropertiesKHR {
pub mut:
	sType                              StructureType = StructureType.physical_device_ray_tracing_pipeline_properties_khr
	pNext                              voidptr       = unsafe { nil }
	shaderGroupHandleSize              u32
	maxRayRecursionDepth               u32
	maxShaderGroupStride               u32
	shaderGroupBaseAlignment           u32
	shaderGroupHandleCaptureReplaySize u32
	maxRayDispatchInvocationCount      u32
	shaderGroupHandleAlignment         u32
	maxRayHitAttributeSize             u32
}

pub type StridedDeviceAddressRegionKHR = C.VkStridedDeviceAddressRegionKHR

@[typedef]
pub struct C.VkStridedDeviceAddressRegionKHR {
pub mut:
	deviceAddress DeviceAddress
	stride        DeviceSize
	size          DeviceSize
}

pub type TraceRaysIndirectCommandKHR = C.VkTraceRaysIndirectCommandKHR

@[typedef]
pub struct C.VkTraceRaysIndirectCommandKHR {
pub mut:
	width  u32
	height u32
	depth  u32
}

fn C.vkCmdTraceRaysKHR(C.VkCommandBuffer, &StridedDeviceAddressRegionKHR, &StridedDeviceAddressRegionKHR, &StridedDeviceAddressRegionKHR, &StridedDeviceAddressRegionKHR, u32, u32, u32)

pub type PFN_vkCmdTraceRaysKHR = fn (C.VkCommandBuffer, &StridedDeviceAddressRegionKHR, &StridedDeviceAddressRegionKHR, &StridedDeviceAddressRegionKHR, &StridedDeviceAddressRegionKHR, u32, u32, u32)

@[inline]
pub fn cmd_trace_rays_khr(command_buffer C.VkCommandBuffer,
	p_raygen_shader_binding_table &StridedDeviceAddressRegionKHR,
	p_miss_shader_binding_table &StridedDeviceAddressRegionKHR,
	p_hit_shader_binding_table &StridedDeviceAddressRegionKHR,
	p_callable_shader_binding_table &StridedDeviceAddressRegionKHR,
	width u32,
	height u32,
	depth u32) {
	C.vkCmdTraceRaysKHR(command_buffer, p_raygen_shader_binding_table, p_miss_shader_binding_table,
		p_hit_shader_binding_table, p_callable_shader_binding_table, width, height, depth)
}

fn C.vkCreateRayTracingPipelinesKHR(C.VkDevice, C.VkDeferredOperationKHR, C.VkPipelineCache, u32, &RayTracingPipelineCreateInfoKHR, &AllocationCallbacks, C.VkPipeline) Result

pub type PFN_vkCreateRayTracingPipelinesKHR = fn (C.VkDevice, C.VkDeferredOperationKHR, C.VkPipelineCache, u32, &RayTracingPipelineCreateInfoKHR, &AllocationCallbacks, C.VkPipeline) Result

@[inline]
pub fn create_ray_tracing_pipelines_khr(device C.VkDevice,
	deferred_operation C.VkDeferredOperationKHR,
	pipeline_cache C.VkPipelineCache,
	create_info_count u32,
	p_create_infos &RayTracingPipelineCreateInfoKHR,
	p_allocator &AllocationCallbacks,
	p_pipelines C.VkPipeline) Result {
	return C.vkCreateRayTracingPipelinesKHR(device, deferred_operation, pipeline_cache,
		create_info_count, p_create_infos, p_allocator, p_pipelines)
}

fn C.vkGetRayTracingCaptureReplayShaderGroupHandlesKHR(C.VkDevice, C.VkPipeline, u32, u32, usize, voidptr) Result

pub type PFN_vkGetRayTracingCaptureReplayShaderGroupHandlesKHR = fn (C.VkDevice, C.VkPipeline, u32, u32, usize, voidptr) Result

@[inline]
pub fn get_ray_tracing_capture_replay_shader_group_handles_khr(device C.VkDevice,
	pipeline C.VkPipeline,
	first_group u32,
	group_count u32,
	data_size usize,
	p_data voidptr) Result {
	return C.vkGetRayTracingCaptureReplayShaderGroupHandlesKHR(device, pipeline, first_group,
		group_count, data_size, p_data)
}

fn C.vkCmdTraceRaysIndirectKHR(C.VkCommandBuffer, &StridedDeviceAddressRegionKHR, &StridedDeviceAddressRegionKHR, &StridedDeviceAddressRegionKHR, &StridedDeviceAddressRegionKHR, DeviceAddress)

pub type PFN_vkCmdTraceRaysIndirectKHR = fn (C.VkCommandBuffer, &StridedDeviceAddressRegionKHR, &StridedDeviceAddressRegionKHR, &StridedDeviceAddressRegionKHR, &StridedDeviceAddressRegionKHR, DeviceAddress)

@[inline]
pub fn cmd_trace_rays_indirect_khr(command_buffer C.VkCommandBuffer,
	p_raygen_shader_binding_table &StridedDeviceAddressRegionKHR,
	p_miss_shader_binding_table &StridedDeviceAddressRegionKHR,
	p_hit_shader_binding_table &StridedDeviceAddressRegionKHR,
	p_callable_shader_binding_table &StridedDeviceAddressRegionKHR,
	indirect_device_address DeviceAddress) {
	C.vkCmdTraceRaysIndirectKHR(command_buffer, p_raygen_shader_binding_table, p_miss_shader_binding_table,
		p_hit_shader_binding_table, p_callable_shader_binding_table, indirect_device_address)
}

fn C.vkGetRayTracingShaderGroupStackSizeKHR(C.VkDevice, C.VkPipeline, u32, ShaderGroupShaderKHR) DeviceSize

pub type PFN_vkGetRayTracingShaderGroupStackSizeKHR = fn (C.VkDevice, C.VkPipeline, u32, ShaderGroupShaderKHR) DeviceSize

@[inline]
pub fn get_ray_tracing_shader_group_stack_size_khr(device C.VkDevice,
	pipeline C.VkPipeline,
	group u32,
	group_shader ShaderGroupShaderKHR) DeviceSize {
	return C.vkGetRayTracingShaderGroupStackSizeKHR(device, pipeline, group, group_shader)
}

fn C.vkCmdSetRayTracingPipelineStackSizeKHR(C.VkCommandBuffer, u32)

pub type PFN_vkCmdSetRayTracingPipelineStackSizeKHR = fn (C.VkCommandBuffer, u32)

@[inline]
pub fn cmd_set_ray_tracing_pipeline_stack_size_khr(command_buffer C.VkCommandBuffer,
	pipeline_stack_size u32) {
	C.vkCmdSetRayTracingPipelineStackSizeKHR(command_buffer, pipeline_stack_size)
}

pub const khr_ray_query_spec_version = 1
pub const khr_ray_query_extension_name = 'VK_KHR_ray_query'

pub type PhysicalDeviceRayQueryFeaturesKHR = C.VkPhysicalDeviceRayQueryFeaturesKHR

@[typedef]
pub struct C.VkPhysicalDeviceRayQueryFeaturesKHR {
pub mut:
	sType    StructureType = StructureType.physical_device_ray_query_features_khr
	pNext    voidptr       = unsafe { nil }
	rayQuery Bool32
}

pub const ext_mesh_shader_spec_version = 1
pub const ext_mesh_shader_extension_name = 'VK_EXT_mesh_shader'

pub type PhysicalDeviceMeshShaderFeaturesEXT = C.VkPhysicalDeviceMeshShaderFeaturesEXT

@[typedef]
pub struct C.VkPhysicalDeviceMeshShaderFeaturesEXT {
pub mut:
	sType                                  StructureType = StructureType.physical_device_mesh_shader_features_ext
	pNext                                  voidptr       = unsafe { nil }
	taskShader                             Bool32
	meshShader                             Bool32
	multiviewMeshShader                    Bool32
	primitiveFragmentShadingRateMeshShader Bool32
	meshShaderQueries                      Bool32
}

pub type PhysicalDeviceMeshShaderPropertiesEXT = C.VkPhysicalDeviceMeshShaderPropertiesEXT

@[typedef]
pub struct C.VkPhysicalDeviceMeshShaderPropertiesEXT {
pub mut:
	sType                                 StructureType = StructureType.physical_device_mesh_shader_properties_ext
	pNext                                 voidptr       = unsafe { nil }
	maxTaskWorkGroupTotalCount            u32
	maxTaskWorkGroupCount                 [3]u32
	maxTaskWorkGroupInvocations           u32
	maxTaskWorkGroupSize                  [3]u32
	maxTaskPayloadSize                    u32
	maxTaskSharedMemorySize               u32
	maxTaskPayloadAndSharedMemorySize     u32
	maxMeshWorkGroupTotalCount            u32
	maxMeshWorkGroupCount                 [3]u32
	maxMeshWorkGroupInvocations           u32
	maxMeshWorkGroupSize                  [3]u32
	maxMeshSharedMemorySize               u32
	maxMeshPayloadAndSharedMemorySize     u32
	maxMeshOutputMemorySize               u32
	maxMeshPayloadAndOutputMemorySize     u32
	maxMeshOutputComponents               u32
	maxMeshOutputVertices                 u32
	maxMeshOutputPrimitives               u32
	maxMeshOutputLayers                   u32
	maxMeshMultiviewViewCount             u32
	meshOutputPerVertexGranularity        u32
	meshOutputPerPrimitiveGranularity     u32
	maxPreferredTaskWorkGroupInvocations  u32
	maxPreferredMeshWorkGroupInvocations  u32
	prefersLocalInvocationVertexOutput    Bool32
	prefersLocalInvocationPrimitiveOutput Bool32
	prefersCompactVertexOutput            Bool32
	prefersCompactPrimitiveOutput         Bool32
}

pub type DrawMeshTasksIndirectCommandEXT = C.VkDrawMeshTasksIndirectCommandEXT

@[typedef]
pub struct C.VkDrawMeshTasksIndirectCommandEXT {
pub mut:
	groupCountX u32
	groupCountY u32
	groupCountZ u32
}

fn C.vkCmdDrawMeshTasksEXT(C.VkCommandBuffer, u32, u32, u32)

pub type PFN_vkCmdDrawMeshTasksEXT = fn (C.VkCommandBuffer, u32, u32, u32)

@[inline]
pub fn cmd_draw_mesh_tasks_ext(command_buffer C.VkCommandBuffer,
	group_count_x u32,
	group_count_y u32,
	group_count_z u32) {
	C.vkCmdDrawMeshTasksEXT(command_buffer, group_count_x, group_count_y, group_count_z)
}

fn C.vkCmdDrawMeshTasksIndirectEXT(C.VkCommandBuffer, C.VkBuffer, DeviceSize, u32, u32)

pub type PFN_vkCmdDrawMeshTasksIndirectEXT = fn (C.VkCommandBuffer, C.VkBuffer, DeviceSize, u32, u32)

@[inline]
pub fn cmd_draw_mesh_tasks_indirect_ext(command_buffer C.VkCommandBuffer,
	buffer C.VkBuffer,
	offset DeviceSize,
	draw_count u32,
	stride u32) {
	C.vkCmdDrawMeshTasksIndirectEXT(command_buffer, buffer, offset, draw_count, stride)
}

fn C.vkCmdDrawMeshTasksIndirectCountEXT(C.VkCommandBuffer, C.VkBuffer, DeviceSize, C.VkBuffer, DeviceSize, u32, u32)

pub type PFN_vkCmdDrawMeshTasksIndirectCountEXT = fn (C.VkCommandBuffer, C.VkBuffer, DeviceSize, C.VkBuffer, DeviceSize, u32, u32)

@[inline]
pub fn cmd_draw_mesh_tasks_indirect_count_ext(command_buffer C.VkCommandBuffer,
	buffer C.VkBuffer,
	offset DeviceSize,
	count_buffer C.VkBuffer,
	count_buffer_offset DeviceSize,
	max_draw_count u32,
	stride u32) {
	C.vkCmdDrawMeshTasksIndirectCountEXT(command_buffer, buffer, offset, count_buffer,
		count_buffer_offset, max_draw_count, stride)
}
