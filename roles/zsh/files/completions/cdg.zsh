#!/usr/bin/env zsh
_cdg_completion()
{
  COMPREPLY=()
  local git_root=$(git rev-parse --show-toplevel)
  echo "${COMP_WORDS[COMP_CWORD]}"

  if [[ -n "$git_root" ]]; then
    pushd $git_root > /dev/null
    local dirs=$(ls -b -d */)
    popd > /dev/null
    COMPREPLY=( $(compgen -W "$dirs" -- "${COMP_WORDS[COMP_CWORD]}") )
  fi
}
complete -F _cdg_completion cdg

