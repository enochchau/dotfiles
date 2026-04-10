#!/bin/bash
set -euo pipefail

echo "=== macOS Bootstrap ==="

# Xcode Command Line Tools
xcode-select --install 2>/dev/null || true

# Homebrew
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

installed=$(brew list)

packages=(bat difftastic fd ffmpeg fzf git-delta jq mise neovim ripgrep tmux uv chezmoi)
casks=(ghostty linearmouse rectangle)

to_install=()
for pkg in "${packages[@]}"; do
  if ! echo "$installed" | grep -qx "$pkg"; then
    to_install+=("$pkg")
  fi
done
if [ ${#to_install[@]} -gt 0 ]; then
  brew install "${to_install[@]}"
fi

to_install=()
for cask in "${casks[@]}"; do
  if ! echo "$installed" | grep -qx "$cask"; then
    to_install+=("$cask")
  fi
done
if [ ${#to_install[@]} -gt 0 ]; then
  brew install --cask "${to_install[@]}" || true
fi

# dev-scripts
mkdir -p ~/code
if [ ! -d ~/code/dev-scripts ]; then
  git clone git@github.com:ec965/dev-scripts.git ~/code/dev-scripts
fi

echo "Done. Run: chezmoi init --apply <repo>"
