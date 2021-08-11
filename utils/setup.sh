#!/usr/bin/env bash
set -euo pipefail

# get the full path of this file
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

printf "Creating ~/.local/bin directory...\n"
mkdir -p "$HOME/.local/bin"

printf "Linking configuration file...\n"
ln -s "$SCRIPTPATH/open_iterm2.sh" "$HOME/.local/bin/open_iterm2.sh"
ln -s "$SCRIPTPATH/venv" "$HOME/.local/bin/venv"

printf "Done!\n"
