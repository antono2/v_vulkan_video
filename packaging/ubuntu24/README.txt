Vulkan Video Player - Ubuntu 24.04 LTS x86_64
================================================

Run the bundled sample:

    ./run.sh

Run another H.264 MP4 file:

    ./run.sh /absolute/path/to/video.mp4

Inspect or select Vulkan devices:

    ./run.sh --list-gpus
    ./run.sh --gpu 0 /absolute/path/to/video.mp4

No compilation or V installation is required. The package includes an Ubuntu
24.04-built Dear ImGui shared library plus the GLFW, libstdc++, and libgcc
runtimes. All bundled libraries are resolved relative to this directory, so
the archive can be extracted under any user name or path.

The test machine must have:

* Ubuntu 24.04 LTS on x86_64
* a working desktop/X11 environment
* the Vulkan loader and GPU driver supplied by the OS/GPU vendor
* Vulkan Video H.264 decode support in that driver and GPU

The Vulkan loader and GPU driver are intentionally not bundled because they
must match the machine's installed graphics driver.
