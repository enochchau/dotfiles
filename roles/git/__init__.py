"""Git role - configures git settings."""

from pyinfra import host
from pyinfra.facts.files import File
from pyinfra.facts.server import Home
from pyinfra.operations import server

from ..common import symlink_config_file


def setup(repo_path: str) -> None:
    """
    Set up Git configuration.

    Args:
        repo_path: Path to the dotfiles repository.
    """
    home_path = host.get_fact(Home)
    gitconfig_path = f"{home_path}/.gitconfig"
    backup_path = f"{home_path}/.gitconfig.bak"

    # Check if gitconfig exists using pyinfra facts
    existing_gitconfig = host.get_fact(File, gitconfig_path)

    # Backup existing gitconfig if it exists
    if existing_gitconfig:
        server.shell(
            name="Backup existing gitconfig",
            commands=[f"mv {gitconfig_path} {backup_path}"],
        )

    # Symlink gitconfig from the repository.
    symlink_config_file(
        repo_path=repo_path,
        role_name="git",
        filename="dot.gitconfig",
        dest_path=gitconfig_path,
        name="Link gitconfig",
    )
