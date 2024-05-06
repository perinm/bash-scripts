sudo apt-get install -y \
    bash \
    curl \
    file \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa

sudo apt-get install -y \
    clang cmake ninja-build libgtk-3-dev
#     libc6:i386 libncurses5:i386 \
#     libstdc++6:i386 lib32z1 \
#     libbz2-1.0:i386
sudo apt-get install libc6:i386 libstdc++6:i386 lib32z1 libbz2-1.0:i386 -y
# download android studio zip
cd ~/Downloads
if [ -f "android-studio-2023.3.1.18-linux.tar.gz" ]; then
    echo "android-studio-2023.3.1.18-linux.tar.gz exists."
else
    wget https://r7---sn-4g57knek.googlevideo.com/videoplayback?expire=1646820000&ei=3Z9oYv6dK4mH8wTJv7OgDQ&ip=2001%3A19f0%3A6c01%3A1b1%3A5400%3A3ff%3Afe0e%3A1b1&id=o-AK1X9Z6Z6
fi
# extract android studio
FOLDER=~/dev
if [ -d "$FOLDER" ]; then
    echo "$FOLDER exists."
else
    mkdir ~/dev
fi
cd ~/dev
FOLDER=android-studio
if [ -d "$FOLDER" ]; then
    echo "$FOLDER exists."
else
    tar -xvzf ~/Downloads/android-studio-2023.3.1.18-linux.tar.gz
fi
cd ~/dev/android-studio/bin
./studio.sh

COMMAND=flutter
if ! command -v $COMMAND &> /dev/null; then
    FOLDER=~/dev
    if [ -d "$FOLDER" ]; then
        echo "$FOLDER exists."
    else
        mkdir ~/dev
    fi
    cd ~/dev
    FOLDER=flutter
    if [ -d "$FOLDER" ]; then
        echo "$FOLDER exists."
    else
        git clone https://github.com/flutter/flutter.git -b stable    
        export PATH="$PATH:`pwd`/flutter/bin"
        flutter precache
        flutter doctor
        sudo apt install default-jdk -y
        sudo add-apt-repository ppa:maarten-fonville/android-studio -y
        sudo apt-get update
        sudo apt-get install android-studio -y
        sudo apt-get install cpu-checker -y
        sudo apt-get install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils -y
        sudo adduser `id -un` libvirt
        sudo adduser `id -un` kvm
        sudo apt install libcanberra-gtk-module libcanberra-gtk3-module -y
        # prepare flutter for linux apps
        sudo apt-get install clang cmake ninja-build pkg-config libgtk-3-dev -y
        flutter config --enable-linux-desktop
    fi
else
    echo "$COMMAND found"
fi
cd ~/dev
FOLDER=flutter-apps
if [ -d "$FOLDER" ]; then
    echo "$FOLDER already cloned."
else
    git clone https://github.com/perinm/flutter-apps.git
fi