export ZDOTDIR=$HOME/.config/zsh

export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

export EDITOR="nvim"
export VISUAL="nvim"

export JQ_COLORS="1;30:0;37:0;37:0;37:0;32:1;37:1;37"

test -f "$HOME/.cargo/env" && . "$HOME/.cargo/env"

# pager settings
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"
export BAT_PAGER='less'
export BAT_THEME='ansi'
export LESS='--mouse --wheel-lines=3'
export FZF_CTRL_T_OPTS="--preview 'bat --color=always {}'"

if [[ "$OSTYPE" == "darwin"* ]]; then
    export HOMEBREW_NO_ANALYTICS=1
fi

export ZSH_COMPDUMP=$ZDOTDIR/.zcompdump
