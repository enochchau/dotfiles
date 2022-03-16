#!/bin/bash

git_username=${1:-'ec965'}
git_email=${2:-'22567131+ec965@users.noreply.github.com'}

echo $(cat << EOF
{ ... }:

{
  username = "$(whoami)";
  homeDirectory = "$(echo $HOME)";
  gitUsername = "$git_username";
  gitEmail = "$git_email";
}
EOF
)
