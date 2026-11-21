// Report Windows build prerequisites and the driver's advertised video extensions.
import os
import probeio
import time
import windowssetup

const usage = 'Usage: v run scripts/check_windows.vsh [--build-only]'
const vulkaninfo_timeout = time.minute
const video_extensions = ['VK_KHR_video_queue', 'VK_KHR_video_decode_queue', 'VK_KHR_video_decode_h264']

fn check(args []string) ! {
	if args in [['--help'], ['-h']] {
		println(usage)
		return
	}
	if args.len != 0 && args != ['--build-only'] {
		return error(usage)
	}
	windowssetup.check_prerequisites()!
	if args.len == 0 {
		result := probeio.run_probe_with_options('vulkaninfo', [], vulkaninfo_timeout,
			environment: windowssetup.current_environment()
		)
		if !result.ok {
			return error('vulkaninfo did not complete. Check the LunarG SDK and graphics driver.\n${result.detail}')
		}
		mut missing := []string{}
		for extension in video_extensions {
			if result.detail.contains(extension) {
				println('[ok]      ${extension} advertised')
			} else {
				missing << extension
			}
		}
		if missing.len > 0 {
			return error('Vulkan video extensions are unavailable: ${missing.join(', ')}')
		}
	}
	println('Build prerequisites look usable. Use the player --list-gpus to check hardware decoding.')
}

check(os.args[1..]) or {
	eprintln(err)
	exit(1)
}
