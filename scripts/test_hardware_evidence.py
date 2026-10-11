"""A capability probe or unsuccessful comparison must not claim decode validation."""
import unittest
from hardware_evidence import result_scope


class EvidenceChecks(unittest.TestCase):
    def test_capabilities_are_not_decode_evidence(self):
        self.assertEqual(result_scope(False, False), 'capabilities_only')

    def test_failed_pixels_do_not_pass(self):
        self.assertEqual(result_scope(False, True), 'comparison_failed')
        self.assertEqual(result_scope(True, True), 'decoded_pixels_match')


if __name__ == '__main__':
    unittest.main()
