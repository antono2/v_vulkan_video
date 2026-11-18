// Compare a first-loop NV12 capture with FFmpeg using coded video dimensions.
import flag
import os
import strconv
import scripts.videoevidence

fn run(args []string) !int {
	mut parser := flag.new_flag_parser(args)
	parser.application('compare_nv12')
	parser.description('Compare display-order NV12 dumps with FFmpeg.')
	parser.arguments_description('<reference> <dump-dir>')
	tolerance_text := parser.string('tolerance', 0, '0', 'maximum allowed difference per byte')
	test := parser.bool('self-test', 0, false, 'verify rotation, tolerance, and frame counts')
	if parser.bool('help', `h`, false, 'show this help') {
		println(parser.usage())
		return 0
	}
	paths := parser.finalize()!
	if test && paths.len == 0 {
		project := os.dir(@DIR)
		videoevidence.test_comparison(os.join_path(project, 'res',
			'H264_parameter_id_7_160x96_1s.mp4'))!
		return 0
	}
	if paths.len != 2 {
		return error(parser.usage())
	}
	tolerance := strconv.parse_int(tolerance_text, 10, 32) or {
		return error('tolerance must be an integer between 0 and 255')
	}
	result := videoevidence.compare(paths[0], paths[1], int(tolerance), 0)!
	println(result.report())
	return if result.mismatches == 0 { 0 } else { 1 }
}

exit(run(os.args[1..]) or {
	eprintln(err)
	1
})
