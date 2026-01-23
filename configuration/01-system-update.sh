#!/bin/bash
# ============================================================================
# Module: System Update
# ============================================================================
# Purpose: Updates the package list from Ubuntu repositories
# This ensures we get the latest versions of packages
# ============================================================================

set -e  # Exit on any error

echo "[1/6] Updating package list..."

# apt update downloads package information from all configured sources
# This refreshes the local database of available packages and their versions
sudo apt update

echo "✓ Package list updated successfully"
