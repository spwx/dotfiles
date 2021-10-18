#!/usr/bin/env bash
set -euo pipefail

# get the full path of this file
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

printf "Creating ~/.config directory\n"
mkdir -p ~/.config/karabiner

printf "Linking configuration file...\n"
ln -s "$SCRIPTPATH/karabiner.json" "$HOME/.config/karabiner/karabiner.json"

printf "Done!\n"
