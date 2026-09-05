#!/usr/bin/env bash
set -euo pipefail

package_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)

if (($# == 0)); then
	exec "$package_dir/v_vulkan_video" "$package_dir/res/sample.mp4"
fi
exec "$package_dir/v_vulkan_video" "$@"
