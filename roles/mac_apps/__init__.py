"""macOS desktop app installs via Homebrew casks."""

from ..common import install_brew_casks


def setup(casks: list[str]) -> None:
    """
    Install desktop applications on macOS.

    Args:
        casks: List of Homebrew cask names.
    """
    install_brew_casks(casks=casks, name="Install macOS desktop apps")
