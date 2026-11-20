# Keep the PowerShell entry point for setup, the source bundle, and existing callers.
param(
    [string]$OutputDirectory = "",
    [string]$ModulesDirectory = "",
    [ValidateSet("stable", "v3")]
    [string]$Compiler = "stable"
)

$ErrorActionPreference = "Stop"
$BuildArguments = @('--compiler', $Compiler)
if ($OutputDirectory) { $BuildArguments += @('--output', [IO.Path]::GetFullPath($OutputDirectory)) }
if ($ModulesDirectory) { $BuildArguments += @('--modules', [IO.Path]::GetFullPath($ModulesDirectory)) }
Push-Location (Split-Path -Parent $PSScriptRoot)
try {
    & v run (Join-Path $PSScriptRoot 'build_windows.vsh') @BuildArguments
    if ($LASTEXITCODE -ne 0) { throw "Windows build failed with status $LASTEXITCODE." }
} finally {
    Pop-Location
}
