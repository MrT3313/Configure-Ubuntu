#!/bin/bash
# ============================================================================
# Module: Cursor Installation
# ============================================================================
# Purpose: Installs Cursor AI code editor with full desktop integration
# Includes application launcher, icon, and command-line access
#
# ARM64 COMPATIBILITY:
# Cursor works on ARM64 Linux (including Apple Silicon via UTM).
# The script automatically detects architecture and downloads the correct version.
# ============================================================================

set -e  # Exit on any error

echo "[6/7] Installing Cursor..."

# Helper function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if Cursor is already installed by looking for the 'cursor' command
if command_exists cursor; then
    echo "Cursor is already installed. Skipping..."
else
    # SUBSTEP 6.1: Detect architecture and set appropriate download URL
    ARCH=$(uname -m)
    
    if [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
        echo "ARM64 architecture detected - downloading ARM64 version..."
        CURSOR_URL="https://api2.cursor.sh/updates/download/golden/linux-arm64/cursor/latest"
    else
        echo "x86_64 architecture detected - downloading x64 version..."
        CURSOR_URL="https://api2.cursor.sh/updates/download/golden/linux-x64/cursor/latest"
    fi
    
    # SUBSTEP 6.2: Define installation directories
    CURSOR_DIR="$HOME/.local/share/cursor"
    ICON_DIR="$HOME/.local/share/icons/hicolor/512x512/apps"
    APPLICATIONS_DIR="$HOME/.local/share/applications"
    
    # SUBSTEP 6.3: Create the installation directories
    mkdir -p "$CURSOR_DIR"
    mkdir -p "$ICON_DIR"
    mkdir -p "$APPLICATIONS_DIR"
    
    # SUBSTEP 6.4: Download the Cursor AppImage
    echo "Downloading Cursor AppImage..."
    
    if command_exists curl; then
        curl -L -o "$CURSOR_DIR/cursor.AppImage" "$CURSOR_URL"
    elif command_exists wget; then
        wget -O "$CURSOR_DIR/cursor.AppImage" "$CURSOR_URL"
    else
        echo "Error: Neither curl nor wget is installed."
        exit 1
    fi
    
    # Check if download was successful
    if [ ! -f "$CURSOR_DIR/cursor.AppImage" ] || [ ! -s "$CURSOR_DIR/cursor.AppImage" ]; then
        echo "Error: Failed to download the Cursor AppImage."
        exit 1
    fi
    
    echo "Download complete."
    
    # SUBSTEP 6.5: Make the AppImage executable
    chmod +x "$CURSOR_DIR/cursor.AppImage"
    
    # SUBSTEP 6.6: Extract icon from AppImage
    echo "Extracting icon from AppImage..."
    
    # Try to extract icon using AppImage's built-in extraction
    cd "$CURSOR_DIR"
    ./cursor.AppImage --appimage-extract >/dev/null 2>&1 || true
    
    # Look for icon in extracted files
    if [ -f "squashfs-root/cursor.png" ]; then
        cp "squashfs-root/cursor.png" "$ICON_DIR/cursor.png"
        echo "✓ Icon extracted successfully"
    elif [ -f "squashfs-root/resources/app/icon.png" ]; then
        cp "squashfs-root/resources/app/icon.png" "$ICON_DIR/cursor.png"
        echo "✓ Icon extracted successfully"
    elif [ -f "squashfs-root/usr/share/icons/hicolor/512x512/apps/cursor.png" ]; then
        cp "squashfs-root/usr/share/icons/hicolor/512x512/apps/cursor.png" "$ICON_DIR/cursor.png"
        echo "✓ Icon extracted successfully"
    else
        # Fallback: download icon from a reliable source
        echo "Extracting icon failed, downloading from web..."
        if command_exists curl; then
            curl -L -o "$ICON_DIR/cursor.png" "https://www.cursor.com/brand/icon.png" 2>/dev/null || \
            curl -L -o "$ICON_DIR/cursor.png" "https://avatars.githubusercontent.com/u/124628009?s=200&v=4" 2>/dev/null || \
            echo "Warning: Could not download icon"
        fi
    fi
    
    # Clean up extracted files
    rm -rf squashfs-root
    
    # SUBSTEP 6.7: Create a symbolic link for command-line access
    sudo ln -sf "$CURSOR_DIR/cursor.AppImage" /usr/local/bin/cursor
    
    # SUBSTEP 6.8: Create desktop entry for application launcher
    echo "Creating desktop launcher..."
    cat > "$APPLICATIONS_DIR/cursor.desktop" << EOF
[Desktop Entry]
Name=Cursor
Comment=The AI Code Editor
Exec=$CURSOR_DIR/cursor.AppImage %U
Icon=cursor
Terminal=false
Type=Application
StartupWMClass=Cursor
Categories=Development;IDE;TextEditor;
MimeType=text/plain;text/x-c;text/x-c++;text/x-java;text/x-python;application/x-shellscript;
StartupNotify=true
Keywords=cursor;editor;development;ide;code;ai;
EOF
    
    # SUBSTEP 6.9: Make the desktop entry executable
    chmod +x "$APPLICATIONS_DIR/cursor.desktop"
    
    # SUBSTEP 6.10: Update desktop database to register the application
    if command_exists update-desktop-database; then
        update-desktop-database "$APPLICATIONS_DIR" 2>/dev/null || true
    fi
    
    # SUBSTEP 6.11: Update icon cache
    if command_exists gtk-update-icon-cache; then
        gtk-update-icon-cache -f -t "$HOME/.local/share/icons/hicolor" 2>/dev/null || true
    fi
    
    echo "✓ Cursor installed successfully"
    echo "  - Launch from Applications menu: Search for 'Cursor'"
    echo "  - Or run from terminal: 'cursor'"
    echo "  - Installed to: $CURSOR_DIR/cursor.AppImage"
    echo ""
    echo "Note: If icon doesn't appear immediately, log out and back in, or run:"
    echo "  gtk-update-icon-cache -f -t ~/.local/share/icons/hicolor"
fi