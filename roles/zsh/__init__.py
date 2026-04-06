"""Zsh role - configures zsh shell and antidote plugin manager."""

from pyinfra import host
from pyinfra.facts.server import Home, Kernel
from pyinfra.operations import files, server

from facts.user_shell import UserShell

from ..common import clone_repo, symlink_config_file
from ..constants import KERNEL_DARWIN, SHELL_ZSH


def setup(repo_path: str) -> None:
    """
    Set up zsh shell with antidote plugin manager.

    Args:
        repo_path: Path to the dotfiles repository.
    """
    home_path = host.get_fact(Home)
    zdotdir = f"{home_path}/.config/zsh"
    kernel = host.get_fact(Kernel)

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

    # Antidote is required by .zshrc.
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

    if kernel == KERNEL_DARWIN:
        # Change user shell to zsh on macOS if needed.
        current_shell = host.get_fact(UserShell)

        if current_shell != SHELL_ZSH:
            server.shell(
                name="Change user shell to zsh",
                commands=["chsh -s /bin/zsh"],
                _sudo=True,
            )

    machine_file = "macmachine.zsh" if kernel == KERNEL_DARWIN else "linuxmachine.zsh"

    symlink_config_file(
        repo_path=repo_path,
        role_name="zsh",
        filename=machine_file,
        dest_path=f"{zdotdir}/machine.zsh",
        name="Link machine.zsh",
    )
