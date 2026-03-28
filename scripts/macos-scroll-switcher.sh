#!/bin/bash
set -euo pipefail

DOTFILES_DIR="${1:?Usage: macos-scroll-switcher.sh <dotfiles-dir>}"

echo "==> macOS detected — setting up scroll-switcher packages"

if ! command -v swiftc &>/dev/null; then
    echo "ERROR: swiftc is required but not found in PATH." >&2
    echo "       Install Xcode Command Line Tools: xcode-select --install" >&2
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
    ".local/bin/set-scroll-direction.swift"
    ".local/bin/set-scroll-direction"
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

# Compile Swift sources into standalone binaries
echo "    Building ScrollModeMenubar.app ..."
APP_DIR="$HOME/.local/bin/ScrollModeMenubar.app"
rm -rf "$APP_DIR"
mkdir -p "$APP_DIR/Contents/MacOS"
swiftc "$HOME/.local/bin/scroll-mode-menubar.swift" -o "$APP_DIR/Contents/MacOS/ScrollModeMenubar"
cat > "$APP_DIR/Contents/Info.plist" << 'INFOPLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleIdentifier</key>
    <string>com.user.scroll-mode-menubar</string>
    <key>CFBundleName</key>
    <string>ScrollModeMenubar</string>
    <key>CFBundleExecutable</key>
    <string>ScrollModeMenubar</string>
    <key>CFBundleVersion</key>
    <string>1.0</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>LSUIElement</key>
    <true/>
    <key>LSBackgroundOnly</key>
    <false/>
</dict>
</plist>
INFOPLIST

echo "    Compiling set-scroll-direction.swift ..."
swiftc "$HOME/.local/bin/set-scroll-direction.swift" -o "$HOME/.local/bin/set-scroll-direction" \
    -framework CoreGraphics \
    -Xlinker -U -Xlinker _CGSSetSwipeScrollDirection \
    -Xlinker -U -Xlinker __CGSDefaultConnection

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
