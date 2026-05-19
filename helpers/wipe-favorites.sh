#!/bin/bash
# ============================================================================
# Helper: Wipe GNOME dock favorites
# ============================================================================
# Usage: wipe_favorites
# Clears the entire GNOME Shell dock favorites list so only apps
# explicitly added by our setup scripts appear in the dock.
# Gracefully skips on non-GNOME systems.
# ============================================================================

wipe_favorites() {
    # Check if gsettings is available
    if ! command -v gsettings >/dev/null 2>&1; then
        echo "gsettings not found, skipping dock favorites wipe"
        return 0
    fi

    # Check if the GNOME Shell schema exists
    if ! gsettings list-schemas 2>/dev/null | grep -q "^org.gnome.shell$"; then
        echo "org.gnome.shell schema not found, skipping dock favorites wipe"
        return 0
    fi

    gsettings set org.gnome.shell favorite-apps "[]"
    echo "Cleared dock favorites"
    return 0
}
