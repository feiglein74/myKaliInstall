# myKaliInstall

Automatisiertes Shell-Script zur Installation und Konfiguration einer umfassenden Sammlung von Security-Tools, Entwicklungstools und Produktivitätsanwendungen für Kali Linux.

## Beschreibung

Dieses Script richtet ein frisches Kali Linux System mit einer kuratierten Auswahl an Tools für:
- **Sicherheitsanalyse**: Forensik, Endpoint Detection, Wireless Testing
- **DNS-Testing**: Lasttest-Tools und erweiterte DNS-Utilities
- **Entwicklung**: VS Code, Postman, API-Testing
- **Netzwerk**: VPN, Monitoring, Serial Terminal
- **Produktivität**: Wissensdatenbank, Passwort-Manager, E-Mail

## Voraussetzungen

Das Script prüft automatisch, ob folgende Tools installiert sind:
- `sudo`
- `apt` (Debian-basiertes System)
- `git`
- `wget`
- `unzip`
- `curl`
- `tar`

## Verwendung

### Vollständige Installation ausführen

```bash
chmod +x myInstall.sh
./myInstall.sh
```

Das Script führt automatisch ein System-Update durch und installiert anschließend alle Tools.

### Nur System-Updates ausführen

```bash
chmod +x myUpdate.sh
./myUpdate.sh
```

## Installierte Tools

### Sicherheitsanalyse
- **Hayabusa**: Windows Event Log Forensik (~hayabusa)
- **Velociraptor**: Endpoint Detection and Response (~velociraptor)
- **mdk3**: Wireless Attack Tool

### DNS-Testing
- **dnsblast**: DNS Load Testing (~dnsblast)
- **dnspyre**: DNS Performance Testing (~dnspyre)
- **ldnsutils**: Erweiterte DNS-Utilities (inkl. drill)

### Entwicklung
- **Visual Studio Code**: Code-Editor
- **Postman**: API-Testing und Entwicklung

### Netzwerk
- **ZeroTier**: VPN-Lösung
- **gping**: Grafisches Ping-Tool
- **tio**: Serielles Terminal

### Produktivität
- **Obsidian**: Wissensdatenbank
- **Logseq**: Outliner und Notizen
- **KeePassXC**: Passwort-Manager
- **Thunderbird**: E-Mail-Client
- **OneDriver**: OneDrive-Client für Linux

### System-Tools
- **Terminator**: Erweiterter Terminal-Emulator
- **btop**: Moderner System-Monitor
- **GNU Parallel**: Parallelverarbeitung
- **jq**: JSON-Prozessor
- **x-cmd**: Umfangreiches Toolkit
- **Google Chrome**: Webbrowser

## Besonderheiten

- **Idempotent**: Das Script kann beliebig oft ausgeführt werden - bereits installierte Pakete werden übersprungen
- **GitHub API**: Neueste Releases werden automatisch via GitHub API heruntergeladen
- **Fehlerbehandlung**: Umfassende Validierung und Fehlerprüfung
- **Tool-Verzeichnisse**: Kompilierte/entpackte Tools werden in dedizierten Verzeichnissen unter ~/ abgelegt

## Hinweise

- Das Script benötigt sudo-Rechte für die Installation
- Einige Tools werden aus Quellen kompiliert (z.B. dnsblast)
- VS Code wird mit `--classic` confinement installiert
- Die Installation kann je nach Internetverbindung einige Zeit dauern

## Dokumentation

Detaillierte Informationen zur Architektur und Erweiterung des Scripts finden Sie in [CLAUDE.md](CLAUDE.md).
