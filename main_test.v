module main

fn test_parse_cli_defaults() {
	options := parse_cli([]) or { panic(err) }
	assert options.video_path == ''
	assert options.gpu_index == -1
	assert !options.list_gpus
}

fn test_parse_cli_gpu_and_list() {
	options := parse_cli(['--list-gpus', '--gpu', '2', 'movie.mp4']) or { panic(err) }
	assert options.list_gpus
	assert options.gpu_index == 2
	assert options.video_path.ends_with('movie.mp4')
}

fn test_parse_cli_rejects_invalid_gpu() {
	if _ := parse_cli(['--gpu', 'abc']) {
		assert false, 'invalid GPU index was accepted'
	}
	if _ := parse_cli(['--gpu', '-1']) {
		assert false, 'negative GPU index was accepted'
	}
}

fn test_parse_cli_rejects_unknown_options_and_multiple_files() {
	if _ := parse_cli(['--unknown']) {
		assert false, 'unknown option was accepted'
	}
	if _ := parse_cli(['one.mp4', 'two.mp4']) {
		assert false, 'multiple input files were accepted'
	}
}
