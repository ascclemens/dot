########
# Path #
########

# add ~/.local/bin
if [[ -d ~/.local/bin ]]; then
  export PATH=$PATH:~/.local/bin
fi

# add nim
if [[ -d ~/.nimble/bin ]]; then
  export PATH=$PATH:~/.nimble/bin
fi

export PATH=$PATH:/usr/local/sbin:/usr/local/bin
