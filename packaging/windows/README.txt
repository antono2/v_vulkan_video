Vulkan Video Player - Windows x64
=================================

Run the bundled sample with run.bat, or drag an H.264 MP4 file onto run.bat.

List or explicitly select Vulkan devices from Command Prompt:

    run.bat --list-gpus
    run.bat --gpu 0 C:\path\to\video.mp4

The Vulkan loader and GPU driver are not bundled. The installed display driver
must expose VK_KHR_video_queue, VK_KHR_video_decode_queue, and
VK_KHR_video_decode_h264. NVIDIA Vulkan Video requires a Pascal-generation GPU
or newer; a GeForce GTX 765M will report a clean unsupported-device error.
