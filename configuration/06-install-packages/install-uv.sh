#!/bin/bash
set -e

echo "Installing UV..."

if ! command -v uv &> /dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.cargo/bin:$PATH"
    echo "✓ UV installed successfully"
else
    echo "UV is already installed. Skipping..."
fi
