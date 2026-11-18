#!/bin/sh
# Compatibility entry point for the V development launcher.
set -eu
dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
exec "${V_BIN:-v}" run "$dir/run.vsh" -- "$@"
