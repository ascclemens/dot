if [ ! -x "$(command -v java)" ]; then
  java() {
    local sudo='sudo'
    for group in $(groups); do
      [ "$group" = 'docker' ] && sudo=''
    done
    "$sudo" docker run \
      --rm \
      -it \
      -v "$(pwd)":"$(pwd)" \
      openjdk:latest \
      /bin/sh -c "cd \"$(pwd)\"; groupadd \"$USER\" -g \"$GID\"; useradd \"$USER\" -d \"$HOME\" -g \"$GID\" -u \"$UID\"; chown \"$USER:$USER\" \"$HOME\"; su \"$USER\" -c 'java $*'"
  }

  xjava() {
    local sudo='sudo'
    for group in $(groups); do
      [ "$group" = 'docker' ] && sudo=''
    done
    "$sudo" docker run \
      --rm \
      -it \
      -v "$(pwd)":"$(pwd)" \
      -v /tmp/.X11-unix:/tmp/.X11-unix \
      -e DISPLAY="$DISPLAY" \
      openjdk:latest \
      /bin/sh -c "cd \"$(pwd)\"; groupadd \"$USER\" -g \"$GID\"; useradd \"$USER\" -d \"$HOME\" -g \"$GID\" -u \"$UID\"; chown \"$USER:$USER\" \"$HOME\"; su \"$USER\" -c 'java $*'"
  }
fi
