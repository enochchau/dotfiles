"""Custom fact to get the current user's shell on macOS."""

from pyinfra.api import FactBase


class UserShell(FactBase):
    """
    Returns the current user's shell path on macOS.

    Uses dscl to read the UserShell attribute from the system directory.
    Returns None if the command fails or produces no output.
    """

    command = "dscl . -read /Users/$(whoami) UserShell | cut -d' ' -f2"

    def process(self, output: list[str]) -> str | None:
        """
        Process the command output.

        Args:
            output: List of output lines from the command.

        Returns:
            The shell path if found, None otherwise.
        """
        if output and len(output) > 0:
            shell = output[0].strip()
            return shell if shell else None
        return None
