######################
# Version management #
######################

if [[ -d ~/.pyenv ]]; then
  export PATH=~/.pyenv/bin:$PATH
  eval "$(pyenv init -)"
fi

if [[ -d ~/.rbenv ]]; then
  export PATH=$HOME/.rbenv/bin:$PATH
  eval "$(rbenv init -)"
fi

[[ -x $(command -v jenv) ]] && eval "$(jenv init -)"
[[ -x $(command -v rbenv) ]] && eval "$(rbenv init -)"
[[ -x $(command -v thefuck) ]] && eval "$(thefuck --alias)"

[[ -x /home/linuxbrew/.linuxbrew/bin/brew ]] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
