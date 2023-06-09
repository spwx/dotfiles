#!/usr/bin/env bash
set -euo pipefail

# get the full path of this file
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

# printf "Linking configuration directory...\n"
$SCRIPTPATH/aspell/setup.sh
$SCRIPTPATH/doom.d/setup.sh
