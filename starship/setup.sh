#!/usr/bin/env bash
set -euo pipefail

# Remove older configuration
printf "Remove any older configuration.\n"
target="$HOME/.config/starship.toml"
if [ -L "$target" ]; then
  unlink "$target"
else
  rm "$target"
fi

# get the full path of this file
SCRIPTPATH="$(
  cd "$(dirname "$0")"
  pwd -P
)"

printf "Linking configuration file...\n"
ln -s "$SCRIPTPATH/starship.toml" "$HOME/.config/starship.toml"

printf "Done!\n"
