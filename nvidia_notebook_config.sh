# # Frist try - black screen blinking
# sudo apt install nvidia-driver-460
# sudo reboot

# # Second try - boot, work good
# # but nvidia-smi doesn't work 
# # and second-screen doesnt
# wget https://us.download.nvidia.com/XFree86/Linux-x86_64/470.63.01/NVIDIA-Linux-x86_64-470.63.01.run -O nvidia-linux.run
# sudo chmod +x nvidia-linux.run
# sudo sh nvidia-linux.run
# # perhaps after deactiving nouveau
# sudo bash -c "echo blacklist nouveau > /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
# sudo bash -c "echo options nouveau modeset=0 >> /etc/modprobe.d/blacklist-nvidia-nouveau.conf"

# # Thrid try - black screen blinking, but works if remove nouveau, but nvidia-smi doesn't
# # perhaps installing cude solves it
# sudo ubuntu-drivers autoinstall
# sudo bash -c "echo blacklist nouveau > /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
# sudo bash -c "echo options nouveau modeset=0 >> /etc/modprobe.d/blacklist-nvidia-nouveau.conf"

sudo apt-get remove --purge '^nvidia-.*'
sudo apt-get install nvidia-driver-550 nvidia-dkms-550