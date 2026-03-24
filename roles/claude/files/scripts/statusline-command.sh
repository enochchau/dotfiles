#!/bin/bash
# Claude Code statusline — minimal lualine/p10k style
# Uses nerdfonts + ANSI colors mapped to terminal palette

input=$(cat)

# Parse JSON (single jq call, tab-delimited)
IFS=$'\t' read -r model cwd used total_input total_output vim_mode wt_name wt_branch \
  <<< "$(echo "$input" | jq -r '
  [
    .model.display_name // "?",
    .workspace.current_dir // .cwd // "",
    .context_window.used_percentage // "",
    (.context_window.total_input_tokens // 0 | tostring),
    (.context_window.total_output_tokens // 0 | tostring),
    .vim.mode // "",
    .worktree.name // "",
    .worktree.branch // ""
  ] | @tsv')"

# Git info (from git directly, falling back to Claude's worktree data)
git_dir="${cwd:-$PWD}"
git_branch=$(git -C "$git_dir" symbolic-ref --short HEAD 2>/dev/null \
  || git -C "$git_dir" rev-parse --short HEAD 2>/dev/null)
[ -z "$git_branch" ] && git_branch="$wt_branch"

# Worktree detection (check if cwd is a linked worktree)
git_common=$(git -C "$git_dir" rev-parse --git-common-dir 2>/dev/null)
git_gitdir=$(git -C "$git_dir" rev-parse --git-dir 2>/dev/null)
wt_detected=""
if [ -n "$git_common" ] && [ -n "$git_gitdir" ] && [ "$git_common" != "$git_gitdir" ]; then
  wt_detected=$(basename "$git_dir")
fi
[ -z "$wt_detected" ] && wt_detected="$wt_name"

# Colors (ANSI — maps to terminal palette)
RST="\033[0m"
BOLD="\033[1m"
DIM="\033[2m"
FG_GREEN="\033[32m"
FG_YELLOW="\033[93m"
FG_BLUE="\033[34m"
FG_MAGENTA="\033[35m"
FG_CYAN="\033[36m"
FG_WHITE="\033[37m"
FG_GRAY="\033[90m"
FG_RED="\033[31m"
REV="\033[7m"

# Nerdfonts (literal UTF-8, verified from nerdfonts.com/cheat-sheet)
ICON_MODEL="󰧑"   # nf-md-brain
ICON_GAUGE="󰊚"   # nf-md-gauge
ICON_FOLDER="󰉋"   # nf-md-folder
ICON_TREE="󰒪"   # nf-md-sitemap
ICON_BRANCH="󰘬"   # nf-md-source_branch

SEP="${FG_GRAY} │ ${RST}"

# Format token count (e.g. 12345 -> 12.3k, 1234567 -> 1.2M)
fmt_tokens() {
  t=$1
  if [ -z "$t" ] || [ "$t" = "null" ]; then
    echo "0"; return
  fi
  if [ "$t" -ge 1000000 ]; then
    echo "$((t / 1000000)).$((t % 1000000 / 100000))M"
  elif [ "$t" -ge 1000 ]; then
    echo "$((t / 1000)).$((t % 1000 / 100))k"
  else
    echo "$t"
  fi
}

# --- Build segments ---
line=""

# Vim mode badge (reverse video like lualine)
if [ -n "$vim_mode" ]; then
  case "$vim_mode" in
    NORMAL)  mode_color="${FG_BLUE}" ;;
    INSERT)  mode_color="${FG_GREEN}" ;;
    VISUAL)  mode_color="${FG_MAGENTA}" ;;
    REPLACE) mode_color="${FG_RED}" ;;
    *)       mode_color="${FG_WHITE}" ;;
  esac
  line="${line}${BOLD}${mode_color}${REV} ${vim_mode} ${RST}"
  line="${line}${SEP}"
fi

# Model
line="${line}${FG_BLUE}${BOLD}${ICON_MODEL} ${RST}${FG_BLUE}${model}${RST}"

# Context window used % + token count
if [ -n "$used" ]; then
  used_int=$(printf "%.0f" "$used")
  if [ "$used_int" -ge 80 ]; then
    ctx_color="${FG_RED}"
  elif [ "$used_int" -ge 50 ]; then
    ctx_color="${FG_YELLOW}"
  else
    ctx_color="${FG_GREEN}"
  fi
  tok_total=$(( ${total_input:-0} + ${total_output:-0} ))
  tok_fmt=$(fmt_tokens "$tok_total")
  line="${line}${SEP}${ctx_color}${ICON_GAUGE} ${used_int}% ${DIM}(${tok_fmt})${RST}"
fi

# CWD (shorten home to ~, show only last 2 segments if long)
if [ -n "$cwd" ]; then
  short_cwd=$(echo "$cwd" | sed "s|^$HOME|~|")
  depth=$(echo "$short_cwd" | tr '/' '\n' | wc -l)
  if [ "$depth" -gt 3 ]; then
    short_cwd="…/$(echo "$short_cwd" | rev | cut -d'/' -f1-2 | rev)"
  fi
  line="${line}${SEP}${FG_CYAN}${ICON_FOLDER} ${short_cwd}${RST}"
fi

# Worktree name
if [ -n "$wt_detected" ]; then
  line="${line}${SEP}${FG_MAGENTA}${ICON_TREE} ${wt_detected}${RST}"
fi

# Branch
if [ -n "$git_branch" ]; then
  line="${line}${SEP}${FG_GREEN}${ICON_BRANCH} ${git_branch}${RST}"
fi

printf "%b" "$line"
