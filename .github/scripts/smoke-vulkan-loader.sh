#!/usr/bin/env bash
# Checks the packaged Vulkan loader path before running the video player.
set -euo pipefail

player=${1:?Usage: smoke-vulkan-loader.sh PLAYER}
log_dir=$(mktemp -d)
trap 'rm -rf -- "$log_dir"' EXIT

# Software Vulkan is enough to check loader dispatch and device discovery.
# This does not emulate H.264 decoding or claim hardware playback coverage.
icds=(/usr/share/vulkan/icd.d/lvp_icd*.json)
[[ -f ${icds[0]} ]] || { echo 'Lavapipe ICD is missing' >&2; exit 1; }
export VK_DRIVER_FILES=${icds[0]}
export VK_ICD_FILENAMES=${icds[0]}

timeout 20s "$player" --help > "$log_dir/help.log" 2>&1 || {
	status=$?
	cat "$log_dir/help.log"
	exit "$status"
}
cat "$log_dir/help.log"
timeout 20s xvfb-run -a "$player" --list-gpus res/20240917_095400.mp4 > "$log_dir/gpus.log" 2>&1 || {
	status=$?
	cat "$log_dir/gpus.log"
	exit "$status"
}
cat "$log_dir/gpus.log"
grep -F 'Vulkan devices for H.264' "$log_dir/gpus.log"
grep -i 'llvmpipe\|lavapipe' "$log_dir/gpus.log"
