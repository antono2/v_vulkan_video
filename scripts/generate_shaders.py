#!/usr/bin/env python3
"""Compile the player GLSL and emit documented V arrays; --check never writes tracked files."""

import argparse
from pathlib import Path
import struct
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]


def run(command):
    subprocess.run(command, check=True, capture_output=True, text=True)


def render(stage, binary):
    if len(binary) < 20 or len(binary) % 4:
        raise ValueError(f"Invalid {stage} SPIR-V length")
    words = struct.unpack(f"<{len(binary) // 4}I", binary)
    if words[0] != 0x07230203:
        raise ValueError(f"Invalid {stage} SPIR-V magic")
    source = "video.vert" if stage == "vertex" else "video.frag"
    purpose = ("Positions the video quad and transforms its texture coordinates."
               if stage == "vertex" else
               "Samples the video texture through the YCbCr-conversion sampler.")
    values = [f"0x{word:08x}" for word in words]
    values[0] = f"u32({values[0]})"
    lines = ["\t" + ", ".join(values[i:i + 6]) + "," for i in range(0, len(values), 6)]
    return (f"// {purpose}\n"
            f"// Generated from {source}; do not edit the embedded SPIR-V words.\n"
            "// Regenerate: python3 scripts/generate_shaders.py (toolchain: BUILDING.md).\n"
            f"module main\n\nconst g_{stage}_shader = [\n" + "\n".join(lines) + "\n]\n")


def generate(args):
    # Compile and validate both stages before changing either tracked output.
    outputs = {}
    with tempfile.TemporaryDirectory(prefix="video-shaders-") as directory:
        temp = Path(directory)
        for stage, source, compiler in [
            ("vertex", "video.vert", [args.glslc, "--target-env=vulkan1.0"]),
            ("fragment", "video.frag", [args.glslang, "-V", "--target-env", "vulkan1.0"]),
        ]:
            binary = temp / f"{stage}.spv"
            run([*compiler, str(ROOT / source), "-o", str(binary)])
            run([args.spirv_val, "--target-env", "vulkan1.0", str(binary)])
            output = temp / f"{stage}_shader.v"
            output.write_text(render(stage, binary.read_bytes()), encoding="utf-8")
            outputs[ROOT / output.name] = output.read_bytes()
    changed = [path for path, data in outputs.items() if not path.exists() or path.read_bytes() != data]
    if args.check:
        for path in changed:
            print(f"Stale generated shader: {path.name}")
        return 1 if changed else 0
    for path in changed:
        path.write_bytes(outputs[path])
        print(f"Generated {path.name}")
    return 0


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true")
    parser.add_argument("--glslc", default="glslc")
    parser.add_argument("--glslang", default="glslangValidator")
    parser.add_argument("--spirv-val", default="spirv-val")
    args = parser.parse_args()
    try:
        return generate(args)
    except subprocess.CalledProcessError as error:
        parser.exit(1, f"Shader command failed: {error.cmd}\n{error.stdout}{error.stderr}")
    except (OSError, ValueError) as error:
        parser.exit(1, f"Shader generation failed: {error}\n")


if __name__ == "__main__":
    raise SystemExit(main())
