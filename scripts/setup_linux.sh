#!/usr/bin/env bash
set -euo pipefail

usage() {
	cat <<'EOF'
Usage: setup_linux.sh [--check|--install]

  --check    Report build/runtime prerequisites without changing the system
             (default).
  --install  Install Debian/Ubuntu build prerequisites, then run the checks.
EOF
}

mode=check
case "${1:-}" in
	''|--check) ;;
	--install) mode=install ;;
	-h|--help) usage; exit 0 ;;
	*) usage >&2; exit 2 ;;
esac

if [[ $mode == install ]]; then
	if [[ ! -r /etc/os-release ]]; then
		echo 'Cannot identify this Linux distribution.' >&2
		exit 1
	fi
	# shellcheck disable=SC1091
	source /etc/os-release
	case "${ID:-}:${ID_LIKE:-}" in
		ubuntu:*|debian:*|*:debian*) ;;
		*) echo 'Automatic installation supports Debian and Ubuntu only; see QUICKSTART.md.' >&2; exit 1 ;;
	esac
	packages=(build-essential cmake git luajit libglfw3-dev libvulkan-dev vulkan-tools pkg-config)
	printf 'Installing: %s\n' "${packages[*]}"
	sudo apt-get update
	sudo apt-get install -y "${packages[@]}"
fi

missing=0
for command in git cmake cc c++ pkg-config vulkaninfo; do
	if command -v "$command" >/dev/null 2>&1; then
		printf '[ok]      %s\n' "$command"
	else
		printf '[missing] %s\n' "$command"
		missing=1
	fi
done

if command -v v >/dev/null 2>&1; then
	printf '[ok]      v: %s\n' "$(v version 2>/dev/null || true)"
else
	echo '[missing] v (install from https://github.com/vlang/v)'
	missing=1
fi

if command -v vulkaninfo >/dev/null 2>&1; then
	vulkan_summary=$(mktemp)
	vulkan_details=$(mktemp)
	trap 'rm -f "$vulkan_summary" "$vulkan_details"' EXIT
	if vulkaninfo --summary >"$vulkan_summary" 2>&1; then
		echo '[ok]      Vulkan loader can enumerate devices'
	else
		echo '[failed]  vulkaninfo could not enumerate a usable Vulkan device'
		missing=1
	fi
	vulkaninfo >"$vulkan_details" 2>/dev/null || true
	for extension in VK_KHR_video_queue VK_KHR_video_decode_queue VK_KHR_video_decode_h264; do
		if grep -q "$extension" "$vulkan_details"; then
			printf '[ok]      %s advertised\n' "$extension"
		else
			printf '[missing] %s (driver/GPU capability)\n' "$extension"
			missing=1
		fi
	done
fi

if ((missing)); then
	echo 'One or more requirements are unavailable. See QUICKSTART.md.' >&2
	exit 1
fi
echo 'Build and Vulkan Video prerequisites look usable.'
