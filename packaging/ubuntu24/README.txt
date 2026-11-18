Vulkan Video Player - Ubuntu 24.04 LTS x86_64
================================================

Run the bundled sample:

    ./v_vulkan_video

Run another H.264 MP4 file:

    ./v_vulkan_video /absolute/path/to/video.mp4

Inspect or select Vulkan devices:

    ./v_vulkan_video --list-gpus
    ./v_vulkan_video --gpu 0 /absolute/path/to/video.mp4
    ./v_vulkan_video --decode-output-mode coincident /absolute/path/to/video.mp4

No compilation or V installation is required. The package includes an Ubuntu
24.04-built Dear ImGui shared library plus the GLFW, libstdc++ and libgcc
runtimes. All bundled libraries are resolved relative to this directory, so
the archive can be extracted under any user name or path.

Relative RUNPATHs load the bundled application libraries without requiring
LD_LIBRARY_PATH or overriding dependencies used by the installed Vulkan driver.

BUILD-INFO.txt records the source/compiler/module revisions. LICENSE,
MEDIA.txt and licenses/ retain the project, test-media and dependency
notices. Check the archive's accompanying .sha256 file before extraction.

The test machine must have:

* Ubuntu 24.04 LTS on x86_64
* a working desktop/X11 environment
* the Vulkan loader and GPU driver supplied by the OS/GPU vendor
* Vulkan Video H.264 decode support in that driver and GPU

The Vulkan loader and GPU driver are intentionally not bundled because they
must match the machine's installed graphics driver.
