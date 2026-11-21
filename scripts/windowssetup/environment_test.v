module windowssetup

fn utf16le(text string) string {
	mut bytes := []u8{}
	for character in text.runes() {
		value := u16(character)
		bytes << u8(value)
		bytes << u8(value >> 8)
	}
	return bytes.bytestr()
}

fn test_parse_visual_studio_environment_preserves_unicode_and_equals() ! {
	raw := utf16le('${rune(utf16_byte_order_mark)}=C:=C:\\fixture\r\n' +
		'${architecture_variable}=${target_architecture}\r\n' +
		'Path=C:\\Outils café\\bin;C:\\SDK\\Bin\r\n' +
		'INCLUDE=C:\\Build=Tools\\include\r\n' +
		'${vs_command_variable}=C:\\VsDevCmd.bat\r\n')
	values := parse_vs_environment(raw)!
	assert values['Path'] == 'C:\\Outils café\\bin;C:\\SDK\\Bin'
	assert values['INCLUDE'] == 'C:\\Build=Tools\\include'
	assert values.len == 3
}

fn test_parse_visual_studio_environment_accepts_decoded_windows_stdout() ! {
	path := r'C:\Outils café\bin'
	text := '${architecture_variable}=${target_architecture}\r\nPath=${path}\r\n'
	assert parse_vs_environment(text)!['Path'] == path
}

fn test_parse_visual_studio_environment_refuses_wrong_architecture_and_truncation() {
	for raw, message in {
		utf16le('${architecture_variable}=x86\r\n'):                         'did not activate the x64 build tools'
		utf16le('${architecture_variable}=${target_architecture}') + '\x00': 'incomplete UTF-16'
	} {
		parse_vs_environment(raw) or {
			assert err.msg().contains(message)
			continue
		}
		assert false, 'Expected to reject ${message}'
	}
}
