#!/bin/sh
#!/bin/sh

# == Simple note management ==
# Author: Kyle Clemens (kyleclemens.com)
#
# This is a simple system for writing notes. Set $NOTES_PATH to where you want notes to be stored.
# The function works on basic sh and should work on other shells without issue. Use `note -h` for
# usage.
#
# The script will optionally use git when adding new files, automatically adding and committing the
# note if $NOTES_PATH is a git repository. The script will never pull or push, only add and commit.
#
# PGP encryption is backed by GPG and is only enabled if $NOTES_PATH/.keys exists. $NOTES_PATH/.keys
# should contain a newline-separated list of recipients (key IDs work well) to encrypt notes for.
# Note that adding a recipient after notes have been made won't yet re-encrypt previous notes.
#
# The edit line of the function can be changed if you don't want to eval the $EDITOR, but it depends
# on which shell you use. :)

# No trailing slash, please.
export NOTES_PATH="$HOME/notes"

note() {
  trap "find /tmp -maxdepth 1 -name 'note-plain.*' -delete" EXIT

  print_help() {
    echo 'note 0.2.0'
    echo '  Author: Kyle Clemens (kyleclemens.com)'
    echo
    echo 'note -p'
    echo '  Display $NOTES_PATH.'
    echo 'note search (-d) [string]'
    echo '  Search $NOTES_PATH for a note containing `string` in the title. If -d is specified, do'
    echo '  a deep search, searching contents. If notes are encrypted, they will be unencrypted and'
    echo '  search in memory, but this will take longer.'
    echo 'note insert (-d) [title]'
    echo '  Author a new note with the given title. If -d is specified, do not sort the note by'
    echo '  date (note will be made in the root of $NOTES_PATH).'
    echo 'note edit [path]'
    echo '  Edit a note given either its absoltue path or path relative to $NOTES_PATH,'
    echo '  optionally ending in `.txt`. This is really only useful if using git integration, as'
    echo '  this will auto-commit after editing.'
    echo 'note view [path]'
    echo '  Print a note to stdout. The path is specified in the same manner as `note edit`.'
    echo 'note delete [path]'
    echo '  Delete a note. The path is specified in the same manner as `note edit`.'
    echo 'note list'
    echo '  List all note paths relative to $NOTES_PATH.'
    echo 'note git [git parameters]'
    echo '  Run git in $NOTES_PATH.'
  }

  note_edit() {
    local src="$1"
    local dst="$2"
    local exists=0
    [ -f "$dst" ] && exists=1
    # ${=EDITOR} "$note_path" # uncomment for zsh
    # $EDITOR "$note_path" # uncomment for bash
    [ "$is_gpg" -eq "1" ] && [ "$exists" -eq "1" ] && gpg_decrypt_into "$dst" "$src"
    eval "$EDITOR \"$src\"" # comment if you uncomment one of the above
    if [ "$is_gpg" -eq "1" ]; then
      gpg_encrypt "$src" "$dst"
    else
      mv "$src" "$dst"
    fi

    if [ "$is_git" -eq "1" ]; then
      if [ "$title" = "" ]; then
        local title
        title=$(echo "$dst" | rev | cut -d'/' -f1 | cut -d'.' -f2- | rev)
      fi

      local message
      if [ "$exists" -eq 1 ]; then
        message="edit note: $title"
      else
        message="add note: $title"
      fi
      git_commit "$dst" "$message"
    fi
  }

  git_commit() {
    local note_path="$1"
    local message="$2"

    if [ "$is_git" -eq "1" ]; then
      git -C "$NOTES_PATH" add --all
      git -C "$NOTES_PATH" commit -m "$message"
    fi
  }

  gpg_encrypt() {
    local src="$1"
    local dst="$2"

    local args=""

    while read -r key; do
      args="-r $key $args"
    done < "$NOTES_PATH/.keys"

    gpg --encrypt --sign $args "$src"
    rm -f -- "$src"
    mv "$src.gpg" "$dst"
  }

  gpg_decrypt() {
    local note_path="$*"

    gpg --decrypt "$note_path"
  }

  gpg_decrypt_into() {
    local src="$1"
    local dst="$2"

    gpg --decrypt "$src" > "$dst"
  }

  temp_note() {
    local tmp
    if [ -x "$(command -v mktemp)" ]; then
      tmp=$(mktemp "${TMPDIR:-/tmp}/note-plain.XXXXXXX")
    else
      tmp=$(
        echo 'mkstemp(template)' |
          m4 -D template="${TMPDIR:-/tmp}/note-plain.XXXXXXX"
      )
    fi
    echo "$tmp"
  }

  fix_note_path() {
    local note_path
    case $* in
      /*) note_path=$* ;;
      *) note_path=$NOTES_PATH/$* ;;
    esac
    case $note_path in
      *.txt) ;;
      *) note_path=$note_path.txt ;;
    esac

    echo "$note_path"
  }

  if [ "$NOTES_PATH" = "" ]; then
    echo 'Please define $NOTES_PATH.'
    return 1
  fi

  local is_git=0
  local has_gpg=0
  local is_gpg=0
  [ -x "$(command -v git)" ] && [ -d "$NOTES_PATH/.git" ] && is_git=1
  [ -x "$(command -v gpg)" ] && has_gpg=1
  if [ -f "$NOTES_PATH/.keys" ]; then
    if [ "$has_gpg" -eq "1" ]; then
      is_gpg=1
    else
      echo 'WARNING: The notes path specifies a list of PGP keys, but GPG is not installed, so notes'
      echo '         will not be encrypted.'
      echo 'Press enter to continue or ^C to abort.'
      read -r
    fi
  fi

  local use_date=1
  local subcommand="$1"

  if [ "$subcommand" = "" ] || [ "$subcommand" = "help" ] || [ "$subcommand" = "--help" ]; then
    print_help
    return 0
  fi

  case "${subcommand}" in
    edit)
      shift 1
      local note_path
      note_path=$(fix_note_path "$*")

      if [ ! -f "$note_path" ]; then
        echo "That note does not exist."
        return 6
      fi

      note_edit "$(temp_note)" "$note_path"
      return 0
      ;;
    view)
      shift 1
      local note_path
      note_path=$(fix_note_path "$*")

      if [ ! -f "$note_path" ]; then
        echo "That note does not exist."
        return 7
      fi

      if [ "$is_gpg" -eq "1" ]; then
        gpg_decrypt "$note_path"
      else
        cat "$note_path"
      fi

      return 0
      ;;
    search)
      shift 1
      local deep=0
      while getopts "d" o; do
        case "${o}" in
          d) deep=1 ;;
          *)
            echo 'Unknown flag.'
            return 1
            ;;
        esac
      done
      shift $((OPTIND-1))

      local query="$*"
      if [ "$query" = "" ]; then
        echo "Please specify a string to search for."
        return 5
      fi

      if [ "$deep" -eq "1" ]; then
        if [ "$is_gpg" -eq "1" ]; then
          find "$NOTES_PATH" -name "*.txt" -type f | while IFS='' read -r note_path; do
            exec 4>/dev/null
            local output=''
            output=$(gpg --status-fd 4 --logger-fd 4 --quiet --batch --decrypt "$note_path" | grep --colour=always "$query")
            exec 4>&-
            [ "$output" != "" ] && echo "$(tput setaf 4)${note_path}$(tput sgr0):" && echo "$output"
          done
        else
          grep -R "$query" "$NOTES_PATH"
        fi
      else
        find "$NOTES_PATH" -name "*${query}*.txt" -type f
      fi

      return 0
      ;;
    delete)
      shift 1
      local note_path
      note_path=$(fix_note_path "$*")

      if [ ! -f "$note_path" ]; then
        echo "That note does not exist."
        return 7
      fi

      rm "$note_path"

      local parent="${note_path%/*}"
      rmdir -p --ignore-fail-on-non-empty "$parent"

      if [ "$is_git" -eq "1" ]; then
        local title
        title=$(echo "$note_path" | rev | cut -d'/' -f1 | cut -d'.' -f2- | rev)
        git_commit "$note_path" "remove note: $title"
      fi
      return 0
      ;;
    list)
      find "$NOTES_PATH" -type f -name '*.txt' | while IFS="" read -r note_path; do
        local np="${note_path#"$NOTES_PATH/"}"
        np="${np%".txt"}"
        echo "$np"
      done
      return 0
      ;;
    insert)
      shift 1
      while getopts "d" o; do
        case "${o}" in
          d) use_date=0 ;;
          *)
            echo "Unknown flag."
            return 4
            ;;
        esac
      done
      shift $((OPTIND-1))

      if [ "$EDITOR" = "" ]; then
        echo 'Please define $EDITOR.'
        return 3
      fi

      local title="$*"
      if [ "$title" = "" ]; then
        echo "Please provide a note name."
        return 2
      fi

      local final_path
      if [ "$use_date" -eq "1" ]; then
        local subdir
        subdir=$(date +'%Y/%m/%d')

        final_path="$NOTES_PATH/$subdir"
      else
        final_path="$NOTES_PATH"
      fi

      local note_path="$final_path/$title.txt"

      local parent="${note_path%/*}"
      mkdir -p "$parent"

      note_edit "$(temp_note)" "$note_path"

      return 0
      ;;
    git)
      shift 1
      git -C "$NOTES_PATH" "$@"
      return 0
  esac

  while getopts "hp" o; do
    case "${o}" in
      h)
        print_help
        return 0
        ;;
      p)
        echo "$NOTES_PATH"
        return 0
        ;;
      *)
        echo "Unknown flag."
        return 4
        ;;
    esac
  done

  echo "Unknown subcommand."
  return 4
}
