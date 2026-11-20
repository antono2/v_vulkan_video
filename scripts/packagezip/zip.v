// Write and verify package ZIPs without command-line archive tools.
module packagezip

import compress.szip
import crypto.sha256
import os

const hash_block_size = 64 * 1024

pub fn file_hash(path string) !string {
	mut file := os.open(path)!
	defer { file.close() }
	mut hash := sha256.new()
	mut block := []u8{len: hash_block_size}
	for {
		size := file.read(mut block) or {
			if err is os.Eof {
				break
			}
			return err
		}
		if size == 0 {
			break
		}
		hash.write(block[..size])!
	}
	return hash.sum([]u8{}).hex()
}

pub fn verify_checksum(archive string) ! {
	if !os.is_file(archive) {
		return error('Package does not exist: ${archive}')
	}
	sum := archive + '.sha256'
	if !os.is_file(sum) {
		return error('Package checksum is missing: ${sum}')
	}
	fields := os.read_file(sum)!.all_before('\n').fields()
	if fields.len == 0 || fields[0].to_lower() != file_hash(archive)! {
		return error('Package checksum mismatch: ${archive}')
	}
}

fn collect(directory string, relative string, mut paths []string) ! {
	mut names := os.ls(os.join_path(directory, relative))!
	names.sort()
	for name in names {
		path := relative + name
		source := os.join_path(directory, path)
		if os.is_link(source) {
			return error('Package input contains a symbolic link: ${source}')
		}
		if os.is_dir(source) {
			paths << path + '/'
			collect(directory, path + '/', mut paths)!
		} else if os.is_file(source) {
			paths << path
		} else {
			return error('Package input is not a regular file: ${source}')
		}
	}
}

pub fn write_tree(archive string, root string, directory string) ! {
	mut paths := ['']
	collect(directory, '', mut paths)!
	write_entries(archive, root, directory, paths)!
	$if !windows {
		mut modes := map[string]u32{}
		for path in paths {
			modes[root + '/' + path] = os.stat(os.join_path(directory, path))!.mode & permission_bits
		}
		write_modes(archive, modes)!
	}
}

pub fn write_entries(archive string, root string, directory string, paths []string) ! {
	mut zip := szip.open(archive, .default_level, .write)!
	defer { zip.close() }
	for path in paths {
		zip.open_entry(root + '/' + path)!
		if path != '' && !path.ends_with('/') {
			zip.create_entry(os.join_path(directory, path))!
		}
		zip.close_entry()
	}
}

fn safe_entry(path string) bool {
	return !path.contains_any('\\:') && path.split('/').all(it !in ['', '.', '..'])
}

// Extract a package into an existing private scratch directory. Each entry
// must remain within the package's named top-level directory.
pub fn extract(archive string, root string, destination string) ! {
	modes := read_modes(archive)!
	mut zip := szip.open(archive, .no_compression, .read_only)!
	defer { zip.close() }
	mut seen := map[string]bool{}
	for index in 0 .. zip.total()! {
		zip.open_entry_by_index(index)!
		name := zip.name()
		is_dir := zip.is_dir()!
		path := if is_dir { name.trim_string_right('/') } else { name }
		if !safe_entry(path) || (path != root && !path.starts_with(root + '/')) || path in seen
			|| (path == root && !is_dir) {
			return error('Unexpected or duplicate package entry: ${name}')
		}
		seen[path] = true
		target := os.join_path(destination, path)
		if is_dir {
			os.mkdir_all(target)!
		} else {
			os.mkdir_all(os.dir(target))!
			zip.extract_entry(target)!
			$if !windows {
				if mode := modes[name] {
					os.chmod(target, int(mode))!
				}
			}
			if os.file_size(target) != zip.size() {
				return error('Invalid package entry size: ${name}')
			}
		}
		zip.close_entry()
	}
}
