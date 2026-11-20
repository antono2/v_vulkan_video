# Compatibility entry point for the cross-platform V package verifier.
[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [string] $Archive = "dist\vkvideo-windows-x64.zip"
)

$ErrorActionPreference = "Stop"
$Archive = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Archive)
& v run (Join-Path $PSScriptRoot 'package_windows.vsh') verify $Archive
if ($LASTEXITCODE -ne 0) { throw 'Windows package verification failed.' }
