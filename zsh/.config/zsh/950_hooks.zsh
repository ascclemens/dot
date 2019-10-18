have_requirements() {
  for req in $(basename "$1" | rev | cut -d. -f2- | rev | tr '+' '\n'); do
    case "$req" in
      '!'*)
        [ -x "$(command -v "$(echo "$req" | cut -d'!' -f2-)")" ] && return 1
        ;;
      *)
        [ ! -x "$(command -v "$req")" ] && return 1
        ;;
    esac
  done
  return 0
}

HOOKS_DIR=$HOME/.config/zsh/hooks
if [ -d "$HOOKS_DIR" ]; then
  for f in "$HOOKS_DIR"/*(N); do
    if have_requirements "$f"; then
      source "$f"
    fi
  done
fi

unset HOOKS_DIR
unfunction have_requirements
