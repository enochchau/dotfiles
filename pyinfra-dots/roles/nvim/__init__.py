from pyinfra import host
from pyinfra.facts.server import Home, Kernel
from pyinfra.operations import brew, files


def setup(repo_path):
    home_path = host.get_fact(Home)

    # Install neovim on macOS
    if host.get_fact(Kernel) == "Darwin":
        brew.packages(
            name="Install neovim",
            packages=["neovim"],
        )

    # Create .config directory
    files.directory(
        name="Create .config directory",
        path=f"{home_path}/.config",
        mode="0755",
    )

    # Symlink nvim config directory
    files.link(
        name="Symlink nvim config",
        path=f"{home_path}/.config/nvim",
        target=f"{repo_path}/roles/nvim/files",
        force=True,
    )
