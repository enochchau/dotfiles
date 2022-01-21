#!/bin/zsh

# vim
alias vi="nvim"
alias vim="nvim"

# nav
alias cdnvim="cd ~/.config/nvim"
alias cddot="cd ~/dotfiles"
alias ...=../..
alias ....=../../..
alias .....=../../../..
alias ......=../../../../..

# git
alias ga='git add'
alias gb='git branch'
alias gc='git commit -v'
alias gco='git checkout'
alias gcp='git cherry-pick'
alias gd='git diff'
alias gf='git fetch'
alias gfa='git fetch --all --prune --jobs=10'
alias glo='git log --oneline --decorate'
alias gl='git pull'
alias gpsup='git push --set-upstream origin $(git_current_branch)'
alias gp='git push'
alias gst='git status'
alias gcol="git branch | fzf | sed 's/^.* //' | xargs git checkout"
alias gitdel='~/code/dev-scripts/git-delete.sh'

# ls
alias l='ls -lah'
alias la='ls -lAh'
alias ll='ls -lh'
alias ls='ls -G --color'
alias lsa='ls -lah'
