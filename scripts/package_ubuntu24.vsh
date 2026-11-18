// Build the relocatable player inside a selected Ubuntu 24.04 root filesystem.
import os
import rand
import ubuntupackage

fn setting(name string, default_value string) string {
	value := os.getenv(name)
	return if value == '' { default_value } else { value }
}

fn resolve_compiler() !string {
	value := setting('V_BIN', @VEXE)
	path := if os.is_file(value) { value } else { os.find_abs_path_of_executable(value)! }
	return os.real_path(path)
}

fn run_sandbox(args []string) ! {
	mut process := os.new_process(os.find_abs_path_of_executable(args[0])!)
	process.set_args(args[1..])
	process.run()
	process.wait()
	defer { process.close() }
	if process.code != 0 {
		return error('Ubuntu build sandbox exited with status ${process.code}')
	}
}

fn build_commands(input ubuntupackage.Inputs, workspace string, sdk string, products string) ! {
	mut sandbox := ubuntupackage.sandbox(input.runtime_root)
	sandbox << ['--ro-bind', workspace, workspace]
	compiler_directory := os.dir(input.compiler)
	if !compiler_directory.starts_with(workspace + '/') && compiler_directory != workspace {
		sandbox << ['--ro-bind', compiler_directory, compiler_directory]
	}
	if sdk != '/usr' && !sdk.starts_with(workspace + '/') && os.is_dir(sdk) {
		sandbox << ['--ro-bind', sdk, sdk]
	}
	sandbox << ['--bind', input.modules, input.modules]
	if !input.imgui.starts_with(input.modules + '/') {
		sandbox << ['--bind', input.imgui, input.imgui]
	}

	workspace_mapping := '-ffile-prefix-map=${workspace}=/workspace'
	modules_mapping := '-ffile-prefix-map=${input.modules}=/vmodules'
	flags := '${workspace_mapping} ${modules_mapping}'
	environment := ['env', 'VMODULES=${input.modules}', 'VULKAN_SDK=${sdk}']

	mut build_imgui := sandbox.clone()
	build_imgui << ['--chdir', input.imgui]
	build_imgui << environment
	build_imgui << ['CMAKE_BUILD_TYPE=' + setting('VIMGUI_BUILD_TYPE', 'Release'), 'CFLAGS=${flags}',
		'CXXFLAGS=${flags}', input.compiler, 'run', './build_vimgui.vsh', '--linkage', 'shared',
		'--glfw', setting('VIMGUI_GLFW_PROVIDER', 'system'), '--glfw-version',
		setting('VIMGUI_GLFW_VERSION', '3.3')]
	run_sandbox(build_imgui)!

	mut build_player := sandbox.clone()
	products_mount := '/tmp/vkvideo-build'
	build_player << ['--bind', products, products_mount, '--chdir', input.project]
	build_player << environment
	build_player << [input.compiler, '-cc', 'gcc', '-cflags', workspace_mapping, '-cflags',
		modules_mapping, '-o', os.join_path(products_mount, ubuntupackage.player_name), '.']
	run_sandbox(build_player)!
}

fn run(args []string) ! {
	usage := 'Usage: v run scripts/package_ubuntu24.vsh [ARCHIVE.zip]'
	if args == ['--help'] || args == ['-h'] {
		println(usage)
		return
	}
	if args.len > 1 {
		return error(usage)
	}
	project := os.real_path(os.dir(@DIR))
	workspace := os.dir(project)
	runtime := os.abs_path(setting('UBUNTU24_ROOTFS', os.join_path(workspace, '.buildroots',
		'ubuntu-24.04')))
	sdk := os.abs_path(setting('VULKAN_SDK', os.join_path(workspace, '1.4.341.1', 'x86_64')))
	modules := os.real_path(setting('VMODULES', os.vmodules_dir()).all_before(os.path_delimiter))
	imgui_default := os.join_path(modules, 'antono2', 'imgui')
	imgui := os.real_path(setting('VIMGUI_DIR', if os.is_file(os.join_path(imgui_default,
		'build_vimgui.vsh')) {
		imgui_default
	} else {
		os.join_path(modules, 'imgui')
	}))
	for required in [os.join_path(runtime, 'usr/bin/patchelf'),
		os.join_path(imgui, 'build_vimgui.vsh'), os.join_path(project, ubuntupackage.demo_video)] {
		if !os.is_file(required) {
			return error('Missing required build input: ${required}')
		}
	}
	compiler := resolve_compiler()!
	output := if args.len == 1 {
		os.abs_path(args[0])
	} else {
		os.join_path(workspace, 'vkvideo_ubuntu24_amd64.zip')
	}
	build := os.join_path(workspace, '.vkvideo-build-' + rand.uuid_v4())
	os.mkdir(build)!
	defer { os.rmdir_all(build) or {} }
	input := ubuntupackage.Inputs{
		project:       project
		modules:       modules
		imgui:         imgui
		player:        os.join_path(build, ubuntupackage.player_name)
		compiler:      compiler
		compiler_mode: 'default'
		runtime_root:  runtime
		sandbox_tools: true
	}
	build_commands(input, workspace, sdk, build)!
	ubuntupackage.package(input, output)!
}

run(os.args[1..]) or {
	eprintln(err)
	exit(1)
}
