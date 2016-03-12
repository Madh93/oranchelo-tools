#! /bin/bash

# NAME          : oranchelo-tools-status
# DESCRIPTION   : Check available release of oranchelo-icon-theme
# AUTHOR        : Madh93 (Miguel Hernandez)
# VERSION       : 0.0.1 
# LICENSE       : GNU General Public License v3   
# USAGE         : bash oranchelo-tools-status.sh 


# INCLUDE
source $( cd "$( dirname "$0" )" && pwd )/oranchelo-tools-utils.sh


# CONFIG
SCRIPT=$(basename $0 .sh)
releases=""
release_version=""
menu_all=1
menu_update=1

# SOURCE CODE

check_new_version() {
  
  if ! workspace_exists ; then
    show_error "Oranchelo Workspace does not exist!"
    echo -e "\nRun $(show_info 'oranchelo-tools-init') for create it."
    end
  fi

  # Get last release
  echo -e "Checking available release..."
  releases=$(curl -i https://api.github.com/repos/Madh93/oranchelo-icon-theme/tags 2>&1)
  release_version=$(echo "${releases}" | grep name | head -1 | cut -d '"' -f4)

  show_status
}

show_status() {

  if [ -f "$DIR/sources/$release_version.tar.gz" ] ; then
    echo "Nothing to do: last release downloaded."
  else
    echo -e "Available a new Oranchelo Icon Theme version:\t $(show_info $release_version)"
    echo -e "\nRun $(show_info 'oranchelo-tools-update').\n"
  fi
}

update() {
  echo -e "\nRun $(show_info 'oranchelo-tools-update').\n"
}

show_help() {

  echo -e "\n$SCRIPT: check available release of oranchelo-icon-theme.\n"
  echo -e "Usage: $SCRIPT [options]\n"
  echo -e "Options:"
  echo "  -a, --all     Show status for all builds"
  echo "  -u, --update  Check and update local releases"
  echo "  -h, --help    Print help"
}


# MAIN
while [ "$1" != "" ]; do
  case "$1" in 
    -a | --all)
      menu_all=0
      ;;    
    -u | --update)
      menu_update=0
      ;;  
    -h | --help)
      show_help
      exit 0
      ;;
    *)
      echo -e "$SCRIPT: unknown argument '$1'.\nRun $(show_info '$SCRIPT -h') for usage."
      exit 0
      ;;
  esac
  shift
done

check_new_version