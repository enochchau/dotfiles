from pyinfra import host
from pyinfra.facts.server import Hostname
from pyinfra.operations import brew
from pyinfra.operations import files
import os

repo_path = os.path.expanduser("~/dotfiles/pyinfra-dots")
home_path = os.path.expanduser("~")

# Import roles
from roles.git import setup as git_setup
from roles.zsh import setup as zsh_setup

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

# Devtools
brew.packages(
    packages=[
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
        "uv",
    ]
)

# Mac apps
brew.casks(casks=["ghostty", "linearmouse", "rectangle"])
