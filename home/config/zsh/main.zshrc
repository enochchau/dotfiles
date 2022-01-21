#!/bin/zsh

# path
export PATH="$(yarn global bin):$PATH"
export PATH="$HOME/.local/bin:$PATH"

# apps
export BAT_THEME="Dracula"

autoload -U compinit; compinit
autoload -U bashcompinit; bashcompinit

source "$ZDOTDIR/zsh_aliases.sh"
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

PROMPT='%~ %b$ '
RPROMPT='%T'
