"""claude code config"""

from pyinfra import host
from pyinfra.facts.server import Home
from pyinfra.operations import files

from ..common import symlink_config_file


def setup(repo_path: str) -> None:
    """
    Symlink claude settings

    Args:
        repo_path: Path to dotfiles repo
    """

    home_path = host.get_fact(Home)
    role_files = f"{repo_path}/roles/claude/files"

    symlink_config_file(
        repo_path=repo_path,
        role_name="claude",
        filename="settings.json",
        dest_path=f"{home_path}/.claude/settings.json",
        name="Link settings.json",
    )

    symlink_config_file(
        repo_path=repo_path,
        role_name="claude",
        filename="CLAUDE.md",
        dest_path=f"{home_path}/.claude/CLAUDE.md",
        name="Link CLAUDE.md",
    )

    files.link(
        name="Link scripts directory",
        path=f"{home_path}/.claude/scripts",
        target=f"{role_files}/scripts",
        force=True,
    )

    symlink_config_file(
        repo_path=repo_path,
        role_name="claude",
        filename="SOUL.md",
        dest_path=f"{home_path}/.claude/SOUL.md",
        name="Link SOUL.md",
    )
