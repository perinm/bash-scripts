# https://docs.nvidia.com/cuda/wsl-user-guide/index.html#getting-started-with-cuda-on-wsl
# https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&Distribution=WSL-Ubuntu
sudo apt-key del 7fa2af80
wget https://developer.download.nvidia.com/compute/cuda/repos/wsl-ubuntu/x86_64/cuda-wsl-ubuntu.pin
sudo mv cuda-wsl-ubuntu.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/12.6.2/local_installers/cuda-repo-wsl-ubuntu-12-6-local_12.6.2-1_amd64.deb
sudo gdebi -n cuda-repo-wsl-ubuntu-12-6-local_12.6.2-1_amd64.deb
sudo cp /var/cuda-repo-wsl-ubuntu-12-6-local/cuda-*-keyring.gpg /usr/share/keyrings/
sudo apt-get update
sudo apt-get -y install cuda-toolkit-12-6
# https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
sudo apt-get update
sudo apt-get install -y nvidia-container-toolkit
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
# https://nvidia.github.io/TensorRT-LLM/installation/linux.html
# Install dependencies, TensorRT-LLM requires Python 3.10
sudo apt-get update && \
      sudo apt-get -y install python3.10 python3.10-venv python3.10-dev openmpi-bin libopenmpi-dev git git-lfs

python3.10 -m venv /home/ubuntu/venv3.10
source /home/ubuntu/venv3.10/bin/activate
pip install -U pip setuptools wheel setuptools-rust

# Install the latest preview version (corresponding to the main branch) of TensorRT-LLM.
# If you want to install the stable version (corresponding to the release branch), please
# remove the `--pre` option.
pip install tensorrt_llm -U --pre --extra-index-url https://pypi.nvidia.com

# Check installation
python3 -c "import tensorrt_llm"
