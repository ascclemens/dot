###########
# Prompts #
###########

export PROMPT="$(~/.prompt/prompt PROMPT)"
export RPROMPT="$(~/.prompt/prompt RPROMPT)"

function rust_prompt_info {
  if [[ -e ./Cargo.toml || -e ./Cargo.lock && -e $(which rustc) ]]; then
    echo "$(rustc --version | cut -d ' ' -f 2) "
  fi
}

function git_dirty {
  [[ $(git diff --shortstat 2> /dev/null | tail -n1) != "" ]] && echo "*"
}

function git_status {
  if [[ "x$(git_dirty)" == "x" ]]; then
    echo "%{$FG[002]%}"
  else
    echo "%{$FG[009]%}"
  fi
}

function git_spark {
  if [[ "x$(git status 2> /dev/null)" != "x" ]]; then
    echo " $(git freq $(date '+%Y-%m-%d') -7 | spark)"
  fi
}

function update_git_color {
  ZSH_THEME_GIT_PROMPT_PREFIX=" $(git_status)"
  ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}$(git_spark)"
}

ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""

function echo_blank() {
  echo
}

precmd_functions+=echo_blank
precmd_functions+=update_git_color
