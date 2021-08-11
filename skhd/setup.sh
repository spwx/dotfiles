#!/usr/bin/env bash
set -euo pipefail

# get the full path of this file
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

printf "Creating ~/.config directory\n"
mkdir -p ~/.config/skhd

printf "Linking configuration file...\n"
ln -s "$SCRIPTPATH/skhdrc" "$HOME/.config/skhd/skhdrc"

printf "Done!\n"
