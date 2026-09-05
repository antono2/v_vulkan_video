#!/usr/bin/env bash
set -euo pipefail

project_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." >/dev/null 2>&1 && pwd)
modules_dir=${VMODULES:?VMODULES must point to the checked-out V modules}
output_zip=${1:-$project_dir/vkvideo-ubuntu24-amd64.zip}
package_name=vkvideo-ubuntu24-amd64
stage_dir=$(mktemp -d)
trap 'rm -rf -- "$stage_dir"' EXIT
package_dir="$stage_dir/$package_name"

for required in \
	"$project_dir/v_vulkan_video" \
	"$modules_dir/imgui/lib/libvimgui.so" \
	/usr/lib/x86_64-linux-gnu/libglfw.so.3 \
	/usr/lib/x86_64-linux-gnu/libstdc++.so.6 \
	/lib/x86_64-linux-gnu/libgcc_s.so.1 \
	"$project_dir/res/20240917_095400.mp4"; do
	[[ -f $required ]] || { echo "Missing package input: $required" >&2; exit 1; }
done

mkdir -p "$package_dir/lib" "$package_dir/res"
install -m 0755 "$project_dir/v_vulkan_video" "$package_dir/v_vulkan_video"
install -m 0755 "$modules_dir/imgui/lib/libvimgui.so" "$package_dir/lib/libvimgui.so"
install -m 0755 /usr/lib/x86_64-linux-gnu/libglfw.so.3 "$package_dir/lib/libglfw.so.3"
install -m 0755 /usr/lib/x86_64-linux-gnu/libstdc++.so.6 "$package_dir/lib/libstdc++.so.6"
install -m 0755 /lib/x86_64-linux-gnu/libgcc_s.so.1 "$package_dir/lib/libgcc_s.so.1"
install -m 0644 "$project_dir/res/20240917_095400.mp4" "$package_dir/res/sample.mp4"
install -m 0755 "$project_dir/packaging/ubuntu24/run.sh" "$package_dir/run.sh"
install -m 0644 "$project_dir/packaging/ubuntu24/README.txt" "$package_dir/README.txt"

strip --strip-unneeded "$package_dir/v_vulkan_video" "$package_dir/lib/libvimgui.so"
patchelf --set-rpath '$ORIGIN/lib' "$package_dir/v_vulkan_video"
patchelf --set-rpath '$ORIGIN' "$package_dir/lib/libvimgui.so"

(cd "$stage_dir" && zip -qr package.zip "$package_name")
install -m 0644 "$stage_dir/package.zip" "$output_zip"
"$project_dir/scripts/verify_ubuntu24_package.sh" "$output_zip"
sha256sum "$output_zip"
