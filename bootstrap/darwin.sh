#!/bin/bash
set -euo pipefail

echo "=== macOS Bootstrap ==="

# Xcode Command Line Tools
xcode-select --install 2>/dev/null || true

# Homebrew
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Packages
brew install bat difftastic fd ffmpeg fzf git-delta jq mise neovim ripgrep tmux uv chezmoi

# Casks
brew install --cask ghostty linearmouse rectangle

# dev-scripts
mkdir -p ~/code
if [ ! -d ~/code/dev-scripts ]; then
  git clone git@github.com:ec965/dev-scripts.git ~/code/dev-scripts
fi

echo "Done. Run: chezmoi init --apply <repo>"
