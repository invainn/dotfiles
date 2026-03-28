#!/bin/bash
set -euo pipefail

# ---------------------------------------------------------------------------
# Linux package installer (idempotent)
#
# Detects the system package manager and installs the same packages as
# macos-packages.sh where equivalents exist.
#
# Supported: apt (Debian/Ubuntu), dnf (Fedora/RHEL), pacman (Arch), zypper (openSUSE)
#
# Not available in most distro repos (install separately):
#   - mise        → https://mise.jdx.dev
#   - starship    → https://starship.rs
#   - opencode    → https://opencode.ai
#   - docker      → https://docs.docker.com/engine/install/
# ---------------------------------------------------------------------------

# --- Detect package manager and define install command ---------------------

if command -v apt &>/dev/null; then
    PKG_MANAGER="apt"
    pkg_install() { sudo apt update -y && sudo apt install -y "$@"; }
elif command -v dnf &>/dev/null; then
    PKG_MANAGER="dnf"
    pkg_install() { sudo dnf install -y "$@"; }
elif command -v pacman &>/dev/null; then
    PKG_MANAGER="pacman"
    pkg_install() { sudo pacman -Syu --noconfirm "$@"; }
elif command -v zypper &>/dev/null; then
    PKG_MANAGER="zypper"
    pkg_install() { sudo zypper install -y "$@"; }
else
    echo "ERROR: No supported package manager found (apt, dnf, pacman, zypper)." >&2
    exit 1
fi

echo "==> Detected package manager: $PKG_MANAGER"

# --- Map package names that differ across distros --------------------------
#
# Canonical name → distro-specific name. Empty string = skip (not available).

pkg_name() {
    local pkg="$1"
    case "$pkg" in
        fd)
            case "$PKG_MANAGER" in
                apt|dnf) echo "fd-find" ;;
                *)       echo "fd" ;;
            esac ;;
        build-tools)
            case "$PKG_MANAGER" in
                apt)    echo "build-essential" ;;
                pacman) echo "base-devel" ;;
                *)      echo "gcc make" ;;
            esac ;;
        gh)
            case "$PKG_MANAGER" in
                pacman) echo "github-cli" ;;
                *)      echo "gh" ;;
            esac ;;
        eza)
            case "$PKG_MANAGER" in
                dnf|pacman) echo "eza" ;;
                *)          echo "" ;;
            esac ;;
        git-delta)
            case "$PKG_MANAGER" in
                dnf|pacman) echo "git-delta" ;;
                *)          echo "" ;;
            esac ;;
        *) echo "$pkg" ;;
    esac
}

# --- Shared package list ---------------------------------------------------

PACKAGES=(
    neovim git curl wget jq ripgrep fzf fd tree tmux
    bat htop tldr stow build-tools zsh zsh-syntax-highlighting
    gh eza git-delta
)

# Resolve canonical names to distro-specific names
RESOLVED=()
for pkg in "${PACKAGES[@]}"; do
    resolved=$(pkg_name "$pkg")
    [ -n "$resolved" ] && RESOLVED+=($resolved)
done

echo "==> Installing system packages ..."
pkg_install "${RESOLVED[@]}"
echo "    system packages installed"

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
