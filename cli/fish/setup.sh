#!/usr/bin/env bash
set -euo pipefail

# get the full path of this file
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

printf "Creating ~/.config directory\n"
mkdir -p ~/.config/fish

printf "Linking configuration files...\n"
ln -s "$SCRIPTPATH/config.fish" "$HOME/.config/fish/config.fish"
ln -s "$SCRIPTPATH/fish_variables" "$HOME/.config/fish/fish_variables"

printf "Done!\n"
