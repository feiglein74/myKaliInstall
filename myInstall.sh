#!/bin/bash
# Update Routine
source ./myUpdate.sh
#
# https://github.com/gnome-terminator/terminator
if [[ $(command -v terminator) ]]; then
  # Code, der ausgeführt wird, wenn die Bedingung wahr ist
  echo "terminator schon installiert"
else
  # Code, der ausgeführt wird, wenn die Bedingung falsch ist
  sudo apt -y install terminator
fi
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






