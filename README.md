# dotfiles

Dotfiles managed with [chezmoi](https://www.chezmoi.io/) for macOS, Linux, and NixOS.

## Quick Start

### New Machine

1. Run the bootstrap script for your system:

```bash
# macOS — installs Homebrew, packages, casks, chezmoi
./bootstrap/darwin.sh

# NixOS — checks chezmoi is in configuration.nix
./bootstrap/nixos.sh

# Other Linux — installs chezmoi
./bootstrap/linux.sh
```

2. Initialize and apply:

```bash
chezmoi init --apply -s ~/dotfiles git@github.com:ec965/dotfiles.git
```

### Existing Machine

```bash
chezmoi update
```

## Day-to-Day Workflow

Edit files in place, then pull changes back into the source:

```bash
# Re-add all changed files
chezmoi re-add

# Or a single file
chezmoi re-add ~/.config/nvim/init.lua

# Commit from the source directory
cd ~/.local/share/chezmoi
git add -A && git commit
```

Or edit from the source side:

```bash
chezmoi edit ~/.config/nvim/init.lua
chezmoi apply
```

Add a new file:

```bash
chezmoi add ~/.config/foo/bar.toml
```

## Structure

```
dotfiles/
├── .chezmoi.toml.tmpl         # Auto-detected OS data (darwin/nixos/linux)
├── .chezmoiexternal.toml      # External git repos (antidote)
├── .chezmoiignore             # OS-conditional file exclusion
├── .chezmoiscripts/           # Run scripts (chsh, mise install, etc.)
├── bootstrap/                 # Per-system bootstrap scripts
│   ├── darwin.sh
│   ├── linux.sh
│   └── nixos.sh
├── dot_gitconfig
├── dot_zshenv
├── dot_config/
│   ├── zsh/                   # Zsh config (ZDOTDIR)
│   ├── tmux/
│   ├── nvim/
│   ├── ghostty/
│   ├── Code/User/             # VSCode settings
│   └── mise/
└── dot_claude/                # Claude Code config
```

## OS Behavior

|                         | macOS            | Linux | NixOS |
| ----------------------- | ---------------- | ----- | ----- |
| git, zsh, tmux, nvim    | yes              | yes   | yes   |
| ghostty, vscode, claude | yes              | yes   | no    |
| mise                    | yes              | yes   | no    |
| brew packages/casks     | bootstrap script | —     | —     |
| chsh                    | run script       | —     | —     |

On NixOS, only base configs are deployed. Tools and desktop apps should be managed through `configuration.nix`.

## Run Scripts

| Script         | Trigger            | What it does                      |
| -------------- | ------------------ | --------------------------------- |
| `setup-shell`  | Once               | `chsh -s /bin/zsh` on macOS       |
| `mise-install` | On config change   | Runs `mise install`               |
| `vscode-mac`   | On settings change | Copies VSCode files to macOS path |

## License

MIT
