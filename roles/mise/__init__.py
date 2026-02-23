from pyinfra import host
from pyinfra.facts.server import Home, Kernel
from pyinfra.operations import brew, files, server


def setup(repo_path):
    home_path = host.get_fact(Home)

    # Install mise on macOS
    if host.get_fact(Kernel) == "Darwin":
        brew.packages(
            name="Install mise",
            packages=["mise"],
        )

    # Create .config directory
    files.directory(
        name="Create .config directory",
        path=f"{home_path}/.config",
        mode="0755",
    )

    # Symlink mise config directory
    files.link(
        name="Symlink mise config",
        path=f"{home_path}/.config/mise",
        target=f"{repo_path}/roles/mise/files",
        force=True,
    )

    # Install mise shims/tools (macOS only)
    if host.get_fact(Kernel) == "Darwin":
        server.shell(
            name="Install mise tools",
            commands=["mise install"],
        )
