"""Neovim role - installs and configures Neovim."""

from pyinfra import host
from pyinfra.facts.server import Home

from ..common import (
    ensure_config_directory,
    install_brew_packages,
    symlink_config_directory,
)


def setup(repo_path: str) -> None:
    """
    Set up Neovim.

    Args:
        repo_path: Path to the dotfiles repository.
    """
    # Install neovim on macOS
    install_brew_packages(packages=["neovim"])

    # Create .config directory
    ensure_config_directory()

    # Symlink nvim config directory
    symlink_config_directory(
        repo_path=repo_path,
        role_name="nvim",
        dest_path=f"{host.get_fact(Home)}/.config/nvim",
    )
