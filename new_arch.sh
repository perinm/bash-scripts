#!/bin/bash
PYTHON_MAJOR_VERSION=3.12
NVIDIA=0

sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm \
    python-pip python-virtualenv htop \
    curl whois nmap ncdu lm_sensors wget gpg gnome-shell-extensions wavemon mesa-demos \
    gnome-system-monitor apache-tools libvirt bridge-utils virt-manager qemu \
    mpv ghex imagemagick ghostscript hwinfo bluez bluez-utils

sudo systemctl enable bluetooth.service
bluetoothctl power on
sudo pacman -S --needed --noconfirm \
    bluez-hid2hci

# Note: gdebi, snap, apt-get, and add-apt-repository are skipped as they are not relevant in Arch.

# Python specific version:
# Arch typically has the latest version of Python available, but for a specific version:
# sudo pacman -S --needed --noconfirm python${PYTHON_MAJOR_VERSION}

# For system extra settings:
# allowing the GNOME workspace to work with 2 monitors instead of only one
gsettings set org.gnome.mutter workspaces-only-on-primary false

# Generate SSH key if not exists
KEY_BASE_NAME=id_ed25519
KEY_NAME=${KEY_BASE_NAME}_$(date +%Y_%m_%d_%H_%M_%S)
FILE=~/.ssh/$KEY_NAME
if [ -f $FILE ]; then
  echo "$FILE exists."
else
  ssh-keygen -o -a 100 -t ed25519 -f $FILE -C "$KEY_NAME" -q -N ""
fi
cat $FILE.pub

# Git configuration
git config --global user.email "lucasperinm@gmail.com"
git config --global user.name "Lucas Manchine"

# Application Installations
install_app_if_not_exists() {
    local COMMAND=$1
    local INSTALL_SCRIPT=$2
    if ! command -v $COMMAND &> /dev/null; then
        eval "$INSTALL_SCRIPT"
    else
        echo "$COMMAND found"
    fi
}

# Google Chrome
install_app_if_not_exists google-chrome-stable "yay -S --noconfirm google-chrome"

# NVM & NPM
install_app_if_not_exists npm "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash && source ~/.bashrc && nvm install --lts"

# OpenTofu (Project formerly Terraform)
install_app_if_not_exists tofu "
    yay -S --noconfirm opentofu-bin
    if ! command -v terraform &> /dev/null; then
        sudo ln -s /usr/bin/tofu /usr/bin/terraform
    fi
"

# AWS CLI
install_app_if_not_exists aws "yay -S --noconfirm aws-cli-v2"

# GitHub Copilot CLI
install_app_if_not_exists github-copilot-cli "
    curl -SLO https://deb.nodesource.com/nsolid_setup_deb.sh
    chmod 500 nsolid_setup_deb.sh
    ./nsolid_setup_deb.sh 21
    sudo pacman -S --needed --noconfirm nodejs npm
    sudo npm install -g @githubnext/github-copilot-cli
    echo 'eval \"$(github-copilot-cli alias -- \"$0\")\"' >> ~/.bashrc
    github-copilot-cli auth
    rm nsolid_setup_deb.sh
"

# MySQL Workbench
install_app_if_not_exists mysql-workbench "yay -S --noconfirm mysql-workbench"

# Visual Studio Code
install_app_if_not_exists code "sudo pacman -S --needed --noconfirm code"

# Docker
install_app_if_not_exists docker "
    curl https://get.docker.com | sh
    sudo usermod -aG docker $USER
"

# Spotify
install_app_if_not_exists spotify "yay -S --noconfirm spotify"

# OBS Studio
install_app_if_not_exists obs-studio "
    sudo pacman -S --needed --noconfirm obs-studio
"

# Discord
install_app_if_not_exists discord "yay -S --noconfirm discord"

# Gsnap Gnome Shell Extension
install_app_if_not_exists gsnap "
    wget -O ~/gsnap.zip https://extensions.gnome.org/extension-data/gSnapmicahosborne.v19.shell-extension.zip
    mkdir -p ~/.local/share/gnome-shell/extensions/gSnap@micahosborne
    unzip ~/gsnap.zip -d ~/.local/share/gnome-shell/extensions/gSnap@micahosborne
    gnome-extensions enable gSnap@micahosborne
    rm ~/gsnap.zip
"

# Telegram Desktop
install_app_if_not_exists telegram-desktop "sudo pacman -S --needed --noconfirm telegram-desktop"

# Ksnip
install_app_if_not_exists ksnip "yay -S --noconfirm ksnip"

# Slack
install_app_if_not_exists slack-desktop "yay -S --noconfirm slack-desktop"

# SMPlayer
install_app_if_not_exists smplayer "sudo pacman -S --needed --noconfirm smplayer"

# Pinta
install_app_if_not_exists pinta "sudo pacman -S --needed --noconfirm pinta"

# Skype
install_app_if_not_exists skypeforlinux-stable-bin "yay -S --noconfirm skypeforlinux-stable-bin"

# Postman
install_app_if_not_exists postman-bin "
    yay -S --noconfirm postman-bin
    cat > ~/.local/share/applications/postman.desktop <<EOL
[Desktop Entry]
Encoding=UTF-8
Name=Postman
Exec=/usr/bin/postman
Icon=postman
Terminal=false
Type=Application
Categories=Development;
EOL
"

# Obsidian
install_app_if_not_exists obsidian-snap "yay -S --noconfirm obsidian"

# KeePassXC
install_app_if_not_exists keepassxc "sudo pacman -S --needed --noconfirm keepassxc"

# Alacritty
install_app_if_not_exists alacritty "
    sudo pacman -S --needed --noconfirm alacritty
    cargo build --release --no-default-features --features=wayland
    sudo tic -xe alacritty,alacritty-direct extra/alacritty.info
    sudo cp target/release/alacritty /usr/local/bin
    sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
    sudo desktop-file-install extra/linux/Alacritty.desktop
    sudo update-desktop-database
    sudo mkdir -p /usr/local/share/man/man1
    sudo mkdir -p /usr/local/share/man/man5
    mkdir -p ~/.bash_completion
    cp extra/completions/alacritty.bash ~/.bash_completion/alacritty
    echo "source ~/.bash_completion/alacritty" >> ~/.bashrc
    sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator $(which alacritty) 50
    python3-nautilus
    pip install --user nautilus-open-any-terminal
    glib-compile-schemas ~/.local/share/glib-2.0/schemas/
    gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal alacritty
"

# Scrcpy
install_app_if_not_exists scrcpy "
    sudo pacman -S --needed --noconfirm scrcpy
"

# Check if a service exists
service_exists() {
    local n=$1
    if [[ $(systemctl list-units --all -t service --full --no-legend "$n.service" | sed 's/^\s*//g' | cut -f1 -d' ') == $n.service ]]; then
        return 0
    else
        return 1
    fi
}