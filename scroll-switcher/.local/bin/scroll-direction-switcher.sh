#!/bin/bash
#
# scroll-direction-switcher.sh
#
# Monitors for external mouse connect/disconnect events and toggles
# macOS natural scrolling accordingly:
#   - Trackpad only  → natural scrolling ON  (com.apple.swipescrolldirection = true/1)
#   - External mouse → natural scrolling OFF (com.apple.swipescrolldirection = false/0)
#
# Uses `hidutil list` with HID Usage Page 1 (Generic Desktop), Usage 2 (Mouse)
# to robustly detect external pointing devices regardless of product name.
#
# Uses the private CGSSetSwipeScrollDirection API (via a Swift helper) to
# change scroll direction immediately in the window server, rather than
# relying on `defaults write` which doesn't take effect until re-read.
#
# Installed as a LaunchAgent for automatic background operation.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LOG_TAG="ScrollSwitcher"
POLL_INTERVAL=2  # seconds between checks
STATE_FILE="$HOME/.local/state/scroll-mode.state"

# Ensure state directory exists
mkdir -p "$(dirname "$STATE_FILE")"

log() {
    logger -t "$LOG_TAG" "$1"
}

is_external_mouse_connected() {
    local count
    count=$(hidutil list 2>/dev/null \
        | awk 'NR > 2 && $4 == "1" && $5 == "2" && $NF == "0"' \
        | wc -l)
    count=$(( count + 0 ))  # trim whitespace from wc

    if [ "$count" -gt 0 ]; then
        return 0
    fi

    # Fallback: also check ioreg for HID devices with "Mouse" in product name,
    # in case hidutil output format changes in a future macOS release.
    local ioreg_mouse
    ioreg_mouse=$(ioreg -r -c IOHIDInterface -l 2>/dev/null \
        | grep -ci '"Product" = ".*[Mm]ouse.*"')
    if [ "$ioreg_mouse" -gt 0 ]; then
        return 0
    fi

    return 1
}

get_current_setting() {
    # Returns 0 (false/OFF) or 1 (true/ON) as stored by macOS defaults
    defaults read NSGlobalDomain com.apple.swipescrolldirection 2>/dev/null
}

set_natural_scrolling() {
    # $1 must be "true" or "false"
    local bool_val="$1"
    local desired_numeric
    if [ "$bool_val" = "true" ]; then
        desired_numeric=1
    else
        desired_numeric=0
    fi

    local current
    current=$(get_current_setting)

    if [ "$current" = "$desired_numeric" ]; then
        return  # already set correctly
    fi

    # Use the Swift helper that calls the private CGSSetSwipeScrollDirection API
    # to change scroll direction immediately in the window server, persist the
    # preference, and notify System Settings.
    "$SCRIPT_DIR/set-scroll-direction" "$bool_val"

    if [ "$bool_val" = "true" ]; then
        log "Natural scrolling ENABLED (trackpad mode)"
    else
        log "Natural scrolling DISABLED (mouse mode)"
    fi
}

write_state() {
    printf '%s\n' "$1" > "$STATE_FILE"
}

# --- Main loop ---

log "Starting scroll direction switcher (polling every ${POLL_INTERVAL}s)"

# Initialize state on startup — detect and apply immediately
if is_external_mouse_connected; then
    LAST_STATE="mouse"
    set_natural_scrolling false
else
    LAST_STATE="trackpad"
    set_natural_scrolling true
fi
write_state "$LAST_STATE"
log "Initial state: $LAST_STATE"

while true; do
    if is_external_mouse_connected; then
        CURRENT_STATE="mouse"
    else
        CURRENT_STATE="trackpad"
    fi

    if [ "$CURRENT_STATE" != "$LAST_STATE" ]; then
        if [ "$CURRENT_STATE" = "mouse" ]; then
            set_natural_scrolling false
        else
            set_natural_scrolling true
        fi
        write_state "$CURRENT_STATE"
        LAST_STATE="$CURRENT_STATE"
    fi

    sleep "$POLL_INTERVAL"
done
