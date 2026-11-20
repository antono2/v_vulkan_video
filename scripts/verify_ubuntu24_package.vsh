// Verify the checksum, redistribution notices, and loader paths in an Ubuntu package.
import os
import packagezip
import rand

const package_name = 'vkvideo-ubuntu24-amd64'
const bundled_libraries = ['libvimgui.so', 'libglfw.so.3', 'libstdc++.so.6', 'libgcc_s.so.1']
const package_modules = ['vulkan', 'vkmemalloc', 'memory', 'imgui', 'glfw', 'minimp4', 'h264']

fn command(args []string) !string {
	result := os.exec(args)
	if result.exit_code != 0 {
		return error('${args[0]} exited with status ${result.exit_code}\n${result.output}')
	}
	return result.output.trim_right('\r\n')
}

fn verify_contents(directory string) ! {
	root := os.dir(@DIR)
	mut paths := ['BUILD-INFO.txt', 'LICENSE', 'MEDIA.txt', 'README.txt', 'v_vulkan_video',
		'res/20240917_095400.mp4', 'licenses/libstdc++6.txt', 'licenses/libgcc-s1.txt']
	paths << bundled_libraries.map('lib/' + it)
	for index, line in os.read_lines(os.join_path(root, 'packaging', 'licenses.manifest'))! {
		fields := line.fields()
		if fields.len != 3 {
			return error('invalid license manifest row ${index + 1}')
		}
		paths << 'licenses/' + fields[2]
	}
	for relative in paths {
		path := os.join_path(directory, relative)
		if !os.is_file(path) || os.file_size(path) == 0 {
			return error('Package is missing: ${relative}')
		}
	}
	mut labels := ['Source revision', 'V compiler', 'Compiler mode', 'C compiler', 'Vulkan SDK']
	labels << package_modules.map('Module ' + it)
	records := os.read_lines(os.join_path(directory, 'BUILD-INFO.txt'))!
	for label in labels {
		prefix := label + ': '
		if !records.any(it.starts_with(prefix) && it.len > prefix.len) {
			return error('Package build record is missing: ${label}')
		}
	}
}

fn verify_runtime(directory string, patchelf string) ! {
	player := os.join_path(directory, 'v_vulkan_video')
	imgui := os.join_path(directory, 'lib', 'libvimgui.so')
	binary := command(['file', player])!
	if !binary.contains('ELF 64-bit') || !binary.contains('x86-64') {
		return error('Player is not an x86-64 ELF binary')
	}
	player_rpath := command([patchelf, '--print-rpath', player])!
	library_rpath := command([patchelf, '--print-rpath', imgui])!
	if player_rpath != r'$ORIGIN/lib' {
		return error('Unexpected player RUNPATH: ${player_rpath}')
	}
	if library_rpath != r'$ORIGIN' {
		return error('Unexpected libvimgui RUNPATH: ${library_rpath}')
	}
	// Resolve function relocations as well as SONAMEs through the package RUNPATHs.
	loader := command(['env', '-u', 'LD_LIBRARY_PATH', 'LC_ALL=C', 'ldd', '-r', player])!
	if loader.contains('not found') || loader.contains('undefined symbol') {
		return error('Package has unresolved shared-library dependencies or symbols:\n${loader}')
	}
	for library in bundled_libraries {
		if !loader.contains(os.join_path(directory, 'lib', library)) {
			return error('Player does not resolve ${library} from its package directory')
		}
	}
	dynamic := command(['readelf', '-d', player, imgui])!
	if dynamic.split_into_lines().any(it.contains('/home/') && it.all_after('/home/').contains('/')) {
		return error('Package contains an absolute build-user ELF loader path')
	}
	help := command(['env', '-u', 'LD_LIBRARY_PATH', player, '--help'])!
	if !help.contains('Usage:') {
		return error('The packaged executable did not print its usage')
	}
}

fn verify(archive string) ! {
	packagezip.verify_checksum(archive)!
	tool := os.getenv_opt('PATCHELF') or { os.find_abs_path_of_executable('patchelf') or { '' } }
	if tool == '' || !os.is_executable(tool) {
		return error('patchelf is required (or set PATCHELF to its executable path)')
	}
	stage := os.join_path(os.temp_dir(), 'vkvideo-verify-' + rand.uuid_v4())
	os.mkdir(stage, mode: 0o700)!
	defer { os.rmdir_all(stage) or {} }
	packagezip.extract(archive, package_name, stage)!
	directory := os.join_path(stage, package_name)
	verify_contents(directory)!
	verify_runtime(directory, tool)!
	println('Verified relocatable Ubuntu 24 package: ${archive}')
}

fn run(args []string) ! {
	usage := 'Usage: v run scripts/verify_ubuntu24_package.vsh ARCHIVE.zip'
	if args == ['--help'] || args == ['-h'] {
		println(usage)
		return
	}
	if args.len != 1 {
		return error(usage)
	}
	verify(os.abs_path(args[0]))!
}

run(os.args[1..]) or {
	eprintln(err)
	exit(1)
}
