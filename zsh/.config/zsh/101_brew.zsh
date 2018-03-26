########
# Brew #
########

if [[ -x $(which brew) ]]; then
  export OPENSSL_INCLUDE_DIR="$(brew --prefix openssl)/include"
  export OPENSSL_LIB_DIR="$(brew --prefix openssl)/lib"
fi
