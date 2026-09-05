module main

import examples.video_decode_app as vda
import os

struct CliOptions {
	mut:
	video_path string
	gpu_index  int = -1
	list_gpus bool
	show_help bool
}

fn parse_cli(args []string) !CliOptions {
	mut options := CliOptions{}
	mut i := 0
	for i < args.len {
		arg := args[i]
		match arg {
			'-h', '--help' { options.show_help = true }
			'--list-gpus' { options.list_gpus = true }
			'--gpu' {
				i++
				if i >= args.len {
					return error('--gpu requires a non-negative device index')
				}
				if args[i].int() < 0 || args[i] != args[i].int().str() {
					return error('invalid GPU index: ${args[i]}')
				}
				options.gpu_index = args[i].int()
			}
			else {
				if arg.starts_with('-') {
					return error('unknown option: ${arg}')
				}
				if options.video_path != '' {
					return error('only one video file may be specified')
				}
				options.video_path = os.real_path(arg)
			}
		}
		i++
	}
	return options
}

fn print_usage(program string) {
	println('Usage: ${program} [--list-gpus] [--gpu INDEX] [video.mp4]')
	println('If omitted, the bundled sample video is used.')
}

fn main() {
	options := parse_cli(os.args[1..]) or {
		eprintln('${err}')
		print_usage(os.file_name(os.args[0]))
		exit(2)
	}
	if options.show_help {
		print_usage(os.file_name(os.args[0]))
		return
	}
	if options.video_path != '' && !os.is_file(options.video_path) {
		eprintln('Video file does not exist: ${options.video_path}')
		exit(2)
	}

	mut app := vda.VideoDecodeApp{
		device_context: vda.DeviceContext{}
		video_path: options.video_path
		preferred_gpu_index: options.gpu_index
		list_gpus: options.list_gpus
	}
	app.device_context.swapchain.app = &app
	if !app.initialize() {
		if options.list_gpus {
			return
		}
		eprintln('Could not initialize the video player')
		exit(1)
	}
	app.run()
	app.shutdown()
}
