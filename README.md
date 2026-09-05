# v_vulkan_video

An H.264/AVC MP4 video player written in V using Vulkan Video decode. It uses
the video's display metadata for aspect ratio and rotation, selects a capable
GPU by its advertised Vulkan Video profile, and loops by default.

The current release baseline supports progressive 8-bit 4:2:0 H.264 Baseline,
Main, and High profiles. It has been exercised on Ubuntu 24.04 with an NVIDIA
GeForce GTX 1060, including repeated resizing, looping, and orderly shutdown.
The Vulkan loader and installed GPU driver must expose H.264 Vulkan Video
decode; an ordinary Vulkan graphics implementation is not sufficient.

## Run

```sh
./v_vulkan_video [--list-gpus] [--gpu INDEX] [video.mp4]
```

Without a video path, the bundled self-recorded and metadata-sanitized sample
is used. `--list-gpus` reports compatibility against the selected video's
actual H.264 profile.

## Build and packages

For a first install, start with [QUICKSTART.md](QUICKSTART.md). It has short
paths for Ubuntu/Debian, Fedora, and Windows, plus read-only prerequisite
checks and an opt-in Ubuntu dependency installer.

See [BUILDING.md](BUILDING.md) for shared/static ImGui choices, system or
bundled GLFW selection, Ubuntu 24 binary packaging, and the Windows x64 source
workflow.

See [PLATFORM_SUPPORT.md](PLATFORM_SUPPORT.md) for tested hardware, known
limitations, and the release-validation matrix. In particular, B-frame POC
parsing is tested, but a separate display-order output-image queue is still
required before B-frame playback is release-supported.

## Tests

```sh
v test .
```

The software-only tests cover MP4 metadata and validation, H.264 picture order,
malformed and truncated inputs, playback timing, looping, and command-line
parsing. Vulkan decode, synchronization, resize, and presentation still
require hardware with Vulkan Video support.

## License

The source is available under the MIT License. Test-media attribution and
provenance are documented in [res/README.md](res/README.md).
