# Quick start

The shortest route is the pre-built Ubuntu 24.04 x86-64 ZIP from the GitHub
release. Extract it and run `./run.sh`. The archive includes the player and its
ordinary user-space libraries; the Vulkan loader and GPU driver remain system
components because they must match the machine.

Before building from source, check that the machine can run the player:

```sh
./scripts/setup_linux.sh --check
```

The important result is not merely that Vulkan works. The selected driver must
advertise `VK_KHR_video_queue`, `VK_KHR_video_decode_queue`, and
`VK_KHR_video_decode_h264`.

## Ubuntu 24.04 and Debian-based Linux

Install the native build dependencies (the script prints the command before it
uses `sudo`):

```sh
./scripts/setup_linux.sh --install
```

Install the [V compiler](https://github.com/vlang/v), then from this checkout:

```sh
./scripts/build_linux.sh
./v_vulkan_video
```

Use `./scripts/build_linux.sh --compiler v3` to build the full player with V3.
V3 is supported, but is still an opt-in V compiler mode. The wrapper also
offers `--linkage static` and `--glfw bundled --glfw-version 3.4`; run it with
`--help` for all choices.

## Fedora

Install `@development-tools`, `cmake`, `git`, `luajit`, `glfw-devel`,
`vulkan-loader-devel`, `vulkan-headers`, `volk-devel`, and `vulkan-tools`, then use the same
`v install`, ImGui build, and player build commands shown above. Package names
can vary between Fedora releases, so `setup_linux.sh --install` currently
limits automatic installation to Debian-family systems.

## Windows 10/11 x64

Install:

- the V compiler and Git;
- Visual Studio 2022 Build Tools with **Desktop development with C++**;
- CMake;
- the LunarG Vulkan SDK; and
- a current GPU driver with Vulkan Video H.264 decode support.

Open **x64 Native Tools Command Prompt for VS 2022**, ensure `v`, `cmake`, and
`VULKAN_SDK` are available, and run:

```powershell
powershell -ExecutionPolicy Bypass -File scripts\check_windows.ps1
v install
git -C "$env:USERPROFILE\.vmodules\imgui" submodule update --init --recursive
powershell -ExecutionPolicy Bypass -File scripts\build_windows.ps1
```

The build script produces `dist\vkvideo-windows-x64.zip`. Windows compilation
and unsupported-device diagnostics are tested; playback validation on a
Vulkan-Video-capable Windows GPU remains a release TODO.

## macOS

The player is not currently supported. MoltenVK provides Vulkan graphics
portability, but not the Vulkan Video H.264 decode path required by this app.

## Running and troubleshooting

```sh
./v_vulkan_video --list-gpus video.mp4
./v_vulkan_video --gpu 0 video.mp4
```

The player currently accepts progressive 8-bit 4:2:0 H.264 in MP4. A GPU may
be excellent at Vulkan graphics and still lack Vulkan Video decoding. On a
laptop with multiple GPUs, `--list-gpus` distinguishes the compatible device
from graphics-only devices. See [PLATFORM_SUPPORT.md](PLATFORM_SUPPORT.md) for
the tested matrix and media limitations.
