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
menu_ppa=1
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
  elif [ $menu_ppa -eq 0 ] ; then
    target=$(cat $DIR/config | grep -v "#" | grep ppa | tr -s ' |\t' ':')
  elif [ $menu_rpm -eq 0 ] ; then
    target=$(cat $DIR/config | grep -v "#" | grep rpm | tr -s ' |\t' ':')
  else
    target=$(cat $DIR/config | grep -v "#" | grep "deb\|ppa\|rpm" | tr -s ' |\t' ':')
  fi

  build_packages
}

build_packages() {

  for pkg in $target; do
    if [[ "$pkg" == *"deb"* ]] || [[ "$pkg" == *"ppa"* ]]; then
      build_deb
    elif [[ "$pkg" == *"rpm"* ]]; then
      build_rpm
    else
      echo -e "\nUnknown package: $pkg"
      exit
    fi
  done

  show_success "\nAll packages built!"
}

build_deb() {

  version=$(echo $pkg | cut -d ':' -f2)
  codename=$(echo $pkg | cut -d ':' -f3)
  if [[ "$pkg" == *"deb"* ]]; then
    build_path="$DIR/build/deb/$release/$version"
  else
    build_path="$DIR/build/ppa/$release/$version"
  fi

  # Check if package is built
  if [ -f "$DIR/build/deb/$release/$version/deb/oranchelo-icon-theme_$release~ubuntu$version.1_all.deb" ]; then
    show_info "\n[DEB] $ORANCHELO $release for Ubuntu $version built yet..."
    return 0
  elif [ -f "$DIR/build/ppa/$release/$version/oranchelo-icon-theme_$release~ubuntu$version.1_source.changes" ]; then
    show_info "\n[PPA] $ORANCHELO $release for Ubuntu $version built yet..."
    return 0
  fi

  # Check DEB credentials
  if [ -z "$DEBFULLNAME" ] ; then
    show_error "\n\$DEBFULLNAME variable is empty!"
    exit 0
  fi
  if [ -z "$DEBEMAIL" ] ; then
    show_error "\n\$DEBEMAIL variable is empty!"
    exit 0
  fi

  show_info "\nBuilding... $ORANCHELO $release for Ubuntu $version\n"
  mk_dir "$build_path"
  mk_dir "$build_path/bin"
  mk_dir "$build_path/config"
  mk_dir "$build_path/config/changelog" "/usr/local/share/oranchelo-tools/deb/config/changelog"
  mk_dir "$build_path/config/control" "/usr/local/share/oranchelo-tools/deb/config/control"
  mk_dir "$build_path/config/copyright" "/usr/local/share/oranchelo-tools/deb/config/copyright"
  mk_dir "$build_path/config/install" "/usr/local/share/oranchelo-tools/deb/config/install"
  mk_dir "$build_path/config/postinst" "/usr/local/share/oranchelo-tools/deb/config/postinst"
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
  debdir="$build_path/$ORANCHELO-$release~ubuntu$version.1"
  mkdir $debdir
  cp -r $build_path/bin/* $debdir

  # Create packaging skeleton (debian/*)
  cd $debdir
  dh_make --indep --createorig

  # Remove make calls
  grep -v makefile debian/rules > debian/rules.new
  mv debian/rules.new debian/rules

  # Copy config files
  chmod -x $build_path/config/*
  cp $build_path/config/changelog debian/changelog
  cp $build_path/config/control debian/control
  cp $build_path/config/copyright debian/copyright
  cp $build_path/config/install debian/install
  cp $build_path/config/postinst debian/postinst

  # Remove the example files
  rm debian/*.ex debian/*.EX debian/README.*

  # Build package
  if [[ "$pkg" == *"deb"* ]]; then
    debuild
  else
    if [ -z "$ORANCHELO_GPG_KEY" ] ; then
      show_error "\n\$ORANCHELO_GPG_KEY variable is empty!"
      exit 0
    else
      debuild -k"${ORANCHELO_GPG_KEY}" -S
    fi
  fi

  # Move generated deb
  if [ "$?" == "0" ]; then
    cp $build_path/*.deb $build_path/deb >/dev/null 2>&1 || cp $build_path/*.changes $build_path/deb
    show_success "\n[DEB] $ORANCHELO $release for Ubuntu $version built!"
  else
    show_error "\n[DEB] $ORANCHELO $release for Ubuntu $version failed!"
    exit 0
  fi

  # Push PPA to Launchpad
  if [[ "$pkg" == *"ppa"* ]]; then
    cd $build_path
    dput ppa:oranchelo/oranchelo-icon-theme oranchelo-icon-theme_0.7.4~ubuntu16.10.1_source.changes
    if [ "$?" == "0" ]; then
      show_success "\n[PPA] $ORANCHELO $release for Ubuntu $version uploaded to Launchpad!"
    else
      show_error "\n[PPA] $ORANCHELO $release for Ubuntu $version upload failed!"
      exit 0
    fi
  fi
}

build_rpm() {

  version=$(echo $pkg | cut -d ':' -f2)
  build_path="$DIR/build/rpm/$release/$version"

  # Check if package is built
  if [ -f "$build_path/rpm/oranchelo-icon-theme-$release-1.$version.noarch.rpm" ]; then
    show_info "\n[RPM] $ORANCHELO $release for Fedora $version built yet..."
    return 0
  fi

  show_info "\nBuilding... $ORANCHELO $release for Fedora $version\n"
  mk_dir "$build_path"
  mk_dir "$build_path/BUILD"
  mk_dir "$build_path/SOURCES"
  mk_dir "$build_path/SRPMS"
  mk_dir "$build_path/SPECS"
  mk_dir "$build_path/SPECS/oranchelo-icon-theme.spec" "/usr/local/share/oranchelo-tools/rpm/config/oranchelo-icon-theme.spec"
  mk_dir "$build_path/rpm"

  show_info "\nExtracting and copying sources..."
  tar -zxf $DIR/sources/$release.tar.gz -C $build_path/SOURCES
  cp -rf $build_path/SOURCES/OrancheloTeam* $build_path/SOURCES/oranchelo-icon-theme-$release
  cd $build_path/SOURCES
  tar -zcf $build_path/SOURCES/v$release.tar.gz oranchelo-icon-theme-$release
  rm -rf $build_path/SOURCES/OrancheloTeam*
  rm -rf $build_path/SOURCES/oranchelo*

  show_info "\nGenerating build configuration..."
  # SPEC
  sed -i "2s/.RELEASE/$release/" $build_path/SPECS/oranchelo-icon-theme.spec
  sed -i "3s/.VERSION/$version/" $build_path/SPECS/oranchelo-icon-theme.spec

  show_info "\nBuilding package..."
  # Work in temporal ~/rpmbuild
  if [[ -d "$HOME/rpmbuild" ]]; then
    rm -rf ~/rpmbuild
  fi
  mkdir ~/rpmbuild
  cp -r $build_path/SOURCES ~/rpmbuild
  cp -r $build_path/SPECS ~/rpmbuild
  mkdir ~/rpmbuild/BUILD ~/rpmbuild/SRPMS ~/rpmbuild/BUILDROOT
  cd ~/rpmbuild/SPECS

  # Check errors
  rpmlint oranchelo-icon-theme.spec

  # Build rpm
  rpmbuild -ba oranchelo-icon-theme.spec

  # Move generated rpm
  if [ "$?" == "0" ]; then
    cp -rf ~/rpmbuild/BUILD $build_path
    cp -rf ~/rpmbuild/RPMS $build_path
    cp -rf ~/rpmbuild/S* $build_path
    rm -rf ~/rpmbuild
    cp $build_path/RPMS/noarch/oranchelo-icon-theme-$release-1.$version.noarch.rpm $build_path/rpm/oranchelo-icon-theme-$release-1.$version.noarch.rpm
    show_success "\n[RPM] $ORANCHELO $release for Fedora $version built!"
  else
    show_error "\n[RPM] $ORANCHELO $release for Fedora $version failed!"
    exit 0
  fi
}

show_help() {

  echo -e "\n$SCRIPT: build ditribution package for $ORANCHELO.\n"
  echo -e "Usage: $SCRIPT [options]\n"
  echo -e "Options:"
  echo "  -p, --ppa     Build pending PPA uploads"
  echo "  -d, --deb     Build pending DEB packages"
  echo "  -r, --rpm     Build pending RPM packages"
  echo "  -h, --help    Print help"
  exit 0
}


# MAIN
while [ "$1" != "" ]; do
  case "$1" in
    -p | --ppa)
      menu_ppa=0
      ;;
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
