###########
# Antigen #
###########

if [[ ! -e ~/.config/zsh/antigen.zsh && -x $(command -v curl) ]]; then
  echo 'Downloading antigen...'
  curl -L git.io/antigen > ~/.config/zsh/antigen.zsh
fi

if [[ -e ~/.config/zsh/antigen.zsh ]]; then
  source ~/.config/zsh/antigen.zsh

  antigen use oh-my-zsh
  antigen bundle cargo
  antigen bundle colored-man-pages
  antigen bundle colorize
  antigen bundle cp
  antigen bundle docker
  antigen bundle docker-compose
  antigen bundle git
  antigen bundle git-extras
  antigen bundle httpie
  antigen bundle mosh
  antigen bundle peterhurford/up.zsh
  antigen bundle pip
  antigen bundle python
  antigen bundle rimraf/k
  antigen bundle rupa/z
  antigen bundle rust
  antigen bundle tmuxinator
  antigen bundle zsh-users/zsh-completions
  antigen bundle zsh-users/zsh-syntax-highlighting
  antigen apply
fi
