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

  if [ -x "$(command -v x11docker)" ]; then
    xjava() {
      local agent_arg=''
      [ -x "$(command -v nxagent)" ] && agent_arg='--nxagent'
      [ -x "$(command -v xpra)" ] && agent_arg='--xpra'
      x11docker \
      "$agent_arg" \
      -- \
      --rm -v "$(pwd):$(pwd)" \
      -- \
      openjdk:latest \
      /bin/sh -c "cd \"$(pwd)\"; java $*"
    }
  fi
fi
