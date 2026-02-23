from pyinfra import host
from pyinfra.facts.server import Home, Kernel
from pyinfra.operations import brew, files, git


def setup(repo_path):
    home_path = host.get_fact(Home)

    # Install brew packages on macOS
    if host.get_fact(Kernel) == "Darwin":
        brew.packages(
            name="Install brew packages",
            packages=["bat", "fd", "fzf", "git-delta", "jq", "ripgrep"],
        )

        # Install casks
        brew.casks(
            name="Install casks",
            casks=["rectangle"],
        )

    # Create ~/code directory
    files.directory(
        name="Create ~/code directory",
        path=f"{home_path}/code",
        mode="0755",
    )

    # Clone dev-scripts repository
    git.repo(
        name="Clone dev-scripts repository",
        src="git@github.com:ec965/dev-scripts.git",
        dest=f"{home_path}/code/dev-scripts",
        pull=True,
    )
