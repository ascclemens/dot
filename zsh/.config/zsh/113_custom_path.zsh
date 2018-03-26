########
# Path #
########

# add ~/.local/bin
if [[ -d ~/.local/bin ]]; then
  export PATH=$PATH:~/.local/bin
fi

export PATH=$PATH:/usr/local/sbin:/usr/local/bin
