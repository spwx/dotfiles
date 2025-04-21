#!/usr/bin/env bash
set -euo pipefail

# get the full path of this file
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

printf "Creating ~/.config directory\n"
mkdir -p ~/.config/vscode-neovim-config

printf "Linking configuration files...\n"
ln -s "$SCRIPTPATH/init.lua" "$HOME/.config/vscode-neovim-config/init.lua"

printf "Done!\n"
