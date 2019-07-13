#############
# Functions #
#############

# mkdir, then cd to it
mkdircd() {
  mkdir -p "$*";
  cd "$*";
}

# undollar
\$() { $@ }

# dokku
dokku() {
  local remote
  local host
  local app
  if [ -x "$(command -v git)" ]; then
    if ! remote=$(git remote get-url dokku); then
      remote=""
    fi
  fi

  if [ "$remote" = "" ]; then
    echo 'No remote named `dokku`'
    return 1
  fi

  host=$(echo "$remote" | cut -d':' -f1)
  app=$(echo "$remote" | cut -d':' -f2)

  if [ "$#" -lt 1 ]; then
    ssh -t "$remote"
    return "$?"
  fi

  local first="$1"
  shift 1

  ssh -t "$host" "$first" "$app" "$@"
}
