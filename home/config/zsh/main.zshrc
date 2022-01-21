#!/bin/zsh

# path
export PATH="$(yarn global bin):$PATH"
export PATH="$HOME/.local/bin:$PATH"

# apps
export BAT_THEME="Dracula"

autoload -U compinit; compinit
autoload -U bashcompinit; bashcompinit

source "$ZDOTDIR/zsh_aliases.sh"
source "$ZDOTDIR/prompt.sh"
# plugins=(git)
# export ZSH="$XDG_DATA_HOME/sheldon/repos/github.com/ohmyzsh/ohmyzsh"
eval "$(sheldon source)"

# go to git root directory
cdg() { cd "$(git rev-parse --show-toplevel)/$1" }
_cdg_completion()
{
  COMPREPLY="$(ls $(git rev-parse --show-toplevel || echo "$HOME")/)" 
}
complete -F _cdg_completion cdg

bindkey -v

export HISTFILESIZE=50000
export HISTSIZE=50000
export HISTFILE="$ZDOTDIR/zsh_history"
setopt HIST_FIND_NO_DUPS
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt APPEND_HISTORY
