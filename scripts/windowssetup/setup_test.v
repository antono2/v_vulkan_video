module windowssetup

import os
import probeio
import rand

const fixture_compiler = 'fixture-v'
const inherited = {
	'GIT_CONFIG_COUNT':   '1'
	'GIT_CONFIG_KEY_0':   'fixture.original'
	'GIT_CONFIG_VALUE_0': 'preserved'
	'VTMP':               'unrelated temp'
}

struct Fixture {
	options Options
	failure string
	ready   bool
mut:
	calls  []string
	stages []string
}

fn (mut fixture Fixture) invoke(program string, args []string, project string, env map[string]string) probeio.ProbeResult {
	assert project == fixture.options.project
	assert env['GIT_CONFIG_KEY_0'] == 'fixture.original'
	assert env['GIT_CONFIG_VALUE_0'] == 'preserved'
	build := program == fixture_compiler && args[0] == 'run'
		&& args[1] == 'scripts/build_windows.vsh'
	if build {
		assert env['GIT_CONFIG_COUNT'] == '1'
		assert 'GIT_CONFIG_KEY_1' !in env
	} else {
		assert env['GIT_CONFIG_COUNT'] == '2'
		assert env['GIT_CONFIG_KEY_1'] == 'core.longpaths'
		assert env['GIT_CONFIG_VALUE_1'] == 'true'
	}
	if program == 'git' && args[2] in ['status', 'rev-list'] {
		assert env['VTMP'] == 'unrelated temp'
		fixture.calls << args[2]
		failure := if args[2] == 'status' { 'dirty' } else { 'unpublished' }
		return probeio.ProbeResult{
			ok:     true
			detail: if fixture.failure == failure { 'local work' } else { '' }
		}
	}
	assert env['VMODULES'] == fixture.options.modules
	stage := env['VTMP']
	assert os.dir(stage) == os.join_path(fixture.options.modules, '.vtmp')
	assert os.is_dir(stage)
	fixture.stages << stage
	if program == 'git' {
		assert args == ['-C', os.join_path(fixture.options.modules, 'antono2', 'imgui'),
			'submodule', 'update', '--init', '--recursive']
		fixture.calls << 'submodules'
		return probeio.ProbeResult{
			ok: fixture.failure != 'submodules'
		}
	}
	assert program == fixture_compiler
	if build {
		assert args == ['run', 'scripts/build_windows.vsh', '--modules', fixture.options.modules,
			'--compiler', 'v3', '--output', fixture.options.output, '--verify']
		fixture.calls << 'build'
		return probeio.ProbeResult{
			ok: fixture.failure != 'build'
		}
	}
	if args == ['install'] {
		fixture.calls << 'install'
		return probeio.ProbeResult{
			ok: fixture.failure != 'install'
		}
	}
	assert args == ['run', 'scripts/check_installed_deps.vsh']
	fixture.calls << 'dependencies'
	return probeio.ProbeResult{
		ok: fixture.ready || ('install' in fixture.calls && fixture.failure != 'revisions')
	}
}

fn test_prepare_and_build_preserve_arguments_and_remove_their_staging() ! {
	root := os.join_path(os.temp_dir(), 'vkvideo setup tests ' + rand.uuid_v4())
	defer { os.rmdir_all(root) or {} }
	options := Options{
		project:       os.join_path(root, 'project outside bundle')
		modules:       os.join_path(root, 'modules with spaces')
		output:        os.join_path(root, 'package with spaces')
		compiler_mode: 'v3'
		verify:        true
	}
	mut fixture := Fixture{
		options: options
	}
	prepare(options, fixture_compiler, inherited, mut fixture)!
	assert fixture.calls == ['dependencies', 'install', 'dependencies', 'submodules', 'build']
	stage := fixture.stages[0]
	assert fixture.stages.all(it == stage)
	assert !os.exists(stage)
	assert inherited['GIT_CONFIG_COUNT'] == '1'

	only := Options{
		...options
		prepare_only: true
	}
	mut repeat := Fixture{
		options: only
		ready:   true
	}
	prepare(only, fixture_compiler, inherited, mut repeat)!
	assert repeat.calls == ['dependencies', 'submodules']
	assert repeat.stages[0] != stage
	assert !os.exists(repeat.stages[0])
}

fn test_failed_commands_stop_preparation_and_clean_staging() ! {
	root := os.join_path(os.temp_dir(), 'vkvideo setup failures ' + rand.uuid_v4())
	defer { os.rmdir_all(root) or {} }
	options := Options{
		project:       root
		modules:       os.join_path(root, 'modules with spaces')
		output:        os.join_path(root, 'package with spaces')
		compiler_mode: 'v3'
		verify:        true
	}
	cases := {
		'install':    'VPM installation failed'
		'revisions':  'Installed dependencies do not match'
		'submodules': 'ImGui submodule preparation failed'
		'build':      'Windows player build failed'
	}
	for failure, message in cases {
		mut fixture := Fixture{
			options: options
			failure: failure
		}
		mut refused := false
		prepare(options, fixture_compiler, inherited, mut fixture) or {
			assert err.msg().starts_with(message)
			refused = true
		}
		assert refused
		assert fixture.stages.all(!os.exists(it))
		assert (fixture.calls.last() == 'dependencies' && failure == 'revisions')
			|| fixture.calls.last() == failure
	}
}

fn test_existing_unpublished_or_dirty_modules_survive() ! {
	root := os.join_path(os.temp_dir(), 'vkvideo local work ' + rand.uuid_v4())
	defer { os.rmdir_all(root) or {} }
	module_path := os.join_path(root, 'antono2', 'fixture')
	os.mkdir_all(module_path)!
	os.write_file(os.join_path(module_path, '.git'), 'gitdir: linked worktree')!
	options := Options{
		project:      root
		modules:      root
		prepare_only: true
	}
	for failure in ['dirty', 'unpublished'] {
		mut fixture := Fixture{
			options: options
			failure: failure
		}
		mut refused := false
		prepare(options, fixture_compiler, inherited, mut fixture) or {
			assert err.msg().starts_with('Preserve ')
			refused = true
		}
		assert refused
		assert fixture.stages.len == 0
		assert 'install' !in fixture.calls
		assert !os.exists(os.join_path(root, '.vtmp'))
	}
}

fn test_module_resolution_and_git_config_rejection() ! {
	root := os.join_path(os.temp_dir(), 'vkvideo bundle ' + rand.uuid_v4())
	defer { os.rmdir_all(root) or {} }
	project := os.join_path(root, 'player')
	bundled := os.join_path(root, 'modules')
	imgui := os.join_path(bundled, 'antono2', 'imgui')
	os.mkdir_all(imgui)!
	os.write_file(os.join_path(imgui, 'CMakeLists.txt'), '')!
	configured := os.join_path(root, 'explicit environment')
	assert modules_directory('', project, '') == bundled
	assert modules_directory('', project, configured + os.path_delimiter + 'ignored') == configured
	assert modules_directory(bundled, project, configured) == bundled
	for value in ['-1', 'invalid', max_i32.str()] {
		mut refused := false
		git_environment({
			'GIT_CONFIG_COUNT': value
		}) or {
			refused = true
			map[string]string{}
		}
		assert refused
	}
}
