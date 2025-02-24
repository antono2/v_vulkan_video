module volk

import src.vulkan as vk

// Volk
// https://github.com/zeux/volk#basic-usage
#flag windows -I$env('VULKAN_SDK')/Include/Volk
// https://github.com/zeux/volk#building
#flag -DVOLK_IMPLEMENTATION
#flag -DVK_NO_PROTOTYPES
//#preinclude "volk.h"
#include "volk.h"

fn C.volkInitialize() vk.Result
fn C.volkLoadInstance(C.VkInstance)
fn C.volkLoadDevice(C.VkDevice)


@[inline]
pub fn load_device(vk_device C.VkDevice) {
	C.volkLoadDevice(vk_device)
}

@[inline]
pub fn load_instance(vk_instance C.VkInstance) {
	C.volkLoadInstance(vk_instance)
}

@[inline]
pub fn initialize() vk.Result {
	return C.volkInitialize()
}
