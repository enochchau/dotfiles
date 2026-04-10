#!/bin/bash
set -euo pipefail

echo "=== Linux Bootstrap ==="

# Install chezmoi
if ! command -v chezmoi &>/dev/null; then
  sh -c "$(curl -fsLS get.chezmoi.io)"
fi

echo "Install packages for your distro, then: chezmoi init --apply <repo>"
