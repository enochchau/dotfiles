function cdfzf
  set -l dir (find $argv -maxdepth 1 -mindepth 1 -type d -or -type l | fzf)
  if test -n $dir
    cd $dir || exit
  end
end
