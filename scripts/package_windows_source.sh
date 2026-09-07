#!/usr/bin/env bash
set -euo pipefail

project_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." >/dev/null 2>&1 && pwd)
workspace_dir=$(cd -- "$project_dir/.." >/dev/null 2>&1 && pwd)
modules_setting=${V_MODULES_DIR:-${VMODULES:-${HOME}/.vmodules}}
modules_dir=$(cd -- "${modules_setting%%:*}" >/dev/null 2>&1 && pwd)
output_zip=${1:-$workspace_dir/vkvideo_windows_source.zip}
bundle_name=vkvideo-windows-source
stage_dir=$(mktemp -d "$workspace_dir/.vkvideo-windows-source.XXXXXX")
trap 'rm -rf -- "$stage_dir"' EXIT

mkdir -p "$stage_dir/$bundle_name/v_vulkan_video" "$stage_dir/$bundle_name/modules/antono2"
rsync -a --exclude '.git' --exclude '.build' --exclude 'build' --exclude 'dist' \
	--exclude 'v_vulkan_video' --exclude '*.o' --exclude '*.so' --exclude '*.a' \
	"$project_dir/" "$stage_dir/$bundle_name/v_vulkan_video/"
for module in glfw h264 imgui minimp4 vkmemalloc vulkan; do
	module_path=antono2/$module
	if [[ ! -d $modules_dir/$module_path && $module != vkmemalloc ]]; then
		module_path=$module
	fi
	if [[ ! -d $modules_dir/$module_path ]]; then
		echo "Missing V module: antono2/$module" >&2
		exit 1
	fi
	rsync -a --exclude '.git' --exclude '.build' --exclude 'build' --exclude 'lib' \
		--exclude '*.o' --exclude '*.so' --exclude '*.a' \
		"$modules_dir/$module_path/" "$stage_dir/$bundle_name/modules/antono2/$module/"
done

(cd "$stage_dir" && zip -qr source.zip "$bundle_name")
install -m 0644 "$stage_dir/source.zip" "$output_zip"
unzip -t "$output_zip" >/dev/null
sha256sum "$output_zip"
