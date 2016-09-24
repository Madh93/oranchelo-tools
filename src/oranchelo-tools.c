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

    Command *c = initCommand(size,args);
    runCommand(c);
    destroyCommand(c);
}

void runCommand(const Command *c) {

    int pid, status;

    pid = fork();

    if (pid == 0) {
        if (execvp(c->path, c->args) != 0) {
            throwError(RUN_COMMAND_FAIL);
        }
    } else if (pid > 0) {
        wait(&status);
    } else {
        throwError(FORK_PROCESS_FAIL);
    }
}


/**
*** Built-in data structures
**/

Command* initCommand(int size, char *args[]) {

    Command *c = malloc(sizeof(Command));

    if (c) {
        c->sz_args = size;
        setCommand(args[1], &c->cmd);
        setArguments(size, args, &c->args);
        setPath(args[1], &c->path);
    } else {
        throwError(INITIALIZED_FAIL);
    }

    return c;
}

void destroyCommand(Command *c) {

    if (c) {
        for (int i=0; i<(c->sz_args); i++)
            free(c->args[i]);
        free(c->args);
        free(c->path);
        free(c);
    } else {
        throwError(DESTROY_FAIL);
    }
}

void setCommand(const char *name, command *cmd) {

    if (strcmp(name, CMD_BUILD) == 0)
        *cmd = BUILD;
    if (strcmp(name, CMD_CLEAN) == 0)
        *cmd = CLEAN;
    else if (strcmp(name, CMD_INIT) == 0)
        *cmd = INIT;
    else if (strcmp(name, CMD_STATUS) == 0)
        *cmd = STATUS;
    else if (strcmp(name, CMD_UPDATE) == 0)
        *cmd = UPDATE;
    else
        throwErrorDetailed(INVALID_ARGUMENT, name);
}

void setArguments(const int size, char *args[], char **arguments[]) {

    char **aux = malloc(size * sizeof(void*));
    aux[size-1] = NULL;

    for (int i=0; i<(size-1); i++) {
        aux[i] = malloc(sizeof(args[i+1]));
        memcpy(aux[i], args[i+1], sizeof(args[i+1]));
    }

    *arguments = aux;
}

void setPath(char *name, char *path[]) {

    char path_[80] = PATH;
    char *aux;

    aux = strcat(strcat(strcat(path_, "/oranchelo-tools-"), name), ".sh");
    *path = (char *)malloc(strlen(aux)+1);
    strcpy(*path, aux);
}


/**
*** Built-in commands
**/

void showHelp() {
    printf("%s: Development and build tools for Oranchelo\n", APP);
    printf("\nUsage: %s [command | options]\n", APP);
    printf("\nCommand:\n");
    printf("  build \tBuild ditribution package\n");
    printf("  clean \tClean build workspace\n");
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
        case RUN_COMMAND_FAIL: printf("Failed running 'Command'.\n"); break;
        case FORK_PROCESS_FAIL: printf("Failed fork 'Command'.\n"); break;
        case DESTROY_FAIL: printf("Failed destroying 'Command'.\n"); break;
        default: printf("Unknown error...\n");
    }

    exit(0);
}
