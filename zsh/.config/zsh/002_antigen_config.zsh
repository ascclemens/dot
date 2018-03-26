###########
# Antigen #
###########

if [[ -e $(which curl) && ! -e ~/.config/zsh/antigen.zsh ]]; then
  echo 'Downloading antigen...'
  curl -L git.io/antigen > ~/.config/zsh/antigen.zsh
fi

if [[ -e ~/.config/zsh/antigen.zsh ]]; then
  source ~/.config/zsh/antigen.zsh

  antigen use oh-my-zsh
  antigen bundle rimraf/k
  antigen bundle git
  antigen bundle git-extras
  antigen bundle brew
  antigen bundle brew-cask
  antigen bundle colorize
  antigen bundle jump
  antigen bundle mvn
  antigen bundle cp
  antigen bundle mosh
  antigen bundle httpie
  antigen bundle pip
  antigen bundle python
  antigen bundle tmuxinator
  antigen bundle web-search
  antigen bundle zsh-users/zsh-syntax-highlighting
  antigen bundle peterhurford/up.zsh
  antigen bundle rupa/z
  antigen apply
fi
