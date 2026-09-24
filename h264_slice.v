module main

import antono2.h264

// The pinned h264 module omits the final weighted reference entry and ignores
// slice-level reference-count overrides. Both shift the following MMCO syntax.
fn read_weight_table(mut sh h264.SliceHeader, sps &h264.SequenceParameterSet,
	pps &h264.PictureParameterSet, mut bits h264.Bitstream) ! {
	sh.pwt.luma_log2_weight_denom = bits.ue()
	if sps.chroma_format_idc != 0 {
		sh.pwt.chroma_log2_weight_denom = bits.ue()
	}
	l0_count := if sh.num_ref_idx_active_override_flag != 0 {
		sh.num_ref_idx_l0_active_minus1 + 1
	} else {
		pps.num_ref_idx_l0_active_minus1 + 1
	}
	if l0_count > 64 {
		return error('H.264 weighted reference count exceeds 64')
	}
	for i in 0 .. l0_count {
		sh.pwt.luma_weight_l0_flag[i] = bits.u1()
		if sh.pwt.luma_weight_l0_flag[i] != 0 {
			sh.pwt.luma_weight_l0[i] = bits.se()
			sh.pwt.luma_offset_l0[i] = bits.se()
		}
		if sps.chroma_format_idc != 0 {
			sh.pwt.chroma_weight_l0_flag[i] = bits.u1()
			if sh.pwt.chroma_weight_l0_flag[i] != 0 {
				for j in 0 .. 2 {
					sh.pwt.chroma_weight_l0[i][j] = bits.se()
					sh.pwt.chroma_offset_l0[i][j] = bits.se()
				}
			}
		}
	}
	if sh.is_slice_type(.b) {
		l1_count := if sh.num_ref_idx_active_override_flag != 0 {
			sh.num_ref_idx_l1_active_minus1 + 1
		} else {
			pps.num_ref_idx_l1_active_minus1 + 1
		}
		if l1_count > 64 {
			return error('H.264 weighted reference count exceeds 64')
		}
		for i in 0 .. l1_count {
			sh.pwt.luma_weight_l1_flag[i] = bits.u1()
			if sh.pwt.luma_weight_l1_flag[i] != 0 {
				sh.pwt.luma_weight_l1[i] = bits.se()
				sh.pwt.luma_offset_l1[i] = bits.se()
			}
			if sps.chroma_format_idc != 0 {
				sh.pwt.chroma_weight_l1_flag[i] = bits.u1()
				if sh.pwt.chroma_weight_l1_flag[i] != 0 {
					for j in 0 .. 2 {
						sh.pwt.chroma_weight_l1[i][j] = bits.se()
						sh.pwt.chroma_offset_l1[i][j] = bits.se()
					}
				}
			}
		}
	}
}

fn read_reference_marking(mut sh h264.SliceHeader,
	nal &h264.NetworkAbstractionLayerHeader, mut bits h264.Bitstream) ! {
	if nal.type == .coded_slice_idr {
		sh.drpm.no_output_of_prior_pics_flag = bits.u1()
		sh.drpm.long_term_reference_flag = bits.u1()
		return
	}
	sh.drpm.adaptive_ref_pic_marking_mode_flag = bits.u1()
	if sh.drpm.adaptive_ref_pic_marking_mode_flag == 0 {
		return
	}
	for i in 0 .. sh.drpm.memory_management_control_operation.len {
		if bits.eof() {
			return error('truncated H.264 reference marking')
		}
		op := bits.ue()
		if op > 6 {
			return error('invalid H.264 memory-management operation ${op}')
		}
		sh.drpm.memory_management_control_operation[i] = op
		if op in [u32(1), 3] {
			sh.drpm.difference_of_pic_nums_minus1[i] = bits.ue()
		}
		if op == 2 {
			sh.drpm.long_term_pic_num[i] = bits.ue()
		}
		if op in [u32(3), 6] {
			sh.drpm.long_term_frame_idx[i] = bits.ue()
		}
		if op == 4 {
			sh.drpm.max_long_term_frame_idx_plus1[i] = bits.ue()
		}
		if op == 0 {
			return
		}
	}
	return error('H.264 reference marking has more than 64 operations')
}

fn read_slice_header_checked(nal &h264.NetworkAbstractionLayerHeader,
	pps_array []h264.PictureParameterSet, sps_array []h264.SequenceParameterSet,
	mut bits h264.Bitstream) !h264.SliceHeader {
	mut sh := h264.SliceHeader{}
	sh.first_mb_in_slice = bits.ue()
	sh.slice_type = bits.ue()
	sh.pic_parameter_set_id = bits.ue()
	if sh.pic_parameter_set_id >= u32(pps_array.len) {
		return error('H.264 slice references missing PPS ${sh.pic_parameter_set_id}')
	}
	pps := pps_array[sh.pic_parameter_set_id]
	if pps.seq_parameter_set_id >= u32(sps_array.len) {
		return error('H.264 PPS ${sh.pic_parameter_set_id} references missing SPS ${pps.seq_parameter_set_id}')
	}
	sps := sps_array[pps.seq_parameter_set_id]
	sh.frame_num = bits.u(sps.log2_max_frame_num_minus4 + 4)
	if sps.frame_mbs_only_flag == 0 {
		sh.field_pic_flag = bits.u1()
		if sh.field_pic_flag != 0 {
			sh.bottom_field_flag = bits.u1()
		}
	}
	if nal.type == .coded_slice_idr {
		sh.idr_pic_id = bits.ue()
	}
	if sps.pic_order_cnt_type == 0 {
		sh.pic_order_cnt_lsb = bits.u(sps.log2_max_pic_order_cnt_lsb_minus4 + 4)
		if pps.pic_order_present_flag != 0 && sh.field_pic_flag == 0 {
			sh.delta_pic_order_cnt_bottom = bits.se()
		}
	} else if sps.pic_order_cnt_type == 1 && sps.delta_pic_order_always_zero_flag == 0 {
		sh.delta_pic_order_cnt[0] = bits.se()
		if pps.pic_order_present_flag != 0 && sh.field_pic_flag == 0 {
			sh.delta_pic_order_cnt[1] = bits.se()
		}
	}
	if pps.redundant_pic_cnt_present_flag != 0 {
		sh.redundant_pic_cnt = bits.ue()
	}
	if sh.is_slice_type(.b) {
		sh.direct_spatial_mv_pred_flag = bits.u1()
	}
	if sh.is_slice_type(.p) || sh.is_slice_type(.sp) || sh.is_slice_type(.b) {
		sh.num_ref_idx_active_override_flag = bits.u1()
		if sh.num_ref_idx_active_override_flag != 0 {
			sh.num_ref_idx_l0_active_minus1 = bits.ue()
			if sh.is_slice_type(.b) {
				sh.num_ref_idx_l1_active_minus1 = bits.ue()
			}
		}
	}
	sh.read_ref_pic_list_reordering(mut bits)
	if (pps.weighted_pred_flag != 0 && (sh.is_slice_type(.p) || sh.is_slice_type(.sp)))
		|| (pps.weighted_bipred_idc == 1 && sh.is_slice_type(.b)) {
		read_weight_table(mut sh, &sps, &pps, mut bits)!
	}
	if nal.idc != .priority_disposable {
		read_reference_marking(mut sh, nal, mut bits)!
	}
	if pps.entropy_coding_mode_flag != 0 && !sh.is_slice_type(.i) && !sh.is_slice_type(.si) {
		sh.cabac_init_idc = bits.ue()
	}
	sh.slice_qp_delta = bits.se()
	if sh.is_slice_type(.sp) || sh.is_slice_type(.si) {
		if sh.is_slice_type(.sp) {
			sh.sp_for_switch_flag = bits.u1()
		}
		sh.slice_qs_delta = bits.se()
	}
	if pps.deblocking_filter_control_present_flag != 0 {
		sh.disable_deblocking_filter_idc = bits.ue()
		if sh.disable_deblocking_filter_idc != 1 {
			sh.slice_alpha_c0_offset_div2 = bits.se()
			sh.slice_beta_offset_div2 = bits.se()
		}
	}
	if pps.num_slice_groups_minus1 > 0 && pps.slice_group_map_type >= 3
		&& pps.slice_group_map_type <= 5 {
		return error('H.264 slice groups are not supported')
	}
	return sh
}
