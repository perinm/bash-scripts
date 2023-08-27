#!/bin/bash
sudo apt-get update -y && sudo apt-get full-upgrade -y && sudo apt-get autoremove -y && sudo apt-get clean -y && sudo apt-get autoclean -y

# lines below sudo apt-get install, install docker requirements
sudo apt-get install -y gdebi git htop python3-pip python3-venv htop libcanberra-gtk-module p7zip-full lm-sensors ppa-purge wireguard wireguard-tools net-tools nmap \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

KEY_BASE_NAME=rasp
KEY_NAME=${KEY_BASE_NAME}_$(date +%Y_%m_%d)
FILE=~/.ssh/$KEY_NAME
if [ -f $FILE ]; then
  echo "$FILE exists."
else
  ssh-keygen -o -a 100 -t ed25519 -f $FILE -C "$KEY_NAME" -q -N ""
fi
cat $FILE.pub

## system extra settings
# allows gnome workspace to work with 2 monitors instead of only one
# gsettings set org.gnome.mutter workspaces-only-on-primary false

## /#

## Install many apps, each app install consists of

# COMMAND
# IF command doesn't exist run code block of installation
# ELSE tell command exists 
# FI
# COMMAND=google-chrome
# if ! command -v $COMMAND &> /dev/null; then
#     wget -O ~/google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
#     sudo gdebi -n ~/google-chrome.deb
# else
#     echo "$COMMAND found"
# fi
# COMMAND=code
# if ! command -v $COMMAND &> /dev/null; then
#     sudo apt-get install -y software-properties-common apt-transport-https curl
#     wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
#     sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
#     sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
#     rm -f packages.microsoft.gpg
#     sudo apt-get install -y apt-transport-https
#     sudo apt-get update
#     sudo apt-get install -y code
#     declare -a StringArray=(
#         'GitHub.copilot'
#         'GitHub.vscode-pull-request-github'
#         'GrapeCity.gc-excelviewer'
#         'ms-azuretools.vscode-docker'
#         'ms-python.python'
#         'ms-python.vscode-pylance'
#         'ms-toolsai.jupyter'
#         'ms-vscode-remote.remote-ssh'
#         'ms-vscode-remote.remote-ssh-edit'
#         'ms-vscode.cpptools'
#         'tomoki1207.pdf'
#         'WakaTime.vscode-wakatime'
#     )
#     for val in "${StringArray[@]}"; do
#         code --install-extension $val
#     done
#     pip install ipykernel
# else
#     echo "$COMMAND found"
# fi
# COMMAND=docker
# if ! command -v $COMMAND &> /dev/null; then
#     curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
#     echo \
#         "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
#         $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
#     sudo apt-get update
#     sudo apt-get install -y docker-ce docker-ce-cli containerd.io
# else
#     echo "$COMMAND found"
# fi
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
COMMAND=raspotify
if ! command -v $COMMAND &> /dev/null; then
    sudo apt-get -y install curl && curl -sL https://dtcooper.github.io/raspotify/install.sh | sh
else
    echo "$COMMAND found"
fi
# COMMAND=spocon
# if ! command -v $COMMAND &> /dev/null; then
#     sudo add-apt-repository ppa:spocon/spocon
#     sudo apt-get -y update
#     sudo apt-get install spocon 
# else
#     echo "$COMMAND found"
# fi
COMMAND=brave-browser
if ! command -v $COMMAND &> /dev/null; then
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
    sudo apt-get update
    sudo apt-get install brave-browser
else
    echo "$COMMAND found"
fi
# COMMAND=discord
# if ! command -v $COMMAND &> /dev/null; then
#     wget -O ~/discord.deb "https://discordapp.com/api/download?platform=linux&format=deb"
#     sudo gdebi -n ~/discord.deb
# else
#     echo "$COMMAND found"
# fi
COMMAND=syncthing
if ! command -v $COMMAND &> /dev/null; then
    sudo apt-get install -y apt-transport-https
    curl -s https://syncthing.net/release-key.txt | gpg --dearmor | sudo tee /usr/share/keyrings/syncthing-archive-keyring.gpg >/dev/null
    echo "deb [signed-by=/usr/share/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list
    sudo apt update
    sudo apt install syncthing
else
    echo "$COMMAND found"
fi
COMMAND=nordvpn
if ! command -v $COMMAND &> /dev/null; then
    sh <(curl -sSf https://downloads.nordcdn.com/apps/linux/install.sh)
else
    echo "$COMMAND found"
fi
COMMAND=telegram-desktop
if ! command -v $COMMAND &> /dev/null; then
    wget -O- https://telegram.org/dl/desktop/linux | sudo tar xJ -C /opt/
    sudo ln -s /opt/Telegram/Telegram /usr/local/bin/telegram-desktop
else
    echo "$COMMAND found"
fi
# COMMAND=slack
# if ! command -v $COMMAND &> /dev/null; then
#     wget -O ~/slack.deb https://downloads.slack-edge.com/releases/linux/4.17.0/prod/x64/slack-desktop-4.17.0-amd64.deb
#     sudo gdebi -n ~/slack.deb
# else
#     echo "$COMMAND found"
# fi
# FILE=~/.local/share/applications/obsidian.desktop
# if [ -f "$FILE" ]; then
#     echo "$FILE exists."
# else
#     pip install 'lxml == 4.6.3'
#     python3 ./python_scripts/download_latest_file_from_github.py
#     chmod a+x ${HOME}/apps/obsidian/Obsidian.AppImage
#     cat >$FILE <<EOL
# [Desktop Entry]
# Name=Obsidian
# Comment=Obsidian - A second brain, for you, forever.
# Exec=${HOME}/apps/obsidian/Obsidian.AppImage
# Icon=${HOME}/apps/app-icons/obsidian.png
# Terminal=false
# Type=Application
# Categories=Development
# MimeType=x-scheme-handler/obsidian;text/html;
# EOL
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
#     pip install 'lxml == 4.6.3'
#     python3 ./python_scripts/download_latest_freecad_from_github.py
#     chmod a+x ${HOME}/apps/freecad_realthunder/FreeCad_RealThunder.AppImage
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