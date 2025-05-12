#!/usr/bin/env bash
set -euo pipefail

# Remove older configuration
printf "Removing any older configuration.\n"
target="$HOME/.tmux.conf"
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
ln -s "$SCRIPTPATH/.tmux.conf" "$HOME/.tmux.conf"

printf "Done!\n"
