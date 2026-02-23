from pyinfra import host
from pyinfra.operations import brew, files, git
from pyinfra.facts.server import Kernel


def setup(repo_path):
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
        path="~/code",
        mode="0755",
    )

    # Clone dev-scripts repository
    git.repo(
        name="Clone dev-scripts repository",
        src="git@github.com:ec965/dev-scripts.git",
        dest="~/code/dev-scripts",
        pull=True,
    )
