"""VSCode role - configures Visual Studio Code settings (macOS only)."""

from pyinfra import host
from pyinfra.facts.server import Home, Kernel

from ..common import ensure_config_directory, symlink_config_file


def setup(repo_path: str) -> None:
    """
    Set up VS Code settings (macOS only).

    Args:
        repo_path: Path to the dotfiles repository.
    """
    # macOS only
    if host.get_fact(Kernel) != "Darwin":
        return

    home_path = host.get_fact(Home)
    vscode_path = f"{home_path}/Library/Application Support/Code/User"

    # Create VSCode settings directory
    ensure_config_directory()

    # Link VSCode settings files
    for item in ["settings.json", "keybindings.json"]:
        symlink_config_file(
            repo_path=repo_path,
            role_name="vscode",
            filename=item,
            dest_path=f"{vscode_path}/{item}",
            name=f"Link VSCode {item}",
        )
