# Building and packaging

The application supports either a shared or static Dear ImGui binding. The
shared configuration is the distribution default because it keeps C++ and
Vulkan backend symbols isolated and can be relocated with `$ORIGIN`.

## Shared Dear ImGui (default)

```sh
~/.vmodules/imgui/build_vimgui.sh --linkage shared --glfw system
v -cc gcc -o v_vulkan_video .
```

## Static Dear ImGui

```sh
~/.vmodules/imgui/build_vimgui.sh --linkage static --glfw system
v -d imgui_static -cc gcc -o v_vulkan_video .
```

`imgui_static` hides the executable's Volk dispatch variables from dynamic
symbol lookup. Without that visibility rule, the Vulkan loader can resolve a
function name back to the application's same-named pointer slot.

This option statically links Dear ImGui/ImPlot. It does not promise a fully
static Linux executable: GLFW, libc, the Vulkan loader, and the GPU driver are
platform runtime components.

## GLFW provider and version

Use the distribution GLFW package:

```sh
~/.vmodules/imgui/build_vimgui.sh --glfw system
```

Or build a selected upstream release:

```sh
~/.vmodules/imgui/build_vimgui.sh --glfw bundled --glfw-version 3.4
```

The same `--glfw` and `--glfw-version` options work with either ImGui linkage.

## Platform status

See [PLATFORM_SUPPORT.md](PLATFORM_SUPPORT.md) for the tested platform and the
requirements for other operating systems and GPU/driver combinations. The
portable ZIP below is specifically an Ubuntu 24.04 x86-64/X11 build; it is not
a platform-independent archive.

## Player command line

```sh
./v_vulkan_video [--list-gpus] [--gpu INDEX] [video.mp4]
```

GPU compatibility is evaluated against the input stream's actual H.264
profile. Without `--gpu`, the first fully compatible presentation/decode device
is selected. Invalid media and unsupported or out-of-range devices return a
clean non-zero exit status with a diagnostic instead of a panic.

## Ubuntu 24.04 binary package

The packaging script builds in the configured Ubuntu 24 root filesystem,
sets relative runtime paths, bundles compatible C++/GLFW libraries, tests the
ZIP, and prints its SHA-256 digest:

```sh
scripts/package_ubuntu24.sh ~/workspace/vkvideo_ubuntu24_amd64.zip
```

Optional environment overrides are `V_BIN`, `UBUNTU24_ROOTFS`, `VIMGUI_DIR`,
`VULKAN_SDK`, `VIMGUI_BUILD_TYPE`, `VIMGUI_GLFW_PROVIDER`, and
`VIMGUI_GLFW_VERSION`.

The Vulkan loader and GPU driver are deliberately not bundled; they must match
the target machine and provide Vulkan Video H.264 decoding.

The packaging command also runs `scripts/verify_ubuntu24_package.sh`. It checks
the archive layout, x86-64 ELF type, relative RUNPATHs, bundled-library
resolution, and rejects ELF loader metadata containing absolute `/home/USER`
build paths. Source filenames used only for diagnostics may remain embedded;
they are not consulted by the dynamic loader and do not affect relocation.
An existing archive can be checked independently:

```sh
scripts/verify_ubuntu24_package.sh ~/workspace/vkvideo_ubuntu24_amd64.zip
```

If `patchelf` is not installed on the host, set `PATCHELF` to a compatible
executable (the packaging script does this automatically from its rootfs).

## Windows x64 source bundle

The Windows bundle contains the project and its exact V module dependencies.
Extract it, open `v_vulkan_video\packaging\windows\build.bat`, and run it. The
script locates Visual Studio automatically, builds shared ImGui and GLFW 3.4,
compiles the player with MSVC, and creates
`dist\vkvideo-windows-x64.zip`. It requires V 0.5.2+, CMake, Visual Studio C++
x64 tools, and a Vulkan SDK selected through `VULKAN_SDK`.

Windows playback testing on a Vulkan Video-capable GPU is currently deferred;
the remaining checks are tracked in `PLATFORM_SUPPORT.md`.
