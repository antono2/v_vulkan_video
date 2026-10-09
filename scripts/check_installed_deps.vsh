#!/usr/bin/env -S v run
// Verify fresh VPM installations against the tags declared by this project.

import os
import v.vmod

fn check_dependencies() ! {
	root := os.dir(os.dir(os.real_path(@FILE)))
	manifest := vmod.from_file(os.join_path(root, 'v.mod'))!
	configured := os.getenv('VMODULES')
	modules := if configured != '' { configured } else { os.join_path(os.home_dir(), '.vmodules') }
	for dependency in manifest.dependencies {
		name, tag := dependency.rsplit_once('@') or {
			return error('Dependency is not pinned: ${dependency}')
		}
		module_dir := os.join_path(modules, ...name.split('.'))
		actual := os.execute('git -C ${os.quoted_path(module_dir)} rev-parse HEAD')
		expected := os.execute('git -C ${os.quoted_path(module_dir)} rev-parse ${os.quoted_path(tag + '^{commit}')}')
		if actual.exit_code != 0 || expected.exit_code != 0 {
			return error('Cannot verify installed ${dependency}: ${actual.output}${expected.output}')
		}
		if actual.output.trim_space() != expected.output.trim_space() {
			return error('Installed ${name} does not match ${tag}: ${actual.output.trim_space()}')
		}
		println('Verified ${dependency}')
	}
}

fn main() {
	check_dependencies() or {
		eprintln(err)
		exit(1)
	}
}
