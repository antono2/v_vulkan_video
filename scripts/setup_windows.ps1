# Prepares the installed toolchain and pinned modules, then builds the Windows player.
[CmdletBinding()]
param(
    [string]$ModulesDirectory = '',
    [string]$OutputDirectory = '',
    [ValidateSet('stable', 'v3')]
    [string]$Compiler = 'stable',
    [switch]$Check,
    [switch]$PrepareOnly
)

$ErrorActionPreference = 'Stop'
if ($Check -and $PrepareOnly) { throw 'Choose either -Check or -PrepareOnly.' }
$ProjectDirectory = Split-Path -Parent (Split-Path -Parent $PSCommandPath)
. (Join-Path $PSScriptRoot 'windows_environment.ps1')
Initialize-VkVideoWindowsEnvironment
& (Join-Path $PSScriptRoot 'check_windows.ps1') -BuildOnly
if ($Check) { return }

$ModulesDirectory = Get-VkVideoModulesDirectory $ModulesDirectory $ProjectDirectory
$env:VMODULES = $ModulesDirectory
# Released VPM cannot move temporary checkouts across drives. Always stage
# beside the selected modules, including when Windows TEMP is on another drive.
$env:VTMP = Join-Path $ModulesDirectory '.vtmp'
New-Item -ItemType Directory -Force -Path $ModulesDirectory, $env:VTMP | Out-Null
Write-Host "Preparing pinned modules at $ModulesDirectory"
Push-Location $ProjectDirectory
try {
    & v install
    if ($LASTEXITCODE -ne 0) { throw 'VPM installation failed. Resolve the reported error and rerun setup.' }
    & v run scripts/check_installed_deps.vsh
    if ($LASTEXITCODE -ne 0) { throw 'Installed dependencies do not match v.mod. See the reported module revisions.' }
    $ImguiDirectory = Join-Path $ModulesDirectory 'antono2\imgui'
    & git -C $ImguiDirectory submodule update --init --recursive
    if ($LASTEXITCODE -ne 0) { throw 'ImGui submodule preparation failed. Resolve the Git error and rerun setup.' }
} finally {
    Pop-Location
}
if ($PrepareOnly) {
    Write-Host 'Dependencies are ready. Run scripts\build_windows.ps1 to build the player.'
    return
}
& (Join-Path $PSScriptRoot 'build_windows.ps1') -ModulesDirectory $ModulesDirectory -OutputDirectory $OutputDirectory -Compiler $Compiler
Write-Host 'Use the packaged player with --list-gpus to check playback support for your video.'
