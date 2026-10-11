#!/usr/bin/env python3
"""Record GPU/driver evidence and compare a real first-loop NV12 capture."""
import argparse
from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path
import platform
import sys

from doctor import probe


def file_hash(path):
    digest = hashlib.sha256()
    with path.open('rb') as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b''):
            digest.update(block)
    return digest.hexdigest()


def result_scope(compared, available):
    return 'decoded_pixels_match' if compared else ('comparison_failed' if available else 'capabilities_only')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--player', type=Path, required=True)
    parser.add_argument('--video', type=Path, required=True)
    parser.add_argument('--reference', type=Path, help='Original elementary stream when MP4 remux timestamps differ')
    parser.add_argument('--dump-dir', type=Path, help='Existing VV_DUMP_NV12_DIR from actual GPU playback')
    parser.add_argument('--output', type=Path, required=True, help='New JSON evidence file')
    args = parser.parse_args()
    player = args.player.resolve(strict=True)
    video = args.video.resolve(strict=True)
    reference = (args.reference or video).resolve(strict=True)
    passed, gpu = probe([str(player), '--list-gpus', str(video)], timeout=30)
    sdk = os.environ.get('VULKAN_SDK', '')
    vulkaninfo = str(Path(sdk) / 'Bin/vulkaninfo.exe') if os.name == 'nt' and sdk else 'vulkaninfo'
    _, driver = probe([vulkaninfo, '--summary'], timeout=30)
    _, ffmpeg = probe(['ffmpeg', '-version'])
    compared, comparison = False, 'No real GPU capture supplied; decoding is unverified.'
    if args.dump_dir:
        compared, comparison = probe([sys.executable, str(Path(__file__).with_name('compare_nv12.py')),
                                      str(reference), str(args.dump_dir.resolve(strict=True))], timeout=300)
    report = {'captured_at': datetime.now(timezone.utc).isoformat(), 'platform': platform.platform(),
              'player_sha256': file_hash(player), 'video_sha256': file_hash(video),
              'reference_sha256': file_hash(reference), 'device_enumeration_passed': passed,
              'devices': gpu, 'driver': driver, 'ffmpeg': ffmpeg.splitlines()[0] if ffmpeg else '',
              'status': result_scope(compared and passed, bool(args.dump_dir)), 'comparison': comparison,
              'remaining_checks': ['rendered colors/orientation', 'resize and window close',
                                   'long-running looping', 'other GPU drivers', 'Windows OpenCL interoperability']}
    with args.output.open('x', encoding='utf-8') as output:
        json.dump(report, output, indent=2)
        output.write('\n')
    print(f"{report['status']}: {args.output}")
    return 0 if report['status'] == 'decoded_pixels_match' else 2


if __name__ == '__main__':
    raise SystemExit(main())
