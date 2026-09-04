param(
    [string]$OutputDirectory = ""
)

$ErrorActionPreference = "Stop"
Write-Host "vkvideo Windows build script revision 5"
$ProjectDirectory = Split-Path -Parent (Split-Path -Parent $PSCommandPath)
$BundleDirectory = Split-Path -Parent $ProjectDirectory
$ModulesDirectory = Join-Path $BundleDirectory "modules"
if (-not (Test-Path (Join-Path $ModulesDirectory "imgui\CMakeLists.txt"))) {
    throw "Expected the bundled V modules at $ModulesDirectory"
}
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
$ImguiDirectory = Join-Path $ModulesDirectory "imgui"
$ImguiLibraryDirectory = Join-Path $ImguiDirectory "lib"
$GlfwLibraryDirectory = Join-Path $ModulesDirectory "glfw\lib"
if (Test-Path $BuildDirectory) {
    # This directory contains generated CMake state only. Starting clean also
    # prevents a failed dependency download from poisoning the next run.
    Remove-Item $BuildDirectory -Recurse -Force
}
New-Item -ItemType Directory -Force $BuildDirectory, $ImguiLibraryDirectory, $GlfwLibraryDirectory, $OutputDirectory | Out-Null

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

$Executable = Join-Path $OutputDirectory "v_vulkan_video.exe"
Push-Location $ProjectDirectory
try {
    v -cc msvc -cflags /MT -o $Executable .
    if ($LASTEXITCODE -ne 0) { throw "V application build failed." }
} finally {
    Pop-Location
}

Copy-Item $VimguiDll.FullName $OutputDirectory -Force
Copy-Item $GlfwDll.FullName $OutputDirectory -Force
New-Item -ItemType Directory -Force (Join-Path $OutputDirectory "res") | Out-Null
Copy-Item (Join-Path $ProjectDirectory "res\20240917_095400.mp4") (Join-Path $OutputDirectory "res\sample.mp4") -Force
Copy-Item (Join-Path $ProjectDirectory "packaging\windows\run.bat") $OutputDirectory -Force
Copy-Item (Join-Path $ProjectDirectory "packaging\windows\README.txt") $OutputDirectory -Force

$ZipPath = "$OutputDirectory.zip"
if (Test-Path $ZipPath) { Remove-Item $ZipPath -Force }
Compress-Archive -Path $OutputDirectory -DestinationPath $ZipPath
Write-Host "Built Windows package: $ZipPath"
