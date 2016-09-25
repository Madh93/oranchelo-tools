#! /bin/bash

# NAME          : oranchelo-tools-status
# DESCRIPTION   : Check available release of oranchelo-icon-theme
# AUTHOR        : Madh93 (Miguel Hernandez)
# VERSION       : 0.1.0
# LICENSE       : GNU General Public License v3
# USAGE         : bash oranchelo-tools-status.sh


# INCLUDE
source $( cd "$( dirname "$0" )" && pwd )/oranchelo-tools-utils.sh


# CONFIG
SCRIPT=$(basename $0 .sh)
PKGS_PUSHED_URL="https://raw.githubusercontent.com/OrancheloTeam/oranchelo-icon-theme/master/README.md"
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
  releases=$(curl -i https://api.github.com/repos/OrancheloTeam/oranchelo-icon-theme/tags 2>&1)
  release_version=$(echo "${releases}" | grep name | head -1 | cut -d '"' -f4 | cut -c 2-)

  show_status
}

show_status() {

  # Basic status
  if [ -f "$DIR/sources/$release_version.tar.gz" ] ; then
    echo "Nothing to do: last release downloaded."
  else
    echo -e "Available a new Oranchelo Icon Theme version:\t $(show_info $release_version)"
  fi

  # All status builds
  if [ $menu_all -eq 0 ] ; then
    show_all
  fi

  # Update local
  if [ $menu_update -eq 0 ] ; then
    update
  elif [ ! -f "$DIR/sources/$release_version.tar.gz" ] ; then
    echo -e "\nRun $(show_info 'oranchelo-tools update').\n"
  fi

}

show_all() {

  echo -e "\nStatus for each build...\n"
  pkgs_pushed="$(curl -i $PKGS_PUSHED_URL 2>&1)"

  printf "\t+------------------------------------+ \n"
  printf "\t| %-6s | %-6s | %-4s | %-4s |\n" "Package" "Version" "Built" "Pushed"
  printf "\t|---------|---------|-------|--------| \n"

  build_begin=$(grep -nH 'BEGINBUILD' $DIR/config | cut -d ':' -f2)
  build_end=$(grep -nH 'ENDBUILD' $DIR/config | cut -d ':' -f2)
  builds=$(cat $DIR/config | sed -n $((build_begin+1)),$((build_end-1))p | grep -v '^#')


  # DEB
  deb=$(echo "${builds}" | grep deb | tr -s ' |\t' ':')

  for pkg in $deb; do
    name=$(echo $pkg | cut -d ':' -f2)
    deb_name="$ORANCHELO_$release_version.ubuntu$name.1_all.deb"
    deb_path="$DIR/build/deb/$release_version/$name/deb/$deb_name"

    # Built package?
    if [ -f "$deb_path" ] ; then
      built=$(show_success "yes")
    else
      built=$(show_error "no!")
    fi

    # Pushed package?
    if [[ $pkgs_pushed == *$deb_name* ]] ; then
      pushed=$(show_success "yes")
    else
      pushed=$(show_error "no!")
    fi

    printf "\t| %-7s | %-7s | %-5s   | %-6s    |\n" "DEB" $name $built $pushed
  done


  # RPM
  rpm=$(echo "${builds}" | grep rpm | tr -s ' |\t' ':')

  for pkg in $rpm; do
    rpm_name="$ORANCHELO-$release_version-1.fc23.noarch.rpm"
    rpm_path="$DIR/build/rpm/$release_version/rpm/$rpm_name"

    # Built package?
    if [ -f "$rpm_path" ] ; then
      built=$(show_success "yes")
    else
      built=$(show_error "no!")
    fi

    # Pushed package?
    if [[ $pkgs_pushed == *$rpm_name* ]] ; then
      pushed=$(show_success "yes")
    else
      pushed=$(show_error "no!")
    fi

    printf "\t| %-7s | %-7s | %-5s   | %-6s    |\n" "RPM" "-" $built $pushed
  done

  printf "\t+------------------------------------+ \n"
}

update() {
  # echo -e "\nRun $(show_info 'oranchelo-tools-update').\n"
  echo ""
}

show_help() {

  echo -e "\n$SCRIPT: check available release of $ORANCHELO.\n"
  echo -e "Usage: $SCRIPT [options]\n"
  echo -e "Options:"
  echo "  -a, --all     Show status for all builds"
  echo "  -u, --update  Check and update local releases"
  echo "  -h, --help    Print help"
  exit 0
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
      ;;
    *)
      echo -e "$SCRIPT: unknown argument '$1'.\nRun $(show_info '$SCRIPT -h') for usage."
      exit 0
      ;;
  esac
  shift
done

check_new_version
