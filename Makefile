# Executables
CC=gcc
CP=cp -r
MD=mkdir -p
RM=rm -rf
CHM=chmod +x

# Directories
DIR_BUILD=build
DIR_BIN=bin
DIR_SRC=src

# Config
TARGET=oranchelo-tools
PREFIX?=/usr/local
LIB=$(PREFIX)/lib/$(TARGET)
SHARE=$(PREFIX)/share/$(TARGET)

# Rules
all: directories $(TARGET)

$(TARGET): main.o oranchelo-tools.o
	$(CC) $(DIR_BUILD)/oranchelo-tools.o $(DIR_BUILD)/main.o -o $(DIR_BIN)/$(TARGET)

main.o: $(DIR_SRC)/main.c
	$(CC) -Iheaders -c $(DIR_SRC)/main.c -o $(DIR_BUILD)/main.o

oranchelo-tools.o: $(DIR_SRC)/oranchelo-tools.c
	$(CC) -Iheaders -c $(DIR_SRC)/oranchelo-tools.c -o $(DIR_BUILD)/oranchelo-tools.o

directories:
	$(MD) $(DIR_BIN) $(DIR_BUILD)

install:
	$(CP) $(DIR_BIN)/$(TARGET) $(PREFIX)/bin/$(TARGET)
	$(MD) $(LIB)/scripts
	$(CP) scripts/* $(LIB)/scripts
	$(CHM) $(LIB)/scripts

uninstall:
	$(RM) $(PREFIX)/bin/$(TARGET)
	$(RM) $(LIB)

clean:
	$(RM) $(DIR_BIN) $(DIR_BUILD)
