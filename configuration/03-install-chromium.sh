#!/bin/bash
# ============================================================================
# Module: Chromium Browser Installation
# ============================================================================
# Purpose: Installs the Chromium web browser
# Chromium is the open-source browser that Google Chrome is based on
# Available directly from Ubuntu's official repositories
# ============================================================================

set -e  # Exit on any error

echo "[3/6] Installing Chromium Browser..."

# Check if Chromium is already installed to avoid redundant installation
# We check for both "chromium-browser" and "chromium" commands
# because the command name varies between Ubuntu versions
if command_exists chromium-browser || command_exists chromium; then
    # If either command exists, Chromium is already installed
    echo "Chromium is already installed. Skipping..."
else
    # Install Chromium Browser from Ubuntu repositories
    # -y flag automatically answers "yes" to prompts during installation
    sudo apt install -y chromium-browser
    echo "✓ Chromium Browser installed successfully"
fi
