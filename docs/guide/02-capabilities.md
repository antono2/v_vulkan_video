# 2. Select a device from the video's requirements

“Supports Vulkan” is too broad a device test. A player needs a graphics queue
that can present to its window, an H.264 decode queue, the Vulkan Video
extensions, a compatible profile and picture layout, and usable image formats.
The chosen MP4 may require a profile that another file does not.

## The selection path

After parsing, [`VideoDecodeApp.initialize`](../../app.v#L147) obtains the stream's
[decode requirements](../../video_player.v#L603): profile, level, coded extent,
DPB slots, and active references. It asks
[`h264_decode_gpu_diagnostics_for_output_mode`](../../device_context.v#L419)
for diagnostics for every GPU. [`--list-gpus`](../../app.v#L187) exposes those
diagnostics to the user. A forced [`--gpu` index](../../app.v#L202) is checked
against the same requirements; otherwise the first
compatible device is chosen. Errors name the missing capability instead of
assuming that a graphics-capable GPU can decode.

The [stream probe](../../device_context.v#L526) checks the queried H.264 level,
coded extent, DPB and active reference limits, selected output mode, and output/DPB
formats with the image usages the session will actually create. It runs before
logical device creation, so a second GPU can be tried when the first one
cannot satisfy the particular video.

The SPS stores level 4.0 as `level_idc = 40`; Vulkan's
[`StdVideoH264LevelIdc` conversion](../../device_context.v#L52) maps it to
the enum value used in session parameters. The
[level check](../../device_context.v#L77) compares that enum against the
device's `maxLevelIdc`, and reports the required and supported levels before
creating a session.

The [SPS macroblock dimensions](../../mp4_parser.v#L143) supply the coded
extent, which can be larger than the visible image after H.264 cropping.
The [session extent](../../decoder_session.v#L116) and
[decode picture resources](../../player_decode.v#L467) use those coded
dimensions; the [display copy](../../player_decode.v#L271) uses the visible
dimensions.

[`initialize_device`](../../device_context.v#L154) then chooses queue families and
creates the logical device with the required extensions. It builds a
[VideoProfileInfoKHR](../../device_context.v#L272) for progressive 8-bit 4:2:0 H.264 and chains H.264
profile and capability structs through `pNext`. Vulkan Video format queries
use the same profile. A format is useful only if it supports the image usages
required by the next step, including transfer out of the decoded picture in
this design.

The player accepts the two advertised DPB/output modes. In *coincident* mode,
the decoded output is a DPB image. In *distinct* mode, the output and DPB
images are separate. `auto` prefers coincident and falls back to distinct;
forced modes aid driver validation and fail if unsupported. The choice is made
by [`select_decode_output_mode`](../../video_player.v#L18), with software tests
for [automatic fallback](../../video_player_test.v#L333) and
[forced modes](../../video_player_test.v#L338).

```mermaid
flowchart TD
    Stream[Parsed H.264 profile and dimensions] --> Extensions[Required extensions]
    Extensions --> Queues[Presenting graphics and H.264 decode queues]
    Queues --> Profile[Profile capabilities and limits]
    Profile --> Mode[Coincident or distinct output mode]
    Mode --> Formats[Output and DPB formats with required usages]
    Formats --> Device[Create device and decoder]
```

**Invariant:** the profile and image usage used for capability queries must
match the resources later created. A successful generic Vulkan device
creation is not proof that a video session or its images will work.

## Apply the selection pattern elsewhere

Build a requirement record from the content first: codec, profile, bit depth,
chroma, coded extent, and any presentation requirements. Probe candidates
against that record. For an editor handling many clips, the policy might be
“choose one device that handles every clip” or “select a backend per clip.” For
a game that uses video only for optional cutscenes, software decode could be
a fallback. Each policy changes when and how compatibility failures should
be reported.

The application has one window and chooses one GPU. Multi-GPU transfer,
software fallback, and runtime format changes are outside its current design.
See [platform support](../../PLATFORM_SUPPORT.md) before treating a successful
build as playback support.
