#!/bin/bash
# Claude Code statusline — minimal lualine/p10k style
# Uses nerdfonts + ANSI colors mapped to terminal palette

input=$(cat)

# Parse JSON (single jq call; unit-separator delimited — unlike tab, \x1f is
# not IFS whitespace, so empty fields don't collapse and shift the rest)
IFS=$'\x1f' read -r model effort cwd used total_input total_output cost vim_mode wt_name wt_branch \
  <<< "$(echo "$input" | jq -r '
  [
    .model.display_name // "?",
    .effort.level // "",
    .workspace.current_dir // .cwd // "",
    .context_window.used_percentage // "",
    (.context_window.total_input_tokens // 0 | tostring),
    (.context_window.total_output_tokens // 0 | tostring),
    (.cost.total_cost_usd // 0 | tostring),
    .vim.mode // "",
    .worktree.name // "",
    .worktree.branch // ""
  ] | join("\u001f")')"

# Git info (from git directly, falling back to Claude's worktree data)
# --no-optional-locks: never take the index lock, just read state (safe to
# run concurrently with other git processes, no risk of lock contention).
git_dir="${cwd:-$PWD}"
git_branch=$(git --no-optional-locks -C "$git_dir" symbolic-ref --short HEAD 2>/dev/null \
  || git --no-optional-locks -C "$git_dir" rev-parse --short HEAD 2>/dev/null)
[ -z "$git_branch" ] && git_branch="$wt_branch"

# Worktree detection (check if cwd is a linked worktree)
git_common=$(git --no-optional-locks -C "$git_dir" rev-parse --git-common-dir 2>/dev/null)
git_gitdir=$(git --no-optional-locks -C "$git_dir" rev-parse --git-dir 2>/dev/null)
wt_detected=""
if [ -n "$git_common" ] && [ -n "$git_gitdir" ] && [ "$git_common" != "$git_gitdir" ]; then
  wt_detected=$(basename "$git_dir")
fi
[ -z "$wt_detected" ] && wt_detected="$wt_name"

# Git status counts (staged / modified / untracked / ahead / behind) — a
# single `status --porcelain=v2 --branch` call gives us everything at once,
# instead of separate `git diff --stat` / `git rev-list` invocations.
git_ahead=0
git_behind=0
git_staged=0
git_modified=0
git_conflicts=0
git_untracked=0
if [ -n "$git_branch" ]; then
  while IFS= read -r gline; do
    case "$gline" in
      "# branch.ab "*)
        ab="${gline#"# branch.ab "}"
        git_ahead=$(echo "$ab" | awk '{print $1}' | tr -d '+')
        git_behind=$(echo "$ab" | awk '{print $2}' | tr -d '-')
        ;;
      "1 "*|"2 "*)
        xy=$(echo "$gline" | awk '{print $2}')
        [ "${xy%?}" != "." ] && git_staged=$((git_staged + 1))
        [ "${xy#?}" != "." ] && git_modified=$((git_modified + 1))
        ;;
      "u "*)
        git_conflicts=$((git_conflicts + 1))
        ;;
      "? "*)
        git_untracked=$((git_untracked + 1))
        ;;
    esac
  done <<< "$(git --no-optional-locks -C "$git_dir" status --porcelain=v2 --branch --untracked-files=normal 2>/dev/null)"
fi

# --- Colors (ANSI foreground only — auto-adapts to terminal theme) ---
RST="\033[0m"
BOLD="\033[1m"
DIM="\033[2m"
REV="\033[7m"
FG_GREEN="\033[32m"
FG_BLUE="\033[34m"
FG_MAGENTA="\033[35m"
FG_CYAN="\033[36m"
FG_GRAY="\033[90m"
FG_RED="\033[31m"
FG_YELLOW="\033[33m"

# Nerdfonts (literal UTF-8, verified from nerdfonts.com/cheat-sheet)
ICON_MODEL="󰧑"   # nf-md-brain
ICON_GAUGE="󰊚"   # nf-md-gauge
ICON_FOLDER="󰉋"   # nf-md-folder
ICON_TREE="󰒪"   # nf-md-sitemap
ICON_BRANCH="󰘬"   # nf-md-source_branch
ICON_WATER="󰖌"   # nf-md-water
ICON_COST=""   # nf-fa-dollar

# --- Segment primitives ---
# Segments are collected in order and joined with │ separators.

_seg_N=0
SEP="${FG_GRAY} | ${RST}"

# Add a segment: seg <color> <content> [icon]
seg() {
  local color="$1" content="$2" icon="$3"
  local rendered
  if [ -n "$icon" ]; then
    rendered="${color}${icon} ${content}${RST}"
  else
    rendered="${color}${content}${RST}"
  fi
  eval "_seg_${_seg_N}=\"\${rendered}\""
  _seg_N=$((_seg_N + 1))
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

# Shorten a path (home -> ~, truncate to last 2 segments if deep,
# keeping the ~/ or / root so it's clear where the path is anchored)
fmt_path() {
  local p="$1"
  p=$(echo "$p" | sed "s|^$HOME|~|")
  local depth=$(echo "$p" | tr '/' '\n' | wc -l)
  if [ "$depth" -gt 3 ]; then
    local tail
    tail=$(echo "$p" | rev | cut -d'/' -f1-2 | rev)
    case "$p" in
      "~"*) p="~/…/${tail}" ;;
      *)    p="/…/${tail}" ;;
    esac
  fi
  echo "$p"
}

# --- Build statusline ---
line=""

# Vim mode badge (reverse video, stands alone before segments)
if [ -n "$vim_mode" ]; then
  case "$vim_mode" in
    NORMAL)  mode_color="${FG_BLUE}" ;;
    INSERT)  mode_color="${FG_GREEN}" ;;
    VISUAL)  mode_color="${FG_MAGENTA}" ;;
    REPLACE) mode_color="${FG_RED}" ;;
    *)       mode_color="" ;;
  esac
  line="${BOLD}${mode_color}${REV} ${vim_mode} ${RST} "
fi

# Model (effort is absent when the model doesn't support reasoning effort)
if [ -n "$effort" ]; then
  seg "${FG_BLUE}" "${model} ${DIM}${effort}${RST}" "${BOLD}${ICON_MODEL}"
else
  seg "${FG_BLUE}" "${model}" "${BOLD}${ICON_MODEL}"
fi

# Usage stats
if [ -n "$used" ]; then
  used_int=$(printf "%.0f" "$used")
  if [ "$used_int" -ge 80 ]; then ctx_color="${FG_RED}"
  elif [ "$used_int" -ge 50 ]; then ctx_color="${FG_YELLOW}"
  else ctx_color="${FG_GREEN}"
  fi

  tok_total=$(( ${total_input:-0} + ${total_output:-0} ))
  tok_fmt=$(fmt_tokens "$tok_total")
  seg "$ctx_color" "${used_int}% ${DIM}(${tok_fmt})${RST}" "$ICON_GAUGE"

  # water_ul=$(( ${total_output:-0} * 500 / 1000 ))
  # water_fmt=$(fmt_water "$water_ul")
  # seg "${FG_CYAN}" "${water_fmt}" "$ICON_WATER"

  # if [ -n "$cost" ] && [ "$cost" != "0" ]; then
  #   cost_fmt=$(printf '%.2f' "$cost")
  #   seg "${FG_YELLOW}" "\$${cost_fmt}" "$ICON_COST"
  # fi
fi

# Path / worktree / branch
if [ -n "$cwd" ]; then
  seg "${FG_CYAN}" "$(fmt_path "$cwd")" "$ICON_FOLDER"
fi
# if [ -n "$wt_detected" ]; then
#   seg "${FG_MAGENTA}" "${wt_detected}" "$ICON_TREE"
# fi
if [ -n "$git_branch" ]; then
  is_dirty=0
  [ "$git_staged" -gt 0 ] || [ "$git_modified" -gt 0 ] || [ "$git_untracked" -gt 0 ] || [ "$git_conflicts" -gt 0 ] && is_dirty=1
  if [ "$is_dirty" -eq 1 ]; then branch_color="${FG_YELLOW}"; else branch_color="${FG_GREEN}"; fi

  git_content="${branch_color}${git_branch}${RST}"
  [ "${git_ahead:-0}" -gt 0 ] 2>/dev/null && git_content="${git_content} ${FG_CYAN}⇡${git_ahead}${RST}"
  [ "${git_behind:-0}" -gt 0 ] 2>/dev/null && git_content="${git_content} ${FG_CYAN}⇣${git_behind}${RST}"
  [ "$git_staged" -gt 0 ] && git_content="${git_content} ${FG_GREEN}+${git_staged}${RST}"
  [ "$git_modified" -gt 0 ] && git_content="${git_content} ${FG_YELLOW}!${git_modified}${RST}"
  [ "$git_conflicts" -gt 0 ] && git_content="${git_content} ${FG_RED}~${git_conflicts}${RST}"
  [ "$git_untracked" -gt 0 ] && git_content="${git_content} ${FG_BLUE}?${git_untracked}${RST}"

  eval "_seg_${_seg_N}=\"\${BOLD}\${ICON_BRANCH} \${git_content}\""
  _seg_N=$((_seg_N + 1))
fi

# Join all segments with separator
i=0
while [ "$i" -lt "$_seg_N" ]; do
  [ "$i" -gt 0 ] && line="${line}${SEP}"
  eval "line=\"\${line}\${_seg_${i}}\""
  i=$((i + 1))
done

printf "%b" "$line"
