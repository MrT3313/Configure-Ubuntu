#!/bin/bash
set -e

echo "Installing WezTerm..."

if ! command -v wezterm &> /dev/null; then
    sudo apt-get update
    sudo apt-get install -y wget gpg apt-transport-https
    curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
    echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
    sudo apt-get update
    sudo apt-get install -y wezterm
    echo "✓ WezTerm installed successfully"
else
    echo "WezTerm is already installed. Skipping..."
fi

add_to_favorites "org.wezfurlong.wezterm.desktop"
