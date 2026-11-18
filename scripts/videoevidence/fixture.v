// Check coded-pixel comparison using the tracked five-frame H.264 clip.
module videoevidence

import os
import rand
import x.json2

const fixture_width = 160
const fixture_height = 96
const fixture_frames = 5

struct DisplaySideData {
	rotation int
}

struct DisplayStream {
	side_data_list []DisplaySideData
}

struct DisplayProbe {
	streams []DisplayStream
}

pub fn test_comparison(reference string) ! {
	area := os.join_path(os.temp_dir(), 'vkvideo-nv12-${rand.ulid()}')
	os.mkdir(area)!
	defer { os.rmdir_all(area) or {} }
	mut decode_command := ['ffmpeg']
	decode_command << ffmpeg_args(reference)
	decoded := os.exec(decode_command)
	if decoded.exit_code != 0 {
		return error(decoded.output)
	}
	// Each four luma samples share one U,V pair in NV12.
	frame_size := fixture_width * fixture_height * 3 / 2
	assert decoded.output.len == fixture_frames * frame_size
	for index in 0 .. fixture_frames {
		start := index * frame_size
		frame := decoded.output[start..start + frame_size]
		os.write_file(os.join_path(area, '${index}.nv12'), frame)!
	}
	result := compare(reference, area, 0, 0)!
	assert result.frame_count == fixture_frames && result.mismatches == 0 && result.max_delta == 0

	rotated := os.join_path(area, 'rotated.mp4')
	remux := os.exec(['ffmpeg', '-v', 'error', '-display_rotation', '90', '-i', reference, '-c:v',
		'copy', rotated])
	if remux.exit_code != 0 {
		return error(remux.output)
	}
	metadata := os.exec(['ffprobe', '-v', 'error', '-select_streams', 'v:0', '-show_entries',
		'stream_side_data=rotation', '-of', 'json', rotated])
	if metadata.exit_code != 0 {
		return error(metadata.output)
	}
	display := json2.decode[DisplayProbe](metadata.output)!
	assert display.streams.len == 1
	assert display.streams[0].side_data_list.any(it.rotation in [-90, 90])
	rotated_result := compare(rotated, area, 0, 0)!
	assert rotated_result.frame_count == fixture_frames && rotated_result.mismatches == 0
	assert rotated_result.max_delta == 0

	first := os.join_path(area, '0.nv12')
	mut pixels := os.read_bytes(first)!
	original := int(pixels[0])
	pixels[0] ^= bytes_per_nv12_sample
	mut delta := int(pixels[0]) - original
	if delta < 0 {
		delta = -delta
	}
	os.write_file_array(first, pixels)!
	changed := compare(reference, area, 0, 0)!
	assert changed.mismatches == 1 && changed.max_delta == delta
	tolerated := compare(reference, area, delta, 0)!
	assert tolerated.mismatches == 0 && tolerated.max_delta == delta

	last := os.join_path(area, '${fixture_frames - 1}.nv12')
	os.rm(last)!
	mut caught_extra := false
	compare(reference, area, 0, 0) or {
		caught_extra = err.msg().contains('more frames than the GPU capture')
		Comparison{}
	}
	assert caught_extra
	println('NV12 fixtures passed at ${fixture_width}x${fixture_height} with ${fixture_frames} frames')
}
