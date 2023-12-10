#!/bin/bash
sudo apt-get update -y && sudo apt-get full-upgrade -y && sudo apt-get autoremove -y && sudo apt-get clean -y && sudo apt-get autoclean -y

# TO-DO:
# - Prusa
# - Fritzing

# lines below sudo apt-get install, install docker requirements
# steam
sudo apt-get install -y gdebi python-is-python3 python3-pip python3-venv htop tilix apt-transport-https \
                        curl whois nmap ncdu lm-sensors wget gpg gnome-shell-extensions wavemon mesa-utils \
                        gir1.2-gtop-2.0 gir1.2-nm-1.0 gir1.2-clutter-1.0 gnome-system-monitor apache2-utils

# sudo apt-get install -y libcanberra-gtk-module p7zip-full wireshark \
#     ppa-purge wireguard wireguard-tools net-tools gparted btrfs-progs d-feet btrfs-compsize \
#     copyq gimp minidlna \
#     ca-certificates \
#     gnupg \
#     lsb-release

## system extra settings
# allows gnome workspace to work with 2 monitors instead of only one
# gsettings set org.gnome.mutter workspaces-only-on-primary false
KEY_BASE_NAME=id_ed25519
KEY_NAME=${KEY_BASE_NAME}_$(date +%Y_%m_%d)
FILE=~/.ssh/$KEY_NAME
if [ -f $FILE ]; then
  echo "$FILE exists."
else
  ssh-keygen -o -a 100 -t ed25519 -f $FILE -C "$KEY_NAME" -q -N ""
fi
cat $FILE.pub
## /#

## Install many apps, each app install consists of

# COMMAND
# IF command doesn't exist run code block of installation
# ELSE tell command exists 
# FI

# COMMAND=appimagelauncherd
# if ! command -v $COMMAND &> /dev/null; then
#     sudo add-apt-repository ppa:appimagelauncher-team/stable -y
#     sudo apt-get update
#     sudo apt-get install -y appimagelauncher
# else
#     echo "$COMMAND found"
# fi
# COMMAND=platformio
# if ! command -v $COMMAND &> /dev/null; then
#     pip install -U pip
#     pip install -U esptool
#     python -c "$(curl -fsSL https://raw.githubusercontent.com/platformio/platformio/master/scripts/get-platformio.py)"
#     LINE='export PATH=$PATH:$HOME/.local/bin'
#     FILE=~/.profile
#     grep -xqF -- "$LINE" $FILE || echo "$LINE" >> "$FILE"
#     declare -a StringArray=(
#         'platformio'
#         'pio'
#         'piodebuggdb'
#     )
#     for file in "${StringArray[@]}"; do
#         if [ -f ~/.local/bin/$file ]; then
#             echo "~/.local/bin/$file exists."
#         else
#             ln -s ~/.platformio/penv/bin/$file ~/.local/bin/$file
#         fi
#     done
#     curl -fsSL https://raw.githubusercontent.com/platformio/platformio-core/master/scripts/99-platformio-udev.rules | sudo tee /etc/udev/rules.d/99-platformio-udev.rules
#     sudo service udev restart
#     sudo usermod -a -G dialout $USER
#     sudo usermod -a -G plugdev $USER
# else
#     echo "$COMMAND found"
# fi
# COMMAND=deb-get
# if ! command -v $COMMAND &> /dev/null; then
#     # remember to set DEBGET_TOKEN before running
#     DEBGET_TOKEN=<my-secret-token>
#     export DEBGET_TOKEN=$DEBGET_TOKEN
#     curl -sL https://raw.githubusercontent.com/wimpysworld/deb-get/main/deb-get | sudo -E bash -s install deb-get
# else
#     echo "$COMMAND found"
# fi
COMMAND=google-chrome
if ! command -v $COMMAND &> /dev/null; then
    wget -O ~/${COMMAND}.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo gdebi -n ~/${COMMAND}.deb
    rm ~/${COMMAND}.deb
else
    echo "$COMMAND found"
fi
# keybase not working yet for ubuntu 23.10
# COMMAND=keybase
# if ! command -v $COMMAND &> /dev/null; then
#     curl https://prerelease.keybase.io/keybase_amd64.deb -o ~/${COMMAND}.deb
#     sudo gdebi -n ~/${COMMAND}.deb
#     rm ~/${COMMAND}.deb
#     run_keybase
# else
#     echo "$COMMAND found"
# fi
# terraform not working yet for ubuntu 23.10
# COMMAND=terraform
# if ! command -v $COMMAND &> /dev/null; then
#     sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
#     wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
#     # gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
#     echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
#     sudo apt-get update && sudo apt-get install -y $COMMAND
# else
#     echo "$COMMAND found"
# fi
COMMAND=tofu
if ! command -v $COMMAND &> /dev/null; then
    curl -s https://packagecloud.io/install/repositories/opentofu/tofu/script.deb.sh?any=true -o /tmp/tofu-repository-setup.sh
    sudo bash /tmp/tofu-repository-setup.sh
    rm /tmp/tofu-repository-setup.sh
    sudo apt-get install -y tofu
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
COMANND=??
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
COMANND=mysql-workbench-community
if ! command -v $COMMAND &> /dev/null; then
    # wget -O ~/${COMMAND}.deb https://repo.mysql.com//mysql-apt-config_0.8.28-1_all.deb
    # sudo gdebi -n ~/${COMMAND}.deb
    # rm ~/${COMMAND}.deb
    sudo snap install $COMANND
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
    # declare -a StringArray=(
    #     'Dart-Code.dart-code'
    #     'Dart-Code.flutter'
    #     'DavidAnson.vscode-markdownlint'
    #     'GitHub.copilot'
    #     'GitHub.vscode-pull-request-github'
    #     'GrapeCity.gc-excelviewer'
    #     'ms-azuretools.vscode-docker'
    #     'ms-python.python'
    #     'ms-python.vscode-pylance'
    #     'ms-toolsai.jupyter'
    #     'ms-vscode-remote.remote-ssh'
    #     'ms-vscode-remote.remote-ssh-edit'
    #     'ms-vscode.cpptools'
    #     'tomoki1207.pdf'
    #     'WakaTime.vscode-wakatime'
    #     'yzane.markdown-pdf'
    # )
    # for val in "${StringArray[@]}"; do
    #     code --install-extension $val
    # done
    # pip install ipykernel
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
# COMMAND=drovio
# if ! command -v $COMMAND &> /dev/null; then
#     wget -O ~/drovio.deb https://repository.drovio.com/stable/drovio/linux/latest_version/drovio.deb
#     sudo gdebi -n ~/drovio.deb
# else
#     echo "$COMMAND found"
# fi
COMMAND=spotify
if ! command -v $COMMAND &> /dev/null; then
    # curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
    # echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
    # sudo apt-get update && sudo apt-get install -y spotify-client
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
    # sudo snap install obs-studio
else
    echo "$COMMAND found"
fi
COMMAND=chat-gpt
if ! command -v $COMMAND &> /dev/null; then
    wget -O ~/${COMMAND}.deb "https://github.com/lencx/ChatGPT/releases/download/v1.1.0/ChatGPT_1.1.0_linux_x86_64.deb"
    sudo gdebi -n ~/${COMMAND}.deb
    rm ~/${COMMAND}.deb
else
    echo "$COMMAND found"
fi
# COMMAND=discord
# if ! command -v $COMMAND &> /dev/null; then
#     wget -O ~/${COMMAND}.deb "https://discordapp.com/api/download?platform=linux&format=deb"
#     sudo gdebi -n ~/${COMMAND}.deb
#     rm ~/${COMMAND}.deb
# else
#     echo "$COMMAND found"
# fi
# # run telegram-desktop afterwards
COMMAND=telegram-desktop
if ! command -v $COMMAND &> /dev/null; then
    # wget -O- https://telegram.org/dl/desktop/linux | sudo tar xJ -C /opt/
    # sudo ln -s /opt/Telegram/Telegram /usr/local/bin/telegram-desktop
    sudo snap install telegram-desktop
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
# COMMAND=upwork
# if ! command -v $COMMAND &> /dev/null; then
#     wget --user-agent="Mozilla" -O ~/${COMMAND}.deb https://upwork-usw2-desktopapp.upwork.com/binaries/v5_8_0_24_aef0dc8c37cf46a8/upwork_5.8.0.24_amd64.deb
#     sudo gdebi -n ~/${COMMAND}.deb
#     rm ~/${COMMAND}.deb
# else
#     echo "$COMMAND found"
# fi
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
# COMMAND=youtube-dl
# if ! command -v $COMMAND &> /dev/null; then
#     sudo -H pip install --upgrade youtube-dl
# else
#     echo "$COMMAND found"
# fi
COMMAND=authy
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
    sudo snap install $COMMAND
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
# COMMAND=projectlibre
# if ! command -v $COMMAND &> /dev/null; then
#     wget -O ~/projectlibre.deb https://megalink.dl.sourceforge.net/project/projectlibre/ProjectLibre/1.9.3/projectlibre_1.9.3-1.deb
#     sudo gdebi -n ~/projectlibre.deb
# else
#     echo "$COMMAND found"
# fi
# COMMAND=qbittorrent
# if ! command -v $COMMAND &> /dev/null; then
#     sudo add-apt-repository ppa:qbittorrent-team/qbittorrent-stable -y
#     sudo apt-get update && sudo apt-get install -y qbittorrent
# else
#     echo "$COMMAND found"
# fi
# COMMAND=remmina
# if ! command -v $COMMAND &> /dev/null; then
#     sudo apt-add-repository ppa:remmina-ppa-team/remmina-next -y
#     sudo apt-get update
#     sudo apt-get install -y remmina remmina-plugin-rdp remmina-plugin-secret
# else
#     echo "$COMMAND found"
# fi
# un-comment to re-add teams
# COMMAND=teams
# if ! command -v $COMMAND &> /dev/null; then
#     curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
#     sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/ms-teams stable main" > /etc/apt/sources.list.d/teams.list'
#     sudo apt-get update
#     sudo apt-get install -y teams
# else
#     echo "$COMMAND found"
# fi
# COMMAND=brave-browser
# if ! command -v $COMMAND &> /dev/null; then
#     sudo apt-get install apt-transport-https curl
#     sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
#     echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
#     sudo apt-get update
#     sudo apt-get install -y brave-browser
# else
#     echo "$COMMAND found"
# fi
# FILE=~/.local/share/applications/freecad_realthunder.desktop
# if [ -f "$FILE" ]; then
#     echo "$FILE exists."
# else
#     pip3 install 'lxml == 4.6.3'
#     python3 ./python_scripts/download_latest_freecad_from_github.py
#     sudo chmod a+x ${HOME}/apps/freecad_realthunder/FreeCad_RealThunder.AppImage
#     cat >$FILE <<EOL
# [Desktop Entry]
# Name=FreeCad_RealThunder
# Comment=FreeCad RealThunder version
# Exec=${HOME}/apps/freecad_realthunder/FreeCad_RealThunder.AppImage
# Icon=${HOME}/apps/app-icons/freecad_realthunder.png
# Terminal=false
# Type=Application
# Categories=Development
# EOL
# fi
# COMMAND=google-earth-pro
# if ! command -v $COMMAND &> /dev/null; then
#     wget -O ~/${COMMAND}.deb https://dl.google.com/dl/earth/client/current/google-earth-pro-stable_current_amd64.deb
#     sudo gdebi -n ~/${COMMAND}.deb
#     rm ~/${COMMAND}.deb
# else
#     echo "$COMMAND found"
# fi
# COMMAND=gsutil
# if ! command -v $COMMAND &> /dev/null; then
#     wget -O ~/gsutil.tar.gz https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-398.0.0-linux-x86_64.tar.gz
#     cd ~/
#     tar -xf ~/gsutil.tar.gz
#     ./google-cloud-sdk/install.sh
#     ./google-cloud-sdk/bin/gcloud init
# else
#     echo "$COMMAND found"
# fi
# COMMAND=waynergy
# if ! command -v $COMMAND &> /dev/null; then
#     sudo apt-get install -y libxkbcommon-dev libtls-dev wl-clipboard wayland-scanner++
# else
#     echo "$COMMAND found"
# fi
COMMAND=dbeaver-ce
if ! command -v $COMMAND &> /dev/null; then
    # curl -fsSL https://dbeaver.io/debs/dbeaver.gpg.key | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/dbeaver.gpg
    # echo "deb https://dbeaver.io/debs/dbeaver-ce /" | sudo tee /etc/apt/sources.list.d/dbeaver.list
    # sudo apt-get update
    # sudo apt-get install -y dbeaver-ce
    sudo snap install $COMMAND
else
    echo "$COMMAND found"
fi
# COMMAND=syncthing
# if ! command -v $COMMAND &> /dev/null; then
#     curl -fsSL https://syncthing.net/release-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/syncthing-archive-keyring.gpg
#     echo "deb [signed-by=/usr/share/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list
#     sudo apt-get update
#     sudo apt-get install -y $COMMAND
# else
#     echo "$COMMAND found"
# fi
# COMMAND=franz
# if ! command -v $COMMAND &> /dev/null; then
#     wget -O ~/${COMMAND}.deb https://github.com/meetfranz/franz/releases/download/v5.9.2/franz_5.9.2_amd64.deb
#     sudo gdebi -n ~/${COMMAND}.deb
#     rm ~/${COMMAND}.deb
# else
#     echo "$COMMAND found"
# fi
service_exists() {
    local n=$1
    if [[ $(systemctl list-units --all -t service --full --no-legend "$n.service" | sed 's/^\s*//g' | cut -f1 -d' ') == $n.service ]]; then
        return 0
    else
        return 1
    fi
}
# SERVICE=plexmediaserver
# if service_exists SERVICE; then
#     echo "$SERVICE found"
# else
#     curl -fsSL https://downloads.plex.tv/plex-keys/PlexSign.key | gpg --dearmor | sudo tee /usr/share/keyrings/plexmediaserver.gpg  > /dev/null
#     echo "deb [signed-by=/usr/share/keyrings/plexmediaserver.gpg] https://downloads.plex.tv/repo/deb public main" | sudo tee /etc/apt/sources.list.d/plexmediaserver.list
#     sudo apt-get update
#     sudo apt-get install -y plexmediaserver
# fi
# SERVICE=ums.service
# VERSION=11.4.1
# if service_exists SERVICE; then
#     echo "$SERVICE found"
# else
#     sudo apt-get install -y mediainfo dcraw vlc mplayer mencoder openjdk-18-jre
#     wget -O ~/${SERVICE}.tgz https://github.com/UniversalMediaServer/UniversalMediaServer/releases/download/${VERSION}/UMS-${VERSION}-x86_64.tgz
#     sudo tar -zxvf ~/${SERVICE}.tgz -C /opt/ --transform s/ums-${VERSION}/ums/
#     FILE=/etc/systemd/system/ums.service
#     if [ -f "$FILE" ]; then
#         echo "$FILE exists."
#     else
#         cat >$FILE <<EOL
# [Unit]
# Description=Run UMS as hari
# DefaultDependencies=no
# After=network.target

# [Service]
# Type=simple
# User=hari
# Group=hari
# ExecStart=/opt/ums/UMS.sh
# TimeoutStartSec=0
# RemainAfterExit=yes
# Environment="UMS_MAX_MEMORY=2048M"

# [Install]
# WantedBy=default.target
# EOL
#     fi
# fi