zstyle ':antidote:bundle' use-friendly-names 'yes'
source $ZDOTDIR/antidote/antidote.zsh

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# cd opts
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus
# misc opts
setopt multios              # enable redirect to multiple streams: echo >file1 >file2
setopt long_list_jobs       # show long list format job notifications
setopt interactivecomments  # recognize comments

# load dotfiles functions, completions, and scripts
# You can override DOT_FILES if it's cloned to a different location
DOT_FILES=${DOT_FILES:-~/dotfiles}
DOT_FILES_ZSH=$DOT_FILES/roles/zsh/files
fpath=($DOT_FILES_ZSH/functions $DOT_FILES_ZSH/completions $fpath)
fpath+=${ZDOTDIR:-~}/.zsh_functions
autoload -Uz $DOT_FILES_ZSH/functions/*(.:t)

export PATH=$DOT_FILES_ZSH/scripts:$PATH
export PATH=~/.local/bin:$PATH
export PATH=~/.luarocks/bin:$PATH
export PATH="/usr/local/sbin:$PATH"

# general aliases
alias cddot="cd $DOT_FILES"
alias cdnvim='cd ~/.config/nvim'
alias gcol='git branch | fzf | sed '\''s/^.* //'\'' | xargs git checkout'
alias vi="nvim"
alias vim="nvim"
# dev script
dev_scripts_base=~/code/dev-scripts
if test -d $dev_scripts_base; then
    export PATH="$dev_scripts_base:$PATH"
    fpath+=$dev_scripts_base/completions
    alias gitdel="$dev_scripts_base/git-delete"
    alias conf="source $dev_scripts_base/project $XDG_CONFIG_HOME"
    alias dot="source $dev_scripts_base/project $HOME/dotfiles $HOME/dotfiles/roles"
fi
# docker-compose v2 alias so that completions work
alias docker-compose='docker compose'
# git aliases
alias gst='git status'
alias gc='git commit'
alias gb='git branch'
alias gbcd="git for-each-ref --sort=-committerdate refs/heads/ --format='%(committerdate:local) %(refname)'"
alias gco='git checkout'
alias gcp='git cherry-pick'
alias gd='git diff'
alias gf='git fetch'
alias gfa='git fetch --all'
alias gl='git pull'
alias gm='git merge'
alias gp='git push'
alias gpf='git push --force'
alias gpsup='git push --set-upstream origin $(git rev-parse --abbrev-ref HEAD)'
alias grb='git rebase'
alias ga="git add"
# directory aliases
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'
# List directory contents
alias lsa='ls -lah'
alias l='ls -lah'
alias ll='ls -lh'
alias la='ls -lAh'

autoload -Uz compinit zrecompile promptinit

# speed up compinit
dump=$ZSH_COMPDUMP
if [[ -s $dump(#qN.mh+24) && (! -s "$dump.zwc" || "$dump" -nt "$dump.zwc") ]]; then
    compinit -d $ZSH_COMPDUMP
    zrecompile $ZSH_COMPDUMP
fi
compinit -C

# load plugins
antidote load

# machine specific configuration
if test -f $ZDOTDIR/machine.zsh; then
    source $ZDOTDIR/machine.zsh
fi

compinit

# prompt
promptinit && prompt powerlevel10k
source ~/.config/zsh/.p10k.zsh

# pnpm
export PNPM_HOME="/Users/enochchau/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

eval "$(mise activate zsh)"

bindkey -e
