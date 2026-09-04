#!/usr/bin/env bash
set -euo pipefail

usage() {
	cat <<'EOF'
Usage: build_linux.sh [options]

Options:
  --compiler stable|v3       V compiler frontend (default: stable)
  --linkage shared|static    Dear ImGui linkage (default: shared)
  --glfw system|bundled      GLFW provider (default: system)
  --glfw-version VERSION     Bundled GLFW release (default: 3.4)
  --skip-install             Do not run `v install`
EOF
}

compiler=stable
linkage=shared
glfw_provider=system
glfw_version=3.4
install_modules=1
while (($#)); do
	case "$1" in
		--compiler) compiler=$2; shift 2 ;;
		--linkage) linkage=$2; shift 2 ;;
		--glfw) glfw_provider=$2; shift 2 ;;
		--glfw-version) glfw_version=$2; shift 2 ;;
		--skip-install) install_modules=0; shift ;;
		-h|--help) usage; exit 0 ;;
		*) echo "Unknown option: $1" >&2; usage >&2; exit 2 ;;
	esac
done

[[ $compiler == stable || $compiler == v3 ]] || { echo 'compiler must be stable or v3' >&2; exit 2; }
[[ $linkage == shared || $linkage == static ]] || { echo 'linkage must be shared or static' >&2; exit 2; }
[[ $glfw_provider == system || $glfw_provider == bundled ]] || { echo 'glfw must be system or bundled' >&2; exit 2; }

project_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." >/dev/null 2>&1 && pwd)
v_bin=${V_BIN:-v}
command -v "$v_bin" >/dev/null 2>&1 || { echo "V compiler not found: $v_bin" >&2; exit 1; }

cd "$project_dir"
if ((install_modules)); then
	"$v_bin" install
fi

vmodules_dir=${VMODULES:-$HOME/.vmodules}
imgui_dir=$vmodules_dir/imgui
[[ -f $imgui_dir/build_vimgui.sh ]] || {
	echo "ImGui module not found at $imgui_dir; check VMODULES or run v install." >&2
	exit 1
}
git -C "$imgui_dir" submodule update --init --recursive
"$imgui_dir/build_vimgui.sh" --linkage "$linkage" --glfw "$glfw_provider" --glfw-version "$glfw_version"

v_flags=()
[[ $compiler == v3 ]] && v_flags+=(-new-compiler)
[[ $linkage == static ]] && v_flags+=(-d imgui_static)
"$v_bin" "${v_flags[@]}" -cc gcc -o v_vulkan_video .
echo "Built $project_dir/v_vulkan_video with $compiler V compiler, $linkage ImGui, and $glfw_provider GLFW."
