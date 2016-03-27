#! /bin/bash

# NAME          : oranchelo-tools-build
# DESCRIPTION   : Build ditribution package for oranchelo-icon-theme
# AUTHOR        : Madh93 (Miguel Hernandez)
# VERSION       : 0.0.1
# LICENSE       : GNU General Public License v3
# USAGE         : bash oranchelo-tools-build.sh


# INCLUDE
source $( cd "$( dirname "$0" )" && pwd )/oranchelo-tools-utils.sh


# CONFIG
SCRIPT=$(basename $0 .sh)
menu_all=1


# SOURCE CODE



show_help() {

  echo -e "\n$SCRIPT: build ditribution package for $ORANCHELO.\n"
  echo -e "Usage: $SCRIPT [options]\n"
  echo -e "Options:"
  echo "  -a, --all     Build all pending packages"
  echo "  -h, --help    Print help"
}


# MAIN
case "$1" in 
  -a | --all)
    menu_all=0
    ;;
  -h | --help)
    show_help
    ;;
  *)
    echo -e "$SCRIPT: unknown argument.\nRun $(show_info '$SCRIPT -h') for usage."
    ;;
esac