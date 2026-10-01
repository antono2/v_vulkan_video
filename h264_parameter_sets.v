module main

import antono2.h264

// The pinned H.264 parser reads past truncated RBSPs as zero bits and has
// fixed-size arrays for POC cycles and HRD entries. Check those boundaries
// before passing untrusted MP4 parameter sets to it.
struct CheckedH264Bits {
	data []u8
mut:
	position int
}

fn (mut bits CheckedH264Bits) read(count int) !u32 {
	if count < 0 || count > 32 || bits.position + count > bits.data.len * 8 {
		return error('truncated H.264 parameter set')
	}
	mut value := u32(0)
	for _ in 0 .. count {
		value = (value << 1) | u32((bits.data[bits.position / 8] >> (7 - bits.position % 8)) & 1)
		bits.position++
	}
	return value
}

fn (mut bits CheckedH264Bits) ue() !u32 {
	mut zeros := 0
	for bits.read(1)! == 0 {
		zeros++
		if zeros > 31 {
			return error('invalid H.264 Exp-Golomb value')
		}
	}
	return (u32(1) << zeros) - 1 + bits.read(zeros)!
}

fn (mut bits CheckedH264Bits) se() !int {
	value := bits.ue()!
	if value > 0x7fffffff {
		return error('H.264 signed Exp-Golomb value is too large')
	}
	return if value & 1 != 0 { int((value + 1) / 2) } else { -int(value / 2) }
}

fn (mut bits CheckedH264Bits) scaling_list(size int) ! {
	mut last := 8
	mut next := 8
	for _ in 0 .. size {
		if next != 0 {
			next = (last + bits.se()! + 256) % 256
		}
		last = if next == 0 { last } else { next }
	}
}

fn (mut bits CheckedH264Bits) scaling_list_values(size int) !([]u8, bool) {
	mut values := []u8{len: size}
	mut last := 8
	mut next := 8
	mut use_default := false
	for i in 0 .. size {
		if next != 0 {
			next = (last + bits.se()! + 256) % 256
			if i == 0 && next == 0 {
				use_default = true
			}
		}
		values[i] = u8(if next == 0 { last } else { next })
		last = int(values[i])
	}
	return values, use_default
}

// The pinned parser records scaling-list presence but its fixed-array slice
// writes do not persist the list values. Re-read the validated syntax into the
// actual SPS arrays used to build Vulkan session parameters.
fn populate_sps_scaling_lists(payload []u8, mut sps h264.SequenceParameterSet) ! {
	mut bits := CheckedH264Bits{
		data: payload
	}
	profile := bits.read(8)!
	_ = bits.read(16)!
	_ = bits.ue()!
	if profile != 100 {
		return
	}
	chroma := bits.ue()!
	if chroma == 3 {
		_ = bits.read(1)!
	}
	_ = bits.ue()!
	_ = bits.ue()!
	_ = bits.read(1)!
	if bits.read(1)! == 0 {
		return
	}
	for i in 0 .. 8 {
		if bits.read(1)! == 0 {
			continue
		}
		values, use_default := bits.scaling_list_values(if i < 6 { 16 } else { 64 })!
		if i < 6 {
			for j, value in values {
				sps.scaling_list_4x4[i][j] = int(value)
			}
			sps.use_default_scaling_matrix_4x4_flag[i] = if use_default { u32(1) } else { u32(0) }
		} else {
			for j, value in values {
				sps.scaling_list_8x8[i - 6][j] = int(value)
			}
			sps.use_default_scaling_matrix_8x8_flag[i - 6] = if use_default {
				u32(1)
			} else {
				u32(0)
			}
		}
	}
}

fn populate_pps_scaling_lists(payload []u8, mut pps h264.PictureParameterSet) ! {
	mut bits := CheckedH264Bits{
		data: payload
	}
	_ = bits.ue()!
	_ = bits.ue()!
	_ = bits.read(2)!
	_ = bits.ue()! // slice groups: preflight rejected nonzero values
	_ = bits.ue()!
	_ = bits.ue()!
	_ = bits.read(3)!
	_ = bits.se()!
	_ = bits.se()!
	_ = bits.se()!
	_ = bits.read(3)!
	if !bits.has_more_rbsp_data()! {
		return
	}
	transform_8x8 := bits.read(1)!
	if bits.read(1)! == 0 {
		return
	}
	for i in 0 .. 6 + int(transform_8x8) * 2 {
		if bits.read(1)! == 0 {
			continue
		}
		values, use_default := bits.scaling_list_values(if i < 6 { 16 } else { 64 })!
		if i < 6 {
			for j, value in values {
				pps.scaling_list_4x4[i][j] = int(value)
			}
			pps.use_default_scaling_matrix_4x4_flag[i] = if use_default { u32(1) } else { u32(0) }
		} else {
			for j, value in values {
				pps.scaling_list_8x8[i - 6][j] = int(value)
			}
			pps.use_default_scaling_matrix_8x8_flag[i - 6] = if use_default {
				u32(1)
			} else {
				u32(0)
			}
		}
	}
}

fn (mut bits CheckedH264Bits) hrd() ! {
	count := bits.ue()!
	if count > 32 {
		return error('H.264 HRD has more than 32 entries')
	}
	_ = bits.read(4)!
	_ = bits.read(4)!
	for _ in 0 .. int(count) {
		_ = bits.ue()!
		_ = bits.ue()!
		_ = bits.read(1)!
	}
	_ = bits.read(20)!
}

fn (mut bits CheckedH264Bits) vui() ! {
	if bits.read(1)! != 0 {
		if bits.read(8)! == 255 {
			_ = bits.read(32)!
		}
	}
	if bits.read(1)! != 0 {
		_ = bits.read(1)!
	}
	if bits.read(1)! != 0 {
		_ = bits.read(4)!
		if bits.read(1)! != 0 {
			_ = bits.read(24)!
		}
	}
	if bits.read(1)! != 0 {
		_ = bits.ue()!
		_ = bits.ue()!
	}
	if bits.read(1)! != 0 {
		_ = bits.read(32)!
		_ = bits.read(32)!
		_ = bits.read(1)!
	}
	mut has_hrd := false
	if bits.read(1)! != 0 {
		bits.hrd()!
		has_hrd = true
	}
	if bits.read(1)! != 0 {
		bits.hrd()!
		has_hrd = true
	}
	if has_hrd {
		_ = bits.read(1)!
	}
	_ = bits.read(1)!
	if bits.read(1)! != 0 {
		_ = bits.read(1)!
		for _ in 0 .. 6 {
			_ = bits.ue()!
		}
	}
}

fn validate_sps_rbsp(payload []u8) ! {
	mut bits := CheckedH264Bits{
		data: payload
	}
	profile := bits.read(8)!
	if profile !in [u32(66), 77, 100] {
		return error('H.264 profile_idc ${profile} is unsupported; supported profiles are Baseline, Main, and High 8-bit 4:2:0')
	}
	_ = bits.read(8)! // constraint flags and reserved bits
	_ = bits.read(8)! // level_idc
	sps_id := bits.ue()!
	if sps_id > 31 {
		return error('H.264 SPS id exceeds 31')
	}
	if profile == 100 {
		chroma := bits.ue()!
		if chroma == 3 {
			_ = bits.read(1)!
		}
		_ = bits.ue()!
		_ = bits.ue()!
		_ = bits.read(1)!
		if bits.read(1)! != 0 {
			for i in 0 .. 8 {
				if bits.read(1)! != 0 {
					bits.scaling_list(if i < 6 { 16 } else { 64 })!
				}
			}
		}
	}
	if bits.ue()! > 12 {
		return error('invalid H.264 frame-number bit width')
	}
	poc_type := bits.ue()!
	if poc_type == 0 {
		if bits.ue()! > 12 {
			return error('invalid H.264 picture-order-count bit width')
		}
	} else if poc_type == 1 {
		_ = bits.read(1)!
		_ = bits.se()!
		_ = bits.se()!
		cycle_count := bits.ue()!
		if cycle_count > 256 {
			return error('H.264 POC cycle has more than 256 entries')
		}
		for _ in 0 .. int(cycle_count) {
			_ = bits.se()!
		}
	} else if poc_type != 2 {
		return error('invalid H.264 picture-order-count type ${poc_type}')
	}
	if bits.ue()! >= slot_count {
		return error('H.264 reference count exceeds decoder slots')
	}
	_ = bits.read(1)!
	_ = bits.ue()! // width
	_ = bits.ue()! // height
	if bits.read(1)! == 0 {
		_ = bits.read(1)!
	}
	_ = bits.read(1)!
	if bits.read(1)! != 0 {
		for _ in 0 .. 4 {
			_ = bits.ue()!
		}
	}
	if bits.read(1)! != 0 {
		bits.vui()!
	}
	if bits.read(1)! != 1 {
		return error('H.264 SPS has no RBSP stop bit')
	}
}

fn validate_pps_rbsp(payload []u8) ! {
	mut bits := CheckedH264Bits{
		data: payload
	}
	pps_id := bits.ue()!
	sps_id := bits.ue()!
	if pps_id > 255 || sps_id > 31 {
		return error('H.264 PPS or SPS id is out of range')
	}
	_ = bits.read(2)!
	if bits.ue()! != 0 {
		return error('H.264 slice groups are not supported')
	}
	if bits.ue()! >= 64 || bits.ue()! >= 64 {
		return error('H.264 reference-list count exceeds 64')
	}
	_ = bits.read(1)! // weighted prediction
	_ = bits.read(2)! // weighted biprediction
	_ = bits.se()! // initial QP
	_ = bits.se()! // initial QS
	_ = bits.se()! // chroma QP offset
	_ = bits.read(3)! // deblocking, intra prediction, redundant count
	if bits.has_more_rbsp_data()! {
		transform_8x8 := bits.read(1)!
		if bits.read(1)! != 0 {
			for i in 0 .. 6 + int(transform_8x8) * 2 {
				if bits.read(1)! != 0 {
					bits.scaling_list(if i < 6 { 16 } else { 64 })!
				}
			}
		}
		_ = bits.se()!
	}
	if bits.read(1)! != 1 {
		return error('H.264 PPS has no RBSP stop bit')
	}
}

fn (bits CheckedH264Bits) has_more_rbsp_data() !bool {
	if bits.position >= bits.data.len * 8 {
		return error('truncated H.264 parameter set')
	}
	mut lookahead := bits
	if lookahead.read(1)! == 0 {
		return true
	}
	for lookahead.position < lookahead.data.len * 8 {
		if lookahead.read(1)! != 0 {
			return true
		}
	}
	return false
}
