###########
# Aliases #
###########

[[ -x $(which pmset) ]] && alias battery="pmset -g batt"
[[ -x $(which numfmt) ]] && alias bytes="numfmt --to=iec-i --suffix=B"
[[ -x $(which gnumfmt) ]] && alias bytes="gnumfmt --to=iec-i --suffix=B"
[[ -x $(which hub) ]] && alias git=hub
[[ -x $(which mpsyt) ]] && alias mpsyt='mpsyt; reset_title'
[[ -x $(which tmuxinator) ]] && alias mux=tmuxinator

if [[ -x /Applications/VLC.app/Contents/MacOS/VLC && -x $(which reattach-to-user-namespace) ]]; then
  alias vlc="reattach-to-user-namespace /Applications/VLC.app/Contents/MacOS/VLC"
fi

alias ls="ls -Gp"
alias lsa="ls -A"
alias reset_title='printf "\e]0;$(hostname)\a"'
