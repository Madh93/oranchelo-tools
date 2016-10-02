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
menu_deb=1
menu_rpm=1


# SOURCE CODE

build() {

  if ! workspace_exists ; then
    show_error "Oranchelo Workspace does not exist!"
    echo -e "\nRun $(show_info 'oranchelo-tools init') for create it."
    end
  fi

  release=$(ls $DIR/sources | grep tar.gz | sed 's/.tar.gz//')

  if [ -z "$release" ] ; then
    show_error "Oranchelo sources do not exist!"
    echo -e "\nRun $(show_info 'oranchelo-tools update') for download it."
    end
  fi

  # Check build type
  if [ $menu_deb -eq 0 ] ; then
    target=$(cat $DIR/config | grep -v "#" | grep deb | tr -s ' |\t' ':')
  elif [ $menu_rpm -eq 0 ] ; then
    target=$(cat $DIR/config | grep -v "#" | grep rpm | tr -s ' |\t' ':')
  else
    target=$(cat $DIR/config | grep -v "#" | grep "deb\|rpm" | tr -s ' |\t' ':')
  fi

  build_packages
}

build_packages() {

  for pkg in $target; do
    if [[ "$pkg" == *"deb"* ]]; then
      build_deb
    elif [[ "$pkg" == *"rpm"* ]]; then
      build_rpm
    else
      echo -e "\nUnknown package: $pkg"
      exit
    fi
  done
}

build_deb() {

  version=$(echo $pkg | cut -d ':' -f2)
  codename=$(echo $pkg | cut -d ':' -f3)
  build_path="$DIR/build/deb/$release/$version"

  show_info "\nBuilding... $ORANCHELO $release for Ubuntu $version\n"
  mk_dir "$build_path"
  mk_dir "$build_path/bin"
  mk_dir "$build_path/config"
  mk_dir "$build_path/config/changelog" "/usr/local/share/oranchelo-tools/deb/config/changelog"
  mk_dir "$build_path/config/control" "/usr/local/share/oranchelo-tools/deb/config/control"
  mk_dir "$build_path/config/copyright" "/usr/local/share/oranchelo-tools/deb/config/copyright"
  mk_dir "$build_path/config/postinst" "/usr/local/share/oranchelo-tools/deb/config/postinst"
  mk_dir "$build_path/config/prerm" "/usr/local/share/oranchelo-tools/deb/config/prerm"
  mk_dir "$build_path/deb"

  show_info "\nExtracting and copying sources..."
  tar -zxf $DIR/sources/$release.tar.gz -C $build_path/bin
  cp -rf $build_path/bin/Oranchelo*/Oranchelo* $build_path/bin
  rm -rf $build_path/bin/OrancheloTeam*

  show_info "\nGenerating build configuration..."
  # CHANGELOG
  sed -i "s/.RELEASE/$release/" $build_path/config/changelog
  sed -i "1s/.VERSION/$version/" $build_path/config/changelog
  sed -i "1s/.CODENAME/$codename/" $build_path/config/changelog
  sed -i "5s/.DATE/$(LANG=en_US date +'%a, %d %b %Y %T')/" $build_path/config/changelog

  # CONTROL
  sed -i "10s/.RELEASE/$release/" $build_path/config/control
  sed -i "10s/.VERSION/$version/" $build_path/config/control

  # COPYRIGHT
  sed -i "6s/.YEAR/$(date +'%Y')/" $build_path/config/copyright

  show_info "\nBuilding package..."
  # Create deb directory and copy sources
  prepwd=$(pwd)
  debdir="$build_path/$ORANCHELO-$release~ubuntu$version.1"
  mkdir $debdir
  cp -r $build_path/bin $debdir

  # Create packaging skeleton (debian/*)
  cd $debdir
  yes | dh_make -s --indep --createorig

  # Remove make calls
  grep -v makefile debian/rules > debian/rules.new
  mv debian/rules.new debian/rules

  # Copy config files
  mv $build_path/config/changelog debian/changelog
  mv $build_path/config/control debian/control
  mv $build_path/config/copyright debian/copyright
  mv $build_path/config/install debian/install
  mv $build_path/config/postinst debian/postinst

  # Remove the example files
  rm debian/*.ex debian/*.EX debian/README.*

  # Build package
  debuild

  cd $prepwd

  show_success "\n$ORANCHELO $release for Ubuntu $version built!"
}

build_rpm() {
  echo "this is a rpm man"
}

show_help() {

  echo -e "\n$SCRIPT: build ditribution package for $ORANCHELO.\n"
  echo -e "Usage: $SCRIPT [options]\n"
  echo -e "Options:"
  echo "  -d, --deb     Build pending DEB packages"
  echo "  -r, --rpm     Build pending RPM packages"
  echo "  -h, --help    Print help"
  exit 0
}


# MAIN
while [ "$1" != "" ]; do
  case "$1" in
    -d | --deb)
      menu_deb=0
      ;;
    -r | --rpm)
      menu_rpm=0
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

build
