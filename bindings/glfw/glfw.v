module glfw

import src.vulkan as vk

// GLFW
// https://www.glfw.org/docs/latest/vulkan_guide.html
#flag windows -I<PATH TO GLFW INCLUDE, LIKE C:\glfw-3.4.bin.WIN64\include>
#flag windows -Iinclude
#flag linux -L/usr/lib/x86_64-linux-gnu
#flag windows -L<PATH TO GLFW LIB, LIKE C:\glfw-3.4.bin.WIN64\lib-mingw-w64>
#flag linux -lglfw
#flag windows -lglfw3
#flag windows -lgdi32
// Please see https://www.glfw.org/docs/latest/build_guide.html#build_macros for more information
#flag windows -DGLFW_INCLUDE_GLCOREARB=1 // makes the GLFW header include the modern GL/glcorearb.h header (OpenGL/gl3.h on macOS) instead of the regular OpenGL header.

#include "GLFW/glfw3.h"

pub const glfw_true = 1
pub const glfw_false = 0
pub const press = 1
pub const key_enter = 257
pub const key_escape = 256
pub const client_api = 0x00022001
pub const no_api = 0
pub const resizable = int(0x00020003)

// Using heap, since window contains a pointer to user data,
// which should not be cleaned up automatically

pub type C.GLFWwindow = voidptr

pub type C.GLFWmonitor = voidptr

fn C.glfwInit() int
pub fn init() bool {
	return C.glfwInit() == glfw_true
}

fn C.glfwTerminate()
pub fn terminate() {
	C.glfwTerminate()
}

fn C.glfwCreateWindow(width int, height int, title &char, monitor voidptr, share voidptr) C.GLFWwindow
pub fn create_window(width int, height int, title string, monitor C.GLFWmonitor, share C.GLFWwindow) C.GLFWwindow {
	return C.glfwCreateWindow(width, height, title.str, voidptr(monitor), voidptr(share))
}

fn C.glfwSetWindowUserPointer(window voidptr, pointer voidptr)
pub fn set_window_user_pointer(window C.GLFWwindow, pointer voidptr) {
	C.glfwSetWindowUserPointer(voidptr(window), pointer)
}

fn C.glfwGetWindowUserPointer(window voidptr) voidptr
pub fn get_user_pointer(window C.GLFWwindow) voidptr {
	return C.glfwGetWindowUserPointer(voidptr(window))
}

pub type GLFWFnKey = fn (window C.GLFWwindow, key_id int, scan_code int, action int, bit_filed int)

fn C.glfwSetKeyCallback(window voidptr, callback GLFWFnKey)
pub fn set_key_callback(window C.GLFWwindow, callback GLFWFnKey) {
	C.glfwSetKeyCallback(voidptr(window), callback)
}

fn C.glfwMakeContextCurrent(window voidptr)
pub fn make_context_current(window C.GLFWwindow) {
	C.glfwMakeContextCurrent(voidptr(window))
}

fn C.glfwVulkanSupported() int
pub fn is_vulkan_supported() bool {
	return C.glfwVulkanSupported() == glfw_true
}

fn C.glfwSetWindowShouldClose(window voidptr, value int)
pub fn set_should_close(window C.GLFWwindow, flag int) {
	C.glfwSetWindowShouldClose(voidptr(window), flag)
}

fn C.glfwWindowShouldClose(window voidptr) int
pub fn window_should_close(window C.GLFWwindow) bool {
	return C.glfwWindowShouldClose(voidptr(window)) == glfw_true
}

fn C.glfwPollEvents()
pub fn poll_events() {
	C.glfwPollEvents()
}

fn C.glfwGetRequiredInstanceExtensions(count &u32) &&char
pub fn get_required_instance_extensions(count &u32) &&char {
	return C.glfwGetRequiredInstanceExtensions(count)
}

fn C.glfwCreateWindowSurface(voidptr, voidptr, voidptr, voidptr) vk.Result
pub fn create_window_surface(instance C.VkInstance, window C.GLFWwindow, allocator &vk.AllocationCallbacks, surface C.VkSurfaceKHR) vk.Result {
	return C.glfwCreateWindowSurface(voidptr(instance), voidptr(window), voidptr(allocator),
		voidptr(surface))
}

fn C.glfwWindowHint(int, int)
pub fn window_hint(hint int, value int) {
	C.glfwWindowHint(hint, value)
}

fn C.glfwGetPhysicalDevicePresentationSupport(voidptr, voidptr, u32) int
pub fn get_physical_device_presentation_support(instance C.VkInstance, device C.VkPhysicalDevice, queuefamily u32) bool {
	return C.glfwGetPhysicalDevicePresentationSupport(voidptr(instance), voidptr(device),
		queuefamily) == glfw_true
}
