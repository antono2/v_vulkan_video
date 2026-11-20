// Build Windows player artifacts with the Visual Studio environment already active.
import flag
import os
import probeio
import rand
import time
import windowspackage

const glfw_version = '3.4'
const executable_name = 'v_vulkan_video.exe'
const sample_media = 'res/20240917_095400.mp4'
const player_probe_timeout = 2 * time.minute

struct BuildOptions {
	project       string
	modules       string
	output        string
	compiler_mode string
	verify        bool
}

fn tool(name string) !string {
	path := probeio.find_executable(name)
	if path == '' {
		return error('Required command is unavailable: ${name}')
	}
	return path
}

fn command(executable string, args []string, cwd string) ! {
	mut child := os.new_process(executable)
	defer { child.close() }
	child.set_args(args)
	child.set_work_folder(cwd)
	child.run()
	child.wait()
	if child.code != 0 {
		return error('${os.file_name(executable)} exited with status ${child.code}: ${args.join(' ')}')
	}
}

fn module_directory(requested string, project string) string {
	if requested != '' {
		return os.abs_path(requested)
	}
	configured := os.getenv('VMODULES')
	if configured != '' {
		return os.abs_path(configured.all_before(os.path_delimiter))
	}
	bundled := os.join_path(os.dir(project), 'modules')
	if os.is_file(os.join_path(bundled, 'antono2', 'imgui', 'CMakeLists.txt')) {
		return bundled
	}
	return os.join_path(os.home_dir(), '.vmodules')
}

fn native_artifact(files []string, name string, bundled_header bool) !string {
	for path in files {
		if os.file_name(path).to_lower_ascii() != name {
			continue
		}
		normalized := path.replace('\\', '/').to_lower_ascii()
		if !bundled_header
			|| (normalized.contains('/glfw-src/') && normalized.ends_with('/include/glfw/glfw3.h')) {
			return path
		}
	}
	return error('The native build did not produce ${name}.')
}

fn verify_release(options BuildOptions, compiler string, flags []string) ! {
	player := os.join_path(options.output, executable_name)
	// The packaged DLLs must be found before any SDK or globally installed copies.
	old_path := os.getenv('PATH')
	os.setenv('PATH', options.output + os.path_delimiter + old_path, true)
	defer { os.setenv('PATH', old_path, true) }
	help := probeio.run_probe(player, ['--help'], player_probe_timeout)
	if !help.ok || !help.detail.contains('Usage:') {
		return error('The Windows player did not print its command-line help.\n${help.detail}')
	}
	gpus := probeio.run_probe(player, ['--list-gpus', os.join_path(options.output, sample_media)],
		player_probe_timeout)
	if !gpus.ok || !gpus.detail.contains('Vulkan devices for H.264') {
		return error('The Windows player could not enumerate Vulkan devices.\n${gpus.detail}')
	}
	println('Windows player help and Vulkan device enumeration passed.')
	mut args := flags.clone()
	args << ['test', '.']
	command(compiler, args, options.project)!
	windowspackage.verify(options.project, options.output + '.zip')!
}

fn build(options BuildOptions) ! {
	imgui := os.join_path(options.modules, 'antono2', 'imgui')
	if !os.is_file(os.join_path(imgui, 'CMakeLists.txt')) {
		return error('ImGui module not found at ${options.modules}; run v install or pass --modules.')
	}
	println('Using V modules at ${options.modules}')
	sdk := os.getenv('VULKAN_SDK')
	if sdk == '' || !os.is_file(os.join_path(sdk, 'Include', 'vulkan', 'vulkan.h')) {
		return error('Set VULKAN_SDK to the installed Vulkan SDK before building.')
	}
	compiler := tool('v')!
	cmake := tool('cmake')!
	tool('cl')!
	// Every build owns a fresh CMake cache. A failed download cannot poison
	// the next build, and an existing .build directory is never deleted.
	stage := os.join_path(os.temp_dir(), 'vkvideo-imgui-' + rand.uuid_v4())
	os.mkdir(stage, mode: 0o700)!
	defer { os.rmdir_all(stage) or { eprintln(err) } }
	build_dir := os.join_path(stage, 'native')
	glfw_lib := os.join_path(stage, 'glfw-lib')
	os.mkdir(glfw_lib)!
	imgui_lib := os.join_path(imgui, 'lib')
	os.mkdir_all(imgui_lib)!
	os.setenv('VMODULES', options.modules, true)
	command(cmake, ['-S', imgui, '-B', build_dir, '-A', 'x64', '-DSTATIC_BUILD=OFF',
		'-DVIMGUI_GLFW_PROVIDER=bundled', '-DVIMGUI_GLFW_VERSION=${glfw_version}',
		'-DVIMGUI_OUTPUT_DIR=${os.join_path(build_dir,
			'output')}',
		r'-DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded$<$<CONFIG:Debug>:Debug>',
		'-DCIMGUI_NO_EXPORT=OFF', '-DIMGUI_FREETYPE=OFF'], options.project)!
	command(cmake, ['--build', build_dir, '--config', 'Release', '--parallel'], options.project)!
	files := os.walk_ext(build_dir, '').sorted()
	imgui_dll := native_artifact(files, 'vimgui.dll', false)!
	imgui_import := native_artifact(files, 'vimgui.lib', false)!
	glfw_dll := native_artifact(files, 'glfw3.dll', false)!
	glfw_import := native_artifact(files, 'glfw3dll.lib', false)!
	glfw_header := native_artifact(files, 'glfw3.h', true)!
	os.cp(imgui_import, os.join_path(imgui_lib, 'vimgui.lib'))!
	os.cp(glfw_import, os.join_path(glfw_lib, 'glfw3.lib'))!
	os.setenv('GLFW_INCLUDE', os.dir(os.dir(glfw_header)), true)
	os.setenv('GLFW_LIB', glfw_lib, true)
	player := os.join_path(stage, executable_name)
	// Avoid legacy Winsock headers before V's Winsock2 declarations.
	mut flags := ['-cc', 'msvc', '-cflags', '/DWIN32_LEAN_AND_MEAN']
	if options.compiler_mode == 'v3' {
		flags << '-new-compiler'
	}
	mut args := flags.clone()
	args << ['-subsystem', 'console', '-cflags', '/MT', '-o', player, '.']
	command(compiler, args, options.project)!
	sdk_version := os.getenv('VULKAN_SDK_VERSION')
	windowspackage.package(windowspackage.Inputs{
		project:    options.project
		modules:    options.modules
		compiler:   options.compiler_mode
		executable: player
		imgui:      imgui_dll
		glfw:       glfw_dll
		sdk:        if sdk_version == '' { os.file_name(sdk.trim_right('/\\')) } else { sdk_version }
	}, options.output)!
	if options.verify {
		verify_release(options, compiler, flags)!
	}
}

fn run(args []string) ! {
	project := os.dir(@DIR)
	mut parser := flag.new_flag_parser(args)
	parser.application('build_windows')
	parser.description('Build the Windows player and its release ZIP from a configured x64 toolchain.')
	output := parser.string('output', 0, os.join_path(project, 'dist', windowspackage.name),
		'output directory')
	modules := parser.string('modules', 0, '', 'override the V module directory')
	mode := parser.string('compiler', 0, 'stable', 'stable or v3')
	verify := parser.bool('verify', 0, false, 'run the player probes, tests and archive verifier')
	if parser.bool('help', `h`, false, 'show help') {
		println(parser.usage())
		return
	}
	if parser.finalize()!.len != 0 || mode !in ['stable', 'v3'] {
		return error(parser.usage())
	}
	build(BuildOptions{
		project:       project
		modules:       module_directory(modules, project)
		output:        os.abs_path(output)
		compiler_mode: mode
		verify:        verify
	})!
}

run(os.args[1..]) or {
	eprintln(err)
	exit(1)
}
