#!/usr/bin/env bash
set -euo pipefail

# get the full path of this file
SCRIPTPATH="$(
  cd "$(dirname "$0")"
  pwd -P
)"

# Remove any older configuration
printf "Removing any older configuration.\n"
target="$HOME/.config/aerospace"
if [ -L "$target" ]; then
  unlink "$target"
else
  rm -rf "$target"
fi

printf "Linking configuration directory...\n"
ln -s "$SCRIPTPATH" "$HOME/.config/aerospace"

printf "Done!\n"
