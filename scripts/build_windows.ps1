# Builds Windows player artifacts using configured output and module directories.
param(
    [string]$OutputDirectory = "",
    [string]$ModulesDirectory = "",
    [ValidateSet("stable", "v3")]
    [string]$Compiler = "stable"
)

$ErrorActionPreference = "Stop"
Write-Host "vkvideo Windows build script revision 9"
$ProjectDirectory = Split-Path -Parent (Split-Path -Parent $PSCommandPath)
. (Join-Path $PSScriptRoot 'windows_environment.ps1')
$ModulesDirectory = Get-VkVideoModulesDirectory $ModulesDirectory $ProjectDirectory
$Antono2ModulesDirectory = Join-Path $ModulesDirectory "antono2"
if (-not (Test-Path (Join-Path $Antono2ModulesDirectory "imgui\CMakeLists.txt"))) {
    throw "ImGui module not found at $ModulesDirectory; run v install or pass -ModulesDirectory."
}
Write-Host "Using V modules at $ModulesDirectory"
if (-not $env:VULKAN_SDK -or -not (Test-Path (Join-Path $env:VULKAN_SDK "Include\vulkan\vulkan.h"))) {
    throw "Install the Vulkan SDK and run this from an environment where VULKAN_SDK is set."
}
foreach ($Command in @("v", "cmake", "cl")) {
    if (-not (Get-Command $Command -ErrorAction SilentlyContinue)) {
        throw "Required command is unavailable: $Command"
    }
}

if (-not $OutputDirectory) {
    $OutputDirectory = Join-Path $ProjectDirectory "dist\vkvideo-windows-x64"
}
$OutputDirectory = [IO.Path]::GetFullPath($OutputDirectory)
$BuildDirectory = Join-Path $ProjectDirectory ".build\windows-imgui"
$PackageDirectory = Join-Path $BuildDirectory "package\vkvideo-windows-x64"
$ImguiDirectory = Join-Path $Antono2ModulesDirectory "imgui"
$ImguiLibraryDirectory = Join-Path $ImguiDirectory "lib"
$GlfwLibraryDirectory = Join-Path $BuildDirectory 'glfw-lib'
if (Test-Path $BuildDirectory) {
    # This directory contains generated CMake state only. Starting clean also
    # prevents a failed dependency download from poisoning the next run.
    $ResolvedBuildDirectory = (Resolve-Path -LiteralPath $BuildDirectory).Path
    $ExpectedBuildDirectory = [IO.Path]::GetFullPath((Join-Path $ProjectDirectory '.build\windows-imgui'))
    if ($ResolvedBuildDirectory -ne $ExpectedBuildDirectory -or
        ((Get-Item -LiteralPath $BuildDirectory).Attributes -band [IO.FileAttributes]::ReparsePoint)) {
        throw "Refusing to remove an unexpected build directory: $ResolvedBuildDirectory"
    }
    Remove-Item -LiteralPath $ResolvedBuildDirectory -Recurse -Force
}
New-Item -ItemType Directory -Force $BuildDirectory, $PackageDirectory, $ImguiLibraryDirectory, $GlfwLibraryDirectory, $OutputDirectory | Out-Null

$CMakeArguments = @(
    "-S", $ImguiDirectory,
    "-B", $BuildDirectory,
    "-A", "x64",
    "-DSTATIC_BUILD=OFF",
    "-DVIMGUI_GLFW_PROVIDER=bundled",
    "-DVIMGUI_GLFW_VERSION=3.4",
    "-DVIMGUI_OUTPUT_DIR=$BuildDirectory\output",
    "-DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded`$<`$<CONFIG:Debug>:Debug>",
    "-DCIMGUI_NO_EXPORT=OFF",
    "-DIMGUI_FREETYPE=OFF"
)
& cmake @CMakeArguments
if ($LASTEXITCODE -ne 0) { throw "CMake configuration failed." }
cmake --build $BuildDirectory --config Release --parallel
if ($LASTEXITCODE -ne 0) { throw "Dear ImGui/GLFW build failed." }

$VimguiDll = Get-ChildItem $BuildDirectory -Recurse -Filter "vimgui.dll" | Select-Object -First 1
$VimguiLib = Get-ChildItem $BuildDirectory -Recurse -Filter "vimgui.lib" | Select-Object -First 1
$GlfwDll = Get-ChildItem $BuildDirectory -Recurse -Filter "glfw3.dll" | Select-Object -First 1
$GlfwLib = Get-ChildItem $BuildDirectory -Recurse -Filter "glfw3dll.lib" | Select-Object -First 1
$GlfwHeader = Get-ChildItem $BuildDirectory -Recurse -Filter "glfw3.h" |
    Where-Object { $_.FullName -match "glfw-src.*include.GLFW" } | Select-Object -First 1
foreach ($Artifact in (@{
    "vimgui.dll" = $VimguiDll
    "vimgui.lib" = $VimguiLib
    "glfw3.dll" = $GlfwDll
    "glfw3dll.lib" = $GlfwLib
    "GLFW/glfw3.h" = $GlfwHeader
}).GetEnumerator()) {
    if (-not $Artifact.Value) { throw "The native build did not produce $($Artifact.Key)." }
}

Copy-Item $VimguiLib.FullName (Join-Path $ImguiLibraryDirectory "vimgui.lib") -Force
Copy-Item $GlfwLib.FullName (Join-Path $GlfwLibraryDirectory "glfw3.lib") -Force
$env:VMODULES = $ModulesDirectory
$env:GLFW_INCLUDE = Split-Path -Parent (Split-Path -Parent $GlfwHeader.FullName)
$env:GLFW_LIB = $GlfwLibraryDirectory

$Executable = Join-Path $PackageDirectory "v_vulkan_video.exe"
Push-Location $ProjectDirectory
try {
    $VArguments = @()
    if ($Compiler -eq "v3") { $VArguments += "-new-compiler" }
    # Prevent windows.h from loading legacy Winsock before V's Winsock2 headers.
    $VArguments += @("-subsystem", "console", "-cc", "msvc", "-cflags", "/DWIN32_LEAN_AND_MEAN", "-cflags", "/MT", "-o", $Executable, ".")
    & v @VArguments
    if ($LASTEXITCODE -ne 0) { throw "V application build failed." }
} finally {
    Pop-Location
}

$PackageScript = Join-Path $PSScriptRoot 'package_windows.vsh'
& v run $PackageScript build $OutputDirectory $ModulesDirectory $Compiler $Executable $VimguiDll.FullName $GlfwDll.FullName
if ($LASTEXITCODE -ne 0) { throw 'Windows package assembly failed.' }
