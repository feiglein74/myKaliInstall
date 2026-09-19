# Changelog

Alle wichtigen Änderungen an diesem Projekt werden in dieser Datei dokumentiert.

Das Format basiert auf [Keep a Changelog](https://keepachangelog.com/de/1.0.0/),
und dieses Projekt folgt [Semantic Versioning](https://semver.org/lang/de/).

## [Unreleased]

### Added
- TODO.md mit strukturierten Verbesserungsvorschlägen
- .gitignore für besseres Repository-Management
- CLAUDE.md mit umfassender Projektdokumentation auf Deutsch
- README.md umfassend erweitert mit Kategorien und Beschreibungen
- CHANGELOG.md für Versionsverfolgung

### Changed
- Alle Kommentare und Fehlermeldungen auf Deutsch übersetzt
- README.md auf Deutsch übersetzt und erweitert

## [1.5.0] - 2026-09-19

### Fixed
- **Hayabusa wurde bei jedem Lauf neu installiert**: Der Release-Tag (`v4.1.0`)
  wurde gegen die aus dem Asset-Dateinamen extrahierte Version (`4.1.0`)
  verglichen - der Vergleich konnte nie zutreffen. Fuehrendes `v` wird nun entfernt.
- **Abbruch bei GitHub-Rate-Limit**: `curl -s` ohne `-f` schrieb Fehlerantworten
  in die JSON-Datei; der Fehler trat erst spaeter als kryptischer jq-Abbruch auf.
  Neue Funktion `fetch_latest_release` prueft HTTP-Status und `tag_name` und
  meldet die API-Ursache im Klartext.
- **Pfadabhaengiges `source ./myUpdate.sh`**: Das Skript lief nur aus dem
  Repo-Verzeichnis heraus. Nutzt jetzt `SCRIPT_DIR` (via `BASH_SOURCE`).
- **`x-cmd` beendete das Skript**: Das Bootstrap-Script referenziert
  `$ZSH_VERSION`, was unter `set -u` die Shell sofort beendet - das `||` griff
  dabei nicht. Der `eval` laeuft jetzt in einer Subshell ohne `-e`/`-u`.
- **snapd-Initialisierung**: `sudo snap wait system seed.loaded` nach der
  snapd-Installation verhindert "too early for operation" beim ersten
  `snap install` auf frischen Systemen.

### Changed
- `jq` wird ueber apt statt snap installiert; der hart verdrahtete Pfad
  `/snap/bin/jq` entfaellt an 8 Stellen.
- `install-snap-package` prueft mit `snap list` statt `command -v` - der
  Binary-Name weicht teils vom Snap-Namen ab und `/snap/bin` liegt nicht in
  jeder Shell im PATH.

## [1.0.0] - 2024-11-14

### Added
- **Velociraptor**: Endpoint Detection and Response Tool
- **foremost**: Datenrettungstool
- **Glogg**: Logfile Reader
- **Tor Browser**: Anonymer Webbrowser
- **Homebrew**: Paketmanager (mit Fingerabdruck-Leser Support)
- **VMWARE Workstation**: Abhängigkeiten hinzugefügt
- **Thunderbird**: E-Mail-Client
- **ldnsutils**: DNS-Utilities (drill-Befehl)
- **mdk3**: Wireless Attack Tool mit Dokumentation
- **ZeroTier**: VPN-Lösung
- **Logseq**: Outliner und Wissensmanagement
- **KeePassXC**: Passwort-Manager
- **Postman**: API-Testing Tool
- **Hayabusa**: Windows Event Log Forensik

### Changed
- Quiet-Mode für apt in Update-Routine aktiviert
- Silent-Mode für curl und wget aktiviert
- Unzip mit `-o` Flag für Hayabusa (Überschreiben ohne Nachfrage)
- Unzip mit `-qq` Flag für Hayabusa (Quiet-Mode)
- Farbreset nach Hayabusa-Installation (ANSI-Reset)
- Individuelle JSON-Dateien für jede Git-Versionsprüfung

### Fixed
- Bugfix für Visual Studio Code Installation und apt -qq
- Snapd Initialisierung korrigiert für jq-Installation

### Technical Improvements
- Install-Funktionen für alle apt und snap Pakete eingeführt
- Modulare App-Installation mit Wiederverwendbarkeit
- snapd aus Check_Command entfernt (separate Behandlung)

## [0.1.0] - 2024-XX-XX

### Added
- Initiales Repository
- Grundlegende Skriptstruktur mit Fehlerbehandlung
- Check-Funktionen für Abhängigkeiten
- System-Update-Routine (myUpdate.sh)
- Basis-Installationen:
  - Terminator (Terminal-Emulator)
  - snapd (Snap-Paketmanager)
  - GNU Parallel
  - btop (System-Monitor)
  - Visual Studio Code
  - jq (JSON-Prozessor)
  - x-cmd Toolkit
  - dnspyre (DNS-Performance-Testing)
  - dnsblast (DNS-Load-Testing)
  - tio (Serielles Terminal)
  - gping (Grafisches Ping)
  - Obsidian (Wissensdatenbank)
  - OneDriver (OneDrive-Client)
  - Google Chrome

---

## Legende

- **Added**: Neue Features
- **Changed**: Änderungen an bestehender Funktionalität
- **Deprecated**: Bald zu entfernende Features
- **Removed**: Entfernte Features
- **Fixed**: Fehlerbehebungen
- **Security**: Sicherheitsupdates
