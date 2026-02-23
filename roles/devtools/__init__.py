"""Devtools role - installs common development tools."""

from pyinfra import host
from pyinfra.facts.server import Home
from pyinfra.operations import files

from ..common import clone_repo, install_brew_casks, install_brew_packages


def setup(repo_path: str, packages: list[str], casks: list[str]) -> None:
    """
    Set up development tools.

    Args:
        repo_path: Path to the dotfiles repository.
        packages: List of Homebrew packages to install.
        casks: List of Homebrew casks to install.
    """
    home_path = host.get_fact(Home)

    # Install brew packages and casks on macOS
    install_brew_packages(packages=packages)
    install_brew_casks(casks=casks)

    # Create ~/code directory
    files.directory(
        name="Create ~/code directory",
        path=f"{home_path}/code",
        mode="0755",
    )

    # Clone dev-scripts repository
    clone_repo(
        repo_url="git@github.com:ec965/dev-scripts.git",
        dest_path=f"{home_path}/code/dev-scripts",
        name="Clone dev-scripts repository",
    )
