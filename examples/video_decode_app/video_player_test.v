module video_decode_app

import minimp4
import os
import vulkan as vk

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

fn test_rotation_from_common_mp4_track_matrices() {
	assert rotation_from_track_matrix([i32(65536), 0, 0, 0, 65536, 0, 0, 0, 1073741824]!) == 0
	assert rotation_from_track_matrix([i32(0), 65536, 0, -65536, 0, 0, 0, 0, 1073741824]!) == -90
	assert rotation_from_track_matrix([i32(0), -65536, 0, 65536, 0, 0, 0, 0, 1073741824]!) == 90
	assert rotation_from_track_matrix([i32(-65536), 0, 0, 0, -65536, 0, 0, 0, 1073741824]!) == 180
}

fn test_display_dimensions_apply_sar_before_rotation() {
	mut metadata := VideoMetadata{
		coded_width: 720
		coded_height: 576
		sar_width: 16
		sar_height: 15
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

fn test_vui_colour_primaries_map_to_vulkan_ycbcr_models() {
	assert ycbcr_model_from_colour_primaries(1) == vk.SamplerYcbcrModelConversion.ycbcr709
	assert ycbcr_model_from_colour_primaries(5) == vk.SamplerYcbcrModelConversion.ycbcr601
	assert ycbcr_model_from_colour_primaries(6) == vk.SamplerYcbcrModelConversion.ycbcr601
	assert ycbcr_model_from_colour_primaries(9) == vk.SamplerYcbcrModelConversion.ycbcr2020
	assert ycbcr_model_from_colour_primaries(2) == vk.SamplerYcbcrModelConversion.ycbcr_identity
	assert ycbcr_model_name(vk.SamplerYcbcrModelConversion.ycbcr709) == 'BT.709'
}

fn test_minimp4_retains_track_rotation_matrix() {
	path := '${v_modroot}/res/20240917_095400.mp4'
	mut file := os.open(path) or { panic(err) }
	defer { file.close() }
	mut user_data := CallbackUserData{
		file: &file
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
		file: &file
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
		decoder.video_data.file.close()
	}
}

fn test_parser_orders_type_zero_b_frames_within_their_gop() {
	mut decoder := Decoder{}
	decoder.parse_mp4_data('${v_modroot}/res/Big_Buck_Bunny_360_10s_1MB.mp4') or {
		panic(err)
	}
	defer {
		decoder.video_data.file.close()
	}
	assert decoder.video_data.frame_infos.len == 300
	assert decoder.video_data.frame_infos[..7].map(it.display_order) == [0, 6, 3, 1, 2,
		4, 5]
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

fn test_parser_rejects_non_mp4_input_as_an_error() {
	mut decoder := Decoder{}
	decoder.parse_mp4_data('${v_modroot}/NOTES.txt') or {
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
		file: &file
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
		gpu_bitstream_capacity: u64(upload_buffer.len)
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
		display_width: 1080
		display_height: 1920
		rotation_degrees: -90
	}
	transform := video_render_transform(metadata, vk.Extent2D{
		width: 1280
		height: 720
	})
	assert transform.values[0..7] == [f32(0), 1, 0, 0, -1, 0, 1]
	assert transform.values[8] > 0.31 && transform.values[8] < 0.32
	assert transform.values[9] == 1
}
