"""Custom fact to read the OS identifier from /etc/os-release."""

from pyinfra.api import FactBase


class SystemId(FactBase):
    """
    Returns the Linux distribution ID from /etc/os-release.

    Returns None if the file is unavailable or the ID cannot be determined.
    """

    command = """sh -c '. /etc/os-release >/dev/null 2>&1 && printf "%s" "$ID"'"""

    def process(self, output: list[str]) -> str | None:
        """
        Process the command output.

        Args:
            output: List of output lines from the command.

        Returns:
            The lowercase distribution ID if found, otherwise None.
        """
        if not output:
            return None

        system_id = output[0].strip().lower()
        return system_id or None
