#!/bin/sh
# Compatibility entry point for the V Ubuntu packager.
set -eu
script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
compiler=${V_BIN:-$script_dir/../../v/v}
if [ -z "${V_BIN:-}" ] && [ ! -x "$compiler" ]; then
    compiler=v
fi
exec "$compiler" run "$script_dir/package_ubuntu24.vsh" "$@"
