// NAME          : oranchelo-tools.c
// DESCRIPTION   : Development and build tools for Oranchelo
// AUTHOR        : Madh93 (Miguel Hernandez)
// VERSION       : 0.0.1
// LICENSE       : GNU General Public License v3

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "oranchelo-tools.h"


/**
*** General 
**/

void readCommand(int size, char *args[]) {
    
    Command c;
    
    if (initCommand(&c, args) != 0)
        throwError(INITIALIZED_FAIL);
}

int runCommand() {
    return 0;
}


/**
*** Built-in data structures
**/

int initCommand(Command *c, char *args[]) {
    // CMD
    if (setCommand(args[1], &c->cmd) != 0)
        throwErrorDetailed(INVALID_ARGUMENT, args[1]);

    return 0;
}

int setCommand(const char *name, command *cmd) {
    
    if (strcmp(name, CMD_BUILD) == 0)
        *cmd = BUILD;
    else if (strcmp(name, CMD_INIT) == 0)
        *cmd = INIT;
    else if (strcmp(name, CMD_STATUS) == 0)
        *cmd = STATUS;
    else if (strcmp(name, CMD_UPDATE) == 0)
        *cmd = UPDATE;
    else
        return 1;

    return 0;
}


/**
*** Built-in commands
**/

void showHelp() {
    printf("%s\n", APP);
}

void showVersion() {
    printf("%s %s\n", APP, VERSION);
}


/**
*** Error handling
**/

void throwError(error e) {
    throwErrorDetailed(e, "");
}

void throwErrorDetailed(error e, const char* info) {
    
    switch(e) {
        case NO_ARGUMENTS: printf("Not specified command. Try '%s --help'.\n", APP); break;
        case INVALID_ARGUMENT: printf("%s: unknown argument. Try '%s --help'.\n", info, APP); break;
        case INITIALIZED_FAIL: printf("Failed initializing 'Command'.\n"); break;
        default: printf("Unknown error...\n");
    }
    
    exit(0);
}
