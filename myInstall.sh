#!/bin/bash
set -euo pipefail

# Version
VERSION="1.6.0"

# Versionsinformation anzeigen
if [[ "${1:-}" == "--version" ]] || [[ "${1:-}" == "-v" ]]; then
  echo "myKaliInstall v${VERSION}"
  exit 0
fi

# Verzeichnis dieses Skripts, unabhaengig vom aktuellen Arbeitsverzeichnis
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

function error_exit {
  echo "Fehler: $1" >&2
  exit 1
}

function check_command {
  if ! command -v "$1" &> /dev/null; then
    error_exit "Befehl '$1' nicht gefunden. Bitte zuerst installieren."
  fi
}

function check_file {
  if [ ! -f "$1" ]; then
    error_exit "Datei '$1' nicht gefunden. Bitte sicherstellen, dass sie existiert."
  fi
}

function check_directory {
  if [ ! -d "$1" ]; then
    error_exit "Verzeichnis '$1' nicht gefunden. Bitte sicherstellen, dass es existiert."
  fi
}

function check_url {
  if ! curl --output /dev/null --silent --head --fail "$1"; then
    error_exit "URL '$1' ist nicht erreichbar. Bitte Internetverbindung prüfen."
  fi
}

function check_package {
  if ! dpkg-query -W -f='${Status}' "$1" 2>/dev/null | grep -q "install ok installed"; then
    error_exit "Paket '$1' ist nicht installiert. Bitte zuerst installieren."
  fi
}

function check_snap {
  if ! snap list | grep -q "$1"; then
    error_exit "Snap-Paket '$1' ist nicht installiert. Bitte zuerst installieren."
  fi
}

function check_git {
  if ! git --version &> /dev/null; then
    error_exit "Git ist nicht installiert. Bitte zuerst installieren."
  fi
}

function check_wget {
  if ! wget --version &> /dev/null; then
    error_exit "Wget ist nicht installiert. Bitte zuerst installieren."
  fi
}

function check_unzip {
  if ! unzip -v &> /dev/null; then
    error_exit "Unzip ist nicht installiert. Bitte zuerst installieren."
  fi
}

function check_curl {
  if ! curl --version &> /dev/null; then
    error_exit "Curl ist nicht installiert. Bitte zuerst installieren."
  fi
}

function check_sudo {
  if ! sudo -v &> /dev/null; then
    error_exit "Sudo ist nicht konfiguriert. Bitte zuerst konfigurieren."
  fi
}

function check_apt {
  if ! command -v apt &> /dev/null; then
    error_exit "APT Paketmanager ist nicht verfügbar. Bitte Debian-basiertes System verwenden."
  fi
}

function check_apt_package {
  local package="$1"
  if dpkg-query -W -f='${Status}' "$package" 2>/dev/null | grep -q "install ok installed"; then
    echo "$package ist bereits installiert."
  else
    echo "$package ist nicht installiert."
  fi
}

# Laedt die Release-Info von GitHub nach $2 und gibt den Tag-Namen aus.
# Faengt zwei Faelle ab, die sonst erst spaeter als kryptischer jq-Fehler
# auftauchen: nicht erreichbare API (curl -f) und das GitHub-Rate-Limit
# von 60 Anfragen/Stunde ohne Token (dann fehlt tag_name in der Antwort).
function fetch_latest_release {
  local repo="$1" json="$2" tag msg
  if ! curl -fsS "https://api.github.com/repos/${repo}/releases/latest" -o "$json"; then
    error_exit "GitHub-API fuer '${repo}' nicht erreichbar. Internetverbindung pruefen."
  fi
  tag=$(jq -r '.tag_name // empty' "$json")
  if [[ -z "$tag" ]]; then
    msg=$(jq -r '.message // "unerwartete Antwort"' "$json")
    rm -f "$json"
    error_exit "Keine Release-Info fuer '${repo}': ${msg}"
  fi
  printf '%s\n' "$tag"
}

function install-apt-package {
  local package="$1"
  if dpkg-query -W -f='${Status}' "$package" 2>/dev/null | grep -q "install ok installed"; then
    echo "$package ist bereits installiert."
  else
    echo "Installiere $package..."
    sudo apt -qq -y install "$package" || error_exit "Installation von $package fehlgeschlagen."
  fi
}

function install-snap-package {
  local package="$1"
  # snap list statt command -v: der Binary-Name weicht teils vom Snap-Namen ab
  # und /snap/bin liegt nicht in jeder Shell im PATH.
  if snap list "$package" &> /dev/null; then
    echo "$package ist bereits installiert."
  else
    echo "Installiere $package..."
    sudo snap install "$package" || error_exit "Installation von $package fehlgeschlagen."
  fi
}

# Prüfe erforderliche Befehle
check_command "sudo"
check_command "apt"
check_command "git"
check_command "wget"
check_command "unzip"
check_command "curl"
check_command "tar"


# Update-Routine (absoluter Pfad, damit das Skript aus jedem
# Arbeitsverzeichnis heraus startbar ist)
source "${SCRIPT_DIR}/myUpdate.sh"
#
# https://github.com/gnome-terminator/terminator
install-apt-package "terminator"

# https://snapcraft.io/store
install-apt-package "snapd"
sudo systemctl enable --now snapd snapd.apparmor
# Auf frischen Systemen ist snapd direkt nach der Installation noch nicht
# initialisiert; ohne dieses Warten scheitert der erste snap install mit
# "too early for operation".
sudo snap wait system seed.loaded
sudo snap refresh

# https://www.gnu.org/software/parallel/man.html
install-apt-package "parallel"

# https://github.com/aristocratos/btop
install-snap-package "btop"

# https://code.visualstudio.com/
if [[ $(command -v code) ]]; then
  echo "Code ist bereits installiert."
else
  echo "Installiere Code..."
  sudo snap install code --classic || error_exit "Installation von VS Code fehlgeschlagen."
fi

# Claude Code - agentische CLI von Anthropic
# https://code.claude.com/docs/en/setup
# Bewusst ueber das signierte apt-Repository statt "curl | bash": apt prueft
# jedes Paket gegen den Anthropic-Schluessel, und Updates laufen ueber die
# Update-Routine in myUpdate.sh automatisch mit.
if dpkg-query -W -f='${Status}' claude-code 2>/dev/null | grep -q "install ok installed"; then
  echo "claude-code ist bereits installiert."
else
  echo "Richte Claude-Code-Repository ein..."
  install-apt-package "gnupg"
  sudo install -d -m 0755 /etc/apt/keyrings
  sudo curl -fsSL https://downloads.claude.ai/keys/claude-code.asc \
    -o /etc/apt/keyrings/claude-code.asc \
    || error_exit "Signaturschluessel fuer Claude Code konnte nicht geladen werden."
  # Fingerabdruck gegen den veroeffentlichten Wert pruefen, bevor dem
  # Repository vertraut wird. Schlaegt das fehl, wird der Schluessel wieder
  # entfernt, damit kein halb eingerichtetes Repository zurueckbleibt.
  CLAUDE_KEY_EXPECTED="31DDDE24DDFAB679F42D7BD2BAA929FF1A7ECACE"
  CLAUDE_KEY_ACTUAL=$(gpg --show-keys --with-colons /etc/apt/keyrings/claude-code.asc 2>/dev/null | awk -F: '/^fpr:/{print $10; exit}')
  if [[ "$CLAUDE_KEY_ACTUAL" != "$CLAUDE_KEY_EXPECTED" ]]; then
    sudo rm -f /etc/apt/keyrings/claude-code.asc
    error_exit "Fingerabdruck des Claude-Code-Schluessels stimmt nicht (erwartet $CLAUDE_KEY_EXPECTED, erhalten ${CLAUDE_KEY_ACTUAL:-keiner})."
  fi
  echo "deb [signed-by=/etc/apt/keyrings/claude-code.asc] https://downloads.claude.ai/claude-code/apt/stable stable main" \
    | sudo tee /etc/apt/sources.list.d/claude-code.list > /dev/null
  sudo apt -qq -y update
  install-apt-package "claude-code"
fi

# https://jqlang.org/
# jq aus den Kali-Repos statt per snap: macht den absoluten Pfad
# /snap/bin/jq ueberfluessig und entkoppelt die Release-Pruefungen von snapd.
install-apt-package "jq"
#
# https://www.x-cmd.com/
# WARNUNG: Remote Code Execution - Code wird direkt von URL ausgeführt
echo "Installiere x-cmd (Remote-Script)..."
# Hinweis: Das x-cmd Bootstrap-Script prüft die laufende Shell über
# $ZSH_VERSION / $BASH_VERSION. Unter `set -u` ist eine solche Referenz
# fatal und beendet die Shell sofort - ein `|| echo ...` greift dabei nicht.
# Deshalb läuft der eval in einer Subshell ohne -e/-u; schlägt sie fehl,
# fängt das `||` den Exit-Code ab und die Installation läuft weiter.
(
  set +euo pipefail
  eval "$(curl -fsSL https://get.x-cmd.com)"
) || echo "x-cmd Installation fehlgeschlagen (optional)"
#
# https://github.com/Yamato-Security/hayabusa
mkdir -p ~/hayabusa
cd ~/hayabusa || error_exit "Konnte nicht nach ~/hayabusa wechseln"
HAYABUSA_LATEST=$(fetch_latest_release "Yamato-Security/hayabusa" /tmp/hayabusa-json)
HAYABUSA_CURRENT=$(find . -maxdepth 1 -name "hayabusa-*-lin-x64-musl" -type f 2>/dev/null | head -1 | sed 's/.*hayabusa-\(.*\)-lin-x64-musl/\1/')
# Der Release-Tag lautet "v4.1.0", der Asset-Dateiname aber "hayabusa-4.1.0-...".
# Ohne das Entfernen des fuehrenden "v" schlaegt der Vergleich immer fehl und
# hayabusa wird bei jedem Lauf neu heruntergeladen.
if [[ "$HAYABUSA_CURRENT" == "${HAYABUSA_LATEST#v}" ]]; then
  echo "hayabusa $HAYABUSA_LATEST ist bereits installiert."
  rm /tmp/hayabusa-json
else
  echo "Installiere hayabusa $HAYABUSA_LATEST (aktuell: ${HAYABUSA_CURRENT:-keine})..."
  # Alte Version entfernen falls vorhanden
  rm -f hayabusa-*-lin-x64-musl 2>/dev/null
  HAYABUSA_ZIP=$(jq -r '.assets[] | select(.name|test("lin-x64-musl.zip")) | .name' /tmp/hayabusa-json)
  HAYABUSA_URL=$(jq -r '.assets[] | select(.name|test("lin-x64-musl.zip")) | .browser_download_url' /tmp/hayabusa-json)
  wget -c "$HAYABUSA_URL"
  unzip -o -qq "$HAYABUSA_ZIP"
  rm "$HAYABUSA_ZIP"
  HAYABUSA_BIN=$(find . -maxdepth 1 -name "hayabusa-*-lin-x64-musl" -type f | head -1)
  HAYABUSA_BIN="${HAYABUSA_BIN#./}"
  [[ -z "$HAYABUSA_BIN" ]] && error_exit "Hayabusa Binary nicht gefunden"
  chmod a+x "$HAYABUSA_BIN"
  ./"$HAYABUSA_BIN" update-rules --quiet
  rm /tmp/hayabusa-json
fi
cd ~ || error_exit "Konnte nicht nach ~ wechseln"
#
# Velociraptor - Endpoint Detection and Response
# https://www.velocidex.com/
mkdir -p ~/velociraptor
cd ~/velociraptor || error_exit "Konnte nicht nach ~/velociraptor wechseln"
VELO_LATEST=$(fetch_latest_release "Velocidex/velociraptor" /tmp/velociraptor-json)
VELO_CURRENT=$(find . -maxdepth 1 -name "velociraptor-v*linux-amd64-musl" -type f 2>/dev/null | head -1 | sed 's/.*velociraptor-\(v[0-9.]*\).*/\1/')
if [[ "$VELO_CURRENT" == "$VELO_LATEST" ]]; then
  echo "velociraptor $VELO_LATEST ist bereits installiert."
  rm /tmp/velociraptor-json
else
  echo "Installiere velociraptor $VELO_LATEST (aktuell: ${VELO_CURRENT:-keine})..."
  rm -f velociraptor-v*linux-amd64-musl 2>/dev/null
  VELO_URL=$(jq -r '[.assets[] | select(.name|test("linux-amd64-musl$")) | .browser_download_url] | last' /tmp/velociraptor-json)
  wget -c "$VELO_URL"
  chmod a+x velociraptor-v*linux-amd64-musl
  rm /tmp/velociraptor-json
fi
cd ~ || error_exit "Konnte nicht nach ~ wechseln"
#
# https://github.com/tio/tio
install-apt-package "tio"

# https://github.com/orf/gping
install-apt-package "gping"

# https://obsidian.md/
install-apt-package "obsidian"

# https://github.com/jstaf/onedriver
install-apt-package "onedriver"
#
# Chrome installieren
if command -v google-chrome &> /dev/null; then
  echo "Google Chrome ist bereits installiert."
else
  echo "Installiere Google Chrome..."
  install-apt-package "libxss1"
  cd ~ || error_exit "Konnte nicht nach ~ wechseln"
  wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  sudo apt -qq -y install ./google-chrome-stable_current_amd64.deb || error_exit "Chrome Installation fehlgeschlagen"
  rm -f google-chrome-stable_current_amd64.deb
fi
#
# https://github.com/jedisct1/dnsblast
cd ~ || error_exit "Konnte nicht nach ~ wechseln"
if [[ ! -d ~/dnsblast ]]; then
  git clone https://github.com/jedisct1/dnsblast
  cd ~/dnsblast || error_exit "Konnte nicht nach ~/dnsblast wechseln"
  make
  cd ~ || error_exit "Konnte nicht nach ~ wechseln"
else
  echo "dnsblast ist bereits vorhanden."
fi
#
# https://github.com/Tantalor93/dnspyre
mkdir -p ~/dnspyre
cd ~/dnspyre || error_exit "Konnte nicht nach ~/dnspyre wechseln"
DNSPYRE_LATEST=$(fetch_latest_release "Tantalor93/dnspyre" /tmp/dnspyre-json)
DNSPYRE_CURRENT=""
if [[ -x ~/dnspyre/dnspyre ]]; then
  DNSPYRE_CURRENT=$(~/dnspyre/dnspyre --version 2>/dev/null | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+' | head -1)
fi
if [[ "$DNSPYRE_CURRENT" == "$DNSPYRE_LATEST" ]]; then
  echo "dnspyre $DNSPYRE_LATEST ist bereits installiert."
  rm /tmp/dnspyre-json
else
  echo "Installiere dnspyre $DNSPYRE_LATEST (aktuell: ${DNSPYRE_CURRENT:-keine})..."
  rm -f dnspyre 2>/dev/null
  DNSPYRE_URL=$(jq -r '.assets[] | select(.name=="dnspyre_linux_amd64.tar.gz") | .browser_download_url' /tmp/dnspyre-json)
  wget -c "$DNSPYRE_URL"
  tar -xzf dnspyre_linux_amd64.tar.gz
  rm dnspyre_linux_amd64.tar.gz
  # Domain-Liste nur herunterladen wenn nicht vorhanden
  [[ ! -f 10000-domains ]] && wget -q https://raw.githubusercontent.com/Tantalor93/dnspyre/master/data/10000-domains
  rm /tmp/dnspyre-json
fi
cd ~ || error_exit "Konnte nicht nach ~ wechseln"
#
# https://www.postman.com/
install-snap-package "postman"

# logseq - Outliner
# https://logseq.com/
install-snap-package "logseq"

# keepassxc - Passwort-Manager
# https://keepassxc.org/
install-snap-package "keepassxc"


# Zerotier
# https://www.zerotier.com/
# WARNUNG: Remote Code Execution - Offizielles ZeroTier Installationsskript
echo "Installiere ZeroTier (Remote-Script)..."
curl -fsSL https://install.zerotier.com | sudo bash

# mdk3 - Wireless Attack Tool
# Beispiel: mdk3 mon0 d -c 6
install-apt-package "mdk3"

# thunderbird - E-Mail-Client
# https://www.thunderbird.net/
# Hinweis: Nicht standardmäßig in Kali Linux installiert.
install-apt-package "thunderbird"

# ldnsutils - DNS-Utilities
# Benötigt für drill statt dig
install-apt-package "ldnsutils"