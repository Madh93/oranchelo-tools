#! /bin/bash

# NAME          : oranchelo-tools-utils
# DESCRIPTION   : Basic utils for oranchelo-tools
# AUTHOR        : Madh93 (Miguel Hernandez)
# VERSION       : 0.0.1
# LICENSE       : GNU General Public License v3
# USAGE         :


# UTILS
ORANCHELO="oranchelo-icon-theme"
NAME_DIR="oranchelo-workspace"
DIR="$HOME/$NAME_DIR"

# Output color: BLUE
show_info() {
  echo -e "\033[1;34m$@\033[0m"
}

# Output color: GREEN
show_success() {
  echo -e "\033[1;32m$@\033[0m"
}

# Output color: RED
show_error() {
  echo -e "\033[1;31m$@\033[0m"
}

end() {
  echo -e "\nExiting...\n"
  exit 0
}

mk_dir() {
  mkdir -p $1
  show_success "\tcreate $(show_info ${1#$HOME/})"
}

mk_file() {
  touch $1
  show_success "\tcreate $(show_info ${1#$HOME/})"
}

workspace_exists() {
  if [[ -d "$DIR" ]] && [[ -n "$DIR" ]] ; then
    return 0
  else
    return 1
  fi
}
