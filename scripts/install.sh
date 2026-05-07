#!/bin/bash

# ============================================================
#   Hyperframes Addon by Vibe Coding DACH - Mac/Linux Installer
# ============================================================

set -e

# Farben
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

INSTALL_DIR="$HOME/hyperframes-vbc"
CONFIG_DIR="$HOME/.hyperframes-vbc"
ERRORS=0

echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║                                                          ║"
echo "║   🎬 Hyperframes Addon by Vibe Coding DACH               ║"
echo "║   Installation startet...                                ║"
echo "║                                                          ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

# --- Schritt 1: Dependency-Check ---
echo -e "${BLUE}[1/6] System-Check läuft...${NC}"
echo ""

check_command() {
    if command -v $1 &> /dev/null; then
        echo -e "${GREEN}✅ $1 gefunden${NC}"
    else
        echo -e "${RED}❌ $1 fehlt${NC}"
        echo "   $2"
        ERRORS=$((ERRORS+1))
    fi
}

# OS Detection
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="mac"
    INSTALL_HINT_NODE="brew install node"
    INSTALL_HINT_PYTHON="brew install python@3.11"
    INSTALL_HINT_FFMPEG="brew install ffmpeg"
    INSTALL_HINT_GIT="brew install git"
else
    OS="linux"
    INSTALL_HINT_NODE="sudo apt install nodejs npm"
    INSTALL_HINT_PYTHON="sudo apt install python3 python3-pip"
    INSTALL_HINT_FFMPEG="sudo apt install ffmpeg"
    INSTALL_HINT_GIT="sudo apt install git"
fi

check_command "node" "Installiere mit: $INSTALL_HINT_NODE"
check_command "python3" "Installiere mit: $INSTALL_HINT_PYTHON"
check_command "ffmpeg" "Installiere mit: $INSTALL_HINT_FFMPEG"
check_command "git" "Installiere mit: $INSTALL_HINT_GIT"

echo ""
if [ $ERRORS -gt 0 ]; then
    echo -e "${YELLOW}⚠️  Es fehlen $ERRORS Tools. Installiere sie zuerst und starte dann neu.${NC}"
    exit 1
fi

# --- Schritt 2: Verzeichnisse ---
echo -e "${BLUE}[2/6] Verzeichnisse werden angelegt...${NC}"
mkdir -p "$INSTALL_DIR"
mkdir -p "$CONFIG_DIR/assets"
echo -e "${GREEN}✅ Verzeichnisse bereit${NC}"
echo ""

# --- Schritt 3: Hyperframes klonen ---
echo -e "${BLUE}[3/6] Hyperframes wird heruntergeladen...${NC}"
if [ ! -d "$INSTALL_DIR/hyperframes" ]; then
    cd "$INSTALL_DIR"
    git clone https://github.com/heygen/hyperframes.git
else
    echo -e "${YELLOW}ℹ️  Hyperframes ist schon installiert. Überspringe.${NC}"
fi
echo -e "${GREEN}✅ Hyperframes bereit${NC}"
echo ""

# --- Schritt 4: NPM ---
echo -e "${BLUE}[4/6] Node-Pakete werden installiert (kann 1-2 Minuten dauern)...${NC}"
cd "$INSTALL_DIR/hyperframes"
npm install --silent
echo -e "${GREEN}✅ Node-Pakete installiert${NC}"
echo ""

# --- Schritt 5: Faster Whisper ---
echo -e "${BLUE}[5/6] Faster Whisper wird installiert...${NC}"
pip3 install faster-whisper --quiet || echo -e "${YELLOW}⚠️  Faster Whisper konnte nicht installiert werden. Du kannst es später nachinstallieren.${NC}"
echo -e "${GREEN}✅ Faster Whisper bereit${NC}"
echo ""

# --- Schritt 6: Brand-Config ---
echo -e "${BLUE}[6/6] Standard-Konfiguration wird erstellt...${NC}"
if [ ! -f "$CONFIG_DIR/brand.config.json" ]; then
    cat > "$CONFIG_DIR/brand.config.json" << 'EOF'
{
  "version": "1.0",
  "brand": {
    "name": "Meine Marke",
    "primaryColor": "#0EA5E9",
    "accentColor": "#F59E0B",
    "backgroundColor": "#0A0A0A",
    "textColor": "#FFFFFF",
    "fontHeading": "Inter",
    "fontBody": "Inter",
    "fontMono": "JetBrains Mono",
    "logoPath": null,
    "logoPosition": "top-left",
    "language": "de"
  },
  "preferences": {
    "subtitlesEnabled": true,
    "subtitlesLanguage": "de",
    "defaultAspectRatio": "16:9",
    "outputDirectory": "./output"
  },
  "setupComplete": false
}
EOF
fi
echo -e "${GREEN}✅ Konfiguration bereit${NC}"
echo ""

echo "╔══════════════════════════════════════════════════════════╗"
echo "║                                                          ║"
echo "║   🎉 Installation erfolgreich!                           ║"
echo "║                                                          ║"
echo "║   Nächster Schritt: Sag Claude Code:                     ║"
echo "║   \"Starte den Brand-Wizard\"                              ║"
echo "║                                                          ║"
echo "║   Oder direkt:                                           ║"
echo "║   \"Mach mir ein News-Intro über AI\"                      ║"
echo "║                                                          ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""
