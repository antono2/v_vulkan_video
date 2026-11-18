// Check Linux build tools and Vulkan Video capability, with optional Debian-family setup.
import os
import probeio { find_executable, run_probe }
import time

const runtime_timeout = 30 * time.second
const compiler_timeout = 15 * time.second
const native_tools = ['git', 'cmake', 'cc', 'c++', 'pkg-config', 'vulkaninfo']
const video_extensions = ['VK_KHR_video_queue', 'VK_KHR_video_decode_queue', 'VK_KHR_video_decode_h264']
const packages = ['build-essential', 'cmake', 'git', 'luajit', 'libglfw3-dev', 'libvulkan-dev',
	'libvulkan-volk-dev', 'vulkan-tools', 'pkg-config']
const usage = 'Usage: v run scripts/setup_linux.vsh [--check|--install]\n\n  --check    Report build and Vulkan Video prerequisites (default).\n  --install  Install Debian/Ubuntu packages with sudo, then check prerequisites.'

fn debian_family(release string) bool {
	mut id := ''
	mut id_like := []string{}
	for line in release.split_into_lines() {
		separator := line.index('=') or { continue }
		key := line[..separator]
		word := line[separator + 1..].trim_space().trim('"\'')
		match key {
			'ID' { id = word }
			'ID_LIKE' { id_like = word.fields() }
			else {}
		}
	}
	return id in ['debian', 'ubuntu'] || 'debian' in id_like
}

struct Device {
	id string
mut:
	name       string
	extensions []string
}

fn (device Device) missing_extensions() []string {
	return video_extensions.filter(it !in device.extensions)
}

fn devices_from_details(details string) []Device {
	mut devices := []Device{}
	for line in details.split_into_lines() {
		// vulkaninfo prints each physical device as a top-level GPU<n>: section.
		if line.starts_with('GPU') && line.ends_with(':') {
			id := line[3..line.len - 1]
			if id != '' && id.bytes().all(it.is_digit()) {
				devices << Device{ id: id }
			}
			continue
		}
		if devices.len == 0 {
			continue
		}
		name := line.all_before(':').trim_space()
		index := devices.len - 1
		if name in video_extensions && name !in devices[index].extensions {
			devices[index].extensions << name
		}
		if line.trim_space().starts_with('deviceName') && line.contains('=') {
			devices[index].name = line.all_after('=').trim_space()
		}
	}
	return devices
}

fn install() ! {
	release := os.read_file('/etc/os-release') or {
		return error('Cannot identify this Linux distribution.')
	}
	if !debian_family(release) {
		return error('Automatic installation supports Debian and Ubuntu families only. See QUICKSTART.md.')
	}
	sudo := os.find_abs_path_of_executable('sudo')!
	println('Installing: ${packages.join(' ')}')
	mut install_args := ['apt-get', 'install', '-y']
	install_args << packages
	for args in [['apt-get', 'update'], install_args] {
		mut command := os.new_process(sudo)
		command.set_args(args)
		command.run()
		command.wait()
		status := command.code
		command.close()
		if status != 0 {
			return error('sudo ${args.join(' ')} exited with status ${status}')
		}
	}
}

fn check() ! {
	mut passed := true
	for tool in native_tools {
		if find_executable(tool) == '' {
			println('[missing] ${tool}')
			passed = false
		} else {
			println('[ok]      ${tool}')
		}
	}
	compiler := run_probe(@VEXE, ['version'], compiler_timeout)
	if compiler.ok {
		println('[ok]      v: ${compiler.detail}')
	} else {
		println('[failed]  V compiler: ${compiler.detail}')
		passed = false
	}
	if find_executable('vulkaninfo') != '' {
		summary := run_probe('vulkaninfo', ['--summary'], runtime_timeout)
		if summary.ok {
			println('[ok]      Vulkan loader can enumerate devices')
		} else {
			println('[failed]  vulkaninfo could not enumerate a usable Vulkan device')
			eprintln(summary.detail)
			passed = false
		}
		details := run_probe('vulkaninfo', [], runtime_timeout)
		if !details.ok {
			eprintln('[failed]  vulkaninfo could not list Vulkan extensions: ${details.detail}')
			passed = false
		}
		devices := devices_from_details(details.detail)
		if devices.len == 0 {
			eprintln('[failed]  No physical-device sections reported by vulkaninfo')
		}
		mut supported := false
		for device in devices {
			label := if device.name == '' {
				'GPU${device.id}'
			} else {
				'GPU${device.id} (${device.name})'
			}
			missing := device.missing_extensions()
			if missing.len == 0 {
				println('[ok]      ${label} advertises all three Vulkan Video extensions')
				supported = true
			} else {
				println('[missing] ${label}: ${missing.join(', ')}')
			}
		}
		passed = passed && supported
	}
	if !passed {
		return error('One or more requirements are unavailable. See QUICKSTART.md.')
	}
	println('Build and Vulkan Video prerequisites look usable.')
}

fn self_test() {
	assert debian_family('ID=ubuntu\n')
	assert debian_family('ID=linuxmint\nID_LIKE="ubuntu debian"\n')
	assert debian_family("ID='debian'\n")
	assert !debian_family('ID=fedora\nID_LIKE="rhel debianized"\n')
	assert !debian_family('PRETTY_NAME="Debian"\n')
	devices := devices_from_details('VK_KHR_video_queue : extension revision 8\n' +
		'GPU0:\n' +
		'\tdeviceName = Test device\n' +
		'\tVK_KHR_video_queue : extension revision 8\n' +
		'\tVK_KHR_video_decode_queue : extension revision 8\n' +
		'\tVK_KHR_video_decode_h264 : extension revision 9\n' +
		'GPU1:\n' +
		'\tVK_KHR_video_decode_h264_fake : extension revision 9\n')
	assert devices.len == 2
	assert devices[0].name == 'Test device'
	assert devices[0].missing_extensions().len == 0
	assert devices[1].missing_extensions() == video_extensions
	split := devices_from_details('GPU0:\n' +
		'\tVK_KHR_video_queue : extension revision 8\n' +
		'GPU1:\n' +
		'\tVK_KHR_video_decode_queue : extension revision 8\n' +
		'\tVK_KHR_video_decode_h264 : extension revision 9\n')
	assert split[0].missing_extensions().len == 2
	assert split[1].missing_extensions() == ['VK_KHR_video_queue']
	println('Linux setup fixtures passed.')
}

fn run(args []string) ! {
	if args in [['--help'], ['-h']] {
		println(usage)
		return
	}
	if args == ['--self-test'] {
		self_test()
		return
	}
	if args.len != 0 && args != ['--check'] && args != ['--install'] {
		return error_with_code(usage, 2)
	}
	if os.user_os() != 'linux' {
		return error('This setup helper is for Linux. See QUICKSTART.md for other platforms.')
	}
	if args == ['--install'] {
		install()!
	}
	check()!
}

run(os.args[1..]) or {
	eprintln(err)
	exit(if err.code() == 2 { 2 } else { 1 })
}
