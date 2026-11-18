// Copy the package's license notices and record the exact build inputs.
import os

const package_modules = ['vulkan', 'vkmemalloc', 'memory', 'imgui', 'glfw', 'minimp4', 'h264']
const bundled_runtimes = ['libstdc++6', 'libgcc-s1']

fn module_directory(modules string, name string) string {
	if name == 'imgui' {
		if override := os.getenv_opt('VIMGUI_DIR') {
			return override
		}
	}
	namespaced := os.join_path(modules, 'antono2', name)
	return if os.is_dir(namespaced) { namespaced } else { os.join_path(modules, name) }
}

fn command(args []string) !string {
	result := os.exec(args)
	if result.exit_code != 0 {
		return error('${args[0]} exited with status ${result.exit_code}\n${result.output}')
	}
	return result.output.trim_right('\r\n')
}

fn revision(directory string) !string {
	if os.exists(os.join_path(directory, '.git')) {
		return command(['git', '-C', directory, 'rev-parse', 'HEAD'])
	}
	receipt := os.join_path(directory, 'SOURCE_REVISION')
	if os.is_file(receipt) {
		return os.read_file(receipt)!.replace('\r', '').replace('\n', '')
	}
	return 'unrecorded source checkout'
}

fn copy_notice(source string, destination string) ! {
	os.cp(source, destination)!
	os.chmod(destination, 0o644)!
}

fn write_info(package_directory string) ! {
	root := os.dir(@DIR)
	modules_setting := os.getenv_opt('VMODULES') or {
		return error('VMODULES must identify the checked-out V modules')
	}
	modules := modules_setting.all_before(os.path_delimiter)
	compiler := os.getenv_opt('V_BIN') or { @VEXE }
	licenses := os.join_path(package_directory, 'licenses')
	os.mkdir_all(licenses)!
	copy_notice(os.join_path(root, 'LICENSE'), os.join_path(package_directory, 'LICENSE'))!
	copy_notice(os.join_path(root, 'res', 'README.md'),
		os.join_path(package_directory, 'MEDIA.txt'))!
	manifest := os.join_path(root, 'packaging', 'licenses.manifest')
	for index, line in os.read_lines(manifest)! {
		fields := line.fields()
		if fields.len != 3 {
			return error('invalid license manifest row ${index + 1}')
		}
		module_path := module_directory(modules, fields[0])
		copy_notice(os.join_path(module_path, fields[1]), os.join_path(licenses, fields[2]))!
	}
	runtime_root := os.getenv_opt('PACKAGE_RUNTIME_ROOT') or { '/' }
	for runtime in bundled_runtimes {
		source := os.join_path(runtime_root, 'usr', 'share', 'doc', runtime, 'copyright')
		copy_notice(source, os.join_path(licenses, '${runtime}.txt'))!
	}
	mode := os.getenv_opt('PACKAGE_COMPILER_MODE') or { 'default' }
	c_compiler := os.getenv_opt('PACKAGE_C_COMPILER') or { 'gcc' }
	sdk_version := os.getenv_opt('VULKAN_SDK_VERSION') or { 'system headers' }
	mut info := [
		'Source revision: ${revision(root)!}',
		'V compiler: ${command([compiler, 'version'])!}',
		'Compiler mode: ${mode}',
		'C compiler: ${c_compiler}',
		'Vulkan SDK: ${sdk_version}',
		'Package target: Ubuntu 24.04 x86-64',
	]
	for name in package_modules {
		info << 'Module ${name}: ${revision(module_directory(modules, name))!}'
	}
	os.write_file(os.join_path(package_directory, 'BUILD-INFO.txt'), info.join('\n') + '\n')!
}

fn run(args []string) ! {
	usage := 'Usage: v run scripts/write_linux_package_info.vsh PACKAGE_DIR'
	if args == ['--help'] || args == ['-h'] {
		println(usage)
		return
	}
	if args.len != 1 {
		return error(usage)
	}
	write_info(os.abs_path(args[0]))!
}

run(os.args[1..]) or {
	eprintln(err)
	exit(1)
}
