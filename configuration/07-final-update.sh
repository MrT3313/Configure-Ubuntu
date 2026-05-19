#!/bin/bash
# ============================================================================
# Module: Final System Update
# ============================================================================
# Purpose: Performs a final system update after all installations
# This ensures all packages (including newly installed ones) are up to date
# ============================================================================

set -e  # Exit on any error

echo "[7/7] Running final system update..."

# apt update refreshes the package list (in case repos were added)
# && chains commands - only runs the second if the first succeeds
# apt upgrade upgrades all installed packages to their latest versions
# -y automatically confirms any upgrade prompts
sudo apt update && sudo apt upgrade -y

echo "✓ System update completed successfully"
