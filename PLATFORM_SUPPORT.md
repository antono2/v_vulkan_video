# Platform support

Vulkan Video support depends on all three layers: this player, the Vulkan
loader, and a GPU driver that exposes H.264 video decode for the selected GPU.
A normal Vulkan graphics driver does not necessarily provide Vulkan Video.

| Platform | Status | Notes |
| --- | --- | --- |
| Ubuntu 24.04 LTS, x86-64, X11 | Tested | Playback, metadata rotation, colour conversion, looping, resize, and shutdown tested on an NVIDIA GeForce GTX 1060. The same system's Intel HD Graphics 530 is enumerated by ANV but exposes no Vulkan Video extensions with Mesa 25.2.8. A relocatable binary ZIP is produced by `scripts/package_ubuntu24.sh`. |
| Other Linux distributions | Source-build target | Requires a Vulkan loader/driver with H.264 video decode, GLFW development files, a C/C++ toolchain, and the V compiler. Wayland-native behavior has not yet been validated; XWayland may be used by GLFW depending on its build. |
| Windows 10, x86-64 | Native build and unsupported-device startup tested | MSVC 19.50, Vulkan SDK 1.4.357, shared ImGui, and bundled GLFW 3.4 build successfully. Startup and clean capability rejection were tested on a GeForce GTX 765M; that Kepler GPU exposes no Vulkan Video extensions. Playback still requires validation on supported Windows hardware before publishing a general binary. |
| macOS | Unsupported for video decode | The UI bindings can be built for macOS, but this application requires Vulkan Video H.264 decode. Do not treat a MoltenVK graphics-capable system as proof of Vulkan Video support. |

## TODO: Windows playback validation

Further Windows testing is deferred until a machine with a Vulkan
Video-capable GPU is available. The remaining Windows work is:

- enable and validate a full-player V3 build once the published Windows V
  toolchain supports this project's `-new-compiler` invocation;
- validate H.264 playback and timing over multiple loops;
- resize and minimize repeatedly during active decoding;
- validate rotated and non-rotated video metadata;
- compare limited/full-range BT.601 and BT.709 colour with VLC;
- test orderly window-close and Escape-key shutdown;
- inspect Vulkan validation-layer output;
- verify the generated ZIP on a Windows machine without build tools installed.

The completed MSVC build and GTX 765M unsupported-device test do not satisfy
these playback checks.

The application currently decodes H.264/AVC video carried in MP4. It supports
8-bit 4:2:0 progressive Baseline, Main, and High profiles when the driver
reports a compatible Vulkan Video profile. Other codecs, chroma formats,
bit depths, and interlaced streams are rejected with an explanatory error.

B-frame picture-order parsing is covered by regression tests, but decoded
pictures are not yet retained in a separate display-order output queue.
Consequently, B-frame streams are not currently considered release-supported;
the bundled default deliberately retains the source recording's no-B-frame
structure until that queue is complete.

Unsupported media, missing Vulkan Video extensions, and incompatible GPU
profiles produce orderly diagnostics and a non-zero exit status. Unexpected
failures after Vulkan device creation (for example, allocation, swapchain, or
queue-submission failures) remain fatal because teardown from partially
recorded or submitted command buffers is not yet modeled as recoverable. These
driver/runtime failures are tracked as post-release lifecycle hardening rather
than being conflated with malformed-input handling.

Hardware is selected by capability rather than vendor name: the device must
provide graphics/presentation, the required Vulkan Video extensions, an H.264
decode queue, and a supported decode output format. The decoded-picture-buffer
and output-image mode is chosen from the modes reported by the driver.

## Software-only regression coverage

The production playback timeline and frame-progression logic are isolated from
Vulkan submission and tested with deterministic mock frame durations. These
tests cover fixed-rate and variable-rate scheduling, initial/reset behavior,
long application stalls, looping with decoder reset, and non-looping end of
stream. They run on machines with only Lavapipe/llvmpipe.

This deliberately does not advertise Vulkan Video extensions or emulate video
commands. Decoded-picture-buffer operation, image transitions, queue
synchronization, and presentation still require a real Vulkan Video device.

Before calling a platform supported for release, run at least:

- playback through multiple loops;
- continuous enlargement and reduction of the window, including minimization;
- clean window-close and Escape-key shutdown;
- rotated and non-rotated MP4 files;
- limited-range BT.601 and BT.709 material, plus full-range material;
- a device with coincident DPB/output images and one requiring distinct images;
- the package verifier where a binary package exists.
