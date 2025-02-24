/*
	Vulkan Memory Allocator Bindings for Vlang

Version 3.2.1

Copyright (c) 2017-2025 Advanced Micro Devices, Inc. All rights reserved.
License: MIT
See also: product page on GPUOpen https://gpuopen.com/gaming-product/vulkan-memory-allocator/
          repository on GitHub https://github.com/GPUOpen-LibrariesAndSDKs/VulkanMemoryAllocator
*/

module vk_mem_alloc

import src.vulkan as vk

#flag -I @VMODROOT/include
#include "vk_mem_alloc.h"

// pub type C.VmaVulkanFunctions = voidptr

// Pointers to some Vulkan functions - a subset used by the library.

// Used in VmaAllocatorCreateInfo::pVulkanFunctions.

pub type VulkanFunctions = C.VmaVulkanFunctions

@[typedef]
pub struct C.VmaVulkanFunctions {
pub mut:
	/// Required when using VMA_DYNAMIC_VULKAN_FUNCTIONS.
	vkGetInstanceProcAddr vk.PFN_vkGetInstanceProcAddrLUNARG = unsafe { nil }
	/// Required when using VMA_DYNAMIC_VULKAN_FUNCTIONS.
	vkGetDeviceProcAddr                 vk.PFN_vkGetDeviceProcAddr                 = unsafe { nil }
	vkGetPhysicalDeviceProperties       vk.PFN_vkGetPhysicalDeviceProperties       = unsafe { nil }
	vkGetPhysicalDeviceMemoryProperties vk.PFN_vkGetPhysicalDeviceMemoryProperties = unsafe { nil }
	vkAllocateMemory                    vk.PFN_vkAllocateMemory                    = unsafe { nil }
	vkFreeMemory                        vk.PFN_vkFreeMemory                        = unsafe { nil }
	vkMapMemory                         vk.PFN_vkMapMemory                         = unsafe { nil }
	vkUnmapMemory                       vk.PFN_vkUnmapMemory                       = unsafe { nil }
	vkFlushMappedMemoryRanges           vk.PFN_vkFlushMappedMemoryRanges           = unsafe { nil }
	vkInvalidateMappedMemoryRanges      vk.PFN_vkInvalidateMappedMemoryRanges      = unsafe { nil }
	vkBindBufferMemory                  vk.PFN_vkBindBufferMemory                  = unsafe { nil }
	vkBindImageMemory                   vk.PFN_vkBindImageMemory                   = unsafe { nil }
	vkGetBufferMemoryRequirements       vk.PFN_vkGetBufferMemoryRequirements       = unsafe { nil }
	vkGetImageMemoryRequirements        vk.PFN_vkGetImageMemoryRequirements        = unsafe { nil }
	vkCreateBuffer                      vk.PFN_vkCreateBuffer                      = unsafe { nil }
	vkDestroyBuffer                     vk.PFN_vkDestroyBuffer                     = unsafe { nil }
	vkCreateImage                       vk.PFN_vkCreateImage                       = unsafe { nil }
	vkDestroyImage                      vk.PFN_vkDestroyImage                      = unsafe { nil }
	vkCmdCopyBuffer                     vk.PFN_vkCmdCopyBuffer                     = unsafe { nil }
	// #if VMA_DEDICATED_ALLOCATION || VMA_VULKAN_VERSION >= 1001000
	//     /// Fetch "vkGetBufferMemoryRequirements2" on Vulkan >= 1.1, fetch "vkGetBufferMemoryRequirements2KHR" when using VK_KHR_dedicated_allocation extension.
	//// get_buffer_memory_requirements2_khr vk.PFN_vkGetBufferMemoryRequirements2KHR = unsafe{ nil }
	//     /// Fetch "vkGetImageMemoryRequirements2" on Vulkan >= 1.1, fetch "vkGetImageMemoryRequirements2KHR" when using VK_KHR_dedicated_allocation extension.
	////get_image_memory_requirements2_khr vk.PFN_vkGetImageMemoryRequirements2KHR = unsafe{ nil }
	// #endif
	// #if VMA_BIND_MEMORY2 || VMA_VULKAN_VERSION >= 1001000
	//     /// Fetch "vkBindBufferMemory2" on Vulkan >= 1.1, fetch "vkBindBufferMemory2KHR" when using VK_KHR_bind_memory2 extension.
	////bind_buffer_memory2_khr vk.PFN_vkBindBufferMemory2KHR = unsafe{ nil }
	//     /// Fetch "vkBindImageMemory2" on Vulkan >= 1.1, fetch "vkBindImageMemory2KHR" when using VK_KHR_bind_memory2 extension.
	////bind_image_memory2_khr vk.PFN_vkBindImageMemory2KHR = unsafe{ nil }
	// #endif
	// #if VMA_MEMORY_BUDGET || VMA_VULKAN_VERSION >= 1001000
	//     /// Fetch from "vkGetPhysicalDeviceMemoryProperties2" on Vulkan >= 1.1, but you can also fetch it from "vkGetPhysicalDeviceMemoryProperties2KHR" if you enabled extension VK_KHR_get_physical_device_properties2.
	////get_physical_device_memory_properties2_khr vk.PFN_vkGetPhysicalDeviceMemoryProperties2KHR = unsafe{ nil }
	// #endif
	// #if VMA_KHR_MAINTENANCE4 || VMA_VULKAN_VERSION >= 1003000
	//     /// Fetch from "vkGetDeviceBufferMemoryRequirements" on Vulkan >= 1.3, but you can also fetch it from "vkGetDeviceBufferMemoryRequirementsKHR" if you enabled extension VK_KHR_maintenance4.
	////get_device_buffer_memory_requirements vk.PFN_vkGetDeviceBufferMemoryRequirementsKHR
	//     /// Fetch from "vkGetDeviceImageMemoryRequirements" on Vulkan >= 1.3, but you can also fetch it from "vkGetDeviceImageMemoryRequirementsKHR" if you enabled extension VK_KHR_maintenance4.
	////get_device_image_memory_requirements vk.PFN_vkGetDeviceImageMemoryRequirementsKHR
	// #endif
	// #if VMA_EXTERNAL_MEMORY_WIN32
	////get_memory_win32_handle_khr vk.PFN_vkGetMemoryWin32HandleKHR = unsafe{ nil }
	// #else
	////get_memory_win32_handle_khr voidptr
	// #endif
}

pub type VmaAllocatorCreateFlags = u32
pub type PFN_vmaAllocateDeviceMemoryFunction = fn (allocator C.VmaAllocator, memory_type u32, memory C.VkDeviceMemory, size vk.DeviceSize, p_user_data voidptr)

pub type C.VmaAllocator = voidptr
pub type PFN_vmaFreeDeviceMemoryFunction = fn (allocator C.VmaAllocator, memory_type u32, memory C.VkDeviceMemory, size vk.DeviceSize, p_user_data voidptr)

fn C.vmaCreateAllocator(p_create_info voidptr, p_allocator voidptr) vk.Result
@[inline]
pub fn create_allocator(p_create_info &VmaAllocatorCreateInfo, p_allocator C.VmaAllocator) vk.Result {
	return C.vmaCreateAllocator(p_create_info, p_allocator)
}

pub type VmaAllocatorCreateInfo = C.VmaAllocatorCreateInfo

/// Description of a Allocator to be created.
@[typedef]
pub struct C.VmaAllocatorCreateInfo {
pub mut:
	/// Flags for created allocator. Use #VmaAllocatorCreateFlagBits enum.
	flags VmaAllocatorCreateFlags
	/// Vulkan physical device.
	// It must be valid throughout whole lifetime of created allocator.
	physicalDevice C.VkPhysicalDevice //@[required]
	/// Vulkan device.
	// It must be valid throughout whole lifetime of created allocator.
	device C.VkDevice //@[required]
	/// Preferred size of a single `VkDeviceMemory` block to be allocated from large heaps > 1 GiB. Optional.
	// Set to 0 to use default, which is currently 256 MiB.
	preferredLargeHeapBlockSize vk.DeviceSize
	/// Custom CPU memory allocation callbacks. Optional.
	// Optional, can be null. When specified, will also be used for all CPU-side memory allocations.
	pAllocationCallbacks &vk.AllocationCallbacks = unsafe { nil }
	/// Informative callbacks for `vkAllocateMemory`, `vkFreeMemory`. Optional.
	// Optional, can be null.
	pDeviceMemoryCallbacks &VmaDeviceMemoryCallbacks = unsafe { nil }
	// \brief Either null or a pointer to an array of limits on maximum number of bytes that can be allocated out of particular Vulkan memory heap.

	/*
    If not NULL, it must be a pointer to an array of
    `VkPhysicalDeviceMemoryProperties::memoryHeapCount` elements, defining limit on
    maximum number of bytes that can be allocated out of particular Vulkan memory
    heap.

    Any of the elements may be equal to `VK_WHOLE_SIZE`, which means no limit on that
    heap. This is also the default in case of `pHeapSizeLimit` = NULL.

    If there is a limit defined for a heap:

    - If user tries to allocate more memory from that heap using this allocator,
      the allocation fails with `VK_ERROR_OUT_OF_DEVICE_MEMORY`.
    - If the limit is smaller than heap size reported in `VkMemoryHeap::size`, the
      value of this limit will be reported instead when using vmaGetMemoryProperties().

    Warning! Using this feature may not be equivalent to installing a GPU with
    smaller amount of memory, because graphics driver doesn't necessary fail new
    allocations with `VK_ERROR_OUT_OF_DEVICE_MEMORY` result when memory capacity is
    exceeded. It may return success and just silently migrate some device memory
    blocks to system RAM. This driver behavior can also be controlled using
    VK_AMD_memory_overallocation_behavior extension.
    */
	pHeapSizeLimit vk.DeviceSize
	// const VkDeviceSize* VMA_NULLABLE VMA_LEN_IF_NOT_NULL("VkPhysicalDeviceMemoryProperties::memoryHeapCount") pHeapSizeLimit;
	pVulkanFunctions &VulkanFunctions = unsafe { nil }
	instance         C.VkInstance //@[required]
	vulkanApiVersion u32
}

pub type VmaDeviceMemoryCallbacks = C.VmaDeviceMemoryCallbacks

@[typedef]
pub struct C.VmaDeviceMemoryCallbacks {
	// Optional, can be null.
	pfnAllocate PFN_vmaAllocateDeviceMemoryFunction = unsafe { nil }
	// Optional, can be null.
	pfnFree PFN_vmaFreeDeviceMemoryFunction = unsafe { nil }
	// Optional, can be null.
	pUserData voidptr = unsafe { nil }
}
