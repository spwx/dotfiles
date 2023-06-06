#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

$SCRIPT_DIR/karabiner/setup.sh
$SCRIPT_DIR/skhd/setup.sh
$SCRIPT_DIR/yabai/setup.sh
