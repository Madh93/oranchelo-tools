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
RELEASES=$(curl -i https://api.github.com/repos/Madh93/oranchelo-icon-theme/tags)


# SOURCE CODE
echo "${RELEASES}"