#!/bin/zsh

source ~/.antigen.zsh
antigen use oh-my-zsh
antigen bundle git
antigen theme romkatv/powerlevel10k
antigen apply

# set editor to nvim
export VISUAL=nvim
export EDITOR="$VISUAL"
alias vi="nvim"
alias vim="nvim"

# go to git root directory
cdg() { cd "$(git rev-parse --show-toplevel)/$1" }
_cdg_completion()
{
  COMPREPLY="$(ls $(git rev-parse --show-toplevel || echo "$HOME")/)" 
}
complete -F _cdg_completion cdg

export PATH="$(yarn global bin):$PATH"
export PATH="$HOME/.local/bin:$PATH"
export BAT_THEME="Dracula"
export GIT_PAGER='delta --dark -s -n'
