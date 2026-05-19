#!/bin/bash
# ============================================================================
# Module: Prerequisites Installation
# ============================================================================
# Purpose: Installs common dependencies needed for VS Code and Cursor
# These tools are required for downloading and verifying packages
# ============================================================================

set -e  # Exit on any error

echo "[2/7] Installing prerequisites..."

# Install necessary utilities:
# - wget: command-line tool for downloading files from the internet
# - gpg: GNU Privacy Guard, used to verify cryptographic signatures
# - apt-transport-https: allows apt to retrieve packages over HTTPS
# - software-properties-common: provides scripts for managing software repositories
# The -y flag skips confirmation prompts
sudo apt install -y wget gpg apt-transport-https software-properties-common

echo "✓ Prerequisites installed successfully"
