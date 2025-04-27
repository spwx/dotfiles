#!/usr/bin/env bash
set -euo pipefail

# get the full path of this file
SCRIPTPATH="$(
  cd "$(dirname "$0")"
  pwd -P
)"

# Remove any older configuration
printf "Removing any older configuration.\n"
target="$HOME/.config/fish"
if [ -L "$target" ]; then
  unlink "$target"
else
  rm -rf "$target"
fi

# Create new configuration
printf "Creating ~/.config/fish directory\n"
mkdir -p $HOME/.config/fish

printf "Linking configuration files...\n"
ln -s "$SCRIPTPATH/config.fish" "$HOME/.config/fish/config.fish"
ln -s "$SCRIPTPATH/fish_variables" "$HOME/.config/fish/fish_variables"

printf "Done!\n"
