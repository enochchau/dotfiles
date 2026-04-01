#!/bin/bash
# Claude Code statusline — minimal lualine/p10k style
# Uses nerdfonts + ANSI colors mapped to terminal palette

input=$(cat)

# Parse JSON (single jq call, tab-delimited)
IFS=$'\t' read -r model cwd used total_input total_output cost vim_mode wt_name wt_branch \
  <<< "$(echo "$input" | jq -r '
  [
    .model.display_name // "?",
    .workspace.current_dir // .cwd // "",
    .context_window.used_percentage // "",
    (.context_window.total_input_tokens // 0 | tostring),
    (.context_window.total_output_tokens // 0 | tostring),
    (.cost.total_cost_usd // 0 | tostring),
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

# Group backgrounds (subtle, using 256-color palette)
BG_MODEL="\033[48;5;236m"    # dark gray
BG_USAGE="\033[48;5;234m"    # darker gray
BG_GIT="\033[48;5;236m"      # dark gray

# Nerdfonts (literal UTF-8, verified from nerdfonts.com/cheat-sheet)
ICON_MODEL="󰧑"   # nf-md-brain
ICON_GAUGE="󰊚"   # nf-md-gauge
ICON_FOLDER="󰉋"   # nf-md-folder
ICON_TREE="󰒪"   # nf-md-sitemap
ICON_BRANCH="󰘬"   # nf-md-source_branch
ICON_WATER="󰖌"   # nf-md-water
ICON_COST=""   # nf-fa-dollar

# --- Segment / Group primitives ---
# A segment is "color content [icon]" → rendered as "icon content" in color
# A group wraps segments in a background with │ separators
#
# _seg_N tracks segment count; _seg_color_N / _seg_content_N store each one.
# This avoids arrays-in-subshells issues (group is called inline, not in $()).

_seg_N=0

# Add a segment: seg <color> <content> [icon]
seg() {
  local color="$1" content="$2" icon="$3"
  local rendered
  if [ -n "$icon" ]; then
    rendered="${color}${icon} ${content}"
  else
    rendered="${color}${content}"
  fi
  eval "_seg_${_seg_N}=\"\${rendered}\""
  _seg_N=$((_seg_N + 1))
}

# Render accumulated segments as a group with a background color, append to $line
# Usage: group <bg_color>
group() {
  [ "$_seg_N" -eq 0 ] && return
  local bg="$1"
  line="${line}${bg} "
  local i=0
  while [ "$i" -lt "$_seg_N" ]; do
    if [ "$i" -gt 0 ]; then
      line="${line}${FG_GRAY} │ ${bg}"
    fi
    eval "line=\"\${line}\${_seg_${i}}\""
    i=$((i + 1))
  done
  line="${line} ${RST}"
  _seg_N=0
}

# Format token count (e.g. 12345 -> 12.3k, 1234567 -> 1.2M)
fmt_tokens() {
  local t=$1
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

# Format water usage (microliters -> μl/ml/L)
fmt_water() {
  local ul=$1
  if [ "$ul" -ge 1000000 ]; then
    echo "$((ul / 1000000)).$((ul % 1000000 / 100000))L"
  elif [ "$ul" -ge 1000 ]; then
    echo "$((ul / 1000)).$((ul % 1000 / 100))ml"
  else
    echo "${ul}μl"
  fi
}

# Shorten a path (home -> ~, truncate to last 2 segments if deep)
fmt_path() {
  local p="$1"
  p=$(echo "$p" | sed "s|^$HOME|~|")
  local depth=$(echo "$p" | tr '/' '\n' | wc -l)
  if [ "$depth" -gt 3 ]; then
    p="…/$(echo "$p" | rev | cut -d'/' -f1-2 | rev)"
  fi
  echo "$p"
}

# --- Build statusline ---
line=""

# Vim mode badge (reverse video, stands alone before groups)
if [ -n "$vim_mode" ]; then
  case "$vim_mode" in
    NORMAL)  mode_color="${FG_BLUE}" ;;
    INSERT)  mode_color="${FG_GREEN}" ;;
    VISUAL)  mode_color="${FG_MAGENTA}" ;;
    REPLACE) mode_color="${FG_RED}" ;;
    *)       mode_color="${FG_WHITE}" ;;
  esac
  line="${BOLD}${mode_color}${REV} ${vim_mode} ${RST} "
fi

# --- Group 1: Model ---
seg "${FG_BLUE}" "${model}" "${BOLD}${ICON_MODEL}"
group "$BG_MODEL"

# --- Group 2: Usage stats ---
if [ -n "$used" ]; then
  used_int=$(printf "%.0f" "$used")
  if [ "$used_int" -ge 80 ]; then ctx_color="${FG_RED}"
  elif [ "$used_int" -ge 50 ]; then ctx_color="${FG_YELLOW}"
  else ctx_color="${FG_GREEN}"
  fi

  tok_total=$(( ${total_input:-0} + ${total_output:-0} ))
  tok_fmt=$(fmt_tokens "$tok_total")
  seg "$ctx_color" "${used_int}% ${DIM}(${tok_fmt})${RST}${BG_USAGE}" "$ICON_GAUGE"

  # water_ul=$(( ${total_output:-0} * 500 / 1000 ))
  # water_fmt=$(fmt_water "$water_ul")
  # seg "${FG_CYAN}" "${water_fmt}" "$ICON_WATER"

  # if [ -n "$cost" ] && [ "$cost" != "0" ]; then
  #   cost_fmt=$(printf '%.2f' "$cost")
  #   seg "${FG_YELLOW}" "\$${cost_fmt}" "$ICON_COST"
  # fi

  line="${line} "
  group "$BG_USAGE"
fi

# --- Group 3: Git ---
if [ -n "$cwd" ]; then
  seg "${FG_CYAN}" "$(fmt_path "$cwd")" "$ICON_FOLDER"
fi
# if [ -n "$wt_detected" ]; then
#   seg "${FG_MAGENTA}" "${wt_detected}" "$ICON_TREE"
# fi
if [ -n "$git_branch" ]; then
  seg "${FG_GREEN}" "${git_branch}" "$ICON_BRANCH"
fi
if [ "$_seg_N" -gt 0 ]; then
  line="${line} "
  group "$BG_GIT"
fi

printf "%b" "$line"
