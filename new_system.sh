#!/bin/bash
sudo apt update -y && sudo apt full-upgrade -y && sudo apt autoremove -y && sudo apt clean -y && sudo apt autoclean -y

# lines below sudo apt install, install docker requirements
sudo apt install -y gdebi python3-pip python3-venv htop libcanberra-gtk-module p7zip-full lm-sensors wireshark ppa-purge wireguard wireguard-tools net-tools nmap \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

## system extra settings
# allows gnome workspace to work with 2 monitors instead of only one
gsettings set org.gnome.mutter workspaces-only-on-primary false

## /#

## Install many apps, each app install consists of

# COMMAND
# IF command doesn't exist run code block of installation
# ELSE tell command exists 
# FI
COMMAND=google-chrome
if ! command -v $COMMAND &> /dev/null; then
    wget -O ~/google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo gdebi -n ~/google-chrome.deb
else
    echo "$COMMAND found"
fi
COMMAND=code
if ! command -v $COMMAND &> /dev/null; then
    sudo apt install -y software-properties-common apt-transport-https curl
    curl -sSL https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" -y
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
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo \
        "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
else
    echo "$COMMAND found"
fi
COMMAND=docker-compose
if ! command -v $COMMAND &> /dev/null; then
    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
else
    echo "$COMMAND found"
fi
COMMAND=drovio
if ! command -v $COMMAND &> /dev/null; then
    wget -O ~/drovio.deb https://repository.drovio.com/stable/drovio/linux/latest_version/drovio.deb
    sudo gdebi -n ~/drovio.deb
else
    echo "$COMMAND found"
fi
COMMAND=spotify
if ! command -v $COMMAND &> /dev/null; then
    # curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo apt-key add - 
    # echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
    # sudo apt-get update && sudo apt-get install -y spotify-client
    curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | sudo gpg --dearmor -o /usr/share/keyrings/spotify-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/spotify-archive-keyring.gpg] http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
    sudo apt-get update && sudo apt-get install spotify-client
else
    echo "$COMMAND found"
fi
COMMAND=obs
if ! command -v $COMMAND &> /dev/null; then
    sudo apt install -y ffmpeg
    sudo add-apt-repository ppa:obsproject/obs-studio -y
    sudo apt update
    sudo apt install -y obs-studio
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
COMMAND=telegram-desktop
if ! command -v $COMMAND &> /dev/null; then
    wget -O- https://telegram.org/dl/desktop/linux | sudo tar xJ -C /opt/
    sudo ln -s /opt/Telegram/Telegram /usr/local/bin/telegram-desktop
else
    echo "$COMMAND found"
fi
COMMAND=slack
if ! command -v $COMMAND &> /dev/null; then
    wget -O ~/slack.deb https://downloads.slack-edge.com/releases/linux/4.17.0/prod/x64/slack-desktop-4.17.0-amd64.deb
    sudo gdebi -n ~/slack.deb
else
    echo "$COMMAND found"
fi
COMMAND=upwork
if ! command -v $COMMAND &> /dev/null; then
    wget -O ~/upwork.deb https://upwork-usw2-desktopapp.upwork.com/binaries/v5_5_0_11_61df9c99b6df4e7b/upwork_5.5.0.11_amd64.deb
    sudo gdebi -n ~/upwork.deb
else
    echo "$COMMAND found"
fi
COMMAND=smplayer
if ! command -v $COMMAND &> /dev/null; then
    sudo add-apt-repository ppa:rvm/smplayer -y
    sudo apt-get update 
    sudo apt-get install -y smplayer smplayer-themes
else
    echo "$COMMAND found"
fi
COMMAND=youtube-dl
if ! command -v $COMMAND &> /dev/null; then
    sudo -H pip install --upgrade youtube-dl
else
    echo "$COMMAND found"
fi
FILE=~/.local/share/applications/obsidian.desktop
if [ -f "$FILE" ]; then
    echo "$FILE exists."
else
    pip install 'lxml == 4.6.3'
    python3 ./python_scripts/download_latest_file_from_github.py
    sudo chmod a+x ${HOME}/apps/obsidian/Obsidian.AppImage
    cat >$FILE <<EOL
[Desktop Entry]
Name=Obsidian
Comment=Obsidian - A second brain, for you, forever.
Exec=${HOME}/apps/obsidian/Obsidian.AppImage
Icon=${HOME}/apps/app-icons/obsidian.png
Terminal=false
Type=Application
Categories=Development
MimeType=x-scheme-handler/obsidian;text/html;
EOL
fi
COMMAND=arduino
if ! command -v $COMMAND &> /dev/null; then
    wget -O ~/arduino1.tar.xz https://downloads.arduino.cc/arduino-1.8.15-linux64.tar.xz
    tar -xf ~/arduino1.tar.xz -C ~/
    sudo ~/arduino-1.8.15/install.sh
    sudo usermod -a -G dialout $USER
else
    echo "$COMMAND found"
fi
COMMAND=qbittorrent
if ! command -v $COMMAND &> /dev/null; then
    sudo add-apt-repository ppa:qbittorrent-team/qbittorrent-stable -y
    sudo apt-get update && sudo apt-get install -y qbittorrent
else
    echo "$COMMAND found"
fi
COMMAND=remmina
if ! command -v $COMMAND &> /dev/null; then
    sudo apt-add-repository ppa:remmina-ppa-team/remmina-next -y
    sudo apt update
    sudo apt install -y remmina remmina-plugin-rdp remmina-plugin-secret
else
    echo "$COMMAND found"
fi
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
COMMAND=brave-browser
if ! command -v $COMMAND &> /dev/null; then
    sudo apt install apt-transport-https curl
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
    sudo apt update
    sudo apt install -y brave-browser
else
    echo "$COMMAND found"
fi
FILE=~/.local/share/applications/freecad_realthunder.desktop
if [ -f "$FILE" ]; then
    echo "$FILE exists."
else
    pip3 install 'lxml == 4.6.3'
    python3 ./python_scripts/download_latest_freecad_from_github.py
    sudo chmod a+x ${HOME}/apps/freecad_realthunder/FreeCad_RealThunder.AppImage
    cat >$FILE <<EOL
[Desktop Entry]
Name=FreeCad_RealThunder
Comment=FreeCad RealThunder version
Exec=${HOME}/apps/freecad_realthunder/FreeCad_RealThunder.AppImage
Icon=${HOME}/apps/app-icons/freecad_realthunder.png
Terminal=false
Type=Application
Categories=Development
EOL
fi
COMMAND=google-earth-pro
if ! command -v $COMMAND &> /dev/null; then
    wget -O ~/google-earth.deb https://dl.google.com/dl/earth/client/current/google-earth-pro-stable_current_amd64.deb
    sudo gdebi -n ~/google-earth.deb
    rm ~/google-earth.deb
else
    echo "$COMMAND found"
fi
FILE=~/.local/share/applications/cura.desktop
if [ -f "$FILE" ]; then
    echo "$FILE exists."
else
    curl https://software.ultimaker.com/cura/Ultimaker_Cura-4.13.1.AppImage --create-dirs -o ${HOME}/apps/cura/cura.AppImage
    curl https://user-images.githubusercontent.com/18035735/48554277-46064580-e8de-11e8-8c4c-b682081a2219.png -o ${HOME}/apps/app-icons/cura.png
    sudo chmod a+x ${HOME}/apps/cura/cura.AppImage
    cat >$FILE <<EOL
[Desktop Entry]
Name=Cura
Comment=Cura
Exec=${HOME}/apps/cura/cura.AppImage
Icon=${HOME}/apps/app-icons/cura.png
Terminal=false
Type=Application
Categories=Development
EOL
fi
