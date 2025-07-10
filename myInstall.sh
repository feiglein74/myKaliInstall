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

function dpkg-query {
  local package="$1"
  if dpkg -l | grep -q "$package"; then
    echo "$package is already installed."
  else
    echo "$package is not installed."
  fi
}

function install-apt-package {
  local package="$1"
  if dpkg -l | grep -q "$package"; then
    echo "$package is already installed."
  else
    echo "Installing $package..."
    sudo apt -qq -y install "$package" || error_exit "Failed to install $package."
  fi
}

function install-snap-package {
  local package="$1"
  if [[ $(command -v "$package") ]]; then
    echo "$package is already installed."
  else
    echo "Installing $package..."
    sudo snap install "$package" || error_exit "Failed to install $package."
  fi
}

# Check for required commands
check_command "sudo"
check_command "apt"
check_command "git"
check_command "wget"
check_command "unzip"
check_command "curl"
check_command "tar"


# Update Routine
source ./myUpdate.sh
#
# https://github.com/gnome-terminator/terminator
install-apt-package "terminator"

# https://snapcraft.io/store
install-apt-package "snapd"
sudo systemctl enable --now snapd snapd.apparmor
sudo snap refresh

# https://www.gnu.org/software/parallel/man.html
install-apt-package "parallel"

# https://github.com/aristocratos/btop
install-snap-package "btop"

# https://code.visualstudio.com/
if [[ $(command -v code) ]]; then
  echo "Code is already installed."
else
  echo "Installing Code..."
  sudo snap install code --classic || error_exit "Failed to install $package."
fi

# https://jqlang.org/
install-snap-package "jq"
#
# https://www.x-cmd.com/
eval "$(curl https://get.x-cmd.com)"
#
# https://github.com/Yamato-Security/hayabusa
mkdir ~/hayabusa
cd ~/hayabusa
curl -s https://api.github.com/repos/Yamato-Security/hayabusa/releases/latest > /tmp/hayabusa-json
cat /tmp/hayabusa-json | /snap/bin/jq '.assets[] | select (.name|test("lin-x64-musl.zip"))' | /snap/bin/jq '.browser_download_url' | xargs wget -c {}
unzip -o -qq hayabusa-3.3.0-lin-x64-musl.zip
rm hayabusa-3.3.0-lin-x64-musl.zip
chmod a+x hayabusa-3.3.0-lin-x64-musl
./hayabusa-3.3.0-lin-x64-musl update-rules --quiet
rm /tmp/hayabusa-json
cd ..
echo -e "\033[0m"
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
install-apt-package "libxss1"
cd ~
wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt -f install ./google-chrome*.deb
rm google-chrome-stable_current_amd64.deb
#
# https://github.com/jedisct1/dnsblast
cd ~
git clone https://github.com/jedisct1/dnsblast
cd ~/dnsblast
make
cd ~
#
# https://github.com/Tantalor93/dnspyre
mkdir ~/dnspyre
cd ~/dnspyre
curl -s https://api.github.com/repos/Tantalor93/dnspyre/releases/latest > /tmp/dnspyre-json
cat /tmp/dnspyre-json | /snap/bin/jq '.assets[] | select (.name=="dnspyre_linux_amd64.tar.gz")' | /snap/bin/jq '.browser_download_url' | xargs wget -c {}
tar -xzvf dnspyre_linux_amd64.tar.gz
rm dnspyre_linux_amd64.tar.gz
wget -q https://raw.githubusercontent.com/Tantalor93/dnspyre/master/data/10000-domains
rm /tmp/dnspyre-json
cd ~
#
# https://www.postman.com/
install-snap-package "postman"

install-snap-package "logseq"

install-snap-package "keepassxc"


# Zerotier
# https://www.zerotier.com/
curl -s https://install.zerotier.com | sudo bash

install-apt-package "mdk3"
