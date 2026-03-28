#!/bin/bash
set -euo pipefail

# ---------------------------------------------------------------------------
# Linux package installer (idempotent)
#
# Installs the same packages as macos-packages.sh where apt equivalents exist.
#
# Not available via apt (install separately):
#   - mise        → https://mise.jdx.dev
#   - starship    → https://starship.rs
#   - eza         → https://github.com/eza-community/eza
#   - git-delta   → https://github.com/dandavison/delta
#   - docker      → https://docs.docker.com/engine/install/
#   - gh          → https://github.com/cli/cli/blob/trunk/docs/install_linux.md
#                    (needs the GitHub CLI apt repo; skipped here)
# ---------------------------------------------------------------------------

# --- apt packages ----------------------------------------------------------

echo "==> Installing apt packages ..."

sudo apt update -y

sudo apt install -y \
    neovim \
    git \
    curl \
    wget \
    jq \
    ripgrep \
    fzf \
    fd-find \
    tree \
    tmux \
    bat \
    htop \
    tldr \
    stow \
    build-essential \
    zsh-syntax-highlighting

echo "    apt packages installed"

# --- lazygit (binary from GitHub release) ----------------------------------

echo "==> Installing lazygit ..."

case "$(uname -m)" in
    x86_64|amd64)  LAZYGIT_ARCH="Linux_x86_64" ;;
    aarch64|arm64) LAZYGIT_ARCH="Linux_arm64"   ;;
    *)
        echo "ERROR: Unsupported architecture '$(uname -m)' for lazygit download." >&2
        exit 1
        ;;
esac

LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')

LAZYGIT_TMPDIR=$(mktemp -d)
trap 'rm -rf "$LAZYGIT_TMPDIR"' EXIT

curl -Lo "$LAZYGIT_TMPDIR/lazygit.tar.gz" \
    "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_${LAZYGIT_ARCH}.tar.gz"
tar xf "$LAZYGIT_TMPDIR/lazygit.tar.gz" -C "$LAZYGIT_TMPDIR" lazygit
sudo install -m 755 "$LAZYGIT_TMPDIR/lazygit" /usr/local/bin/lazygit

echo "    lazygit ${LAZYGIT_VERSION} installed"

# --- zsh plugins (via git clone) -------------------------------------------

echo "==> Installing zsh plugins ..."

clone_if_missing() {
    local repo="$1" dest="$2"
    if [ -d "$dest" ]; then
        echo "    Already exists: $dest"
    else
        git clone --depth=1 "$repo" "$dest"
    fi
}

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

clone_if_missing https://github.com/zsh-users/zsh-autosuggestions \
    "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

clone_if_missing https://github.com/djui/alias-tips.git \
    "$ZSH_CUSTOM/plugins/alias-tips"

clone_if_missing https://github.com/ntnyq/omz-plugin-pnpm.git \
    "$ZSH_CUSTOM/plugins/pnpm"

clone_if_missing https://github.com/zsh-users/zsh-syntax-highlighting.git \
    "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

echo "    zsh plugins installed"

# --- tmux plugin manager ---------------------------------------------------

echo "==> Installing tmux plugin manager ..."

clone_if_missing https://github.com/tmux-plugins/tpm \
    "$HOME/.tmux/plugins/tpm"

echo "    tmux plugin manager installed"

echo "==> All done!"
