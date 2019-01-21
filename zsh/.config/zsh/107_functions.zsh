#############
# Functions #
#############

# mkdir, then cd to it
mkdircd() {
  mkdir -p "$*";
  cd "$*";
}

# undollar
\$() { $@ }


function ec2_ssh() {
  local ec2_ip
  local curr_ip

  echo "Getting current SSH IP in $2"
  ec2_ip=$(aws --region "$1" ec2 describe-security-groups --group-name "$2" | jq -r '.SecurityGroups[0].IpPermissions | map(select(.FromPort == 22)) | .[0].IpRanges[0].CidrIp')

  echo "Getting current IP"
  curr_ip="$(curl -4sSfL icanhazip.com | tr -d '\n')/32"

  echo "Revoking $ec2_ip in $2"
  aws ec2 revoke-security-group-ingress --region "$1" --group-name "$2" --protocol tcp --port 22 --cidr "$ec2_ip"

  echo "Authorizing $curr_ip in $2"
  aws ec2 authorize-security-group-ingress --region "$1" --group-name "$2" --protocol tcp --port 22 --cidr "$curr_ip"

  echo "Done"
}

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
# PGP encryption is backed by GPG and is only enabled if $NOTES_PATH/keys exists. $NOTES_PATH/keys
# should contain a newline-separated list of recipients (key IDs work well) to encrypt notes for.
# Note that adding a recipient after notes have been made won't yet re-encrypt previous notes.
#
# The edit line of the function can be changed if you don't want to eval the $EDITOR, but it depends
# on which shell you use. :)

export NOTES_PATH="$HOME/notes"

note() {
  note_edit() {
    local note_path="$*"
    local exists=0
    [ -f "$note_path" ] && exists=1
    # ${=EDITOR} "$note_path" # uncomment for zsh
    # $EDITOR "$note_path" # uncomment for bash
    [ "$is_gpg" -eq "1" ] && [ "$exists" -eq "1" ] && gpg_decrypt_move "$note_path"
    eval "$EDITOR \"$note_path\"" # comment if you uncomment one of the above
    [ "$is_gpg" -eq "1" ] && gpg_encrypt "$note_path"

    if [ "$is_git" -eq "1" ]; then
      if [ "$title" = "" ]; then
        local title
        title=$(echo "$note_path" | rev | cut -d'/' -f1 | cut -d'.' -f2- | rev)
      fi

      git -C "$NOTES_PATH" add --all
      local message
      if [ "$exists" -eq 1 ]; then
        message="edit note: $title"
      else
        message="add note: $title"
      fi
      git -C "$NOTES_PATH" commit -m "$message"
    fi
  }

  gpg_encrypt() {
    local note_path="$*"

    local args=""

    while read -r key; do
      args="-r $key $args"
    done < "$NOTES_PATH/keys"

    gpg -e $args "$note_path"
    mv "$note_path.gpg" "$note_path"
  }

  gpg_decrypt() {
    local note_path="$*"

    gpg -d "$note_path"
  }

  gpg_decrypt_move() {
    local note_path="$*"

    gpg -d "$note_path" > "$note_path.plain"
    mv "$note_path.plain" "$note_path"
  }

  fix_note_path() {
    local note_path
    case $* in
      /*) note_path=$OPTARG ;;
      *) note_path=$NOTES_PATH/$OPTARG ;;
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
  if [ -f "$NOTES_PATH/keys" ]; then
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

  while getopts "hpds:e:v:" o; do
    case "${o}" in
      h)
        echo "note -p"
        echo '  Display $NOTES_PATH.'
        echo "note -s [string]"
        echo '  Search $NOTES_PATH for a note containing `string` in the title.'
        echo "note (-d) [title]"
        echo '  Author a new note with the given title. If -d is specified, do not sort the note by'
        echo '  date (note will be made in the root of $NOTES_PATH).'
        echo "note -e [path]"
        echo '  Edit a note given either its absoltue path or path relative to $NOTES_PATH,'
        echo '  optionally ending in `.txt`. This is really only useful if using git integration, as'
        echo "  this will auto-commit after editing."
        echo "note -v [path]"
        echo '  Print a note to stdout. The path is specified in the same manner as `note -e`.'
        return 0
        ;;
      p)
        echo "$NOTES_PATH"
        return 0
        ;;
      s)
        if [ "${OPTARG}" = "" ]; then
          echo "Please specify a string to search for."
          return 5
        fi

        find "$NOTES_PATH" -name "*$OPTARG*.txt" -type f
        return 0
        ;;
      d) use_date=0 ;;
      e)
        local note_path
        note_path=$(fix_note_path "$OPTARG")

        if [ ! -f "$note_path" ]; then
          echo "That note does not exist."
          return 6
        fi

        note_edit "$note_path"
        return 0
        ;;
      v)
        local note_path
        note_path=$(fix_note_path "$OPTARG")

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

    mkdir -p "$final_path"
  else
    final_path="$NOTES_PATH"
  fi

  local note_path="$final_path/$title.txt"

  note_edit "$note_path"
}
