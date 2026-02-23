"""Zsh role - configures zsh shell and antidote plugin manager."""

from pyinfra import host
from pyinfra.facts.server import Home
from pyinfra.operations import files, server

from facts.user_shell import UserShell

from ..common import clone_repo, symlink_config_file
from ..constants import SHELL_ZSH


def setup(repo_path: str) -> None:
    """
    Set up zsh shell with antidote plugin manager.

    Args:
        repo_path: Path to the dotfiles repository.
    """
    home_path = host.get_fact(Home)
    zdotdir = f"{home_path}/.config/zsh"

    # Create ZDOTDIR
    files.directory(
        name="Create ZDOTDIR",
        path=zdotdir,
        mode="0755",
    )

    # Link home zshenv
    symlink_config_file(
        repo_path=repo_path,
        role_name="zsh",
        filename="home.zshenv",
        dest_path=f"{home_path}/.zshenv",
        name="Link home zshenv",
    )

    # Link zdotdir zshenv
    symlink_config_file(
        repo_path=repo_path,
        role_name="zsh",
        filename="dot.zshenv",
        dest_path=f"{zdotdir}/.zshenv",
        name="Link zdotdir zshenv",
    )

    # Link zshrc
    symlink_config_file(
        repo_path=repo_path,
        role_name="zsh",
        filename="dot.zshrc",
        dest_path=f"{zdotdir}/.zshrc",
        name="Link zshrc",
    )

    # Install Antidote
    clone_repo(
        repo_url="https://github.com/mattmc3/antidote.git",
        dest_path=f"{zdotdir}/antidote",
        name="Install Antidote",
    )

    # Link zsh-plugins.txt
    symlink_config_file(
        repo_path=repo_path,
        role_name="zsh",
        filename="dot.zsh_plugins.txt",
        dest_path=f"{zdotdir}/.zsh_plugins.txt",
        name="Link zsh-plugins.txt",
    )

    # Change user shell to zsh (if not already)
    current_shell = host.get_fact(UserShell)

    if current_shell != SHELL_ZSH:
        server.shell(
            name="Change user shell to zsh",
            commands=["chsh -s /bin/zsh"],
            _sudo=True,
        )

    # Link MacMachine.zshrc
    symlink_config_file(
        repo_path=repo_path,
        role_name="zsh",
        filename="macmachine.zsh",
        dest_path=f"{zdotdir}/machine.zsh",
        name="Link MacMachine.zshrc",
    )
