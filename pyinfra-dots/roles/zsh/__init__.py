from pyinfra import host
from pyinfra.operations import files, git, server
from pyinfra.facts.server import Home, User, Users


def setup(home_path, repo_path):
    zdotdir = f"{home_path}/.config/zsh"

    # Create ZDOTDIR
    files.directory(
        name="Create ZDOTDIR",
        path=zdotdir,
        mode="0755",
    )

    # Link home zshenv
    files.link(
        name="Link home zshenv",
        path=f"{home_path}/.zshenv",
        target=f"{repo_path}/roles/zsh/files/home.zshenv",
        force=True,
    )

    # Link zdotdir zshenv
    files.link(
        name="Link zdotdir zshenv",
        path=f"{zdotdir}/.zshenv",
        target=f"{repo_path}/roles/zsh/files/dot.zshenv",
        force=True,
    )

    # Link zshrc
    files.link(
        name="Link zshrc",
        path=f"{zdotdir}/.zshrc",
        target=f"{repo_path}/roles/zsh/files/dot.zshrc",
        force=True,
    )

    # Install Antidote
    git.repo(
        name="Install Antidote",
        src="https://github.com/mattmc3/antidote.git",
        dest=f"{zdotdir}/antidote",
        branch="HEAD",
        pull=True,
    )

    # Link zsh-plugins.txt
    files.link(
        name="Link zsh-plugins.txt",
        path=f"{zdotdir}/.zsh_plugins.txt",
        target=f"{repo_path}/roles/zsh/files/dot.zsh_plugins.txt",
        force=True,
    )

    # Change user shell to zsh (if not already)
    username = host.get_fact(User)
    users = host.get_fact(Users)
    current_shell = users.get(username, {}).get("shell")

    if current_shell != "/bin/zsh":
        server.shell(
            name="Change user shell to zsh",
            commands=["chsh -s /bin/zsh"],
            _sudo=True,
        )

    # Link MacMachine.zshrc
    files.link(
        name="Link MacMachine.zshrc",
        path=f"{zdotdir}/machine.zsh",
        target=f"{repo_path}/roles/zsh/files/macmachine.zsh",
        force=True,
    )

