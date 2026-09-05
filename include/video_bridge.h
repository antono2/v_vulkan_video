#ifndef V_VULKAN_VIDEO_BRIDGE_H
#define V_VULKAN_VIDEO_BRIDGE_H

#include <stdint.h>
#include <vk_video/vulkan_video_codec_h264std_decode.h>

static inline void vv_set_h264_scaling_list_4x4(
    StdVideoH264ScalingLists* lists, uint32_t list, uint32_t element, uint8_t value) {
    lists->ScalingList4x4[list][element] = value;
}

static inline void vv_set_h264_scaling_list_8x8(
    StdVideoH264ScalingLists* lists, uint32_t list, uint32_t element, uint8_t value) {
    lists->ScalingList8x8[list][element] = value;
}

static inline void vv_set_h264_picture_order_count(
    StdVideoDecodeH264PictureInfo* picture, int32_t top, int32_t bottom) {
    picture->PicOrderCnt[0] = top;
    picture->PicOrderCnt[1] = bottom;
}

static inline void vv_set_h264_idr_picture_flag(
    StdVideoDecodeH264PictureInfo* picture, uint32_t value) {
    picture->flags.IdrPicFlag = value;
}

static inline void vv_set_h264_reference_info(
    StdVideoDecodeH264ReferenceInfo* reference, uint16_t frame_num,
    int32_t top, int32_t bottom) {
    reference->FrameNum = frame_num;
    reference->PicOrderCnt[0] = top;
    reference->PicOrderCnt[1] = bottom;
}

#endif
