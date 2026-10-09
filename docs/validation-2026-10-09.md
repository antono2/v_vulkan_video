# Release-candidate validation — 2026-10-09

## Release graph

The 0.3.0-rc2 candidate uses Vulkan 3.2.2, GLFW 2.0.1, ImGui 0.3.1,
h264 2.0.1, minimp4 2.0.0, vkmemalloc 2.6.2 and memory 1.4.0.
The recursive installed-dependency check verified all seven tag commits locally.
Required CI now performs the same check, including transitive pins. It caught
and corrected the previous required workflow's stale GLFW 2.0.0 checkout.
Current V and dependency masters remain advisory.

## Linux hardware regression

Stable V 0.5.2 (`7647ce1`) and GCC built the candidate with this release graph;
all four software test files passed. On an NVIDIA GeForce GTX 1060 6GB with
driver 580.178.04, the following first-loop NV12 readbacks matched FFmpeg with
zero mismatched frames and zero byte difference:

| Input | Frames | Coded dimensions |
| --- | ---: | --- |
| Parameter-set ID 7 | 5 | 160 × 96 |
| Multislice | 24 | 320 × 180 |
| Elephants Dream landscape | 240 | 1280 × 720 |
| Big Buck Bunny 360p with B-frames | 300 | 640 × 360 |
| Rotated default clip | 737 | 1920 × 1080 |
| Total | 1,306 | |

The comparison disables FFmpeg autorotation, so it verifies decoded coded
pixels rather than rendered colour conversion or orientation. Private
Xvfb/Openbox windows exercised continued looping, resize, minimize/restore,
Escape shutdown and window-manager close; all five player processes exited
with status 0. Escape was held briefly so the frame-polled key check could
observe it. These checks use real NVIDIA Vulkan Video decoding.

## Scope and release gate

Publish the Ubuntu 24.04 packages only from a passing release CI run for the
candidate revision, preserving embedded build information and checksums. The
hardware regression above uses a local build; verify the downloaded release
package separately before publication. Required CI covers stable and pinned V3
on Linux and Windows, shared/static Linux builds and fresh module installation.

This follow-up does not extend the earlier rendered-RGB or manual visual
results. Windows hardware playback, Wayland-native behavior, distinct
DPB/output images and other GPU drivers remain outside this hardware claim.
Windows build artifacts are CI validation inputs; supported Windows playback
hardware is still needed before a general Windows binary release.
