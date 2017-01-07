#! /bin/bash

# NAME          : oranchelo-tools-init
# DESCRIPTION   : Initialize build directory
# AUTHOR        : Madh93 (Miguel Hernandez)
# VERSION       : 0.1.0
# LICENSE       : GNU General Public License v3
# USAGE         : bash oranchelo-tools-init.sh


# INCLUDE
source $( cd "$( dirname "$0" )" && pwd )/oranchelo-tools-utils.sh


# CONFIG
SCRIPT=$(basename $0 .sh)

# SOURCE CODE

create_tree() {

  if workspace_exists ; then
    show_error "Oranchelo Workspace already exists!"
    end
  fi

  echo -e "\nInitializing...\n"

  mk_dir "$DIR"
  mk_file "$DIR/config" "/usr/local/share/oranchelo-tools/config"
  mk_dir "$DIR/sources"
  mk_dir "$DIR/build/deb"
  mk_dir "$DIR/build/ppa"
  mk_dir "$DIR/build/rpm"

  echo -e "\nInitialized Oranchelo Workspace in $DIR\n"
}

show_help() {

  echo -e "\n$SCRIPT: initalize build directory for $ORANCHELO.\n"
  echo -e "Usage: oranchelo-tools init [options]\n"
  echo -e "Options:"
  echo "  -f, --force   Remove the previous workspace"
  echo "  -h, --help    Print help"
  exit 0
}


# MAIN
while [ "$1" != "" ]; do
  case "$1" in
    -f | --force)
      rm -rf $DIR
      ;;
    -h | --help)
      show_help
      ;;
    *)
      echo -e "$SCRIPT: unknown argument '$1'.\nRun $(show_info oranchelo-tools init -h) for usage."
      exit 0
      ;;
  esac
  shift
done

create_tree
