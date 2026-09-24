module main

import antono2.vulkan as vk
import math
import antono2.vkmemalloc as vkmem
import antono2.h264

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
		pNext:               &d.settings.decode_h264_profile_info
		videoCodecOperation: vk.VideoCodecOperationFlagBitsKHR.decode_h264
		chromaSubsampling:   vk.VideoChromaSubsamplingFlagsKHR(vk.VideoChromaSubsamplingFlagBitsKHR._420)
		lumaBitDepth:        vk.VideoComponentBitDepthFlagsKHR(vk.VideoComponentBitDepthFlagBitsKHR._8)
		chromaBitDepth:      vk.VideoComponentBitDepthFlagsKHR(vk.VideoComponentBitDepthFlagBitsKHR._8)
	}
	d.properties.caps.pNext = &d.properties.decode_caps

	mut res := vk.get_physical_device_video_capabilities_khr(dev_ctx.get_gpu_current(),
		&d.settings.profile_info, mut &d.properties.caps)
	if res != vk.Result.success {
		panic('Vulkan device does not expose H.264 ${h264_profile_name(d.video_data.h264_profile_idc)} Profile decode capabilities: ${res}')
	}

	// Construct the complete wrapper so its required Vulkan sType default is
	// applied. Mutating fields of the zero-initialized embedded value leaves
	// sType at zero with some V compiler/code-generation paths; NVIDIA's driver
	// may then fault when this chain is passed to vkCreateImage.
	d.settings.profile_list_info = vk.VideoProfileListInfoKHR{
		profileCount: 1
		pProfiles:    &d.settings.profile_info
	}

	capability_flags := d.properties.decode_caps.flags
	supports_coincide := (capability_flags & vk.VideoDecodeCapabilityFlagsKHR(vk.VideoDecodeCapabilityFlagBitsKHR.dpb_and_output_coincide)) != 0
	supports_distinct := (capability_flags & vk.VideoDecodeCapabilityFlagsKHR(vk.VideoDecodeCapabilityFlagBitsKHR.dpb_and_output_distinct)) != 0
	selected_output_mode := select_decode_output_mode(app.decode_output_mode, supports_coincide,
		supports_distinct) or { panic(err) }
	d.properties.dpb_and_output_coincide = selected_output_mode == .coincident
	println('Decode image mode: ${if d.properties.dpb_and_output_coincide {
		'coincident DPB/output'
	} else {
		'distinct DPB/output'
	}}')
	output_usage := vk.ImageUsageFlags(u32(vk.ImageUsageFlagBits.video_decode_dst) | u32(vk.ImageUsageFlagBits.transfer_src))
	d.properties.format_props = query_video_format(dev_ctx.get_gpu_current(),
		&d.settings.profile_list_info, output_usage) or {
		panic('No Vulkan Video decode-output format supports transfer to the display image')
	}
	dpb_usage := if d.properties.dpb_and_output_coincide {
		vk.ImageUsageFlags(u32(vk.ImageUsageFlagBits.video_decode_dpb) | u32(vk.ImageUsageFlagBits.video_decode_dst) | u32(vk.ImageUsageFlagBits.transfer_src))
	} else {
		vk.ImageUsageFlags(vk.ImageUsageFlagBits.video_decode_dpb)
	}
	d.properties.dpb_format_props = query_video_format(dev_ctx.get_gpu_current(),
		&d.settings.profile_list_info, dpb_usage) or {
		panic('No Vulkan Video DPB format supports the required decode mode')
	}
	d.properties.usage_dpb = dpb_usage

	num_memory_frames := u64(d.video_data.num_dpb_slots)
	mut aligned_frame_size :=
		U64(d.video_data.max_memory_frame_size_bytes).align_to(d.properties.caps.minBitstreamBufferOffsetAlignment)
	aligned_frame_size =
		U64(aligned_frame_size).align_to(d.properties.caps.minBitstreamBufferSizeAlignment)
	d.video_data.max_memory_frame_size_bytes = aligned_frame_size
	video_decoder_queue_family_index := dev_ctx.get_decoder_queue_family_index()
	buffer_size := d.video_data.max_memory_frame_size_bytes * num_memory_frames
	buffer_ci := vk.BufferCreateInfo{
		pNext:                 &d.settings.profile_list_info
		flags:                 0
		size:                  buffer_size
		usage:                 vk.BufferUsageFlags(vk.BufferUsageFlagBits.video_decode_src)
		sharingMode:           vk.SharingMode.exclusive
		queueFamilyIndexCount: 0
		pQueueFamilyIndices:   unsafe { nil }
	}
	res = app.device_context.memory_allocator.create_buffer_with_options(&buffer_ci, vkmem.AllocationOptions{
		usage: .upload
	}, &d.gpu_bitstream_buffer, mut d.gpu_bitstream_allocation)
	if res != vk.Result.success {
		panic('Could not create the Vulkan Video bitstream buffer: ${res}')
	}
	// Host visible
	mut p_data := unsafe { nil }
	// Use the same live allocator instance that created the allocation. dev_ctx
	// was copied before create_buffer() updated the allocator's block table.
	res = app.device_context.memory_allocator.map(mut d.gpu_bitstream_allocation, &p_data)
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
		queueFamilyIndex:           video_decoder_queue_family_index
		pVideoProfile:              &d.settings.profile_info
		pictureFormat:              d.properties.format_props.format
		maxCodedExtent:             vk.Extent2D{
			width:  d.video_data.width_padd
			height: d.video_data.height_padd
		}
		referencePictureFormat:     d.properties.dpb_format_props.format
		maxDpbSlots:                d.video_data.num_dpb_slots
		maxActiveReferencePictures: d.video_data.max_reference_pictures
		pStdHeaderVersion:          &d.properties.caps.stdHeaderVersion
	}
	res = vk.create_video_session_khr(dev_ctx.vk_device, &session_ci, unsafe { nil },
		&d.video_session)
	if res != vk.Result.success {
		panic('Could not create the Vulkan Video H.264 decode session: ${res}')
	}

	mut requirement_count := u32(0)
	mut n := unsafe { nil }
	vk.get_video_session_memory_requirements_khr(dev_ctx.vk_device, d.video_session,
		&requirement_count, mut n)
	mut requirements := []vk.VideoSessionMemoryRequirementsKHR{len: int(requirement_count), init: vk.VideoSessionMemoryRequirementsKHR{}}

	mut requirements_data := requirements.data
	res = vk.get_video_session_memory_requirements_khr(dev_ctx.vk_device, d.video_session,
		&requirement_count, mut requirements_data)
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
		memory_type_index := dev_ctx.memory_allocator.get_memory_type(req.memoryRequirements.memoryTypeBits,
			vk.MemoryPropertyFlags(0))
		if memory_type_index == max_u32 {
			panic('No compatible Vulkan memory type exists for video-session binding ${req.memoryBindIndex}')
		}
		allocate_info := vk.MemoryAllocateInfo{
			allocationSize:  req.memoryRequirements.size
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
			memory:          session_memory
			memoryOffset:    0
			memorySize:      req.memoryRequirements.size
		}
	}

	// Resolve this extension command from the device directly. When another
	// shared object links libvulkan, ELF symbol interposition can otherwise
	// make Volk's same-named global dispatch slot unreliable.
	bind_session_memory_fn := vk.PFN_vkBindVideoSessionMemoryKHR(vk.get_device_proc_addr(dev_ctx.vk_device,
		c'vkBindVideoSessionMemoryKHR'))
	if isnil(voidptr(bind_session_memory_fn)) {
		panic('vkGetDeviceProcAddr returned null for vkBindVideoSessionMemoryKHR')
	}
	res = bind_session_memory_fn(dev_ctx.vk_device, d.video_session,
		u32(bind_session_memory_infos.len), bind_session_memory_infos.data)
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

	d.prepare_decoded_picture_buffer(dev_ctx.vk_device, mut app.device_context.memory_allocator)

	d.info.memory_frames = []DecoderVideoMemoryFrameInfo{len: int(num_memory_frames), init: DecoderVideoMemoryFrameInfo{
		data_frame_info:                           unsafe { nil }
		gpu_bitstream_slice_mapped_memory_address: unsafe { nil }
		decoding_frame_index:                      -1
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

fn (mut d Decoder) prepare_decoded_picture_buffer(device vk.Device, mut allocator vkmem.Allocator) {
	// Allocate an image array to store decoded pictures in  -
	// num_dpb_slots already includes one slot for the picture currently decoded.
	//
	// we know there will be at max 17 images (16+1) as 16 is the max by the standard.
	//
	// Decoded-picture-buffer images should remain in device-local memory.
	dpb_image_count := int(d.video_data.num_dpb_slots)
	d.info.images_dpb = []DecoderDpbImage{len: dpb_image_count}

	image_ci := vk.ImageCreateInfo{
		pNext:                 &d.settings.profile_list_info
		flags:                 0
		imageType:             vk.ImageType._2d
		format:                d.properties.dpb_format_props.format
		extent:                vk.Extent3D{
			width:  d.video_data.width_padd
			height: d.video_data.height_padd
			depth:  1
		}
		mipLevels:             1
		arrayLayers:           1
		samples:               vk.SampleCountFlagBits._1
		tiling:                vk.ImageTiling.optimal
		usage:                 d.properties.usage_dpb
		sharingMode:           vk.SharingMode.exclusive
		queueFamilyIndexCount: 0
		pQueueFamilyIndices:   unsafe { nil }
		initialLayout:         vk.ImageLayout.undefined
	}

	mut image_view_ci := vk.ImageViewCreateInfo{
		flags:            0
		image:            unsafe { nil }
		viewType:         vk.ImageViewType._2d
		format:           image_ci.format
		components:       vk.ComponentMapping{}
		subresourceRange: vk.ImageSubresourceRange{
			aspectMask:     vk.ImageAspectFlags(vk.ImageAspectFlagBits.color)
			baseMipLevel:   0
			levelCount:     1
			baseArrayLayer: 0
			layerCount:     1
		}
	}

	mut dpb_index := 0
	mut res := vk.Result.error_unknown
	for mut dpb in d.info.images_dpb {
		res = allocator.create_image_with_options(&image_ci, vkmem.AllocationOptions{
			usage: .gpu_only
		}, &dpb.image, mut dpb.allocation_info)
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
		$if debug ? {
			name := 'myDPBImage${dpb_index}'
			name_info := vk.DebugUtilsObjectNameInfoEXT{
				objectType:   vk.ObjectType.image
				objectHandle: u64(voidptr(dpb.image))
				pObjectName:  name.str // C string
			}
			vk.set_debug_utils_object_name_ext(device, &name_info)
		}
		dpb_index++
	} // for d.info.images_dpb
}

fn (mut d Decoder) create_video_session_parameters(device vk.Device) {
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
		for list_idx < vk.std_video_h264_scaling_list_4x4_num_lists
			&& list_idx < pps.scaling_list_4x4.len {
			for el_idx < vk.std_video_h264_scaling_list_4x4_num_elements
				&& el_idx < pps.scaling_list_4x4[0].len {
				unsafe {
					C.vv_set_h264_scaling_list_4x4(&video_scaling_list_pps[i], u32(list_idx),
						u32(el_idx), u8(pps.scaling_list_4x4[list_idx][el_idx]))
				}
				el_idx++
			}
			list_idx++
		}
		list_idx = 0
		el_idx = 0
		for list_idx < vk.std_video_h264_scaling_list_8x8_num_lists
			&& list_idx < pps.scaling_list_8x8.len {
			for el_idx < vk.std_video_h264_scaling_list_8x8_num_elements
				&& el_idx < pps.scaling_list_8x8[0].len {
				unsafe {
					C.vv_set_h264_scaling_list_8x8(&video_scaling_list_pps[i], u32(list_idx),
						u32(el_idx), u8(pps.scaling_list_8x8[list_idx][el_idx]))
				}
				el_idx++
			}
			list_idx++
		}

		video_picture_parameter_sets[i] = vk.StdVideoH264PictureParameterSet{
			flags:                                vk.StdVideoH264PpsFlags{
				transform_8x8_mode_flag:                      u32(pps.transform_8x8_mode_flag)
				redundant_pic_cnt_present_flag:               pps.redundant_pic_cnt_present_flag
				constrained_intra_pred_flag:                  pps.constrained_intra_pred_flag
				deblocking_filter_control_present_flag:       pps.deblocking_filter_control_present_flag
				weighted_pred_flag:                           pps.weighted_pred_flag
				bottom_field_pic_order_in_frame_present_flag: pps.pic_order_present_flag
				entropy_coding_mode_flag:                     pps.entropy_coding_mode_flag
				pic_scaling_matrix_present_flag:              pps.pic_scaling_matrix_present_flag
			}
			seq_parameter_set_id:                 u8(pps.seq_parameter_set_id)
			pic_parameter_set_id:                 u8(pps.pic_parameter_set_id)
			num_ref_idx_l0_default_active_minus1: u8(pps.num_ref_idx_l0_active_minus1)
			num_ref_idx_l1_default_active_minus1: u8(pps.num_ref_idx_l1_active_minus1)
			weighted_bipred_idc:                  unsafe { vk.StdVideoH264WeightedBipredIdc(pps.weighted_bipred_idc) }
			pic_init_qp_minus26:                  i8(pps.pic_init_qp_minus26)
			pic_init_qs_minus26:                  i8(pps.pic_init_qs_minus26)
			chroma_qp_index_offset:               i8(pps.chroma_qp_index_offset)
			second_chroma_qp_index_offset:        i8(pps.second_chroma_qp_index_offset)
			pScalingLists:                        unsafe { &video_scaling_list_pps[i] }
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
				constraint_set0_flag:                 sps.constraint_set0_flag
				constraint_set1_flag:                 sps.constraint_set1_flag
				constraint_set2_flag:                 sps.constraint_set2_flag
				constraint_set3_flag:                 sps.constraint_set3_flag
				constraint_set4_flag:                 sps.constraint_set4_flag
				constraint_set5_flag:                 sps.constraint_set5_flag
				direct_8x8_inference_flag:            sps.direct_8x8_inference_flag
				mb_adaptive_frame_field_flag:         sps.mb_adaptive_frame_field_flag
				frame_mbs_only_flag:                  sps.frame_mbs_only_flag
				delta_pic_order_always_zero_flag:     sps.delta_pic_order_always_zero_flag
				separate_colour_plane_flag:           sps.separate_colour_plane_flag
				gaps_in_frame_num_value_allowed_flag: sps.gaps_in_frame_num_value_allowed_flag
				qpprime_y_zero_transform_bypass_flag: sps.qpprime_y_zero_transform_bypass_flag
				frame_cropping_flag:                  sps.frame_cropping_flag
				seq_scaling_matrix_present_flag:      sps.seq_scaling_matrix_present_flag
				vui_parameters_present_flag:          sps.vui_parameters_present_flag
			}
			// Note: There is no 0 in StdVideoH264ProfileIdc enum
			profile_idc:                           unsafe { vk.StdVideoH264ProfileIdc(sps.profile_idc) }
			level_idc:                             unsafe { vk.StdVideoH264LevelIdc(sps.level_idc) }
			chroma_format_idc:                     get_chroma_format(sps.profile_idc,
				sps.chroma_format_idc)
			seq_parameter_set_id:                  u8(sps.seq_parameter_set_id)
			bit_depth_luma_minus8:                 u8(sps.bit_depth_luma_minus8)
			bit_depth_chroma_minus8:               u8(sps.bit_depth_chroma_minus8)
			log2_max_frame_num_minus4:             u8(sps.log2_max_frame_num_minus4)
			pic_order_cnt_type:                    unsafe { vk.StdVideoH264PocType(sps.pic_order_cnt_type) }
			offset_for_non_ref_pic:                sps.offset_for_non_ref_pic
			log2_max_pic_order_cnt_lsb_minus4:     u8(sps.log2_max_pic_order_cnt_lsb_minus4)
			num_ref_frames_in_pic_order_cnt_cycle: u8(sps.num_ref_frames_in_pic_order_cnt_cycle)
			max_num_ref_frames:                    u8(sps.num_ref_frames)
			reserved1:                             0
			pic_width_in_mbs_minus1:               sps.pic_width_in_mbs_minus1
			pic_height_in_map_units_minus1:        sps.pic_height_in_map_units_minus1
			frame_crop_left_offset:                sps.frame_crop_left_offset
			frame_crop_right_offset:               sps.frame_crop_right_offset
			frame_crop_top_offset:                 sps.frame_crop_top_offset
			frame_crop_bottom_offset:              sps.frame_crop_bottom_offset
			reserved2:                             0
			pOffsetForRefFrame:                    unsafe { nil }
			pScalingLists:                         unsafe { &video_scaling_list_sps[i] }
			pSequenceParameterSetVui:              unsafe { &video_sequence_parameter_set_vui[i] }
		}

		// VUI stands for "Video Usability Information"
		vui := &sps.vui

		video_sequence_parameter_set_vui[i] = vk.StdVideoH264SequenceParameterSetVui{
			flags:                               vk.StdVideoH264SpsVuiFlags{
				aspect_ratio_info_present_flag:  vui.aspect_ratio_info_present_flag
				overscan_info_present_flag:      vui.overscan_info_present_flag
				overscan_appropriate_flag:       vui.overscan_appropriate_flag
				video_signal_type_present_flag:  vui.video_signal_type_present_flag
				video_full_range_flag:           vui.video_full_range_flag
				color_description_present_flag:  vui.color_description_present_flag
				chroma_loc_info_present_flag:    vui.chroma_loc_info_present_flag
				timing_info_present_flag:        vui.timing_info_present_flag
				fixed_frame_rate_flag:           vui.fixed_frame_rate_flag
				bitstream_restriction_flag:      vui.bitstream_restriction_flag
				nal_hrd_parameters_present_flag: vui.nal_hrd_parameters_present_flag
				vcl_hrd_parameters_present_flag: vui.vcl_hrd_parameters_present_flag
			}
			aspect_ratio_idc:                    unsafe { vk.StdVideoH264AspectRatioIdc(vui.aspect_ratio_idc) }
			sar_width:                           u16(vui.sar_width)
			sar_height:                          u16(vui.sar_height)
			video_format:                        u8(vui.video_format)
			colour_primaries:                    u8(vui.colour_primaries)
			transfer_characteristics:            u8(vui.transfer_characteristics)
			matrix_coefficients:                 u8(vui.matrix_coefficients)
			num_units_in_tick:                   vui.num_units_in_tick
			time_scale:                          vui.time_scale
			max_num_reorder_frames:              u8(vui.num_reorder_frames)
			max_dec_frame_buffering:             u8(vui.max_dec_frame_buffering)
			chroma_sample_loc_type_top_field:    u8(vui.chroma_sample_loc_type_top_field)
			chroma_sample_loc_type_bottom_field: u8(vui.chroma_sample_loc_type_bottom_field)
			reserved1:                           0
			pHrdParameters:                      unsafe { &video_hrd_parameters[i] }
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
			cpb_removal_delay_length_minus1:         hrd.cpb_removal_delay_length_minus1
			dpb_output_delay_length_minus1:          hrd.dpb_output_delay_length_minus1
			time_offset_length:                      hrd.time_offset_length
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
		for list_idx < vk.std_video_h264_scaling_list_4x4_num_lists
			&& list_idx < sps.scaling_list_4x4.len {
			for el_idx < vk.std_video_h264_scaling_list_4x4_num_elements
				&& el_idx < sps.scaling_list_4x4[0].len {
				unsafe {
					C.vv_set_h264_scaling_list_4x4(&video_scaling_list_sps[i], u32(list_idx),
						u32(el_idx), u8(sps.scaling_list_4x4[list_idx][el_idx]))
				}
				el_idx++
			}
			list_idx++
		}

		list_idx = 0
		el_idx = 0
		for list_idx < vk.std_video_h264_scaling_list_8x8_num_lists
			&& list_idx < sps.scaling_list_8x8.len {
			for el_idx < vk.std_video_h264_scaling_list_8x8_num_elements
				&& el_idx < sps.scaling_list_8x8[0].len {
				unsafe {
					C.vv_set_h264_scaling_list_8x8(&video_scaling_list_sps[i], u32(list_idx),
						u32(el_idx), u8(sps.scaling_list_8x8[list_idx][el_idx]))
				}
				el_idx++
			}
			list_idx++
		}
	} // for d.video_data.sps_count

	mut session_parameters_add_info := vk.VideoDecodeH264SessionParametersAddInfoKHR{
		stdSPSCount: d.video_data.sps_count
		pStdSPSs:    video_sequence_parameter_set.data
		stdPPSCount: d.video_data.pps_count
		pStdPPSs:    video_picture_parameter_sets.data
	}
	mut video_decode_session_parameters_ci := vk.VideoDecodeH264SessionParametersCreateInfoKHR{
		maxStdSPSCount:     d.video_data.sps_count
		maxStdPPSCount:     d.video_data.pps_count
		pParametersAddInfo: &session_parameters_add_info
	}
	video_session_parameters_ci := vk.VideoSessionParametersCreateInfoKHR{
		pNext:                          &video_decode_session_parameters_ci
		flags:                          0
		videoSessionParametersTemplate: unsafe { nil }
		videoSession:                   d.video_session
	}

	res := vk.create_video_session_parameters_khr(device, &video_session_parameters_ci,
		unsafe { nil }, &d.video_session_parameters)
	if res != vk.Result.success {
		panic('Could not create H.264 video-session parameters: ${res}')
	}
}

type U64 = u64

fn (sz U64) align_to(alignment usize) u64 {
	return ((sz - 1) / alignment + 1) * alignment
}
