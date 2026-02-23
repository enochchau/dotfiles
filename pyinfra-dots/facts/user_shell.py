from pyinfra.api import FactBase


class UserShell(FactBase):
    """
    Returns the current user's shell path on macOS.
    Uses dscl to read the UserShell attribute.
    """

    command = "dscl . -read /Users/$(whoami) UserShell | cut -d' ' -f2"

    def process(self, output):
        # output is a list with one line: the shell path
        if output:
            return output[0].strip()
        return None
