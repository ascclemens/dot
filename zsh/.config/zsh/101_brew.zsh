########
# Brew #
########

if [[ -x $(command -v brew) ]]; then
  function __do_brew() {
    if brew ls --versions openssl > /dev/null; then
      local openssl_prefix
      if openssl_prefix=$(brew --prefix openssl); then
        export OPENSSL_INCLUDE_DIR="$openssl_prefix/include"
        export OPENSSL_LIB_DIR="$openssl_prefix/lib"
      fi
    fi

    if brew ls --versions curl > /dev/null; then
      local curl_prefix
      if curl_prefix=$(brew --prefix curl); then
        export PATH="$curl_prefix/bin:$PATH"
      fi
    fi

    if brew ls --versions zsh > /dev/null; then
      local site_functions
      site_functions=$(brew --prefix)/share/zsh/site-functions
      if [[ -d $site_functions ]]; then
        FPATH="$site_functions:$FPATH"
      fi
    fi
  }
  __do_brew
  unfunction __do_brew
fi
