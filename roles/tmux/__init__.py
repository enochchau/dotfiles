"""Tmux role - installs and configures tmux."""

from pyinfra import host
from pyinfra.facts.server import Home

from ..common import ensure_config_directory, symlink_config_file


def setup(repo_path: str) -> None:
    """
    Set up tmux.

    Args:
        repo_path: Path to the dotfiles repository.
    """
    # Create .config/tmux directory
    ensure_config_directory(subdirs=["tmux"])

    # Symlink tmux.conf
    symlink_config_file(
        repo_path=repo_path,
        role_name="tmux",
        filename="tmux.conf",
        dest_path=f"{host.get_fact(Home)}/.config/tmux/tmux.conf",
    )
