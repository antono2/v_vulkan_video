# Forward the existing PowerShell diagnostics command to V.
param([switch]$BuildOnly)

$ErrorActionPreference = 'Stop'
$CheckArguments = @()
if ($BuildOnly) { $CheckArguments += '--build-only' }
& v run (Join-Path $PSScriptRoot 'check_windows.vsh') @CheckArguments
if ($LASTEXITCODE -ne 0) { throw "Windows prerequisite checks failed with status $LASTEXITCODE." }
