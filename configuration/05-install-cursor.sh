#!/bin/bash
# ============================================================================
# Module: Cursor Installation
# ============================================================================
# Purpose: Installs Cursor AI code editor
# Cursor is an AI-powered code editor (fork of VS Code with AI features)
# It's distributed as an AppImage, which is a portable application format
#
# ARM64 COMPATIBILITY:
# Cursor works on ARM64 Linux (including Apple Silicon via UTM).
# The script automatically detects architecture and downloads the correct version.
# ============================================================================

set -e  # Exit on any error

echo "[5/6] Installing Cursor..."

# Check if Cursor is already installed by looking for the 'cursor' command
if command_exists cursor; then
    echo "Cursor is already installed. Skipping..."
else
    # SUBSTEP 5.1: Detect architecture and set appropriate download URL
    ARCH=$(uname -m)
    
    # Determine the correct download URL based on architecture
    if [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
        echo "ARM64 architecture detected - downloading ARM64 version..."
        # ARM64 AppImage URL for Apple Silicon and other ARM64 systems
        CURSOR_URL="https://downloader.cursor.sh/linux/appImage/arm64"
    else
        echo "x86_64 architecture detected - downloading x64 version..."
        # x86_64 AppImage URL for Intel/AMD systems
        CURSOR_URL="https://downloader.cursor.sh/linux/appImage/x64"
    fi
    
    # SUBSTEP 5.2: Define installation directory
    # We'll install Cursor in the user's local share directory
    # This follows Linux filesystem hierarchy standards for user-specific data
    CURSOR_DIR="$HOME/.local/share/cursor"
    
    # SUBSTEP 5.3: Create the installation directory
    # -p flag creates parent directories if they don't exist
    # No error is thrown if the directory already exists
    mkdir -p "$CURSOR_DIR"
    
    # SUBSTEP 5.4: Download the Cursor AppImage
    echo "Downloading Cursor..."
    # wget -O specifies the output filename and location
    # This downloads the file and saves it as cursor.AppImage
    wget -O "$CURSOR_DIR/cursor.AppImage" "$CURSOR_URL"
    
    # SUBSTEP 5.5: Make the AppImage executable
    # AppImages need execute permission to run
    # chmod +x adds execute permission for all users
    chmod +x "$CURSOR_DIR/cursor.AppImage"
    
    # SUBSTEP 5.6: Create a system-wide symbolic link
    # This allows users to run 'cursor' from anywhere in the terminal
    # -s creates a symbolic link (shortcut)
    # -f forces creation, overwriting if it already exists
    # /usr/local/bin is in PATH, so the command will be globally accessible
    sudo ln -sf "$CURSOR_DIR/cursor.AppImage" /usr/local/bin/cursor
    
    # SUBSTEP 5.7: Create a desktop entry for the application menu
    # Desktop entries allow the app to appear in your system's application launcher
    # First, ensure the applications directory exists
    mkdir -p "$HOME/.local/share/applications"
    
    # Create the .desktop file with the application metadata
    # This uses a "here document" (<<EOF...EOF) to write multiple lines
    # The .desktop file format is a standard for Linux desktop environments
    cat > "$HOME/.local/share/applications/cursor.desktop" << EOF
[Desktop Entry]
Name=Cursor
Exec=$CURSOR_DIR/cursor.AppImage %U
Terminal=false
Type=Application
Icon=cursor
StartupWMClass=Cursor
Comment=Cursor AI Code Editor
Categories=Development;IDE;
EOF
    # [Desktop Entry] - Required header for .desktop files
    # Name - The display name shown in application menus
    # Exec - Command to run when launching (%U passes URLs/files)
    # Terminal - false means don't open a terminal window
    # Type - Application indicates this is a launchable program
    # Icon - Icon name to display (cursor will use default if not found)
    # StartupWMClass - Helps window managers identify the application window
    # Comment - Description shown in application menus
    # Categories - Determines where the app appears in categorized menus
    
    echo "✓ Cursor installed successfully"
fi
