# ARCH

## Installation Boot - UEFI

- unified flow for the latest official Arch ISO, with GNOME, GDM, and automatic login
- `fresh disk + encrypted`
- `fresh disk + unencrypted`
- `dual boot with Windows + unencrypted`
- this guide assumes UEFI mode and Secure Boot disabled during installation
- if you want Secure Boot later, set it up after Arch is installed
- replace `<cpu_microcode>` with `intel-ucode` on Intel or `amd-ucode` on AMD
- replace all disk and partition placeholders with your real devices
- the encrypted path is based on [this gist](https://gist.github.com/mjnaderi/28264ce68f87f52f2cabb823a503e673), credits to [mjnaderi](https://gist.github.com/mjnaderi)

Choose one of those three paths before you start partitioning.

### 1. Boot, keyboard, network, and disk check

Boot the latest official Arch ISO, then set your keyboard, confirm UEFI mode, connect to the network, and inspect the current disks.

```bash
loadkeys br-abnt
cat /sys/firmware/efi/fw_platform_size
iwctl
```

Inside `iwctl`, use your real wireless device name instead of `<wireless_device>`.

```bash
device list
station <wireless_device> scan
station <wireless_device> get-networks
station <wireless_device> connect <SSID>
station <wireless_device> show
exit
```

Back in the shell, verify connectivity, time sync, and disk layout.

```bash
ip link
ping -c 3 ping.archlinux.org
timedatectl
fdisk -l
lsblk -o NAME,SIZE,FSTYPE,TYPE,MOUNTPOINTS
```

### 2. Choose your path

`fresh disk + encrypted`

- wipes the target disk
- creates an EFI partition, a separate `/boot`, and an encrypted LUKS + LVM setup

`fresh disk + unencrypted`

- wipes the target disk
- creates an EFI partition and a root partition

`dual boot with Windows + unencrypted`

- keeps the existing Windows install
- shrink Windows first from Windows Disk Management
- reuse the existing EFI System Partition
- do not create a new GPT table
- do not format the existing EFI System Partition

### 3. Partition the disk

#### Fresh Disk + Encrypted

Use `fdisk` on the target disk, for example `/dev/nvme0n1`.

- press `g` to create a new GPT table
- create partition 1 as `+1G` for EFI
- change partition 1 type to `EFI System`
- create partition 2 as `+1G` for `/boot`
- create partition 3 using the remaining space for LUKS/LVM
- press `p` to review the layout
- press `w` to write changes

```bash
fdisk /dev/<target_disk>
```

#### Fresh Disk + Unencrypted

Use `fdisk` on the target disk, for example `/dev/nvme0n1`.

- press `g` to create a new GPT table
- create partition 1 as `+1G` for EFI
- change partition 1 type to `EFI System`
- create partition 2 using the remaining space for `/`
- press `p` to review the layout
- press `w` to write changes

```bash
fdisk /dev/<target_disk>
```

#### Dual Boot With Windows + Unencrypted

Use `fdisk` on the Windows disk, but only create the new Linux partition in the free space.

- do not press `g`
- press `p` first and confirm the current Windows layout
- `<windows_disk>` such as `/dev/nvme0n1`
- `<existing_esp_partition>` such as `/dev/nvme0n1p1`
- `<windows_partition>` such as `/dev/nvme0n1p3`
- create one new Linux partition in the unallocated space
- accept the default first sector
- accept the default last sector to use the remaining free space, or set a custom size such as `+150G`
- press `w` to write changes

```bash
fdisk <windows_disk>
lsblk -o NAME,SIZE,FSTYPE,TYPE,MOUNTPOINTS
```

### 4. Format and mount

#### Fresh Disk + Encrypted

Format the EFI and `/boot` partitions, then create the encrypted LVM layout.

```bash
mkfs.fat -F 32 /dev/<efi_partition>
mkfs.ext4 /dev/<boot_partition>
cryptsetup --use-random luksFormat /dev/<luks_partition>
cryptsetup luksOpen /dev/<luks_partition> cryptlvm
pvcreate /dev/mapper/cryptlvm
vgcreate vg0 /dev/mapper/cryptlvm
lvcreate --size 150G vg0 --name root
lvcreate -l +100%FREE vg0 --name home
lvreduce --size -256M vg0/home
mkfs.ext4 /dev/vg0/root
mkfs.ext4 /dev/vg0/home
mount /dev/vg0/root /mnt
mount --mkdir /dev/<efi_partition> /mnt/efi
mount --mkdir /dev/<boot_partition> /mnt/boot
mount --mkdir /dev/vg0/home /mnt/home
```

#### Fresh Disk + Unencrypted

Format the EFI and root partitions, then mount them.

```bash
mkfs.fat -F 32 /dev/<efi_partition>
mkfs.ext4 /dev/<root_partition>
mount /dev/<root_partition> /mnt
mount --mkdir /dev/<efi_partition> /mnt/boot
```

#### Dual Boot With Windows + Unencrypted

Format only the new Linux partition. Reuse the existing Windows EFI partition without formatting it.

```bash
mkfs.ext4 /dev/<new_linux_root_partition>
mount /dev/<new_linux_root_partition> /mnt
mount --mkdir /dev/<existing_esp_partition> /mnt/boot
```

### 5. Install packages

Install the common packages first.

```bash
pacstrap -K /mnt base linux linux-firmware sof-firmware <cpu_microcode> grub efibootmgr networkmanager gnome gnome-tweaks gnome-shell-extensions sudo vim man-db man-pages texinfo
```

When prompted for the `gnome` package group, press `Enter` to install all.

If you chose the encrypted path, also install `lvm2`.

```bash
pacstrap -K /mnt lvm2
```

If you chose the Windows dual-boot path, also install the Windows detection helpers.

```bash
pacstrap -K /mnt os-prober ntfs-3g fuse3
```

Generate `fstab`, review it, and chroot into the new system.

```bash
genfstab -U /mnt >> /mnt/etc/fstab
vim /mnt/etc/fstab
arch-chroot /mnt /bin/bash
```

### 6. Configure the base system

Set the timezone and hardware clock.

```bash
ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
hwclock --systohc
```

Set locales and keyboard layout.

- uncomment `en_US.UTF-8 UTF-8`
- uncomment `pt_BR.UTF-8 UTF-8`

```bash
vim /etc/locale.gen
locale-gen
echo 'LANG=en_US.UTF-8' > /etc/locale.conf
echo 'KEYMAP=br-abnt' > /etc/vconsole.conf
```

Set the hostname and hosts file.

```bash
echo myhostname > /etc/hostname
cat > /etc/hosts <<'EOF'
127.0.0.1 localhost
::1 localhost
127.0.1.1 myhostname.localdomain myhostname
EOF
```

Set the root password, create your user, and allow `sudo` for `wheel`.

```bash
passwd
useradd -m -G wheel --shell /bin/bash username
passwd username
EDITOR=vim visudo
```

Inside `visudo`, uncomment:

```text
%wheel ALL=(ALL:ALL) ALL
```

### 7. Encryption-only setup

Skip this step if you did not choose the encrypted path.

Edit `mkinitcpio.conf` and add `encrypt` and `lvm2` to `HOOKS` before `filesystems`, then rebuild the initramfs.

```bash
vim /etc/mkinitcpio.conf
mkinitcpio -P
```

### 8. Install and configure GRUB

#### Fresh Disk + Encrypted

Install GRUB to the EFI partition mounted at `/efi`, then set the encrypted root kernel parameters.

Set `GRUB_CMDLINE_LINUX` to:

```text
cryptdevice=/dev/<luks_partition>:cryptlvm root=/dev/vg0/root
```

```bash
grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB
vim /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg
```

#### Fresh Disk + Unencrypted

Install GRUB to the EFI partition mounted at `/boot`.

```bash
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
```

#### Dual Boot With Windows + Unencrypted

Install GRUB to the existing EFI partition mounted at `/boot`.

Add or uncomment this line in `/etc/default/grub` before generating the config:

```text
GRUB_DISABLE_OS_PROBER=false
```

```bash
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
vim /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg
```

### 9. Enable services and configure automatic login

Enable networking, time sync, and GDM.

```bash
systemctl enable NetworkManager
systemctl enable systemd-timesyncd
systemctl enable gdm
```

Edit `/etc/gdm/custom.conf` and under `[daemon]` set:

```text
AutomaticLogin=username
AutomaticLoginEnable=True
```

```bash
vim /etc/gdm/custom.conf
```

If GNOME on Wayland gives you GPU problems, you can force Xorg for this user.

```bash
mkdir -p /var/lib/AccountsService/users
cat > /var/lib/AccountsService/users/username <<'EOF'
[User]
XSession=gnome-xorg
EOF
```

### 10. Finish the installation

Exit the chroot, unmount everything, and reboot.

```bash
exit
umount -R /mnt
reboot
```

### 11. Dual-boot-only check after first boot

Skip this step unless you chose the Windows dual-boot path.

If Windows does not appear in GRUB after the first boot into Arch, run:

```bash
sudo os-prober
sudo grub-mkconfig -o /boot/grub/grub.cfg
```
