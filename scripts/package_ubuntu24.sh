#!/usr/bin/env bash
set -euo pipefail

project_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." >/dev/null 2>&1 && pwd)
workspace_dir=$(cd -- "$project_dir/.." >/dev/null 2>&1 && pwd)
v_bin=${V_BIN:-$workspace_dir/v/v}
rootfs=${UBUNTU24_ROOTFS:-$workspace_dir/.buildroots/ubuntu-24.04}
imgui_dir=${VIMGUI_DIR:-${HOME}/.vmodules/imgui}
vmodules_dir=$(cd -- "$imgui_dir/.." >/dev/null 2>&1 && pwd)
vulkan_sdk=${VULKAN_SDK:-$workspace_dir/1.4.341.1/x86_64}
output_zip=${1:-$workspace_dir/vkvideo_ubuntu24_amd64.zip}
package_name=vkvideo-ubuntu24-amd64

for required in "$v_bin" "$rootfs/usr/bin/patchelf" "$imgui_dir/build_vimgui.sh" \
	"$project_dir/res/20240917_095400.mp4"; do
	if [[ ! -e $required ]]; then
		echo "Missing required build input: $required" >&2
		exit 1
	fi
done

build_dir=$(mktemp -d "$workspace_dir/.vkvideo-build.XXXXXX")
trap 'rm -rf -- "$build_dir"' EXIT
mkdir -p "$build_dir/output" "$build_dir/$package_name/lib" "$build_dir/$package_name/res"

# Build the native C++ binding against Ubuntu 24 while keeping it in a shared
# object. This isolates its Vulkan symbols from Volk in the V executable.
bwrap --ro-bind "$rootfs" / --dev-bind /dev /dev --proc /proc --tmpfs /tmp \
	--ro-bind "$workspace_dir" "$workspace_dir" \
	--bind "$vmodules_dir" "$vmodules_dir" \
	--chdir "$imgui_dir" \
	env VULKAN_SDK="$vulkan_sdk" CMAKE_BUILD_TYPE="${VIMGUI_BUILD_TYPE:-Release}" \
		CFLAGS="-ffile-prefix-map=$workspace_dir=/workspace -ffile-prefix-map=$vmodules_dir=/vmodules" \
		CXXFLAGS="-ffile-prefix-map=$workspace_dir=/workspace -ffile-prefix-map=$vmodules_dir=/vmodules" \
	./build_vimgui.sh --linkage shared \
		--glfw "${VIMGUI_GLFW_PROVIDER:-system}" \
		--glfw-version "${VIMGUI_GLFW_VERSION:-3.3}"

bwrap --ro-bind "$rootfs" / --dev-bind /dev /dev --proc /proc --tmpfs /tmp \
	--ro-bind "$workspace_dir" "$workspace_dir" \
	--bind "$vmodules_dir" "$vmodules_dir" \
	--bind "$build_dir/output" /build-output \
	--chdir "$project_dir" \
	env VULKAN_SDK="$vulkan_sdk" \
	"$v_bin" -cc gcc \
		-cflags "-ffile-prefix-map=$workspace_dir=/workspace" \
		-cflags "-ffile-prefix-map=$vmodules_dir=/vmodules" \
		-o /build-output/v_vulkan_video .

bwrap --ro-bind "$rootfs" / --dev-bind /dev /dev --proc /proc --tmpfs /tmp \
	--bind "$build_dir/output" /build-output \
	/usr/bin/strip --strip-unneeded /build-output/v_vulkan_video
bwrap --ro-bind "$rootfs" / --dev-bind /dev /dev --proc /proc --tmpfs /tmp \
	--bind "$build_dir/output" /build-output \
	/usr/bin/patchelf --set-rpath '$ORIGIN/lib' /build-output/v_vulkan_video
bwrap --ro-bind "$rootfs" / --dev-bind /dev /dev --proc /proc --tmpfs /tmp \
	--bind "$vmodules_dir" "$vmodules_dir" \
	/usr/bin/strip --strip-unneeded "$imgui_dir/lib/libvimgui.so"
bwrap --ro-bind "$rootfs" / --dev-bind /dev /dev --proc /proc --tmpfs /tmp \
	--bind "$vmodules_dir" "$vmodules_dir" \
	/usr/bin/patchelf --set-rpath '$ORIGIN' "$imgui_dir/lib/libvimgui.so"

install -m 0755 "$build_dir/output/v_vulkan_video" "$build_dir/$package_name/v_vulkan_video"
install -m 0755 "$imgui_dir/lib/libvimgui.so" "$build_dir/$package_name/lib/libvimgui.so"
install -m 0755 "$rootfs/usr/lib/x86_64-linux-gnu/libglfw.so.3" "$build_dir/$package_name/lib/libglfw.so.3"
install -m 0755 "$rootfs/usr/lib/x86_64-linux-gnu/libstdc++.so.6" "$build_dir/$package_name/lib/libstdc++.so.6"
install -m 0755 "$rootfs/lib/x86_64-linux-gnu/libgcc_s.so.1" "$build_dir/$package_name/lib/libgcc_s.so.1"
install -m 0644 "$project_dir/res/20240917_095400.mp4" "$build_dir/$package_name/res/sample.mp4"
cp "$project_dir/packaging/ubuntu24/run.sh" "$build_dir/$package_name/run.sh"
cp "$project_dir/packaging/ubuntu24/README.txt" "$build_dir/$package_name/README.txt"
chmod 0755 "$build_dir/$package_name/run.sh"

(cd "$build_dir" && zip -qr package.zip "$package_name")
install -m 0644 "$build_dir/package.zip" "$output_zip"
unzip -t "$output_zip" >/dev/null
PATCHELF="$rootfs/usr/bin/patchelf" \
	"$project_dir/scripts/verify_ubuntu24_package.sh" "$output_zip"
sha256sum "$output_zip"
