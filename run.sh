#!/usr/bin/env bash
# Launches the development player using the repository's configured build and input options.
set -euo pipefail

project_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec v -d debug -cc gcc run "${project_dir}" -- "$@"
