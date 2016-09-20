#! /bin/bash

# NAME          : oranchelo-tools-update
# DESCRIPTION   : Update local releases of oranchelo-icon-theme
# AUTHOR        : Madh93 (Miguel Hernandez)
# VERSION       : 0.0.1
# LICENSE       : GNU General Public License v3
# USAGE         : bash oranchelo-tools-update.sh


# INCLUDE
source $( cd "$( dirname "$0" )" && pwd )/oranchelo-tools-utils.sh


# CONFIG
SCRIPT=$(basename $0 .sh)
menu_force=1


# SOURCE CODE

update() {

  if ! workspace_exists ; then
    show_error "Oranchelo Workspace does not exist!"
    echo -e "\nRun $(show_info 'oranchelo-tools-init') for create it."
    end
  fi

  # Get last release
  releases=$(curl -i https://api.github.com/repos/OrancheloTeam/oranchelo-icon-theme/tags 2>&1)
  release_version=$(echo "${releases}" | grep name | head -1 | cut -d '"' -f4 | cut -c 2-)
  release_targz=$(echo "${releases}" | grep tarball | head -1 | cut -d '"' -f4)

  # Update if doesn't exist or --force-update
  if [[ -f "$DIR/sources/$release_version.tar.gz" ]] && [[ $menu_force -eq 1 ]]; then
    echo "Nothing to do: last release downloaded."
  else
    wget $release_targz -O $DIR/sources/$release_version.tar.gz
    echo -e "Updated to a new Oranchelo Icon Theme version:\t $(show_info $release_version)"
  fi
}

show_help() {

  echo -e "\n$SCRIPT: update local releases of $ORANCHELO.\n"
  echo -e "Usage: $SCRIPT [options]\n"
  echo -e "Options:"
  echo "  -f, --force   Overwrite existing local releases"
  echo "  -h, --help    Print help"
}


# MAIN
while [ "$1" != "" ]; do
  case "$1" in
    -f | --force)
      menu_force=0
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

update
