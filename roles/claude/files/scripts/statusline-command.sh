#!/bin/sh
# Claude Code status line script
# Shows: vim mode | model | cwd | context used%

input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // "Unknown Model"')
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
vim_mode=$(echo "$input" | jq -r '.vim.mode // empty')

# Build the status line parts
parts=""

# Vim mode (only when present)
if [ -n "$vim_mode" ]; then
  parts="[$vim_mode]"
fi

# Model
if [ -n "$parts" ]; then
  parts="$parts  $model"
else
  parts="$model"
fi

# Current working directory (shorten $HOME to ~)
if [ -n "$cwd" ]; then
  home="$HOME"
  short_cwd=$(echo "$cwd" | sed "s|^$home|~|")
  parts="$parts  $short_cwd"
fi

# Context window used percentage
if [ -n "$used" ]; then
  used_int=$(printf "%.0f" "$used")
  parts="$parts  ctx:${used_int}%"
fi

printf "%s" "$parts"
