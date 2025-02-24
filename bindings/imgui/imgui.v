module imgui

#flags -I @VMODROOT/thirdparty/imgui
#include "imgui.h"

#flag -D IMGUI_IMPL_VULKAN_HAS_DYNAMIC_RENDERING
#include "backends/imgui_impl_vulkan.h"
#include "backends/imgui_impl_glfw.h"

