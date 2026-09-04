Run

  ./run.sh [--list-gpus] [--gpu INDEX] [video.mp4]

The bundled sample is used when the path is omitted. Debug builds enable the
Khronos validation layer and print Vulkan validation messages.

`--list-gpus` reports every Vulkan device and whether it can decode the input
video's H.264 profile. `--gpu INDEX` selects one of those devices explicitly.

Requires

sudo apt install libimgui-dev
