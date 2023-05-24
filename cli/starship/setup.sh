#!/usr/bin/env bash
set -euo pipefail

# get the full path of this file
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

printf "Linking configuration file...\n"
ln -s "$SCRIPTPATH/starship.toml" "$HOME/.config/starship.toml"

printf "Done!\n"
