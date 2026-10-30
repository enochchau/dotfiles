#!/bin/bash
# Claude Code statusline — minimal lualine/p10k style
# Uses nerdfonts + ANSI colors mapped to terminal palette

input=$(cat)

# Parse JSON (single jq call; unit-separator delimited — unlike tab, \x1f is
# not IFS whitespace, so empty fields don't collapse and shift the rest)
IFS=$'\x1f' read -r model effort cwd used total_output cost vim_mode wt_name wt_branch session_id repo_name \
  <<< "$(echo "$input" | jq -r '
  [
    .model.display_name // "?",
    .effort.level // "",
    .workspace.current_dir // .cwd // "",
    .context_window.used_percentage // "",
    (.context_window.total_output_tokens // 0 | tostring),
    (.cost.total_cost_usd // 0 | tostring),
    .vim.mode // "",
    .worktree.name // "",
    .worktree.branch // "",
    .session_id // "",
    .workspace.repo.name // ""
  ] | join("\u001f")')"

# Agent name: the address other sessions use with SendMessage (e.g. "claude-dc").
# The statusline JSON doesn't carry it (session_name skips default display
# names), so look it up from `claude agents --json` by session id.
agent_name=""
if [ -n "$session_id" ]; then
  agent_name=$(claude agents --json 2>/dev/null \
    | jq -r --arg session_id "$session_id" '.[] | select(.sessionId == $session_id) | .name // empty' \
    | head -1)
fi

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

# Linear ticket in branch name (e.g. ec-eng-1234-fix-thing -> ENG-1234).
# Strip the personal "ec-" prefix first so it isn't mistaken for a team key.
LINEAR_WORKSPACE="numeric"
linear_ticket=$(printf '%s' "${git_branch#ec-}" | grep -oE '[a-zA-Z]+-[0-9]+' | head -1 | tr '[:lower:]' '[:upper:]')

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
# Segments are collected in order and joined with · separators, matching the
# native Claude Code footer.

SEP="${FG_GRAY} · ${RST}"

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

# Visible width of a rendered line (ANSI colors and OSC 8 links stripped)
visible_width() {
  printf '%b' "$1" | perl -CS -ne 's/\e\[[0-9;]*m//g; s/\e\]8;;.*?\a//g; print length'
}

# --- Segment content ---

# Vim mode badge (reverse video, stands alone before segments)
vim_badge=""
if [ -n "$vim_mode" ]; then
  case "$vim_mode" in
    NORMAL)  mode_color="${FG_BLUE}" ;;
    INSERT)  mode_color="${FG_GREEN}" ;;
    VISUAL)  mode_color="${FG_MAGENTA}" ;;
    REPLACE) mode_color="${FG_RED}" ;;
    *)       mode_color="" ;;
  esac
  vim_badge="${BOLD}${mode_color}${REV} ${vim_mode} ${RST} "
fi

# Effort, abbreviated (absent when the model doesn't support reasoning effort)
case "$effort" in
  low)    effort_short="lo" ;;
  medium) effort_short="med" ;;
  high)   effort_short="hi" ;;
  xhigh)  effort_short="xh" ;;
  *)      effort_short="$effort" ;;
esac

if [ -n "$used" ]; then
  used_int=$(printf "%.0f" "$used")
  if [ "$used_int" -ge 80 ]; then ctx_color="${FG_RED}"
  elif [ "$used_int" -ge 50 ]; then ctx_color="${FG_YELLOW}"
  else ctx_color="${FG_GREEN}"
  fi
fi

# Inside git, show the nearest repo/worktree root, prefixed with the origin repo
# name when the root dir is named differently (~/Numeric/fdp/master ->
# fdp/master, ~/Numeric/agent-skills -> agent-skills). Outside git, the cwd.
path_label=""
git_toplevel=$(git --no-optional-locks -C "$git_dir" rev-parse --show-toplevel 2>/dev/null)
if [ -n "$git_toplevel" ]; then
  path_label=$(basename "$git_toplevel")
  [ -n "$repo_name" ] && [ "$repo_name" != "$path_label" ] && path_label="${repo_name}/${path_label}"
elif [ -n "$cwd" ]; then
  path_label=$(fmt_path "$cwd")
fi

if [ -n "$git_branch" ]; then
  is_dirty=0
  [ "$git_staged" -gt 0 ] || [ "$git_modified" -gt 0 ] || [ "$git_untracked" -gt 0 ] || [ "$git_conflicts" -gt 0 ] && is_dirty=1
  if [ "$is_dirty" -eq 1 ]; then branch_color="${FG_YELLOW}"; else branch_color="${FG_GREEN}"; fi

  git_status_suffix=""
  [ "${git_ahead:-0}" -gt 0 ] 2>/dev/null && git_status_suffix="${git_status_suffix} ${FG_CYAN}⇡${git_ahead}${RST}"
  [ "${git_behind:-0}" -gt 0 ] 2>/dev/null && git_status_suffix="${git_status_suffix} ${FG_CYAN}⇣${git_behind}${RST}"
  [ "$git_staged" -gt 0 ] && git_status_suffix="${git_status_suffix} ${FG_GREEN}+${git_staged}${RST}"
  [ "$git_modified" -gt 0 ] && git_status_suffix="${git_status_suffix} ${FG_YELLOW}!${git_modified}${RST}"
  [ "$git_conflicts" -gt 0 ] && git_status_suffix="${git_status_suffix} ${FG_RED}~${git_conflicts}${RST}"
  [ "$git_untracked" -gt 0 ] && git_status_suffix="${git_status_suffix} ${FG_BLUE}?${git_untracked}${RST}"
fi

# --- Build statusline ---
# build_line <show_model> [branch_max_chars] prints the line. The fit step
# below calls it again with less content when the full line is too wide.
build_line() {
  local show_model="$1" branch_max_chars="$2"
  local line="$vim_badge"
  _seg_N=0

  if [ -n "$agent_name" ]; then
    seg "${FG_MAGENTA}" "@${agent_name}"
  fi

  if [ "$show_model" = 1 ]; then
    if [ -n "$effort_short" ]; then
      seg "${FG_BLUE}" "${model} ${DIM}${effort_short}${RST}" "${BOLD}${ICON_MODEL}"
    else
      seg "${FG_BLUE}" "${model}" "${BOLD}${ICON_MODEL}"
    fi
  fi

  if [ -n "$used" ]; then
    seg "$ctx_color" "${used_int}%" "$ICON_GAUGE"

    # water_ul=$(( ${total_output:-0} * 500 / 1000 ))
    # water_fmt=$(fmt_water "$water_ul")
    # seg "${FG_CYAN}" "${water_fmt}" "$ICON_WATER"

    # if [ -n "$cost" ] && [ "$cost" != "0" ]; then
    #   cost_fmt=$(printf '%.2f' "$cost")
    #   seg "${FG_YELLOW}" "\$${cost_fmt}" "$ICON_COST"
    # fi
  fi

  if [ -n "$path_label" ]; then
    seg "${FG_CYAN}" "$path_label" "$ICON_FOLDER"
  fi
  # if [ -n "$wt_detected" ]; then
  #   seg "${FG_MAGENTA}" "${wt_detected}" "$ICON_TREE"
  # fi

  if [ -n "$git_branch" ]; then
    local branch_text="$git_branch" git_content
    if [ -n "$branch_max_chars" ] && [ "${#git_branch}" -gt "$branch_max_chars" ]; then
      branch_text="${git_branch:0:branch_max_chars}…"
    fi

    # If the branch references a Linear ticket, make it an OSC 8 hyperlink
    # (cmd+click to open; needs a hyperlink-capable terminal like iTerm2/Kitty/WezTerm)
    if [ -n "$linear_ticket" ]; then
      ticket_url="https://linear.app/${LINEAR_WORKSPACE}/issue/${linear_ticket}"
      git_content="\033]8;;${ticket_url}\a${branch_color}${branch_text}${RST}\033]8;;\a"
    else
      git_content="${branch_color}${branch_text}${RST}"
    fi
    git_content="${git_content}${git_status_suffix}"

    eval "_seg_${_seg_N}=\"\${BOLD}\${ICON_BRANCH} \${git_content}\""
    _seg_N=$((_seg_N + 1))
  fi

  # Join all segments with separator
  local i=0
  while [ "$i" -lt "$_seg_N" ]; do
    [ "$i" -gt 0 ] && line="${line}${SEP}"
    eval "line=\"\${line}\${_seg_${i}}\""
    i=$((i + 1))
  done

  printf '%s' "$line"
}

# Fit to the terminal width (Claude Code sets COLUMNS): drop the model segment
# first, then cut the branch name down to whatever room is left.
MIN_BRANCH_CHARS=8
line=$(build_line 1)
if [ -n "$COLUMNS" ]; then
  overflow=$(( $(visible_width "$line") - COLUMNS ))
  if [ "$overflow" -gt 0 ]; then
    line=$(build_line 0)
    overflow=$(( $(visible_width "$line") - COLUMNS ))
  fi
  if [ "$overflow" -gt 0 ] && [ -n "$git_branch" ]; then
    # -1 leaves room for the "…"
    branch_max_chars=$(( ${#git_branch} - overflow - 1 ))
    [ "$branch_max_chars" -lt "$MIN_BRANCH_CHARS" ] && branch_max_chars=$MIN_BRANCH_CHARS
    line=$(build_line 0 "$branch_max_chars")
  fi
fi

printf "%b" "$line"
