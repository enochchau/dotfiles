# go
export PATH="$HOME/go/bin:$PATH"
# add kubectl-gopass extension to path
export PATH="$HOME/Gatsby/kubectl-gopass:$PATH"

# python
# eval "$(pyenv init -)"
# PATH="$HOME/.pyenv/shims:$PATH"
#
# python julia bindings
# export PYTHON="$HOME/.pyenv/versions/julia/bin/python"

# android studio
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

alias rundev="~/code/dev-scripts/run.sh dev"
alias runsb="~/code/dev-scripts/run.sh storybook"
alias runservices="~/code/dev-scripts/run.sh services"
alias proj="~/code/dev-scripts/project.sh '$HOME/Gatsby $HOME/code $HOME/Gatsby/repo'"
alias wtb="~/code/dev-scripts/bootstrap-worktree.sh"

source ~/code/dev-scripts/cdg.sh

###-begin-gatsby-completions-###
#
# yargs command completion script
#
# Installation: gatsby completion >> ~/.zshrc
#    or gatsby completion >> ~/.zsh_profile on OSX.
#
_gatsby_yargs_completions()
{
  local reply
  local si=$IFS
  IFS=$'
' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" gatsby --get-yargs-completions "${words[@]}"))
  IFS=$si
  _describe 'values' reply
}
compdef _gatsby_yargs_completions gatsby
###-end-gatsby-completions-###
