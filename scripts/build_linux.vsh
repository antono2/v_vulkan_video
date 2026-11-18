// Build the Linux player against the selected compiler and native ImGui configuration.
import flag
import os

struct Options {
	compiler     string
	c_compiler   string
	linkage      string
	glfw         string
	glfw_version string
	skip_install bool
	help         bool
}

fn parse(args []string) !Options {
	mut parser := flag.new_flag_parser(args)
	parser.application('build_linux')
	parser.description('Build the player and its native dependencies on Linux.')
	compiler := parser.string('compiler', 0, 'stable', 'stable or v3 V frontend')
	cc := parser.string('cc', 0, '', 'gcc for stable and tcc for v3 by default')
	linkage := parser.string('linkage', 0, 'shared', 'shared or static Dear ImGui')
	glfw := parser.string('glfw', 0, 'system', 'system or bundled GLFW')
	glfw_version := parser.string('glfw-version', 0, '',
		'bundled GLFW release from compatibility.json by default')
	skip_install := parser.bool('skip-install', 0, false, 'use the installed V modules')
	if parser.bool('help', `h`, false, 'show this help') {
		println(parser.usage())
		return Options{
			help: true
		}
	}
	if parser.finalize()!.len != 0 {
		return error(parser.usage())
	}
	if compiler !in ['stable', 'v3'] || cc !in ['', 'tcc', 'gcc']
		|| linkage !in ['shared', 'static'] || glfw !in ['system', 'bundled'] {
		return error('Choose a supported compiler, C compiler, linkage, and GLFW provider.\n' +
			parser.usage())
	}
	return Options{
		compiler:     compiler
		c_compiler:   if cc != '' {
			cc
		} else if compiler == 'v3' {
			'tcc'
		} else {
			'gcc'
		}
		linkage:      linkage
		glfw:         glfw
		glfw_version: glfw_version
		skip_install: skip_install
	}
}

fn run(arguments []string) ! {
	executable_path := if os.is_abs_path(arguments[0]) {
		arguments[0]
	} else {
		os.find_abs_path_of_executable(arguments[0])!
	}
	mut process := os.new_process(executable_path)
	process.set_args(arguments[1..])
	process.wait()
	defer { process.close() }
	if process.code != 0 {
		return error('${arguments[0]} exited with status ${process.code}')
	}
}

fn build(options Options) ! {
	root := os.dir(@DIR)
	os.chdir(root)!
	compiler := @VEXE
	compatibility := os.exec([compiler, 'run', 'scripts/compatibility.vsh', '--get', 'glfw'])
	if compatibility.exit_code != 0 {
		return error(compatibility.output.trim_space())
	}
	glfw_version := if options.glfw_version == '' {
		compatibility.output.trim_space()
	} else {
		options.glfw_version
	}
	if !options.skip_install {
		run([compiler, 'install'])!
	}
	// V accepts a colon-delimited module lookup path. VPM installs into its first entry.
	modules := os.vmodules_dir().all_before(':')
	mut imgui := os.join_path(modules, 'antono2', 'imgui')
	if !os.is_file(os.join_path(imgui, 'build_vimgui.vsh')) {
		imgui = os.join_path(modules, 'imgui')
	}
	native_build := os.join_path(imgui, 'build_vimgui.vsh')
	if !os.is_file(native_build) {
		return error('ImGui module missing. Run v install antono2.imgui or omit --skip-install.')
	}
	run(['git', '-C', imgui, 'submodule', 'update', '--init', '--recursive'])!
	run([compiler, 'run', native_build, '--linkage', options.linkage, '--glfw', options.glfw,
		'--glfw-version', glfw_version])!
	mut arguments := [compiler]
	if options.compiler == 'v3' {
		arguments << '-new-compiler'
	}
	if options.linkage == 'static' {
		arguments << ['-d', 'imgui_static']
	}
	arguments << ['-cc', options.c_compiler, '-o', 'v_vulkan_video', '.']
	run(arguments)!
	println('Built ${os.join_path(root, 'v_vulkan_video')} with ${options.compiler} V, ${options.c_compiler}, ${options.linkage} ImGui and ${options.glfw} GLFW.')
}

fn main() {
	options := parse(os.args[1..]) or {
		eprintln(err)
		exit(2)
	}
	if options.help {
		return
	}
	build(options) or {
		eprintln(err)
		exit(1)
	}
}
