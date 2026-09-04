# Test media

`20240917_095400.mp4` is a self-recorded video supplied by the project owner
for use as the player's default and regression fixture. The published copy is
a metadata-stripped transcode containing only the video stream. It preserves
the properties exercised by the player: H.264 High Profile, progressive 8-bit
4:2:0, 1920x1080 coded dimensions, a -90 degree display matrix, square pixels,
and limited-range BT.709 colour metadata.

The sanitized file has 737 frames at 30 frames per second and uses an average
video bitrate of approximately 5 Mbit/s. It retains the source recording's
no-B-frame structure; B-frame parser coverage is provided by the Big Buck
Bunny fixtures below. Its SHA-256 digest is:

```text
796da05615010a2206e2fb17b7cecb4b7395d503620138f5eb2074eff85f5c55
```

The `Big_Buck_Bunny_*_10s_1MB.mp4` files exercise parser behavior at several
resolutions. Big Buck Bunny is (c) copyright 2008 Blender Foundation and is
available under the Creative Commons Attribution 3.0 license.
