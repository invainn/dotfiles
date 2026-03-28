#!/bin/bash
set -euo pipefail

echo "==> Checking for Xcode Command Line Tools ..."

if ! xcode-select -p &>/dev/null; then
    echo "    Xcode CLT not found — installing ..."
    xcode-select --install
    echo "    Waiting for Xcode CLT installation to complete ..."
    until xcode-select -p &>/dev/null; do
        sleep 5
    done
    echo "    Xcode CLT installed"
else
    echo "    Xcode CLT already installed"
fi

echo "==> Checking for Homebrew ..."

if ! command -v brew &>/dev/null; then
    echo "    Homebrew not found — installing ..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Make brew available for the rest of this script
    if [ -x /opt/homebrew/bin/brew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -x /usr/local/bin/brew ]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    echo "    Homebrew already installed"
fi

echo "==> Installing packages via Homebrew ..."

brew install \
    neovim \
    lazygit \
    mise \
    stow \
    git \
    curl \
    wget \
    jq \
    ripgrep \
    fzf \
    fd \
    tree \
    tmux \
    starship \
    zsh-autosuggestions \
    zsh-syntax-highlighting \
    bat \
    eza \
    git-delta \
    htop \
    tlrc \
    gh \
    docker \
    opencode

echo "==> Homebrew packages installed"
