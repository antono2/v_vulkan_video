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
$Pins = Get-Content (Join-Path $ProjectDirectory 'compatibility.json') -Raw | ConvertFrom-Json
if ($Pins.schema_version -ne 1) { throw 'Unsupported compatibility manifest schema.' }
foreach ($Match in [regex]::Matches((Get-Content (Join-Path $ProjectDirectory 'v.mod') -Raw), "'antono2\.([a-z0-9_]+)@([^']+)'")) {
    if ($Pins.modules.($Match.Groups[1].Value) -ne $Match.Groups[2].Value) { throw 'v.mod and compatibility.json disagree.' }
}
. (Join-Path $PSScriptRoot 'windows_environment.ps1')
Initialize-VkVideoWindowsEnvironment
& (Join-Path $PSScriptRoot 'check_windows.ps1') -BuildOnly
if ($Check) { return }

$ModulesDirectory = Get-VkVideoModulesDirectory $ModulesDirectory $ProjectDirectory
$env:VMODULES = $ModulesDirectory
# Released VPM cannot move temporary checkouts across drives. Always stage
# beside the selected modules, including when Windows TEMP is on another drive.
$env:VTMP = Join-Path (Join-Path $ModulesDirectory '.vtmp') ([Guid]::NewGuid().ToString('N').Substring(0, 8))
New-Item -ItemType Directory -Force -Path $ModulesDirectory, $env:VTMP | Out-Null
Write-Host "Preparing pinned modules at $ModulesDirectory"
Push-Location $ProjectDirectory
try {
    Invoke-VkVideoGitLongPaths {
        # Older VPM releases can replace installed modules. Fail before invoking
        # them if an existing checkout contains unpublished work.
        $NamespaceDirectory = Join-Path $ModulesDirectory 'antono2'
        if (Test-Path -LiteralPath $NamespaceDirectory) {
            foreach ($ModuleDirectory in Get-ChildItem -LiteralPath $NamespaceDirectory -Directory) {
                if (-not (Test-Path -LiteralPath (Join-Path $ModuleDirectory.FullName '.git'))) { continue }
                $Changes = & git -C $ModuleDirectory.FullName status --porcelain
                if ($LASTEXITCODE -ne 0 -or $Changes) {
                    throw "Preserve local changes in $($ModuleDirectory.FullName), or choose an empty -ModulesDirectory."
                }
                $Unpublished = & git -C $ModuleDirectory.FullName rev-list HEAD --branches --not --remotes --tags
                if ($LASTEXITCODE -ne 0 -or $Unpublished) {
                    throw "Preserve unpublished commits in $($ModuleDirectory.FullName), or choose an empty -ModulesDirectory."
                }
            }
        }
        $SavedErrorAction = $ErrorActionPreference
        try {
            # Windows PowerShell 5 turns redirected native stderr into error
            # records. A missing module is expected on the first installation.
            $ErrorActionPreference = 'Continue'
            $DependencyCheck = & v run scripts/check_installed_deps.vsh 2>&1
            $DependencyExit = $LASTEXITCODE
        } finally {
            $ErrorActionPreference = $SavedErrorAction
        }
        if ($DependencyExit -ne 0) {
            & v install
            if ($LASTEXITCODE -ne 0) { throw 'VPM installation failed. Resolve the reported error and rerun setup.' }
            & v run scripts/check_installed_deps.vsh
            if ($LASTEXITCODE -ne 0) { throw 'Installed dependencies do not match v.mod. See the reported module revisions.' }
        } else {
            $DependencyCheck | Write-Host
            Write-Host 'Pinned dependencies are already installed.'
        }
        $ImguiDirectory = Join-Path $ModulesDirectory 'antono2\imgui'
        & git -C $ImguiDirectory submodule update --init --recursive
        if ($LASTEXITCODE -ne 0) { throw 'ImGui submodule preparation failed. Resolve the Git error and rerun setup.' }
    }
} finally {
    Pop-Location
}
if ($PrepareOnly) {
    Write-Host 'Dependencies are ready. Run scripts\build_windows.ps1 to build the player.'
    return
}
& (Join-Path $PSScriptRoot 'build_windows.ps1') -ModulesDirectory $ModulesDirectory -OutputDirectory $OutputDirectory -Compiler $Compiler
Write-Host 'Use the packaged player with --list-gpus to check playback support for your video.'
