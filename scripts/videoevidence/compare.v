// Compare decoded NV12 planes with a display-order software reference.
module videoevidence

import os
import strconv
import time
import x.json2

const bytes_per_nv12_sample = 255
const reported_mismatch_limit = 5
const poll_interval = 5 * time.millisecond

struct Stream {
	width  int
	height int
}

struct Streams {
	streams []Stream
}

struct Dump {
	index int
	path  string
}

pub struct Comparison {
pub:
	frame_count int
	width       int
	height      int
	mismatches  int
	max_delta   int
	details     []string
}

pub fn (result Comparison) report() string {
	summary := 'Compared ${result.frame_count} frames at ${result.width}x${result.height}; mismatched=${result.mismatches}, maximum byte difference=${result.max_delta}'
	return if result.details.len > 0 { result.details.join('\n') + '\n' + summary } else { summary }
}

pub fn ffmpeg_args(reference string) []string {
	// Readback contains coded pixels before the MP4 display transform.
	return ['-hide_banner', '-loglevel', 'error', '-noautorotate', '-i', reference, '-fps_mode',
		'passthrough', '-pix_fmt', 'nv12', '-f', 'rawvideo', 'pipe:1']
}

fn dimensions(reference string) !Stream {
	result := probe(['ffprobe', '-v', 'error', '-select_streams', 'v:0', '-show_entries',
		'stream=width,height', '-of', 'json', reference], 30 * time.second)
	if result.exit_code != 0 {
		return error('ffprobe failed: ${result.output.trim_space()}')
	}
	metadata := json2.decode[Streams](result.output)!
	if metadata.streams.len == 0 {
		return error('reference does not contain a video stream')
	}
	stream := metadata.streams[0]
	if stream.width <= 0 || stream.height <= 0 || stream.width % 2 != 0 || stream.height % 2 != 0 {
		return error('NV12 comparison requires positive, even dimensions')
	}
	return stream
}

fn list_frames(directory string) ![]Dump {
	message := 'dump directory must contain contiguous 0.nv12, 1.nv12, ... files'
	mut dumps := []Dump{}
	for name in os.ls(directory)! {
		if !name.ends_with('.nv12') {
			continue
		}
		stem := name.trim_string_right('.nv12')
		index := strconv.parse_uint(stem, 10, 31) or { return error(message) }
		dumps << Dump{int(index), os.join_path(directory, name)}
	}
	dumps.sort(a.index < b.index)
	if dumps.len == 0 {
		return error(message)
	}
	for position, frame in dumps {
		if position != frame.index {
			return error(message)
		}
	}
	return dumps
}

struct DecoderPipe {
	deadline time.Duration
	clock    time.StopWatch
mut:
	child   &os.Process
	partial []u8
	stderr  string
}

fn decoder(reference string, timeout time.Duration) !DecoderPipe {
	ffmpeg := os.find_abs_path_of_executable('ffmpeg') or { return error('ffmpeg was not found') }
	mut process := os.new_process(ffmpeg)
	process.set_args(ffmpeg_args(reference))
	process.set_redirect_stdio()
	process.run()
	if process.status != .running {
		process.close()
		return error('could not start FFmpeg: ${process.err}')
	}
	return DecoderPipe{
		deadline: timeout
		clock:    time.new_stopwatch()
		child:    process
	}
}

fn (mut decoder DecoderPipe) close() {
	if decoder.child.is_alive() {
		decoder.child.signal_kill()
	}
	decoder.child.wait()
	decoder.child.close()
}

fn (mut decoder DecoderPipe) read(size int) ![]u8 {
	for decoder.partial.len < size {
		alive := decoder.child.is_alive()
		chunk := decoder.child.stdout_read()
		diagnostic := decoder.child.stderr_read()
		if diagnostic != '' {
			// Keep FFmpeg errors bounded for a malformed or lengthy reference.
			decoder.stderr = (decoder.stderr + diagnostic).limit(16 * 1024)
		}
		if chunk != '' {
			decoder.partial << chunk.bytes()
		} else if !alive {
			break
		} else {
			time.sleep(poll_interval)
		}
		if decoder.deadline > 0 && decoder.clock.elapsed() >= decoder.deadline {
			return error('FFmpeg comparison exceeded ${decoder.deadline}')
		}
	}
	length := if decoder.partial.len > size { size } else { decoder.partial.len }
	pixels := decoder.partial[..length].clone()
	decoder.partial.delete_many(0, length)
	return pixels
}

fn byte_difference(gpu []u8, reference []u8) int {
	mut largest := 0
	for index, value in gpu {
		delta := int(value) - int(reference[index])
		magnitude := if delta < 0 { -delta } else { delta }
		if magnitude > largest {
			largest = magnitude
		}
	}
	return largest
}

// compare streams one decoded frame at a time and checks for a complete loop.
pub fn compare(reference string, dump_dir string, tolerance int, timeout time.Duration) !Comparison {
	if tolerance < 0 || tolerance > bytes_per_nv12_sample {
		return error('tolerance must be between 0 and ${bytes_per_nv12_sample}')
	}
	stream := dimensions(reference)!
	// NV12 has one full-resolution Y plane and a half-sized interleaved UV plane.
	luma_size := i64(stream.width) * stream.height
	frame_size := luma_size + luma_size / 2
	if frame_size > max_int {
		return error('frame is too large for this NV12 comparison')
	}
	dumps := list_frames(dump_dir)!
	mut decode := decoder(reference, timeout)!
	defer { decode.close() }
	mut mismatches := 0
	mut largest := 0
	mut details := []string{}
	for frame in dumps {
		size := os.file_size(frame.path)
		if size != u64(frame_size) {
			return error('Frame ${frame.index}: expected ${frame_size} bytes, got GPU=${size}')
		}
		gpu := os.read_bytes(frame.path)!
		pixels := decode.read(int(frame_size))!
		if gpu.len != frame_size || pixels.len != frame_size {
			return error('Frame ${frame.index}: expected ${frame_size} bytes, got GPU=${gpu.len} FFmpeg=${pixels.len}\n${decode.stderr.trim_space()}'.trim_space())
		}
		delta := byte_difference(gpu, pixels)
		if delta > largest {
			largest = delta
		}
		if delta > tolerance {
			mismatches++
			if mismatches <= reported_mismatch_limit {
				details << 'Frame ${frame.index}: maximum byte difference ${delta}'
			}
		}
	}
	if decode.read(1)!.len != 0 {
		return error('FFmpeg produced more frames than the GPU capture')
	}
	decode.child.wait()
	if decode.child.code != 0 {
		return error('FFmpeg could not decode the reference input\n${decode.stderr.trim_space()}'.trim_space())
	}
	return Comparison{dumps.len, stream.width, stream.height, mismatches, largest, details}
}
