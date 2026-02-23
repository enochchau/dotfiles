"""Ghostty role - installs and configures Ghostty terminal."""

from pyinfra import host
from pyinfra.facts.server import Home

from ..common import ensure_config_directory, symlink_config_directory


def setup(repo_path: str) -> None:
    """
    Set up Ghostty terminal.

    Args:
        repo_path: Path to the dotfiles repository.
    """
    # Create .config directory
    ensure_config_directory()

    # Symlink ghostty config directory
    symlink_config_directory(
        repo_path=repo_path,
        role_name="ghostty",
        dest_path=f"{host.get_fact(Home)}/.config/ghostty",
    )
