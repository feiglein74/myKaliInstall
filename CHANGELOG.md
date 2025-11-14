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
