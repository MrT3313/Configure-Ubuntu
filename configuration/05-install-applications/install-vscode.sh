#!/bin/bash
# ============================================================================
# Module: Visual Studio Code Installation
# ============================================================================
# Purpose: Installs Microsoft's VS Code editor
# VS Code is installed from Microsoft's official repository for the latest version
# Supports both x86_64 and ARM64 architectures
# ============================================================================

set -e  # Exit on any error

echo "Installing VS Code..."

# Check if VS Code is already installed by looking for the 'code' command
if command_exists code; then
    echo "VS Code is already installed. Skipping..."
else
    # SUBSTEP 4.1: Download and install Microsoft's GPG key
    # The GPG key is used to verify that packages are authentic and from Microsoft
    # wget -qO- downloads the key quietly and outputs to stdout
    # gpg --dearmor converts the key to a format apt can use
    # The result is saved as packages.microsoft.gpg
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    
    # SUBSTEP 4.2: Install the GPG key to the system keyring
    # -D creates any necessary parent directories
    # -o root -g root sets owner and group to root
    # -m 644 sets read permissions for all, write only for owner
    sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
    
    # SUBSTEP 4.3: Add VS Code repository to apt sources
    # This tells apt where to download VS Code from
    # [arch=...] specifies which architectures are supported (including ARM64)
    # [signed-by=...] tells apt which key to use for verification
    # | sudo tee redirects the output to the file with sudo privileges
    # > /dev/null suppresses the console output from tee
    echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
    
    # SUBSTEP 4.4: Update package list to include the new VS Code repository
    sudo apt update
    
    # SUBSTEP 4.5: Install VS Code package
    # -y automatically confirms the installation
    # apt will automatically select the correct architecture (x86_64 or ARM64)
    sudo apt install -y code
    
    # SUBSTEP 4.6: Clean up temporary files
    # Remove the temporary GPG key file we created
    rm -f packages.microsoft.gpg
    
    echo "✓ VS Code installed successfully"
fi

add_to_favorites "code.desktop"
