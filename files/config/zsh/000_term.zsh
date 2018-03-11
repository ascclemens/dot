########
# TERM #
########

# Yes, everything about this is bad. However, it's basically the only TERM that gets everyone to
# play together nicely. iTerm -> tmux -> ssh/mosh -> tmux maintaining proper keybinds is a miracle.
# So the way this works is that we use xterm-256color everywhere EXCEPT tmux. tmux requires
# screen-256color.
if [[ $TMUX != "" ]]; then
  export TERM=screen-256color
else
  export TERM=xterm-256color
fi
