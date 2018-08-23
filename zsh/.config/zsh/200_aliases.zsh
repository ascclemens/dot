###########
# Aliases #
###########

[[ -x $(command -v pmset) ]] && alias battery="pmset -g batt"
[[ -x $(command -v numfmt) ]] && alias bytes="numfmt --to=iec-i --suffix=B"
[[ -x $(command -v gnumfmt) ]] && alias bytes="gnumfmt --to=iec-i --suffix=B"
[[ -x $(command -v hub) ]] && alias git=hub
[[ -x $(command -v mpsyt) ]] && alias mpsyt='mpsyt; reset_title'
[[ -x $(command -v tmuxinator) ]] && alias mux=tmuxinator

if [[ -x /Applications/VLC.app/Contents/MacOS/VLC && -x $(command -v reattach-to-user-namespace) ]]; then
  alias vlc="reattach-to-user-namespace /Applications/VLC.app/Contents/MacOS/VLC"
fi

if [[ -x $(command -v exa) ]]; then
  alias ls="exa"
  alias lsa="ls -a"
else
  alias ls="ls -Gp"
  alias lsa="ls -A"
fi

alias reset_title='printf "\e]0;$(hostname)\a"'
alias integrity='openssl dgst -sha384 -binary | openssl enc -base64 -A'
