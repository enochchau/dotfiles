#!/bin/bash
set -euo pipefail

echo "=== NixOS Bootstrap ==="

# chezmoi should be in configuration.nix
if ! command -v chezmoi &>/dev/null; then
  echo "Add 'chezmoi' to configuration.nix packages, then nixos-rebuild switch"
  exit 1
fi

echo "Done. Run: chezmoi init --apply <repo>"
