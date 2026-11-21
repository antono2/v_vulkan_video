# Activate the vendor toolchain and hand off to the V setup script.
[CmdletBinding()]
param(
    [string]$ModulesDirectory = '',
    [string]$OutputDirectory = '',
    [ValidateSet('stable', 'v3')]
    [string]$Compiler = 'stable',
    [switch]$Check,
    [switch]$PrepareOnly,
    [switch]$Verify
)

$ErrorActionPreference = 'Stop'
if ($Check -and $PrepareOnly) { throw 'Choose either -Check or -PrepareOnly.' }
$ProjectDirectory = Split-Path -Parent $PSScriptRoot
. (Join-Path $PSScriptRoot 'windows_environment.ps1')
Initialize-VkVideoWindowsEnvironment
if (-not (Get-Command v -ErrorAction SilentlyContinue)) {
    & (Join-Path $PSScriptRoot 'check_windows.ps1') -BuildOnly
}
$SetupArguments = @('--modules', (Get-VkVideoModulesDirectory $ModulesDirectory $ProjectDirectory), '--compiler', $Compiler)
if ($OutputDirectory) { $SetupArguments += @('--output', [IO.Path]::GetFullPath($OutputDirectory)) }
if ($Check) { $SetupArguments += '--check' }
if ($PrepareOnly) { $SetupArguments += '--prepare-only' }
if ($Verify) { $SetupArguments += '--verify' }
$SavedModules = $env:VMODULES
# V creates VMODULES before a script runs. Use an existing directory for
# compiler startup so -Check leaves the requested modules directory untouched.
$env:VMODULES = $ProjectDirectory
Push-Location $ProjectDirectory
try {
    & v run (Join-Path $PSScriptRoot 'setup_windows.vsh') @SetupArguments
    if ($LASTEXITCODE -ne 0) { throw "Windows setup failed with status $LASTEXITCODE." }
} finally {
    Pop-Location
    $env:VMODULES = $SavedModules
}
