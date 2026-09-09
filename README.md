# v_vulkan_video

[Project portfolio](https://oreskin.de/projects_en.php)

An H.264/AVC MP4 video player written in V using Vulkan Video decode. It uses
the video's display metadata for aspect ratio and rotation, selects a capable
GPU by its advertised Vulkan Video profile, and loops by default.

The current release baseline supports progressive 8-bit 4:2:0 H.264 Baseline,
Main, and High profiles, including streams with B-frames. Decoding remains in
H.264 reference order while a bounded output-image queue presents pictures in
display order. It has been exercised on Ubuntu 24.04 with an NVIDIA GeForce GTX
1060, including repeated resizing, looping, and orderly shutdown.
The Vulkan loader and installed GPU driver must expose H.264 Vulkan Video
decode; an ordinary Vulkan graphics implementation is not sufficient.

## Run

```sh
./v_vulkan_video [--list-gpus] [--gpu INDEX] [--decode-output-mode MODE] [video.mp4]
```

To compile and run directly from a source checkout, target the repository root:

```sh
v run . [--list-gpus] [--gpu INDEX] [--decode-output-mode MODE] [video.mp4]
```

`examples/video_decode_app` is the application's importable module rather than
a standalone `main` package, so it is not a direct `v run` target.

Without a video path, the bundled self-recorded and metadata-sanitized sample
is used. `--list-gpus` reports compatibility against the selected video's
actual H.264 profile.

`--decode-output-mode auto|coincident|distinct` selects how decoded pictures
are stored. `auto` prefers coincident DPB/output images and falls back to
distinct images. The forced modes are useful for driver validation and fail
with an explanatory error when the selected device does not advertise them.

For a known-supported landscape example, use the bundled 720p Elephants Dream
excerpt:

```sh
v run . res/Elephants_Dream_720p30_8s_CC-BY.mp4
```

This fixture is H.264 High Profile, 1280x720 at 30 fps, limited-range BT.709,
and contains no B-frames. Its source and CC BY attribution are documented in
[res/README.md](res/README.md).

The bundled Big Buck Bunny fixtures exercise B-frame playback at 360p, 720p,
and 1080p. For example:

```sh
v run . res/Big_Buck_Bunny_720_10s_1MB.mp4
```

## Build and packages

For a first install, start with [QUICKSTART.md](QUICKSTART.md). It has short
paths for Ubuntu/Debian, Fedora, and Windows, plus read-only prerequisite
checks and an opt-in Ubuntu dependency installer.

See [BUILDING.md](BUILDING.md) for shared/static ImGui choices, system or
bundled GLFW selection, Ubuntu 24 binary packaging, and the Windows x64 source
workflow.

See [PLATFORM_SUPPORT.md](PLATFORM_SUPPORT.md) for tested hardware, known
limitations, and the release-validation matrix.

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
