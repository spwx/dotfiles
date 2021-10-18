#!/usr/bin/env bash
set -euo pipefail

# get the full path of this file
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

rm -rf ~/.doom.d

printf "Linking configuration directory...\n"
ln -s "$SCRIPTPATH" "$HOME/.doom.d"

printf "Done!\n"
