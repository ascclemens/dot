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
