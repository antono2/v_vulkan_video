// Import the vendor's x64 toolchain environment for this process and its children.
module windowssetup

import encoding.binary
import os
import probeio
import rand
import time

const discovery_timeout = 2 * time.minute
const sdk_variable = 'VULKAN_SDK'
const architecture_variable = 'VSCMD_ARG_TGT_ARCH'
const target_architecture = 'x64'
const vs_command_variable = 'VKVIDEO_VSDEVCMD'
const utf16_byte_order_mark = u16(0xfeff)
const utf16_code_unit_bytes = int(sizeof(u16))

fn decode_vs_environment(raw string) !string {
	// Some V releases decode Windows process pipes before returning stdout.
	if !raw.contains('\x00') {
		return raw
	}
	if raw.len % utf16_code_unit_bytes != 0 {
		return error('Visual Studio returned an incomplete UTF-16 environment.')
	}
	mut wide := []u16{cap: raw.len / utf16_code_unit_bytes}
	bytes := raw.bytes()
	for offset := 0; offset < bytes.len; offset += utf16_code_unit_bytes {
		value := binary.little_endian_u16(bytes[offset..])
		if offset != 0 || value != utf16_byte_order_mark {
			wide << value
		}
	}
	return unsafe { string_from_wide2(wide.data, wide.len) }
}

fn parse_vs_environment(raw string) !map[string]string {
	text := decode_vs_environment(raw)!
	mut values := map[string]string{}
	for line in text.split_into_lines() {
		name, value := line.split_once('=') or { continue }
		// cmd.exe also lists pseudo-variables for per-drive working directories.
		if name == '' || name.to_upper_ascii() == vs_command_variable {
			continue
		}
		values[name] = value
	}
	if values[architecture_variable] != target_architecture {
		return error('Visual Studio did not activate the x64 build tools.')
	}
	return values
}

fn visual_studio_environment() !map[string]string {
	program_files := os.getenv('ProgramFiles(x86)')
	if program_files == '' {
		return error('ProgramFiles(x86) is unset. Use a 64-bit Windows shell.')
	}
	vswhere := os.join_path(program_files, 'Microsoft Visual Studio', 'Installer', 'vswhere.exe')
	located := probeio.run_probe_with_options(vswhere, ['-latest', '-products', '*', '-requires',
		'Microsoft.VisualStudio.Component.VC.Tools.x86.x64', '-property', 'installationPath', '-utf8'],
		discovery_timeout,
		environment: current_environment()
	)
	if !located.ok || located.detail == '' {
		return error('Visual Studio x64 C++ tools were not found. Install the Desktop development with C++ workload.')
	}
	devcmd := os.join_path(located.detail, 'Common7', 'Tools', 'VsDevCmd.bat')
	if !os.is_file(devcmd) {
		return error('The Visual Studio developer command is missing: ${devcmd}')
	}
	// Run only the vendor initialization and cmd's environment export in a child.
	// A fixed batch filename avoids passing an installation path through cmd's parser.
	scratch := os.join_path(os.temp_dir(), 'vkvideo-msvc-' + rand.uuid_v4())
	os.mkdir(scratch)!
	defer { os.rmdir_all(scratch) or { eprintln(err) } }
	script := 'capture.cmd'
	os.write_file(os.join_path(scratch, script), '@echo off\r\n' +
		'call "%${vs_command_variable}%" -no_logo -arch=${target_architecture} -host_arch=${target_architecture} >nul\r\n' +
		'if errorlevel 1 exit /b 1\r\nset\r\n')!
	mut child_env := current_environment()
	child_env[vs_command_variable] = devcmd
	command := os.getenv_opt('ComSpec') or { 'cmd.exe' }
	result := probeio.run_probe_with_options(command, ['/d', '/u', '/c', script], discovery_timeout,
		directory:   scratch
		environment: child_env
		stdout_only: true
	)
	if !result.ok {
		// stdout can contain inherited environment values. Keep it out of diagnostics.
		return error('Visual Studio failed to initialize its x64 build environment.')
	}
	return parse_vs_environment(result.detail)
}

pub fn activate_environment() ! {
	if os.user_os() != 'windows' {
		return error('Visual Studio tool discovery requires Windows.')
	}
	if os.getenv(architecture_variable) != target_architecture || probeio.find_executable('cl') == '' {
		for name, value in visual_studio_environment()! {
			if os.setenv(name, value, true) != 0 {
				return error('Could not apply the Visual Studio environment variable ${name}.')
			}
		}
	}
	if probeio.find_executable('cl') == '' {
		return error('The active Visual Studio environment has no cl.exe.')
	}
	$if windows {
		if os.getenv(sdk_variable) == '' {
			stored := installed_vulkan_sdk()
			if stored != '' {
				os.setenv(sdk_variable, stored, true)
			}
		}
	}
	sdk := os.getenv(sdk_variable)
	if sdk == '' || !os.is_file(os.join_path(sdk, 'Include', 'vulkan', 'vulkan.h')) {
		return error('Set VULKAN_SDK to a Vulkan SDK containing the development headers.')
	}
	bin := os.join_path(sdk, 'Bin')
	path := os.getenv('PATH')
	if os.is_dir(bin) && !path.split(os.path_delimiter).any(it.to_lower_ascii() == bin.to_lower_ascii()) {
		os.setenv('PATH', bin + os.path_delimiter + path, true)
	}
}

pub fn check_prerequisites() ! {
	activate_environment()!
	for tool in ['v', 'git', 'cmake', 'cl'] {
		if probeio.find_executable(tool) == '' {
			return error('Required command is unavailable: ${tool}. Install it and add it to PATH.')
		}
		println('[ok]      ${tool}')
	}
	println('[ok]      VULKAN_SDK=${os.getenv(sdk_variable)}')
}

// Use code-unit offsets on Windows so the pinned V release preserves non-ASCII paths.
pub fn current_environment() map[string]string {
	$if windows {
		return windows_environment()
	} $else {
		return os.environ()
	}
}
