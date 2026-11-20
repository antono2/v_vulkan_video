// Prepare pinned Windows player modules without overwriting local work.
module windowssetup

import os
import probeio
import rand
import strconv
import time

const command_timeout = 10 * time.minute

pub struct Options {
pub:
	project       string
	modules       string
	output        string
	compiler_mode string
	prepare_only  bool
	verify        bool
}

pub interface Runner {
mut:
	invoke(program string, args []string, project string, env map[string]string) probeio.ProbeResult
}

pub struct NativeRunner {}

pub fn (mut runner NativeRunner) invoke(program string, args []string, project string, env map[string]string) probeio.ProbeResult {
	return probeio.run_probe(program, args, command_timeout, directory: project, environment: env)
}

pub fn modules_directory(requested string, project string, configured string) string {
	if requested != '' {
		return os.abs_path(requested)
	}
	if configured != '' {
		return os.abs_path(configured.all_before(os.path_delimiter))
	}
	bundled := os.join_path(os.dir(project), 'modules')
	if os.is_file(os.join_path(bundled, 'antono2', 'imgui', 'CMakeLists.txt')) {
		return bundled
	}
	return os.join_path(os.home_dir(), '.vmodules')
}

fn git_environment(parent map[string]string) !map[string]string {
	configured := parent['GIT_CONFIG_COUNT'].trim_space()
	count := if configured == '' { 0 } else { strconv.atoi(configured) or {
			return error('GIT_CONFIG_COUNT must be a nonnegative integer.')} }
	if count < 0 || count == max_i32 {
		return error('GIT_CONFIG_COUNT must be a nonnegative integer with room for one more entry.')
	}
	mut env := parent.clone()
	env['GIT_CONFIG_KEY_${count}'] = 'core.longpaths'
	env['GIT_CONFIG_VALUE_${count}'] = 'true'
	env['GIT_CONFIG_COUNT'] = (count + 1).str()
	return env
}

fn protect_modules(options Options, env map[string]string, mut runner Runner) ! {
	namespace := os.join_path(options.modules, 'antono2')
	if !os.is_dir(namespace) {
		return
	}
	for name in os.ls(namespace)!.sorted() {
		directory := os.join_path(namespace, name)
		if !os.is_dir(directory) || !os.exists(os.join_path(directory, '.git')) {
			continue
		}
		status :=
			runner.invoke('git', ['-C', directory, 'status', '--porcelain'], options.project, env)
		if !status.ok || status.detail != '' {
			return error('Preserve local changes in ${directory}, or choose an empty --modules directory.\n${status.detail}')
		}
		commits := runner.invoke('git', ['-C', directory, 'rev-list', 'HEAD', '--branches', '--not',
			'--remotes', '--tags'], options.project, env)
		if !commits.ok || commits.detail != '' {
			return error('Preserve unpublished commits in ${directory}, or choose an empty --modules directory.\n${commits.detail}')
		}
	}
}

fn checked(result probeio.ProbeResult, failure string) ! {
	if !result.ok {
		return error('${failure}\n${result.detail}')
	}
	if result.detail != '' {
		println(result.detail)
	}
}

pub fn prepare(options Options, compiler string, inherited map[string]string, mut runner Runner) ! {
	mut env := git_environment(inherited)!
	protect_modules(options, env, mut runner)!
	env['VMODULES'] = options.modules
	// File moves in released VPM cannot cross drives, so stage beside modules.
	staging_root := os.join_path(options.modules, '.vtmp')
	os.mkdir_all(staging_root)!
	staging := os.join_path(staging_root, rand.uuid_v4()[..8])
	os.mkdir(staging)!
	defer { os.rmdir_all(staging) or { eprintln(err) } }
	env['VTMP'] = staging
	println('Preparing pinned modules at ${options.modules}')
	verify_dependencies := ['run', 'scripts/check_installed_deps.vsh']
	dependencies := runner.invoke(compiler, verify_dependencies, options.project, env)
	if dependencies.ok {
		checked(dependencies, '')!
		println('Pinned dependencies are already installed.')
	} else {
		checked(runner.invoke(compiler, ['install'], options.project, env),
			'VPM installation failed. Resolve the reported error and rerun setup.')!
		checked(runner.invoke(compiler, verify_dependencies, options.project, env),
			'Installed dependencies do not match v.mod.')!
	}
	imgui := os.join_path(options.modules, 'antono2', 'imgui')
	checked(runner.invoke('git', ['-C', imgui, 'submodule', 'update', '--init', '--recursive'],
		options.project, env), 'ImGui submodule preparation failed.')!
	if options.prepare_only {
		println('Dependencies are ready. Run v run scripts/build_windows.vsh to build the player.')
		return
	}
	mut args := ['run', 'scripts/build_windows.vsh', '--modules', options.modules, '--compiler',
		options.compiler_mode]
	if options.output != '' {
		args << ['--output', options.output]
	}
	if options.verify {
		args << '--verify'
	}
	mut build_env := inherited.clone()
	build_env['VMODULES'] = options.modules
	build_env['VTMP'] = staging
	checked(runner.invoke(compiler, args, options.project, build_env),
		'Windows player build failed.')!
	println('Use the packaged player with --list-gpus to check playback support for your video.')
}
