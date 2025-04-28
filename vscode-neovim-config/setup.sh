#!/usr/bin/env bash
set -euo pipefail

# get the full path of this file
SCRIPTPATH="$(
  cd "$(dirname "$0")"
  pwd -P
)"

# Remove any older configuration
printf "Removing any older configuration.\n"
target="$HOME/.config/vscode-neovim-config"
if [ -L "$target" ]; then
  unlink "$target"
else
  rm -rf "$target"
fi

printf "Creating ~/.config directory\n"
mkdir -p ~/.config/vscode-neovim-config

printf "Linking configuration files...\n"
ln -s "$SCRIPTPATH/init.lua" "$HOME/.config/vscode-neovim-config/init.lua"

printf "Done!\n"
