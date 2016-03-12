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

mk_dir() {
  mkdir -p $1
  show_success "\tcreate $(show_info ${1#$HOME/})"
}

mk_file() {
  touch $1
  show_success "\tcreate $(show_info ${1#$HOME/})"
}

create_tree() {

  if workspace_exists ; then
    show_error "Oranchelo Workspace already exists!"
    end
  fi
  
  echo -e "\nInitializing...\n"

  mk_dir "$DIR"
  mk_file "$DIR/config"
  mk_dir "$DIR/sources"
  mk_dir "$DIR/deb"
  mk_dir "$DIR/deb/EXAMPLE_oranchelo-X.Y.Z"
  mk_dir "$DIR/deb/EXAMPLE_oranchelo-X.Y.Z/14.04"
  mk_dir "$DIR/deb/EXAMPLE_oranchelo-X.Y.Z/14.04/bin"
  mk_dir "$DIR/deb/EXAMPLE_oranchelo-X.Y.Z/14.04/config"
  mk_file "$DIR/deb/EXAMPLE_oranchelo-X.Y.Z/14.04/config/changelog"
  mk_file "$DIR/deb/EXAMPLE_oranchelo-X.Y.Z/14.04/config/control"
  mk_file "$DIR/deb/EXAMPLE_oranchelo-X.Y.Z/14.04/config/copyright"
  mk_file "$DIR/deb/EXAMPLE_oranchelo-X.Y.Z/14.04/config/postinst"
  mk_file "$DIR/deb/EXAMPLE_oranchelo-X.Y.Z/14.04/config/prerm"
  mk_dir "$DIR/deb/EXAMPLE_oranchelo-X.Y.Z/14.04/deb"
  mk_dir "$DIR/rpm"
  mk_dir "$DIR/rpm/EXAMPLE_oranchelo-X.Y.Z"
  mk_dir "$DIR/rpm/EXAMPLE_oranchelo-X.Y.Z/specs"
  mk_file "$DIR/rpm/EXAMPLE_oranchelo-X.Y.Z/specs/oranchelo-icon-theme.spec"
  mk_dir "$DIR/rpm/EXAMPLE_oranchelo-X.Y.Z/sources"
  mk_dir "$DIR/rpm/EXAMPLE_oranchelo-X.Y.Z/build"
  mk_dir "$DIR/rpm/EXAMPLE_oranchelo-X.Y.Z/rpm"

  echo -e "\nInitialized Oranchelo Workspace in $DIR\n"
}

show_help() {

  echo -e "\n$SCRIPT: initalize build directory for oranchelo-icon-theme.\n"
  echo -e "Usage: $SCRIPT [options]\n"
  echo -e "Options:"
  echo "  -f, --force   Remove the previous workspace"
  echo "  -h, --help    Print help"
}


# MAIN
case "$1" in 
  -f | --force)
    rm -rf $DIR
    create_tree
    ;;
  -h | --help)
    show_help
    ;;
  "")
    create_tree
    ;;
  *)
    echo -e "$SCRIPT: unknown argument.\nRun $(show_info '$SCRIPT -h') for usage."
    ;;
esac