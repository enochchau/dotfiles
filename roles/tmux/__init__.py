from pyinfra import host
from pyinfra.facts.server import Home, Kernel
from pyinfra.operations import brew, files


def setup(repo_path):
    home_path = host.get_fact(Home)

    # Install tmux on macOS
    if host.get_fact(Kernel) == "Darwin":
        brew.packages(
            name="Install tmux",
            packages=["tmux"],
        )

    # Create .config directory
    files.directory(
        name="Create .config/tmux directory",
        path=f"{home_path}/.config/tmux",
        mode="0755",
    )

    # Symlink tmux.conf
    files.link(
        name="Symlink tmux.conf",
        path=f"{home_path}/.config/tmux/tmux.conf",
        target=f"{repo_path}/roles/tmux/files/tmux.conf",
        force=True,
    )
