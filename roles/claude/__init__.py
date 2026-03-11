"""claude code config"""

from pyinfra import host
from pyinfra.facts.server import Home

from ..common import symlink_config_file


def setup(repo_path: str) -> None:
    """
    Symlink claude settings

    Args:
        repo_path: Path to dotfiles repo
    """

    home_path = host.get_fact(Home)

    symlink_config_file(
        repo_path=repo_path,
        role_name="claude",
        filename="settings.json",
        dest_path=f"{home_path}/.claude/settings.json",
        name="Link settings.json"
    )

    symlink_config_file(
        repo_path=repo_path,
        role_name="claude",
        filename="CLAUDE.md",
        dest_path=f"{home_path}/.claude/CLAUDE.md",
        name="Link CLAUDE.md"
    )

    symlink_config_file(
        repo_path=repo_path,
        role_name="claude",
        filename="statusline-command.sh",
        dest_path=f"{home_path}/.claude/statusline-command.sh",
        name="Link statusline-command.sh"
    )
