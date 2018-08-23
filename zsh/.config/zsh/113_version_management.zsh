######################
# Version management #
######################

if [[ -d ~/.pyenv ]]; then
  export PATH=~/.pyenv/bin:$PATH
  eval "$(pyenv init -)"
fi

[[ -x $(command -v jenv) ]] && eval "$(jenv init -)"
[[ -x $(command -v rbenv) ]] && eval "$(rbenv init -)"
[[ -x $(command -v thefuck) ]] && eval "$(thefuck --alias)"
