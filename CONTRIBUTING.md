# 🤝 Beiträge zum Hyperframes Addon

Du willst neue Templates beisteuern oder Bugs fixen? Super!

## Neue Templates beitragen

1. Kopiere einen bestehenden Template-Ordner aus `templates/` als Basis
2. Passe `template.html` an (nutze die CSS-Variablen `--primary`, `--accent`, `--bg`, `--text`)
3. Erstelle eine `meta.json` mit allen Variablen und Szenen
4. Trage das Template in `templates.json` ein
5. Pull Request öffnen

## Template-Konventionen

- **Variablen** in `{{DOPPELTEN_GESCHWEIFTEN_KLAMMERN}}` (UPPER_SNAKE_CASE)
- **CSS-Variablen** für alles was per Brand anpassbar sein soll
- **Animations-Timings** in Sekunden, klar dokumentiert
- **Maximale Längen** für Texte in `meta.json` festlegen
- **Kommentar am Anfang** mit Liste aller Variablen

## SKILL.md Änderungen

Bei Änderungen an `SKILL.md`:
- Auf Deutsch bleiben (User-facing Sprache)
- Schritt-für-Schritt Anleitungen hinzufügen
- Anti-Patterns ergänzen wenn nötig
- Versionsnummer erhöhen

## Bug Reports

Issue auf GitHub öffnen mit:
- Betriebssystem (Windows/Mac/Linux)
- Was hast du gemacht?
- Was ist passiert?
- Was hätte passieren sollen?
- Logs aus `~/.hyperframes-vbc/cache/` falls vorhanden

## Code of Conduct

Sei nett. Sei hilfsbereit. Hilf Anfängern.

Mehr nicht.
