#! /bin/bash

# NAME          : oranchelo-tools-clean
# DESCRIPTION   : Clean build directory
# AUTHOR        : Madh93 (Miguel Hernandez)
# VERSION       : 0.1.0
# LICENSE       : GNU General Public License v3
# USAGE         : bash oranchelo-tools-clean.sh


# INCLUDE
source $( cd "$( dirname "$0" )" && pwd )/oranchelo-tools-utils.sh


# CONFIG
SCRIPT=$(basename $0 .sh)

# SOURCE CODE

clean_build() {

  if ! workspace_exists ; then
    show_error "Oranchelo Workspace does not exist!"
    echo -e "\nRun $(show_info 'oranchelo-tools-init') for create it."
    end
  fi

  echo -e "\nInitializing...\n"

  rm -rf $DIR/build/deb/*
  rm -rf $DIR/build/rpm/*
  rm -rf $DIR/sources/*

  echo -e "Oranchelo Workspace clean!\n"
}

show_help() {

  echo -e "\n$SCRIPT: initalize build directory for $ORANCHELO.\n"
  echo -e "Usage: $SCRIPT [options]\n"
  echo -e "Options:"
  echo "  -h, --help    Print help"
}


# MAIN
case "$1" in
  -h | --help)
    show_help
    ;;
  "")
    clean_build
    ;;
  *)
    echo -e "$SCRIPT: unknown argument.\nRun $(show_info '$SCRIPT -h') for usage."
    ;;
esac
