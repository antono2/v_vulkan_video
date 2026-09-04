module video_decode_app

import math

const max_playback_backlog_ns = i64(500_000_000)

// PlaybackTimeline contains only media-clock state. It deliberately has no
// Vulkan or decoder dependency, so deterministic tests can exercise the exact
// scheduling logic used by hardware playback.
struct PlaybackTimeline {
mut:
	started     bool
	elapsed_ns  i64
	duration_ns i64 = 1
}

fn (mut timeline PlaybackTimeline) decode_is_due(delta_ns i64) bool {
	if !timeline.started {
		return true
	}
	timeline.elapsed_ns += math.max[i64](0, delta_ns)
	if timeline.elapsed_ns < timeline.duration_ns {
		return false
	}
	timeline.elapsed_ns -= timeline.duration_ns
	// Avoid a long application stall causing an extended fast-forward burst.
	timeline.elapsed_ns = math.min(timeline.elapsed_ns, max_playback_backlog_ns)
	return true
}

fn (mut timeline PlaybackTimeline) frame_decoded(duration_ns i64) {
	timeline.started = true
	timeline.duration_ns = math.max[i64](1, duration_ns)
}

fn (mut timeline PlaybackTimeline) reset() {
	timeline.started = false
	timeline.elapsed_ns = 0
	timeline.duration_ns = 1
}

struct FrameAdvance {
	next_frame    int
	stopped       bool
	decoder_reset bool
}

fn advance_decoded_frame(current_frame int, frame_count int, looping bool) FrameAdvance {
	if frame_count <= 0 {
		return FrameAdvance{stopped: true}
	}
	if current_frame + 1 < frame_count {
		return FrameAdvance{next_frame: current_frame + 1}
	}
	if looping {
		return FrameAdvance{decoder_reset: true}
	}
	return FrameAdvance{
		next_frame: frame_count - 1
		stopped: true
	}
}
