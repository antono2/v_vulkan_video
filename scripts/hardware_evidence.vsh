// Record GPU capabilities and the result of an independent GPU readback comparison.
import crypto.sha256
import flag
import os
import rand
import time
import x.json2
import scripts.videoevidence

$if windows {
	#include <fcntl.h>
	#include <io.h>
	#include <sys/stat.h>
}

fn C._write(fd int, data voidptr, count u32) int
fn C._close(fd int) int

const hash_block_size = 1024 * 1024

struct Evidence {
	captured_at               string
	platform                  string
	player_sha256             string
	video_sha256              string
	reference_sha256          string
	device_enumeration_passed bool
	devices                   string
	driver                    string
	ffmpeg                    string
	status                    string
	comparison                string
	remaining_checks          []string
}

struct Options {
	player    string
	video     string
	reference string
	dump_dir  string
	output    string
}

type Probe = fn ([]string, time.Duration) os.Result

type Compare = fn (string, string, int, time.Duration) !videoevidence.Comparison

fn file_hash(path string) !string {
	mut file := os.open(path)!
	defer { file.close() }
	mut hash := sha256.new()
	mut block := []u8{len: hash_block_size}
	mut remaining := os.file_size(path)
	for remaining > 0 {
		size := file.read(mut block)!
		if size <= 0 || u64(size) > remaining {
			return error('input changed while hashing ${path}')
		}
		hash.write(block[..size])!
		remaining -= u64(size)
	}
	return hash.sum([]u8{}).hex()
}

fn resolve_file(path string) !string {
	if !os.is_file(path) {
		return error('missing input file ${path}')
	}
	return os.real_path(path)
}

fn write_new(path string, content string) ! {
	// Reserve the destination exclusively before writing the evidence.
	mut complete := false
	$if windows {
		// Older Windows CRTs reject the C11 fopen "x" flag.
		flags := C._O_WRONLY | C._O_CREAT | C._O_EXCL | C._O_BINARY
		fd := C._wopen(path.to_wide(), flags, int(C._S_IREAD | C._S_IWRITE))
		if fd < 0 {
			return error('could not create new evidence file ${path}')
		}
		written := C._write(fd, content.str, u32(content.len))
		status := C._close(fd)
		complete = written == content.len && status == 0
	} $else {
		file := os.vfopen(path, 'wbx')!
		written := C.fwrite(content.str, 1, usize(content.len), file)
		status := C.fclose(file)
		complete = written == usize(content.len) && status == 0
	}
	if !complete {
		os.rm(path) or {}
		return error('could not write evidence to ${path}')
	}
}

fn record(options Options, probe Probe, compare Compare) !Evidence {
	player := resolve_file(options.player)!
	video := resolve_file(options.video)!
	reference := if options.reference == '' { video } else { resolve_file(options.reference)! }
	has_capture := options.dump_dir != ''
	if has_capture && !os.is_dir(options.dump_dir) {
		return error('missing GPU capture directory ${options.dump_dir}')
	}
	devices := probe([player, '--list-gpus', video], 30 * time.second)
	sdk := os.getenv('VULKAN_SDK')
	vulkaninfo := if os.user_os() == 'windows' && sdk != '' {
		os.join_path(sdk, 'Bin', 'vulkaninfo.exe')
	} else {
		'vulkaninfo'
	}
	driver := probe([vulkaninfo, '--summary'], 30 * time.second)
	ffmpeg := probe(['ffmpeg', '-version'], 15 * time.second)
	mut comparison := 'No real GPU capture supplied. Decoding is unverified.'
	mut compared := false
	if has_capture {
		if result := compare(reference, os.real_path(options.dump_dir), 0, 300 * time.second) {
			comparison = result.report()
			compared = result.mismatches == 0
		} else {
			comparison = err.msg()
		}
	}
	passed := devices.exit_code == 0
	status := if !has_capture {
		'capabilities_only'
	} else if passed && compared {
		'decoded_pixels_match'
	} else {
		'comparison_failed'
	}
	kernel := os.uname()
	report := Evidence{
		captured_at:               time.utc().format_rfc3339()
		platform:                  '${kernel.sysname}-${kernel.release}-${kernel.machine}'
		player_sha256:             file_hash(player)!
		video_sha256:              file_hash(video)!
		reference_sha256:          file_hash(reference)!
		device_enumeration_passed: passed
		devices:                   devices.output
		driver:                    driver.output
		ffmpeg:                    ffmpeg.output.all_before('\n').trim_space()
		status:                    status
		comparison:                comparison
		remaining_checks:          ['rendered colors/orientation', 'resize and window close',
			'long-running looping', 'other GPU drivers', 'Windows OpenCL interoperability']
	}
	write_new(options.output, json2.encode(report, prettify: true) + '\n')!
	return report
}

fn fixture_probe(_ []string, _ time.Duration) os.Result {
	return os.Result{
		exit_code: 0
		output:    'fixture probe output'
	}
}

fn fixture_comparison(_ string, _ string, _ int, _ time.Duration) !videoevidence.Comparison {
	return error('GPU capture does not match reference')
}

fn self_test() ! {
	root := os.join_path(os.temp_dir(), 'vkvideo-evidence-${rand.ulid()}')
	os.mkdir(root)!
	defer { os.rmdir_all(root) or {} }
	player := os.join_path(root, 'player.exe')
	video := os.join_path(root, 'video.mp4')
	os.write_file(player, 'player fixture')!
	os.write_file(video, 'media fixture')!
	for has_capture in [false, true] {
		output := os.join_path(root, '${has_capture}.json')
		options := Options{
			player:   player
			video:    video
			dump_dir: if has_capture { root } else { '' }
			output:   output
		}
		record(options, fixture_probe, fixture_comparison)!
		saved := os.read_file(output)!
		report := json2.decode[Evidence](saved)!
		assert report.device_enumeration_passed
		if has_capture {
			assert report.status == 'comparison_failed'
			assert report.comparison.contains('does not match')
		} else {
			assert report.status == 'capabilities_only'
			assert report.comparison.contains('No real GPU capture')
		}
		write_new(output, 'replacement') or {}
		assert os.read_file(output)! == saved
	}
	assert os.read_file(player)! == 'player fixture'
	assert os.read_file(video)! == 'media fixture'
	println('Hardware evidence status and exclusive output checks passed')
}

fn run(args []string) !int {
	mut parser := flag.new_flag_parser(args)
	parser.application('hardware_evidence')
	parser.description('Record GPU enumeration, driver, and decoded pixel evidence.')
	player := parser.string('player', 0, '', 'path to the built video player')
	video := parser.string('video', 0, '', 'video used for GPU playback')
	reference := parser.string('reference', 0, '', 'original stream for software decode')
	dump_dir := parser.string('dump-dir', 0, '', 'existing GPU readback directory')
	output := parser.string('output', 0, '', 'path to a new JSON evidence file')
	test := parser.bool('self-test', 0, false, 'validate evidence status and output handling')
	if parser.bool('help', `h`, false, 'show this help') {
		println(parser.usage())
		return 0
	}
	if parser.finalize()!.len != 0 {
		return error(parser.usage())
	}
	if test {
		self_test()!
		return 0
	}
	if player == '' || video == '' || output == '' {
		return error(parser.usage())
	}
	report := record(Options{player, video, reference, dump_dir, output}, videoevidence.probe,
		videoevidence.compare)!
	println('${report.status}: ${output}')
	return if report.status == 'decoded_pixels_match' { 0 } else { 2 }
}

exit(run(os.args[1..]) or {
	eprintln(err)
	1
})
