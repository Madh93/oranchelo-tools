// NAME          : oranchelo-tools.h
// DESCRIPTION   : Development and build tools for Oranchelo
// AUTHOR        : Madh93 (Miguel Hernandez)
// VERSION       : 0.0.1
// LICENSE       : GNU General Public License v3

#ifndef ORANCHELO_TOOLS_H
#define ORANCHELO_TOOLS_H

/**
*** INCLUDES
**/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include <sys/types.h>
#include <string.h>


/**
*** CONSTANTS
**/

/* General */
#define APP "oranchelo-tools"
#define VERSION "0.0.1"
#define PATH "/usr/local/lib/oranchelo-tools/scripts"

/* Commands names */
#define CMD_BUILD "build"
#define CMD_CLEAN "clean"
#define CMD_INIT "init"
#define CMD_STATUS "status"
#define CMD_UPDATE "update"


/**
*** DEFINITION TYPES
**/

/* command: Command Type */
typedef enum {
    BUILD,
    CLEAN,
    INIT,
    STATUS,
    UPDATE
} command;

/* error: Error Type */
typedef enum {
    NO_ARGUMENTS,
    INVALID_ARGUMENT,
    INITIALIZED_FAIL,
    RUN_COMMAND_FAIL,
    FORK_PROCESS_FAIL,
    DESTROY_FAIL
} error;

/* Command: Struct with command info */
typedef struct {
    command cmd;
    int sz_args;
    char **args;
    char *path;
} Command;


/**
*** DEFINITION FUNCTIONS
**/

/* General */
void readCommand(int size, char *args[]);
void runCommand(const Command *c);

/* Built-in data structures */
Command* initCommand(int size, char *args[]);
void destroyCommand(Command *c);
void setCommand(const char *name, command *cmd);
void setArguments(const int size, char *args[], char **arguments[]);
void setPath(char *name, char *path[]);

/* Built-in commands */
void showHelp();
void showVersion();

/* Error handling */
void throwError(error e);
void throwErrorDetailed(error e, const char *info);

#endif /* ORANCHELO_TOOLS_H */
