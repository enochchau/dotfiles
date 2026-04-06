# pyinfra-dots

Pyinfra-based dotfiles deployment for macOS and NixOS.

## Overview

This project uses [pyinfra](https://pyinfra.com/) to manage and deploy dotfiles. It provides an idempotent, Python-based alternative to Ansible for configuring your development environment.

The deploy aims to manage your user environment imperatively on both macOS and NixOS. Platform-specific steps still stay platform-specific, so macOS handles Homebrew and `chsh`, while NixOS runs the shared user-level setup.

## Requirements

- Python 3.13+
- [uv](https://docs.astral.sh/uv/) for dependency management

## Quick Start

```bash
# Install dependencies
uv sync

# Run deployment
make run
```

On NixOS, `make run` performs the shared user-level deploy flow where it makes sense: it links checked-in files and clones repositories, while leaving application and runtime installation to Nix.

## Nix Flake

This repo also includes a `flake.nix` so a NixOS machine can bootstrap the runner without manually installing `uv` first.

Enable flakes in `/etc/nixos/configuration.nix`:

```nix
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
```

Then apply it:

```bash
sudo nixos-rebuild switch
```

From the dotfiles checkout, you can then use either flow:

```bash
# Enter a shell with uv, Python, and make
nix develop
uv sync --no-dev
make run
```

```bash
# Or run the deploy directly via the flake app
nix run .#run
```

On NixOS, the deploy auto-detects the platform and follows the NixOS branch directly instead of going through a separate deploy mode.

The flake also exports the Linux C++ runtime needed by Python wheels like `gevent` and `greenlet`, which avoids `libstdc++.so.6` errors when running `pyinfra` on NixOS.

## Available Commands

| Command | Description |
|---------|-------------|
| `make run` | Deploy dotfiles with pyinfra |
| `make lint` | Check code with ruff |
| `make format` | Format code with ruff |
| `make typecheck` | Type check with ty |
| `make check` | Run all checks (lint + format + typecheck) |

## Structure

```
dotfiles/
├── deploy.py              # Main entry point
├── facts/                 # Custom facts
│   └── user_shell.py      # Get current user's shell on macOS
├── roles/                 # Role definitions
│   ├── devtools/          # Dev tools (bat, fd, fzf, etc.)
│   ├── ghostty/           # Ghostty terminal
│   ├── git/               # Git configuration
│   ├── mise/              # Mise (formerly rtx)
│   ├── nvim/              # Neovim configuration
│   ├── tmux/              # Tmux configuration
│   ├── vscode/            # VS Code settings
│   └── zsh/               # Zsh configuration
└── MIGRATION.md           # Ansible → pyinfra migration guide
```

## Roles

| Role | Description |
|------|-------------|
| `git` | Backs up and symlinks `.gitconfig` |
| `zsh` | Configures zsh and symlinks platform-specific shell files |
| `tmux` | Installs tmux and symlinks config |
| `nvim` | Installs Neovim and symlinks config directory |
| `mise` | Configures mise on macOS |
| `devtools` | Installs common dev tools via Homebrew |
| `ghostty` | Installs Ghostty terminal |
| `vscode` | Symlinks VS Code settings on macOS and Linux |

## NixOS Behavior

By default, NixOS now follows the same imperative user-level flow as macOS for shared setup:

- Symlink checked-in config files
- Clone Antidote for Zsh plugins
- Create `~/code` and clone `dev-scripts`

On NixOS, application and runtime installs should live in `configuration.nix`, so the deploy skips:

- `mise` config and `mise install`
- Homebrew package installs and casks
- Changing the login shell with `chsh`

## Development

```bash
# Run all checks before committing
make check

# Deploy changes
make run
```

## License

MIT
