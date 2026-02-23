from pyinfra import host
from pyinfra.operations import brew, files, server
from pyinfra.facts.server import Kernel


def setup(repo_path):
    # Install mise on macOS
    if host.get_fact(Kernel) == "Darwin":
        brew.packages(
            name="Install mise",
            packages=["mise"],
        )

    # Create .config directory
    files.directory(
        name="Create .config directory",
        path="~/.config",
        mode="0755",
    )

    # Symlink mise config directory
    files.link(
        name="Symlink mise config",
        path="~/.config/mise",
        target=f"{repo_path}/roles/mise/files",
        force=True,
    )

    # Install mise shims/tools
    server.shell(
        name="Install mise tools",
        commands=["mise install"],
    )
