#!/bin/bash
# ============================================================================
# Helper: Add application to GNOME dock favorites
# ============================================================================
# Usage: add_to_favorites "app.desktop"
# Appends a .desktop entry to the GNOME Shell dock favorites list.
# Idempotent: skips if the app is already in favorites.
# Gracefully skips on non-GNOME systems.
# ============================================================================

add_to_favorites() {
    local desktop_id="$1"

    # Check if gsettings is available
    if ! command -v gsettings >/dev/null 2>&1; then
        echo "gsettings not found, skipping dock favorites for $desktop_id"
        return 0
    fi

    # Check if the GNOME Shell schema exists
    if ! gsettings list-schemas 2>/dev/null | grep -q "^org.gnome.shell$"; then
        echo "org.gnome.shell schema not found, skipping dock favorites for $desktop_id"
        return 0
    fi

    # Get current favorites
    local current
    current=$(gsettings get org.gnome.shell favorite-apps 2>/dev/null) || {
        echo "Could not read favorite-apps, skipping dock favorites for $desktop_id"
        return 0
    }

    # Check if app is already in favorites
    if echo "$current" | grep -q "'$desktop_id'"; then
        echo "$desktop_id is already in dock favorites, skipping"
        return 0
    fi

    # Handle empty favorites (could be "@as []" or "[]")
    if [ "$current" = "@as []" ] || [ "$current" = "[]" ]; then
        gsettings set org.gnome.shell favorite-apps "['$desktop_id']"
    else
        # Remove trailing bracket, append new entry, close bracket
        local new_list
        new_list=$(echo "$current" | sed "s/]$/, '$desktop_id']/")
        gsettings set org.gnome.shell favorite-apps "$new_list"
    fi

    echo "Added $desktop_id to dock favorites"
    return 0
}
