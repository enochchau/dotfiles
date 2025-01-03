function cmp_cdg
  set -l gitroot (git rev-parse --show-toplevel)
  if test -n "$gitroot"
    set -l prevdir (pwd)
    cd $gitroot
    __fish_complete_directories
    cd $prevdir
  end
end

complete -c cdg -f -a "(cmp_cdg)"
