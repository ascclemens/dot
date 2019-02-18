#!/bin/sh

gpg-alias() {
  local output=''

  case "$*" in
    main) output='7AFEC6C933D82E9DE3762A8BB5260624B47A890B' ;;
    protonmail) output='D9C72EA2C779B4E8F8A1001628CA7635E216667B' ;;
    kashike) output='99B06D94C8F2EEA255534A8AC217DFC4DF0226A5' ;;
    lol768) output='12AA0AC17FA700703F9BC76F9EA7187835735CC6' ;;
  esac

  if [ "$output" = "" ]; then
    >&2 echo 'no such alias'
    return 1
  else
    echo "$output"
  fi
}
