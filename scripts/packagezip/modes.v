// Preserve Unix permissions across szip implementations using ZIP central-directory metadata.
module packagezip

import encoding.binary
import os

const end_magic = u32(0x06054b50)
const zip64_end_magic = u32(0x06064b50)
const zip64_locator_magic = u32(0x07064b50)
const entry_magic = u32(0x02014b50)
const end_length = 22
const zip64_locator_length = 20
const zip64_record_length = 56
const max_comment_length = 65535
const entry_length = 46
const creator_system = 5
const external_attributes = 38
const unix_system = u8(3)
const macos_system = u8(19)
const directory_flag = u32(0x10)
const unix_directory = u32(0o40000)
const unix_regular_file = u32(0o100000)
const permission_bits = u32(0o777)

struct CentralDirectory {
	offset u64
mut:
	bytes []u8
}

fn read_central_directory(file os.File, size u64) !CentralDirectory {
	tail_bound := u64(end_length + max_comment_length)
	tail_offset := if size > tail_bound { size - tail_bound } else { u64(0) }
	tail := file.read_bytes_at(int(size - tail_offset), tail_offset)
	for end := tail.len - end_length; end >= 0; end-- {
		// Validate the comment length before accepting a signature found in the tail.
		if binary.little_endian_u32_at(tail, end) != end_magic
			|| int(binary.little_endian_u16_at(tail, end + 20)) != tail.len - end - end_length {
			continue
		}
		end_offset := tail_offset + u64(end)
		mut length := u64(binary.little_endian_u32_at(tail, end + 12))
		mut start := u64(binary.little_endian_u32_at(tail, end + 16))
		if length == u32(-1) || start == u32(-1) {
			length, start = zip64_directory_location(file, end_offset)!
		}
		if start > end_offset || length > end_offset - start || length > u64(max_int) {
			return error('Invalid ZIP central directory bounds')
		}
		bytes := file.read_bytes_at(int(length), start)
		if u64(bytes.len) != length {
			return error('Incomplete ZIP central directory')
		}
		return CentralDirectory{ offset: start, bytes: bytes }
	}
	return error('Missing ZIP end-of-central-directory record')
}

fn zip64_directory_location(file os.File, end_offset u64) !(u64, u64) {
	if end_offset < zip64_locator_length {
		return error('Missing ZIP64 central directory locator')
	}
	locator := file.read_bytes_at(zip64_locator_length, end_offset - zip64_locator_length)
	if locator.len != zip64_locator_length || binary.little_endian_u32(locator) != zip64_locator_magic {
		return error('Invalid ZIP64 central directory locator')
	}
	record_offset := binary.little_endian_u64_at(locator, 8)
	if record_offset > end_offset - zip64_locator_length
		|| end_offset - zip64_locator_length - record_offset < zip64_record_length {
		return error('Invalid ZIP64 central directory record location')
	}
	record := file.read_bytes_at(zip64_record_length, record_offset)
	if record.len != zip64_record_length || binary.little_endian_u32(record) != zip64_end_magic {
		return error('Missing ZIP64 central directory record')
	}
	return binary.little_endian_u64_at(record, 40), binary.little_endian_u64_at(record, 48)
}

struct CentralEntry {
	name   string
	offset int
}

fn central_entries(bytes []u8) ![]CentralEntry {
	mut entries := []CentralEntry{}
	for offset := 0; offset < bytes.len; {
		if bytes.len - offset < entry_length || binary.little_endian_u32_at(bytes, offset) != entry_magic {
			return error('Invalid ZIP central directory entry')
		}
		name_length := int(binary.little_endian_u16_at(bytes, offset + 28))
		extra_length := int(binary.little_endian_u16_at(bytes, offset + 30))
		comment_length := int(binary.little_endian_u16_at(bytes, offset + 32))
		name_start := offset + entry_length
		variable_length := name_length + extra_length + comment_length
		if variable_length > bytes.len - name_start {
			return error('Incomplete ZIP central directory entry')
		}
		entries << CentralEntry{bytes[name_start..name_start + name_length].bytestr(), offset}
		offset = name_start + variable_length
	}
	return entries
}

fn write_modes(archive string, modes map[string]u32) ! {
	mut file := os.open_file(archive, 'r+b')!
	defer { file.close() }
	mut directory := read_central_directory(file, os.file_size(archive))!
	entries := central_entries(directory.bytes)!
	if entries.len != modes.len {
		return error('ZIP central directory does not match the packaged paths')
	}
	for entry in entries {
		mode := modes[entry.name] or { return error('Unexpected ZIP entry: ${entry.name}') }
		directory.bytes[entry.offset + creator_system] = unix_system
		mut attr := (mode | unix_regular_file) << 16
		if entry.name.ends_with('/') {
			attr = ((mode | unix_directory) << 16) | directory_flag
		}
		binary.little_endian_put_u32_at(mut directory.bytes, attr, entry.offset + external_attributes)
	}
	file.seek(i64(directory.offset), .start)!
	if file.write(directory.bytes)! != directory.bytes.len {
		return error('Could not write ZIP permissions')
	}
}

fn read_modes(archive string) !map[string]u32 {
	mut file := os.open(archive)!
	defer { file.close() }
	directory := read_central_directory(file, os.file_size(archive))!
	mut modes := map[string]u32{}
	for entry in central_entries(directory.bytes)! {
		if directory.bytes[entry.offset + creator_system] in [unix_system, macos_system] {
			attr := binary.little_endian_u32_at(directory.bytes, entry.offset + external_attributes)
			modes[entry.name] = (attr >> 16) & permission_bits
		}
	}
	return modes
}
