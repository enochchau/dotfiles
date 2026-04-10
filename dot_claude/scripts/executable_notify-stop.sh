#!/bin/sh
# Claude Code Stop hook — sends a macOS notification with the last message.
# Receives JSON on stdin with "last_assistant_message" field.

msg=$(jq -r '.last_assistant_message // "Done" | .[0:200]' 2>/dev/null)
msg=${msg:-Done}

ICON="$HOME/.claude/scripts/icon.png"

# Capture tmux context so clicking the notification jumps to the right window/pane.
# We need full paths and the socket since -execute runs in a minimal environment.
# Build the on-click command: activate Ghostty, then switch tmux window/pane.
# -execute and -activate can't be combined, so we use osascript for activation.
CLICK_CMD="osascript -e 'tell application \"Ghostty\" to activate'"
if [ -n "$TMUX" ]; then
  TMUX_BIN=$(command -v tmux)
  TMUX_SOCKET=$(echo "$TMUX" | cut -d, -f1)
  TMUX_TARGET=$(tmux display-message -p '#{session_name}:#{window_index}.#{pane_index}')
  TMUX_SESSION=${TMUX_TARGET%%:*}
  CLICK_CMD="$CLICK_CMD && $TMUX_BIN -S $TMUX_SOCKET switch-client -t $TMUX_SESSION \\; select-window -t ${TMUX_TARGET%%.*} \\; select-pane -t $TMUX_TARGET"
fi

if command -v terminal-notifier >/dev/null 2>&1; then
  set -- -title "Claude Code" -message "$msg" -sound default -execute "$CLICK_CMD"
  [ -f "$ICON" ] && set -- "$@" -contentImage "$ICON"
  terminal-notifier "$@"
else
  # Fallback to osascript
  # Escape double quotes for AppleScript
  msg=$(printf '%s' "$msg" | sed 's/"/\\"/g')
  osascript -e "display notification \"$msg\" with title \"Claude Code\" sound name \"default\""
fi
