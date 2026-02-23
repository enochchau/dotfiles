"""Common utilities for pyinfra roles."""

from pyinfra import host
from pyinfra.facts.server import Home, Kernel
from pyinfra.operations import brew, files

from .constants import DIR_CONFIG, MODE_DIRECTORY


def ensure_config_directory(
    home_path: str | None = None,
    subdirs: list[str] | None = None,
) -> None:
    """
    Ensure the .config directory exists, optionally with subdirectories.

    Args:
        home_path: Home directory path. Uses host.get_fact(Home) if not provided.
        subdirs: Optional list of subdirectories to create under .config.
    """
    if home_path is None:
        home_path = host.get_fact(Home)

    config_path = f"{home_path}/{DIR_CONFIG}"
    files.directory(
        name=f"Create {DIR_CONFIG} directory",
        path=config_path,
        mode=MODE_DIRECTORY,
    )

    if subdirs:
        for subdir in subdirs:
            subdir_path = f"{config_path}/{subdir}"
            files.directory(
                name=f"Create {DIR_CONFIG}/{subdir} directory",
                path=subdir_path,
                mode=MODE_DIRECTORY,
            )


def install_brew_packages(packages: list[str], name: str | None = None) -> None:
    """
    Install Homebrew packages on macOS.

    Args:
        packages: List of package names to install.
        name: Optional custom name for the operation.
    """
    if host.get_fact(Kernel) != "Darwin":
        return

    brew.packages(
        name=name or "Install brew packages",
        packages=packages,
    )


def install_brew_casks(casks: list[str], name: str | None = None) -> None:
    """
    Install Homebrew casks on macOS.

    Args:
        casks: List of cask names to install.
        name: Optional custom name for the operation.
    """
    if host.get_fact(Kernel) != "Darwin":
        return

    brew.casks(
        name=name or "Install brew casks",
        casks=casks,
    )


def symlink_config_file(
    repo_path: str,
    role_name: str,
    filename: str,
    dest_path: str,
    name: str | None = None,
) -> None:
    """
    Create a symbolic link for a config file from role files directory.

    Args:
        repo_path: Path to the dotfiles repository.
        role_name: Name of the role (directory under roles/).
        filename: Name of the file in the role's files directory.
        dest_path: Destination path for the symlink.
        name: Optional custom name for the operation.
    """
    source_path = f"{repo_path}/roles/{role_name}/files/{filename}"
    files.link(
        name=name or f"Link {filename}",
        path=dest_path,
        target=source_path,
        force=True,
    )


def symlink_config_directory(
    repo_path: str,
    role_name: str,
    dest_path: str,
    name: str | None = None,
) -> None:
    """
    Create a symbolic link for a config directory from role files directory.

    Args:
        repo_path: Path to the dotfiles repository.
        role_name: Name of the role (directory under roles/).
        dest_path: Destination path for the symlink.
        name: Optional custom name for the operation.
    """
    source_path = f"{repo_path}/roles/{role_name}/files"
    files.link(
        name=name or f"Link {role_name} config",
        path=dest_path,
        target=source_path,
        force=True,
    )


def template_config_file(
    repo_path: str,
    role_name: str,
    template_name: str,
    dest_path: str,
    **template_vars,
) -> None:
    """
    Render a template file to the config destination.

    Args:
        repo_path: Path to the dotfiles repository.
        role_name: Name of the role (directory under roles/).
        template_name: Name of the template file (without .j2 extension).
        dest_path: Destination path for the rendered template.
        **template_vars: Variables to pass to the Jinja2 template.
    """
    source_path = f"{repo_path}/roles/{role_name}/templates/{template_name}.j2"
    files.template(
        name=f"Update {template_name}",
        src=source_path,
        dest=dest_path,
        mode="0644",
        **template_vars,
    )


def clone_repo(
    repo_url: str,
    dest_path: str,
    name: str | None = None,
    branch: str = "HEAD",
    pull: bool = True,
) -> None:
    """
    Clone or update a git repository.

    Args:
        repo_url: Git repository URL.
        dest_path: Destination path for the repository.
        name: Optional custom name for the operation.
        branch: Branch to checkout. Defaults to HEAD.
        pull: Whether to pull updates if repo exists. Defaults to True.
    """
    from pyinfra.operations import git

    git.repo(
        name=name or f"Clone {repo_url}",
        src=repo_url,
        dest=dest_path,
        branch=branch,
        pull=pull,
    )
