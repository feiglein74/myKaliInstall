#!/bin/bash

function error_exit {
  echo "Error: $1"
  exit 1
}

function check_command {
  if ! command -v "$1" &> /dev/null; then
    error_exit "Command '$1' not found. Please install it first."
  fi
}

function check_file {
  if [ ! -f "$1" ]; then
    error_exit "File '$1' not found. Please ensure it exists."
  fi
}

function check_directory {
  if [ ! -d "$1" ]; then
    error_exit "Directory '$1' not found. Please ensure it exists."
  fi
} 

function check_url {
  if ! curl --output /dev/null --silent --head --fail "$1"; then
    error_exit "URL '$1' is not reachable. Please check your internet connection."
  fi
} 

function check_package {
  if ! dpkg -l | grep -q "$1"; then
    error_exit "Package '$1' is not installed. Please install it first."
  fi
}

function check_snap {
  if ! snap list | grep -q "$1"; then
    error_exit "Snap package '$1' is not installed. Please install it first."
  fi
} 

function check_git {
  if ! git --version &> /dev/null; then
    error_exit "Git is not installed. Please install it first."
  fi
}

function check_wget {
  if ! wget --version &> /dev/null; then
    error_exit "Wget is not installed. Please install it first."
  fi
}

function check_unzip {
  if ! unzip -v &> /dev/null; then
    error_exit "Unzip is not installed. Please install it first."
  fi
}

function check_curl {
  if ! curl --version &> /dev/null; then
    error_exit "Curl is not installed. Please install it first."
  fi
}

function check_sudo {
  if ! sudo -v &> /dev/null; then
    error_exit "Sudo is not configured. Please configure it first."
  fi
}

function check_apt {
  if ! command -v apt &> /dev/null; then
    error_exit "APT package manager is not available. Please ensure you are using a Debian-based system."
  fi
}

function install-apt-package {
  local package="$1"
  if [[ $(command -v "$package") ]]; then
    echo "$package is already installed."
  else
    echo "Installing $package..."
    sudo apt -y install "$package" || error_exit "Failed to install $package."
  fi
}

# Check for required commands
check_command "sudo"
check_command "apt"
check_command "git"
check_command "wget"
check_command "unzip"
check_command "curl"


# Update Routine
source ./myUpdate.sh
#
# https://github.com/gnome-terminator/terminator
install-apt-package "terminator"
#if [[ $(command -v terminator) ]]; then
  # Code, der ausgeführt wird, wenn die Bedingung wahr ist
#  echo "terminator schon installiert"
#else
  # Code, der ausgeführt wird, wenn die Bedingung falsch ist
#  sudo apt -y install terminator
#fi
# https://snapcraft.io/store
if [[ $(command -v snap) ]]; then
  # Code, der ausgeführt wird, wenn die Bedingung wahr ist
  echo "snap schon installiert"
else
  # Code, der ausgeführt wird, wenn die Bedingung falsch ist
  sudo apt -y install snapd
fi
sudo systemctl enable --now snapd snapd.apparmor
sudo snap refresh

# https://www.gnu.org/software/parallel/man.html
if [[ $(command -v parallel) ]]; then
  # Code, der ausgeführt wird, wenn die Bedingung wahr ist
  echo "parallel schon installiert"
else
  # Code, der ausgeführt wird, wenn die Bedingung falsch ist
  sudo apt -y install parallel
fi
# https://github.com/aristocratos/btop
if [[ $(command -v btop) ]]; then
  # Code, der ausgeführt wird, wenn die Bedingung wahr ist
  echo "btop schon installiert"
else
  # Code, der ausgeführt wird, wenn die Bedingung falsch ist
  sudo snap install btop
fi
# https://code.visualstudio.com/
if [[ $(command -v code) ]]; then
  # Code, der ausgeführt wird, wenn die Bedingung wahr ist
  echo "Visual Studio Code schon installiert"
else
  # Code, der ausgeführt wird, wenn die Bedingung falsch ist
  sudo snap install --classic code
fi
# https://jqlang.org/
if [[ $(command -v jq) ]]; then
  # Code, der ausgeführt wird, wenn die Bedingung wahr ist
  echo "jql schon installiert"
else
  # Code, der ausgeführt wird, wenn die Bedingung falsch ist
  sudo snap install jq
fi
#
# https://www.x-cmd.com/
eval "$(curl https://get.x-cmd.com)"
#
# https://github.com/Yamato-Security/hayabusa
mkdir ~/hayabusa
cd ~/hayabusa
curl https://api.github.com/repos/Yamato-Security/hayabusa/releases/latest > /tmp/lf-json
cat /tmp/lf-json | /snap/bin/jq '.assets[] | select (.name|test(".lin-x64-musl.zip"))' | /snap/bin/jq '.browser_download_url' | xargs wget -c {}
unzip hayabusa-3.3.0-lin-x64-musl.zip
rm hayabusa-3.3.0-lin-x64-musl.zip
chmod a+x hayabusa-3.3.0-lin-x64-musl
./hayabusa-3.3.0-lin-x64-musl update-rules
rm /tmp/lf-json
cd ..
#
# https://github.com/tio/tio
if [[ $(command -v tio) ]]; then
  # Code, der ausgeführt wird, wenn die Bedingung wahr ist
  echo "tio schon installiert"
else
  # Code, der ausgeführt wird, wenn die Bedingung falsch ist
  sudo apt -y install tio
fi
# https://github.com/orf/gping
if [[ $(command -v gping) ]]; then
  # Code, der ausgeführt wird, wenn die Bedingung wahr ist
  echo "gping schon installiert"
else
  # Code, der ausgeführt wird, wenn die Bedingung falsch ist
  sudo apt -y install gping 
fi
# https://obsidian.md/
if [[ $(command -v obsidian) ]]; then
  # Code, der ausgeführt wird, wenn die Bedingung wahr ist
  echo "Obsidian schon installiert"
else
  # Code, der ausgeführt wird, wenn die Bedingung falsch ist
  sudo apt -y install obsidian 
fi

# https://github.com/jstaf/onedriver
if [[ $(command -v onedriver) ]]; then
  # Code, der ausgeführt wird, wenn die Bedingung wahr ist
  echo "onedriver schon installiert"
else
  # Code, der ausgeführt wird, wenn die Bedingung falsch ist
  sudo apt -y install onedriver
fi
#
# Chrome installieren
sudo apt -y install libxss1
cd ~
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt -f install ./google-chrome*.deb
rm google-chrome-stable_current_amd64.deb
#
# https://github.com/jedisct1/dnsblast
cd ~
git clone https://github.com/jedisct1/dnsblast
cd dnsblast
make
cd ~
#
# https://github.com/Tantalor93/dnspyre

mkdir ~/dnspyre
cd ~/dnspyre
curl https://api.github.com/repos/Tantalor93/dnspyre/releases/latest > /tmp/lf-json
cat /tmp/lf-json | /snap/bin/jq '.assets[] | select (.name=="dnspyre_linux_amd64.tar.gz")' | /snap/bin/jq '.browser_download_url' | xargs wget -c {}
tar -xzvf dnspyre_linux_amd64.tar.gz
rm dnspyre_linux_amd64.tar.gz
wget  https://raw.githubusercontent.com/Tantalor93/dnspyre/master/data/10000-domains
cd ~
#
# https://www.postman.com/
if [[ $(command -v postman) ]]; then
  # Code, der ausgeführt wird, wenn die Bedingung wahr ist
  echo "Postman schon installiert"
else
  # Code, der ausgeführt wird, wenn die Bedingung falsch ist
  sudo snap install postman
fi






