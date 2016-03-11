#! /bin/bash

# NAME          : oranchelo-tools-utils
# DESCRIPTION   : Basic utils for oranchelo-tools
# AUTHOR        : Madh93 (Miguel Hernandez)
# VERSION       : 0.0.1 
# LICENSE       : GNU General Public License v3   
# USAGE         : bash oranchelo-tools-status.sh 


# UTILS

# Output color: BLUE
show_question() {
  echo -e "\033[1;34m$@\033[0m"
}

# Output color: GREEN
show_source() {
  echo -e "\033[1;32m$@\033[0m"
}

# Output color: RED
show_error() {
  echo -e "\033[1;31m$@\033[0m"
}

end() {
  echo -e "\nExiting...\n"
  exit 0
}