# Dear ImGui 1.93 standard compatibility — 2026-10-28

The player now selects `antono2.imgui@v0.4.0-standard`. This explicitly selects
the standard line; the player does not use docking or platform viewports.
Other dependency and compiler pins are unchanged. Rebuild `libvimgui` from the
matching checkout; an old docking library is not ABI-compatible with this update.

## Linux verification

The generated/native 1.93 candidate was built locally with stable V 0.5.2 and
TinyCC against Vulkan 3.2.2, GLFW 2.0.1, h264 2.0.1, minimp4 2.0.0,
vkmemalloc 2.6.2 and memory 1.4.0. All four V software test files and the two
compatibility-manifest tests passed.

On an NVIDIA GeForce GTX 1060 6GB with driver 580.178.04, a private
Xvfb/Openbox window played the bundled rotated 1920×1080 clip using real Vulkan
Video H.264 decoding. Screenshot inspection confirmed correctly oriented
portrait video and the Dear ImGui demo reporting `1.93.0`/`19300`. Mouse input
expanded its Widgets and Basic panels. Resizing to 1100×760 continued playback
and rendering; Escape shut the player down successfully.

All 737 first-loop NV12 decoded frames matched FFmpeg byte-for-byte: zero
mismatched frames and maximum byte difference zero. This comparison validates
decoded coded pixels, not a general rendered-RGB or color-management reference.

`--imgui-demo` is an opt-in diagnostic overlay, with CLI regression coverage.
Closing its window returns to unobstructed video; ordinary playback remains
unchanged. The overlay exercises real UI rendering rather than only empty
ImGui frame creation/submission.

## Limits

This does not validate Windows hardware video playback, other GPU/driver
combinations, Wayland-native presentation or distinct DPB/output images.
Windows playback remains postponed. Required CI must pass before merging the
dependency update; no player release is implied by this validation.
