// Package the prebuilt CI player for Ubuntu 24.04 x86-64.
import os
import ubuntupackage

fn run(args []string) ! {
	usage := 'Usage: v run scripts/package_ci_ubuntu24.vsh [ARCHIVE.zip]'
	if args == ['--help'] || args == ['-h'] {
		println(usage)
		return
	}
	if args.len > 1 {
		return error(usage)
	}
	root := os.dir(@DIR)
	modules_setting := os.getenv_opt('VMODULES') or {
		return error('VMODULES must point to the checked-out V modules')
	}
	modules := modules_setting.all_before(os.path_delimiter)
	output := if args.len == 1 {
		os.abs_path(args[0])
	} else {
		os.join_path(root, ubuntupackage.package_name + '.zip')
	}
	ubuntupackage.package(ubuntupackage.Inputs{
		project:  root
		modules:  modules
		imgui:    os.join_path(modules, 'antono2', 'imgui')
		player:   os.join_path(root, ubuntupackage.player_name)
		compiler: @VEXE
	}, output)!
}

run(os.args[1..]) or {
	eprintln(err)
	exit(1)
}
