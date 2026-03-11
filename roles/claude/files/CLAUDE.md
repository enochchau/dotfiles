# Tool preferences

- When searching for files by name, prefer using `fd` via Bash over the Glob tool.
- When searching file contents, prefer using `rg` via Bash over the Grep tool.
- When creating skills/commands, include a fallback for POSIX utils (`find`, `grep`, etc.) since not all systems have `rg` and `fd`.
- Do not use `rm` to delete files, use `trash` instead to move them to trash.

# General

- Always do a code review after completing a body of work and fix all issues before continuing.
- How can we improve it for robustness? Is it good enough? Is there anything that's overkill?
- Is there any missing logic or mistakes? What about testing? Is coverage good enough for high confidence?
- Is there any dead code that can be removed?
- When referencing source code, always provide the file and line number.
