#!/usr/bin/env bash

# get the full path of this file
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

printf "Linking dictionary\n"
ln -s "$SCRIPTPATH/.aspell.en.pws" "$HOME/.aspell.en.pws"

printf "Done!\n"
