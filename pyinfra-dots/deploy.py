import os

# Import roles
from roles.devtools import setup as devtools_setup
from roles.ghostty import setup as ghostty_setup
from roles.git import setup as git_setup
from roles.mise import setup as mise_setup
from roles.nvim import setup as nvim_setup
from roles.tmux import setup as tmux_setup
from roles.vscode import setup as vscode_setup
from roles.zsh import setup as zsh_setup

repo_path = os.path.expanduser("~/dotfiles/pyinfra-dots")
home_path = os.path.expanduser("~")

# Git
git_setup(
    repo_path=repo_path,
    git_user="enochchau",
    git_email="enoch965@gmail.com",
)

# ZSH
zsh_setup(
    home_path=home_path,
    repo_path=repo_path,
)

# Tmux
tmux_setup(repo_path=repo_path)

# Neovim
nvim_setup(repo_path=repo_path)

# Mise
mise_setup(repo_path=repo_path)

# Devtools
devtools_setup(repo_path=repo_path)

# Ghostty
ghostty_setup(repo_path=repo_path)

# VSCode
vscode_setup(repo_path=repo_path)
