from pyinfra import host
from pyinfra.operations import files, server
from pyinfra.facts.files import File
from pyinfra.facts.server import User


def setup(repo_path, git_user, git_email):
    gitconfig_path = "~/.gitconfig"
    backup_path = "~/.gitconfig.bak"

    # Check if gitconfig exists using pyinfra facts
    existing_gitconfig = host.get_fact(File, gitconfig_path)

    # Backup existing gitconfig if it exists
    if existing_gitconfig:
        server.shell(
            name="Backup existing gitconfig",
            commands=[f"mv {gitconfig_path} {backup_path}"],
        )

    # Template gitconfig
    files.template(
        name="Update gitconfig",
        src=f"{repo_path}/roles/git/templates/gitconfig.j2",
        dest=gitconfig_path,
        mode="0644",
        git_user=git_user,
        git_email=git_email,
    )
