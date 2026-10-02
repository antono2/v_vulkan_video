#!/usr/bin/env python3
"""Exercise coded-pixel comparisons with and without MP4 display rotation."""

import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[1]
FIXTURE = ROOT / "res/H264_parameter_id_7_160x96_1s.mp4"
COMPARE = ROOT / "scripts/compare_nv12.py"


class CompareNv12Tests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.directory = Path(self.temp.name)
        self.frames = self.directory / "frames"
        self.frames.mkdir()
        raw = subprocess.run(
            ["ffmpeg", "-v", "error", "-noautorotate", "-i", str(FIXTURE),
             "-fps_mode", "passthrough", "-pix_fmt", "nv12", "-f", "rawvideo", "pipe:1"],
            check=True, capture_output=True,
        ).stdout
        frame_size = 160 * 96 * 3 // 2
        self.assertEqual(len(raw), 5 * frame_size)
        for index in range(5):
            (self.frames / f"{index}.nv12").write_bytes(
                raw[index * frame_size:(index + 1) * frame_size]
            )

    def compare(self, reference):
        return subprocess.run(
            [sys.executable, str(COMPARE), str(reference), str(self.frames)],
            capture_output=True, text=True,
        )

    def test_unrotated_coded_pixels(self):
        result = self.compare(FIXTURE)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertIn("Compared 5 frames", result.stdout)

    def test_rotated_display_preserves_coded_pixels(self):
        rotated = self.directory / "rotated.mp4"
        subprocess.run(
            ["ffmpeg", "-v", "error", "-display_rotation", "90", "-i", str(FIXTURE),
             "-c:v", "copy", str(rotated)], check=True,
        )
        metadata = json.loads(subprocess.run(
            ["ffprobe", "-v", "error", "-select_streams", "v:0",
             "-show_entries", "stream_side_data=rotation", "-of", "json", str(rotated)],
            check=True, capture_output=True, text=True,
        ).stdout)
        rotations = metadata["streams"][0]["side_data_list"]
        self.assertTrue(any(abs(item.get("rotation", 0)) == 90 for item in rotations))
        result = self.compare(rotated)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertIn("maximum byte difference=0", result.stdout)

    def test_changed_pixels_are_rejected(self):
        first = self.frames / "0.nv12"
        pixels = bytearray(first.read_bytes())
        pixels[0] ^= 255
        first.write_bytes(pixels)
        result = self.compare(FIXTURE)
        self.assertEqual(result.returncode, 1, result.stdout + result.stderr)
        self.assertIn("mismatched=1", result.stdout)


if __name__ == "__main__":
    unittest.main()
