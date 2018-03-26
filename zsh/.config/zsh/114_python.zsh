##########
# Python #
##########

if [[ -e ~/.pyenv ]]; then
  export PATH=~/.pyenv/bin:$PATH
  eval "$(pyenv init -)"
fi
