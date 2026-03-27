#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# ─── Linux package installs ────────────────────────────────────────────────────

if [ "$(uname)" = "Linux" ]; then
    sudo apt install -y zsh-syntax-highlighting fzf build-essential

    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
    git clone --depth=1 https://github.com/djui/alias-tips.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/alias-tips"
    git clone --depth=1 https://github.com/ntnyq/omz-plugin-pnpm.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/pnpm"
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"

    case "$(uname -m)" in
        x86_64|amd64)  LAZYGIT_ARCH="Linux_x86_64" ;;
        aarch64|arm64) LAZYGIT_ARCH="Linux_arm64"   ;;
        *)
            echo "ERROR: Unsupported architecture '$(uname -m)' for lazygit download." >&2
            exit 1
            ;;
    esac

    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_${LAZYGIT_ARCH}.tar.gz"
    tar xf lazygit.tar.gz lazygit

    sudo install -m 755 lazygit /usr/local/bin/lazygit

    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# ─── macOS: scroll-switcher setup (stow packages) ─────────────────────────────

if [ "$(uname)" = "Darwin" ]; then
    echo "==> macOS detected — setting up scroll-switcher packages"

    if ! command -v stow &>/dev/null; then
        echo "ERROR: GNU stow is required but not found in PATH." >&2
        echo "       Install it with: brew install stow" >&2
        exit 1
    fi

    SCROLL_AGENT_LABELS=(
        "com.user.scroll-direction-switcher"
        "com.user.scroll-mode-menubar"
    )

    # Unload running LaunchAgents before touching plist files
    for label in "${SCROLL_AGENT_LABELS[@]}"; do
        plist="$HOME/Library/LaunchAgents/${label}.plist"
        if launchctl print "gui/$(id -u)/${label}" &>/dev/null; then
            echo "    Unloading ${label} ..."
            launchctl bootout "gui/$(id -u)/${label}" 2>/dev/null || true
        fi
    done

    # Ensure target parent directories exist (stow won't create these)
    mkdir -p "$HOME/.local/bin"
    mkdir -p "$HOME/Library/LaunchAgents"

    # Migrate any existing real files out of the way so stow can create symlinks.
    # Only backs up regular files (not symlinks already managed by stow).
    MANAGED_FILES=(
        ".local/bin/scroll-direction-switcher.sh"
        ".local/bin/scroll-mode-menubar.swift"
        "Library/LaunchAgents/com.user.scroll-direction-switcher.plist"
        "Library/LaunchAgents/com.user.scroll-mode-menubar.plist"
    )
    BACKUP_DIR="$HOME/.dotfiles-backup/scroll-$(date +%Y%m%d%H%M%S)"
    backup_needed=false
    for relpath in "${MANAGED_FILES[@]}"; do
        target="$HOME/$relpath"
        if [ -f "$target" ] && [ ! -L "$target" ]; then
            backup_needed=true
            break
        fi
    done
    if $backup_needed; then
        echo "    Backing up existing files to ${BACKUP_DIR} ..."
        mkdir -p "$BACKUP_DIR"
        for relpath in "${MANAGED_FILES[@]}"; do
            target="$HOME/$relpath"
            if [ -f "$target" ] && [ ! -L "$target" ]; then
                mkdir -p "$BACKUP_DIR/$(dirname "$relpath")"
                mv "$target" "$BACKUP_DIR/$relpath"
                echo "      moved $relpath"
            fi
        done
    fi

    # Remove stale symlinks that point to the wrong place (e.g. previous stow run)
    for relpath in "${MANAGED_FILES[@]}"; do
        target="$HOME/$relpath"
        if [ -L "$target" ]; then
            rm "$target"
        fi
    done

    # Stow the packages (target = $HOME, dir = dotfiles repo)
    echo "    Stowing scroll-switcher ..."
    stow -d "$DOTFILES_DIR" -t "$HOME" scroll-switcher

    echo "    Stowing scroll-launchagents ..."
    stow -d "$DOTFILES_DIR" -t "$HOME" scroll-launchagents

    # Reload LaunchAgents
    for label in "${SCROLL_AGENT_LABELS[@]}"; do
        plist="$HOME/Library/LaunchAgents/${label}.plist"
        if [ -f "$plist" ] || [ -L "$plist" ]; then
            echo "    Loading ${label} ..."
            launchctl bootstrap "gui/$(id -u)" "$plist" 2>/dev/null
            launchctl enable "gui/$(id -u)/${label}"
        fi
    done

    # Validate that both agents are running
    for label in "${SCROLL_AGENT_LABELS[@]}"; do
        if ! launchctl print "gui/$(id -u)/${label}" &>/dev/null; then
            echo "ERROR: LaunchAgent ${label} is not running after load." >&2
            exit 1
        fi
        echo "    ✓ ${label} is running"
    done

    echo "==> scroll-switcher setup complete"
fi
