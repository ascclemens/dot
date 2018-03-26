#######
# zsh #
#######

zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' format ' Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' matcher-list '' 'r:|[._-]=* r:|=*'
zstyle ':completion:*' max-errors 1
zstyle :compinstall filename '/home/kyle/.zshrc'

autoload -U colors && colors
autoload -Uz compinit
compinit
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
