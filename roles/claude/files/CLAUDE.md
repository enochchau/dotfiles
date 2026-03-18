# Tool preferences

- When searching for files by name, prefer using `fd` via Bash over the Glob tool.
- When searching file contents, prefer using `rg` via Bash over the Grep tool.
- Do not use `rm` to delete files, use `trash` instead to move them to trash.
- When creating skills/commands, include a fallback for POSIX utils (`find`, `grep`, `rm`, etc.) since not all systems have `rg`, `fd`, and `trash`.

# General

- When referencing source code, always provide the file and line number.
- Before implementing, verify assumptions by checking documentation or web searching for the correct API/CLI flags/behavior. If neither clarifies, ask the user before proceeding. Never guess at how an external tool or API works.
- Always do a code review after completing a body of work and fix all issues before continuing.
  - How can we improve it for robustness? Is it good enough? Is there anything that's overkill?
  - Is there any missing logic or mistakes? What about testing? Is coverage good enough for high confidence?
  - Is there any dead code that can be removed?

# Agent Teams

- Always evaluate a task to see if it can be done in parallel by an agent team.
- When using an agent team, have each subagent work in it's own git worktree and merge
  back into the main branch as they complete.
- Review/audit agents must be read-only — report findings only, no edits. Use a separate agent to implement review findings.
