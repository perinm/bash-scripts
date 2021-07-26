sudo apt update
sudo apt upgrade -y
sudo apt install gdebi -y
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
