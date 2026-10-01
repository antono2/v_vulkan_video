module main

import antono2.minimp4
import antono2.h264
import encoding.hex
import os
import antono2.vulkan as vk

fn test_dpb_acquire_uses_a_free_slot() {
	mut dpb := DPB{
		reference_usage: [u8(0), 2]
	}
	assert dpb.acquire_decode_slot(4) == 1
	assert dpb.reference_usage == [u8(0), 2]
}

fn test_dpb_acquire_expires_oldest_reference_when_full() {
	mut dpb := DPB{
		reference_usage: [u8(2), 0, 1]
	}
	assert dpb.acquire_decode_slot(3) == 2
	assert dpb.reference_usage == [u8(0), 1]
}

fn test_mmco5_discards_old_references_after_decode_and_renumbers_current_picture() {
	mut dpb := DPB{
		current_slot:    2
		reference_usage: [u8(0), 1]
	}
	dpb.poc_status[2] = 14
	dpb.bottom_poc_status[2] = 14
	dpb.frame_num_status[2] = 7
	dpb.finish_mmco5()
	assert dpb.reference_usage.len == 0
	assert dpb.poc_status[2] == 0
	assert dpb.bottom_poc_status[2] == 0
	assert dpb.frame_num_status[2] == 0
	assert dpb.poc_status[0] == 0
}

fn test_progressive_field_order_counts_remain_distinct() {
	mut state := PictureOrderCountType0State{}
	result := state.advance(6, -2, 16, true, true, false)
	assert result.top == 6
	assert result.bottom == 4
	assert result.display_poc == 4
	mut dpb := DPB{
		current_slot: 1
	}
	dpb.poc_status[1] = 14
	dpb.bottom_poc_status[1] = 16
	dpb.finish_mmco5()
	assert dpb.poc_status[1] == 0
	assert dpb.bottom_poc_status[1] == 2
}

fn test_nal_length_prefixes_and_invalid_prefixes() {
	for width in [1, 2, 4] {
		mut sample := []u8{len: width}
		sample[width - 1] = 2
		sample << [u8(0x65), 0x80]
		assert detect_nal_length_size(sample)! == u32(width)
		assert read_nal_length(sample, 0, width)! == 2
	}
	if _ := detect_nal_length_size([u8(0), 2, 0xe5, 0x80]) {
		assert false, 'forbidden NAL header was accepted'
	}
}

fn test_h264_sps_levels_map_to_vulkan_ordinals() {
	assert std_h264_level_idc(10) == ._1_0
	assert std_h264_level_idc(31) == ._3_1
	assert std_h264_level_idc(40) == ._4_0
	assert std_h264_level_idc(62) == ._6_2
	assert std_h264_level_idc(49) == .invalid
	assert h264_level_issue(31, ._4_0) == ''
	assert h264_level_issue(42, ._4_0).contains('requires H.264 level 4.2')
}

fn test_parameter_set_preflight_rejects_truncation_and_oversized_arrays() {
	mut truncated := false
	validate_sps_rbsp([u8(0x42), 0, 0x1f]) or {
		assert err.msg().contains('truncated')
		truncated = true
	}
	assert truncated
	mut oversized := false
	validate_sps_rbsp([u8(0x42), 0, 0x1f, 0xd3, 0, 0x81, 0x40]) or {
		assert err.msg().contains('more than 256')
		oversized = true
	}
	assert oversized
	validate_pps_rbsp([u8(0xc5)]) or {
		assert err.msg().contains('slice groups')
		return
	}
	assert false, 'unsupported H.264 slice groups were accepted'
}

fn test_sps_dimensions_reject_overflow_and_crop_past_picture() {
	mut sps := h264.SequenceParameterSet{
		pic_width_in_mbs_minus1:        19
		pic_height_in_map_units_minus1: 11
	}
	width, height, padded_width, padded_height := progressive_h264_dimensions(&sps) or {
		panic(err)
	}
	assert width == 320 && height == 192
	assert padded_width == 320 && padded_height == 192
	sps.frame_crop_left_offset = 160
	mut rejected := false
	progressive_h264_dimensions(&sps) or {
		assert err.msg().contains('crop offsets')
		rejected = true
	}
	assert rejected
	sps.frame_crop_left_offset = 0
	sps.pic_width_in_mbs_minus1 = 0xffffffff
	rejected = false
	progressive_h264_dimensions(&sps) or {
		assert err.msg().contains('dimensions')
		rejected = true
	}
	assert rejected
}

fn test_extra_slice_must_belong_to_first_picture() {
	first := h264.SliceHeader{
		pic_parameter_set_id: 1
		frame_num:            3
		pic_order_cnt_lsb:    6
	}
	mut next := first
	first_nal := h264.NetworkAbstractionLayerHeader{
		idc:  .priority_high
		type: .coded_slice_non_idr
	}
	next_nal := first_nal
	validate_same_picture(&first, &next, &first_nal, &next_nal) or { panic(err) }
	next.frame_num = 4
	validate_same_picture(&first, &next, &first_nal, &next_nal) or {
		assert err.msg().contains('different pictures')
		return
	}
	assert false, 'a slice from another picture was accepted'
}

fn test_slice_parameter_set_references_are_validated_before_full_parse() {
	mut pps := h264.PictureParameterSet{}
	pps.seq_parameter_set_id = 0
	validate_slice_parameter_sets([u8(0xd0)], [pps], [h264.SequenceParameterSet{}]) or {
		assert err.msg().contains('missing PPS 1')
		return
	}
	assert false, 'missing PPS was accepted'
}

fn test_slice_reader_rejects_invalid_slice_type_before_parameter_lookup() {
	mut bits := h264.Bitstream{}
	bits.init([u8(0x8b)]) // first_mb_in_slice = 0, slice_type = 10
	nal := h264.NetworkAbstractionLayerHeader{}
	read_slice_header_checked(&nal, []h264.PictureParameterSet{}, []h264.SequenceParameterSet{}, mut
		bits) or {
		assert err.msg().contains('invalid H.264 slice type')
		return
	}
	assert false, 'invalid slice type was accepted'
}

fn test_slice_parameter_set_ids_need_not_match_array_offsets() {
	pps := h264.PictureParameterSet{
		pic_parameter_set_id: 3
		seq_parameter_set_id: 7
	}
	sps := h264.SequenceParameterSet{
		seq_parameter_set_id: 7
	}
	validate_slice_parameter_sets([u8(0xb2), 0], [pps], [sps]) or { panic(err) }
	assert h264_pps_by_id([pps], 3)!.seq_parameter_set_id == 7
	mut data := DecoderVideoFileProperties{}
	data.sps_storage_index[7] = 2
	data.pps_storage_index[3] = 2
	assert data.sps_storage_offset(7)! == int(sizeof(h264.SequenceParameterSet))
	assert data.pps_storage_offset(3)! == int(sizeof(h264.PictureParameterSet))
	if _ := data.pps_storage_offset(1) {
		assert false, 'missing PPS id resolved to a serialized offset'
	}
}

fn test_parameter_set_preflight_handles_truncated_and_mutated_headers() {
	sps_ebsp := [u8(0x64), 0, 0x0c, 0xac, 0xd9, 0x41, 0x41, 0x9f, 0x9f, 0x01, 0x10, 0, 0, 0x03,
		0, 0x10, 0, 0, 0x03, 0x03, 0, 0xf1, 0x42, 0x99, 0x60]
	sps := unsafe { remove_emulation_prevention_bytes(sps_ebsp.data, sps_ebsp.len) }
	pps := [u8(0xef), 0x89, 0xcb]
	validate_sps_rbsp(sps) or { panic(err) }
	validate_pps_rbsp(pps) or { panic(err) }
	for prefix in 0 .. sps.len {
		if _ := validate_sps_rbsp(sps[..prefix]) {
			assert false, 'truncated SPS prefix ${prefix} was accepted'
		}
	}
	for prefix in 0 .. pps.len {
		if _ := validate_pps_rbsp(pps[..prefix]) {
			assert false, 'truncated PPS prefix ${prefix} was accepted'
		}
	}
	for bit in 0 .. sps.len * 8 {
		mut changed := sps.clone()
		changed[bit / 8] ^= u8(1 << (bit % 8))
		validate_sps_rbsp(changed) or { continue }
	}
	for bit in 0 .. pps.len * 8 {
		mut changed := pps.clone()
		changed[bit / 8] ^= u8(1 << (bit % 8))
		validate_pps_rbsp(changed) or { continue }
	}
}

fn test_picture_order_count_type_one_uses_cycle_and_nonreference_offset() {
	mut sps := h264.SequenceParameterSet{
		pic_order_cnt_type:                    1
		num_ref_frames_in_pic_order_cnt_cycle: 2
		offset_for_non_ref_pic:                -1
		offset_for_top_to_bottom_field:        1
	}
	sps.offset_for_ref_frame[0] = 2
	sps.offset_for_ref_frame[1] = 2
	mut header := h264.SliceHeader{
		frame_num: 3
	}
	header.delta_pic_order_cnt[0] = -1
	top, bottom := poc_type1_fields(&sps, &header, 0, true) or { panic(err) }
	assert top == 5 && bottom == 6
	header.frame_num = 4
	nonref_top, nonref_bottom := poc_type1_fields(&sps, &header, 0, false) or { panic(err) }
	assert nonref_top == 4 && nonref_bottom == 5
}

fn test_dpb_applies_short_and_long_term_reference_marking() {
	mut dpb := DPB{
		reference_usage:     [u8(0), 1]
		current_slot:        2
		max_long_term_index: 1
	}
	dpb.frame_num_status[0] = 3
	dpb.frame_num_status[1] = 4
	mut header := h264.SliceHeader{
		frame_num: 5
	}
	header.drpm.adaptive_ref_pic_marking_mode_flag = 1
	header.drpm.memory_management_control_operation[0] = 1
	header.drpm.difference_of_pic_nums_minus1[0] = 0
	dpb.frame_num_status[2] = 5
	dpb.mark_after_decode(&header, false, true, 3, 16) or { panic(err) }
	assert dpb.reference_usage == [u8(0), 2]

	dpb.current_slot = 1
	dpb.frame_num_status[1] = 6
	header = h264.SliceHeader{
		frame_num: 6
	}
	header.drpm.adaptive_ref_pic_marking_mode_flag = 1
	header.drpm.memory_management_control_operation[0] = 3
	header.drpm.difference_of_pic_nums_minus1[0] = 2
	header.drpm.long_term_frame_idx[0] = 1
	header.drpm.memory_management_control_operation[1] = 6
	header.drpm.long_term_frame_idx[1] = 0
	dpb.mark_after_decode(&header, false, true, 3, 16) or { panic(err) }
	assert dpb.reference_usage == [u8(0), 2, 1]
	assert dpb.long_term[0] && dpb.long_term_index[0] == 1
	assert !dpb.long_term[2]
	assert dpb.long_term[1] && dpb.long_term_index[1] == 0

	dpb.current_slot = 3
	header = h264.SliceHeader{
		frame_num: 7
	}
	header.drpm.adaptive_ref_pic_marking_mode_flag = 1
	header.drpm.memory_management_control_operation[0] = 2
	header.drpm.long_term_pic_num[0] = 0
	header.drpm.memory_management_control_operation[1] = 4
	header.drpm.max_long_term_frame_idx_plus1[1] = 1
	dpb.mark_after_decode(&header, false, true, 3, 16) or { panic(err) }
	assert dpb.reference_usage == [u8(2), 3]
	assert !dpb.long_term[1] && !dpb.long_term[0]
}

fn test_mmco5_is_found_only_in_a_reference_non_idr_slice() {
	mut slice_header := h264.SliceHeader{}
	slice_header.drpm.adaptive_ref_pic_marking_mode_flag = 1
	slice_header.drpm.memory_management_control_operation[0] = 1
	slice_header.drpm.memory_management_control_operation[1] = 5
	assert slice_has_mmco5(&slice_header, false, .priority_high)
	assert !slice_has_mmco5(&slice_header, true, .priority_high)
	assert !slice_has_mmco5(&slice_header, false, .priority_disposable)
	slice_header.drpm.memory_management_control_operation[0] = 0
	assert !slice_has_mmco5(&slice_header, false, .priority_high)
}

fn test_mmco5_starts_a_new_display_group_and_preserves_pre_reset_decode_poc() {
	mut state := PictureOrderCountType0State{}
	idr := state.advance(0, 0, 16, true, true, false)
	assert idr.decode_poc == 0 && idr.display_poc == 0 && idr.cycle == 0
	previous := state.advance(6, 0, 16, false, true, false)
	assert previous.decode_poc == 6 && previous.cycle == 0
	reset := state.advance(14, 0, 16, false, true, true)
	assert reset.decode_poc == 14
	assert reset.display_poc == 0 && reset.cycle == 1
	assert state.prev_msb == 0 && state.prev_lsb == 14
	next := state.advance(1, 0, 16, false, true, false)
	assert next.decode_poc == 17 && next.display_poc == 17 && next.cycle == 1
	assert compare_frame_display_order(&DecoderVideoDataFrameInfo{
		gop: previous.cycle
		poc: previous.display_poc
	}, &DecoderVideoDataFrameInfo{
		gop: reset.cycle
		poc: reset.display_poc
	}) < 0
}

fn test_display_order_compares_signed_picture_counts_within_a_group() {
	before := DecoderVideoDataFrameInfo{
		gop: 2
		poc: -2
	}
	after := DecoderVideoDataFrameInfo{
		gop: 2
		poc: 1
	}
	assert compare_frame_display_order(&before, &after) < 0
	assert compare_frame_display_order(&after, &before) > 0
}

fn test_decode_output_mode_selection_prefers_coincident_in_auto_mode() {
	assert select_decode_output_mode(.automatic, true, true)! == .coincident
	assert select_decode_output_mode(.automatic, false, true)! == .distinct
}

fn test_decode_output_mode_selection_honours_supported_forced_modes() {
	assert select_decode_output_mode(.coincident, true, true)! == .coincident
	assert select_decode_output_mode(.distinct, true, true)! == .distinct
}

fn test_decode_output_mode_selection_rejects_unsupported_modes() {
	select_decode_output_mode(.coincident, false, true) or {
		assert err.msg().contains('does not support forced coincident')
		select_decode_output_mode(.distinct, true, false) or {
			assert err.msg().contains('does not support forced distinct')
			select_decode_output_mode(.automatic, false, false) or {
				assert err.msg().contains('supports neither')
				return
			}
		}
	}
	assert false, 'unsupported decode output modes were accepted'
}

fn test_rotation_from_common_mp4_track_matrices() {
	assert rotation_from_track_matrix([i32(65536), 0, 0, 0, 65536, 0, 0, 0, 1073741824]!) == 0
	assert rotation_from_track_matrix([i32(0), 65536, 0, -65536, 0, 0, 0, 0, 1073741824]!) == -90
	assert rotation_from_track_matrix([i32(0), -65536, 0, 65536, 0, 0, 0, 0, 1073741824]!) == 90
	assert rotation_from_track_matrix([i32(-65536), 0, 0, 0, -65536, 0, 0, 0, 1073741824]!) == 180
}

fn test_display_dimensions_apply_sar_before_rotation() {
	mut metadata := VideoMetadata{
		coded_width:      720
		coded_height:     576
		sar_width:        16
		sar_height:       15
		rotation_degrees: -90
	}
	metadata.update_display_dimensions()
	assert metadata.display_width == 576
	assert metadata.display_height == 768
}

fn test_h264_sample_aspect_ratio_table() {
	w1, h1 := sample_aspect_ratio(1, 0, 0)
	assert w1 == 1 && h1 == 1
	w2, h2 := sample_aspect_ratio(14, 0, 0)
	assert w2 == 4 && h2 == 3
	w3, h3 := sample_aspect_ratio(255, 8, 9)
	assert w3 == 8 && h3 == 9
	w4, h4 := sample_aspect_ratio(255, 0, 0)
	assert w4 == 1 && h4 == 1
}

fn test_h264_profile_names() {
	assert h264_profile_name(66) == 'Baseline'
	assert h264_profile_name(77) == 'Main'
	assert h264_profile_name(100) == 'High'
}

fn test_vui_matrix_coefficients_map_to_vulkan_ycbcr_models() {
	mut metadata := VideoMetadata{
		coded_height:               1080
		colour_description_present: true
	}
	metadata.matrix_coefficients = 0
	assert ycbcr_model_for_video(metadata) == vk.SamplerYcbcrModelConversion.ycbcr_identity
	metadata.matrix_coefficients = 1
	assert ycbcr_model_for_video(metadata) == vk.SamplerYcbcrModelConversion.ycbcr709
	metadata.matrix_coefficients = 5
	assert ycbcr_model_for_video(metadata) == vk.SamplerYcbcrModelConversion.ycbcr601
	metadata.matrix_coefficients = 6
	assert ycbcr_model_for_video(metadata) == vk.SamplerYcbcrModelConversion.ycbcr601
	metadata.matrix_coefficients = 9
	assert ycbcr_model_for_video(metadata) == vk.SamplerYcbcrModelConversion.ycbcr2020
	metadata.matrix_coefficients = 10
	assert ycbcr_model_for_video(metadata) == vk.SamplerYcbcrModelConversion.ycbcr2020
	metadata.matrix_coefficients = 2
	assert ycbcr_model_for_video(metadata) == vk.SamplerYcbcrModelConversion.ycbcr709
	assert ycbcr_model_name(vk.SamplerYcbcrModelConversion.ycbcr709) == 'BT.709'
}

fn test_missing_colour_description_uses_resolution_fallback() {
	assert ycbcr_model_for_video(VideoMetadata{ coded_height: 1080 }) == vk.SamplerYcbcrModelConversion.ycbcr709
	assert ycbcr_model_for_video(VideoMetadata{ coded_height: 720 }) == vk.SamplerYcbcrModelConversion.ycbcr709
	assert ycbcr_model_for_video(VideoMetadata{ coded_height: 576 }) == vk.SamplerYcbcrModelConversion.ycbcr601
}

fn test_minimp4_retains_track_rotation_matrix() {
	path := '${v_modroot}/res/20240917_095400.mp4'
	mut file := os.open(path) or { panic(err) }
	defer { file.close() }
	mut user_data := CallbackUserData{
		file:      &file
		file_size: os.file_size(path)
	}
	mut mp4 := minimp4.MP4D_demux_t{}
	assert minimp4.mp4d_open(&mp4, read_callback, &user_data, i64(user_data.file_size)) == 1
	defer { minimp4.mp4d_close(&mp4) }
	assert mp4.track_count > 0
	track := unsafe { mp4.track[0] }
	assert track.track_matrix[0] == 0
	assert track.track_matrix[1] == 65536
	assert track.track_matrix[3] == -65536
	assert track.track_matrix[4] == 0
	assert rotation_from_track_matrix(track.track_matrix) == -90
}

fn test_minimp4_phone_sample_timing_is_approximately_30_fps() {
	path := '${v_modroot}/res/20240917_095400.mp4'
	mut file := os.open(path) or { panic(err) }
	defer { file.close() }
	mut user_data := CallbackUserData{
		file:      &file
		file_size: os.file_size(path)
	}
	mut mp4 := minimp4.MP4D_demux_t{}
	assert minimp4.mp4d_open(&mp4, read_callback, &user_data, i64(user_data.file_size)) == 1
	defer { minimp4.mp4d_close(&mp4) }
	mut frame_bytes := u32(0)
	mut timestamp := u32(0)
	mut duration := u32(0)
	minimp4.mp4d_frame_offset(&mp4, 0, 10, &frame_bytes, &timestamp, &duration)
	track := unsafe { mp4.track[0] }
	assert timestamp > duration
	frame_duration_ns := i64(f64(duration) / f64(track.timescale) * 1_000_000_000.0)
	assert frame_duration_ns > 33_000_000 && frame_duration_ns < 34_000_000
}

fn test_parser_accepts_available_h264_resolution_and_rate_samples() {
	samples := [
		['Big_Buck_Bunny_360_10s_1MB.mp4', '640', '360'],
		['Big_Buck_Bunny_720_10s_1MB.mp4', '1280', '720'],
		['Big_Buck_Bunny_1080_10s_1MB.mp4', '1920', '1080'],
	]
	for sample in samples {
		mut decoder := Decoder{}
		decoder.parse_mp4_data('${v_modroot}/res/${sample[0]}') or { panic(err) }
		assert decoder.video_data.width == sample[1].u32()
		assert decoder.video_data.height == sample[2].u32()
		assert decoder.video_data.h264_profile_idc == 100
		assert decoder.video_data.frame_infos.len > 250
		assert decoder.video_data.total_duration >= 9_000_000_000
		for frame in decoder.video_data.frame_infos {
			assert frame.size <= decoder.video_data.max_memory_frame_size_bytes
		}
		decoder.video_data.file.close()
	}
}

fn test_parser_accepts_supported_elephants_dream_720p_sample() {
	mut decoder := Decoder{}
	decoder.parse_mp4_data('${v_modroot}/res/Elephants_Dream_720p30_8s_CC-BY.mp4') or { panic(err) }
	defer {
		decoder.video_data.file.close()
	}
	assert decoder.video_data.width == 1280
	assert decoder.video_data.height == 720
	assert decoder.video_data.h264_profile_idc == 100
	assert decoder.video_data.frame_infos.len == 240
	assert decoder.video_data.total_duration == 8_000_000_000
	assert decoder.video_data.metadata.colour_description_present
	assert decoder.video_data.metadata.matrix_coefficients == 1
	assert ycbcr_model_for_video(decoder.video_data.metadata) == vk.SamplerYcbcrModelConversion.ycbcr709
	for decode_index, frame in decoder.video_data.frame_infos {
		assert frame.display_order == decode_index
	}
}

fn test_parser_accepts_four_slices_per_picture() {
	mut decoder := Decoder{}
	decoder.parse_mp4_data('${v_modroot}/res/H264_multislice_320x180_1s.mp4') or { panic(err) }
	defer {
		decoder.video_data.file.close()
	}
	assert decoder.video_data.frame_infos.len == 24
	assert decoder.video_data.h264_level_idc == 12
	assert decoder.video_data.sps_storage_offset(0)! == 0
	assert decoder.video_data.pps_storage_offset(0)! == 0
	for frame in decoder.video_data.frame_infos {
		assert frame.size > 0
		assert frame.size <= decoder.video_data.max_memory_frame_size_bytes
	}
}

fn test_parser_orders_type_zero_b_frames_within_their_gop() {
	mut decoder := Decoder{}
	decoder.parse_mp4_data('${v_modroot}/res/Big_Buck_Bunny_360_10s_1MB.mp4') or { panic(err) }
	defer {
		decoder.video_data.file.close()
	}
	assert decoder.video_data.frame_infos.len == 300
	assert decoder.video_data.frame_infos[..7].map(it.display_order) == [0, 6, 3, 1, 2, 4, 5]
	for display_order, decode_index in decoder.video_data.frame_display_order {
		assert decoder.video_data.frame_infos[decode_index].display_order == display_order
	}
	for decode_index in 1 .. decoder.video_data.frame_infos.len {
		frame := decoder.video_data.frame_infos[decode_index]
		previous := decoder.video_data.frame_infos[decode_index - 1]
		if frame.gop == previous.gop && frame.reference_priority > 0 {
			assert frame.poc >= 0
		}
	}
}

fn test_parsed_reference_marking_operations_are_valid() {
	mut decoder := Decoder{}
	decoder.parse_mp4_data('${v_modroot}/res/Big_Buck_Bunny_360_10s_1MB.mp4') or { panic(err) }
	defer { decoder.video_data.file.close() }
	for i in 0 .. decoder.video_data.frame_infos.len {
		header := unsafe {
			&h264.SliceHeader(byteptr(decoder.video_data.slice_header_bytes.data) +
				i * sizeof(h264.SliceHeader))
		}
		for op in header.drpm.memory_management_control_operation {
			assert op <= 6, 'sample ${i} has invalid MMCO ${op}'
			if op == 0 { break
			 }
		}
	}
}

fn test_parser_rejects_non_mp4_input_as_an_error() {
	temp_path := os.join_path(os.temp_dir(), 'vkvideo-not-an-mp4-${os.getpid()}.txt')
	os.write_file(temp_path, 'This is deliberately not an MP4 file.') or { panic(err) }
	defer {
		os.rm(temp_path) or {}
	}

	mut decoder := Decoder{}
	decoder.parse_mp4_data(temp_path) or {
		assert err.msg().contains('not a readable MP4 file')
		if decoder.video_data.file_open {
			decoder.video_data.file.close()
			decoder.video_data.file_open = false
		}
		return
	}
	assert false, 'plain text was accepted as MP4 video'
}

fn test_mp4_callback_reports_a_short_read() {
	temp_path := os.join_path(os.temp_dir(), 'vkvideo-short-read-${os.getpid()}.bin')
	os.write_file(temp_path, 'abc') or { panic(err) }
	defer {
		os.rm(temp_path) or {}
	}
	mut file := os.open_file(temp_path, 'rb') or { panic(err) }
	defer {
		file.close()
	}
	mut callback_data := CallbackUserData{
		file:      &file
		file_size: 8
	}
	mut destination := []u8{len: 8}
	result := read_callback(0, destination.data, usize(destination.len), &callback_data)
	assert result == 1
	assert callback_data.read_error == 'short read at MP4 offset 0: expected 8 bytes, read 3'
}

fn test_parser_rejects_a_physically_truncated_mp4() {
	source_path := '${v_modroot}/res/Big_Buck_Bunny_360_10s_1MB.mp4'
	bytes := os.read_bytes(source_path) or { panic(err) }
	assert bytes.len > 1024
	temp_path := os.join_path(os.temp_dir(), 'vkvideo-truncated-${os.getpid()}.mp4')
	os.write_file_array(temp_path, bytes[..bytes.len - 1024]) or { panic(err) }
	defer {
		os.rm(temp_path) or {}
	}

	mut decoder := Decoder{}
	decoder.parse_mp4_data(temp_path) or {
		assert err.msg() != ''
		if decoder.video_data.file_open {
			decoder.video_data.file.close()
			decoder.video_data.file_open = false
		}
		return
	}
	decoder.video_data.file.close()
	assert false, 'a physically truncated MP4 was accepted'
}

fn test_runtime_frame_read_reports_file_truncation() {
	source_path := '${v_modroot}/res/Big_Buck_Bunny_360_10s_1MB.mp4'
	bytes := os.read_bytes(source_path) or { panic(err) }
	temp_path := os.join_path(os.temp_dir(), 'vkvideo-runtime-truncated-${os.getpid()}.mp4')
	os.write_file_array(temp_path, bytes) or { panic(err) }
	defer {
		os.rm(temp_path) or {}
	}

	mut parsed_decoder := Decoder{}
	parsed_decoder.parse_mp4_data(temp_path) or { panic(err) }
	last_frame := parsed_decoder.video_data.frame_infos.len - 1
	last_frame_offset := parsed_decoder.video_data.frame_infos[last_frame].src_offset
	buffer_size := int(parsed_decoder.video_data.max_memory_frame_size_bytes)
	mut upload_buffer := []u8{len: buffer_size}
	parsed_decoder.video_data.file.close()
	os.truncate(temp_path, last_frame_offset) or { panic(err) }
	parsed_decoder.video_data.file = os.open_file(temp_path, 'rb') or { panic(err) }
	mut player := VideoPlayer{
		current_frame: last_frame
	}
	lock player.decoder {
		player.decoder = parsed_decoder
		player.decoder.properties.caps.minBitstreamBufferSizeAlignment = 1
	}
	mut frame := VideoPlayerDecodeStreamFrame{
		gpu_bitstream_capacity:                    u64(upload_buffer.len)
		gpu_bitstream_slice_mapped_memory_address: upload_buffer.data
	}
	player.write_video_frame(mut frame) or {
		assert err.msg() != ''
		player.close_input()
		return
	}
	player.close_input()
	assert false, 'runtime upload accepted a frame removed by file truncation'
}

fn test_render_transform_rotates_minus_90_and_letterboxes_portrait_video() {
	metadata := VideoMetadata{
		display_width:    1080
		display_height:   1920
		rotation_degrees: -90
	}
	transform := video_render_transform(metadata, vk.Extent2D{
		width:  1280
		height: 720
	})
	assert transform.values[0..7] == [f32(0), 1, 0, 0, -1, 0, 1]
	assert transform.values[8] > 0.31 && transform.values[8] < 0.32
	assert transform.values[9] == 1
}

fn test_parser_keeps_nonzero_parameter_set_ids_for_runtime_lookup() {
	mut decoder := Decoder{}
	decoder.parse_mp4_data('${v_modroot}/res/H264_parameter_id_7_160x96_1s.mp4') or { panic(err) }
	defer { decoder.video_data.file.close() }
	assert decoder.video_data.frame_infos.len == 5
	assert decoder.video_data.sps_count == 1
	assert decoder.video_data.pps_count == 1
	assert decoder.video_data.sps_storage_offset(7)! == 0
	assert decoder.video_data.pps_storage_offset(7)! == 0
	sps := unsafe { &h264.SequenceParameterSet(decoder.video_data.sps_bytes.data) }
	pps := unsafe { &h264.PictureParameterSet(decoder.video_data.pps_bytes.data) }
	assert sps.seq_parameter_set_id == 7
	assert pps.pic_parameter_set_id == 7
	assert pps.seq_parameter_set_id == 7
	for i in 0 .. decoder.video_data.frame_infos.len {
		header := unsafe {
			&h264.SliceHeader(byteptr(decoder.video_data.slice_header_bytes.data) +
				i * sizeof(h264.SliceHeader))
		}
		assert header.pic_parameter_set_id == 7
	}
}

fn test_custom_h264_scaling_lists_reach_vulkan_parameter_structs() {
	// SPS from the FRExt_MMCO4_Sony_B conformance stream. Its eight custom
	// lists exposed the pinned parser's fixed-array slice-write bug.
	sps_nal :=
		hex.decode('2764001fad9464763b8ac4444a323b1dc5622225191d8ee2b11114222b373669a844566e6cd35088acdcd9a69444cd1b9bc57c9f93f9bf27c9e4e4cd251a4689c9ebe4fd7f27ebe4f5c9a906c694160964')!
	sps_rbsp := unsafe { remove_emulation_prevention_bytes(byteptr(sps_nal.data) + 1,
		sps_nal.len - 1) }
	validate_sps_rbsp(sps_rbsp)!
	mut sps_bits := h264.Bitstream{}
	sps_bits.init(sps_rbsp)
	mut sps := h264.SequenceParameterSet{}
	sps.read_sps(mut sps_bits)
	populate_sps_scaling_lists(sps_rbsp, mut sps)!
	assert sps.scaling_list_4x4[0][..4] == [i32(6), 12, 12, 19]
	assert sps.scaling_list_8x8[0][..4] == [i32(6), 10, 10, 13]
	assert sps.scaling_list_8x8[1][0] != 0

	// A minimal PPS with one custom 4x4 list of sixteen eights.
	pps_rbsp := hex.decode('ce3c7fffe0c0')!
	validate_pps_rbsp(pps_rbsp)!
	mut pps_bits := h264.Bitstream{}
	pps_bits.init(pps_rbsp)
	mut pps := h264.PictureParameterSet{}
	pps.read_pps(mut pps_bits)
	populate_pps_scaling_lists(pps_rbsp, mut pps)!
	assert pps.pic_scaling_matrix_present_flag == 1
	assert pps.scaling_list_4x4[0][..4] == [i32(8), 8, 8, 8]
}
