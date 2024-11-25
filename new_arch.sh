#!/bin/bash
LAPTOP_BRAND="Dell"
PYTHON_MAJOR_VERSION=3.13
PYTHON_AUR_VERSION=313
NVIDIA=0

sudo pacman -Syu --noconfirm
sudo pacman -Syu --needed --noconfirm linux-firmware
# apache-tools gpg qemu
sudo pacman -Syu --needed --noconfirm \
    python-pip python-virtualenv htop \
    curl whois nmap ncdu lm_sensors wget gnome-shell-extensions wavemon mesa-demos \
    gnome-system-monitor libvirt bridge-utils virt-manager jq firefox clutter zip bind \
    mpv ghex imagemagick ghostscript hwinfo bluez bluez-utils gnome-browser-connector \
    nano discord solaar less os-prober openvpn networkmanager-openvpn spotify-launcher \
    pipewire-alsa pavucontrol sof-firmware sof-tools tlp pwgen tenacity vi dkms \
    linux-headers v4l2loopback-dkms python-opencv android-tools java-runtime-common \
    jre-openjdk docker-buildx python-pipx plocate qemu-full libreoffice-fresh texlive \
    bash-completion \
    gnome-shell-extension-appindicator

sudo localectl set-locale LANG=en_US.UTF-8

# Don' t forget to enable extensions in GNOME Tweaks

sudo groupadd -f plugdev
sudo usermod -aG plugdev $USER
sudo usermod -aG audio $USER
sudo udevadm control --reload-rules

sudo systemctl enable tlp.service
sudo systemctl start tlp.service
sudo systemctl enable bluetooth.service
sudo systemctl start bluetooth.service
bluetoothctl power on
sudo pacman -S --needed --noconfirm \
    bluez-hid2hci

# Note: gdebi, snap, apt-get, and add-apt-repository are skipped as they are not relevant in Arch.

# For system extra settings:
# allowing the GNOME workspace to work with 2 monitors instead of only one
gsettings set org.gnome.mutter workspaces-only-on-primary false
gsettings set org.gnome.desktop.interface cursor-size 48
gsettings set org.gnome.shell disable-extension-version-validation true

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

eval "$(ssh-agent -s)"
ssh-add $FILE

# Git configuration
git config --global init.defaultBranch main
git config --global pull.rebase false
# git config --global push.default current
git config --global --add --bool push.autoSetupRemote true
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

# Install Yay (Yet Another Yaourt)
install_app_if_not_exists yay "
    sudo pacman -S --needed --noconfirm base-devel git
    git clone https://aur.archlinux.org/yay.git
    cd yay/
    makepkg -si --noconfirm
    yay --version
    cd ~/
"

install_app_if_not_exists rustup "
    sudo pacman -S --needed --noconfirm rustup
    rustup toolchain install stable
    rustup update
"

# Check if the CPU is Intel
if grep -qi "GenuineIntel" /proc/cpuinfo; then
    echo "Intel CPU detected. Running package installation script."
    sudo pacman -Syu --needed --noconfirm intel-ucode libva-utils intel-media-driver \
        thermald vulkan-intel intel-gpu-tools
    sudo systemctl enable thermald.service
    sudo systemctl start thermald.service
    yay -S --noconfirm tuned tuned-ppd
    sudo systemctl enable tuned.service tuned-ppd.service
    sudo systemctl start tuned.service tuned-ppd.service
else
    echo "The CPU is not an Intel CPU. Skipping Intel CPU specific packages."
fi

# Check if the CPU is AMD
if grep -qi "AuthenticAMD" /proc/cpuinfo; then
    echo "AMD CPU detected. Running package installation script."
    sudo pacman -Syu --needed --noconfirm amd-ucode
else
    echo "The CPU is not an AMD CPU. Skipping AMD CPU specific packages."
fi

# Check if the laptop brand is Dell
if [ "$LAPTOP_BRAND" == "Dell" ]; then
    echo "Dell laptop detected. Running package installation script."
    sudo pacman -Syu --needed --noconfirm acpi tcl tk
    # sudo pacman -Syu --needed --noconfirm dell-smm-hwmon
    yay -S --noconfirm i8kutils
else
    echo "The laptop brand is not Dell. Skipping Dell laptop specific packages."
fi

# NVM & NPM
install_app_if_not_exists npm "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash && source ~/.bashrc && nvm install --lts"

if ! grep -qF '# Increase Bash history size' ~/.bashrc; then
  cat << 'EOF' >> ~/.bashrc

# Increase Bash history size
HISTSIZE=100000
HISTFILESIZE=200000

# Avoid duplicate entries in the history
HISTCONTROL=ignoredups:erasedups

# Append to the history file, rather than overwriting it
shopt -s histappend

# Add timestamps to history entries
export HISTTIMEFORMAT="%F %T "

source /usr/share/git/completion/git-completion.bash
EOF
fi

yay -S --noconfirm keybase-bin koodo-reader-bin 7-zip-full \
    aws-cli-v2 aws-session-manager-plugin normcap cursor-bin \
    gnome-shell-extension-another-window-session-manager-git \
    gnome-shell-extension-dash-to-dock \
    gnome-shell-extension-gsnap
# yay -S --noconfirm android-studio android-sdk-cmdline-tools-latest android-sdk-build-tools android-sdk-platform-tools android-platform flutter
# dart --disable-analytics
# flutter --disable-analytics
# yay -Rns android-studio android-sdk-cmdline-tools-latest android-sdk-build-tools android-sdk-platform-tools android-platform flutter

install_app_if_not_exists python${PYTHON_MAJOR_VERSION} "yay -S --noconfirm python${PYTHON_AUR_VERSION}"

# Python specific version:
# Arch typically has the latest version of Python available, but for a specific version:
# sudo pacman -S --needed --noconfirm python${PYTHON_MAJOR_VERSION}

python -m venv ~/venv${PYTHON_MAJOR_VERSION}
source ~/venv${PYTHON_MAJOR_VERSION}/bin/activate
pip install -U pip setuptools wheel setuptools-rust ruff
deactivate

pipx ensurepath
sudo pipx ensurepath --global # optional to allow pipx actions with --global argument
sudo updatedb

# Flutter
install_app_if_not_exists flutter "
    yay -S --noconfirm flutter

    sudo groupadd flutterusers
    sudo gpasswd -a $USER flutterusers
    sudo chown -R :flutterusers /opt/flutter
    sudo chmod -R g+w /opt/flutter/

    yay -S --noconfirm android-sdk android-sdk-platform-tools android-sdk-build-tools android-sdk-cmdline-tools-latest
    yay -S --noconfirm android-platform

    sudo groupadd android-sdk
    sudo gpasswd -a $USER android-sdk
    sudo setfacl -R -m g:android-sdk:rwx /opt/android-sdk
    sudo setfacl -d -m g:android-sdk:rwX /opt/android-sdk

    export JAVA_HOME='/usr/lib/jvm/java-22-openjdk'
    sudo archlinux-java set java-22-openjdk

    sdkmanager --install "system-images;android-33;default;x86_64"

    yay -S --noconfirm android-studio
"

# Google Chrome
install_app_if_not_exists google-chrome-stable "
    yay -S --noconfirm google-chrome
    sudo ln -s /usr/bin/google-chrome-stable /usr/bin/google-chrome
    echo '--enable-blink-features=MiddleClickAutoscroll' >> ~/.config/chrome-flags.conf
    echo '--enable-features=UseOzonePlatform' >> ~/.config/chrome-flags.conf
    echo '--ozone-platform=wayland' >> ~/.config/chrome-flags.conf
    echo '--ozone-platform-hint=auto' >> ~/.config/chrome-flags.conf
"

# OpenTofu (Project formerly Terraform)
install_app_if_not_exists tofu "
    yay -S --noconfirm opentofu-bin
    if ! command -v terraform &> /dev/null; then
        sudo ln -s /usr/bin/tofu /usr/bin/terraform
    fi
    echo '
    tf() {
        if [ -f .env ]; then
            source .env
        fi
        tofu \\"\\$@\\"
    }
    alias tf=tf
    ' >> ~/.bashrc
"

install_app_if_not_exists copyq "
    sudo pacman -S --needed --noconfirm copyq
    # Exec=env QT_QPA_PLATFORM=xcb copyq
    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/']"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name 'CopyQ'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command 'copyq show'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding '<Super>v'
    gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings
" 

# GitHub Copilot CLI
install_app_if_not_exists github-copilot-cli "
    curl -SLO https://deb.nodesource.com/nsolid_setup_deb.sh
    chmod 500 nsolid_setup_deb.sh
    ./nsolid_setup_deb.sh 21
    npm install -g @githubnext/github-copilot-cli
    echo 'eval \"$(github-copilot-cli alias -- \"$0\")\"' >> ~/.bashrc
    github-copilot-cli auth
    rm nsolid_setup_deb.sh
"

# MySQL Workbench
install_app_if_not_exists mysql-workbench "yay -S --noconfirm mysql-workbench"

# Visual Studio Code
install_app_if_not_exists code "yay -S --noconfirm visual-studio-code-bin"

# Visual Studio Code Insiders
install_app_if_not_exists code-insiders "yay -S --noconfirm visual-studio-code-insiders-bin"

# Docker
install_app_if_not_exists docker "
    sudo pacman -S --needed --noconfirm docker docker-compose
    sudo systemctl enable docker.service
    sudo systemctl start docker.service
    sudo usermod -aG docker $USER
"

# sudo reboot && nordvpn set technology nordlynx
# NordVPN
install_app_if_not_exists nordvpn "
    yay -S --noconfirm nordvpn-bin
    sudo gpasswd -a $USER nordvpn
    sudo usermod -aG nordvpn $USER
    sudo systemctl enable --now nordvpnd
    nordvpn set lan-discovery enable
    sudo pacman -S --needed --noconfirm wireguard-tools
"

# Spotify
install_app_if_not_exists spotify "yay -S --noconfirm spotify"

# OBS Studio
install_app_if_not_exists obs-studio "
    sudo pacman -S --needed --noconfirm obs-studio
    yay -S --noconfirm obs-backgroundremoval
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

# Zoom
install_app_if_not_exists zoom "yay -S --noconfirm zoom"

# DataGrip
install_app_if_not_exists datagrip "yay -S --noconfirm datagrip datagrip-jre"

# SMPlayer
install_app_if_not_exists smplayer "sudo pacman -S --needed --noconfirm smplayer"

# Pinta
install_app_if_not_exists pinta "sudo pacman -S --needed --noconfirm pinta"

# Skype
install_app_if_not_exists skypeforlinux-bin "yay -S --noconfirm skypeforlinux-bin"

# Resources
install_app_if_not_exists resources "yay -S --noconfirm resources"

# Postman
install_app_if_not_exists postman-bin "yay -S --noconfirm postman-bin"

# Obsidian
install_app_if_not_exists obsidian "sudo pacman -S --needed --noconfirm obsidian"

# KeePassXC
install_app_if_not_exists keepassxc "sudo pacman -S --needed --noconfirm keepassxc"

# Alacritty
install_app_if_not_exists alacritty "
    sudo pacman -S --needed --noconfirm alacritty
    yay -S --noconfirm nautilus-open-any-terminal
    gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal alacritty
    # gsettings set com.github.stunkymonkey.nautilus-open-any-terminal keybindings '<Ctrl><Alt>t'
    # gsettings set com.github.stunkymonkey.nautilus-open-any-terminal new-tab true
    # gsettings set com.github.stunkymonkey.nautilus-open-any-terminal flatpak system
    gsettings set org.gnome.desktop.default-applications.terminal exec 'alacritty'
    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/']"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'Open Alacritty Terminal'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command 'alacritty'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '<Control><Alt>T'
    gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings
    mkdir -p ~/.config/alacritty/themes
    git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes
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

sudo pacman -Syu --noconfirm && yay -Syu --noconfirm && yay -Yc --noconfirm