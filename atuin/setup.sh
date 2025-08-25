#!/usr/bin/env bash
set -euo pipefail

# get the full path of this file
SCRIPTPATH="$(
  cd "$(dirname "$0")"
  pwd -P
)"

# Remove any older configuration
printf "Removing any older configuration.\n"
target="$HOME/.config/atuin"
if [ -L "$target" ]; then
  unlink "$target"
else
  rm -rf "$target"
fi

# Create new configuration
printf "Linking configuration files...\n"
ln -s "$SCRIPTPATH/config.toml" "$HOME/.config/atuin"

printf "Done!\n"
