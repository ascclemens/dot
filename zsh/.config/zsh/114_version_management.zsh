######################
# Version management #
######################

if [[ -d ~/.pyenv ]]; then
  export PATH=~/.pyenv/bin:$PATH
  eval "$(pyenv init -)"
fi

[[ -x $(which jenv) ]] && eval "$(jenv init -)"
[[ -x $(which rbenv) ]] && eval "$(rbenv init -)"
[[ -x $(which thefuck) ]] && eval "$(thefuck --alias)"
