// Drive compatibility, Linux builds, and release validation from GitHub CI.
import os

const player_name = 'v_vulkan_video'
const package_script = 'scripts/package_ci_ubuntu24.vsh'
const loader_smoke = 'scripts/smoke_vulkan_loader.vsh'

fn required_env(name string) !string {
	value := os.getenv(name)
	if value == '' {
		return error('${name} is required for this CI stage.')
	}
	return value
}

fn command(args []string) ! {
	executable := if os.is_abs_path(args[0]) {
		args[0]
	} else {
		os.find_abs_path_of_executable(args[0])!
	}
	mut child := os.new_process(executable)
	defer { child.close() }
	child.set_args(args[1..])
	child.wait()
	if child.code != 0 {
		return error('${args.join(' ')} exited with status ${child.code}.')
	}
}

fn compiler(args []string) ! {
	mut invocation := [@VEXE]
	invocation << args
	command(invocation)!
}

fn compatibility(profile string) ! {
	mut checks := ['scripts/compatibility.vsh', 'scripts/doctor.vsh']
	match profile {
		'release' { checks << 'scripts/hardware_evidence.vsh' }
		'fresh-linux' { checks << 'scripts/setup_linux.vsh' }
		'fresh-windows' {}
		else { return error('Unknown compatibility profile: ${profile}.') }
	}

	for script in checks {
		compiler(['run', script, '--self-test'])!
	}
	if profile == 'fresh-linux' {
		command(['sh', 'scripts/setup_linux.sh', '--help'])!
	}
	compiler(['run', 'scripts/compatibility.vsh', '--github-output', required_env('GITHUB_OUTPUT')!])!
}

fn identifier_start(character u8) bool {
	return character == `_` || (character >= `a` && character <= `z`)
		|| (character >= `A` && character <= `Z`)
}

fn declarations(source string) map[string]bool {
	prefix := 'pub struct C.'
	mut names := map[string]bool{}
	for line in source.split_into_lines() {
		if !line.starts_with(prefix) || line.len == prefix.len
			|| !identifier_start(line[prefix.len]) {
			continue
		}
		mut end := prefix.len + 1
		for end < line.len && (identifier_start(line[end]) || line[end].is_digit()) {
			end++
		}
		names[line[prefix.len..end]] = true
	}
	return names
}

fn duplicates(imgui string, implot string) []string {
	owned := declarations(imgui)
	return declarations(implot).keys().filter(it in owned).sorted()
}

fn check_ownership(imgui string) ! {
	duplicate := duplicates(os.read_file(os.join_path(imgui, 'imgui.v'))!, os.read_file(os.join_path(imgui,
		'implot', 'implot.v'))!)
	if duplicate.len > 0 {
		return error('Duplicate C declarations:\n${duplicate.join('\n')}')
	}
}

fn test_player(profile string) ! {
	mut flags := match profile {
		'shared' { ['-cc', 'gcc'] }
		'static' { ['-d', 'imgui_static', '-cc', 'gcc'] }
		'v3' { ['-new-compiler', '-cc', 'tcc'] }
		// Moving V uses V3 by default; the pinned snapshot still requires its flag.
		'master' { ['-cc', 'tcc'] }
		else { return error('Unknown Linux player profile: ${profile}.') }
	}

	mut tests := flags.clone()
	tests << ['test', '.']
	compiler(tests)!
	destination := if profile in ['v3', 'master'] {
		os.join_path(required_env('RUNNER_TEMP')!, player_name)
	} else {
		player_name
	}
	flags << ['-o', destination, '.']
	compiler(flags)!
	if profile in ['v3', 'master'] {
		compiler(['run', loader_smoke, destination])!
	}
}

fn window_startup() ! {
	temporary := required_env('RUNNER_TEMP')!
	probe := os.join_path(temporary, 'window-startup-probe')
	check := os.join_path(temporary, 'window-startup-check')
	logs := os.join_path(temporary, 'window-startup-logs')
	compiler(['-cc', 'tcc', '-o', probe, 'windowing/probe'])!
	compiler(['-cc', 'tcc', '-o', check, 'tests/desktop/window_startup.v'])!
	command([check, probe, logs])!
}

fn build_compiler(directory string, profile string) ! {
	mut args := ['make', '-C', directory, 'VEXE=./v']
	match profile {
		'pinned' { args << 'local=1' }
		'master' {}
		else { return error('Unknown compiler build profile: ${profile}.') }
	}

	command(args)!
	mut paths := os.open_append(required_env('GITHUB_PATH')!)!
	defer { paths.close() }
	paths.writeln(os.abs_path(directory))!
}

fn imgui_library_path() !string {
	return os.join_path(required_env('VMODULES')!, 'antono2', 'imgui', 'lib')
}

fn with_linux_library_path(args []string) ! {
	previous := os.getenv_opt('LD_LIBRARY_PATH')
	mut library := imgui_library_path()!
	if value := previous {
		if value != '' {
			library += ':' + value
		}
	}
	os.setenv('LD_LIBRARY_PATH', library, true)
	defer {
		if value := previous {
			os.setenv('LD_LIBRARY_PATH', value, true)
		} else {
			os.unsetenv('LD_LIBRARY_PATH')
		}
	}
	compiler(args)!
}

fn fresh_build() ! {
	// V initializes VMODULES before this script runs, so select the target afterward.
	modules := required_env('VKVIDEO_FRESH_MODULES')!
	if os.exists(modules) || os.is_link(modules) {
		return error('The fresh VPM module directory already exists: ${modules}.')
	}
	os.mkdir(modules)!
	os.setenv('VMODULES', modules, true)
	compiler(['run', 'scripts/build_linux.vsh', '--cc', 'tcc'])!
	compiler(['run', 'scripts/check_installed_deps.vsh'])!
}

fn fresh_test() ! {
	os.setenv('VMODULES', required_env('VKVIDEO_FRESH_MODULES')!, true)
	with_linux_library_path(['-cc', 'tcc', 'test', '.'])!
	with_linux_library_path(['run', loader_smoke, os.abs_path(player_name)])!
}

fn package_release(profile string) ! {
	archive := match profile {
		'regular' {
			compiler(['run', 'scripts/package_ubuntu24.vsh', '--help'])!
			'vkvideo-ubuntu24-amd64.zip'
		}
		'debug' {
			with_linux_library_path(['run', 'run.vsh', '--', '--help'])!
			compiler(['-d', 'debug', '-cc', 'gcc', '-o', player_name, '.'])!
			'vkvideo-ubuntu24-amd64-debug.zip'
		}
		else {
			return error('Unknown Ubuntu package profile: ${profile}.')
		}
	}

	compiler(['run', package_script, archive])!
}

fn self_test() {
	left := 'pub struct C.Z_2 {}\r\npub struct C.A\npub struct C.4invalid\n struct C.Hidden\n'
	right := 'pub struct C.Z_2\npub struct C.Own\npub struct C.A{}\npub struct C.A\npub struct C.Hidden'
	assert duplicates(left, right) == ['A', 'Z_2']
	assert duplicates(left, 'pub struct C.Unique').len == 0
	println('Binding ownership fixtures passed.')
}

fn run(args []string) ! {
	os.unsetenv('VEXE')
	if args.len == 3 && args[0] == 'build-compiler' {
		build_compiler(args[1], args[2])!
		return
	}
	// Resolve any caller-supplied checkout before changing to the player directory.
	if args.len == 2 && args[0] == 'binding-ownership' {
		check_ownership(os.abs_path(args[1]))!
		return
	}
	os.chdir(os.dir(@DIR))!
	if args.len == 2 {
		match args[0] {
			'compatibility' { compatibility(args[1])! }
			'test-player' { test_player(args[1])! }
			'package' { package_release(args[1])! }
			else { return error('Unknown Linux CI stage: ${args[0]}.') }
		}

		return
	}
	match args {
		['window-startup'] { window_startup()! }
		['fresh-build'] { fresh_build()! }
		['fresh-test'] { fresh_test()! }
		['--self-test'] { self_test() }
		else { return error('Expected a Linux player CI stage.') }
	}
}

run(os.args[1..]) or {
	eprintln(err)
	exit(1)
}
