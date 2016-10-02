#! /bin/bash

# NAME          : oranchelo-tools-config
# DESCRIPTION   : Show and manipulate configuration file
# AUTHOR        : Madh93 (Miguel Hernandez)
# VERSION       : 0.1.0
# LICENSE       : GNU General Public License v3
# USAGE         : bash oranchelo-tools-config.sh


# INCLUDE
source $( cd "$( dirname "$0" )" && pwd )/oranchelo-tools-utils.sh


# CONFIG
SCRIPT=$(basename $0 .sh)
menu_reset=1
menu_edit=1

# SOURCE CODE

config() {

  if ! workspace_exists ; then
    show_error "Oranchelo Workspace does not exist!"
    echo -e "\nRun $(show_info 'oranchelo-tools init') for create it."
    end
  fi

  # Reset config
  if [ $menu_reset -eq 0 ] ; then
    cp /usr/local/share/oranchelo-tools/config $DIR/config
    show_success "Config Reset done!"
  fi

  # Edit config
  if [ $menu_edit -eq 0 ] ; then
    if [ -z $EDITOR ] ; then
      nano $DIR/config
    else
      $EDITOR $DIR/config
    fi
    show_success "Config Edit done!"
  fi

  # Show config
  if [[ $menu_reset -eq 1 ]] && [[ $menu_edit -eq 1 ]]; then
    cat $DIR/config
  fi
}

show_help() {

  echo -e "\n$SCRIPT: initalize build directory for $ORANCHELO.\n"
  echo -e "Usage: $SCRIPT [options]\n"
  echo -e "Options:"
  echo "  -r, --reset   Load default configuration file"
  echo "  -e, --edit    Edit configuration file"
  echo "  -h, --help    Print help"
  exit 0
}


# MAIN
while [ "$1" != "" ]; do
  case "$1" in
    -r | --reset)
      menu_reset=0
      ;;
    -e | --edit)
      menu_edit=0
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

config
