###########
# Aliases #
###########

alias battery="pmset -g batt"
alias bytes="gnumfmt --to=iec-i --suffix=B"
[[ -e $(which hub) ]] && alias git=hub
alias ka="k -A"
alias ls="ls -Gp"
alias lsa="ls -A"
alias mpsyt='mpsyt; reset_title'
alias mux=tmuxinator
alias pseudo=sudo
alias reset_title='printf "\e]0;$(hostname)\a"'
alias vlc="reattach-to-user-namespace /Applications/VLC.app/Contents/MacOS/VLC"
