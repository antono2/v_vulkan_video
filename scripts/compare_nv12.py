#!/usr/bin/env python3
"""Compare display-order NV12 GPU dumps with FFmpeg's decoded frames."""

import argparse
import json
from pathlib import Path
import subprocess
import sys


def video_dimensions(path: Path) -> tuple[int, int]:
    result = subprocess.run(
        [
            "ffprobe", "-v", "error", "-select_streams", "v:0",
            "-show_entries", "stream=width,height", "-of", "json", str(path),
        ],
        check=True,
        capture_output=True,
        text=True,
    )
    stream = json.loads(result.stdout)["streams"][0]
    return stream["width"], stream["height"]


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("reference", type=Path, help="MP4 or original H.264 elementary stream")
    parser.add_argument("dump_dir", type=Path, help="VV_DUMP_NV12_DIR from one playback loop")
    parser.add_argument("--tolerance", type=int, default=0, help="maximum allowed difference per byte")
    args = parser.parse_args()
    if not 0 <= args.tolerance <= 255:
        parser.error("--tolerance must be between 0 and 255")
    width, height = video_dimensions(args.reference)
    if width % 2 or height % 2:
        parser.error("NV12 comparison requires even dimensions")
    frame_size = width * height * 3 // 2
    frames = sorted(args.dump_dir.glob("*.nv12"), key=lambda path: int(path.stem))
    if not frames or [int(path.stem) for path in frames] != list(range(len(frames))):
        parser.error("dump directory must contain contiguous 0.nv12, 1.nv12, ... files")

    command = [
        "ffmpeg", "-hide_banner", "-loglevel", "error", "-i", str(args.reference),
        "-fps_mode", "passthrough", "-pix_fmt", "nv12", "-f", "rawvideo", "pipe:1",
    ]
    mismatched = 0
    max_difference = 0
    with subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL) as process:
        assert process.stdout is not None
        for index, path in enumerate(frames):
            gpu = path.read_bytes()
            reference = process.stdout.read(frame_size)
            if len(gpu) != frame_size or len(reference) != frame_size:
                print(f"Frame {index}: expected {frame_size} bytes, got GPU={len(gpu)} FFmpeg={len(reference)}", file=sys.stderr)
                process.terminate()
                return 1
            difference = max(abs(a - b) for a, b in zip(gpu, reference))
            max_difference = max(max_difference, difference)
            if difference > args.tolerance:
                mismatched += 1
                if mismatched <= 5:
                    print(f"Frame {index}: maximum byte difference {difference}")
        if process.stdout.read(1):
            print("FFmpeg produced more frames than the GPU capture", file=sys.stderr)
            process.terminate()
            return 1
        if process.wait() != 0:
            print("FFmpeg could not decode the reference input", file=sys.stderr)
            return 1
    print(f"Compared {len(frames)} frames at {width}x{height}; mismatched={mismatched}, maximum byte difference={max_difference}")
    return 1 if mismatched else 0


if __name__ == "__main__":
    sys.exit(main())
