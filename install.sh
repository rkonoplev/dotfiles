#!/bin/bash
# Phoebe Terminal Configuration Installer
set -e

echo "🚀 Installing Phoebe terminal configuration..."
echo "============================================"

# Backup existing config
BACKUP_FILE="$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
if [ -f "$HOME/.zshrc" ]; then
    cp "$HOME/.zshrc" "$BACKUP_FILE"
    echo "📦 Backed up existing .zshrc to: $BACKUP_FILE"
fi

# Determine script location (with fallback for curl | bash)
if [ -n "${BASH_SOURCE[0]}" ] && [ -f "${BASH_SOURCE[0]}" ]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    CONFIG_FILE="$SCRIPT_DIR/.zshrc"
else
    # Fallback for curl ... | bash
    echo "📥 Downloading .zshrc from repository..."
    curl -s -o "$HOME/.zshrc" "https://raw.githubusercontent.com/rkonoplev/dotfiles/main/.zshrc"
    CONFIG_FILE="$HOME/.zshrc"
fi

if [ -f "$CONFIG_FILE" ]; then
    cp "$CONFIG_FILE" "$HOME/.zshrc"
    echo "✅ Configuration installed successfully!"
else
    echo "❌ Error: .zshrc not found"
    exit 1
fi

echo ""
echo "🎉 Installation complete!"
echo ""
echo "Available commands:"
echo "  p, pbe, pfe - Navigate to Phoebe project"
echo "  gw, make    - Build commands"
echo "  phi         - Show Phoebe commands"
echo "  dclean-step - Clean Docker"
echo "  pstatus     - Check system status"
echo ""
echo "Restart terminal or run: source ~/.zshrc"
echo ""