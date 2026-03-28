#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
WORK=false

for arg in "$@"; do
    case "$arg" in
        --work) WORK=true ;;
        *) echo "Unknown flag: $arg"; exit 1 ;;
    esac
done

if [ "$(uname)" = "Linux" ]; then
    echo "==> Linux detected"
    bash "$DOTFILES_DIR/scripts/linux-packages.sh"
fi

if [ "$(uname)" = "Darwin" ]; then
    echo "==> macOS detected"
    bash "$DOTFILES_DIR/scripts/macos-packages.sh"
    if $WORK; then
        bash "$DOTFILES_DIR/scripts/macos-work-packages.sh"
    fi
    bash "$DOTFILES_DIR/scripts/macos-scroll-switcher.sh" "$DOTFILES_DIR"
fi
