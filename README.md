# bash-scripts

## Contents

    In this repository I store bash scripts that I develop, useful or time-saving for me

- new_system.sh:

    1. useful and time-saving when starting new linux install

    2. updates system system, and install many useful packages for me

- install_flutter.sh

    1. install flutter, and android-studio, and configure some system things

- extra_things.sh

    1. Install nordvpn app.

## How to use

Run:

```bash
chmod +x <script_name>.sh
./<script_name>.sh
```

## Extra info ([source](https://askubuntu.com/questions/343268/how-to-use-manual-partitioning-during-installation/343352#343352))

When sideloading ubuntu with windows previously installed, select manually by using "Something else" option.

- swap
  - type: primary
  - beginning of space
  - use as: swap area
- / (root)
  - type: logical
  - location: beginning of space
  - use as: ext4
  - mount point: /
  - size: (10 - 20gb) (20480mb) [if installing cuda in a nvidia machine make it 35gb or 35840mb]
- /home
  - 4 first options same as / (root)
  - choose your home size accordingly (all free space in hard drive)
- device for boot loader being main drive (if there is windows, choose the same one)

## Useful commands

- [manual config brightness keys](https://askubuntu.com/questions/798203/changing-screen-brightness-through-keyboard-functions-on-my-notebook)

```bash
ssh-keygen -t ed25519 -C "<example@email.com>"
```

- [create bootable liveimage using hdd partition instead of usb](https://askubuntu.com/questions/1156490/make-a-hdd-partition-work-like-usb-bootable-in-ubuntu)

- [fix slow boot by defining suspend/hibernate SWAP UUID](https://askubuntu.com/questions/1240123/how-to-enable-the-hibernate-option-in-ubuntu-20-04)

- [move spotify to system tray](https://www.maketecheasier.com/minimize-spotify-to-system-tray-linux/)

- [change ubuntu actions for sleep (supend/hibernate) on lid close, etc](https://ubuntuhandbook.org/index.php/2020/05/lid-close-behavior-ubuntu-20-04/)

- [fix acer predator fan](https://github.com/JafarAkhondali/acer-predator-turbo-and-rgb-keyboard-linux-module)

- ```bash
  # scan local network
  sudo nmap -sn 192.168.18.0/24
  # for simple ip up scan, faster
  sudo nmap -sn -n -host-timeout 1 192.168.18.0/24
  ```

- ````bash
  # generate a random password
  pwgen -s 50 -c -n -y | tr -d ")(}{][\!\"#$%'.\\\/\`><"
  ```

- ```bash
  # All commits started from the next after 8fd7b22 will be rebased with no changes except signing
  git rebase --exec 'git commit --amend --no-edit -n -S' -i 8fd7b22
  # To change all commits started from the very first one you may use --root
  git rebase --exec 'git commit --amend --no-edit -n -S' -i --root
  #Return commit date as author date and force push (don't forget to backup before).
  git rebase --committer-date-is-author-date -i --root # return 
  git push --force
  ```
  -> [source](https://stackoverflow.com/questions/41882919/is-there-a-way-to-gpg-sign-all-previous-commits)

- ```bash
  echo "Host personal\nHostname github.com\nIdentityFile /home/ubuntu/.ssh/rasp_2023_08_27\nIdentitiesOnly yes" >> ~/.ssh/config
  git remote rm origin
  # swap username and repository accordignly
  git remote add origin git@personal:username/repository.git
  ```

  -> [source](https://www.howtogeek.com/devops/how-to-switch-a-github-repository-to-ssh-authentication/)

- ```bash
  # set chrome as default browser inside snaps
  xdg-mime default google-chrome.desktop x-scheme-handler/http
  xdg-mime default google-chrome.desktop x-scheme-handler/https

  gio mime x-scheme-handler/https google-chrome.desktop
  gio mime x-scheme-handler/http google-chrome.desktop
  ```

  -> [source](https://forum.obsidian.md/t/obsidian-doesnt-use-default-browser-on-ubuntu-22-04/68177/5)

- ```bash
  # set other terminal as default
  sudo update-alternatives --config x-terminal-emulator
  ```

  -> [source](https://devicetests.com/change-terminal-tilix-shortcut-ubuntu)

- ```bash
  # concat all images in current folder to a PDF
  convert *.jpg -quality 20 file20.pdf

  # before running that, make sure to disable conflicting policy
  sudo mv /etc/ImageMagick-6/policy.xml /etc/ImageMagick-6/policy.xml.off

  # when done, restore policy by running
  sudo mv /etc/ImageMagick-6/policy.xml.off /etc/ImageMagick-6/policy.xml
  ```

  -> [source](https://stackoverflow.com/a/57721936)

  ```bash
  for KEY in $(apt-key --keyring /etc/apt/trusted.gpg list | grep -E "(([ ]{1,2}(([0-9A-F]{4}))){10})" | tr -d " " | grep -E "([0-9A-F]){8}\b" ); do K=${KEY:(-8)}; apt-key export $K | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/imported-from-trusted-gpg-$K.gpg; done
  ```
  
  -> [source](https://askubuntu.com/a/1415702)

  ```bash
  # remove an app and its data
  flatpak uninstall --delete-data <app_name>

  # remove all unused apps and their data
  flatpak uninstall --unused --delete-data

  # run an update just for the ifs
  sudo flatpak update
  ```

  -> [source](https://forums.linuxmint.com/viewtopic.php?t=395080)

-> config bashrc to show only currrent directory instead of full relative path to home [source](https://askubuntu.com/a/232101)

-> change vs code to LF instead of CRLF [source](https://stackoverflow.com/a/48694365)

-> fix slack screenshare on wayland [source](https://github.com/flathub/com.slack.Slack/issues/101#issuecomment-1807073763)

-> fix slack screenshare on wayland debian package [source](https://github.com/flathub/com.slack.Slack/issues/101#issuecomment-1808323806)

-> CopyQ Not Saving Clipboard Copy Paste in Ubuntu 23.04 [source](https://itsfoss.community/t/copyq-not-saving-clipboard-copy-paste-in-ubuntu-23-04/10829/3)

-> 2024-04-17, fix to google-chrome on ubuntu, stopped working on wayaland [source](https://www.reddit.com/r/linux/comments/1c63fgz/latest_update_of_chrome_on_wayland/)

## Gnome must have shell extensions

- https://github.com/GnomeSnapExtensions/gSnap
- https://github.com/SUPERCILEX/gnome-clipboard-history
- https://github.com/mgalgs/gnome-shell-system-monitor-applet

# ARCH

## Installation Boot

```bash
# set keyboard layout
loadkeys br-abnt

# check UEFI
cat /sys/firmware/efi/fw_platform_size

# Connect to the internet
iwctl

# inside iwctl
device list
station wlan0 scan
station wlan0 get-networks
station wlan0 connect <SSID>
station wlan0 show
exit
# outside of iwctl

ip link

# list disks
lsblk

# format the drive
sudo fdisk /dev/nvme0n1

# inside it type 'p' to print partitions
# ('d' to delete, 'g' to create GPT, 'n' to create, 'w' to write changes)
# then start disk fresh with 'g'
# then create partitions

# 1. 1GB for EFI
# 2. 1GB for Boot
# 3. Rest for LVM

# 1. by typing
# 'n'
# enter
# enter
# +1G

# then type 't' to change type
# 'uefi'

# 2. by typing  
# 'n'
# enter
# enter
# +1G

# then type 't' to change type
# 'linux'

# 3. by typing
# 'n'
# enter
# enter
# enter

# then type 't' to change type
# 'linux'

# 'p' to print all partitions
# 'w' to write changes

# format partitions
mkfs.fat -F 32 /dev/nvme0n1p1
mkfs.ext4 /dev/nvme0n1p2

# Set up the encrypted partition.
cryptsetup --use-random luksFormat /dev/nvme0n1p3
cryptsetup luksOpen /dev/nvme0n1p3 cryptlvm

# Create Volume Group
pvcreate /dev/mapper/cryptlvm
vgcreate vg0 /dev/mapper/cryptlvm

# Create Logical Volumes
lvcreate --size 150G vg0 --name root
lvcreate -l +100%FREE vg0 --name home
lvreduce --size -256M vg0/home

# Format Logical Volumes
mkfs.ext4 /dev/vg0/root
mkfs.ext4 /dev/vg0/home

# Mount new filesystems
mount /dev/vg0/root /mnt
mount --mkdir /dev/nvme0n1p1 /mnt/efi
mount --mkdir /dev/nvme0n1p2 /mnt/boot
mount --mkdir /dev/vg0/home /mnt/home

# Install base system
pacstrap -K /mnt base linux linux-firmware openssh git vim sudo

# Generate fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Chroot into the new system
arch-chroot /mnt /bin/bash

# See available timezones
ls /usr/share/zoneinfo/

# Set the timezone
ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

# Set the hardware clock
hwclock --systohc

# Set the hostname
echo hostname > /etc/hostname

# Create a user
useradd -m -G wheel --shell /bin/bash username
passwd username
visudo
# ---> Uncomment '%wheel ALL=(ALL) ALL'

# configure mkinitcpio
pacman -S lvm2
vim /etc/mkinitcpio.conf
# ---> Add 'encrypt' and 'lvm2' to HOOKS before 'filesystems'

# Regenerate the initramfs
mkinitcpio -P

# Setup GRUB
pacman -S grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB

vim /etc/default/grub
# edit the line GRUB_CMDLINE_LINUX
# GRUB_CMDLINE_LINUX="cryptdevice=/dev/nvme0n1p3:cryptlvm root=/dev/vg0/root"

grub-mkconfig -o /boot/grub/grub.cfg

# Install network manager
pacman -S networkmanager
systemctl enable NetworkManager

# Exit new system
exit
umount -R /mnt

# Arch Linux is now installed. Reboot the system.
reboot

# After rebooting, login as the user you created
# connect to the internet
nmcli device wifi connect <SSID> password <password>

# check internet connectivity
ping google.com

# Install gnome desktop
sudo pacman -S gnome gdm gnome-tweaks gnome-shell-extensions
# ALL
# default font
# pipewire
# y

# Enable GDM
sudo systemctl enable gdm
```
