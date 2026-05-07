@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

set "CONFIG_DIR=%USERPROFILE%\.hyperframes-vbc"

echo.
echo 🔄 Hyperframes Addon Reset
echo.
echo Folgende Daten werden gelöscht:
echo   - Brand-Konfiguration
echo   - Cache und temporäre Dateien
echo.
echo NICHT gelöscht werden:
echo   - Hyperframes selbst
echo   - Deine Logos in %CONFIG_DIR%\assets\
echo   - Fertige Videos im output\-Ordner
echo.
set /p confirm=Wirklich zurücksetzen? (j/N): 

if /i not "%confirm%"=="j" (
    echo ❌ Reset abgebrochen.
    pause
    exit /b 0
)

if exist "%CONFIG_DIR%\brand.config.json" (
    copy "%CONFIG_DIR%\brand.config.json" "%CONFIG_DIR%\brand.config.backup.json" >nul
    echo ✅ Backup gespeichert
)

del /q "%CONFIG_DIR%\brand.config.json" 2>nul
rmdir /s /q "%CONFIG_DIR%\cache" 2>nul

echo.
echo ✅ Reset erfolgreich!
echo.
echo Starte den Brand-Wizard mit:
echo   Sag Claude Code: "Starte den Brand-Wizard"
echo.
pause
