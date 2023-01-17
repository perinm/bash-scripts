wget -O ~/driver_ac_9260.tgz https://wireless.wiki.kernel.org/_media/en/users/drivers/iwlwifi-9260-th-b0-jf-b0-34.618819.0.tgz
tar zxvf ~/driver_ac_9260.tgz
sudo cp "iwlwifi-9260-th-b0-jf-b0-34.618819/"*".ucode" /lib/firmware
sudo apt update && sudo apt install -y dkms git build-essential linux-headers-$(uname -r)
git clone https://github.com/ocerman/zenpower.git
cd zenpower
sudo make dkms-install
lsmod | grep k10temp
sudo modprobe -r k10temp
sudo bash -c 'sudo echo -e "\n# replaced with zenpower\nblacklist k10temp" >> /etc/modprobe.d/blacklist.conf'
sudo modprobe zenpower