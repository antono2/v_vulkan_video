#!/usr/bin/env bash
# Checks extracted Ubuntu package contents and runtime behavior.
set -euo pipefail

archive=${1:?Usage: verify_ubuntu24_package.sh ARCHIVE.zip}
if [[ ! -f $archive ]]; then
	echo "Package does not exist: $archive" >&2
	exit 1
fi
checksum="$archive.sha256"
[[ -f $checksum ]] || { echo "Package checksum is missing: $checksum" >&2; exit 1; }
expected_hash=$(awk 'NR == 1 {print $1}' "$checksum")
actual_hash=$(sha256sum "$archive" | awk '{print $1}')
if [[ ! $expected_hash =~ ^[0-9a-fA-F]{64}$ || ${expected_hash,,} != "$actual_hash" ]]; then
	echo 'Ubuntu package checksum mismatch' >&2
	exit 1
fi

patchelf_bin=${PATCHELF:-}
if [[ -z $patchelf_bin ]]; then
	patchelf_bin=$(command -v patchelf || true)
fi
if [[ -z $patchelf_bin || ! -x $patchelf_bin ]]; then
	echo 'patchelf is required (or set PATCHELF to its executable path)' >&2
	exit 1
fi

verify_dir=$(mktemp -d)
trap 'rm -rf -- "$verify_dir"' EXIT
unzip -q "$archive" -d "$verify_dir"
package_dir="$verify_dir/vkvideo-ubuntu24-amd64"

required_files=(
	"$package_dir/BUILD-INFO.txt"
	"$package_dir/LICENSE"
	"$package_dir/MEDIA.txt"
	"$package_dir/run.sh"
	"$package_dir/v_vulkan_video"
	"$package_dir/lib/libvimgui.so"
	"$package_dir/lib/libglfw.so.3"
	"$package_dir/lib/libstdc++.so.6"
	"$package_dir/lib/libgcc_s.so.1"
	"$package_dir/res/20240917_095400.mp4"
)
project_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
while read -r module source destination; do
	required_files+=("$package_dir/licenses/$destination")
done < "$project_dir/packaging/licenses.manifest"
required_files+=("$package_dir/licenses/libstdc++6.txt" "$package_dir/licenses/libgcc-s1.txt")
for required in "${required_files[@]}"; do
	if [[ ! -s $required ]]; then
		echo "Package is missing: ${required#"$package_dir/"}" >&2
		exit 1
	fi
done

for label in 'Source revision' 'V compiler' 'Compiler mode' 'C compiler' 'Vulkan SDK'; do
	grep -q "^$label: ." "$package_dir/BUILD-INFO.txt" || {
		echo "Package build record is missing: $label" >&2
		exit 1
	}
done
for module in vulkan vkmemalloc memory imgui glfw minimp4 h264; do
	grep -q "^Module $module: ." "$package_dir/BUILD-INFO.txt" || {
		echo "Package build record is missing module: $module" >&2
		exit 1
	}
done

if ! file "$package_dir/v_vulkan_video" | grep -q 'ELF 64-bit.*x86-64'; then
	echo 'Player is not an x86-64 ELF binary' >&2
	exit 1
fi

player_rpath=$("$patchelf_bin" --print-rpath "$package_dir/v_vulkan_video")
imgui_rpath=$("$patchelf_bin" --print-rpath "$package_dir/lib/libvimgui.so")
if [[ $player_rpath != '$ORIGIN/lib' ]]; then
	echo "Unexpected player RUNPATH: $player_rpath" >&2
	exit 1
fi
if [[ $imgui_rpath != '$ORIGIN' ]]; then
	echo "Unexpected libvimgui RUNPATH: $imgui_rpath" >&2
	exit 1
fi

# Do not inject the package directory through LD_LIBRARY_PATH. Besides masking
# broken RUNPATH metadata, that would also make vendor GPU drivers load bundled
# transitive libraries such as libstdc++. The package's two $ORIGIN RUNPATHs
# must be sufficient on their own.
ldd_output=$(ldd "$package_dir/v_vulkan_video")
if grep -q 'not found' <<<"$ldd_output"; then
	echo 'Package has unresolved shared-library dependencies:' >&2
	echo "$ldd_output" >&2
	exit 1
fi
for bundled in libvimgui.so libglfw.so.3 libstdc++.so.6 libgcc_s.so.1; do
	if ! grep -F "$package_dir/lib/$bundled" <<<"$ldd_output" >/dev/null; then
		echo "Player does not resolve $bundled from its package directory" >&2
		exit 1
	fi
done

# Loader paths must be relocatable. Source-file labels embedded for panic and
# assertion diagnostics are harmless strings and are deliberately not treated
# as dependencies.
if readelf -d "$package_dir/v_vulkan_video" "$package_dir/lib/libvimgui.so" |
	grep -E '/home/[^/]+/' >/dev/null; then
	echo 'Package contains an absolute build-user ELF loader path' >&2
	exit 1
fi

echo "Verified relocatable Ubuntu 24 package: $archive"
