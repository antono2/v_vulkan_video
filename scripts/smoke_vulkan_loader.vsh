// Exercise help and Vulkan device discovery with the Lavapipe software driver.
import os
import time
import scripts.videoevidence

const command_timeout = 20 * time.second
const icd_directory = '/usr/share/vulkan/icd.d'
const demo_media = 'res/20240917_095400.mp4'

fn checked_output(arguments []string) !string {
	result := videoevidence.probe(arguments, command_timeout)
	println(result.output)
	if result.exit_code != 0 {
		return error('${arguments[0]} exited with status ${result.exit_code}')
	}
	return result.output
}

fn run(args []string) ! {
	if args.len != 1 {
		return error('usage: v run scripts/smoke_vulkan_loader.vsh PLAYER')
	}
	mut manifests :=
		os.ls(icd_directory)!.filter(it.starts_with('lvp_icd') && it.ends_with('.json'))
	manifests.sort()
	if manifests.len == 0 {
		return error('Lavapipe ICD is missing')
	}
	manifest := os.join_path(icd_directory, manifests[0])
	os.setenv('VK_DRIVER_FILES', manifest, true)
	os.setenv('VK_ICD_FILENAMES', manifest, true)
	player := os.abs_path(args[0])
	checked_output([player, '--help'])!
	video := os.join_path(os.dir(@DIR), demo_media)
	devices := checked_output(['xvfb-run', '-a', player, '--list-gpus', video])!
	if !devices.contains('Vulkan devices for H.264')
		|| !['llvmpipe', 'lavapipe'].any(devices.to_lower_ascii().contains(it)) {
		return error('The Vulkan loader did not report a Lavapipe device')
	}
}

run(os.args[1..]) or {
	eprintln(err)
	exit(1)
}
