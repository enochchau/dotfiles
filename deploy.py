"""Pyinfra deployment script for dotfiles."""

from pyinfra import host
from pyinfra.facts.files import Directory
from pyinfra.facts.server import Home

# Import roles
from roles.devtools import setup as devtools_setup
from roles.ghostty import setup as ghostty_setup
from roles.git import setup as git_setup
from roles.mise import setup as mise_setup
from roles.nvim import setup as nvim_setup
from roles.tmux import setup as tmux_setup
from roles.vscode import setup as vscode_setup
from roles.zsh import setup as zsh_setup

repo_path = f"{host.get_fact(Home)}/dotfiles"
home_path = host.get_fact(Home)

# Validate repository exists
if not host.get_fact(Directory, repo_path):
    raise RuntimeError(f"Repository not found at {repo_path}")

# Configuration
DEVTOOLS_PACKAGES = [
    "bat",
    "difftastic",
    "fd",
    "ffmpeg",
    "fzf",
    "git-delta",
    "jq",
    "mise",
    "neovim",
    "ripgrep",
    "tmux",
    "uv",
]
DEVTOOLS_CASKS = [
    "ghostty",
    "linearmouse",
    "rectangle",
]

# Git
git_setup(
    repo_path=repo_path,
    git_user="enochchau",
    git_email="enoch965@gmail.com",
)

# Devtools
devtools_setup(
    repo_path=repo_path,
    packages=DEVTOOLS_PACKAGES,
    casks=DEVTOOLS_CASKS,
)

# ZSH
zsh_setup(
    repo_path=repo_path,
)

# Tmux
tmux_setup(repo_path=repo_path)

# Neovim
nvim_setup(repo_path=repo_path)

# Mise
mise_setup(repo_path=repo_path)

# Ghostty
ghostty_setup(repo_path=repo_path)

# VSCode
vscode_setup(repo_path=repo_path)
