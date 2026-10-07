# Verifies Windows package contents and the configured executable checks.
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
    "BUILD-INFO.txt"
    "LICENSE"
    "MEDIA.txt"
    "README.txt"
    "glfw3.dll"
    "res\20240917_095400.mp4"
    "run.bat"
    "v_vulkan_video.exe"
    "vimgui.dll"
)
foreach ($Entry in Get-Content (Join-Path $ProjectDirectory 'packaging\licenses.manifest')) {
    $Parts = $Entry -split '\s+'
    if ($Parts.Count -ne 3) { throw "Invalid license entry: $Entry" }
    $ExpectedFiles += "licenses\$($Parts[2])"
}
$TemporaryRoot = [IO.Path]::GetFullPath([IO.Path]::GetTempPath())
$ExtractDirectory = Join-Path $TemporaryRoot ("vkvideo-package-" + [guid]::NewGuid().ToString("N"))

try {
    $ChecksumPath = "$Archive.sha256"
    if (-not (Test-Path -LiteralPath $ChecksumPath -PathType Leaf)) {
        throw "Package checksum is missing: $ChecksumPath"
    }
    $ExpectedHash = ((Get-Content -LiteralPath $ChecksumPath -Raw).Trim() -split '\s+')[0]
    $ActualHash = (Get-FileHash -LiteralPath $Archive -Algorithm SHA256).Hash
    if ($ExpectedHash -notmatch '^[0-9a-fA-F]{64}$' -or $ActualHash -ne $ExpectedHash) {
        throw 'Windows package checksum mismatch'
    }
    Expand-Archive -LiteralPath $Archive -DestinationPath $ExtractDirectory
    $PackageDirectory = Join-Path $ExtractDirectory "vkvideo-windows-x64"
    if (-not (Test-Path -LiteralPath $PackageDirectory -PathType Container)) {
        throw "The archive is missing its vkvideo-windows-x64 root directory"
    }

    # GetRelativePath is unavailable in Windows PowerShell 5.1/.NET Framework.
    # Every enumerated file is below this freshly extracted package root.
    $PackagePrefix = $PackageDirectory.TrimEnd([char[]]'\/') + [IO.Path]::DirectorySeparatorChar
    $ActualFiles = Get-ChildItem -LiteralPath $PackageDirectory -Recurse -File |
        ForEach-Object { $_.FullName.Substring($PackagePrefix.Length) } |
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
    $BuildInfo = Get-Content (Join-Path $PackageDirectory 'BUILD-INFO.txt') -Raw
    foreach ($Label in @('Source revision', 'V compiler', 'Compiler mode', 'C compiler', 'Vulkan SDK')) {
        if ($BuildInfo -notmatch "(?m)^${Label}: .+") { throw "Missing build record: $Label" }
    }
    foreach ($Module in @('vulkan', 'vkmemalloc', 'memory', 'imgui', 'glfw', 'minimp4', 'h264')) {
        if ($BuildInfo -notmatch "(?m)^Module ${Module}: .+") { throw "Missing module revision: $Module" }
    }
    Write-Output "Verified Windows package: $Archive"
} finally {
    $ResolvedExtractDirectory = [IO.Path]::GetFullPath($ExtractDirectory)
    if ($ResolvedExtractDirectory.StartsWith($TemporaryRoot, [StringComparison]::OrdinalIgnoreCase) -and
        (Test-Path -LiteralPath $ResolvedExtractDirectory)) {
        Remove-Item -LiteralPath $ResolvedExtractDirectory -Recurse -Force
    }
}
