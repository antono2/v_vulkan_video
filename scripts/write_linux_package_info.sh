#!/usr/bin/env bash
# Writes dependency/build information used by the Linux distribution.
set -euo pipefail

package_dir=${1:?Usage: write_linux_package_info.sh PACKAGE_DIR}
project_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
modules_dir=${VMODULES:?VMODULES must identify the checked-out V modules}
modules_dir=${modules_dir%%:*}
v_bin=${V_BIN:-v}

module_directory() {
	local module=$1
	if [[ $module == imgui && -n ${VIMGUI_DIR:-} ]]; then
		printf '%s' "$VIMGUI_DIR"
	elif [[ -d $modules_dir/antono2/$module ]]; then
		printf '%s' "$modules_dir/antono2/$module"
	else
		printf '%s' "$modules_dir/$module"
	fi
}

revision() {
	local directory=$1
	if [[ -e $directory/.git ]]; then
		git -C "$directory" rev-parse HEAD
	elif [[ -f $directory/SOURCE_REVISION ]]; then
		tr -d '\r\n' < "$directory/SOURCE_REVISION"
	else
		printf 'unrecorded source checkout'
	fi
}

install -m 0644 "$project_dir/LICENSE" "$package_dir/LICENSE"
install -m 0644 "$project_dir/res/README.md" "$package_dir/MEDIA.txt"
mkdir -p "$package_dir/licenses"
while read -r module source destination; do
	install -m 0644 "$(module_directory "$module")/$source" "$package_dir/licenses/$destination"
done < "$project_dir/packaging/licenses.manifest"

runtime_root=${PACKAGE_RUNTIME_ROOT:-/}
for runtime in libstdc++6 libgcc-s1; do
	install -m 0644 "$runtime_root/usr/share/doc/$runtime/copyright" "$package_dir/licenses/$runtime.txt"
done

{
	printf 'Source revision: %s\n' "$(revision "$project_dir")"
	printf 'V compiler: %s\n' "$("$v_bin" version)"
	printf 'Compiler mode: %s\n' "${PACKAGE_COMPILER_MODE:-default}"
	printf 'C compiler: %s\n' "${PACKAGE_C_COMPILER:-gcc}"
	printf 'Vulkan SDK: %s\n' "${VULKAN_SDK_VERSION:-system headers}"
	printf 'Package target: Ubuntu 24.04 x86-64\n'
	for module in vulkan vkmemalloc memory imgui glfw minimp4 h264; do
		printf 'Module %s: %s\n' "$module" "$(revision "$(module_directory "$module")")"
	done
} > "$package_dir/BUILD-INFO.txt"
