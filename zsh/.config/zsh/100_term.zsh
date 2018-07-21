########
# TERM #
########

# The TERM variable is a disaster. Basically, unless we're in tmux, let it handle itself. If we're
# in tmux, to facilitate a consistent environment, use screen-256color. tmux must also be made
# aware of this term variable. (set -g default-terminal screen-256color)
if [[ "$TMUX" != "" ]]; then
  export TERM=screen-256color
fi
