#############
# Functions #
#############

# mkdir, then cd to it
mkdircd() {
  mkdir -p "$*";
  cd "$*";
}

# move a file and leave a symbolic link in its wake
mvln() {
  mv $1 $2
  ln -s $(realpath $2) $(realpath $1);
}

# mostly unnecessary double strip
sstrip() {
  if [[ $(uname) == 'Darwin' ]]; then
    strip -S "$*" && strip "$*";
  else
    strip -s "$*" && strip "$*";
  fi
}

# undollar
\$() { $@ }

#
# Defines transfer alias and provides easy command line file and folder sharing.
#
# Authors:
#   Remco Verhoef <remco@dutchcoders.io>
#
transfer() {
  # check arguments
  if [ $# -eq 0 ];
  then
    echo "No arguments specified. Usage:\necho transfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"
    return 1
  fi

  # get temporarily filename, output is written to this file show progress can be showed
  tmpfile=$( mktemp -t transferXXX )

  # upload stdin or file
  file=$1

  if tty -s;
  then
    basefile=$(basename "$file" | sed -e 's/[^a-zA-Z0-9._-]/-/g')

    if [ ! -e $file ];
    then
      echo "File $file doesn't exist."
      return 1
    fi

    if [ -d $file ];
    then
      # zip directory and transfer
      zipfile=$( mktemp -t transferXXX.zip )
      cd $(dirname $file) && zip -r -q - $(basename $file) >> $zipfile
      curl --progress-bar --upload-file "$zipfile" "https://transfer.sh/$basefile.zip" >> $tmpfile
      rm -f $zipfile
    else
      # transfer file
      curl --progress-bar --upload-file "$file" "https://transfer.sh/$basefile" >> $tmpfile
    fi
  else
    # transfer pipe
    curl --progress-bar --upload-file "-" "https://transfer.sh/$file" >> $tmpfile
  fi

  # cat output link
  cat $tmpfile

  # cleanup
  rm -f $tmpfile
}
