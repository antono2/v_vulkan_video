// Package the Windows player or verify an archive on any supported host.
import os
import windowspackage

const usage = 'Usage: v run scripts/package_windows.vsh build OUTPUT_DIRECTORY MODULES_DIRECTORY COMPILER PLAYER IMGUI_DLL GLFW_DLL\n       v run scripts/package_windows.vsh verify [ARCHIVE.zip]'

fn run(args []string) ! {
	if args in [['--help'], ['-h']] {
		println(usage)
		return
	}
	project := os.dir(@DIR)
	if args.len == 7 && args[0] == 'build' {
		sdk := os.getenv('VULKAN_SDK')
		setting := os.getenv('VULKAN_SDK_VERSION')
		version := if setting == '' { os.file_name(sdk.trim_right('/\\')) } else { setting }
		return windowspackage.package(windowspackage.Inputs{
			project:    project
			modules:    os.abs_path(args[2])
			compiler:   args[3]
			executable: os.abs_path(args[4])
			imgui:      os.abs_path(args[5])
			glfw:       os.abs_path(args[6])
			sdk:        version
		}, os.abs_path(args[1]))
	}
	if args == ['verify'] || (args.len == 2 && args[0] == 'verify') {
		archive := args[1] or { os.join_path('dist', windowspackage.name + '.zip') }
		return windowspackage.verify(project, os.abs_path(archive))
	}
	return error(usage)
}

run(os.args[1..]) or {
	eprintln(err)
	exit(1)
}
