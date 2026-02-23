from pyinfra import host
from pyinfra.operations import files
from pyinfra.facts.server import Kernel


def setup(repo_path):
    # macOS only
    if host.get_fact(Kernel) != "Darwin":
        return

    # Create VSCode settings directory
    files.directory(
        name="Create VSCode settings directory",
        path="~/Library/Application Support/Code/User",
        mode="0755",
    )

    # Link VSCode settings files
    for item in ["settings.json", "keybindings.json"]:
        files.link(
            name=f"Link VSCode {item}",
            path=f"~/Library/Application Support/Code/User/{item}",
            target=f"{repo_path}/roles/vscode/files/{item}",
            force=True,
        )
