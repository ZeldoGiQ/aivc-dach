@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

REM ============================================================
REM   Hyperframes Addon by Vibe Coding DACH - Windows Installer
REM ============================================================

echo.
echo ╔══════════════════════════════════════════════════════════╗
echo ║                                                          ║
echo ║   🎬 Hyperframes Addon by Vibe Coding DACH               ║
echo ║   Installation startet...                                ║
echo ║                                                          ║
echo ╚══════════════════════════════════════════════════════════╝
echo.

set "INSTALL_DIR=%USERPROFILE%\hyperframes-vbc"
set "CONFIG_DIR=%USERPROFILE%\.hyperframes-vbc"
set "ERRORS=0"

REM --- Schritt 1: Dependency-Check ---
echo [1/6] System-Check läuft...
echo.

where node >nul 2>nul
if %errorlevel% neq 0 (
    echo ❌ Node.js fehlt
    echo    Installiere mit: winget install OpenJS.NodeJS
    set /a ERRORS+=1
) else (
    echo ✅ Node.js gefunden
)

where python >nul 2>nul
if %errorlevel% neq 0 (
    echo ❌ Python fehlt
    echo    Installiere mit: winget install Python.Python.3.11
    set /a ERRORS+=1
) else (
    echo ✅ Python gefunden
)

where ffmpeg >nul 2>nul
if %errorlevel% neq 0 (
    echo ❌ ffmpeg fehlt
    echo    Installiere mit: winget install Gyan.FFmpeg
    set /a ERRORS+=1
) else (
    echo ✅ ffmpeg gefunden
)

where git >nul 2>nul
if %errorlevel% neq 0 (
    echo ❌ Git fehlt
    echo    Installiere mit: winget install Git.Git
    set /a ERRORS+=1
) else (
    echo ✅ Git gefunden
)

echo.
if %ERRORS% gtr 0 (
    echo ⚠️  Es fehlen %ERRORS% Tools. Installiere sie zuerst und starte dann neu.
    echo.
    pause
    exit /b 1
)

REM --- Schritt 2: Verzeichnisse anlegen ---
echo [2/6] Verzeichnisse werden angelegt...
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"
if not exist "%CONFIG_DIR%" mkdir "%CONFIG_DIR%"
if not exist "%CONFIG_DIR%\assets" mkdir "%CONFIG_DIR%\assets"
echo ✅ Verzeichnisse bereit
echo.

REM --- Schritt 3: Hyperframes klonen ---
echo [3/6] Hyperframes wird heruntergeladen...
if not exist "%INSTALL_DIR%\hyperframes" (
    cd /d "%INSTALL_DIR%"
    git clone https://github.com/heygen/hyperframes.git
    if %errorlevel% neq 0 (
        echo ❌ Konnte Hyperframes nicht klonen.
        echo    Prüfe deine Internet-Verbindung.
        pause
        exit /b 1
    )
) else (
    echo ℹ️  Hyperframes ist schon installiert. Überspringe.
)
echo ✅ Hyperframes bereit
echo.

REM --- Schritt 4: NPM Dependencies ---
echo [4/6] Node-Pakete werden installiert (kann 1-2 Minuten dauern)...
cd /d "%INSTALL_DIR%\hyperframes"
call npm install --silent
if %errorlevel% neq 0 (
    echo ❌ npm install fehlgeschlagen.
    pause
    exit /b 1
)
echo ✅ Node-Pakete installiert
echo.

REM --- Schritt 5: Faster Whisper ---
echo [5/6] Faster Whisper wird installiert...
pip install faster-whisper --quiet
if %errorlevel% neq 0 (
    echo ⚠️  Faster Whisper konnte nicht installiert werden.
    echo    Du kannst es später manuell nachinstallieren.
)
echo ✅ Faster Whisper bereit
echo.

REM --- Schritt 6: Brand-Config anlegen (Default) ---
echo [6/6] Standard-Konfiguration wird erstellt...
if not exist "%CONFIG_DIR%\brand.config.json" (
    (
    echo {
    echo   "version": "1.0",
    echo   "brand": {
    echo     "name": "Meine Marke",
    echo     "primaryColor": "#0EA5E9",
    echo     "accentColor": "#F59E0B",
    echo     "backgroundColor": "#0A0A0A",
    echo     "textColor": "#FFFFFF",
    echo     "fontHeading": "Inter",
    echo     "fontBody": "Inter",
    echo     "fontMono": "JetBrains Mono",
    echo     "logoPath": null,
    echo     "logoPosition": "top-left",
    echo     "language": "de"
    echo   },
    echo   "preferences": {
    echo     "subtitlesEnabled": true,
    echo     "subtitlesLanguage": "de",
    echo     "defaultAspectRatio": "16:9",
    echo     "outputDirectory": "./output"
    echo   },
    echo   "setupComplete": false
    echo }
    ) > "%CONFIG_DIR%\brand.config.json"
)
echo ✅ Konfiguration bereit
echo.

REM --- Fertig ---
echo ╔══════════════════════════════════════════════════════════╗
echo ║                                                          ║
echo ║   🎉 Installation erfolgreich!                           ║
echo ║                                                          ║
echo ║   Nächster Schritt: Sag Claude Code:                     ║
echo ║   "Starte den Brand-Wizard"                              ║
echo ║                                                          ║
echo ║   Oder direkt:                                           ║
echo ║   "Mach mir ein News-Intro über AI"                      ║
echo ║                                                          ║
echo ╚══════════════════════════════════════════════════════════╝
echo.
pause
