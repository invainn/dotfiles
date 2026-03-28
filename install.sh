#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ "$(uname)" = "Linux" ]; then
    echo "==> Linux detected"
    bash "$DOTFILES_DIR/scripts/linux-packages.sh"
fi

if [ "$(uname)" = "Darwin" ]; then
    echo "==> macOS detected"
    bash "$DOTFILES_DIR/scripts/macos-scroll-switcher.sh" "$DOTFILES_DIR"
fi
