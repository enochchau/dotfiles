"""VSCode role - configures Visual Studio Code settings."""

from pyinfra import host
from pyinfra.facts.server import Home, Kernel
from pyinfra.operations import files

from ..common import symlink_config_file
from ..constants import KERNEL_DARWIN, KERNEL_LINUX, MODE_DIRECTORY


def setup(repo_path: str) -> None:
    """
    Set up VS Code settings.

    Args:
        repo_path: Path to the dotfiles repository.
    """
    kernel = host.get_fact(Kernel)
    if kernel not in {KERNEL_DARWIN, KERNEL_LINUX}:
        return

    home_path = host.get_fact(Home)
    if kernel == KERNEL_DARWIN:
        vscode_path = f"{home_path}/Library/Application Support/Code/User"
    else:
        vscode_path = f"{home_path}/.config/Code/User"

    # Create VSCode settings directory at the platform-specific path.
    files.directory(
        name="Create VSCode settings directory",
        path=vscode_path,
        mode=MODE_DIRECTORY,
    )

    # Link VSCode settings files
    for item in ["settings.json", "keybindings.json"]:
        symlink_config_file(
            repo_path=repo_path,
            role_name="vscode",
            filename=item,
            dest_path=f"{vscode_path}/{item}",
            name=f"Link VSCode {item}",
        )
