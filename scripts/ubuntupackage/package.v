// Stage and verify the relocatable Ubuntu 24.04 player archive.
module ubuntupackage

import crypto.sha256
import os
import rand

pub const package_name = 'vkvideo-ubuntu24-amd64'
pub const player_name = 'v_vulkan_video'
pub const shared_imgui = 'lib/libvimgui.so'
pub const demo_video = 'res/20240917_095400.mp4'

pub struct Inputs {
pub:
	project       string
	modules       string
	imgui         string
	player        string
	compiler      string
	compiler_mode string = 'stable'
	runtime_root  string = '/'
	sandbox_tools bool
}

pub fn command(args []string) !string {
	result := os.exec(args)
	if result.exit_code != 0 {
		return error('${args[0]} exited with status ${result.exit_code}\n${result.output}')
	}
	return result.output
}

fn copy_file(source string, destination string, mode int) ! {
	if !os.is_file(source) {
		return error('Missing package input: ${source}')
	}
	os.cp(source, destination)!
	os.chmod(destination, mode)!
}

pub fn sandbox(runtime_root string) []string {
	return ['bwrap', '--ro-bind', runtime_root, '/', '--dev-bind', '/dev', '/dev', '--proc', '/proc',
		'--tmpfs', '/tmp']
}

fn (input Inputs) configure_elf(stage string, program string, args []string) ! {
	mut invocation := [program]
	if input.sandbox_tools {
		mount := '/tmp/vkvideo-package'
		invocation = sandbox(input.runtime_root)
		invocation << ['--bind', stage, mount, '/usr/bin/' + program]
		for arg in args {
			invocation << if arg.starts_with(stage + '/') {
				mount + arg[stage.len..]
			} else {
				arg
			}
		}
	} else {
		invocation << args
	}
	command(invocation)!
}

fn zip_archive(stage string, archive string) ! {
	previous_directory := os.getwd()
	os.chdir(stage)!
	defer { os.chdir(previous_directory) or {} }
	command(['zip', '-qr', archive, package_name])!
}

pub fn package(input Inputs, output string) ! {
	stage := os.join_path(os.dir(output), '.vkvideo-package-' + rand.uuid_v4())
	os.mkdir(stage)!
	defer { os.rmdir_all(stage) or {} }
	destination := os.join_path(stage, package_name)
	os.mkdir_all(os.join_path(destination, 'lib'))!
	os.mkdir(os.join_path(destination, 'res'))!
	player := os.join_path(destination, player_name)
	library := os.join_path(destination, shared_imgui)
	copy_file(input.player, player, 0o755)!
	copy_file(os.join_path(input.imgui, shared_imgui), library, 0o755)!
	for name, location in {
		'libglfw.so.3':   'usr/lib/x86_64-linux-gnu/libglfw.so.3'
		'libstdc++.so.6': 'usr/lib/x86_64-linux-gnu/libstdc++.so.6'
		'libgcc_s.so.1':  'lib/x86_64-linux-gnu/libgcc_s.so.1'
	} {
		copy_file(os.join_path(input.runtime_root, location), os.join_path(destination, 'lib', name),
			0o755)!
	}
	copy_file(os.join_path(input.project, demo_video), os.join_path(destination, demo_video), 0o644)!
	copy_file(os.join_path(input.project, 'packaging', 'ubuntu24', 'README.txt'),
		os.join_path(destination, 'README.txt'), 0o644)!
	command(['env', 'PACKAGE_COMPILER_MODE=${input.compiler_mode}', 'VMODULES=${input.modules}',
		'VIMGUI_DIR=${input.imgui}', 'V_BIN=${input.compiler}',
		'PACKAGE_RUNTIME_ROOT=${input.runtime_root}', input.compiler, 'run',
		os.join_path(input.project, 'scripts', 'write_linux_package_info.vsh'), destination])!
	input.configure_elf(stage, 'strip', ['--strip-unneeded', player, library])!
	input.configure_elf(stage, 'patchelf', ['--set-rpath', r'$ORIGIN/lib', player])!
	input.configure_elf(stage, 'patchelf', ['--set-rpath', r'$ORIGIN', library])!
	archive := os.join_path(stage, 'package.zip')
	zip_archive(stage, archive)!
	digest := sha256.sum(os.read_bytes(archive)!).hex()
	checksum := '${digest}  ${os.file_name(output)}\n'
	os.write_file(archive + '.sha256', checksum)!
	mut verifier := []string{}
	if input.sandbox_tools {
		verifier << ['env', 'PATCHELF=' + os.join_path(input.runtime_root, 'usr/bin/patchelf')]
	}
	verifier << [input.compiler, 'run',
		os.join_path(input.project, 'scripts', 'verify_ubuntu24_package.vsh'), archive]
	print(command(verifier)!)
	for from, to in {
		archive:             output
		archive + '.sha256': output + '.sha256'
	} {
		os.chmod(from, 0o644)!
		os.rename(from, to)!
	}
	print(checksum)
}
