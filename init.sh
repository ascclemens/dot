#!/bin/sh

__box_init() {
  set -e

  local nopasswd=0
  local darwin=0
  local sudo=''
  local no_sudo=0

  if [ "$(uname)" = 'Darwin' ]; then
    darwin=1
  fi

  if [ -x "$(command -v sudo)" ]; then
    local cap
    cap="$(sudo -l)"
    if echo "$cap" | grep NOPASSWD; then
      nopasswd=1
      sudo="sudo"
    elif echo "$cap" | grep ALL; then
      sudo="sudo"
    else
      echo 'not enough sudo privileges'
      echo 'cowardly refusing to continue'
      return
    fi
  elif [ "$(whoami)" = "root" ]; then
    local sudo=""
  elif [ "$INIT_NO_SUDO" != "" ]; then
    echo 'no sudo found and not root'
    echo 'going ahead without sudo'
    echo 'things may break'
    no_sudo=1
  else
    echo 'no sudo found and not root'
    echo 'cowardly refusing to continue'
    return
  fi

  if [ $no_sudo -eq 0 ]; then
    echo 'updating apt...'
    $sudo apt-get update

    echo 'upgrading system...'
    $sudo apt-get -y upgrade && $sudo apt-get -y dist-upgrade

    echo 'installing zsh, curl, git, xz-utils, and stow...'
    $sudo apt-get install -y zsh curl git xz-utils stow
  fi

  echo 'setting shell to zsh...'
  if [ $no_sudo -eq 0 ] && [ $nopasswd = 1 ]; then
    # use sudo since it will work and won't prompt for a password
    if [ $darwin = 1 ]; then
      $sudo chsh -s "$(command -v zsh)" -u "$(whoami)"
    else
      $sudo chsh -s "$(command -v zsh)" "$(whoami)"
    fi
  else
    # no point in using sudo, as it will require the same password
    chsh -s "$(which zsh)"
  fi

  echo 'downloading dot files...'
  git clone https://github.com/jkcclemens/dot.git ~/.dot

  echo 'moving to tempdir...'
  local temp=''
  temp="$(mktemp -d)"
  cd "$temp"

  echo 'making ~/.prompt...'
  mkdir -p ~/.prompt

  echo 'making ~/.local/bin...'
  mkdir -p ~/.local/bin

  echo 'downloading path and prompt...'
  curl https://kyleclemens.com/assets/path_and_prompt.tar.xz > path_and_prompt.tar.xz

  echo 'extracting...'
  tar xvf path_and_prompt.tar.xz

  echo 'moving binaries...'
  mv prompt ~/.prompt/prompt
  mv path ~/.local/bin/path

  echo 'moving to ~/.dot...'
  cd ~/.dot

  echo 'removing tempdir...'
  rm -rfv "$temp"

  echo 'making ~/.config/zsh...'
  mkdir -p ~/.config/zsh

  echo 'stowing zsh and path...'
  stow zsh
  stow path

  printf 'install rust? [y/N] '
  read -r install
  if [ "$install" = 'y' ] || [ "$install" = 'Y' ]; then
    curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain nightly --no-modify-path -y
  fi

  echo 'all done. log out and back in for zsh.'
}

__box_init

if command -v unfunction >/dev/null 2>&1; then
  unfunction __box_init
elif command -v unset >/dev/null 2>&1; then
  unset __box_init
fi
