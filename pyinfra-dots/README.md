# pyinfra-dots

Pyinfra-based dotfiles deployment for macOS.

## Overview

This project uses [pyinfra](https://pyinfra.com/) to manage and deploy dotfiles. It provides an idempotent, Python-based alternative to Ansible for configuring your development environment.

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
pyinfra-dots/
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
| `git` | Backs up and templates `.gitconfig` |
| `zsh` | Configures zsh, installs Antidote plugin manager |
| `tmux` | Installs tmux and symlinks config |
| `nvim` | Installs Neovim and symlinks config directory |
| `mise` | Installs mise and tools |
| `devtools` | Installs common dev tools via Homebrew |
| `ghostty` | Installs Ghostty terminal |
| `vscode` | Symlinks VS Code settings (macOS only) |

## Development

```bash
# Run all checks before committing
make check

# Deploy changes
make run
```

## License

MIT
