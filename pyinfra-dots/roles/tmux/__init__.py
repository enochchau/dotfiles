from pyinfra import host
from pyinfra.operations import brew, files
from pyinfra.facts.server import Kernel


def setup(repo_path):
    # Install tmux on macOS
    if host.get_fact(Kernel) == "Darwin":
        brew.packages(
            name="Install tmux",
            packages=["tmux"],
        )

    # Create .config directory
    files.directory(
        name="Create .config/tmux directory",
        path="~/.config/tmux",
        mode="0755",
    )

    # Symlink tmux.conf
    files.link(
        name="Symlink tmux.conf",
        path="~/.config/tmux/tmux.conf",
        target=f"{repo_path}/roles/tmux/files/tmux.conf",
        force=True,
    )
