#!/bin/bash
PYTHON_MAJOR_VERSION=3.12
NVIDIA=0

sudo apt-get update -y && sudo apt-get full-upgrade -y && sudo apt-get autoremove -y && sudo apt-get clean -y && sudo apt-get autoclean -y \
    && sudo snap refresh

sudo apt-get install -y gdebi python3-pip python3-venv htop tilix apt-transport-https \
                        curl whois nmap ncdu lm-sensors wget gpg gnome-shell-extensions wavemon mesa-utils \
                        gir1.2-gtop-2.0 gir1.2-nm-1.0 gir1.2-clutter-1.0 gnome-system-monitor apache2-utils \
                        libvirt-daemon-system bridge-utils cpu-checker libvirt-clients libvirt-daemon qemu-kvm \
                        mpv ghex imagemagick ghostscript hwinfo

sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt-get update -y && sudo apt-get full-upgrade -y && sudo apt-get autoremove -y && sudo apt-get clean -y && sudo apt-get autoclean -y \
    && sudo snap refresh
# sudo apt-get install -y python$PYTHON_MAJOR_VERSION python$PYTHON_MAJOR_VERSION-venv python$PYTHON_MAJOR_VERSION-dev
# python$PYTHON_MAJOR_VERSION -m pip install -U pip setuptools wheel setuptools-rust

## system extra settings
# allows gnome workspace to work with 2 monitors instead of only one
# gsettings set org.gnome.mutter workspaces-only-on-primary false
KEY_BASE_NAME=id_ed25519
KEY_NAME=${KEY_BASE_NAME}_$(date +%Y_%m_%d_%H_%M_%S)
FILE=~/.ssh/$KEY_NAME
if [ -f $FILE ]; then
  echo "$FILE exists."
else
  ssh-keygen -o -a 100 -t ed25519 -f $FILE -C "$KEY_NAME" -q -N ""
fi
cat $FILE.pub
## /#

git config --global user.email "lucasperinm@gmail.com"
git config --global user.name "Lucas Manchine"

## Install many apps, each app install consists of

# COMMAND
# IF command doesn't exist run code block of installation
# ELSE tell command exists 
# FI

COMMAND=google-chrome
if ! command -v $COMMAND &> /dev/null; then
    wget -O ~/${COMMAND}.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo gdebi -n ~/${COMMAND}.deb
    rm ~/${COMMAND}.deb
else
    echo "$COMMAND found"
fi
COMMAND=npm
if ! command -v $COMMAND &> /dev/null; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    source ~/.bashrc
    nvm install --lts
else
    echo "$COMMAND found"
fi
COMMAND=tofu
if ! command -v $COMMAND &> /dev/null; then
    curl -s https://packagecloud.io/install/repositories/opentofu/tofu/script.deb.sh?any=true -o /tmp/tofu-repository-setup.sh
    sudo bash /tmp/tofu-repository-setup.sh
    rm /tmp/tofu-repository-setup.sh
    sudo apt-get install -y tofu
    if ! command -v $COMMAND &> /dev/null; then
        SUBCOMMAND=terraform
        if ! command -v $SUBCOMMAND &> /dev/null; then
            sudo ln -s /usr/bin/tofu /usr/bin/terraform
        else
            echo "$SUBCOMMAND found, not creating symlink for $COMMAND"
        fi
    else
        echo "$COMMAND failed to install"
else
    echo "$COMMAND found"
fi
COMMAND=aws
if ! command -v $COMMAND &> /dev/null; then
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip
    unzip awscliv2.zip
    sudo ./aws/install
else
    echo "$COMMAND found"
fi
COMMAND=??
if ! command -v $COMMAND &> /dev/null; then
    curl -SLO https://deb.nodesource.com/nsolid_setup_deb.sh
    chmod 500 nsolid_setup_deb.sh
    ./nsolid_setup_deb.sh 21
    apt-get install nodejs -y
    sudo npm install -g npm@latest
    sudo npm install -g @githubnext/github-copilot-cli
    echo 'eval "$(github-copilot-cli alias -- "$0")"' >> ~/.bashrc
    github-copilot-cli auth
    rm nsolid_setup_deb.sh
else
    echo "$COMMAND found"
fi
COMMAND=mysql-workbench-community
if ! command -v $COMMAND &> /dev/null; then
    wget -O ~/${COMMAND}.deb https://dev.mysql.com/get/mysql-apt-config_0.8.30-1_all.deb
    sudo gdebi -n ~/${COMMAND}.deb
    rm ~/${COMMAND}.deb
    sudo apt-get update
    # sudo apt-get install -y mysql-workbench-community
    wget -O ~/${COMMAND}.deb https://dev.mysql.com/get/Downloads/MySQLGUITools/mysql-workbench-community_8.0.36-1ubuntu23.10_amd64.deb
    sudo gdebi -n ~/${COMMAND}.deb
    rm ~/${COMMAND}.deb
    sudo apt-get update
    # sudo snap install $COMMAND
else
    echo "$COMMAND found"
fi
COMMAND=code
if ! command -v $COMMAND &> /dev/null; then
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    rm -f packages.microsoft.gpg
    sudo apt-get update
    sudo apt-get install -y code
else
    echo "$COMMAND found"
fi
COMMAND=docker
if ! command -v $COMMAND &> /dev/null; then
  curl https://get.docker.com | sh
  sudo usermod -aG docker $USER
else
  echo "$COMMAND found"
fi
COMMAND=spotify
if ! command -v $COMMAND &> /dev/null; then
    sudo snap install spotify
else
    echo "$COMMAND found"
fi
COMMAND=obs
if ! command -v $COMMAND &> /dev/null; then
    sudo apt-get install -y ffmpeg
    sudo add-apt-repository ppa:obsproject/obs-studio -y
    sudo apt-get update
    sudo apt-get install -y obs-studio
else
    echo "$COMMAND found"
fi
COMMAND=discord
if ! command -v $COMMAND &> /dev/null; then
    wget -O ~/${COMMAND}.deb "https://discordapp.com/api/download?platform=linux&format=deb"
    sudo gdebi -n ~/${COMMAND}.deb
    rm ~/${COMMAND}.deb
else
    echo "$COMMAND found"
fi
COMMAND=gsnap
if ! command -v $COMMAND &> /dev/null; then
    wget -O ~/${COMMAND}.zip https://extensions.gnome.org/extension-data/gSnapmicahosborne.v19.shell-extension.zip
    # .local/share/gnome-shell/extensions
    mkdir -p ~/.local/share/gnome-shell/extensions/gSnap@micahosborne
    unzip ~/${COMMAND}.zip -d ~/.local/share/gnome-shell/extensions/gSnap@micahosborne
    gnome-extensions enable gSnap@micahosborne
else
    echo "$COMMAND found"
fi
COMMAND=telegram-desktop
if ! command -v $COMMAND &> /dev/null; then
    # wget -O- https://telegram.org/dl/desktop/linux | sudo tar xJ -C /opt/
    # sudo ln -s /opt/Telegram/Telegram /usr/local/bin/telegram-desktop
    sudo snap install telegram-desktop
else
    echo "$COMMAND found"
fi
COMMAND=ksnip
if ! command -v $COMMAND &> /dev/null; then
    sudo snap install ksnip
else
    echo "$COMMAND found"
fi
COMMAND=slack
if ! command -v $COMMAND &> /dev/null; then
    wget -O ~/${COMMAND}.deb "https://downloads.slack-edge.com/releases/linux/4.35.131/prod/x64/slack-desktop-4.35.131-amd64.deb"
    sudo gdebi -n ~/${COMMAND}.deb
    rm ~/${COMMAND}.deb
    # sudo snap install slack
else
    echo "$COMMAND found"
fi
COMMAND=smplayer
if ! command -v $COMMAND &> /dev/null; then
    sudo snap install $COMMAND
else
    echo "$COMMAND found"
fi
COMMAND=pinta
if ! command -v $COMMAND &> /dev/null; then
    sudo snap install $COMMAND
else
    echo "$COMMAND found"
fi
COMMAND=skype
if ! command -v $COMMAND &> /dev/null; then
    # sudo snap install $COMMAND
    wget -O ~/${COMMAND}.deb https://go.skype.com/skypeforlinux-64.deb
    sudo gdebi -n ~/${COMMAND}.deb
    rm ~/${COMMAND}.deb
else
    echo "$COMMAND found"
fi
COMMAND=postman
if ! command -v $COMMAND &> /dev/null; then
    # sudo snap install $COMMAND
    wget -O ~/${COMMAND}.tar.gz https://dl.pstmn.io/download/latest/linux64 
    sudo tar -xzf ~/${COMMAND}.tar.gz -C /opt
    sudo ln -s /opt/Postman/Postman /usr/bin/postman
    cat > ~/.local/share/applications/postman.desktop <<EOL
[Desktop Entry]
Encoding=UTF-8
Name=Postman
Exec=postman
Icon=/opt/Postman/app/resources/app/assets/icon.png
Terminal=false
Type=Application
Categories=Development;
EOL
    rm ~/${COMMAND}.tar.gz
else
    echo "$COMMAND found"
fi
COMMAND=obsidian
if ! command -v $COMMAND &> /dev/null; then
    if ! command -v deb-get &> /dev/null; then
        echo "$COMMAND failed to install because deb-get is not installed or missing DEBGET_TOKEN env variable."
    else
        # wget -O ~/${COMMAND}.deb https://github.com/obsidianmd/obsidian-releases/releases/download/v1.4.16/obsidian_1.4.16_amd64.deb
        # sudo gdebi -n ~/${COMMAND}.deb
        # rm ~/${COMMAND}.deb 
        snap install obsidian --classic
    fi
else
    echo "$COMMAND found"
fi
COMMAND=keepassxc
if ! command -v $COMMAND &> /dev/null; then
    sudo add-apt-repository ppa:phoerious/keepassxc -y
    sudo apt-get update
    sudo apt-get install -y keepassxc
else
    echo "$COMMAND found"
fi
COMMAND=alacritty
if ! command -v $COMMAND &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    sudo apt-get install -y cmake libfreetype6-dev libfontconfig1-dev xclip libxcb-xfixes0-dev libxkbcommon-dev gzip scdoc
    git clone https://github.com/jwilm/alacritty
    cd alacritty
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
    sudo apt-get install -y python3-nautilus
    pip install --user nautilus-open-any-terminal
    glib-compile-schemas ~/.local/share/glib-2.0/schemas/
    gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal alacritty
else
    echo "$COMMAND found"
fi
COMMAND=scrcpy
if ! command -v $COMMAND &> /dev/null; then
    sudo apt install ffmpeg libsdl2-2.0-0 adb wget \
        gcc git pkg-config meson ninja-build libsdl2-dev \
        libavcodec-dev libavdevice-dev libavformat-dev libavutil-dev \
        libswresample-dev libusb-1.0-0 libusb-1.0-0-dev
    git clone https://github.com/Genymobile/scrcpy
    cd scrcpy
    ./install_release.sh
    # to uninstall
    # sudo ninja -Cbuild-auto uninstall
else
    echo "$COMMAND found"
fi
service_exists() {
    local n=$1
    if [[ $(systemctl list-units --all -t service --full --no-legend "$n.service" | sed 's/^\s*//g' | cut -f1 -d' ') == $n.service ]]; then
        return 0
    else
        return 1
    fi
}