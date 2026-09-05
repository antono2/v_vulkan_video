module video_decode_app

#flag -I @VMODROOT/include
#include "video_bridge.h"

fn C.vv_set_h264_scaling_list_4x4(voidptr, u32, u32, u8)

fn C.vv_set_h264_scaling_list_8x8(voidptr, u32, u32, u8)

fn C.vv_set_h264_picture_order_count(voidptr, i32, i32)

fn C.vv_set_h264_idr_picture_flag(voidptr, u32)

fn C.vv_set_h264_reference_info(voidptr, u16, i32, i32)

$if windows {
	#define VK_USE_PLATFORM_WIN32_KHR
}
/*
#include "Volk/volk.h"

// TODO: Check if needed
#undef ERROR
#undef min
#undef max
*/
