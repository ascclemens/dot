# always use nano as the editor
export EDITOR=nano
# override code with the dumb patched so
alias code="env LD_LIBRARY_PATH=$HOME/.local/lib code"
# auto title will echo the command name after each command because it's buggy
export DISABLE_AUTO_TITLE="true"
