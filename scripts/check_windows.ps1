$ErrorActionPreference = "Stop"
$Missing = $false

foreach ($Command in @("v", "git", "cmake", "cl", "vulkaninfo")) {
    if (Get-Command $Command -ErrorAction SilentlyContinue) {
        Write-Host "[ok]      $Command"
    } else {
        Write-Host "[missing] $Command"
        $Missing = $true
    }
}

if (-not $env:VULKAN_SDK) {
    Write-Host "[missing] VULKAN_SDK environment variable"
    $Missing = $true
} elseif (-not (Test-Path (Join-Path $env:VULKAN_SDK "Include\vulkan\vulkan.h"))) {
    Write-Host "[failed]  VULKAN_SDK does not contain Vulkan headers: $env:VULKAN_SDK"
    $Missing = $true
} else {
    Write-Host "[ok]      VULKAN_SDK=$env:VULKAN_SDK"
}

if (Get-Command vulkaninfo -ErrorAction SilentlyContinue) {
    $Info = (& vulkaninfo 2>&1 | Out-String)
    foreach ($Extension in @("VK_KHR_video_queue", "VK_KHR_video_decode_queue", "VK_KHR_video_decode_h264")) {
        if ($Info.Contains($Extension)) {
            Write-Host "[ok]      $Extension advertised"
        } else {
            Write-Host "[missing] $Extension (driver/GPU capability)"
            $Missing = $true
        }
    }
}

if ($Missing) {
    Write-Error "One or more requirements are unavailable. See QUICKSTART.md."
}
Write-Host "Build and Vulkan Video prerequisites look usable."
