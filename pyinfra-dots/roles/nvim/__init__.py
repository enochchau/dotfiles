from pyinfra import host
from pyinfra.operations import brew, files
from pyinfra.facts.server import Kernel


def setup(repo_path):
    # Install neovim on macOS
    if host.get_fact(Kernel) == "Darwin":
        brew.packages(
            name="Install neovim",
            packages=["neovim"],
        )

    # Create .config directory
    files.directory(
        name="Create .config directory",
        path="~/.config",
        mode="0755",
    )

    # Symlink nvim config directory
    files.link(
        name="Symlink nvim config",
        path="~/.config/nvim",
        target=f"{repo_path}/roles/nvim/files",
        force=True,
    )
