HOSTS_DIR=$HOME/.config/zsh/hosts
if [ -d "$HOSTS_DIR" ]; then
  for f in "$HOSTS_DIR"/*(N); do
    name=$(basename "$f" | rev | cut -d. -f2- | rev)
    if [ "$name" = "$(hostname)" ]; then
      source "$f"
    fi
  done
fi

unset HOSTS_DIR
