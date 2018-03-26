########
# Brew #
########

if [[ -e $(which brew) ]]; then
  export PATH=/usr/local/sbin:/usr/local/bin:$PATH

  [[ -e $(which jenv) ]] && eval "$(jenv init -)"
  [[ -e $(which rbenv) ]] && eval "$(rbenv init -)"
  [[ -e $(which thefuck) ]] && eval "$(thefuck --alias)"

  export OPENSSL_INCLUDE_DIR="$(brew --prefix openssl)/include"
  export OPENSSL_LIB_DIR="$(brew --prefix openssl)/lib"
fi
