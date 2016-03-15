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
PKGS_PUSHED_URL="https://raw.githubusercontent.com/Madh93/oranchelo-icon-theme/master/README.md"


# SOURCE CODE

update() {

  if ! workspace_exists ; then
    show_error "Oranchelo Workspace does not exist!"
    echo -e "\nRun $(show_info 'oranchelo-tools-init') for create it."
    end
  fi

  # Get last release
  releases=$(curl -i https://api.github.com/repos/Madh93/oranchelo-icon-theme/tags 2>&1)
  release_version=$(echo "${releases}" | grep name | head -1 | cut -d '"' -f4 | cut -c 2-)
  release_targz=$(echo "${releases}" | grep tarball | head -1 | cut -d '"' -f4)

  if [ -f "$DIR/sources/$release_version.tar.gz" ] ; then
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
  echo "  -h, --help    Print help"
}


# MAIN
case "$1" in
  -h | --help)
    show_help
    ;;
  "")
    update
    ;;
  *)
    echo -e "$SCRIPT: unknown argument.\nRun $(show_info '$SCRIPT -h') for usage."
    ;;
esac
