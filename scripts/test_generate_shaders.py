#!/usr/bin/env python3
"""Check shader regeneration, read-only drift detection and failed-build preservation."""

import argparse
import contextlib
import io
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest
from unittest.mock import patch

import generate_shaders as generator


@unittest.skipUnless(all(shutil.which(tool) for tool in
                         ["glslc", "glslangValidator", "spirv-val"]),
                     "Vulkan SDK shader tools are required")
class GenerationTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        for name in ["video.vert", "video.frag"]:
            shutil.copyfile(generator.ROOT / name, self.root / name)
        self.patch = patch.object(generator, "ROOT", self.root)
        self.patch.start()
        self.addCleanup(self.patch.stop)
        self.args = argparse.Namespace(check=False, glslc="glslc",
                                       glslang="glslangValidator", spirv_val="spirv-val")
        with contextlib.redirect_stdout(io.StringIO()):
            self.assertEqual(generator.generate(self.args), 0)

    def outputs(self):
        return {p.name: p.read_bytes() for p in self.root.glob("*_shader.v")}

    def test_regeneration_and_read_only_check(self):
        original = self.outputs()
        self.args.check = True
        self.assertEqual(generator.generate(self.args), 0)
        for stage in ["vertex", "fragment"]:
            self.assertIn(b"Regenerate: python3 scripts/generate_shaders.py",
                          original[f"{stage}_shader.v"])
        target = self.root / "fragment_shader.v"
        target.write_text("stale output\n")
        drifted = self.outputs()
        with contextlib.redirect_stdout(io.StringIO()):
            self.assertEqual(generator.generate(self.args), 1)
        self.assertEqual(self.outputs(), drifted)
        self.args.check = False
        with contextlib.redirect_stdout(io.StringIO()):
            self.assertEqual(generator.generate(self.args), 0)
        self.assertEqual(self.outputs(), original)

    def test_compile_failure_preserves_both_outputs(self):
        original = self.outputs()
        (self.root / "video.frag").write_text("invalid shader\n")
        with self.assertRaises(subprocess.CalledProcessError):
            generator.generate(self.args)
        self.assertEqual(self.outputs(), original)


if __name__ == "__main__":
    unittest.main()
