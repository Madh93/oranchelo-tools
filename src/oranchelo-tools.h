// NAME          : oranchelo-tools.h
// DESCRIPTION   : Development and build tools for Oranchelo
// AUTHOR        : Madh93 (Miguel Hernandez)
// VERSION       : 0.0.1
// LICENSE       : GNU General Public License v3

#ifndef ORANCHELO_TOOLS_H
#define ORANCHELO_TOOLS_H

/**
*** CONSTANTS 
**/

/* General */
#define APP "oranchelo-tools"
#define VERSION "0.0.1"

/* Commands names */
#define CMD_BUILD "build"
#define CMD_INIT "init"
#define CMD_STATUS "status"
#define CMD_UPDATE "update"


/**
*** DEFINITION TYPES
**/

/* command: Command Type */
typedef enum {
    BUILD,
    INIT, 
    STATUS, 
    UPDATE 
} command; 

/* error: Error Type */
typedef enum {
    NO_ARGUMENTS,
    INVALID_ARGUMENT,
    INITIALIZED_FAIL
} error;

/* Command: Struct with command info */
typedef struct {
    char* name;
    command cmd;
    char* arguments;
} Command;


/**
*** DEFINITION FUNCTIONS
**/

/* General */
void readCommand(int size, char *args[]);
int runCommand();

/* Built-in data structures */
int initCommand(Command *c, char *args[]);
int setCommand(const char *name, command *cmd);

/* Built-in commands */
void showHelp();
void showVersion();

/* Error handling */
void throwError(error e);
void throwErrorDetailed(error e, const char *info);

#endif /* ORANCHELO_TOOLS_H */