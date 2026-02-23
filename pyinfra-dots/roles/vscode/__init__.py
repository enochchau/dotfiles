from pyinfra import host
from pyinfra.operations import files
from pyinfra.facts.server import Kernel, Home


def setup(repo_path):
    home_path = host.get_fact(Home)

    # macOS only
    if host.get_fact(Kernel) != "Darwin":
        return

    # Create VSCode settings directory
    files.directory(
        name="Create VSCode settings directory",
        path=f"{home_path}/Library/Application Support/Code/User",
        mode="0755",
    )

    # Link VSCode settings files
    for item in ["settings.json", "keybindings.json"]:
        files.link(
            name=f"Link VSCode {item}",
            path=f"{home_path}/Library/Application Support/Code/User/{item}",
            target=f"{repo_path}/roles/vscode/files/{item}",
            force=True,
        )
