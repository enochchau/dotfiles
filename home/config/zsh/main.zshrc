#!/bin/zsh

alias vi="nvim"
alias vim="nvim"
alias cdnvim="cd ~/.config/nvim"
alias gcol="git branch | fzf | sed 's/^.* //' | xargs git checkout"

plugins=(git)
eval "$(sheldon source)"

# go to git root directory
cdg() { cd "$(git rev-parse --show-toplevel)/$1" }
_cdg_completion()
{
  COMPREPLY="$(ls $(git rev-parse --show-toplevel || echo "$HOME")/)" 
}
complete -F _cdg_completion cdg

bindkey -v
