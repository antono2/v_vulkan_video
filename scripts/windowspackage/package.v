// Assemble and inspect the Windows player archive without a shell archive tool.
module windowspackage

import compress.szip
import os
import packagezip
import rand

pub const name = 'vkvideo-windows-x64'
const media = 'res/20240917_095400.mp4'
const build_record = 'BUILD-INFO.txt'
const bundled = ['LICENSE', 'MEDIA.txt', 'README.txt', 'glfw3.dll', media, 'run.bat',
	'v_vulkan_video.exe', 'vimgui.dll']
const modules = ['vulkan', 'vkmemalloc', 'memory', 'imgui', 'glfw', 'minimp4', 'h264']

pub struct Inputs {
pub:
	project    string
	modules    string
	compiler   string
	executable string
	imgui      string
	glfw       string
	sdk        string
}

struct License {
	module_name string
	source      string
	target      string
}

fn licenses(project string) ![]License {
	mut entries := []License{}
	mut targets := map[string]bool{}
	for index, line in os.read_lines(os.join_path(project, 'packaging', 'licenses.manifest'))! {
		fields := line.fields()
		if fields.len != 3 || fields[2].contains_any('/\\:') || fields[2] in ['.', '..']
			|| fields[2] in targets {
			return error('Invalid license manifest row ${index + 1}: ${line}')
		}
		targets[fields[2]] = true
		entries << License{fields[0], fields[1], 'licenses/' + fields[2]}
	}
	return entries
}

fn expected_files(entries []License) []string {
	mut paths := [build_record]
	paths << bundled
	paths << entries.map(it.target)
	return paths.sorted()
}

fn command(args []string) !string {
	result := os.exec(args)
	if result.exit_code != 0 {
		return error('${args[0]} exited with status ${result.exit_code}\n${result.output}')
	}
	return result.output.trim_right('\r\n')
}

fn revision(directory string) !string {
	if os.exists(os.join_path(directory, '.git')) {
		return command(['git', '-C', directory, 'rev-parse', 'HEAD'])
	}
	path := os.join_path(directory, 'SOURCE_REVISION')
	return if os.is_file(path) {
		os.read_file(path)!.trim_space()
	} else {
		'unrecorded source checkout'
	}
}

fn copy_file(source string, destination string) ! {
	if !os.is_file(source) || os.file_size(source) == 0 {
		return error('Package input is missing or empty: ${source}')
	}
	os.mkdir_all(os.dir(destination))!
	os.cp(source, destination)!
}

fn stage_files(input Inputs, directory string, entries []License) ! {
	for relative, source in {
		'LICENSE':            os.join_path(input.project, 'LICENSE')
		'MEDIA.txt':          os.join_path(input.project, 'res', 'README.md')
		'README.txt':         os.join_path(input.project, 'packaging', 'windows', 'README.txt')
		'glfw3.dll':          input.glfw
		media:                os.join_path(input.project, media)
		'run.bat':            os.join_path(input.project, 'packaging', 'windows', 'run.bat')
		'v_vulkan_video.exe': input.executable
		'vimgui.dll':         input.imgui
	} {
		copy_file(source, os.join_path(directory, relative))!
	}
	for entry in entries {
		source := os.join_path(input.modules, 'antono2', entry.module_name, entry.source)
		copy_file(source, os.join_path(directory, entry.target))!
	}
	compiler := os.find_abs_path_of_executable('v') or { @VEXE }
	mut records := [
		'Source revision: ${revision(input.project)!}',
		'V compiler: ${command([compiler, 'version'])!}',
		'Compiler mode: ${input.compiler}',
		'C compiler: MSVC',
		'Vulkan SDK: ${input.sdk}',
	]
	for module_name in modules {
		module_path := os.join_path(input.modules, 'antono2', module_name)
		records << 'Module ${module_name}: ${revision(module_path)!}'
	}
	os.write_file(os.join_path(directory, build_record), records.join('\n') + '\n')!
}

pub fn package(input Inputs, output string) ! {
	if input.compiler !in ['stable', 'v3'] || input.sdk == '' {
		return error('Supply the Windows compiler mode and Vulkan SDK version.')
	}
	entries := licenses(input.project)!
	paths := expected_files(entries)
	os.mkdir_all(os.dir(output))!
	stage := os.join_path(os.dir(output), '.vkvideo-windows-' + rand.uuid_v4())
	os.mkdir(stage)!
	defer { os.rmdir_all(stage) or {} }
	directory := os.join_path(stage, 'unpacked')
	archive := os.join_path(stage, os.file_name(output) + '.zip')
	stage_files(input, directory, entries)!
	packagezip.write_entries(archive, name, directory, paths)!
	sum := archive + '.sha256'
	os.write_file(sum, '${packagezip.file_hash(archive)!}  ${os.file_name(archive)}\n')!
	verify(input.project, archive)!
	// Update the local unpacked view from the same clean inputs as the archive.
	for relative in paths {
		copy_file(os.join_path(directory, relative), os.join_path(output, relative))!
	}
	os.mv(archive, output + '.zip', overwrite: true)!
	os.mv(sum, output + '.zip.sha256', overwrite: true)!
	println('Built Windows package with the ${input.compiler} V compiler: ${output}.zip')
}

fn verify_build_record(text string) ! {
	records := text.trim_string_left('\xef\xbb\xbf').split_into_lines()
	mut labels := ['Source revision', 'V compiler', 'Compiler mode', 'C compiler', 'Vulkan SDK']
	labels << modules.map('Module ' + it)
	for label in labels {
		prefix := label + ': '
		if !records.any(it.starts_with(prefix) && it[prefix.len..].trim_space() != '') {
			return error('Missing Windows build record: ${label}')
		}
	}
}

fn verify_contents(paths []string, archive string, scratch string) ! {
	mut zip := szip.open(archive, .no_compression, .read_only)!
	defer { zip.close() }
	mut seen := map[string]bool{}
	prefix := name + '/'
	for index in 0 .. zip.total()! {
		zip.open_entry_by_index(index)!
		path := zip.name().replace('\\', '/')
		if !path.starts_with(prefix) {
			return error('Unexpected Windows archive entry: ${path}')
		}
		relative := path[prefix.len..]
		if zip.is_dir()! {
			if relative !in ['', 'res/', 'licenses/'] {
				return error('Unexpected Windows archive directory: ${path}')
			}
			zip.close_entry()
			continue
		}
		if relative !in paths || relative in seen {
			return error('Unexpected or duplicate Windows archive file: ${path}')
		}
		if zip.size() == 0 {
			return error('Packaged file is empty: ${relative}')
		}
		// Decompress to one owned location to validate the payload without
		// treating any name from the archive as an output path.
		zip.extract_entry(scratch)!
		if os.file_size(scratch) != zip.size() {
			return error('Invalid Windows archive file size: ${path}')
		}
		if relative == build_record {
			verify_build_record(os.read_file(scratch)!)!
		}
		os.rm(scratch)!
		seen[relative] = true
		zip.close_entry()
	}
	for relative in paths {
		if relative !in seen {
			return error('Windows package is missing: ${relative}')
		}
	}
}

pub fn verify(project string, archive string) ! {
	packagezip.verify_checksum(archive)!
	stage := os.join_path(os.temp_dir(), 'vkvideo-verify-' + rand.uuid_v4())
	os.mkdir(stage, mode: 0o700)!
	defer { os.rmdir_all(stage) or {} }
	verify_contents(expected_files(licenses(project)!), archive, os.join_path(stage, 'entry'))!
	println('Verified Windows package: ${archive}')
}
