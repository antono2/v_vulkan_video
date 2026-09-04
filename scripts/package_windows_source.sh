#!/usr/bin/env bash
set -euo pipefail

project_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." >/dev/null 2>&1 && pwd)
workspace_dir=$(cd -- "$project_dir/.." >/dev/null 2>&1 && pwd)
modules_dir=$(cd -- "${V_MODULES_DIR:-${HOME}/.vmodules}" >/dev/null 2>&1 && pwd)
output_zip=${1:-$workspace_dir/vkvideo_windows_source.zip}
bundle_name=vkvideo-windows-source
stage_dir=$(mktemp -d "$workspace_dir/.vkvideo-windows-source.XXXXXX")
trap 'rm -rf -- "$stage_dir"' EXIT

mkdir -p "$stage_dir/$bundle_name/v_vulkan_video" "$stage_dir/$bundle_name/modules"
rsync -a --exclude '.git' --exclude '.build' --exclude 'build' --exclude 'dist' \
	--exclude 'v_vulkan_video' --exclude '*.o' --exclude '*.so' --exclude '*.a' \
	"$project_dir/" "$stage_dir/$bundle_name/v_vulkan_video/"
for module in glfw h264 imgui minimp4 vulkan vulkan_memory_allocator; do
	if [[ ! -d $modules_dir/$module ]]; then
		echo "Missing V module: $modules_dir/$module" >&2
		exit 1
	fi
	rsync -a --exclude '.git' --exclude '.build' --exclude 'build' --exclude 'lib' \
		--exclude '*.o' --exclude '*.so' --exclude '*.a' \
		"$modules_dir/$module/" "$stage_dir/$bundle_name/modules/$module/"
done

(cd "$stage_dir" && zip -qr source.zip "$bundle_name")
install -m 0644 "$stage_dir/source.zip" "$output_zip"
unzip -t "$output_zip" >/dev/null
sha256sum "$output_zip"
