# always use nano as the editor
export EDITOR=nano
# override code with the dumb patched so
alias code="env LD_LIBRARY_PATH=$HOME/.local/lib code"
