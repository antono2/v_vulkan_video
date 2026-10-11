# Exercises setup ordering, failure propagation and paths without downloading tools.
$ErrorActionPreference = 'Stop'
$SetupScript = Join-Path $PSScriptRoot 'setup_windows.ps1'
$TestRoot = Join-Path ([IO.Path]::GetTempPath()) ('vkvideo setup tests ' + [Guid]::NewGuid().ToString('N'))
$OriginalLocation = Get-Location
$SavedEnvironment = @{}
foreach ($Name in @('VMODULES', 'VTMP', 'VULKAN_SDK', 'VSCMD_ARG_TGT_ARCH', 'Path', 'GIT_CONFIG_COUNT', 'GIT_CONFIG_KEY_0', 'GIT_CONFIG_VALUE_0')) {
    $SavedEnvironment[$Name] = [Environment]::GetEnvironmentVariable($Name, 'Process')
}

function Assert-Setup([bool]$Condition, [string]$Message) {
    if (-not $Condition) { throw $Message }
}

# Function fixtures are resolved like commands by setup, but make no network calls.
function v {
    Assert-Setup ($env:GIT_CONFIG_COUNT -eq '2' -and $env:GIT_CONFIG_KEY_1 -eq 'core.longpaths' -and
        $env:GIT_CONFIG_VALUE_1 -eq 'true') 'VPM did not inherit Git long-path handling.'
    $global:VkVideoSetupCalls += 'v ' + ($args -join ' ')
    $global:LASTEXITCODE = 0
    if (($args[0] -eq 'install' -and $global:VkVideoSetupFailure -eq 'install') -or
        ($args[0] -eq 'run' -and $global:VkVideoSetupFailure -eq 'revisions')) {
        $global:LASTEXITCODE = 7
    }
}
function git {
    $global:VkVideoSetupCalls += 'git'
    $global:VkVideoSetupGitDirectory = $args[1]
    $global:LASTEXITCODE = if ($global:VkVideoSetupFailure -eq 'submodules') { 8 } else { 0 }
}
function cmake {}
function cl {}

try {
    $Sdk = Join-Path $TestRoot 'SDK with spaces'
    New-Item -ItemType Directory -Force -Path (Join-Path $Sdk 'Include\vulkan'), (Join-Path $Sdk 'Bin') | Out-Null
    New-Item -ItemType File -Path (Join-Path $Sdk 'Include\vulkan\vulkan.h') | Out-Null
    $env:VULKAN_SDK = $Sdk
    $env:VSCMD_ARG_TGT_ARCH = 'x64'
    $env:GIT_CONFIG_COUNT = '1'
    $env:GIT_CONFIG_KEY_0 = 'fixture.original'
    $env:GIT_CONFIG_VALUE_0 = 'preserved'
    Set-Location $TestRoot
    $CallerDirectory = (Get-Location).Path
    $Modules = Join-Path $TestRoot 'modules with spaces'
    $env:VMODULES = $Modules
    $env:VTMP = Join-Path $TestRoot 'unrelated temp'
    $global:VkVideoSetupFailure = ''
    $global:VkVideoSetupCalls = @()

    & $SetupScript -Check
    Assert-Setup ($global:VkVideoSetupCalls.Count -eq 0) '-Check executed dependency commands.'
    Assert-Setup (-not (Test-Path -LiteralPath $Modules)) '-Check created a module directory.'
    Assert-Setup ($env:VTMP -eq (Join-Path $TestRoot 'unrelated temp')) '-Check changed dependency staging.'

    & $SetupScript -PrepareOnly
    Assert-Setup (($global:VkVideoSetupCalls -join '|') -eq 'v install|v run scripts/check_installed_deps.vsh|git') 'Dependency commands ran in the wrong order.'
    Assert-Setup ($global:VkVideoSetupGitDirectory -eq (Join-Path $Modules 'antono2\imgui')) 'Git lost the module path containing spaces.'
    Assert-Setup ($env:VTMP -eq (Join-Path $Modules '.vtmp')) 'VPM staging was not placed beside modules.'
    Assert-Setup ((Get-Location).Path -eq $CallerDirectory) 'Successful setup changed the caller directory.'
    Assert-Setup ($env:GIT_CONFIG_COUNT -eq '1' -and $env:GIT_CONFIG_VALUE_0 -eq 'preserved') 'Setup changed existing Git configuration.'
    & $SetupScript -PrepareOnly
    Assert-Setup ((Get-Location).Path -eq $CallerDirectory) 'Repeated setup changed the caller directory.'

    foreach ($Case in @(
        @{ Failure = 'install'; Message = 'VPM installation failed'; Calls = 1 },
        @{ Failure = 'revisions'; Message = 'Installed dependencies do not match'; Calls = 2 },
        @{ Failure = 'submodules'; Message = 'ImGui submodule preparation failed'; Calls = 3 }
    )) {
        $global:VkVideoSetupFailure = $Case.Failure
        $global:VkVideoSetupCalls = @()
        $Caught = ''
        try { & $SetupScript -PrepareOnly } catch { $Caught = $_.Exception.Message }
        Assert-Setup ($Caught.StartsWith($Case.Message)) "Setup did not report $($Case.Failure) failure: $Caught"
        Assert-Setup ($global:VkVideoSetupCalls.Count -eq $Case.Calls) "Setup continued after $($Case.Failure) failure."
        Assert-Setup ((Get-Location).Path -eq $CallerDirectory) 'Failed setup changed the caller directory.'
        Assert-Setup ($env:GIT_CONFIG_COUNT -eq '1' -and -not $env:GIT_CONFIG_KEY_1) 'Failed setup leaked Git configuration.'
    }

    . (Join-Path $PSScriptRoot 'windows_environment.ps1')
    $Project = Join-Path $TestRoot 'bundle\player'
    $BundledModules = Join-Path $TestRoot 'bundle\modules'
    New-Item -ItemType Directory -Force -Path (Join-Path $BundledModules 'antono2\imgui') | Out-Null
    New-Item -ItemType File -Path (Join-Path $BundledModules 'antono2\imgui\CMakeLists.txt') | Out-Null
    $env:VMODULES = "$Modules;ignored"
    Assert-Setup ((Get-VkVideoModulesDirectory '' $Project) -eq $Modules) 'Module search path precedence changed.'
    Assert-Setup ((Get-VkVideoModulesDirectory $BundledModules $Project) -eq $BundledModules) 'Explicit module directory did not override VMODULES.'
    $env:VMODULES = ''
    Assert-Setup ((Get-VkVideoModulesDirectory '' $Project) -eq $BundledModules) 'Source bundle modules were not discovered.'
    Write-Host 'Windows setup regression checks passed.'
} finally {
    Set-Location $OriginalLocation
    foreach ($Name in $SavedEnvironment.Keys) {
        [Environment]::SetEnvironmentVariable($Name, $SavedEnvironment[$Name], 'Process')
    }
    # Resolve and check the test-owned directory before recursive cleanup.
    $ResolvedTestRoot = [IO.Path]::GetFullPath($TestRoot)
    $TempRoot = [IO.Path]::GetFullPath([IO.Path]::GetTempPath()).TrimEnd('\') + '\'
    if (-not $ResolvedTestRoot.StartsWith($TempRoot, [StringComparison]::OrdinalIgnoreCase) -or
        [IO.Path]::GetFileName($ResolvedTestRoot) -notlike 'vkvideo setup tests *') {
        throw "Refusing cleanup outside the test directory: $ResolvedTestRoot"
    }
    if (Test-Path -LiteralPath $ResolvedTestRoot) { Remove-Item -LiteralPath $ResolvedTestRoot -Recurse -Force }
}
