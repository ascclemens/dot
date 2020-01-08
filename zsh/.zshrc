########
# Main #
########

if [[ "$TERM" = "dumb" ]]; then
  unsetopt zle
  PS1="> "
else
  for f in ~/.config/zsh/*.zsh; do
    source "$f"
  done
fi
