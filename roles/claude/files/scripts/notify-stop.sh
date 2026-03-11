#!/bin/sh
# Claude Code Stop hook — sends a macOS notification with the last message.
# Receives JSON on stdin with "last_assistant_message" field.

msg=$(jq -r '.last_assistant_message // "Done" | .[0:200]' 2>/dev/null)
msg=${msg:-Done}

ICON="$HOME/.claude/scripts/icon.png"

if command -v terminal-notifier >/dev/null 2>&1; then
  if [ -f "$ICON" ]; then
    terminal-notifier -title "Claude Code" -message "$msg" -sound default -appIcon "$ICON"
  else
    terminal-notifier -title "Claude Code" -message "$msg" -sound default
  fi
else
  # Fallback to osascript
  # Escape double quotes for AppleScript
  msg=$(printf '%s' "$msg" | sed 's/"/\\"/g')
  osascript -e "display notification \"$msg\" with title \"Claude Code\" sound name \"default\""
fi
