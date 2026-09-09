module video_decode_app

fn test_mock_timeline_fixed_rate() {
	mut timeline := PlaybackTimeline{}
	assert timeline.frame_is_due()
	timeline.present_frame(40_000_000)
	timeline.tick(39_999_999)
	assert !timeline.frame_is_due()
	timeline.tick(1)
	assert timeline.frame_is_due()
	timeline.present_frame(40_000_000)
	assert !timeline.frame_is_due()
}

fn test_mock_timeline_variable_frame_durations() {
	mut timeline := PlaybackTimeline{}
	timeline.present_frame(20_000_000)
	timeline.tick(25_000_000)
	assert timeline.frame_is_due()
	timeline.present_frame(50_000_000)
	assert timeline.elapsed_ns == 5_000_000
	timeline.tick(44_999_999)
	assert !timeline.frame_is_due()
	timeline.tick(1)
	assert timeline.frame_is_due()
}

fn test_mock_timeline_caps_stall_backlog_and_ignores_negative_delta() {
	mut timeline := PlaybackTimeline{}
	timeline.present_frame(10_000_000)
	timeline.tick(2_000_000_000)
	assert timeline.elapsed_ns == max_playback_backlog_ns
	timeline.present_frame(10_000_000)
	timeline.tick(-1)
	assert timeline.frame_is_due()
	assert timeline.elapsed_ns == 490_000_000
}

fn test_presentation_clock_waits_without_consuming_missing_frame_time() {
	mut timeline := PlaybackTimeline{}
	timeline.present_frame(40_000_000)
	timeline.tick(50_000_000)
	assert timeline.frame_is_due()
	assert timeline.elapsed_ns == 50_000_000
	// The clock is consumed only when the reordered successor is available.
	timeline.present_frame(40_000_000)
	assert timeline.elapsed_ns == 10_000_000
}

fn test_mock_timeline_reset_makes_first_frame_immediately_due() {
	mut timeline := PlaybackTimeline{}
	timeline.present_frame(1_000_000_000)
	timeline.tick(1)
	assert !timeline.frame_is_due()
	timeline.reset()
	assert timeline.frame_is_due()
}

fn test_presentation_buffer_accounts_for_b_frame_reordering() {
	assert presentation_buffer_size([0, 1, 2, 3]) == 1
	// This is the first GOP ordering parsed from the bundled 360p Big Buck
	// Bunny fixture. Pictures 6 and 3 wait while picture 1 is decoded.
	assert presentation_buffer_size([0, 6, 3, 1, 2, 4, 5]) == 3
}

fn test_ready_outputs_are_presented_by_picture_order() {
	mut player := VideoPlayer{
		output_textures: [
			OutputImage{ display_order: 6, duration_ns: 1 },
			OutputImage{ display_order: 3, duration_ns: 1 },
			OutputImage{ display_order: 0, duration_ns: 1 },
			OutputImage{ display_order: 1, duration_ns: 1 },
		]
		output_textures_ready: [0, 1, 2, 3]
	}
	assert player.present_ready_output(0)
	assert player.current_output_index == 2
	assert player.next_display_order == 1
	assert player.output_textures_ready == [0, 1, 3]
	assert player.present_ready_output(1)
	assert player.current_output_index == 3
	assert player.next_display_order == 2
	assert player.output_textures_retired.len == 1
	assert player.output_textures_retired[0].index == 2
	assert !player.present_ready_output(2)
}

fn test_loop_restart_keeps_last_picture_until_new_zero_is_ready() {
	mut player := VideoPlayer{
		current_output_index: 4
		current_frame: 9
		next_display_order: 10
		decode_finished: true
	}
	player.restart_decode_cycle()
	assert player.current_output_index == 4
	assert player.current_frame == 0
	assert player.next_display_order == 0
	assert !player.decode_finished
	assert player.waiting_for_loop_start
	assert has_flag[VideoPlayerFlags](player.flags, VideoPlayerFlags.e_decoder_reset)
}
