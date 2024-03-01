#!/usr/bin/env bash
set -euo pipefail

# get the full path of this file
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

if [ $(uname) = "Darwin" ]; then
  DESTINATION="$HOME/Library/Application Support/Code/User/"
else
  DESTINATION="$HOME/.config/Code/User/"
fi

mkdir -p $DESTINATION

printf "Linking configuration files...\n"
ln -sf "$SCRIPTPATH/keybindings.json" "$DESTINATION/keybindings.json"
ln -sf "$SCRIPTPATH/settings.json" "$DESTINATION/settings.json"
rm -rf $DESTINATION/snippets
ln -sf "$SCRIPTPATH/snippets" "$DESTINATION/snippets"

printf "Done!\n"
