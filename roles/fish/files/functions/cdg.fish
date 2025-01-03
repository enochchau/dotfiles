function cdg
  set -l gitroot (git rev-parse --show-toplevel)
  if test -n "$gitroot"
    cd "$gitroot/$argv"
  end
end
