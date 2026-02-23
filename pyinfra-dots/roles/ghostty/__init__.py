from pyinfra import host
from pyinfra.operations import brew, files
from pyinfra.facts.server import Kernel


def setup(repo_path):
    # Install ghostty on macOS
    if host.get_fact(Kernel) == "Darwin":
        brew.casks(
            name="Install ghostty",
            casks=["ghostty"],
        )

    # Create .config directory
    files.directory(
        name="Create .config directory",
        path="~/.config",
        mode="0755",
    )

    # Symlink ghostty config directory
    files.link(
        name="Symlink ghostty config",
        path="~/.config/ghostty",
        target=f"{repo_path}/roles/ghostty/files",
        force=True,
    )
