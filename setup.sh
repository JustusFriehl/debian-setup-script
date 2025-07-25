#!/bin/bash
sudo apt update && sudo apt upgrade -y
PACK=$(cat packages.list)
echo "Installing Packages"
sudo apt install $PACK -y
echo "Installing KVM/QEMU"
sudo apt install qemu-kvm libvirt-clients libvirt-daemon-system bridge-utils virtinst libvirt-daemon virt-manager -y
sudo systemctl status libvirtd
sudo virsh net-start default
sudo virsh net-autostart default
sudo adduser $USER libvirt
sudo adduser $USER libvirt-qemu
echo "Installing Docker"
sudo apt-get update
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
echo "Installing X11Docker"
curl -fsSL https://raw.githubusercontent.com/mviereck/x11docker/master/x11docker | sudo bash -s -- --update
echo "Configuring Wayfire"
cp wayfire.ini ~/.config/wayfire.ini
echo "Configuring Bash" 
cp bashrc ~/.bashrc
echo "Configuring Neovim"
if [ -e ~/.config/nvim ]
then
	cp init.lua ~/.config/nvim/init.lua
else
	mkdir -p ~/.config/nvim
	cp init.lua ~/.config/nvim/init.lua
fi
echo "Confiuring Firefox"
rm -rf ~/.mozilla/
cp -r mozilla ~/.mozilla
echo "Installing Nix"
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --no-daemon
echo "Installing Flatpak"
sudo apt install flatpak -y
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
echo "Setting up Github-Cli"
(type -p wget >/dev/null || (sudo apt update && sudo apt install wget -y)) \
	&& sudo mkdir -p -m 755 /etc/apt/keyrings \
	&& out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
	&& cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
	&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& sudo mkdir -p -m 755 /etc/apt/sources.list.d \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	&& sudo apt update \
	&& sudo apt install gh -y
echo "Configuring XFCE4"
sudo rm -rf ~/.config/xfce4/
cp -r xfce4 ~/.config/xfce4
echo "Removing unneeded Packages"
sudo apt autoremove -y
echo "Installing Ollama"
curl -fsSL https://ollama.com/install.sh | sh

echo "Finished"
