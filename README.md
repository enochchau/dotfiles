# pyinfra-dots

Pyinfra-based dotfiles deployment for macOS and NixOS.

## Overview

This project uses [pyinfra](https://pyinfra.com/) to manage and deploy dotfiles. It provides an idempotent, Python-based alternative to Ansible for configuring your development environment.

On macOS, the repo can also handle a few imperative setup steps. On NixOS, it automatically switches to a symlink-only mode so package management stays in Nix.

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

On NixOS, `make run` auto-detects the platform and only links checked-in files.

If you want to force that behavior on another machine, run:

```bash
make run-symlink-only
```

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

On NixOS, the deploy still auto-detects the platform and stays in symlink-only mode.

## Available Commands

| Command | Description |
|---------|-------------|
| `make run` | Deploy dotfiles with pyinfra |
| `make run-symlink-only` | Deploy dotfiles in symlink-only mode |
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
| `mise` | Symlinks mise config and optionally installs tools |
| `devtools` | Installs common dev tools via Homebrew |
| `ghostty` | Installs Ghostty terminal |
| `vscode` | Symlinks VS Code settings on macOS and Linux |

## NixOS Behavior

When the host OS is detected as NixOS, the deploy keeps only repository-managed file links and skips imperative setup.

Skipped on NixOS:

- Homebrew package installs and casks
- Cloning `dev-scripts`
- Cloning Antidote
- Running `mise install`
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
