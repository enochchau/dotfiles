#!/bin/bash
set -euo pipefail

echo "=== macOS Bootstrap ==="

# Xcode Command Line Tools
xcode-select --install 2>/dev/null || true

# Homebrew
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
brew bundle --file="$SCRIPT_DIR/Brewfile"

# dev-scripts
mkdir -p ~/code
if [ ! -d ~/code/dev-scripts ]; then
  git clone git@github.com:ec965/dev-scripts.git ~/code/dev-scripts
fi

echo "Done. Run: chezmoi init --apply <repo>"
