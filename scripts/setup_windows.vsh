// Discover Windows build prerequisites and prepare the pinned player dependencies.
import flag
import os
import windowssetup

fn run(args []string) ! {
	project := os.dir(@DIR)
	mut parser := flag.new_flag_parser(args)
	parser.application('setup_windows')
	parser.description('Prepare the pinned player dependencies and build with the installed x64 toolchain.')
	modules := parser.string('modules', 0, '', 'override the V module directory')
	output := parser.string('output', 0, '', 'override the output directory')
	mode := parser.string('compiler', 0, 'stable', 'stable or v3')
	check := parser.bool('check', 0, false, 'check prerequisites without installing modules')
	prepare_only := parser.bool('prepare-only', 0, false, 'prepare modules without building')
	verify := parser.bool('verify', 0, false, 'run player tests and package checks after building')
	if parser.bool('help', `h`, false, 'show help') {
		println(parser.usage())
		return
	}
	if parser.finalize()!.len != 0 || mode !in ['stable', 'v3'] || (check && prepare_only) {
		return error(parser.usage())
	}
	windowssetup.check_prerequisites()!
	compiler := @VEXE
	mut runner := windowssetup.NativeRunner{}
	env := windowssetup.current_environment()
	pins := runner.invoke(compiler, ['run', 'scripts/compatibility.vsh'], project, env)
	if !pins.ok {
		return error(pins.detail)
	}
	if check {
		println('Build prerequisites look usable. Use the player --list-gpus to check hardware decoding.')
		return
	}
	windowssetup.prepare(windowssetup.Options{
		project:       project
		modules:       windowssetup.modules_directory(modules, project, os.getenv('VMODULES'))
		output:        if output == '' { '' } else { os.abs_path(output) }
		compiler_mode: mode
		prepare_only:  prepare_only
		verify:        verify
	}, compiler, env, mut runner)!
}

run(os.args[1..]) or {
	eprintln(err)
	exit(1)
}
