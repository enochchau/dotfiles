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

alias proj="~/code/dev-scripts/project.sh $HOME/Gatsby $HOME/code $HOME/Gatsby/repo"
alias rung="rungatsby"
alias killg="killgatsby"
alias cdgadved="cdgp ui-gen2/src/components/AdvancedEditor/"

export PULSAR_CPP_DIR="/usr/local/Cellar/libpulsar/3.4.0"

# opam configuration
[[ ! -r /Users/enochchau/.opam/opam-init/init.zsh ]] || source /Users/enochchau/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

export PATH="/usr/local/opt/mongodb-community@5.0/bin:$PATH"
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"

###-begin-gatsby-completions-###
#
# yargs command completion script
#
# Installation: ../../../../.asdf/installs/nodejs/16.20.2/.npm/bin/gatsby completion >> ~/.zshrc
#    or ../../../../.asdf/installs/nodejs/16.20.2/.npm/bin/gatsby completion >> ~/.zsh_profile on OSX.
#
_gatsby_yargs_completions()
{
    local reply
    local si=$IFS
    IFS=$'
    ' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" ../../../../.asdf/installs/nodejs/16.20.2/.npm/bin/gatsby --get-yargs-completions "${words[@]}"))
  IFS=$si
  _describe 'values' reply
}
compdef _gatsby_yargs_completions gatsby
###-end-gatsby-completions-###
