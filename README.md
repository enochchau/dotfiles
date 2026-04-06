# pyinfra-dots

Pyinfra-based dotfiles deployment for macOS and NixOS.

## Overview

This project uses [pyinfra](https://pyinfra.com/) to manage and deploy dotfiles. It provides an idempotent, Python-based alternative to Ansible for configuring your development environment.

The deploy aims to manage your user environment imperatively on both macOS and NixOS. The role layout is split into `base`, `workstation`, `desktop`, and `mac_apps`, with NixOS taking the smaller base-only path and macOS using the fuller workstation/desktop setup.

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

On NixOS, `make run` applies the base config set only: Git, Zsh, tmux, and Neovim. Tooling and desktop applications should be installed through Nix.

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
│   ├── system_id.py       # Detect Linux distribution ID
│   └── user_shell.py      # Get current user's shell on macOS
├── roles/                 # Role definitions
│   ├── claude/            # Claude Code configuration
│   ├── devtools/          # Dev tools (bat, fd, fzf, etc.)
│   ├── ghostty/           # Ghostty terminal
│   ├── git/               # Git configuration
│   ├── mac_apps/          # macOS desktop app installs
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
| `tmux` | Symlinks tmux config |
| `nvim` | Symlinks Neovim config directory |
| `devtools` | Installs common dev tools on macOS and clones `dev-scripts` |
| `mise` | Configures mise on macOS |
| `ghostty` | Symlinks Ghostty config |
| `vscode` | Symlinks VS Code settings on macOS and Linux |
| `claude` | Symlinks Claude Code config |
| `mac_apps` | Installs macOS desktop apps via Homebrew casks |

## Role Groups

- `base`: `git`, `zsh`, `tmux`, `nvim`
- `workstation`: `devtools`, `mise`
- `desktop`: `ghostty`, `vscode`, `claude`
- `mac_apps`: Homebrew casks such as `ghostty`, `linearmouse`, and `rectangle`

## NixOS Behavior

On NixOS, the deploy keeps only the base, server-safe config roles:

- Configure Git
- Configure Zsh and clone Antidote
- Configure tmux
- Configure Neovim

On NixOS, application and runtime installs should live in `configuration.nix`, so the deploy skips:

- `workstation`
- `desktop`
- `mac_apps`
- macOS-only shell changes like `chsh`

At minimum, install your shell/editor dependencies through Nix. In practice that likely includes `git`, `zsh`, `tmux`, `neovim`, `fzf`, `ripgrep`, `fd`, and `uv`.

## Development

```bash
# Run all checks before committing
make check

# Deploy changes
make run
```

## License

MIT
