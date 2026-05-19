#!/bin/bash
set -e

echo "[4/7] Running pre-install configurations..."

if [ "${PRESERVE_FAVORITES:-0}" = "1" ]; then
    echo "Skipping dock favorites wipe (--preserve-favorites set)"
else
    wipe_favorites
fi

echo "✓ Pre-install configurations completed"
