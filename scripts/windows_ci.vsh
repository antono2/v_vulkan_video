// Register the pinned Windows compiler and exercise fresh VPM setup outside a bundle.
import os
import windowssetup

const usage = 'Usage: v run scripts/windows_ci.vsh compiler-path V_SOURCE | fresh'
const usage_status = 2

fn register_compiler(source string) ! {
	directory := os.abs_path(source)
	if !os.is_file(os.join_path(directory, 'v.exe')) || directory.contains_any('\r\n') {
		return error('Expected a Windows V compiler checkout: ${directory}')
	}
	path := os.getenv('GITHUB_PATH')
	if path == '' {
		return error('GITHUB_PATH is required to register this compiler.')
	}
	mut receipt := os.open_append(path)!
	defer { receipt.close() }
	receipt.writeln(directory)!
}

fn fresh(project string) ! {
	requested := os.getenv('VKVIDEO_FRESH_MODULES')
	if requested == '' {
		return error('Set VKVIDEO_FRESH_MODULES to a nonexistent module directory.')
	}
	modules := os.abs_path(requested)
	if os.exists(modules) || os.is_link(modules) {
		return error('The fresh VPM module directory already exists: ${modules}')
	}
	// Model an ordinary SDK installation instead of relying on the CI helper's version.
	os.unsetenv('VULKAN_SDK_VERSION')
	setup := os.join_path(project, 'scripts', 'setup_windows.vsh')
	for mode in ['--check', '--verify', '--prepare-only'] {
		mut child := os.new_process(@VEXE)
		child.set_environment(windowssetup.current_environment())
		child.set_args(['run', setup, '--modules', modules, mode])
		child.wait()
		status := child.code
		child.close()
		if status != 0 {
			return error('The fresh Windows setup step ${mode} exited with status ${status}.')
		}
		if mode == '--check' && (os.exists(modules) || os.is_link(modules)) {
			return error('Read-only setup created the module directory: ${modules}')
		}
	}
}

fn run(args []string) ! {
	if args in [['--help'], ['-h']] {
		println(usage)
		return
	}
	match true {
		args == ['fresh'] { fresh(os.dir(@DIR))! }
		args.len == 2 && args[0] == 'compiler-path' && args[1] != '' {
			register_compiler(args[1])!
		}
		else { return error_with_code(usage, usage_status) }
	}
}

run(os.args[1..]) or {
	eprintln(err)
	exit(if err.code() > 0 { err.code() } else { 1 })
}
