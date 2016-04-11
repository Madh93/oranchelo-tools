// NAME          : main.c
// DESCRIPTION   : Development and build tools for Oranchelo
// AUTHOR        : Madh93 (Miguel Hernandez)
// VERSION       : 0.0.1
// LICENSE       : GNU General Public License v3

#include "oranchelo-tools.h"

int main(int argc, char *argv[]) {

    if (argc > 1 ) 
        readCommand(argc, argv);
    else
        throwError(NO_ARGUMENTS);
    
    return 0;
}