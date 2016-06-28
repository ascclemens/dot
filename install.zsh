for file in `ls files/*`; do
  name=`basename $file`
  if [[ -e ~/.$name ]]; then
    echo "~/.$name already existed, so no action was taken."
  else
    ln -s "$(realpath $file)" "$(realpath -m ~/.$name)"
    echo "$file symlinked to ~/.$name"
  fi
done
