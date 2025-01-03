/opt/homebrew/bin/brew shellenv | source

# XDG Base Directory variables
set -Ux XDG_CACHE_HOME "$HOME/.cache"
set -Ux XDG_CONFIG_HOME "$HOME/.config"
set -Ux XDG_DATA_HOME "$HOME/.local/share"
set -Ux XDG_STATE_HOME "$HOME/.local/state"

# Editor settings
set -Ux EDITOR "nvim"
set -Ux VISUAL "nvim"

# jq colors
set -Ux JQ_COLORS "1;30:0;37:0;37:0;37:0;32:1;37:1;37"

# Pager settings
set -Ux MANPAGER "sh -c 'col -bx | bat -l man -p'"
set -Ux MANROFFOPT "-c"
set -Ux BAT_PAGER "less"
set -Ux BAT_THEME "ansi"
set -Ux LESS "--mouse --wheel-lines=3"
set -Ux FZF_CTRL_T_OPTS "--preview 'bat --color=always {}'"

# Disable homebrew analytics
type -q brew && set -Ux HOMEBREW_NO_ANALYTICS 1

# Source Cargo environment
test -d "$HOME/.cargo" && fish_add_path -p "$HOME/.cargo/bin"

if status is-interactive
    # You can override DOT_FILES if it's cloned to a different location
    set -x DOT_FILES (set -q DOT_FILES; or echo ~/dotfiles)

    # General aliases
    abbr -a cddot cd $DOT_FILES
    abbr -a cdnvim cd ~/.config/nvim
    abbr -a gcol 'git branch | fzf | string replace -r ^.*  "" | xargs git checkout'
    abbr -a vi nvim
    abbr -a vim nvim

    # Git aliases
    abbr -a gst git status
    abbr -a gc git commit
    abbr -a gb git branch
    abbr -a gco git checkout
    abbr -a gcp git cherry-pick
    abbr -a gd git diff
    abbr -a gf git fetch
    abbr -a gfa git fetch --all
    abbr -a gl git pull
    abbr -a gm git merge
    abbr -a gp git push
    abbr -a gpf git push --force
    abbr -a gpsup 'git push --set-upstream origin (git rev-parse --abbrev-ref HEAD)'
    abbr -a grb git rebase
    abbr -a ga git add

    # Directory aliases
    abbr -a --position anywhere ... ../..
    abbr -a --position anywhere .... ../../..
    abbr -a --position anywhere ..... ../../../..
    abbr -a --position anywhere ...... ../../../../..

    # List directory contents
    abbr -a lsa ls -lah
    abbr -a l ls -lah
    abbr -a ll ls -lh
    abbr -a la ls -lAh

    abbr -a cdgp --set-cursor "cdg packages/%"
    abbr -a cdgs --set-cursor "cdg services/%"
    abbr -a cdrepo --set-cursor "cd ~/Gatsby/repo/%"

    abbr -a proj "cdfzf ~/code ~/Gatsby ~/Gatsby/repo"
    abbr -a conf "cdfzf ~/.config ~/dotfiles/roles"

    # Machine-specific configuration
    test -f $__fish_config_dir/machine.fish && source $__fish_config_dir/machine.fish
end
