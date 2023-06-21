#!/usr/bin/env zsh

_mov_to_mp4_completion()
{
  local res=$(ls -b | grep '.*\.mov$')
  COMPREPLY="$res"
}
complete -o filenames -F _mov_to_mp4_completion mov-to-mp4
