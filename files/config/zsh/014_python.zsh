##########
# Python #
##########

if [[ -e $(which pyenv) ]]; then
  export PATH=~/.pyenv/bin:$PATH
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi
