#!/bin/sh

BASE_DIR='/home/cano/git/cheat-sheets'
CS_DIR="$BASE_DIR/cheatsheets"

function printHelp
{
	echo "Usage:"
	echo "  cs <tool> [search string]"
	echo "  "
	echo "  # some useful string to look for are the verbs: execute, delete, add, create, list, get"
	exit 1
}


# usage
if [ -z $1 ]; then
	printHelp
fi
if [ ! -z $3 ]; then
	printHelp
fi

if [ ! -f "$CS_DIR/$1" ]; then
	echo "The cheatsheet '$1' does not exist, try with:"
	ls $CS_DIR
	exit 1
fi

# print all
if [ -z $2 ]; then
	cat "$CS_DIR/$1"

# look for the input string
else
	grep "$2" "$CS_DIR/$1"
fi
