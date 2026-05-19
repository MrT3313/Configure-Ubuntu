#!/bin/bash
set -e

echo "[5/7] Installing applications..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

run_sub_module() {
    local module_path="$SCRIPT_DIR/$1"

    if [ ! -x "$module_path" ]; then
        chmod +x "$module_path"
    fi

    "$module_path"
}

run_sub_module "install-chromium.sh"
run_sub_module "install-vscode.sh"
run_sub_module "install-cursor.sh"

echo "✓ All applications installed successfully"
