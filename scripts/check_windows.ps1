# Reports missing Windows build prerequisites before compiling the player.
param([switch]$BuildOnly)

$ErrorActionPreference = "Stop"
$Missing = $false

$Commands = @('v', 'git', 'cmake', 'cl')
if (-not $BuildOnly) { $Commands += 'vulkaninfo' }
foreach ($Command in $Commands) {
    if (Get-Command $Command -ErrorAction SilentlyContinue) {
        Write-Host "[ok]      $Command"
    } else {
        Write-Host "[missing] $Command"
        $NextSteps = @{
            v = 'Install the official V compiler and add it to PATH.'
            git = 'Install Git: winget install --id Git.Git -e'
            cmake = 'Install CMake: winget install --id Kitware.CMake -e'
            cl = 'Run scripts\setup_windows.ps1 to discover installed Visual Studio C++ tools.'
            vulkaninfo = 'Install the LunarG Vulkan SDK and add its Bin directory to PATH.'
        }
        Write-Host "          $($NextSteps[$Command])"
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

if (-not $BuildOnly -and (Get-Command vulkaninfo -ErrorAction SilentlyContinue)) {
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
if ($BuildOnly) {
    Write-Host 'Build prerequisites look usable. Hardware decoding is checked separately with the player --list-gpus.'
} else {
    Write-Host 'Build tools and video extensions were found. Use the player --list-gpus to check a specific GPU and video profile.'
}
