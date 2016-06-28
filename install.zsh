force="false"
remove_old="false"
while getopts fr opt; do
  case $opt in
    f)
      force="true"
      ;;
    r)
      remove_old="true"
  esac
done

for file in `ls files/*`; do
  name=`basename $file`
  if "$remove_old" == "true"; then
    if [[ -e ~/.${name}_old ]]; then
      rm -f ~/.${name}_old
      echo "Removed ~/.${name}_old."
    fi
  elif [[ -e ~/.$name && "$force" != "true" ]]; then
    echo "~/.$name already existed, so no action was taken."
  else
    if [[ -e ~/.$name ]]; then
      mv ~/.$name ~/.${name}_old
      echo "Moved ~/.$name to ~/.${name}_old."
    fi
    ln -s $(realpath $file) $(realpath -m ~/.$name)
    echo "$file symlinked to ~/.$name"
  fi
done
