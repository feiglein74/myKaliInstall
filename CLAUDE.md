# CLAUDE.md

Diese Datei bietet Anleitung für Claude Code (claude.ai/code) bei der Arbeit mit Code in diesem Repository.

## Projektübersicht

Dies ist ein automatisiertes Installationsskript für Kali Linux, das Security-Tools und Entwicklungstools installiert und konfiguriert. Das Hauptskript `myInstall.sh` ist darauf ausgelegt, ein frisches Kali Linux System mit einer kuratierten Auswahl an Tools für Sicherheitsforschung, Netzwerkanalyse und Entwicklung einzurichten.

## Architektur

### Hauptskripte

- **myInstall.sh**: Hauptinstallationsskript (234 Zeilen)
  - Enthält wiederverwendbare Hilfsfunktionen (Zeilen 3-87) für Validierung und Paketinstallation
  - Prüft erforderliche Abhängigkeiten vor der Ausführung (Zeilen 109-117)
  - Bezieht die Update-Routine aus myUpdate.sh (Zeile 120)
  - Installiert Pakete sequenziell mittels eigener Installationsfunktionen

- **myUpdate.sh**: System-Update-Routine
  - Führt apt update, upgrade, dist-upgrade und autoremove aus
  - Wird von myInstall.sh vor den Paketinstallationen eingebunden

### Funktionsbibliothek (myInstall.sh:3-107)

Wichtige wiederverwendbare Funktionen:
- `error_exit`: Zentralisierte Fehlerbehandlung mit Exit
- `check_*`: Validierungsfunktionen für Befehle, Dateien, Verzeichnisse, URLs, Pakete
- `install-apt-package`: Idempotente apt-Paketinstallation
- `install-snap-package`: Idempotente snap-Paketinstallation

Alle Installationsfunktionen prüfen, ob ein Paket bereits installiert ist, bevor eine Installation versucht wird. Das macht das Skript wiederausführbar.

### Installationsmuster

Das Skript folgt einem konsistenten Muster für jedes Tool:
1. Kommentar mit Tool-Name und URL-Referenz
2. Paketinstallation über Hilfsfunktion ODER
3. Manuelle Installation über:
   - Verzeichniserstellung in ~/
   - GitHub API Abfrage für neueste Version
   - Download, Entpacken und Aufräumen
   - Ausführungsrechte setzen

## Wichtige Befehle

**Vollständige Installation ausführen:**
```bash
./myInstall.sh
```

**Nur System-Updates ausführen:**
```bash
./myUpdate.sh
```

## Installierte Tools nach Kategorie

**Sicherheitsanalyse:**
- hayabusa (Windows Event Log Forensik) - ~/hayabusa
- velociraptor (Endpoint Detection/Response) - ~/velociraptor
- mdk3 (Wireless Attack Tool)

**DNS-Testing:**
- dnsblast - ~/dnsblast (aus Quellcode kompiliert)
- dnspyre - ~/dnspyre
- ldnsutils (enthält drill-Befehl)

**Entwicklung:**
- VS Code (via snap --classic)
- Postman API Client

**Netzwerk:**
- ZeroTier VPN
- gping (grafisches Ping)
- tio (Serielles Terminal)

**Produktivität:**
- Obsidian (Wissensdatenbank)
- Logseq (Outliner)
- KeePassXC (Passwort-Manager)
- Thunderbird (E-Mail)
- OneDriver (OneDrive-Client)

**System-Tools:**
- terminator (Terminal-Emulator)
- btop (System-Monitor)
- parallel (GNU parallel)
- jq (JSON-Prozessor)
- x-cmd Toolkit

## Wichtige Implementierungsdetails

**GitHub API Muster:**
Das Skript verwendet ein konsistentes Muster zum Download der neuesten Releases:
```bash
curl -s https://api.github.com/repos/OWNER/REPO/releases/latest > /tmp/tool-json
cat /tmp/tool-json | /snap/bin/jq '.assets[] | select(.name|test("pattern"))' | /snap/bin/jq '.browser_download_url' | xargs wget -c {}
```

**Voraussetzungen:**
Das Skript benötigt sudo, apt, git, wget, unzip, curl und tar als vorinstalliert. Diese werden vor Beginn jeglicher Installation validiert (myInstall.sh:109-117).

**Arbeitsverzeichnis-Wechsel:**
Viele Tool-Installationen wechseln nach ~/ oder erstellen Unterverzeichnisse in ~/. Beim Hinzufügen neuer Tools sicherstellen, dass das Skript zu einem bekannten Verzeichnis zurückkehrt oder absolute Pfade verwendet.

**Snap-Paket-Behandlung:**
VS Code benötigt `--classic` Confinement-Modus (myInstall.sh:141), im Gegensatz zu anderen snap-Paketen, die standardmäßig strict confinement verwenden.

## Änderungsrichtlinien

Beim Hinzufügen neuer Tools:
1. GitHub-Referenz-URL in Kommentaren hinzufügen
2. install-apt-package oder install-snap-package Hilfsfunktionen verwenden, wenn möglich
3. Für manuelle Installationen das oben gezeigte GitHub API Muster befolgen
4. Dedizierte ~/toolname Verzeichnisse für kompilierte/entpackte Tools erstellen
5. Heruntergeladene Archive und temporäre JSON-Dateien aufräumen
6. Idempotenz sicherstellen - prüfen, ob Tool bereits installiert ist, bevor Installation versucht wird
