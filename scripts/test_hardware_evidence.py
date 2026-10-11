"""A capability probe or unsuccessful comparison must not claim decode validation."""
import json
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch
from hardware_evidence import main


class EvidenceChecks(unittest.TestCase):
    def run_fixture(self, root, capture=False):
        player, video, output = root / 'player.exe', root / 'video.mp4', root / 'report.json'
        player.write_bytes(b'player fixture')
        video.write_bytes(b'media fixture')
        arguments = ['hardware_evidence.py', '--player', str(player), '--video', str(video), '--output', str(output)]
        if capture:
            dump = root / 'capture'
            dump.mkdir()
            arguments += ['--dump-dir', str(dump)]
        responses = [(True, 'device enumeration'), (True, 'driver version'), (True, 'FFmpeg fixture')]
        if capture:
            responses.append((False, 'GPU capture does not match reference'))
        with patch('sys.argv', arguments), patch('hardware_evidence.probe', side_effect=responses):
            code = main()
        self.assertEqual(player.read_bytes(), b'player fixture')
        self.assertEqual(video.read_bytes(), b'media fixture')
        return code, json.loads(output.read_text())

    def test_successful_enumeration_without_capture_is_not_decode_evidence(self):
        with tempfile.TemporaryDirectory() as directory:
            code, report = self.run_fixture(Path(directory))
            self.assertEqual(code, 2)
            self.assertEqual(report['status'], 'capabilities_only')
            self.assertTrue(report['device_enumeration_passed'])
            self.assertIn('No real GPU capture', report['comparison'])

    def test_bad_pixels_produce_failed_report_and_exit(self):
        with tempfile.TemporaryDirectory() as directory:
            code, report = self.run_fixture(Path(directory), capture=True)
            self.assertEqual(code, 2)
            self.assertEqual(report['status'], 'comparison_failed')
            self.assertIn('does not match', report['comparison'])


if __name__ == '__main__':
    unittest.main()
