// Rehearse packaging and archive validation with owned synthetic inputs.
module windowspackage

import os
import packagezip
import rand

fn fixture_file(path string, text string) ! {
	os.mkdir_all(os.dir(path))!
	os.write_file(path, text)!
}

fn fixture(root string) !Inputs {
	project := os.join_path(root, 'project')
	modules_dir := os.join_path(root, 'modules')
	executable := os.join_path(root, 'player.exe')
	imgui := os.join_path(root, 'imgui.dll')
	glfw := os.join_path(root, 'glfw.dll')
	for relative in ['LICENSE', 'res/README.md', media, 'packaging/windows/README.txt',
		'packaging/windows/run.bat'] {
		fixture_file(os.join_path(project, relative), relative)!
	}
	fixture_file(os.join_path(project, 'SOURCE_REVISION'), 'fixture revision\n')!
	fixture_file(os.join_path(project, 'packaging', 'licenses.manifest'),
		'imgui LICENSE imgui.txt\n')!
	fixture_file(os.join_path(modules_dir, 'antono2', 'imgui', 'LICENSE'), 'fixture license\n')!
	for path in [executable, imgui, glfw] {
		fixture_file(path, os.file_name(path))!
	}
	return Inputs{project, modules_dir, 'stable', executable, imgui, glfw, 'fixture SDK'}
}

fn expect_invalid(project string, archive string, diagnostic string) ! {
	verify(project, archive) or {
		assert err.msg().contains(diagnostic), err.msg()
		return
	}
	return error('Expected invalid package: ${archive}')
}

fn write_sum(archive string) ! {
	os.write_file(archive + '.sha256', '${packagezip.file_hash(archive)!}  ${os.file_name(archive)}\n')!
}

fn test_package_preserves_archive_contents_on_a_rebuild() {
	root := os.join_path(os.temp_dir(), 'vkvideo package é-' + rand.uuid_v4())
	os.mkdir(root)!
	defer { os.rmdir_all(root) or {} }
	input := fixture(root)!
	output := os.join_path(root, 'custom output')
	stale := os.join_path(output, 'stale local file')
	fixture_file(stale, 'keep this local file')!
	package(input, output)!
	archive := output + '.zip'
	verify(input.project, archive)!
	assert os.read_file(stale)! == 'keep this local file'
	assert os.read_file(os.join_path(output, build_record))!.contains('Source revision: fixture revision')
	assert os.read_file(os.join_path(output, build_record))!.contains('Compiler mode: stable')
	assert os.read_file(os.join_path(output, 'licenses', 'imgui.txt'))! == 'fixture license\n'

	fixture_file(input.executable, 'replacement player')!
	package(input, output)!
	verify(input.project, archive)!
	assert os.read_file(os.join_path(output, 'v_vulkan_video.exe'))! == 'replacement player'

	previous := packagezip.file_hash(archive)!
	os.rm(input.glfw)!
	if _ := package(input, output) {
		assert false, 'A package with a missing GLFW library was accepted'
	}
	assert packagezip.file_hash(archive)! == previous
	verify(input.project, archive)!
	os.write_file(archive + '.sha256', 'invalid\n')!
	expect_invalid(input.project, archive, 'checksum mismatch')!
}

fn test_verifier_rejects_missing_extra_and_empty_entries() {
	root := os.join_path(os.temp_dir(), 'vkvideo verify-' + rand.uuid_v4())
	os.mkdir(root)!
	defer { os.rmdir_all(root) or {} }
	input := fixture(root)!
	entries := licenses(input.project)!
	paths := expected_files(entries)
	output := os.join_path(root, 'legacy')
	stage_files(input, output, entries)!
	// Accept archives produced by the former PowerShell build, which writes a
	// UTF-8 byte order mark and CRLF in BUILD-INFO.txt on some versions.
	info := os.join_path(output, build_record)
	records := os.read_file(info)!.replace('\n', '\r\n')
	os.write_file(info, '\xef\xbb\xbf' + records)!
	legacy := os.join_path(root, 'legacy.zip')
	packagezip.write_entries(legacy, name, output, paths)!
	write_sum(legacy)!
	verify(input.project, legacy)!

	missing := os.join_path(root, 'missing.zip')
	packagezip.write_entries(missing, name, output, paths.filter(it != 'glfw3.dll'))!
	write_sum(missing)!
	expect_invalid(input.project, missing, 'missing: glfw3.dll')!

	extra := os.join_path(root, 'extra.zip')
	fixture_file(os.join_path(output, 'unlisted.txt'), 'unlisted')!
	packagezip.write_entries(extra, name, output, [...paths, 'unlisted.txt'])!
	write_sum(extra)!
	expect_invalid(input.project, extra, 'Unexpected or duplicate Windows archive file')!

	empty := os.join_path(root, 'empty.zip')
	os.write_file(os.join_path(output, 'glfw3.dll'), '')!
	packagezip.write_entries(empty, name, output, paths)!
	write_sum(empty)!
	expect_invalid(input.project, empty, 'Packaged file is empty: glfw3.dll')!

	os.write_file(os.join_path(output, 'glfw3.dll'), 'fixture DLL')!
	os.write_file(info, records.replace('Compiler mode: stable', 'Compiler mode: '))!
	missing_record := os.join_path(root, 'missing-record.zip')
	packagezip.write_entries(missing_record, name, output, paths)!
	write_sum(missing_record)!
	expect_invalid(input.project, missing_record, 'Missing Windows build record: Compiler mode')!
}
