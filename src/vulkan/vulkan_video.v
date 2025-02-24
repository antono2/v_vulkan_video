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

pub fn make_video_std_version(major u32, minor u32, patch u32) u32 {
	return (major << 22) | (minor << 12) | patch
}

pub const std_video_h264_cpb_cnt_list_size = 32
pub const std_video_h264_scaling_list_4x4_num_lists = 6
pub const std_video_h264_scaling_list_4x4_num_elements = 16
pub const std_video_h264_scaling_list_8x8_num_lists = 6
pub const std_video_h264_scaling_list_8x8_num_elements = 64
pub const std_video_h264_max_num_list_ref = 32
pub const std_video_h264_max_chroma_planes = 2
pub const std_video_h264_no_reference_picture = 0xff

pub enum StdVideoH264ChromaFormatIdc {
	monochrome = 0
	_420       = 1
	_422       = 2
	_444       = 3
	invalid    = int(0x7FFFFFFF)
	max_enum   = max_int
}

pub enum StdVideoH264ProfileIdc {
	baseline           = 66
	main               = 77
	high               = 100
	high444_predictive = 244
	invalid            = int(0x7FFFFFFF)
	max_enum           = max_int
}

pub enum StdVideoH264LevelIdc {
	_1_0     = 0
	_1_1     = 1
	_1_2     = 2
	_1_3     = 3
	_2_0     = 4
	_2_1     = 5
	_2_2     = 6
	_3_0     = 7
	_3_1     = 8
	_3_2     = 9
	_4_0     = 10
	_4_1     = 11
	_4_2     = 12
	_5_0     = 13
	_5_1     = 14
	_5_2     = 15
	_6_0     = 16
	_6_1     = 17
	_6_2     = 18
	invalid  = int(0x7FFFFFFF)
	max_enum = max_int
}

pub enum StdVideoH264PocType {
	_0       = 0
	_1       = 1
	_2       = 2
	invalid  = int(0x7FFFFFFF)
	max_enum = max_int
}

pub enum StdVideoH264AspectRatioIdc {
	unspecified  = 0
	square       = 1
	_12_11       = 2
	_10_11       = 3
	_16_11       = 4
	_40_33       = 5
	_24_11       = 6
	_20_11       = 7
	_32_11       = 8
	_80_33       = 9
	_18_11       = 10
	_15_11       = 11
	_64_33       = 12
	_160_99      = 13
	_4_3         = 14
	_3_2         = 15
	_2_1         = 16
	extended_sar = 255
	invalid      = int(0x7FFFFFFF)
	max_enum     = max_int
}

pub enum StdVideoH264WeightedBipredIdc {
	default  = 0
	explicit = 1
	implicit = 2
	invalid  = int(0x7FFFFFFF)
	max_enum = max_int
}

pub enum StdVideoH264ModificationOfPicNumsIdc {
	short_term_subtract = 0
	short_term_add      = 1
	long_term           = 2
	end                 = 3
	invalid             = int(0x7FFFFFFF)
	max_enum            = max_int
}

pub enum StdVideoH264MemMgmtControlOp {
	end                       = 0
	unmark_short_term         = 1
	unmark_long_term          = 2
	mark_long_term            = 3
	set_max_long_term_index   = 4
	unmark_all                = 5
	mark_current_as_long_term = 6
	invalid                   = int(0x7FFFFFFF)
	max_enum                  = max_int
}

pub enum StdVideoH264CabacInitIdc {
	_0       = 0
	_1       = 1
	_2       = 2
	invalid  = int(0x7FFFFFFF)
	max_enum = max_int
}

pub enum StdVideoH264DisableDeblockingFilterIdc {
	disabled = 0
	enabled  = 1
	partial  = 2
	invalid  = int(0x7FFFFFFF)
	max_enum = max_int
}

pub enum StdVideoH264SliceType {
	p        = 0
	b        = 1
	i        = 2
	invalid  = int(0x7FFFFFFF)
	max_enum = max_int
}

pub enum StdVideoH264PictureType {
	p        = 0
	b        = 1
	i        = 2
	idr      = 5
	invalid  = int(0x7FFFFFFF)
	max_enum = max_int
}

pub enum StdVideoH264NonVclNaluType {
	sps             = 0
	pps             = 1
	aud             = 2
	prefix          = 3
	end_of_sequence = 4
	end_of_stream   = 5
	precoded        = 6
	invalid         = int(0x7FFFFFFF)
	max_enum        = max_int
}

pub type StdVideoH264SpsVuiFlags = C.StdVideoH264SpsVuiFlags

@[typedef]
pub struct C.StdVideoH264SpsVuiFlags {
pub mut:
	aspect_ratio_info_present_flag  u32
	overscan_info_present_flag      u32
	overscan_appropriate_flag       u32
	video_signal_type_present_flag  u32
	video_full_range_flag           u32
	color_description_present_flag  u32
	chroma_loc_info_present_flag    u32
	timing_info_present_flag        u32
	fixed_frame_rate_flag           u32
	bitstream_restriction_flag      u32
	nal_hrd_parameters_present_flag u32
	vcl_hrd_parameters_present_flag u32
}

pub type StdVideoH264HrdParameters = C.StdVideoH264HrdParameters

@[typedef]
pub struct C.StdVideoH264HrdParameters {
pub mut:
	cpb_cnt_minus1                          u8
	bit_rate_scale                          u8
	cpb_size_scale                          u8
	reserved1                               u8
	bit_rate_value_minus1                   [std_video_h264_cpb_cnt_list_size]u32
	cpb_size_value_minus1                   [std_video_h264_cpb_cnt_list_size]u32
	cbr_flag                                [std_video_h264_cpb_cnt_list_size]u8
	initial_cpb_removal_delay_length_minus1 u32
	cpb_removal_delay_length_minus1         u32
	dpb_output_delay_length_minus1          u32
	time_offset_length                      u32
}

pub type StdVideoH264SequenceParameterSetVui = C.StdVideoH264SequenceParameterSetVui

@[typedef]
pub struct C.StdVideoH264SequenceParameterSetVui {
pub mut:
	flags                               StdVideoH264SpsVuiFlags
	aspect_ratio_idc                    StdVideoH264AspectRatioIdc
	sar_width                           u16
	sar_height                          u16
	video_format                        u8
	colour_primaries                    u8
	transfer_characteristics            u8
	matrix_coefficients                 u8
	num_units_in_tick                   u32
	time_scale                          u32
	max_num_reorder_frames              u8
	max_dec_frame_buffering             u8
	chroma_sample_loc_type_top_field    u8
	chroma_sample_loc_type_bottom_field u8
	reserved1                           u32
	pHrdParameters                      &StdVideoH264HrdParameters
}

pub type StdVideoH264SpsFlags = C.StdVideoH264SpsFlags

@[typedef]
pub struct C.StdVideoH264SpsFlags {
pub mut:
	constraint_set0_flag                 u32
	constraint_set1_flag                 u32
	constraint_set2_flag                 u32
	constraint_set3_flag                 u32
	constraint_set4_flag                 u32
	constraint_set5_flag                 u32
	direct_8x8_inference_flag            u32
	mb_adaptive_frame_field_flag         u32
	frame_mbs_only_flag                  u32
	delta_pic_order_always_zero_flag     u32
	separate_colour_plane_flag           u32
	gaps_in_frame_num_value_allowed_flag u32
	qpprime_y_zero_transform_bypass_flag u32
	frame_cropping_flag                  u32
	seq_scaling_matrix_present_flag      u32
	vui_parameters_present_flag          u32
}

pub type StdVideoH264ScalingLists = C.StdVideoH264ScalingLists

@[typedef]
pub struct C.StdVideoH264ScalingLists {
pub mut:
	scaling_list_present_mask       u16
	use_default_scaling_matrix_mask u16
	ScalingList4x4                  [std_video_h264_scaling_list_4x4_num_elements][std_video_h264_scaling_list_4x4_num_lists]u8
	ScalingList8x8                  [std_video_h264_scaling_list_8x8_num_elements][std_video_h264_scaling_list_8x8_num_lists]u8
}

pub type StdVideoH264SequenceParameterSet = C.StdVideoH264SequenceParameterSet

@[typedef]
pub struct C.StdVideoH264SequenceParameterSet {
pub mut:
	flags                                 StdVideoH264SpsFlags
	profile_idc                           StdVideoH264ProfileIdc
	level_idc                             StdVideoH264LevelIdc
	chroma_format_idc                     StdVideoH264ChromaFormatIdc
	seq_parameter_set_id                  u8
	bit_depth_luma_minus8                 u8
	bit_depth_chroma_minus8               u8
	log2_max_frame_num_minus4             u8
	pic_order_cnt_type                    StdVideoH264PocType
	offset_for_non_ref_pic                i32
	offset_for_top_to_bottom_field        i32
	log2_max_pic_order_cnt_lsb_minus4     u8
	num_ref_frames_in_pic_order_cnt_cycle u8
	max_num_ref_frames                    u8
	reserved1                             u8
	pic_width_in_mbs_minus1               u32
	pic_height_in_map_units_minus1        u32
	frame_crop_left_offset                u32
	frame_crop_right_offset               u32
	frame_crop_top_offset                 u32
	frame_crop_bottom_offset              u32
	reserved2                             u32
	pOffsetForRefFrame                    &i32
	pScalingLists                         &StdVideoH264ScalingLists
	pSequenceParameterSetVui              &StdVideoH264SequenceParameterSetVui
}

pub type StdVideoH264PpsFlags = C.StdVideoH264PpsFlags

@[typedef]
pub struct C.StdVideoH264PpsFlags {
pub mut:
	transform_8x8_mode_flag                      u32
	redundant_pic_cnt_present_flag               u32
	constrained_intra_pred_flag                  u32
	deblocking_filter_control_present_flag       u32
	weighted_pred_flag                           u32
	bottom_field_pic_order_in_frame_present_flag u32
	entropy_coding_mode_flag                     u32
	pic_scaling_matrix_present_flag              u32
}

pub type StdVideoH264PictureParameterSet = C.StdVideoH264PictureParameterSet

@[typedef]
pub struct C.StdVideoH264PictureParameterSet {
pub mut:
	flags                                StdVideoH264PpsFlags
	seq_parameter_set_id                 u8
	pic_parameter_set_id                 u8
	num_ref_idx_l0_default_active_minus1 u8
	num_ref_idx_l1_default_active_minus1 u8
	weighted_bipred_idc                  StdVideoH264WeightedBipredIdc
	pic_init_qp_minus26                  i8
	pic_init_qs_minus26                  i8
	chroma_qp_index_offset               i8
	second_chroma_qp_index_offset        i8
	pScalingLists                        &StdVideoH264ScalingLists
}

pub const std_vulkan_video_codec_h264_decode_api_version_1_0_0 = make_video_std_version(1,
	0, 0)

pub const std_video_decode_h264_field_order_count_list_size = 2
pub const std_vulkan_video_codec_h264_decode_spec_version = std_vulkan_video_codec_h264_decode_api_version_1_0_0
pub const std_vulkan_video_codec_h264_decode_extension_name = 'VK_STD_vulkan_video_codec_h264_decode'

pub enum StdVideoDecodeH264FieldOrderCount {
	top      = 0
	bottom   = 1
	invalid  = int(0x7FFFFFFF)
	max_enum = max_int
}

pub type StdVideoDecodeH264PictureInfoFlags = C.StdVideoDecodeH264PictureInfoFlags

@[typedef]
pub struct C.StdVideoDecodeH264PictureInfoFlags {
pub mut:
	field_pic_flag           u32
	is_intra                 u32
	IdrPicFlag               u32
	bottom_field_flag        u32
	is_reference             u32
	complementary_field_pair u32
}

pub type StdVideoDecodeH264PictureInfo = C.StdVideoDecodeH264PictureInfo

@[typedef]
pub struct C.StdVideoDecodeH264PictureInfo {
pub mut:
	flags                StdVideoDecodeH264PictureInfoFlags
	seq_parameter_set_id u8
	pic_parameter_set_id u8
	reserved1            u8
	reserved2            u8
	frame_num            u16
	idr_pic_id           u16
	PicOrderCnt          [std_video_decode_h264_field_order_count_list_size]i32
}

pub type StdVideoDecodeH264ReferenceInfoFlags = C.StdVideoDecodeH264ReferenceInfoFlags

@[typedef]
pub struct C.StdVideoDecodeH264ReferenceInfoFlags {
pub mut:
	top_field_flag               u32
	bottom_field_flag            u32
	used_for_long_term_reference u32
	is_non_existing              u32
}

pub type StdVideoDecodeH264ReferenceInfo = C.StdVideoDecodeH264ReferenceInfo

@[typedef]
pub struct C.StdVideoDecodeH264ReferenceInfo {
pub mut:
	flags       StdVideoDecodeH264ReferenceInfoFlags
	FrameNum    u16
	reserved    u16
	PicOrderCnt [std_video_decode_h264_field_order_count_list_size]i32
}

pub const std_vulkan_video_codec_h264_encode_api_version_1_0_0 = make_video_std_version(1,
	0, 0)

pub const std_vulkan_video_codec_h264_encode_spec_version = std_vulkan_video_codec_h264_encode_api_version_1_0_0
pub const std_vulkan_video_codec_h264_encode_extension_name = 'VK_STD_vulkan_video_codec_h264_encode'

pub type StdVideoEncodeH264WeightTableFlags = C.StdVideoEncodeH264WeightTableFlags

@[typedef]
pub struct C.StdVideoEncodeH264WeightTableFlags {
pub mut:
	luma_weight_l0_flag   u32
	chroma_weight_l0_flag u32
	luma_weight_l1_flag   u32
	chroma_weight_l1_flag u32
}

pub type StdVideoEncodeH264WeightTable = C.StdVideoEncodeH264WeightTable

@[typedef]
pub struct C.StdVideoEncodeH264WeightTable {
pub mut:
	flags                    StdVideoEncodeH264WeightTableFlags
	luma_log2_weight_denom   u8
	chroma_log2_weight_denom u8
	luma_weight_l0           [std_video_h264_max_num_list_ref]i8
	luma_offset_l0           [std_video_h264_max_num_list_ref]i8
	chroma_weight_l0         [std_video_h264_max_chroma_planes][std_video_h264_max_num_list_ref]i8
	chroma_offset_l0         [std_video_h264_max_chroma_planes][std_video_h264_max_num_list_ref]i8
	luma_weight_l1           [std_video_h264_max_num_list_ref]i8
	luma_offset_l1           [std_video_h264_max_num_list_ref]i8
	chroma_weight_l1         [std_video_h264_max_chroma_planes][std_video_h264_max_num_list_ref]i8
	chroma_offset_l1         [std_video_h264_max_chroma_planes][std_video_h264_max_num_list_ref]i8
}

pub type StdVideoEncodeH264SliceHeaderFlags = C.StdVideoEncodeH264SliceHeaderFlags

@[typedef]
pub struct C.StdVideoEncodeH264SliceHeaderFlags {
pub mut:
	direct_spatial_mv_pred_flag      u32
	num_ref_idx_active_override_flag u32
	reserved                         u32
}

pub type StdVideoEncodeH264PictureInfoFlags = C.StdVideoEncodeH264PictureInfoFlags

@[typedef]
pub struct C.StdVideoEncodeH264PictureInfoFlags {
pub mut:
	IdrPicFlag                         u32
	is_reference                       u32
	no_output_of_prior_pics_flag       u32
	long_term_reference_flag           u32
	adaptive_ref_pic_marking_mode_flag u32
	reserved                           u32
}

pub type StdVideoEncodeH264ReferenceInfoFlags = C.StdVideoEncodeH264ReferenceInfoFlags

@[typedef]
pub struct C.StdVideoEncodeH264ReferenceInfoFlags {
pub mut:
	used_for_long_term_reference u32
	reserved                     u32
}

pub type StdVideoEncodeH264ReferenceListsInfoFlags = C.StdVideoEncodeH264ReferenceListsInfoFlags

@[typedef]
pub struct C.StdVideoEncodeH264ReferenceListsInfoFlags {
pub mut:
	ref_pic_list_modification_flag_l0 u32
	ref_pic_list_modification_flag_l1 u32
	reserved                          u32
}

pub type StdVideoEncodeH264RefListModEntry = C.StdVideoEncodeH264RefListModEntry

@[typedef]
pub struct C.StdVideoEncodeH264RefListModEntry {
pub mut:
	modification_of_pic_nums_idc StdVideoH264ModificationOfPicNumsIdc
	abs_diff_pic_num_minus1      u16
	long_term_pic_num            u16
}

pub type StdVideoEncodeH264RefPicMarkingEntry = C.StdVideoEncodeH264RefPicMarkingEntry

@[typedef]
pub struct C.StdVideoEncodeH264RefPicMarkingEntry {
pub mut:
	memory_management_control_operation StdVideoH264MemMgmtControlOp
	difference_of_pic_nums_minus1       u16
	long_term_pic_num                   u16
	long_term_frame_idx                 u16
	max_long_term_frame_idx_plus1       u16
}

pub type StdVideoEncodeH264ReferenceListsInfo = C.StdVideoEncodeH264ReferenceListsInfo

@[typedef]
pub struct C.StdVideoEncodeH264ReferenceListsInfo {
pub mut:
	flags                        StdVideoEncodeH264ReferenceListsInfoFlags
	num_ref_idx_l0_active_minus1 u8
	num_ref_idx_l1_active_minus1 u8
	RefPicList0                  [std_video_h264_max_num_list_ref]u8
	RefPicList1                  [std_video_h264_max_num_list_ref]u8
	refList0ModOpCount           u8
	refList1ModOpCount           u8
	refPicMarkingOpCount         u8
	reserved1                    [7]u8
	pRefList0ModOperations       &StdVideoEncodeH264RefListModEntry
	pRefList1ModOperations       &StdVideoEncodeH264RefListModEntry
	pRefPicMarkingOperations     &StdVideoEncodeH264RefPicMarkingEntry
}

pub type StdVideoEncodeH264PictureInfo = C.StdVideoEncodeH264PictureInfo

@[typedef]
pub struct C.StdVideoEncodeH264PictureInfo {
pub mut:
	flags                StdVideoEncodeH264PictureInfoFlags
	seq_parameter_set_id u8
	pic_parameter_set_id u8
	idr_pic_id           u16
	primary_pic_type     StdVideoH264PictureType
	frame_num            u32
	PicOrderCnt          i32
	temporal_id          u8
	reserved1            [3]u8
	pRefLists            &StdVideoEncodeH264ReferenceListsInfo
}

pub type StdVideoEncodeH264ReferenceInfo = C.StdVideoEncodeH264ReferenceInfo

@[typedef]
pub struct C.StdVideoEncodeH264ReferenceInfo {
pub mut:
	flags               StdVideoEncodeH264ReferenceInfoFlags
	primary_pic_type    StdVideoH264PictureType
	FrameNum            u32
	PicOrderCnt         i32
	long_term_pic_num   u16
	long_term_frame_idx u16
	temporal_id         u8
}

pub type StdVideoEncodeH264SliceHeader = C.StdVideoEncodeH264SliceHeader

@[typedef]
pub struct C.StdVideoEncodeH264SliceHeader {
pub mut:
	flags                         StdVideoEncodeH264SliceHeaderFlags
	first_mb_in_slice             u32
	slice_type                    StdVideoH264SliceType
	slice_alpha_c0_offset_div2    i8
	slice_beta_offset_div2        i8
	slice_qp_delta                i8
	reserved1                     u8
	cabac_init_idc                StdVideoH264CabacInitIdc
	disable_deblocking_filter_idc StdVideoH264DisableDeblockingFilterIdc
	pWeightTable                  &StdVideoEncodeH264WeightTable
}

pub const std_video_h265_sublayers_list_size = 7
pub const std_video_h265_cpb_cnt_list_size = 32
pub const std_video_h265_scaling_list_4x4_num_lists = 6
pub const std_video_h265_scaling_list_4x4_num_elements = 16
pub const std_video_h265_scaling_list_8x8_num_lists = 6
pub const std_video_h265_scaling_list_8x8_num_elements = 64
pub const std_video_h265_scaling_list_16x16_num_lists = 6
pub const std_video_h265_scaling_list_16x16_num_elements = 64
pub const std_video_h265_scaling_list_32x32_num_lists = 2
pub const std_video_h265_scaling_list_32x32_num_elements = 64
pub const std_video_h265_predictor_palette_components_list_size = 3
pub const std_video_h265_predictor_palette_comp_entries_list_size = 128
pub const std_video_h265_max_dpb_size = 16
pub const std_video_h265_max_long_term_ref_pics_sps = 32
pub const std_video_h265_chroma_qp_offset_list_size = 6
pub const std_video_h265_chroma_qp_offset_tile_cols_list_size = 19
pub const std_video_h265_chroma_qp_offset_tile_rows_list_size = 21
pub const std_video_h265_max_num_list_ref = 15
pub const std_video_h265_max_chroma_planes = 2
pub const std_video_h265_max_short_term_ref_pic_sets = 64
pub const std_video_h265_max_long_term_pics = 16
pub const std_video_h265_max_delta_poc = 48
pub const std_video_h265_no_reference_picture = 0xff

pub enum StdVideoH265ChromaFormatIdc {
	monochrome = 0
	_420       = 1
	_422       = 2
	_444       = 3
	invalid    = int(0x7FFFFFFF)
	max_enum   = max_int
}

pub enum StdVideoH265ProfileIdc {
	main                    = 1
	main10                  = 2
	main_still_picture      = 3
	format_range_extensions = 4
	scc_extensions          = 9
	invalid                 = int(0x7FFFFFFF)
	max_enum                = max_int
}

pub enum StdVideoH265LevelIdc {
	_1_0     = 0
	_2_0     = 1
	_2_1     = 2
	_3_0     = 3
	_3_1     = 4
	_4_0     = 5
	_4_1     = 6
	_5_0     = 7
	_5_1     = 8
	_5_2     = 9
	_6_0     = 10
	_6_1     = 11
	_6_2     = 12
	invalid  = int(0x7FFFFFFF)
	max_enum = max_int
}

pub enum StdVideoH265SliceType {
	b        = 0
	p        = 1
	i        = 2
	invalid  = int(0x7FFFFFFF)
	max_enum = max_int
}

pub enum StdVideoH265PictureType {
	p        = 0
	b        = 1
	i        = 2
	idr      = 3
	invalid  = int(0x7FFFFFFF)
	max_enum = max_int
}

pub enum StdVideoH265AspectRatioIdc {
	unspecified  = 0
	square       = 1
	_12_11       = 2
	_10_11       = 3
	_16_11       = 4
	_40_33       = 5
	_24_11       = 6
	_20_11       = 7
	_32_11       = 8
	_80_33       = 9
	_18_11       = 10
	_15_11       = 11
	_64_33       = 12
	_160_99      = 13
	_4_3         = 14
	_3_2         = 15
	_2_1         = 16
	extended_sar = 255
	invalid      = int(0x7FFFFFFF)
	max_enum     = max_int
}

pub type StdVideoH265DecPicBufMgr = C.StdVideoH265DecPicBufMgr

@[typedef]
pub struct C.StdVideoH265DecPicBufMgr {
pub mut:
	max_latency_increase_plus1   [std_video_h265_sublayers_list_size]u32
	max_dec_pic_buffering_minus1 [std_video_h265_sublayers_list_size]u8
	max_num_reorder_pics         [std_video_h265_sublayers_list_size]u8
}

pub type StdVideoH265SubLayerHrdParameters = C.StdVideoH265SubLayerHrdParameters

@[typedef]
pub struct C.StdVideoH265SubLayerHrdParameters {
pub mut:
	bit_rate_value_minus1    [std_video_h265_cpb_cnt_list_size]u32
	cpb_size_value_minus1    [std_video_h265_cpb_cnt_list_size]u32
	cpb_size_du_value_minus1 [std_video_h265_cpb_cnt_list_size]u32
	bit_rate_du_value_minus1 [std_video_h265_cpb_cnt_list_size]u32
	cbr_flag                 u32
}

pub type StdVideoH265HrdFlags = C.StdVideoH265HrdFlags

@[typedef]
pub struct C.StdVideoH265HrdFlags {
pub mut:
	nal_hrd_parameters_present_flag           u32
	vcl_hrd_parameters_present_flag           u32
	sub_pic_hrd_params_present_flag           u32
	sub_pic_cpb_params_in_pic_timing_sei_flag u32
	fixed_pic_rate_general_flag               u32
	fixed_pic_rate_within_cvs_flag            u32
	low_delay_hrd_flag                        u32
}

pub type StdVideoH265HrdParameters = C.StdVideoH265HrdParameters

@[typedef]
pub struct C.StdVideoH265HrdParameters {
pub mut:
	flags                                        StdVideoH265HrdFlags
	tick_divisor_minus2                          u8
	du_cpb_removal_delay_increment_length_minus1 u8
	dpb_output_delay_du_length_minus1            u8
	bit_rate_scale                               u8
	cpb_size_scale                               u8
	cpb_size_du_scale                            u8
	initial_cpb_removal_delay_length_minus1      u8
	au_cpb_removal_delay_length_minus1           u8
	dpb_output_delay_length_minus1               u8
	cpb_cnt_minus1                               [std_video_h265_sublayers_list_size]u8
	elemental_duration_in_tc_minus1              [std_video_h265_sublayers_list_size]u16
	reserved                                     [3]u16
	pSubLayerHrdParametersNal                    &StdVideoH265SubLayerHrdParameters
	pSubLayerHrdParametersVcl                    &StdVideoH265SubLayerHrdParameters
}

pub type StdVideoH265VpsFlags = C.StdVideoH265VpsFlags

@[typedef]
pub struct C.StdVideoH265VpsFlags {
pub mut:
	vps_temporal_id_nesting_flag             u32
	vps_sub_layer_ordering_info_present_flag u32
	vps_timing_info_present_flag             u32
	vps_poc_proportional_to_timing_flag      u32
}

pub type StdVideoH265ProfileTierLevelFlags = C.StdVideoH265ProfileTierLevelFlags

@[typedef]
pub struct C.StdVideoH265ProfileTierLevelFlags {
pub mut:
	general_tier_flag                  u32
	general_progressive_source_flag    u32
	general_interlaced_source_flag     u32
	general_non_packed_constraint_flag u32
	general_frame_only_constraint_flag u32
}

pub type StdVideoH265ProfileTierLevel = C.StdVideoH265ProfileTierLevel

@[typedef]
pub struct C.StdVideoH265ProfileTierLevel {
pub mut:
	flags               StdVideoH265ProfileTierLevelFlags
	general_profile_idc StdVideoH265ProfileIdc
	general_level_idc   StdVideoH265LevelIdc
}

pub type StdVideoH265VideoParameterSet = C.StdVideoH265VideoParameterSet

@[typedef]
pub struct C.StdVideoH265VideoParameterSet {
pub mut:
	flags                             StdVideoH265VpsFlags
	vps_video_parameter_set_id        u8
	vps_max_sub_layers_minus1         u8
	reserved1                         u8
	reserved2                         u8
	vps_num_units_in_tick             u32
	vps_time_scale                    u32
	vps_num_ticks_poc_diff_one_minus1 u32
	reserved3                         u32
	pDecPicBufMgr                     &StdVideoH265DecPicBufMgr
	pHrdParameters                    &StdVideoH265HrdParameters
	pProfileTierLevel                 &StdVideoH265ProfileTierLevel
}

pub type StdVideoH265ScalingLists = C.StdVideoH265ScalingLists

@[typedef]
pub struct C.StdVideoH265ScalingLists {
pub mut:
	ScalingList4x4         [std_video_h265_scaling_list_4x4_num_elements][std_video_h265_scaling_list_4x4_num_lists]u8
	ScalingList8x8         [std_video_h265_scaling_list_8x8_num_elements][std_video_h265_scaling_list_8x8_num_lists]u8
	ScalingList16x16       [std_video_h265_scaling_list_16x16_num_elements][std_video_h265_scaling_list_16x16_num_lists]u8
	ScalingList32x32       [std_video_h265_scaling_list_32x32_num_elements][std_video_h265_scaling_list_32x32_num_lists]u8
	ScalingListDCCoef16x16 [std_video_h265_scaling_list_16x16_num_lists]u8
	ScalingListDCCoef32x32 [std_video_h265_scaling_list_32x32_num_lists]u8
}

pub type StdVideoH265SpsVuiFlags = C.StdVideoH265SpsVuiFlags

@[typedef]
pub struct C.StdVideoH265SpsVuiFlags {
pub mut:
	aspect_ratio_info_present_flag          u32
	overscan_info_present_flag              u32
	overscan_appropriate_flag               u32
	video_signal_type_present_flag          u32
	video_full_range_flag                   u32
	colour_description_present_flag         u32
	chroma_loc_info_present_flag            u32
	neutral_chroma_indication_flag          u32
	field_seq_flag                          u32
	frame_field_info_present_flag           u32
	default_display_window_flag             u32
	vui_timing_info_present_flag            u32
	vui_poc_proportional_to_timing_flag     u32
	vui_hrd_parameters_present_flag         u32
	bitstream_restriction_flag              u32
	tiles_fixed_structure_flag              u32
	motion_vectors_over_pic_boundaries_flag u32
	restricted_ref_pic_lists_flag           u32
}

pub type StdVideoH265SequenceParameterSetVui = C.StdVideoH265SequenceParameterSetVui

@[typedef]
pub struct C.StdVideoH265SequenceParameterSetVui {
pub mut:
	flags                               StdVideoH265SpsVuiFlags
	aspect_ratio_idc                    StdVideoH265AspectRatioIdc
	sar_width                           u16
	sar_height                          u16
	video_format                        u8
	colour_primaries                    u8
	transfer_characteristics            u8
	matrix_coeffs                       u8
	chroma_sample_loc_type_top_field    u8
	chroma_sample_loc_type_bottom_field u8
	reserved1                           u8
	reserved2                           u8
	def_disp_win_left_offset            u16
	def_disp_win_right_offset           u16
	def_disp_win_top_offset             u16
	def_disp_win_bottom_offset          u16
	vui_num_units_in_tick               u32
	vui_time_scale                      u32
	vui_num_ticks_poc_diff_one_minus1   u32
	min_spatial_segmentation_idc        u16
	reserved3                           u16
	max_bytes_per_pic_denom             u8
	max_bits_per_min_cu_denom           u8
	log2_max_mv_length_horizontal       u8
	log2_max_mv_length_vertical         u8
	pHrdParameters                      &StdVideoH265HrdParameters
}

pub type StdVideoH265PredictorPaletteEntries = C.StdVideoH265PredictorPaletteEntries

@[typedef]
pub struct C.StdVideoH265PredictorPaletteEntries {
pub mut:
	PredictorPaletteEntries [std_video_h265_predictor_palette_comp_entries_list_size][std_video_h265_predictor_palette_components_list_size]u16
}

pub type StdVideoH265SpsFlags = C.StdVideoH265SpsFlags

@[typedef]
pub struct C.StdVideoH265SpsFlags {
pub mut:
	sps_temporal_id_nesting_flag                    u32
	separate_colour_plane_flag                      u32
	conformance_window_flag                         u32
	sps_sub_layer_ordering_info_present_flag        u32
	scaling_list_enabled_flag                       u32
	sps_scaling_list_data_present_flag              u32
	amp_enabled_flag                                u32
	sample_adaptive_offset_enabled_flag             u32
	pcm_enabled_flag                                u32
	pcm_loop_filter_disabled_flag                   u32
	long_term_ref_pics_present_flag                 u32
	sps_temporal_mvp_enabled_flag                   u32
	strong_intra_smoothing_enabled_flag             u32
	vui_parameters_present_flag                     u32
	sps_extension_present_flag                      u32
	sps_range_extension_flag                        u32
	transform_skip_rotation_enabled_flag            u32
	transform_skip_context_enabled_flag             u32
	implicit_rdpcm_enabled_flag                     u32
	explicit_rdpcm_enabled_flag                     u32
	extended_precision_processing_flag              u32
	intra_smoothing_disabled_flag                   u32
	high_precision_offsets_enabled_flag             u32
	persistent_rice_adaptation_enabled_flag         u32
	cabac_bypass_alignment_enabled_flag             u32
	sps_scc_extension_flag                          u32
	sps_curr_pic_ref_enabled_flag                   u32
	palette_mode_enabled_flag                       u32
	sps_palette_predictor_initializers_present_flag u32
	intra_boundary_filtering_disabled_flag          u32
}

pub type StdVideoH265ShortTermRefPicSetFlags = C.StdVideoH265ShortTermRefPicSetFlags

@[typedef]
pub struct C.StdVideoH265ShortTermRefPicSetFlags {
pub mut:
	inter_ref_pic_set_prediction_flag u32
	delta_rps_sign                    u32
}

pub type StdVideoH265ShortTermRefPicSet = C.StdVideoH265ShortTermRefPicSet

@[typedef]
pub struct C.StdVideoH265ShortTermRefPicSet {
pub mut:
	flags                    StdVideoH265ShortTermRefPicSetFlags
	delta_idx_minus1         u32
	use_delta_flag           u16
	abs_delta_rps_minus1     u16
	used_by_curr_pic_flag    u16
	used_by_curr_pic_s0_flag u16
	used_by_curr_pic_s1_flag u16
	reserved1                u16
	reserved2                u8
	reserved3                u8
	num_negative_pics        u8
	num_positive_pics        u8
	delta_poc_s0_minus1      [std_video_h265_max_dpb_size]u16
	delta_poc_s1_minus1      [std_video_h265_max_dpb_size]u16
}

pub type StdVideoH265LongTermRefPicsSps = C.StdVideoH265LongTermRefPicsSps

@[typedef]
pub struct C.StdVideoH265LongTermRefPicsSps {
pub mut:
	used_by_curr_pic_lt_sps_flag u32
	lt_ref_pic_poc_lsb_sps       [std_video_h265_max_long_term_ref_pics_sps]u32
}

pub type StdVideoH265SequenceParameterSet = C.StdVideoH265SequenceParameterSet

@[typedef]
pub struct C.StdVideoH265SequenceParameterSet {
pub mut:
	flags                                         StdVideoH265SpsFlags
	chroma_format_idc                             StdVideoH265ChromaFormatIdc
	pic_width_in_luma_samples                     u32
	pic_height_in_luma_samples                    u32
	sps_video_parameter_set_id                    u8
	sps_max_sub_layers_minus1                     u8
	sps_seq_parameter_set_id                      u8
	bit_depth_luma_minus8                         u8
	bit_depth_chroma_minus8                       u8
	log2_max_pic_order_cnt_lsb_minus4             u8
	log2_min_luma_coding_block_size_minus3        u8
	log2_diff_max_min_luma_coding_block_size      u8
	log2_min_luma_transform_block_size_minus2     u8
	log2_diff_max_min_luma_transform_block_size   u8
	max_transform_hierarchy_depth_inter           u8
	max_transform_hierarchy_depth_intra           u8
	num_short_term_ref_pic_sets                   u8
	num_long_term_ref_pics_sps                    u8
	pcm_sample_bit_depth_luma_minus1              u8
	pcm_sample_bit_depth_chroma_minus1            u8
	log2_min_pcm_luma_coding_block_size_minus3    u8
	log2_diff_max_min_pcm_luma_coding_block_size  u8
	reserved1                                     u8
	reserved2                                     u8
	palette_max_size                              u8
	delta_palette_max_predictor_size              u8
	motion_vector_resolution_control_idc          u8
	sps_num_palette_predictor_initializers_minus1 u8
	conf_win_left_offset                          u32
	conf_win_right_offset                         u32
	conf_win_top_offset                           u32
	conf_win_bottom_offset                        u32
	pProfileTierLevel                             &StdVideoH265ProfileTierLevel
	pDecPicBufMgr                                 &StdVideoH265DecPicBufMgr
	pScalingLists                                 &StdVideoH265ScalingLists
	pShortTermRefPicSet                           &StdVideoH265ShortTermRefPicSet
	pLongTermRefPicsSps                           &StdVideoH265LongTermRefPicsSps
	pSequenceParameterSetVui                      &StdVideoH265SequenceParameterSetVui
	pPredictorPaletteEntries                      &StdVideoH265PredictorPaletteEntries
}

pub type StdVideoH265PpsFlags = C.StdVideoH265PpsFlags

@[typedef]
pub struct C.StdVideoH265PpsFlags {
pub mut:
	dependent_slice_segments_enabled_flag           u32
	output_flag_present_flag                        u32
	sign_data_hiding_enabled_flag                   u32
	cabac_init_present_flag                         u32
	constrained_intra_pred_flag                     u32
	transform_skip_enabled_flag                     u32
	cu_qp_delta_enabled_flag                        u32
	pps_slice_chroma_qp_offsets_present_flag        u32
	weighted_pred_flag                              u32
	weighted_bipred_flag                            u32
	transquant_bypass_enabled_flag                  u32
	tiles_enabled_flag                              u32
	entropy_coding_sync_enabled_flag                u32
	uniform_spacing_flag                            u32
	loop_filter_across_tiles_enabled_flag           u32
	pps_loop_filter_across_slices_enabled_flag      u32
	deblocking_filter_control_present_flag          u32
	deblocking_filter_override_enabled_flag         u32
	pps_deblocking_filter_disabled_flag             u32
	pps_scaling_list_data_present_flag              u32
	lists_modification_present_flag                 u32
	slice_segment_header_extension_present_flag     u32
	pps_extension_present_flag                      u32
	cross_component_prediction_enabled_flag         u32
	chroma_qp_offset_list_enabled_flag              u32
	pps_curr_pic_ref_enabled_flag                   u32
	residual_adaptive_colour_transform_enabled_flag u32
	pps_slice_act_qp_offsets_present_flag           u32
	pps_palette_predictor_initializers_present_flag u32
	monochrome_palette_flag                         u32
	pps_range_extension_flag                        u32
}

pub type StdVideoH265PictureParameterSet = C.StdVideoH265PictureParameterSet

@[typedef]
pub struct C.StdVideoH265PictureParameterSet {
pub mut:
	flags                                     StdVideoH265PpsFlags
	pps_pic_parameter_set_id                  u8
	pps_seq_parameter_set_id                  u8
	sps_video_parameter_set_id                u8
	num_extra_slice_header_bits               u8
	num_ref_idx_l0_default_active_minus1      u8
	num_ref_idx_l1_default_active_minus1      u8
	init_qp_minus26                           i8
	diff_cu_qp_delta_depth                    u8
	pps_cb_qp_offset                          i8
	pps_cr_qp_offset                          i8
	pps_beta_offset_div2                      i8
	pps_tc_offset_div2                        i8
	log2_parallel_merge_level_minus2          u8
	log2_max_transform_skip_block_size_minus2 u8
	diff_cu_chroma_qp_offset_depth            u8
	chroma_qp_offset_list_len_minus1          u8
	cb_qp_offset_list                         [std_video_h265_chroma_qp_offset_list_size]i8
	cr_qp_offset_list                         [std_video_h265_chroma_qp_offset_list_size]i8
	log2_sao_offset_scale_luma                u8
	log2_sao_offset_scale_chroma              u8
	pps_act_y_qp_offset_plus5                 i8
	pps_act_cb_qp_offset_plus5                i8
	pps_act_cr_qp_offset_plus3                i8
	pps_num_palette_predictor_initializers    u8
	luma_bit_depth_entry_minus8               u8
	chroma_bit_depth_entry_minus8             u8
	num_tile_columns_minus1                   u8
	num_tile_rows_minus1                      u8
	reserved1                                 u8
	reserved2                                 u8
	column_width_minus1                       [std_video_h265_chroma_qp_offset_tile_cols_list_size]u16
	row_height_minus1                         [std_video_h265_chroma_qp_offset_tile_rows_list_size]u16
	reserved3                                 u32
	pScalingLists                             &StdVideoH265ScalingLists
	pPredictorPaletteEntries                  &StdVideoH265PredictorPaletteEntries
}

pub const std_vulkan_video_codec_h265_decode_api_version_1_0_0 = make_video_std_version(1,
	0, 0)

pub const std_video_decode_h265_ref_pic_set_list_size = 8
pub const std_vulkan_video_codec_h265_decode_spec_version = std_vulkan_video_codec_h265_decode_api_version_1_0_0
pub const std_vulkan_video_codec_h265_decode_extension_name = 'VK_STD_vulkan_video_codec_h265_decode'

pub type StdVideoDecodeH265PictureInfoFlags = C.StdVideoDecodeH265PictureInfoFlags

@[typedef]
pub struct C.StdVideoDecodeH265PictureInfoFlags {
pub mut:
	IrapPicFlag                     u32
	IdrPicFlag                      u32
	IsReference                     u32
	short_term_ref_pic_set_sps_flag u32
}

pub type StdVideoDecodeH265PictureInfo = C.StdVideoDecodeH265PictureInfo

@[typedef]
pub struct C.StdVideoDecodeH265PictureInfo {
pub mut:
	flags                        StdVideoDecodeH265PictureInfoFlags
	sps_video_parameter_set_id   u8
	pps_seq_parameter_set_id     u8
	pps_pic_parameter_set_id     u8
	NumDeltaPocsOfRefRpsIdx      u8
	PicOrderCntVal               i32
	NumBitsForSTRefPicSetInSlice u16
	reserved                     u16
	RefPicSetStCurrBefore        [std_video_decode_h265_ref_pic_set_list_size]u8
	RefPicSetStCurrAfter         [std_video_decode_h265_ref_pic_set_list_size]u8
	RefPicSetLtCurr              [std_video_decode_h265_ref_pic_set_list_size]u8
}

pub type StdVideoDecodeH265ReferenceInfoFlags = C.StdVideoDecodeH265ReferenceInfoFlags

@[typedef]
pub struct C.StdVideoDecodeH265ReferenceInfoFlags {
pub mut:
	used_for_long_term_reference u32
	unused_for_reference         u32
}

pub type StdVideoDecodeH265ReferenceInfo = C.StdVideoDecodeH265ReferenceInfo

@[typedef]
pub struct C.StdVideoDecodeH265ReferenceInfo {
pub mut:
	flags          StdVideoDecodeH265ReferenceInfoFlags
	PicOrderCntVal i32
}

pub const std_vulkan_video_codec_h265_encode_api_version_1_0_0 = make_video_std_version(1,
	0, 0)

pub const std_vulkan_video_codec_h265_encode_spec_version = std_vulkan_video_codec_h265_encode_api_version_1_0_0
pub const std_vulkan_video_codec_h265_encode_extension_name = 'VK_STD_vulkan_video_codec_h265_encode'

pub type StdVideoEncodeH265WeightTableFlags = C.StdVideoEncodeH265WeightTableFlags

@[typedef]
pub struct C.StdVideoEncodeH265WeightTableFlags {
pub mut:
	luma_weight_l0_flag   u16
	chroma_weight_l0_flag u16
	luma_weight_l1_flag   u16
	chroma_weight_l1_flag u16
}

pub type StdVideoEncodeH265WeightTable = C.StdVideoEncodeH265WeightTable

@[typedef]
pub struct C.StdVideoEncodeH265WeightTable {
pub mut:
	flags                          StdVideoEncodeH265WeightTableFlags
	luma_log2_weight_denom         u8
	delta_chroma_log2_weight_denom i8
	delta_luma_weight_l0           [std_video_h265_max_num_list_ref]i8
	luma_offset_l0                 [std_video_h265_max_num_list_ref]i8
	delta_chroma_weight_l0         [std_video_h265_max_chroma_planes][std_video_h265_max_num_list_ref]i8
	delta_chroma_offset_l0         [std_video_h265_max_chroma_planes][std_video_h265_max_num_list_ref]i8
	delta_luma_weight_l1           [std_video_h265_max_num_list_ref]i8
	luma_offset_l1                 [std_video_h265_max_num_list_ref]i8
	delta_chroma_weight_l1         [std_video_h265_max_chroma_planes][std_video_h265_max_num_list_ref]i8
	delta_chroma_offset_l1         [std_video_h265_max_chroma_planes][std_video_h265_max_num_list_ref]i8
}

pub type StdVideoEncodeH265SliceSegmentHeaderFlags = C.StdVideoEncodeH265SliceSegmentHeaderFlags

@[typedef]
pub struct C.StdVideoEncodeH265SliceSegmentHeaderFlags {
pub mut:
	first_slice_segment_in_pic_flag              u32
	dependent_slice_segment_flag                 u32
	slice_sao_luma_flag                          u32
	slice_sao_chroma_flag                        u32
	num_ref_idx_active_override_flag             u32
	mvd_l1_zero_flag                             u32
	cabac_init_flag                              u32
	cu_chroma_qp_offset_enabled_flag             u32
	deblocking_filter_override_flag              u32
	slice_deblocking_filter_disabled_flag        u32
	collocated_from_l0_flag                      u32
	slice_loop_filter_across_slices_enabled_flag u32
	reserved                                     u32
}

pub type StdVideoEncodeH265SliceSegmentHeader = C.StdVideoEncodeH265SliceSegmentHeader

@[typedef]
pub struct C.StdVideoEncodeH265SliceSegmentHeader {
pub mut:
	flags                  StdVideoEncodeH265SliceSegmentHeaderFlags
	slice_type             StdVideoH265SliceType
	slice_segment_address  u32
	collocated_ref_idx     u8
	MaxNumMergeCand        u8
	slice_cb_qp_offset     i8
	slice_cr_qp_offset     i8
	slice_beta_offset_div2 i8
	slice_tc_offset_div2   i8
	slice_act_y_qp_offset  i8
	slice_act_cb_qp_offset i8
	slice_act_cr_qp_offset i8
	slice_qp_delta         i8
	reserved1              u16
	pWeightTable           &StdVideoEncodeH265WeightTable
}

pub type StdVideoEncodeH265ReferenceListsInfoFlags = C.StdVideoEncodeH265ReferenceListsInfoFlags

@[typedef]
pub struct C.StdVideoEncodeH265ReferenceListsInfoFlags {
pub mut:
	ref_pic_list_modification_flag_l0 u32
	ref_pic_list_modification_flag_l1 u32
	reserved                          u32
}

pub type StdVideoEncodeH265ReferenceListsInfo = C.StdVideoEncodeH265ReferenceListsInfo

@[typedef]
pub struct C.StdVideoEncodeH265ReferenceListsInfo {
pub mut:
	flags                        StdVideoEncodeH265ReferenceListsInfoFlags
	num_ref_idx_l0_active_minus1 u8
	num_ref_idx_l1_active_minus1 u8
	RefPicList0                  [std_video_h265_max_num_list_ref]u8
	RefPicList1                  [std_video_h265_max_num_list_ref]u8
	list_entry_l0                [std_video_h265_max_num_list_ref]u8
	list_entry_l1                [std_video_h265_max_num_list_ref]u8
}

pub type StdVideoEncodeH265PictureInfoFlags = C.StdVideoEncodeH265PictureInfoFlags

@[typedef]
pub struct C.StdVideoEncodeH265PictureInfoFlags {
pub mut:
	is_reference                    u32
	IrapPicFlag                     u32
	used_for_long_term_reference    u32
	discardable_flag                u32
	cross_layer_bla_flag            u32
	pic_output_flag                 u32
	no_output_of_prior_pics_flag    u32
	short_term_ref_pic_set_sps_flag u32
	slice_temporal_mvp_enabled_flag u32
	reserved                        u32
}

pub type StdVideoEncodeH265LongTermRefPics = C.StdVideoEncodeH265LongTermRefPics

@[typedef]
pub struct C.StdVideoEncodeH265LongTermRefPics {
pub mut:
	num_long_term_sps          u8
	num_long_term_pics         u8
	lt_idx_sps                 [std_video_h265_max_long_term_ref_pics_sps]u8
	poc_lsb_lt                 [std_video_h265_max_long_term_pics]u8
	used_by_curr_pic_lt_flag   u16
	delta_poc_msb_present_flag [std_video_h265_max_delta_poc]u8
	delta_poc_msb_cycle_lt     [std_video_h265_max_delta_poc]u8
}

pub type StdVideoEncodeH265PictureInfo = C.StdVideoEncodeH265PictureInfo

@[typedef]
pub struct C.StdVideoEncodeH265PictureInfo {
pub mut:
	flags                      StdVideoEncodeH265PictureInfoFlags
	pic_type                   StdVideoH265PictureType
	sps_video_parameter_set_id u8
	pps_seq_parameter_set_id   u8
	pps_pic_parameter_set_id   u8
	short_term_ref_pic_set_idx u8
	PicOrderCntVal             i32
	TemporalId                 u8
	reserved1                  [7]u8
	pRefLists                  &StdVideoEncodeH265ReferenceListsInfo
	pShortTermRefPicSet        &StdVideoH265ShortTermRefPicSet
	pLongTermRefPics           &StdVideoEncodeH265LongTermRefPics
}

pub type StdVideoEncodeH265ReferenceInfoFlags = C.StdVideoEncodeH265ReferenceInfoFlags

@[typedef]
pub struct C.StdVideoEncodeH265ReferenceInfoFlags {
pub mut:
	used_for_long_term_reference u32
	unused_for_reference         u32
	reserved                     u32
}

pub type StdVideoEncodeH265ReferenceInfo = C.StdVideoEncodeH265ReferenceInfo

@[typedef]
pub struct C.StdVideoEncodeH265ReferenceInfo {
pub mut:
	flags          StdVideoEncodeH265ReferenceInfoFlags
	pic_type       StdVideoH265PictureType
	PicOrderCntVal i32
	TemporalId     u8
}
