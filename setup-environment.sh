#!/bin/bash
# Shebang line - tells the system to execute this script using bash shell

# ============================================================================
# Main Environment Setup Script for Ubuntu 22.04
# ============================================================================
# Purpose: Orchestrates the installation of development tools
# Installs: DNS Configuration, Chromium Browser, Cursor, and VS Code
# 
# ARCHITECTURE SUPPORT:
# This script supports both x86_64 and ARM64 (Apple Silicon via UTM) architectures.
# All three applications have native support for ARM64 Linux.
#
# MODULAR DESIGN:
# This main script calls individual installation scripts from the 'configuration'
# directory. Each application has its own dedicated installation script.
# ============================================================================

# Exit immediately if any command fails (returns non-zero exit code)
# This prevents the script from continuing if something goes wrong
set -e

# ============================================================================
# CONFIGURATION
# ============================================================================
# Define the directory where individual installation scripts are stored
# This should be relative to where the main script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$SCRIPT_DIR/configuration"

# Display a header banner to the user
echo "======================================="
echo "Environment Setup Script"
echo "======================================="
echo ""

# ============================================================================
# DIRECTORY VALIDATION
# ============================================================================
# Check if the configuration directory exists
if [ ! -d "$CONFIG_DIR" ]; then
    echo "❌ ERROR: Configuration directory not found!"
    echo "Expected location: $CONFIG_DIR"
    echo ""
    echo "Please ensure the 'configuration' directory exists in the same"
    echo "location as this script and contains the installation modules."
    exit 1
fi

# ============================================================================
# ARCHITECTURE DETECTION
# ============================================================================
# Detect the system architecture to provide appropriate information
ARCH=$(uname -m)
echo "Detected architecture: $ARCH"

# Check if running on ARM64 (Apple Silicon via UTM)
if [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
    echo ""
    echo "ℹ️  ARM64 architecture detected (Apple Silicon/UTM)"
    echo "ℹ️  All three applications support ARM64:"
    echo "    • Chromium - Native ARM64 support"
    echo "    • VS Code - Native ARM64 support"
    echo "    • Cursor - ARM64 AppImage available"
    echo ""
    read -p "Press Enter to continue with installation..."
fi
echo ""

# ============================================================================
# UTILITY FUNCTION: Check if a command exists
# ============================================================================
# This function checks whether a given command/program is available in the system
# Parameters: $1 - the command name to check
# Returns: 0 (success) if command exists, 1 (failure) if it doesn't
# Usage: command_exists "code" will return 0 if VS Code is installed
command_exists() {
    # command -v searches for the command in PATH
    # >/dev/null 2>&1 suppresses all output (stdout and stderr)
    command -v "$1" >/dev/null 2>&1
}

# Export the function so child scripts can use it
export -f command_exists

# Source and export dock favorites helpers
source "$SCRIPT_DIR/helpers/add-to-favorites.sh"
source "$SCRIPT_DIR/helpers/wipe-favorites.sh"
export -f add_to_favorites
export -f wipe_favorites

# ============================================================================
# UTILITY FUNCTION: Run installation module
# ============================================================================
# This function runs an individual installation script from the config directory
# Parameters: $1 - the name of the script to run (without path)
# Returns: 0 if successful, exits with error code if script fails
run_module() {
    local module_name="$1"
    local module_path="$CONFIG_DIR/$module_name"
    
    # Check if the module script exists
    if [ ! -f "$module_path" ]; then
        echo "❌ ERROR: Module '$module_name' not found at: $module_path"
        exit 1
    fi
    
    # Check if the module is executable
    if [ ! -x "$module_path" ]; then
        echo "⚠️  Warning: Module '$module_name' is not executable. Making it executable..."
        chmod +x "$module_path"
    fi
    
    # Execute the module script
    echo ""
    echo "Running module: $module_name"
    echo "----------------------------------------"
    "$module_path"
    
    # Check if the module succeeded
    if [ $? -eq 0 ]; then
        echo "✓ Module '$module_name' completed successfully"
    else
        echo "❌ Module '$module_name' failed!"
        exit 1
    fi
}

# ============================================================================
# STEP 1: System Update
# ============================================================================
# Run the system update module first to ensure package lists are current
run_module "01-system-update.sh"

# ============================================================================
# STEP 2: Install Prerequisites
# ============================================================================
# Install common dependencies needed by multiple applications
run_module "02-prerequisites.sh"

# ============================================================================
# STEP 3: Configure DNS
# ============================================================================
# Configure reliable DNS servers for the system
run_module "03-configure-dns.sh"

# ============================================================================
# STEP 4: Pre-install Configurations
# ============================================================================
# Run pre-install configurations (wipe dock favorites, etc.)
run_module "04-preinstall-configurations.sh"

# ============================================================================
# STEP 5: Install Applications
# ============================================================================
# Install Chromium Browser, VS Code, and Cursor
run_module "05-install-applications/index.sh"

# ============================================================================
# STEP 6: Install Packages
# ============================================================================
# Install UV and WezTerm
run_module "06-install-packages/index.sh"

# ============================================================================
# STEP 7: Final System Update
# ============================================================================
# Run a final system update to ensure everything is current
run_module "07-final-update.sh"

# ============================================================================
# Installation Complete - Display Summary
# ============================================================================
# Show a final success message with instructions on how to use the installed apps
echo ""
echo "======================================="
echo "Installation Complete!"
echo "======================================="
echo ""

# Check architecture to provide appropriate completion message
if [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
    echo "Installed applications (ARM64/Apple Silicon):"
    echo "  • Chromium Browser - Launch with: chromium-browser"
    echo "  • VS Code - Launch with: code"
    echo "  • Cursor - Launch with: cursor"
    echo ""
    echo "Note: All applications installed with native ARM64 support."
    echo "Performance should be excellent on Apple Silicon via UTM."
else
    echo "Installed applications:"
    # List each application with its command-line launch instruction
    echo "  • Chromium Browser - Launch with: chromium-browser"
    echo "  • VS Code - Launch with: code"
    echo "  • Cursor - Launch with: cursor"
fi

echo ""
echo "You can now use these applications from your terminal or application menu."
echo ""

# ============================================================================
# End of Script
# ============================================================================
# All installations are complete and the system is ready for development!
