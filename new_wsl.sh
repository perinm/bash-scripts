#!/bin/bash
sudo apt-get update -y && sudo apt-get full-upgrade -y && sudo apt-get autoremove -y && sudo apt-get clean -y && sudo apt-get autoclean -y

sudo apt-get install -y python-is-python3 gdebi python3-pip python3-venv htop p7zip-full lm-sensors \
  ncdu ppa-purge nmap whois gcc g++ make

sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt-get update -y && sudo apt-get full-upgrade -y && sudo apt-get autoremove -y && sudo apt-get clean -y && sudo apt-get autoclean -y
sudo apt-get install -y python3.11 python3.11-venv python3.11-dev
python3.11 -m pip install -U pip setuptools wheel setuptools-rust

FILE=~/.ssh/id_ed25519
if [ -f $FILE ]; then
  echo "$FILE exists."
else
  ssh-keygen -o -a 100 -t ed25519 -f $FILE -C "lucasperinm@gmail.com" -q -N ""
fi
cat $FILE

# https://github.com/nodesource/distributions/blob/master/README.md
# https://www.npmjs.com/package/@githubnext/github-copilot-cli
COMMAND=??
if ! command -v $COMMAND &> /dev/null; then
  curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - && sudo apt-get install -y nodejs
  sudo npm install -g npm@latest
  sudo npm install -g @githubnext/github-copilot-cli
  echo 'eval "$(github-copilot-cli alias -- "$0")"' >> ~/.bashrc
  github-copilot-cli auth
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

COMMAND=nvidia-smi
if ! command -v $COMMAND &> /dev/null; then
  echo "$COMMAND not found"
else
  distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
  # curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
  # curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
  # sudo apt-get update
  # sudo apt-get install -y nvidia-docker2
  # wget https://developer.download.nvidia.com/compute/cuda/repos/wsl-ubuntu/x86_64/cuda-wsl-ubuntu.pin
  # sudo mv cuda-wsl-ubuntu.pin /etc/apt/preferences.d/cuda-repository-pin-600
  # wget https://developer.download.nvidia.com/compute/cuda/12.1.0/local_installers/cuda-repo-wsl-ubuntu-12-1-local_12.1.0-1_amd64.deb
  # sudo dpkg -i cuda-repo-wsl-ubuntu-12-1-local_12.1.0-1_amd64.deb
  # sudo cp /var/cuda-repo-wsl-ubuntu-12-1-local/cuda-*-keyring.gpg /usr/share/keyrings/
  # sudo apt-get update
  # sudo apt-get -y install cuda

  # https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&Distribution=WSL-Ubuntu&target_version=2.0&target_type=deb_network
  wget https://developer.download.nvidia.com/compute/cuda/repos/wsl-ubuntu/x86_64/cuda-keyring_1.1-1_all.deb
  sudo dpkg -i cuda-keyring_1.1-1_all.deb
  sudo apt-get update
  sudo apt-get -y install cuda
  distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
    && curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
    && curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | \
      sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
      sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
  sudo apt-get install -y nvidia-container-toolkit
  sudo nvidia-ctk runtime configure --runtime=docker
fi

ubuntu_release=`lsb_release -rs`
wget https://packages.microsoft.com/config/ubuntu/${ubuntu_release}/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get install -y apt-transport-https
sudo apt-get update
sudo apt-get install -y msopenjdk-17