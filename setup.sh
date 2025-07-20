#!/bin/bash
sudo apt update && sudo apt upgrade
PACK=$(cat packages.list)
echo "Installing Packages"
sudo apt install $PACK
echo "Installing KVM/QEMU"
sudo apt install qemu-kvm libvirt-clients libvirt-daemon-system bridge-utils virtinst libvirt-daemon virt-manager -y
sudo systemctl status libvirtd
sudo virsh net-start default
sudo virsh net-autostart default
sudo adduser $USER libvirt
sudo adduser $USER libvirt-qemu
echo "Installing Docker"
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG podman $USER
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
cp -r mozilla ~/.mozilla
echo "Assembling Distrobox"
distrobox assemble create
