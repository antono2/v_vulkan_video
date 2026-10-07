// Checks that count-only swapchain image queries pass a null output pointer.
module main

fn test_swapchain_count_query_has_null_output_pointer() {
	images := swapchain_count_only_images()
	assert unsafe { voidptr(images) == nil }
}
