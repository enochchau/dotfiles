"""Mise role - installs and configures mise (version manager)."""

from pyinfra import host
from pyinfra.facts.server import Home
from pyinfra.operations import server

from ..common import ensure_config_directory, symlink_config_directory


def setup(repo_path: str) -> None:
    """
    Set up mise version manager.

    Args:
        repo_path: Path to the dotfiles repository.
    """
    # Create .config directory
    ensure_config_directory()

    # Symlink mise config directory
    symlink_config_directory(
        repo_path=repo_path,
        role_name="mise",
        dest_path=f"{host.get_fact(Home)}/.config/mise",
    )

    # Install mise shims/tools (macOS only)
    server.shell(
        name="Install mise tools",
        commands=["mise install"],
    )
