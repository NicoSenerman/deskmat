#!/usr/bin/env bash
set -euo pipefail

INSTALL_DIR="${HOME}/.local/bin"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing deskmat..."

# Create install directory
mkdir -p "$INSTALL_DIR"

# Copy the script
cp "$SCRIPT_DIR/deskmat" "$INSTALL_DIR/deskmat"
chmod +x "$INSTALL_DIR/deskmat"

echo "  Installed to: $INSTALL_DIR/deskmat"

# Copy example config if no config exists
CONFIG_DIR="${HOME}/.config/deskmat"
if [ ! -f "$CONFIG_DIR/config.yaml" ]; then
    mkdir -p "$CONFIG_DIR"
    cp "$SCRIPT_DIR/config.example.yaml" "$CONFIG_DIR/config.yaml"
    echo "  Config copied to: $CONFIG_DIR/config.yaml"
else
    echo "  Config already exists: $CONFIG_DIR/config.yaml (not overwritten)"
fi

# Check dependencies
echo ""
echo "Checking dependencies..."
ok=true

check_pkg() {
    if python3 -c "import gi; gi.require_version('$1', '$2')" 2>/dev/null; then
        echo "  [ok] $1 $2"
    else
        echo "  [!!] $1 $2 — not found"
        ok=false
    fi
}

check_cmd() {
    if command -v "$1" &>/dev/null; then
        echo "  [ok] $1"
    else
        echo "  [!!] $1 — not found (optional: $2)"
    fi
}

check_pkg "Gtk" "4.0"
check_pkg "Gtk4LayerShell" "1.0"
check_cmd "tldr" "install tealdeer for tldr integration"

if python3 -c "import yaml" 2>/dev/null; then
    echo "  [ok] PyYAML"
else
    echo "  [!!] PyYAML — not found (needed for config files: pip install pyyaml)"
fi

echo ""
if [ "$ok" = true ]; then
    echo "Done! Run 'deskmat' to launch, or bind it to a key in your WM config."
else
    echo "Done! Some dependencies are missing — install them before running deskmat."
fi

# Check PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo ""
    echo "Note: $INSTALL_DIR is not in your PATH."
    echo "Add this to your shell config (~/.zshrc or ~/.bashrc):"
    echo "  export PATH=\"\$PATH:$HOME/.local/bin\""
fi
