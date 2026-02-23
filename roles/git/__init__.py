"""Git role - configures git with user settings."""

from pyinfra import host
from pyinfra.facts.files import File
from pyinfra.facts.server import Home
from pyinfra.operations import server

from ..common import template_config_file


def setup(repo_path: str, git_user: str, git_email: str) -> None:
    """
    Set up Git configuration.

    Args:
        repo_path: Path to the dotfiles repository.
        git_user: Git username.
        git_email: Git email address.
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

    # Template gitconfig
    template_config_file(
        repo_path=repo_path,
        role_name="git",
        template_name="gitconfig",
        dest_path=gitconfig_path,
        git_user=git_user,
        git_email=git_email,
    )
