# Discovers installed Windows build tools in the current process only.
function Initialize-VkVideoWindowsEnvironment {
    if (-not [Environment]::Is64BitProcess) {
        throw 'Use 64-bit PowerShell to build the Windows x64 player.'
    }
    if (-not (Get-Command cl -ErrorAction SilentlyContinue) -or $env:VSCMD_ARG_TGT_ARCH -ne 'x64') {
        $VsWhere = Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio\Installer\vswhere.exe'
        if (-not (Test-Path -LiteralPath $VsWhere)) {
            throw 'Install Visual Studio 2022 Build Tools with Desktop development with C++, then rerun setup.'
        }
        $InstallPath = & $VsWhere -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath
        if ($LASTEXITCODE -ne 0 -or -not $InstallPath) {
            throw 'Visual Studio C++ tools were not found. Install the Desktop development with C++ workload.'
        }
        Import-Module (Join-Path $InstallPath 'Common7\Tools\Microsoft.VisualStudio.DevShell.dll')
        Enter-VsDevShell -VsInstallPath $InstallPath -SkipAutomaticLocation -DevCmdArguments '-arch=x64 -host_arch=x64'
    }
    if (-not $env:VULKAN_SDK) {
        foreach ($Scope in @('User', 'Machine')) {
            $SdkPath = [Environment]::GetEnvironmentVariable('VULKAN_SDK', $Scope)
            if ($SdkPath) {
                $env:VULKAN_SDK = $SdkPath
                break
            }
        }
    }
    if ($env:VULKAN_SDK -and (Test-Path -LiteralPath (Join-Path $env:VULKAN_SDK 'Bin'))) {
        $SdkBin = Join-Path $env:VULKAN_SDK 'Bin'
        if (($env:Path -split ';') -notcontains $SdkBin) {
            $env:Path = "$SdkBin;$env:Path"
        }
    }
}

function Get-VkVideoModulesDirectory([string]$Directory, [string]$ProjectDirectory) {
    if (-not $Directory) {
        $BundleModules = Join-Path (Split-Path -Parent $ProjectDirectory) 'modules'
        if ($env:VMODULES) {
            $Directory = ($env:VMODULES -split ';')[0]
        } elseif (Test-Path -LiteralPath (Join-Path $BundleModules 'antono2\imgui\CMakeLists.txt')) {
            $Directory = $BundleModules
        } else {
            $Directory = Join-Path $env:USERPROFILE '.vmodules'
        }
    }
    return [IO.Path]::GetFullPath($Directory)
}

function Invoke-VkVideoGitLongPaths([scriptblock]$Action) {
    # Git subprocesses launched by VPM inherit this per-command configuration.
    # Append to existing overrides and restore them after success or failure.
    $Count = 0
    $ConfiguredCount = $env:GIT_CONFIG_COUNT
    if ($ConfiguredCount -and (-not [int]::TryParse($ConfiguredCount, [ref]$Count) -or $Count -lt 0)) {
        throw 'GIT_CONFIG_COUNT must be a nonnegative integer.'
    }
    $Saved = @{}
    foreach ($Name in @('GIT_CONFIG_COUNT', "GIT_CONFIG_KEY_$Count", "GIT_CONFIG_VALUE_$Count")) {
        $Saved[$Name] = [Environment]::GetEnvironmentVariable($Name, 'Process')
    }
    try {
        [Environment]::SetEnvironmentVariable("GIT_CONFIG_KEY_$Count", 'core.longpaths', 'Process')
        [Environment]::SetEnvironmentVariable("GIT_CONFIG_VALUE_$Count", 'true', 'Process')
        $env:GIT_CONFIG_COUNT = ($Count + 1).ToString()
        & $Action
    } finally {
        foreach ($Name in $Saved.Keys) {
            [Environment]::SetEnvironmentVariable($Name, $Saved[$Name], 'Process')
        }
    }
}
