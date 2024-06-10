# Configuration specific to my MacBook

# go
export PATH="$HOME/go/bin:$PATH"
# add kubectl-gopass extension to path
export PATH="$HOME/Gatsby/kubectl-gopass:$PATH"

# android studio
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-11.jdk/Contents/Home

alias cdgadved="cdgp ui-gen2/src/components/AdvancedEditor/"

dev_scripts_base=~/code/dev-scripts
if test -d $dev_scripts_base; then
    alias proj="$dev_scripts_base/project $HOME/Gatsby $HOME/code $HOME/Gatsby/repo"
fi

gatsby_scripts_base=~/Gatsby/scripts
if test -d $gatsby_scripts_base; then
    fpath+=$gatsby_scripts_base/completions
    alias aws-sso="$gatsby_scripts_base/aws-sso"
    alias aws-sso="$gatsby_scripts_base/aws-login"
    alias killg="$gatsby_scripts_base/gatsby-kill"
    alias rung="$gatsby_scripts_base/gatsby-run"
    alias gatsby-worktree="$gatsby_scripts_base/tmux-worktree-add \$(git branch | grep '^  ' | sed 's/^  //' | fzf)"
fi

export PULSAR_CPP_DIR="/usr/local/Cellar/libpulsar/3.4.0"

# opam configuration
# [[ ! -r /Users/enochchau/.opam/opam-init/init.zsh ]] || source /Users/enochchau/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

export PATH="/usr/local/opt/mongodb-community@5.0/bin:$PATH"

# fzf keybinds and completion - must be loaded after ohmyzsh vi-mode plugin
FZF_BASE=$(brew --prefix)/opt/fzf/shell
source $FZF_BASE/key-bindings.zsh
source $FZF_BASE/completion.zsh

