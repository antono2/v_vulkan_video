# Test media

`20240917_095400.mp4` is a self-recorded video supplied by the project owner
for use as the player's default and regression fixture. The published copy is
a metadata-stripped transcode containing only the video stream. It preserves
the properties exercised by the player: H.264 High Profile, progressive 8-bit
4:2:0, 1920x1080 coded dimensions, a -90 degree display matrix, square pixels,
and limited-range BT.709 colour metadata.

The sanitized file has 737 frames at 30 frames per second and uses an average
video bitrate of approximately 5 Mbit/s. It retains the source recording's
no-B-frame structure; B-frame parsing and display-order playback are exercised
by the Big Buck Bunny fixtures below. Its SHA-256 digest is:

```text
796da05615010a2206e2fb17b7cecb4b7395d503620138f5eb2074eff85f5c55
```

The `Big_Buck_Bunny_*_10s_1MB.mp4` files exercise B-frame parsing and playback
at several resolutions. Big Buck Bunny is (c) copyright 2008 Blender
Foundation and is available under the Creative Commons Attribution 3.0
license. These files omit H.264 colour-description metadata; the player uses
its documented HD/SD YCbCr-matrix fallback for such streams.

`Elephants_Dream_720p30_8s_CC-BY.mp4` is the known-supported landscape playback
example. The 1280x720, 30 fps, H.264 High Profile stream is progressive 8-bit
4:2:0 with no B-frames, no audio, and limited-range BT.709 colour metadata.
720p was chosen as a useful landscape baseline that remains small enough for a
source repository. The eight-second file contains 240 frames and has this
SHA-256 digest:

```text
2c0525581a6783973b7200a4c6926338ee4d818a1bcbdabfc27567a5d6cd235d
```

It was derived from seconds 54 through 62 of the official
[`elephantsdream_teaser.mp4.zip`](https://download.blender.org/demo/movies/elephantsdream_teaser.mp4.zip)
download with:

```sh
ffmpeg -ss 54 -i elephantsdream_teaser.mp4 -t 8 -an \
  -vf 'fps=30,scale=1280:720:flags=lanczos:in_color_matrix=smpte170m:out_color_matrix=bt709' \
  -c:v libx264 -preset slow -crf 21 -profile:v high -bf 0 \
  -g 60 -keyint_min 60 -sc_threshold 0 -pix_fmt yuv420p \
  -color_range tv -colorspace bt709 -color_primaries bt709 \
  -color_trc bt709 -movflags +faststart \
  Elephants_Dream_720p30_8s_CC-BY.mp4
```

*Elephants Dream* is (c) copyright 2006 Blender Foundation / Netherlands Media
Art Institute / [elephantsdream.org](https://orange.blender.org/) and is
licensed under
[Creative Commons Attribution 2.5](https://creativecommons.org/licenses/by/2.5/).
