// Package the prebuilt CI player for Ubuntu 24.04 x86-64.
import crypto.sha256
import os
import rand

const package_name = 'vkvideo-ubuntu24-amd64'
const player_name = 'v_vulkan_video'
const shared_imgui = 'lib/libvimgui.so'
const demo_video = 'res/20240917_095400.mp4'

fn command(args []string) !string {
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

fn package(output string) ! {
	root := os.dir(@DIR)
	modules_setting := os.getenv_opt('VMODULES') or {
		return error('VMODULES must point to the checked-out V modules')
	}
	modules := modules_setting.all_before(os.path_delimiter)
	imgui := os.join_path(modules, 'antono2', 'imgui')
	stage := os.join_path(os.dir(output), '.vkvideo-package-' + rand.uuid_v4())
	os.mkdir(stage)!
	defer { os.rmdir_all(stage) or {} }
	destination := os.join_path(stage, package_name)
	os.mkdir_all(os.join_path(destination, 'lib'))!
	os.mkdir(os.join_path(destination, 'res'))!
	player := os.join_path(destination, player_name)
	library := os.join_path(destination, shared_imgui)
	copy_file(os.join_path(root, player_name), player, 0o755)!
	copy_file(os.join_path(imgui, shared_imgui), library, 0o755)!
	for name, source in {
		'libglfw.so.3':   '/usr/lib/x86_64-linux-gnu/libglfw.so.3'
		'libstdc++.so.6': '/usr/lib/x86_64-linux-gnu/libstdc++.so.6'
		'libgcc_s.so.1':  '/lib/x86_64-linux-gnu/libgcc_s.so.1'
	} {
		copy_file(source, os.join_path(destination, 'lib', name), 0o755)!
	}
	copy_file(os.join_path(root, demo_video), os.join_path(destination, demo_video), 0o644)!
	for name in ['run.sh', 'README.txt'] {
		mode := if name == 'run.sh' { 0o755 } else { 0o644 }
		copy_file(os.join_path(root, 'packaging', 'ubuntu24', name),
			os.join_path(destination, name), mode)!
	}
	command(['env', 'PACKAGE_COMPILER_MODE=stable', @VEXE, 'run',
		os.join_path(root, 'scripts', 'write_linux_package_info.vsh'), destination])!
	command(['strip', '--strip-unneeded', player, library])!
	command(['patchelf', '--set-rpath', r'$ORIGIN/lib', player])!
	command(['patchelf', '--set-rpath', r'$ORIGIN', library])!
	archive := os.join_path(stage, 'package.zip')
	// The archive records the staged directory relative to its extraction root.
	previous_directory := os.getwd()
	os.chdir(stage)!
	command(['zip', '-qr', archive, package_name]) or {
		os.chdir(previous_directory) or {}
		return err
	}
	os.chdir(previous_directory)!
	digest := sha256.sum(os.read_bytes(archive)!).hex()
	checksum := '${digest}  ${os.file_name(output)}\n'
	os.write_file(archive + '.sha256', checksum)!
	print(command([@VEXE, 'run', os.join_path(root, 'scripts', 'verify_ubuntu24_package.vsh'),
		archive])!)
	for from, to in {
		archive:             output
		archive + '.sha256': output + '.sha256'
	} {
		os.chmod(from, 0o644)!
		os.rename(from, to)!
	}
	print(checksum)
}

fn run(args []string) ! {
	usage := 'Usage: v run scripts/package_ci_ubuntu24.vsh [ARCHIVE.zip]'
	if args == ['--help'] || args == ['-h'] {
		println(usage)
		return
	}
	if args.len > 1 {
		return error(usage)
	}
	root := os.dir(@DIR)
	output := if args.len == 1 {
		os.abs_path(args[0])
	} else {
		os.join_path(root, package_name + '.zip')
	}
	package(output)!
}

run(os.args[1..]) or {
	eprintln(err)
	exit(1)
}
