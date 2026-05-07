#!/bin/bash
# Reset-Skript für Hyperframes Addon by Vibe Coding DACH

set -e

CONFIG_DIR="$HOME/.hyperframes-vbc"
INSTALL_DIR="$HOME/hyperframes-vbc"

echo ""
echo "🔄 Hyperframes Addon Reset"
echo ""
echo "Folgende Daten werden gelöscht:"
echo "  - Brand-Konfiguration ($CONFIG_DIR/brand.config.json)"
echo "  - Cache und temporäre Dateien"
echo ""
echo "NICHT gelöscht werden:"
echo "  - Hyperframes selbst"
echo "  - Deine Logos in $CONFIG_DIR/assets/"
echo "  - Fertige Videos im output/-Ordner"
echo ""
read -p "Wirklich zurücksetzen? (j/N): " confirm

if [[ ! $confirm =~ ^[JjYy]$ ]]; then
    echo "❌ Reset abgebrochen."
    exit 0
fi

# Backup der Brand-Config (für den Fall der Fälle)
if [ -f "$CONFIG_DIR/brand.config.json" ]; then
    cp "$CONFIG_DIR/brand.config.json" "$CONFIG_DIR/brand.config.backup.json"
    echo "✅ Backup unter brand.config.backup.json gespeichert"
fi

# Lösche Config (aber nicht Assets)
rm -f "$CONFIG_DIR/brand.config.json"

# Cache leeren
rm -rf "$CONFIG_DIR/cache"

echo ""
echo "✅ Reset erfolgreich!"
echo ""
echo "Starte den Brand-Wizard mit:"
echo "  Sag Claude Code: \"Starte den Brand-Wizard\""
echo ""
