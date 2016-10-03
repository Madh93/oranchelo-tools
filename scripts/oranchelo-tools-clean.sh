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
menu_all=1

# SOURCE CODE

clean_build() {

  if ! workspace_exists ; then
    show_error "Oranchelo Workspace does not exist!"
    echo -e "\nRun $(show_info 'oranchelo-tools init') for create it."
    end
  fi

  echo -e "\nCleaning...\n"

  rm -rf $DIR/build/deb/*
  rm -rf $DIR/build/ppa/*
  rm -rf $DIR/build/rpm/*
  # Remove sources and config too
  if [ $menu_all -eq 0 ] ; then
    rm -rf $DIR/sources/*
    rm -rf $DIR/config
  fi

  show_success "Oranchelo Workspace clean!\n"
}

show_help() {

  echo -e "\n$SCRIPT: initalize build directory for $ORANCHELO.\n"
  echo -e "Usage: $SCRIPT [options]\n"
  echo -e "Options:"
  echo "  -a, --all     Remove all stored sources and config"
  echo "  -h, --help    Print help"
  exit 0
}


# MAIN
while [ "$1" != "" ]; do
  case "$1" in
    -a | --all)
      menu_all=0
      ;;
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

clean_build
