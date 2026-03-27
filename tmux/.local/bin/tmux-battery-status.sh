#!/usr/bin/env bash
# Returns "1" when on battery power, empty otherwise.
# Used by tmux conditional to show/hide the battery segment.

if pmset -g batt 2>/dev/null | grep -q 'discharging'; then
    echo "1"
fi
