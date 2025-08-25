#!/usr/bin/env bash
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

$SCRIPT_DIR/fish/setup.sh
$SCRIPT_DIR/atuin/setup.sh
$SCRIPT_DIR/starship/setup.sh
$SCRIPT_DIR/tmux/setup.sh
$SCRIPT_DIR/aerospace/setup.sh
$SCRIPT_DIR/nvim/setup.sh
$SCRIPT_DIR/vscode-neovim-config/setup.sh
