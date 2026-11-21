// Read the installed SDK and copy the process environment through the Win32 wide-character APIs.
module windowssetup

#flag -ladvapi32
#include <windows.h>

fn C.RegOpenKeyExW(voidptr, &u16, u32, u32, &voidptr) i32
fn C.RegQueryValueExW(voidptr, &u16, voidptr, &u32, voidptr, &u32) i32
fn C.RegCloseKey(voidptr) i32

fn registry_sdk(hive voidptr, key string) string {
	key_wide := key.to_wide()
	name_wide := sdk_variable.to_wide()
	defer {
		unsafe { free(key_wide) }
		unsafe { free(name_wide) }
	}
	mut handle := voidptr(0)
	if C.RegOpenKeyExW(hive, key_wide, 0, C.KEY_QUERY_VALUE, &handle) != 0 {
		return ''
	}
	defer { C.RegCloseKey(handle) }
	mut size := u32(0)
	mut kind := u32(0)
	if C.RegQueryValueExW(handle, name_wide, unsafe { nil }, &kind, unsafe { nil }, &size) != 0
		|| kind !in [u32(C.REG_SZ), u32(C.REG_EXPAND_SZ)]
		|| size < u32(utf16_code_unit_bytes) || size % u32(utf16_code_unit_bytes) != 0 {
		return ''
	}
	// Leave a terminator even if the registry entry omitted one.
	mut buffer := []u16{len: int(size) / utf16_code_unit_bytes + 1}
	if C.RegQueryValueExW(handle, name_wide, unsafe { nil }, &kind, buffer.data, &size) != 0 {
		return ''
	}
	if kind == u32(C.REG_EXPAND_SZ) {
		length := C.ExpandEnvironmentStringsW(buffer.data, unsafe { nil }, 0)
		if length == 0 {
			return ''
		}
		mut expanded := []u16{len: int(length)}
		if C.ExpandEnvironmentStringsW(buffer.data, expanded.data, length) != length {
			return ''
		}
		return unsafe { string_from_wide(expanded.data) }
	}
	return unsafe { string_from_wide(buffer.data) }
}

fn installed_vulkan_sdk() string {
	user := registry_sdk(voidptr(C.HKEY_CURRENT_USER), 'Environment')
	if user != '' {
		return user
	}
	return registry_sdk(voidptr(C.HKEY_LOCAL_MACHINE), r'SYSTEM\CurrentControlSet\Control\Session Manager\Environment')
}

fn C.GetEnvironmentStringsW() &u16
fn C.FreeEnvironmentStringsW(&u16) i32

fn windows_environment() map[string]string {
	block := C.GetEnvironmentStringsW()
	mut values := map[string]string{}
	if isnil(block) {
		return values
	}
	defer { C.FreeEnvironmentStringsW(block) }
	mut cursor := unsafe { &u16(block) }
	unsafe {
		for *cursor != 0 {
			mut length := 0
			for cursor[length] != 0 {
				length++
			}
			entry := string_from_wide2(cursor, length)
			cursor += length + 1
			name, value := entry.split_once('=') or { continue }
			if name != '' {
				values[name] = value
			}
		}
	}
	return values
}
