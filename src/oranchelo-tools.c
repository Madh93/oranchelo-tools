// NAME          : oranchelo-tools.c
// DESCRIPTION   : Development and build tools for Oranchelo
// AUTHOR        : Madh93 (Miguel Hernandez)
// VERSION       : 0.0.1
// LICENSE       : GNU General Public License v3

#include "oranchelo-tools.h"

/**
*** General 
**/

void readCommand(int size, char *args[]) {
    
    Command c;
    
    if (initCommand(&c, size, args) != 0)
        throwError(INITIALIZED_FAIL);
}

int runCommand() {
    return 0;
}


/**
*** Built-in data structures
**/

int initCommand(Command *c, int size, char *args[]) {
    // CMD
    if (setCommand(args[1], &c->cmd) != 0)
        throwErrorDetailed(INVALID_ARGUMENT, args[1]);
    // ARGS
    if (setArguments(size, args, &c->args) != 0)
        return 1;
    // Name
    c->name = args[1];

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

int setArguments(int size, char *args[], char **arguments) {

    char buffer[80] = "";

    for (int i=2; i<size; i++)
        strcat(strcat(buffer, " "), args[i]);

    *arguments = malloc(strlen(buffer)); 
    strcpy(*arguments, buffer);

    return 0;
}


/**
*** Built-in commands
**/

void showHelp() {
    printf("%s: Development and build tools for Oranchelo\n", APP);
    printf("\nUsage: %s [command | options]\n", APP);
    printf("\nCommand:\n");
    printf("  build \tBuild ditribution packagee\n");
    printf("  init  \tInitialize build workspace\n");
    printf("  status\tCheck available release\n");
    printf("  update\tUpdate local releases\n");
    printf("\nOptions:\n");
    printf("  -h, --help\tShow this help\n");
    printf("  -v, --version\tShow version\n");
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
