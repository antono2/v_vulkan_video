module video_decode_app

fn test_mock_timeline_fixed_rate() {
	mut timeline := PlaybackTimeline{}
	assert timeline.decode_is_due(0)
	timeline.frame_decoded(40_000_000)
	assert !timeline.decode_is_due(39_999_999)
	assert timeline.decode_is_due(1)
	timeline.frame_decoded(40_000_000)
	assert !timeline.decode_is_due(0)
}

fn test_mock_timeline_variable_frame_durations() {
	mut timeline := PlaybackTimeline{}
	assert timeline.decode_is_due(0)
	timeline.frame_decoded(20_000_000)
	assert timeline.decode_is_due(25_000_000)
	assert timeline.elapsed_ns == 5_000_000
	timeline.frame_decoded(50_000_000)
	assert !timeline.decode_is_due(44_999_999)
	assert timeline.decode_is_due(1)
}

fn test_mock_timeline_caps_stall_backlog_and_ignores_negative_delta() {
	mut timeline := PlaybackTimeline{}
	assert timeline.decode_is_due(0)
	timeline.frame_decoded(10_000_000)
	assert timeline.decode_is_due(2_000_000_000)
	assert timeline.elapsed_ns == max_playback_backlog_ns
	timeline.frame_decoded(10_000_000)
	assert timeline.decode_is_due(-1)
	assert timeline.elapsed_ns == 490_000_000
}

fn test_mock_frame_progression_and_loop_reset() {
	assert advance_decoded_frame(0, 3, true) == FrameAdvance{next_frame: 1}
	assert advance_decoded_frame(1, 3, true) == FrameAdvance{next_frame: 2}
	assert advance_decoded_frame(2, 3, true) == FrameAdvance{
		decoder_reset: true
	}
}

fn test_mock_non_looping_sequence_stops_on_last_frame() {
	assert advance_decoded_frame(2, 3, false) == FrameAdvance{
		next_frame: 2
		stopped: true
	}
	assert advance_decoded_frame(0, 0, true).stopped
}

fn test_mock_timeline_reset_makes_first_frame_immediately_due() {
	mut timeline := PlaybackTimeline{}
	assert timeline.decode_is_due(0)
	timeline.frame_decoded(1_000_000_000)
	assert !timeline.decode_is_due(1)
	timeline.reset()
	assert timeline.decode_is_due(0)
}
