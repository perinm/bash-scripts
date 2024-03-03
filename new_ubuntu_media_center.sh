#!/bin/bash
sudo apt-get update -y && sudo apt-get full-upgrade -y && sudo apt-get autoremove -y && sudo apt-get clean -y && sudo apt-get autoclean -y \
    && sudo snap refresh

sudo apt-get install -y gdebi curl whois nmap ncdu htop tilix apt-transport-https \
    lm-sensors wget gpg gnome-shell-extensions wavemon flatpak

sudo snap install steam

KEY_BASE_NAME=id_ed25519
KEY_NAME=${KEY_BASE_NAME}_$(date +%Y_%m_%d)
FILE=~/.ssh/$KEY_NAME
if [ -f $FILE ]; then
  echo "$FILE exists."
else
  ssh-keygen -o -a 100 -t ed25519 -f $FILE -C "$KEY_NAME" -q -N ""
fi
cat $FILE.pub

COMMAND=qbittorrent
if ! command -v $COMMAND &> /dev/null; then
    sudo add-apt-repository ppa:qbittorrent-team/qbittorrent-stable -y
    sudo apt-get update && sudo apt-get install -y qbittorrent
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

COMMAND=yuzu
if ! command -v $COMMAND &> /dev/null; then
  sudo apt-get install autoconf cmake g++-11 gcc-11 git glslang-tools libasound2 libboost-context-dev libglu1-mesa-dev libhidapi-dev libpulse-dev libtool libudev-dev libxcb-icccm4 libxcb-image0 libxcb-keysyms1 libxcb-render-util0 libxcb-xinerama0 libxcb-xkb1 libxext-dev libxkbcommon-x11-0 mesa-common-dev nasm ninja-build qtbase5-dev qtbase5-private-dev qtwebengine5-dev qtmultimedia5-dev libmbedtls-dev catch2 libfmt-dev liblz4-dev nlohmann-json3-dev libzstd-dev libssl-dev libavfilter-dev libavcodec-dev libswscale-dev

  -DYUZU_USE_QT_WEB_ENGINE=ON
  -DCMAKE_C_COMPILER=gcc-11 -DCMAKE_CXX_COMPILER=g++-11
  -DYUZU_USE_EXTERNAL_SDL2=OFF
  git clone --recursive https://github.com/yuzu-emu/yuzu-mainline
  cd yuzu-mainline
  mkdir build && cd build
  cmake .. -GNinja -DYUZU_USE_BUNDLED_VCPKG=ON -DYUZU_TESTS=OFF
  ninja
  sudo ninja install
else
    echo "$COMMAND found"
fi

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub com.obsproject.Studio
flatpak install flathub com.obsproject.Studio.Plugin.BackgroundRemoval

COMMAND=docker
if ! command -v $COMMAND &> /dev/null; then
  curl https://get.docker.com | sh
  sudo usermod -aG docker $USER
else
  echo "$COMMAND found"
fi
COMMAND=spotify-client
if ! command -v $COMMAND &> /dev/null; then
  curl -sS https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
  echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
  sudo apt-get update && sudo apt-get install spotify-client
else
  echo "$COMMAND found"
fi