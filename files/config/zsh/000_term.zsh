########
# TERM #
########

# Basically, I give up. xterm-256color should work, in theory, but it just doesn't. In fact, it only
# works in iTerm2 *out of* tmux. Inside tmux or via ssh, screen-256color is required. I don't even
# care at this point. It's been hours. The TERM variable is unbelievable.
if [[ $TMUX == "" && $(uname) == "Darwin" ]]; then
  export TERM=xterm-256color
else
  export TERM=screen-256color
fi
