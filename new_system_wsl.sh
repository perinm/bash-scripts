#!/bin/bash
sudo apt update -y && sudo apt full-upgrade -y && sudo apt autoremove -y && sudo apt clean -y && sudo apt autoclean -y

sudo apt install -y gdebi python-is-python3 python3-pip python3-venv htop libcanberra-gtk-module p7zip-full lm-sensors wireshark \
    ncdu ppa-purge wireguard wireguard-tools net-tools nmap gparted btrfs-progs copyq gnome-shell-extensions d-feet btrfs-compsize \
    copyq gimp tilix minidlna whois \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release


COMMAND=docker
if ! command -v $COMMAND &> /dev/null; then
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    sudo service docker start
else
    echo "$COMMAND found"
fi