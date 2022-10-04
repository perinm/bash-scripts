#!/bin/bash
sudo apt update -y && sudo apt full-upgrade -y && sudo apt autoremove -y && sudo apt clean -y && sudo apt autoclean -y

# TO-DO:
# - Prusa
# - Fritzing

sudo apt install -y gdebi python-is-python3 python3-pip python3-venv htop libcanberra-gtk-module p7zip-full lm-sensors wireshark \
    ncdu ppa-purge wireguard wireguard-tools net-tools nmap gparted btrfs-progs copyq gnome-shell-extensions d-feet btrfs-compsize \
    steam barrier copyq gimp tilix \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

## system extra settings
# allows gnome workspace to work with 2 monitors instead of only one
gsettings set org.gnome.mutter workspaces-only-on-primary false
FILE=~/.ssh/id_ed25519
if [ -f $FILE ]; then
    echo "$FILE exists."
else
    ssh-keygen -o -a 100 -t ed25519 -f $FILE -C "lucasperinm@gmail.com" -q -N ""
fi
## /#

## Install many apps, each app install consists of

# COMMAND
# IF command doesn't exist run code block of installation
# ELSE tell command exists 
# FI

COMMAND=appimagelauncherd
if ! command -v $COMMAND &> /dev/null; then
    sudo add-apt-repository ppa:appimagelauncher-team/stable -y
    sudo apt update
    sudo apt install -y appimagelauncher
else
    echo "$COMMAND found"
fi
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
COMMAND=google-chrome
if ! command -v $COMMAND &> /dev/null; then
    wget -O ~/google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo gdebi -n ~/google-chrome.deb
else
    echo "$COMMAND found"
fi
COMMAND=code
if ! command -v $COMMAND &> /dev/null; then
    sudo apt-get install -y wget gpg
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    rm -f packages.microsoft.gpg
    sudo apt update
    sudo apt install -y code
    declare -a StringArray=(
        'Dart-Code.dart-code'
        'Dart-Code.flutter'
        'DavidAnson.vscode-markdownlint'
        'GitHub.copilot'
        'GitHub.vscode-pull-request-github'
        'GrapeCity.gc-excelviewer'
        'ms-azuretools.vscode-docker'
        'ms-python.python'
        'ms-python.vscode-pylance'
        'ms-toolsai.jupyter'
        'ms-vscode-remote.remote-ssh'
        'ms-vscode-remote.remote-ssh-edit'
        'ms-vscode.cpptools'
        'tomoki1207.pdf'
        'WakaTime.vscode-wakatime'
        'yzane.markdown-pdf'
    )
    for val in "${StringArray[@]}"; do
        code --install-extension $val
    done
    pip install ipykernel
else
    echo "$COMMAND found"
fi
COMMAND=docker
if ! command -v $COMMAND &> /dev/null; then
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
else
    echo "$COMMAND found"
fi
# COMMAND=docker-compose
# if ! command -v $COMMAND &> /dev/null; then
#     sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
#     sudo chmod +x /usr/local/bin/docker-compose
# else
#     echo "$COMMAND found"
# fi
# COMMAND=drovio
# if ! command -v $COMMAND &> /dev/null; then
#     wget -O ~/drovio.deb https://repository.drovio.com/stable/drovio/linux/latest_version/drovio.deb
#     sudo gdebi -n ~/drovio.deb
# else
#     echo "$COMMAND found"
# fi
COMMAND=spotify
if ! command -v $COMMAND &> /dev/null; then
    curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | sudo gpg --dearmor -o /usr/share/keyrings/spotify-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/spotify-archive-keyring.gpg] http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
    sudo apt update && sudo apt install spotify-client
    # sudo snap install spotify
else
    echo "$COMMAND found"
fi
COMMAND=obs
if ! command -v $COMMAND &> /dev/null; then
    sudo add-apt-repository ppa:obsproject/obs-studio -y
    sudo apt update
    sudo apt install -y ffmpeg obs-studio
else
    echo "$COMMAND found"
fi
COMMAND=discord
if ! command -v $COMMAND &> /dev/null; then
    wget -O ~/discord.deb "https://discordapp.com/api/download?platform=linux&format=deb"
    sudo gdebi -n ~/discord.deb
else
    echo "$COMMAND found"
fi
# run telegram-desktop afterwards
COMMAND=telegram-desktop
if ! command -v $COMMAND &> /dev/null; then
    wget -O- https://telegram.org/dl/desktop/linux | sudo tar xJ -C /opt/
    sudo ln -s /opt/Telegram/Telegram /usr/local/bin/telegram-desktop
else
    echo "$COMMAND found"
fi
# COMMAND=slack
# if ! command -v $COMMAND &> /dev/null; then
#     wget -O ~/slack.deb https://downloads.slack-edge.com/releases/linux/4.27.156/prod/x64/slack-desktop-4.27.156-amd64.deb
#     sudo gdebi -n ~/slack.deb
#     # https://askubuntu.com/questions/1398344/apt-key-deprecation-warning-when-updating-system
#     # sudo apt-key list
#     # sudo apt-key export 038651BD | sudo gpg --dearmour -o /usr/share/keyrings/slack.gpg
#     # sudo nano /etc/apt/sources.list.d/slack.list
#     # add this line [uncommented]:
#     # deb [signed-by=/usr/share/keyrings/slack.gpg] https://packagecloud.io/slacktechnologies/slack/debian/ jessie main
#     # sudo snap install slack --classic
# else
#     echo "$COMMAND found"
# fi
COMMAND=upwork
if ! command -v $COMMAND &> /dev/null; then
    wget -O ~/upwork.deb https://upwork-usw2-desktopapp.upwork.com/binaries/v5_6_10_1_de501d28cc034306/upwork_5.6.10.1_amd64.deb
    sudo gdebi -n ~/upwork.deb
else
    echo "$COMMAND found"
fi
COMMAND=smplayer
if ! command -v $COMMAND &> /dev/null; then
    sudo snap install smplayer
else
    echo "$COMMAND found"
fi
COMMAND=youtube-dl
if ! command -v $COMMAND &> /dev/null; then
    sudo -H pip install --upgrade youtube-dl
else
    echo "$COMMAND found"
fi
COMMAND=obsidian
if ! command -v $COMMAND &> /dev/null; then
    wget -O ~/obsidian.deb https://github.com/obsidianmd/obsidian-releases/releases/download/v0.15.9/obsidian_0.15.9_amd64.deb
    sudo gdebi -n ~/obsidian.deb
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
COMMAND=qbittorrent
if ! command -v $COMMAND &> /dev/null; then
    sudo add-apt-repository ppa:qbittorrent-team/qbittorrent-stable -y
    sudo apt-get update && sudo apt-get install -y qbittorrent
else
    echo "$COMMAND found"
fi
# COMMAND=remmina
# if ! command -v $COMMAND &> /dev/null; then
#     sudo apt-add-repository ppa:remmina-ppa-team/remmina-next -y
#     sudo apt update
#     sudo apt install -y remmina remmina-plugin-rdp remmina-plugin-secret
# else
#     echo "$COMMAND found"
# fi
# un-comment to re-add teams
# COMMAND=teams
# if ! command -v $COMMAND &> /dev/null; then
#     curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
#     sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/ms-teams stable main" > /etc/apt/sources.list.d/teams.list'
#     sudo apt update
#     sudo apt install -y teams
# else
#     echo "$COMMAND found"
# fi
# COMMAND=brave-browser
# if ! command -v $COMMAND &> /dev/null; then
#     sudo apt install apt-transport-https curl
#     sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
#     echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
#     sudo apt update
#     sudo apt install -y brave-browser
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
COMMAND=google-earth-pro
if ! command -v $COMMAND &> /dev/null; then
    wget -O ~/google-earth.deb https://dl.google.com/dl/earth/client/current/google-earth-pro-stable_current_amd64.deb
    sudo gdebi -n ~/google-earth.deb
    rm ~/google-earth.deb
else
    echo "$COMMAND found"
fi
COMMAND=gsutil
if ! command -v $COMMAND &> /dev/null; then
    wget -O ~/gsutil.tar.gz https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-398.0.0-linux-x86_64.tar.gz
    cd ~/
    tar -xf ~/gsutil.tar.gz
    ./google-cloud-sdk/install.sh
    ./google-cloud-sdk/bin/gcloud init
else
    echo "$COMMAND found"
fi
# COMMAND=waynergy
# if ! command -v $COMMAND &> /dev/null; then
#     sudo apt install -y libxkbcommon-dev libtls-dev wl-clipboard wayland-scanner++
# else
#     echo "$COMMAND found"
# fi
COMMAND=dbeaver-ce
if ! command -v $COMMAND &> /dev/null; then
    curl -fsSL https://dbeaver.io/debs/dbeaver.gpg.key | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/dbeaver.gpg
    echo "deb https://dbeaver.io/debs/dbeaver-ce /" | sudo tee /etc/apt/sources.list.d/dbeaver.list
    sudo apt update
    sudo apt install -y dbeaver-ce
else
    echo "$COMMAND found"
fi
COMMAND=franz
if ! command -v $COMMAND &> /dev/null; then
    wget -O ~/${COMMAND}.deb https://github.com/meetfranz/franz/releases/download/v5.9.2/franz_5.9.2_amd64.deb
    sudo gdebi -n ~/${COMMAND}.deb
    rm ~/${COMMAND}.deb
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
# SERVICE=plexmediaserver
# if service_exists SERVICE; then
#     echo "$SERVICE found"
# else
#     curl -fsSL https://downloads.plex.tv/plex-keys/PlexSign.key | gpg --dearmor | sudo tee /usr/share/keyrings/plexmediaserver.gpg  > /dev/null
#     echo "deb [signed-by=/usr/share/keyrings/plexmediaserver.gpg] https://downloads.plex.tv/repo/deb public main" | sudo tee /etc/apt/sources.list.d/plexmediaserver.list
#     sudo apt update
#     sudo apt install -y plexmediaserver
# fi
SERVICE=ums.service
VERSION=11.4.1
if service_exists SERVICE; then
    echo "$SERVICE found"
else
    sudo apt install -y mediainfo dcraw vlc mplayer mencoder openjdk-18-jre
    wget -O ~/${SERVICE}.tgz https://github.com/UniversalMediaServer/UniversalMediaServer/releases/download/${VERSION}/UMS-${VERSION}-x86_64.tgz
    sudo tar -zxvf ~/${SERVICE}.tgz -C /opt/ --transform s/ums-${VERSION}/ums/
    FILE=/etc/systemd/system/ums.service
    if [ -f "$FILE" ]; then
        echo "$FILE exists."
    else
        cat >$FILE <<EOL
[Unit]
Description=Run UMS as hari
DefaultDependencies=no
After=network.target

[Service]
Type=simple
User=hari
Group=hari
ExecStart=/opt/ums/UMS.sh
TimeoutStartSec=0
RemainAfterExit=yes
Environment="UMS_MAX_MEMORY=2048M"

[Install]
WantedBy=default.target
EOL
    fi
fi