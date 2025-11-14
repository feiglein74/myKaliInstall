# TODO - Verbesserungsvorschläge für myKaliInstall

## 🔴 Kritische Probleme

### 1. Hardcodierte Versionsnummern beheben
**Priorität:** Hoch
**Aufwand:** 5-10 Minuten
**Dateien:** myInstall.sh:155-158

**Problem:**
```bash
unzip -o -qq hayabusa-3.3.0-lin-x64-musl.zip
```
Bei neuem Release bricht das Script, da der Dateiname hardcodiert ist.

**Lösung:**
Versionsnummer dynamisch aus GitHub API extrahieren und in Variable speichern.

---

### 2. mkdir ohne Fehlerbehandlung
**Priorität:** Hoch
**Aufwand:** 2 Minuten
**Dateien:** myInstall.sh (mehrere Stellen)

**Problem:**
```bash
mkdir ~/hayabusa
```
Schlägt fehl, wenn Verzeichnis bereits existiert.

**Lösung:**
```bash
mkdir -p ~/hayabusa
```
Oder Existenzprüfung vor mkdir durchführen.

---

### 3. Fehlende Cleanup-Schritte
**Priorität:** Hoch
**Aufwand:** 2 Minuten
**Dateien:** myInstall.sh:169 (Velociraptor), weitere

**Problem:**
- `rm /tmp/velociraptor-json` fehlt nach Velociraptor-Installation
- Inkonsistente Bereinigung temporärer JSON-Dateien

**Lösung:**
Cleanup nach jeder Tool-Installation konsistent durchführen.

---

## 🟡 Mittlere Priorität

### 4. Logging-Funktion hinzufügen
**Priorität:** Mittel
**Aufwand:** 10 Minuten

**Problem:**
Keine strukturierte Protokollierung, schwer nachzuvollziehen wo Fehler auftreten.

**Lösung:**
- Log-Datei mit Timestamps erstellen
- Funktion `log_message()` für einheitliches Logging
- Log-Datei: `~/myKaliInstall.log` oder `/var/log/myKaliInstall.log`

**Beispiel:**
```bash
function log_message {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOGFILE"
}
```

---

### 5. Konfigurierbarkeit ermöglichen
**Priorität:** Mittel
**Aufwand:** 30 Minuten

**Problem:**
Alle Tools werden immer installiert, keine Auswahlmöglichkeit.

**Lösung:**
- Konfigurationsdatei `myKaliInstall.conf` mit aktivierbaren/deaktivierbaren Tools
- Oder: Kommandozeilenparameter für selektive Installation
- Oder: Interaktiver Modus mit Auswahl

**Beispiel:**
```bash
./myInstall.sh --only="security,dns"
./myInstall.sh --skip="productivity"
```

---

### 6. Rollback-Funktion
**Priorität:** Mittel
**Aufwand:** 20 Minuten

**Problem:**
Bei Fehler bleibt System in inkonsistentem Zustand.

**Lösung:**
- Liste installierter Pakete in temporärer Datei führen
- Bei Fehler: Deinstallation der bereits installierten Pakete anbieten
- Backup-Funktion für kritische Konfigurationsdateien

---

### 7. Update-Funktion für Tools
**Priorität:** Mittel
**Aufwand:** 15 Minuten

**Problem:**
Bereits installierte Tools werden nicht aktualisiert, nur übersprungen.

**Lösung:**
- Neues Script `myToolUpdate.sh` für Updates bereits installierter Tools
- Oder: Parameter `--force-update` in myInstall.sh
- Versionsprüfung vor Update

---

## 🟢 Nice-to-Have

### 8. Funktionstests nach Installation
**Priorität:** Niedrig
**Aufwand:** 15 Minuten

**Problem:**
Keine Validierung, ob installierte Tools funktionieren.

**Lösung:**
- Einfache Tests nach Installation: `tool --version`
- Erfolgs-/Fehlerliste am Ende ausgeben
- Optional: Umfangreichere Funktionsprüfungen

---

### 9. Versionsverfolgung
**Priorität:** Niedrig
**Aufwand:** 10 Minuten

**Problem:**
Unklar, welche Tool-Versionen installiert sind.

**Lösung:**
- Datei `installed_versions.txt` anlegen
- Nach jeder Installation Version speichern
- Befehl zum Auflisten aller Versionen

**Format:**
```
hayabusa: 3.3.0 (installiert: 2025-11-14)
velociraptor: 0.72.3 (installiert: 2025-11-14)
```

---

### 10. Pfad-Management verbessern
**Priorität:** Niedrig
**Aufwand:** 20 Minuten

**Problem:**
Viele `cd` Befehle können zu unerwarteten Problemen führen.

**Lösung:**
- Subshells für Tool-Installation verwenden
- Oder: Absolute Pfade konsequent nutzen
- Oder: Immer zu bekanntem Verzeichnis zurückkehren

**Beispiel mit Subshell:**
```bash
(
  cd ~/hayabusa || exit 1
  # Installation
)
# Automatisch zurück im ursprünglichen Verzeichnis
```

---

## 📋 Zusätzliche Ideen

### 11. Abhängigkeitsprüfung erweitern
- Prüfen, ob genug Speicherplatz verfügbar ist
- Internetverbindung vor Download prüfen
- Debian-Version prüfen (Kali-spezifisch)

### 12. Fortschrittsanzeige
- Prozentuale Fortschrittsanzeige
- Geschätzte verbleibende Zeit
- Visuelles Feedback (Progressbar)

### 13. Modularisierung
- Funktionen in separate Dateien auslagern
- `lib/functions.sh`, `lib/installers.sh`
- Bessere Wartbarkeit und Testbarkeit

### 14. CI/CD Integration
- GitHub Actions für automatische Tests
- Regelmäßige Prüfung auf neue Tool-Versionen
- Automatische Updates der README mit neuesten Versionen

---

## 🎯 Empfohlene Reihenfolge

**Phase 1 - Quick Wins (30 Minuten):**
1. mkdir -p verwenden (#2)
2. Cleanup vervollständigen (#3)
3. Hardcodierte Versionen beheben (#1)

**Phase 2 - Stabilität (1 Stunde):**
4. Logging hinzufügen (#4)
5. Funktionstests implementieren (#8)
6. Versionsverfolgung (#9)

**Phase 3 - Features (2 Stunden):**
7. Update-Funktion (#7)
8. Konfigurierbarkeit (#5)
9. Pfad-Management (#10)

**Phase 4 - Fortgeschritten (optional):**
10. Rollback-Funktion (#6)
11. Modularisierung (#13)
12. CI/CD (#14)
