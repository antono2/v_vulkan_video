module packagezip

import compress.szip
import os
import rand

fn test_package_round_trip_preserves_paths_and_executable_mode() {
	stage := os.join_path(os.temp_dir(), 'package-zip-test-' + rand.uuid_v4())
	os.mkdir(stage, mode: 0o700) or { panic(err) }
	defer { os.rmdir_all(stage) or { panic(err) } }
	input := os.join_path(stage, 'input')
	output := os.join_path(stage, 'output')
	os.mkdir_all(os.join_path(input, 'empty directory')) or { panic(err) }
	os.mkdir_all(os.join_path(input, 'lib')) or { panic(err) }
	os.mkdir(output) or { panic(err) }
	executable := os.join_path(input, 'player')
	os.write_file(executable, 'executable content') or { panic(err) }
	os.chmod(executable, 0o755) or { panic(err) }
	os.write_file(os.join_path(input, 'lib', 'data with spaces'), '') or { panic(err) }
	archive := os.join_path(stage, 'test archive.zip')
	write_tree(archive, 'bundle', input) or { panic(err) }
	digest := file_hash(archive) or { panic(err) }
	os.write_file(archive + '.sha256', '${digest}  test archive.zip\n') or { panic(err) }
	verify_checksum(archive) or { panic(err) }
	extract(archive, 'bundle', output) or { panic(err) }
	player := os.join_path(output, 'bundle', 'player')
	assert os.read_file(player) or { panic(err) } == 'executable content'
	$if !windows {
		assert os.is_executable(player)
		external := os.join_path(stage, 'external')
		os.mkdir(external) or { panic(err) }
		assert szip.extract_zip_to_dir(archive, external) or { panic(err) }
		assert os.is_file(os.join_path(external, 'bundle', 'lib', 'data with spaces'))
	}
	assert os.is_dir(os.join_path(output, 'bundle', 'empty directory'))
	assert os.is_file(os.join_path(output, 'bundle', 'lib', 'data with spaces'))
	os.write_file(archive + '.sha256', 'bad\n') or { panic(err) }
	verify_checksum(archive) or {
		assert err.msg().contains('checksum mismatch')
		return
	}
	assert false, 'Incorrect checksum was accepted'
}

fn test_extract_rejects_traversal_before_writing_entry() {
	stage := os.join_path(os.temp_dir(), 'package-zip-test-' + rand.uuid_v4())
	os.mkdir(stage, mode: 0o700) or { panic(err) }
	defer { os.rmdir_all(stage) or { panic(err) } }
	archive := os.join_path(stage, 'bad.zip')
	mut zip := szip.open(archive, .default_level, .write) or { panic(err) }
	zip.open_entry('bundle/../unexpected-file') or { panic(err) }
	zip.write_entry('unexpected'.bytes()) or { panic(err) }
	zip.close_entry()
	zip.close()
	extract(archive, 'bundle', stage) or {
		assert err.msg().contains('Unexpected or duplicate package entry')
		assert !os.exists(os.join_path(stage, 'unexpected-file'))
		return
	}
	assert false, 'A traversing path was accepted'
}
