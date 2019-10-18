###########
# Globals #
###########

# set editor based on host
if [[ -x $(command -v code) ]]; then
  export EDITOR="code -wn"
else
  export EDITOR=nano
fi

# set java home if on macOS
[[ -x /usr/libexec/java_home ]] && export JAVA_HOME=$(/usr/libexec/java_home 2>/dev/null)

export MONO_GAC_PREFIX="/usr/local"
export GPG_TTY=$(tty)

# auto title will echo the command name after each command because it's buggy
export DISABLE_AUTO_TITLE="true"
