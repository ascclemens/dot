###########
# Globals #
###########

# set editor based on host
if [[ $(uname) == 'Darwin' ]]; then
  export EDITOR="code -wn"
else
  export EDITOR=nano
fi

# set java home if on macOS
[[ -x /usr/libexec/java_home ]] && export JAVA_HOME=$(/usr/libexec/java_home 2>/dev/null)

export MONO_GAC_PREFIX="/usr/local"
export GPG_TTY=$(tty)

[[ -x $(command -v sccache) ]] && export RUSTC_WRAPPER=sccache
