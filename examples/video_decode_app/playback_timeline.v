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

fn (mut timeline PlaybackTimeline) tick(delta_ns i64) {
	if timeline.started {
		timeline.elapsed_ns += math.max[i64](0, delta_ns)
		timeline.elapsed_ns = math.min(timeline.elapsed_ns, max_playback_backlog_ns)
	}
}

fn (timeline &PlaybackTimeline) frame_is_due() bool {
	return !timeline.started || timeline.elapsed_ns >= timeline.duration_ns
}

fn (mut timeline PlaybackTimeline) present_frame(duration_ns i64) {
	if timeline.started {
		timeline.elapsed_ns = math.max[i64](0, timeline.elapsed_ns - timeline.duration_ns)
	} else {
		timeline.started = true
		timeline.elapsed_ns = 0
	}
	timeline.duration_ns = math.max[i64](1, duration_ns)
}

fn (mut timeline PlaybackTimeline) reset() {
	timeline.started = false
	timeline.elapsed_ns = 0
	timeline.duration_ns = 1
}
