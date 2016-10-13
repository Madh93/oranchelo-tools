#! /bin/bash

# NAME          : oranchelo-tools-upgrade
# DESCRIPTION   : Upgrade oranchelo-tools
# AUTHOR        : Madh93 (Miguel Hernandez)
# VERSION       : 0.1.0
# LICENSE       : GNU General Public License v3
# USAGE         : bash oranchelo-tools-upgrade.sh


# INCLUDE
source $( cd "$( dirname "$0" )" && pwd )/oranchelo-tools-utils.sh


# CONFIG
SCRIPT=$(basename $0 .sh)
menu_all=1

# SOURCE CODE

upgrade() {
  show_info "Downloading last sources..."
  git clone https://github.com/Madh93/oranchelo-tools /tmp/oranchelo-tools
  show_info "Compiling oranchelo-tools..."
  make -C /tmp/oranchelo-tools
  show_info "Installing oranchelo-tools..."
  sudo make install -C /tmp/oranchelo-tools
  rm -rf /tmp/oranchelo-tools

  show_success "\nOranchelo Tools upgraded!\n"
}

show_help() {

  echo -e "\n$SCRIPT: upgrade oranchelo-tools.\n"
  echo -e "Usage: $SCRIPT [options]\n"
  echo -e "Options:"
  echo "  -h, --help    Print help"
  exit 0
}


# MAIN
while [ "$1" != "" ]; do
  case "$1" in
    -h | --help)
      show_help
      ;;
    *)
      echo -e "$SCRIPT: unknown argument '$1'.\nRun $(show_info '$SCRIPT -h') for usage."
      exit 0
      ;;
  esac
  shift
done

upgrade
