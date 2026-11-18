#!/bin/sh
# Compatibility entry point for the Linux setup and prerequisite checks.
set -eu
dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
exec "${V_BIN:-v}" run "$dir/setup_linux.vsh" "$@"
