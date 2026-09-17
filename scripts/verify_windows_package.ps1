[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [string] $Archive = "dist\vkvideo-windows-x64.zip"
)

$ErrorActionPreference = "Stop"
$ProjectDirectory = Split-Path -Parent (Split-Path -Parent $PSCommandPath)
$Archive = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Archive)
if (-not (Test-Path -LiteralPath $Archive -PathType Leaf)) {
    throw "Windows package does not exist: $Archive"
}

$ExpectedFiles = @(
    "README.txt"
    "glfw3.dll"
    "res\20240917_095400.mp4"
    "run.bat"
    "v_vulkan_video.exe"
    "vimgui.dll"
)
$TemporaryRoot = [IO.Path]::GetFullPath([IO.Path]::GetTempPath())
$ExtractDirectory = Join-Path $TemporaryRoot ("vkvideo-package-" + [guid]::NewGuid().ToString("N"))

try {
    Expand-Archive -LiteralPath $Archive -DestinationPath $ExtractDirectory
    $PackageDirectory = Join-Path $ExtractDirectory "vkvideo-windows-x64"
    if (-not (Test-Path -LiteralPath $PackageDirectory -PathType Container)) {
        throw "The archive is missing its vkvideo-windows-x64 root directory"
    }

    $ActualFiles = Get-ChildItem -LiteralPath $PackageDirectory -Recurse -File |
        ForEach-Object { [IO.Path]::GetRelativePath($PackageDirectory, $_.FullName) } |
        Sort-Object
    $ExpectedFiles = $ExpectedFiles | Sort-Object
    $Difference = Compare-Object -ReferenceObject $ExpectedFiles -DifferenceObject $ActualFiles
    if ($Difference) {
        $Details = ($Difference | ForEach-Object { "$($_.SideIndicator) $($_.InputObject)" }) -join [Environment]::NewLine
        throw "Unexpected Windows package contents:`n$Details"
    }
    foreach ($RelativePath in $ExpectedFiles) {
        $File = Get-Item -LiteralPath (Join-Path $PackageDirectory $RelativePath)
        if ($File.Length -eq 0) { throw "Packaged file is empty: $RelativePath" }
    }
    Write-Output "Verified Windows package: $Archive"
} finally {
    $ResolvedExtractDirectory = [IO.Path]::GetFullPath($ExtractDirectory)
    if ($ResolvedExtractDirectory.StartsWith($TemporaryRoot, [StringComparison]::OrdinalIgnoreCase) -and
        (Test-Path -LiteralPath $ResolvedExtractDirectory)) {
        Remove-Item -LiteralPath $ResolvedExtractDirectory -Recurse -Force
    }
}
