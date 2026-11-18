// Bundle the player's tracked sources and the exact revisions of its V modules.
import crypto.sha256
import os
import rand

const bundle_name = 'vkvideo-windows-source'
const source_modules = ['glfw', 'h264', 'imgui', 'memory', 'minimp4', 'vkmemalloc', 'vulkan']

fn command(args []string) !string {
	result := os.exec(args)
	if result.exit_code != 0 {
		return error('${args[0]} exited with status ${result.exit_code}\n${result.output}')
	}
	return result.output.trim_right('\r\n')
}

fn export_checkout(source string, revision string, destination string, work string, project bool) ! {
	os.mkdir_all(destination)!
	archive := os.join_path(work, 'tree-' + rand.uuid_v4() + '.tar')
	defer { os.rm(archive) or {} }
	command(['git', '-C', source, 'archive', '--format=tar', '-o', archive, revision])!
	mut extract := ['tar', '-xf', archive, '-C', destination, '--exclude=*.o', '--exclude=*.so',
		'--exclude=*.a', '--exclude=.build', '--exclude=build']
	if project {
		extract << ['--exclude=dist', '--exclude=v_vulkan_video']
	} else {
		extract << '--exclude=lib'
	}
	command(extract)!
	tree := command(['git', '-c', 'core.quotePath=false', '-C', source, 'ls-tree', '-r', revision])!
	for entry in tree.split_into_lines() {
		if !entry.starts_with('160000 commit ') {
			continue
		}
		header, relative := entry.split_once('\t') or {
			return error('invalid Git submodule entry in ${source}')
		}
		submodule := os.join_path(source, relative)
		if os.exists(os.join_path(submodule, '.git')) {
			selected := header.all_after_last(' ')
			export_checkout(submodule, selected, os.join_path(destination, relative), work, false)!
		}
	}
}

fn snapshot(source string, destination string, work string, project bool) ! {
	revision := command(['git', '-C', source, 'rev-parse', 'HEAD'])!
	export_checkout(source, revision, destination, work, project)!
	os.write_file(os.join_path(destination, 'SOURCE_REVISION'), revision + '\n')!
}

fn locate_modules() !string {
	setting := os.getenv_opt('V_MODULES_DIR') or {
		os.getenv_opt('VMODULES') or { os.join_path(os.home_dir(), '.vmodules') }
	}
	root := os.real_path(setting.all_before(os.path_delimiter))
	if !os.is_dir(root) {
		return error('missing V module directory: ${root}')
	}
	return root
}

fn package(output string) ! {
	root := os.dir(@DIR)
	modules := locate_modules()!
	staging := os.join_path(os.dir(output), '.vkvideo-windows-source-' + rand.uuid_v4())
	os.mkdir(staging)!
	defer { os.rmdir_all(staging) or {} }
	bundle := os.join_path(staging, bundle_name)
	snapshot(root, os.join_path(bundle, 'v_vulkan_video'), staging, true)!
	for name in source_modules {
		mut path := os.join_path(modules, 'antono2', name)
		if !os.is_dir(path) && name != 'vkmemalloc' {
			path = os.join_path(modules, name)
		}
		if !os.is_dir(path) {
			return error('Missing V module: antono2/${name}')
		}
		snapshot(path, os.join_path(bundle, 'modules', 'antono2', name), staging, false)!
	}
	archive := os.join_path(staging, 'source.zip')
	previous := os.getwd()
	os.chdir(staging)!
	command(['zip', '-qr', archive, bundle_name]) or {
		os.chdir(previous) or {}
		return err
	}
	os.chdir(previous)!
	command(['unzip', '-t', archive])!
	digest := sha256.sum(os.read_bytes(archive)!).hex()
	sum := archive + '.sha256'
	os.write_file(sum, '${digest}  ${os.file_name(output)}\n')!
	for from, to in {
		archive: output
		sum:     output + '.sha256'
	} {
		os.chmod(from, 0o644)!
		os.rename(from, to)!
	}
	println('${digest}  ${output}')
}

fn run(args []string) ! {
	usage := 'Usage: v run scripts/package_windows_source.vsh [OUTPUT.zip]'
	if args == ['--help'] || args == ['-h'] {
		println(usage)
		return
	}
	if args.len > 1 {
		return error(usage)
	}
	project_parent := os.dir(os.dir(@DIR))
	output := if args.len == 1 {
		os.abs_path(args[0])
	} else {
		os.join_path(project_parent, 'vkvideo_windows_source.zip')
	}
	package(output)!
}

run(os.args[1..]) or {
	eprintln(err)
	exit(1)
}
