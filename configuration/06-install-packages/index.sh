#!/bin/bash
set -e

echo "[6/7] Installing packages..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

run_sub_module() {
    local module_path="$SCRIPT_DIR/$1"

    if [ ! -x "$module_path" ]; then
        chmod +x "$module_path"
    fi

    "$module_path"
}

run_sub_module "install-uv.sh"
run_sub_module "install-wezterm.sh"

echo "✓ All packages installed successfully"
