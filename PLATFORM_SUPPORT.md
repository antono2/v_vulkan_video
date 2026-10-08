# Platform support

Vulkan Video support depends on all three layers: this player, the Vulkan
loader and a GPU driver that exposes H.264 video decode for the selected GPU.
A normal Vulkan graphics driver does not necessarily provide Vulkan Video.

| Platform | Status | Notes |
| --- | --- | --- |
| Ubuntu 24.04 LTS, x86-64, X11 | Tested | Playback, metadata rotation, colour conversion, looping, resize and shutdown tested on an NVIDIA GeForce GTX 1060. The same system's Intel HD Graphics 530 is enumerated by ANV but exposes no Vulkan Video extensions with Mesa 25.2.8. A relocatable binary ZIP is produced by `scripts/package_ubuntu24.sh`. |
| Other Linux distributions | Source-build target | Requires a Vulkan loader/driver with H.264 video decode, GLFW development files, a C/C++ toolchain and the V compiler. Wayland-native behavior has not yet been validated; XWayland may be used by GLFW depending on its build. |
| Windows 10, x86-64 | Native build and unsupported-device startup tested | MSVC 19.50, Vulkan SDK 1.4.357, shared ImGui and bundled GLFW 3.4 build successfully. Startup and clean capability rejection were tested on a GeForce GTX 765M; that Kepler GPU exposes no Vulkan Video extensions. Playback still requires validation on supported Windows hardware before publishing a general binary. |
| macOS | Unsupported for video decode | The UI bindings can be built for macOS, but this application requires Vulkan Video H.264 decode. Do not treat a MoltenVK graphics-capable system as proof of Vulkan Video support. |

Linux V3 has a required pinned CI job that builds the complete player with
TinyCC, runs the software tests and checks `--help` and Vulkan device discovery
under Xvfb with Lavapipe. An advisory job repeats those checks with current V
and dependency masters. These software-driver checks do not test video decode.
With V master at `b99970bd438a7bdcdfbe38f74d9364db801d5439`, the complete
player builds with TinyCC and its three software-only test files pass. On the
Linux GTX 1060, V3/TinyCC decoded the ID-7 fixture (5 frames) and multislice
fixture (24 frames) byte-for-byte identically to FFmpeg and exited cleanly on
Escape. The player uses the binding's loader initialization and passes the
swapchain semaphore by value. Raw Volk initialization can collide with Linux
TinyCC's exported dispatch variables; a mutable handle parameter was lowered
to its address by this compiler. Stable V remains the release compiler while
broader V3 hardware and platform coverage is completed.

On Windows, source-built V master at `b99970bd438a7bdcdfbe38f74d9364db801d5439`
passed the V3/MSVC package build, all three software test files, `--help`,
`--list-gpus` and archive verification. CI builds and tests stable and pinned
V3 packages separately. The GTX 765M capability rejection confirms the
unsupported-device path, not hardware decoding support.

## Linux release-candidate regression (2026-10-02)

On the GTX 1060 6GB with NVIDIA driver 580.178.04, the stable V 0.5.2/GCC
candidate using minimp4 v2.0.0, h264 v2.0.0 and vkmemalloc v2.6.1 matched
FFmpeg exactly for the ID-7 (5 frames), multislice (24), landscape (240),
360p B-frame (300) and rotated default (737) fixtures: 1,306 frames in total.
NV12 comparisons use coded pixels, with FFmpeg display autorotation disabled.

Managed isolated X11/Xvfb windows exercised looping, resize, minimize/restore,
Escape shutdown and window-manager close. Real NVIDIA Vulkan Video hardware
performed the decode; these automated checks do not repeat the rendered-RGB
spot comparisons described below or validate another compositor or driver.
The diagnostic candidate loaded the Khronos validation layer and completed
the short-fixture checks without reported Vulkan validation errors.

V3/TinyCC at `0dc6a692ed5333cbe3f05ff63ae0766f0333038a` initially boxed an
untyped null in the swapchain image-count query and failed during startup.
With the explicit typed-null workaround, all 29 ID-7/multislice frames matched
FFmpeg, and the managed-window lifecycle checks passed. The swapchain now also
checks count/fill results rather than indexing an empty image array.

This GPU supports coincident DPB/output images only. A forced distinct-image
request was rejected cleanly with an explanatory diagnostic and exit code 1;
that is not a validation of distinct-mode playback. The player has no
user-facing seek control, so seeking is not part of this regression claim.

## TODO: Windows playback validation

Further Windows testing is deferred until a machine with a Vulkan
Video-capable GPU is available. The remaining Windows work is:

- validate H.264 playback and timing over multiple loops;
- resize and minimize repeatedly during active decoding;
- validate rotated and non-rotated video metadata;
- compare limited/full-range BT.601 and BT.709 colour with VLC;
- test orderly window-close and Escape-key shutdown;
- inspect Vulkan validation-layer output;
- verify the generated ZIP on a Windows machine without build tools installed.

The completed MSVC build and GTX 765M unsupported-device test do not satisfy
these playback checks.

## Supported media and failure behavior

The application currently decodes H.264/AVC video carried in MP4. It supports
8-bit 4:2:0 progressive Baseline, Main and High profiles when the driver
reports a compatible Vulkan Video profile. Other codecs, chroma formats,
bit depths and interlaced streams are rejected with an explanatory error.
Picture-order-count types 0, 1 and 2 are calculated for progressive frames.
Separate top and bottom order counts are supplied to Vulkan references.
The DPB applies sliding-window marking and explicit MMCO 1–6, including
long-term references. The bundled 360p stream exercises MMCO 1 on the tested
Linux GPU. The external `MR2_TANDBERG_E` conformance stream exercises MMCO 5
and long-term operations 3, 4 and 6; `FRExt_MMCO4_Sony_B` exercises long-term
operations 2, 3, 4 and 6. On the Linux GTX 1060, decoded NV12 output matched
FFmpeg byte for byte for all 300 Tandberg frames and all 60 Sony frames. The
bundled four-slice and ID-7 fixtures also matched for all 24 and 5 frames.
The Sony comparison exposed a scaling-list bug: the pinned H.264 parser set
the SPS list-presence flags but left the list values at zero. The player now
[fills the validated lists](h264_parameter_sets.v#L77) before creating
[Vulkan session parameters](decoder_session.v#L303).

AVC samples with 1, 2 or 4 byte NAL length prefixes are accepted. The parser
skips metadata-only samples, checks every slice in a sample belongs to the
same picture and reports invalid slice references before creating a Vulkan
device. SPS/PPS preflight checks truncated syntax and the pinned parser's
fixed-array limits. The pinned H.264 module's weighted-prediction reader is
corrected in this application's checked slice reader. Device selection also
checks the stream's H.264 level against the GPU's reported maximum.

B-frame streams are decoded in codec order and retained in a bounded image
queue until they become next in presentation order. The queue size is derived
from the parsed stream and includes extra images for in-flight swapchain work;
retired images are not reused until the graphics submissions that sampled them
have completed. The bundled Big Buck Bunny fixtures cover this path at 360p,
720p and 1080p.

Unsupported media, missing Vulkan Video extensions and incompatible GPU
profiles produce orderly diagnostics and a non-zero exit status. The pinned
H.264 parser and this application's preflight do not validate every semantic
relationship inside arbitrarily corrupted SPS/PPS bitstreams. Failures after
Vulkan device creation (for example, allocation, swapchain or queue-submission
failures) remain fatal because teardown from
partially recorded or submitted command buffers is not yet modeled as
recoverable. These driver/runtime failures are tracked as post-release
lifecycle hardening rather than being conflated with malformed-input handling.

Hardware is selected by capability rather than vendor name: the device must
provide graphics/presentation, the required Vulkan Video extensions, an H.264
decode queue, coded extent and reference limits and output/DPB formats with
the required image usages. The decoded-picture-buffer
and output-image mode is chosen from the modes reported by the driver. Use
`--decode-output-mode coincident` or `--decode-output-mode distinct` to force a
specific advertised path during compatibility testing; `auto` remains the
default.

## Software-only regression coverage

The production playback timeline and frame-progression logic are isolated from
Vulkan submission and tested with deterministic mock frame durations. These
tests cover fixed-rate and variable-rate scheduling, initial/reset behavior,
long application stalls, looping with decoder reset and non-looping end of
stream. They run on machines with only Lavapipe/llvmpipe.

This deliberately does not advertise Vulkan Video extensions or emulate video
commands. Decoded-picture-buffer operation, image transitions, queue
synchronization and presentation still require a real Vulkan Video device.

## Hardware validation checklist

To repeat the H.264 reference-marking smoke check, download the
[MR2 Tandberg stream](https://dev.gentoo.org/~lu_zero/fate/h264-conformance/MR2_TANDBERG_E.264)
and the
[FRExt Sony stream](https://dev.gentoo.org/~lu_zero/fate/h264-conformance/FRext/FRExt_MMCO4_Sony_B.264),
then remux them to MP4 without transcoding:

```sh
ffmpeg -r 30 -i MR2_TANDBERG_E.264 -c:v copy MR2_TANDBERG_E.mp4
ffmpeg -r 25 -i FRExt_MMCO4_Sony_B.264 -c:v copy FRExt_MMCO4_Sony_B.mp4
./v_vulkan_video MR2_TANDBERG_E.mp4
./v_vulkan_video FRExt_MMCO4_Sony_B.mp4
```

The files are external conformance media and are not included in the repository.
Inspect `memory_management_control_operation` with FFmpeg's `trace_headers`
bitstream filter to confirm which operations each stream contains.

To compare decoded pixels, set `VV_DUMP_NV12_DIR` to an empty directory before
running the player. The [readback path](frame_readback.v#L48) copies the first
playback loop's decoded images to display-order `N.nv12` files. Run the
[comparison script](scripts/compare_nv12.py#L25) against the original H.264
elementary stream for the Sony case: FFmpeg's MP4 remux has nonmonotonic
timestamps and drops frames when exporting raw video.

The comparison disables FFmpeg's display autorotation: NV12 readback contains
coded-image pixels before the player's presentation transform. This also
allows a rotated MP4 to be compared without confusing display orientation
with a decode mismatch.

```sh
VV_DUMP_NV12_DIR=/tmp/sony-nv12 ./v_vulkan_video FRExt_MMCO4_Sony_B.mp4
python3 scripts/compare_nv12.py FRExt_MMCO4_Sony_B.264 /tmp/sony-nv12
```

The readback waits for decode fences, invalidates mapped memory and writes
only the first playback loop. It costs extra GPU memory and stalls that loop;
leave the environment variable unset for normal playback. An exact match
checks decoded NV12 bytes and display order on this GPU. It does not verify
the YCbCr-to-RGB rendering or another driver's decode implementation.

The rendered window was checked separately on the same GPU. An X11 capture of
the bundled ID-7 color-bar fixture (BT.601 limited-range fallback) was compared
with FFmpeg's RGB output at nine interior pixels. A generated H.264
`smptehdbars` clip signaling BT.709 and full range was compared at eight
interior pixels, with FFmpeg's scale filter explicitly set to BT.709/full
input. The largest per-channel difference was 2 in 8-bit RGB in both checks.
These spot checks cover the two indicated conversion paths, not every output
pixel, chroma edge, display compositor or GPU driver.

Before calling a platform supported for release, run at least:

- playback through multiple loops;
- continuous enlargement and reduction of the window, including minimization;
- clean window-close and Escape-key shutdown;
- rotated and non-rotated MP4 files;
- limited-range BT.601 and BT.709 material, plus full-range material;
- a device with coincident DPB/output images and one requiring distinct images;
- the package verifier where a binary package exists.
