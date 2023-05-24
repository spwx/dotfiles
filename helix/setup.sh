#!/usr/bin/env bash
set -euo pipefail

# get the full path of this file
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

rm -rf ~/.config/helix

printf "Linking configuration directory...\n"
ln -s "$SCRIPTPATH" "$HOME/.config/helix"

printf "Done!\n"
