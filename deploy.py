"""Pyinfra deployment script for dotfiles."""

from pyinfra import host
from pyinfra.facts.files import Directory
from pyinfra.facts.server import Home, Kernel

from facts.system_id import SystemId
from roles.claude import setup as claude_setup
from roles.constants import KERNEL_DARWIN, KERNEL_LINUX

# Import roles
from roles.devtools import setup as devtools_setup
from roles.ghostty import setup as ghostty_setup
from roles.git import setup as git_setup
from roles.mac_apps import setup as mac_apps_setup
from roles.mise import setup as mise_setup
from roles.nvim import setup as nvim_setup
from roles.tmux import setup as tmux_setup
from roles.vscode import setup as vscode_setup
from roles.zsh import setup as zsh_setup

repo_path = f"{host.get_fact(Home)}/dotfiles"

# Validate repository exists
if not host.get_fact(Directory, repo_path):
    raise RuntimeError(f"Repository not found at {repo_path}")

kernel = host.get_fact(Kernel)
is_nixos = kernel == KERNEL_LINUX and host.get_fact(SystemId) == "nixos"

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
MAC_APP_CASKS = ["ghostty", "linearmouse", "rectangle"]


def run_base_roles() -> None:
    """Run shell/editor roles shared by all machine types."""
    git_setup(repo_path=repo_path)
    zsh_setup(repo_path=repo_path)
    tmux_setup(repo_path=repo_path)
    nvim_setup(repo_path=repo_path)


def run_workstation_roles() -> None:
    """Run non-GUI workstation roles."""
    devtools_setup(
        repo_path=repo_path,
        packages=DEVTOOLS_PACKAGES,
    )

    if kernel == KERNEL_DARWIN:
        mise_setup(repo_path=repo_path)


def run_desktop_roles() -> None:
    """Run desktop-only config roles."""
    ghostty_setup(repo_path=repo_path)
    vscode_setup(repo_path=repo_path)
    claude_setup(repo_path=repo_path)


def run_mac_apps() -> None:
    """Run macOS desktop app installs."""
    mac_apps_setup(casks=MAC_APP_CASKS)


run_base_roles()

if not is_nixos:
    run_workstation_roles()
    run_desktop_roles()

    if kernel == KERNEL_DARWIN:
        run_mac_apps()
