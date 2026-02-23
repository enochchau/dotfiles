from pyinfra.facts.base import FactBase


class UserShell(FactBase):
    """
    Returns the current user's shell path on macOS.
    Uses dscl to read the UserShell attribute.
    """

    default = None

    def command(self) -> str:
        # Get the current username first
        username_command = "whoami"
        # Then use dscl to get the shell
        return "dscl . -read /Users/$(whoami) UserShell | cut -d' ' -f2"
