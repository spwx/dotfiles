#!/usr/bin/env bash
set -euo pipefail

# get the full path of this file
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

printf "Creating ~/.config directory\n"
mkdir -p ~/.config/limelight

printf "Linking configuration file...\n"
ln -s "$SCRIPTPATH/limelightrc" "$HOME/.config/limelight/limelightrc"

printf "Done!\n"
