module main

import os
import math
import antono2.minimp4
import antono2.h264

@[heap]
struct CallbackUserData {
pub mut:
	file        &os.File
	last_offset i64
	file_size   u64
	read_error  string
}

fn read_callback(offset i64, buffer &u8, size usize, user_data voidptr) int {
	mut data := unsafe { &CallbackUserData(user_data) }
	if offset < 0 || offset >= data.file_size {
		return 1
	}
	to_copy := math.min(i64(size), data.file_size - offset)
	data.file.seek(offset, .start) or {
		data.read_error = 'could not seek to MP4 offset ${offset}: ${err}'
		return 1
	}
	num_bytes_read := data.file.read_into_ptr(buffer, int(to_copy)) or {
		data.read_error = 'could not read ${to_copy} bytes at MP4 offset ${offset}: ${err}'
		return 1
	}
	data.last_offset = offset + num_bytes_read
	if num_bytes_read != int(to_copy) {
		data.read_error = 'short read at MP4 offset ${offset}: expected ${to_copy} bytes, read ${num_bytes_read}'
		return 1
	}
	return 0
}

// Turn an EBSP (Encapsulated Byte Sequence Payload) into an RBSP (Raw Byte Sequence Payload)
// pub fn remove_emulation_prevention_bytes(ebsp []u8) []u8 {
//   mut rbsp := []u8{cap: ebsp.len}
//   if ebsp.len == 0 { return rbsp }
//   mut i := 0
//   for i < ebsp.len {
//     if ((i + 2) < ebsp.len)
//     && ebsp[i] == 0
//     && ebsp[i + 1] == 0
//     && ebsp[i + 2] == 3 {
//       rbsp << ebsp[i]
//       rbsp << ebsp[i + 1]
//       i += 2
//     } else {
//       rbsp << ebsp[i]
//     }
//     i++
//   }
//   return rbsp
// }
@[unsafe]
fn remove_emulation_prevention_bytes(ebsp byteptr, size int) []u8 {
	mut rbsp := []u8{cap: size}
	if size == 0 {
		return rbsp
	}
	mut i := 0
	for i < size {
		if (i + 2) < size && unsafe { ebsp[i] == 0 && ebsp[i + 1] == 0 && ebsp[i + 2] == 3 } {
			rbsp << unsafe { ebsp[i] }
			rbsp << unsafe { ebsp[i + 1] }
			i += 2
		} else {
			rbsp << unsafe { ebsp[i] }
		}
		i++
	}
	return rbsp
}

fn slice_has_mmco5(slice_header &h264.SliceHeader, is_idr bool, ref_idc h264.NAL_REF_IDC) bool {
	if is_idr || ref_idc == .priority_disposable
		|| slice_header.drpm.adaptive_ref_pic_marking_mode_flag == 0 {
		return false
	}
	for operation in slice_header.drpm.memory_management_control_operation {
		if operation == 5 {
			return true
		}
		if operation == 0 {
			break
		}
	}
	return false
}

struct PictureOrderCountType0State {
mut:
	prev_msb int
	prev_lsb int
	cycle    int = -1
}

struct PictureOrderCountType0Result {
	decode_poc  int
	display_poc int
	top         int
	bottom      int
	cycle       int
}

fn (mut state PictureOrderCountType0State) advance(pic_lsb int, delta_bottom int,
	max_lsb int, is_idr bool, is_reference bool, has_mmco5 bool) PictureOrderCountType0Result {
	if is_idr {
		state.prev_msb = 0
		state.prev_lsb = 0
		state.cycle++
	}
	mut msb := state.prev_msb
	if pic_lsb < state.prev_lsb && state.prev_lsb - pic_lsb >= max_lsb / 2 {
		msb += max_lsb
	} else if pic_lsb > state.prev_lsb && pic_lsb - state.prev_lsb > max_lsb / 2 {
		msb -= max_lsb
	}
	top := msb + pic_lsb
	bottom := top + delta_bottom
	if has_mmco5 {
		state.cycle++
	}
	if is_reference {
		state.prev_msb = if has_mmco5 { 0 } else { msb }
		state.prev_lsb = if has_mmco5 { top } else { pic_lsb }
	}
	return PictureOrderCountType0Result{
		decode_poc:  top
		display_poc: if has_mmco5 { 0 } else { top }
		top:         top
		bottom:      bottom
		cycle:       state.cycle
	}
}

fn (mut d Decoder) parse_mp4_data(file_path string) ! {
	d.video_data.file = os.open_file(file_path, 'rb')!
	d.video_data.file_open = true
	d.video_data.file.seek(0, .end)!
	mp4_file_size := d.video_data.file.tell()!
	d.video_data.file.seek(0, .start)!
	mut mp4 := minimp4.MP4D_demux_t{}
	mut user_data := CallbackUserData{
		file:        &d.video_data.file
		last_offset: 0
		file_size:   os.file_size(file_path)
	}
	if minimp4.mp4d_open(&mp4, read_callback, &user_data, mp4_file_size) != 1 {
		if user_data.read_error != '' {
			return error(user_data.read_error)
		}
		return error('not a readable MP4 file')
	}
	defer {
		minimp4.mp4d_close(&mp4)
	}
	if mp4.track_count == 0 || isnil(mp4.track) {
		return error('MP4 contains no tracks')
	}
	mut ntrack := u32(0)
	mut found_video_track := false
	mut found_unsupported_video_track := false
	for track_index in u32(0) .. mp4.track_count {
		candidate := unsafe { mp4.track[track_index] }
		if candidate.handler_type != minimp4.mp4d_handler_type_vide {
			continue
		}
		if candidate.object_type_indication == minimp4.mp4_object_type_avc {
			ntrack = track_index
			found_video_track = true
			break
		}
		found_unsupported_video_track = true
	}
	if !found_video_track {
		if found_unsupported_video_track {
			return error('MP4 video codec is unsupported; this player currently supports H.264/AVC')
		}
		return error('MP4 contains no H.264/AVC video track')
	}
	track := unsafe { mp4.track[ntrack] }
	if track.sample_count == 0 {
		return error('H.264 video track contains no samples')
	}
	if track.timescale == 0 {
		return error('H.264 video track has an invalid zero timescale')
	}
	d.video_data.metadata.track_matrix = track.track_matrix
	d.video_data.metadata.rotation_degrees = rotation_from_track_matrix(track.track_matrix)

	// Read SPS
	mut num_bytes_sps := 0
	mut count_sps := 0
	mut sps_array := []h264.SequenceParameterSet{}
	mut data_sps := minimp4.mp4d_read_sps(&mp4, ntrack, count_sps, &num_bytes_sps)
	for !isnil(data_sps) {
		mut nal := h264.NetworkAbstractionLayerHeader{}
		mut nal_header_bs := h264.Bitstream{}
		nal_header_bs.init(unsafe { data_sps.vbytes(1) })
		nal.read_nal_header(mut &nal_header_bs)
		if num_bytes_sps <= 1 {
			return error('H.264 track contains an invalid sequence parameter set')
		}
		mut nal_payload_rbsp_data := unsafe {
			remove_emulation_prevention_bytes(byteptr(data_sps) + 1, num_bytes_sps - 1)
		}
		mut nal_payload_bs := h264.Bitstream{}
		nal_payload_bs.init(nal_payload_rbsp_data)
		mut sps := h264.SequenceParameterSet{}
		sps.read_sps(mut nal_payload_bs)
		if sps.profile_idc !in [u32(66), 77, 100] {
			return error('H.264 profile_idc ${sps.profile_idc} is unsupported; supported profiles are Baseline, Main, and High 8-bit 4:2:0')
		}
		if d.video_data.h264_profile_idc == 0 {
			d.video_data.h264_profile_idc = sps.profile_idc
		} else if d.video_data.h264_profile_idc != sps.profile_idc {
			return error('H.264 track changes profile between sequence parameter sets')
		}
		if sps.bit_depth_luma_minus8 != 0 || sps.bit_depth_chroma_minus8 != 0 {
			return error('H.264 bit depths above 8-bit are not supported')
		}
		if sps.profile_idc >= 100 && sps.chroma_format_idc != 1 {
			return error('H.264 chroma formats other than 4:2:0 are not supported')
		}
		if sps.frame_mbs_only_flag == 0 {
			return error('interlaced H.264 video is not currently supported')
		}
		// Data validation
		// https://stackoverflow.com/questions/6394874/fetching-the-dimensions-of-a-h264video-stream
		width := ((sps.pic_width_in_mbs_minus1 + 1) * 16) - (sps.frame_crop_left_offset * 2) -
			(sps.frame_crop_right_offset * 2)
		height := ((2 - sps.frame_mbs_only_flag) * (sps.pic_height_in_map_units_minus1 + 1) * 16) -
			(sps.frame_crop_top_offset * 2) - (sps.frame_crop_bottom_offset * 2)
		mp4_width := unsafe { track.sampleDescription.video.width }
		mp4_height := unsafe { track.sampleDescription.video.height }
		if mp4_width != width || mp4_height != height {
			eprintln('Warning: MP4 dimensions ${mp4_width}x${mp4_height} differ from H.264 SPS display dimensions ${width}x${height}')
		}
		d.video_data.width_padd = (sps.pic_width_in_mbs_minus1 + 1) * 16
		d.video_data.height_padd = (sps.pic_height_in_map_units_minus1 + 1) * 16
		if sps.vui_parameters_present_flag != 0 {
			d.video_data.metadata.sar_width, d.video_data.metadata.sar_height = sample_aspect_ratio(sps.vui.aspect_ratio_idc,
				sps.vui.sar_width, sps.vui.sar_height)
			d.video_data.metadata.video_full_range = sps.vui.video_full_range_flag != 0
			d.video_data.metadata.colour_description_present =
				d.video_data.metadata.colour_description_present
				|| sps.vui.color_description_present_flag != 0
			d.video_data.metadata.colour_primaries = u8(sps.vui.colour_primaries)
			d.video_data.metadata.transfer_function = u8(sps.vui.transfer_characteristics)
			d.video_data.metadata.matrix_coefficients = u8(sps.vui.matrix_coefficients)
		}
		// x ^ ((x ^ y) & -(x < y)) // max(x, y)
		// d.video_data.num_dpb_slots = d.video_data.num_dpb_slots ^ ((d.video_data.num_dpb_slots ^ (sps.num_ref_frames * 2 + 1)) & -u32(d.video_data.num_dpb_slots < (sps.num_ref_frames * 2 + 1)))
		d.video_data.num_dpb_slots = math.max[u32](d.video_data.num_dpb_slots, sps.num_ref_frames +
			1)
		d.video_data.sps_bytes << unsafe { byteptr(&sps).vbytes(int(sizeof(sps))) }
		sps_array << sps
		d.video_data.sps_count++
		count_sps++

		data_sps = minimp4.mp4d_read_sps(&mp4, ntrack, count_sps, &num_bytes_sps)
	}
	if sps_array.len == 0 {
		return error('H.264 video track contains no sequence parameter set (SPS)')
	}

	// Read PPS
	mut size_pps := 0
	mut count_pps := 0
	mut pps_array := []h264.PictureParameterSet{}
	mut data_pps := minimp4.mp4d_read_pps(&mp4, ntrack, count_pps, &size_pps)

	for !isnil(data_pps) {
		mut nal := h264.NetworkAbstractionLayerHeader{}
		mut nal_header_bs := h264.Bitstream{}
		nal_header_bs.init(unsafe { data_pps.vbytes(1) })
		nal.read_nal_header(mut nal_header_bs)
		if size_pps <= 1 {
			return error('H.264 track contains an invalid picture parameter set')
		}
		pps_payload_rbsp_data := unsafe {
			remove_emulation_prevention_bytes(byteptr(data_pps) + 1, size_pps - 1)
		}
		mut pps_payload_bs := h264.Bitstream{}
		pps_payload_bs.init(pps_payload_rbsp_data)

		mut pps := h264.PictureParameterSet{}
		pps.read_pps(mut pps_payload_bs)
		d.video_data.pps_bytes.ensure_cap(d.video_data.pps_bytes.len + int(sizeof(pps)))
		d.video_data.pps_bytes << unsafe { byteptr(&pps).vbytes(int(sizeof(pps))) }
		pps_array << pps
		d.video_data.pps_count++
		count_pps++

		data_pps = minimp4.mp4d_read_pps(&mp4, ntrack, count_pps, &size_pps)
	}
	if pps_array.len == 0 {
		return error('H.264 video track contains no picture parameter set (PPS)')
	}

	d.video_data.width = unsafe { track.sampleDescription.video.width }
	d.video_data.height = unsafe { track.sampleDescription.video.height }
	d.video_data.metadata.coded_width = d.video_data.width
	d.video_data.metadata.coded_height = d.video_data.height
	d.video_data.metadata.update_display_dimensions()
	println('Video codec: H.264 ${h264_profile_name(d.video_data.h264_profile_idc)} Profile')
	println('Display metadata: coded ${d.video_data.metadata.coded_width}x${d.video_data.metadata.coded_height}, display ${d.video_data.metadata.display_width}x${d.video_data.metadata.display_height}, SAR ${d.video_data.metadata.sar_width}:${d.video_data.metadata.sar_height}, rotation ${d.video_data.metadata.rotation_degrees}°')

	timescale_rcp := 1.0 / f64(track.timescale)
	mut poc_state := PictureOrderCountType0State{}
	mut prev_frame_num := u32(0)
	mut prev_frame_offset := u32(0)

	// Read frames
	mut track_duration := u32(0)
	mut max_frame_size_bytes := u64(0)
	mut input_file_position := u64(0)
	d.video_data.file.seek(0, .start)!

	d.video_data.frame_infos = []DecoderVideoDataFrameInfo{cap: int(track.sample_count)}
	d.video_data.slice_header_bytes.ensure_cap(int(track.sample_count * sizeof(h264.SliceHeader)))
	d.video_data.slice_header_count = track.sample_count

	mut file := d.video_data.file
	mut sample_index := u32(0)
	for {
		if sample_index >= track.sample_count {
			break
		}
		mut frame_bytes_num_to_do := u32(0)
		mut duration := u32(0)
		mut timestamp := u32(0)
		// minimp4 returns timestamp before duration. These were previously passed
		// in reverse order, causing later frames to use their growing timestamp as
		// a duration and making playback progressively slower.
		offset := minimp4.mp4d_frame_offset(&mp4, ntrack, sample_index, &frame_bytes_num_to_do,
			&timestamp, &duration)
		// The upload buffer must fit any slice contained in the complete MP4
		// sample, including samples with leading non-slice NAL units.
		max_frame_size_bytes = math.max[u64](max_frame_size_bytes, frame_bytes_num_to_do)
		track_duration += duration

		mut data_frame := DecoderVideoDataFrameInfo{
			src_offset:      offset
			frame_bytes_num: frame_bytes_num_to_do
		}

		mut src_buffer := []u8{len: int(frame_bytes_num_to_do)}
		mut src_buffer_idx := 0
		if offset - input_file_position > 0 {
			file.seek(offset - input_file_position, .current) or {
				return error('could not seek to MP4 sample ${sample_index}: ${err}')
			}
		}
		if file.eof() {
			return error('MP4 sample ${sample_index} points beyond the end of the file')
		}
		expected_frame_bytes := frame_bytes_num_to_do
		frame_bytes_num_to_do = u32(file.read(mut src_buffer) or {
			return error('could not read MP4 sample ${sample_index}: ${err}')
		})
		if frame_bytes_num_to_do != expected_frame_bytes {
			return error('MP4 sample ${sample_index} is truncated: expected ${expected_frame_bytes} bytes, read ${frame_bytes_num_to_do}')
		}
		input_file_position = offset + frame_bytes_num_to_do
		for frame_bytes_num_to_do > 0 {
			if frame_bytes_num_to_do < 4 {
				return error('MP4 sample ${sample_index} has a truncated H.264 NAL length')
			}
			// mut size := unsafe{ (u32(*&src_buffer[src_buffer_idx+0]) << 24) | (u32(*&src_buffer[src_buffer_idx+1]) << 16) | (u32(*&src_buffer[src_buffer_idx+2]) << 8) | *&src_buffer[src_buffer_idx+3] }
			mut size := unsafe {
				(u32(src_buffer[src_buffer_idx + 0]) << 24) | (u32(src_buffer[src_buffer_idx + 1]) << 16) | (u32(src_buffer[
					src_buffer_idx + 2]) << 8) | src_buffer[src_buffer_idx + 3]
			}
			size += 4
			if size < 4 || frame_bytes_num_to_do < size {
				return error('MP4 sample ${sample_index} has an invalid H.264 NAL size ${size - 4}')
			}

			length_prefixed_data_offset := src_buffer_idx + 4
			length_prefixed_data_size := size - 4
			if length_prefixed_data_size <= 1 {
				return error('MP4 sample ${sample_index} contains an empty H.264 NAL unit')
			}

			mut nal := h264.NetworkAbstractionLayerHeader{}
			mut nal_header_bs := h264.Bitstream{}
			nal_header_bs.init(src_buffer[length_prefixed_data_offset..
				length_prefixed_data_offset + 1])
			nal.read_nal_header(mut nal_header_bs)

			slfrom := length_prefixed_data_offset + 1
			nal_payload_rbsp_data := unsafe {
				remove_emulation_prevention_bytes(byteptr(src_buffer.data) + slfrom,
					int(length_prefixed_data_size - 1))
			}
			mut nal_payload_bs := h264.Bitstream{}
			nal_payload_bs.init(nal_payload_rbsp_data)

			mut is_idr := false
			match nal.type {
				.coded_slice_idr {
					data_frame.frame_type = DecoderFrameType.e_intra
					is_idr = true
				}
				.coded_slice_non_idr {
					data_frame.frame_type = DecoderFrameType.e_predictive
				}
				else {
					frame_bytes_num_to_do -= size
					src_buffer_idx += int(size)
					continue
				}
			}

			/*
																																																																					      * Decode Picture Order Count
																																																																					      * (tig) see ITU-T H.264 (08/2021) pp.113
																																																																					      *
																																																																					      */
			// tig: see Rec. ITU-T H.264 (08/2021) p.66 (7-1)
			mut slice_header := h264.SliceHeader{}
			slice_header.read_slice_header(&nal, pps_array, sps_array, mut nal_payload_bs)
			data_frame.has_mmco5 = slice_has_mmco5(&slice_header, is_idr, nal.idc)
			if slice_header.pic_parameter_set_id >= u32(pps_array.len) {
				return error('MP4 sample ${sample_index} references missing H.264 PPS ${slice_header.pic_parameter_set_id}')
			}
			pps := pps_array[slice_header.pic_parameter_set_id]
			if pps.seq_parameter_set_id >= u32(sps_array.len) {
				return error('MP4 sample ${sample_index} references missing H.264 SPS ${pps.seq_parameter_set_id}')
			}
			sps := sps_array[pps.seq_parameter_set_id]

			max_frame_num := u32(1) << (sps.log2_max_frame_num_minus4 + 4)
			max_pic_order_cnt_lsb := int(u32(1) << (sps.log2_max_pic_order_cnt_lsb_minus4 + 4))
			mut frame_num_offset := u32(0)
			mut tmp_pic_order_cout := u32(0)

			match sps.pic_order_cnt_type {
				0 {
					// The parser already rejected interlaced SPSs, so this is a frame.
					result := poc_state.advance(int(slice_header.pic_order_cnt_lsb),
						int(slice_header.delta_pic_order_cnt_bottom), max_pic_order_cnt_lsb,
						is_idr, nal.idc != .priority_disposable, data_frame.has_mmco5)
					data_frame.top_field_order_cnt = result.top
					data_frame.bottom_field_order_cnt = result.bottom
					data_frame.decode_poc = result.decode_poc
					data_frame.poc = result.display_poc
					data_frame.gop = result.cycle
				}
				// match 0
				2 {
					if is_idr {
						frame_num_offset = 0
					} else if prev_frame_num > slice_header.frame_num {
						frame_num_offset = prev_frame_offset + max_frame_num
					} else {
						frame_num_offset = prev_frame_offset
					}
					prev_frame_offset = if data_frame.has_mmco5 { u32(0) } else { frame_num_offset }
					prev_frame_num = if data_frame.has_mmco5 {
						u32(0)
					} else {
						slice_header.frame_num
					}

					if is_idr {
						tmp_pic_order_cout = 0
					} else if nal.idc == h264.NAL_REF_IDC.priority_disposable {
						tmp_pic_order_cout = 2 * (frame_num_offset + slice_header.frame_num) - 1
					} else {
						tmp_pic_order_cout = 2 * (frame_num_offset + slice_header.frame_num)
					}

					// (tig) Ignore bottom or top fields, as we assume progressive.
					// If it were otherwise - for interleaved - either the top or the bottom
					// field shall be set, depending on whether the current picture is the
					// top or bottom field, as indicated by bottom_field_flag
					data_frame.decode_poc = int(tmp_pic_order_cout)
					data_frame.poc = if data_frame.has_mmco5 { 0 } else { data_frame.decode_poc }
					if tmp_pic_order_cout == 0 || data_frame.has_mmco5 {
						poc_state.cycle++
					}
					data_frame.gop = poc_state.cycle
				}
				// match 2
				else {
					return error('H.264 picture-order-count type ${sps.pic_order_cnt_type} is not supported')
				}
			} // match

			// Accept frame beginning NAL unit
			data_frame.nal_ref_idc = u32(nal.idc)
			data_frame.nal_unit_type = u8(nal.type)
			nal_start_code := h264.NalStartCode{}.value
			data_frame.size = u64(nal_start_code.len) + size - 4
			data_frame.reference_priority = u32(nal.idc)

			data_frame.decode_time_ns = i64(f64(timestamp) * timescale_rcp * 1_000_000_000.0)
			data_frame.display_time_ns = i64(f64(timestamp) * timescale_rcp * 1_000_000_000.0)
			data_frame.duration_ns = math.max[i64](1,
				i64(f64(duration) * timescale_rcp * 1_000_000_000.0))
			d.video_data.slice_header_bytes << unsafe {
				byteptr(&slice_header).vbytes(int(sizeof(slice_header)))
			}

			// for frame_bytes_num_to_do > 0
			break
		}

		// x ^ ((x ^ y) & -(x < y)) // max(x, y)
		// max_frame_size_bytes = max_frame_size_bytes ^ ((max_frame_size_bytes ^ data_frame.size) & -(u64(max_frame_size_bytes < data_frame.size)))
		max_frame_size_bytes = math.max[u64](max_frame_size_bytes, data_frame.size)

		d.video_data.frame_infos << data_frame
		sample_index++
	} // for sample_index < track.sample_count

	// Fills array values with their index 0..len
	d.video_data.frame_display_order = []u64{len: d.video_data.frame_infos.len, init: index}

	// Keep frame_infos in MP4 decode order. Only the display-order index list is
	// sorted; slice_header_bytes and current_frame use the original decode order.
	for i in 1 .. d.video_data.frame_display_order.len {
		index_to_insert := d.video_data.frame_display_order[i]
		frame_to_insert := d.video_data.frame_infos[index_to_insert]
		mut j := i
		for j > 0 {
			previous_index := d.video_data.frame_display_order[j - 1]
			if compare_frame_display_order(&d.video_data.frame_infos[previous_index],
				&frame_to_insert) <= 0 {
				break
			}
			d.video_data.frame_display_order[j] = previous_index
			j--
		}
		d.video_data.frame_display_order[j] = index_to_insert
	}

	for i in 0 .. d.video_data.frame_display_order.len {
		d.video_data.frame_infos[d.video_data.frame_display_order[i]].display_order = i
	}

	d.video_data.max_memory_frame_size_bytes = max_frame_size_bytes
	d.video_data.total_duration = i64(f64(track_duration) * timescale_rcp * 1_000_000_000.0)
}
