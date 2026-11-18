#!/bin/sh
# Compatibility entry point for the native V builder.
set -eu
dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
exec "${V_BIN:-v}" run "$dir/build_linux.vsh" "$@"
