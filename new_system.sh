#!/bin/bash
sudo apt update
sudo apt upgrade -y
# lines 5 - 9 install docker requirements
sudo apt install -y gdebi python3-pip python3-venv htop \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
COMMAND=google-chrome
if ! command -v $COMMAND &> /dev/null; then
    wget -O ~/google-chrome-stable_current_amd64.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo gdebi -n google-chrome-stable_current_amd64.deb
else
    echo "$COMMAND found"
fi
COMMAND=code
if ! command -v $COMMAND &> /dev/null; then
    sudo apt install -y software-properties-common apt-transport-https curl
    curl -sSL https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
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
    curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo apt-key add - 
    echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
    sudo apt-get update && sudo apt-get install -y spotify-client
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
    sudo add-apt-repository ppa:rvm/smplayer 
    sudo apt-get update 
    sudo apt-get install smplayer smplayer-themes smplayer-skins 
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
    python3 download_latest_file_from_github.py
    chmod a+x ${HOME}/apps/obsidian/Obsidian.AppImage
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
