#!/usr/bin/env bash
set -euo pipefail

package_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
export LD_LIBRARY_PATH="$package_dir/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"

if (($# == 0)); then
	exec "$package_dir/v_vulkan_video" "$package_dir/res/sample.mp4"
fi
exec "$package_dir/v_vulkan_video" "$@"
