#!/bin/sh
# Claude Code Stop hook — sends a macOS notification with the last message.
# Receives JSON on stdin with "last_assistant_message" field.

msg=$(jq -r '.last_assistant_message // "Done" | .[0:200]' 2>/dev/null)
msg=${msg:-Done}
# Escape double quotes for AppleScript
msg=$(printf '%s' "$msg" | sed 's/"/\\"/g')

osascript -e "display notification \"$msg\" with title \"Claude Code\""
