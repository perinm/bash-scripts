all commands are meant to be ran on windows

'''bash
GET-CimInstance -query "SELECT * from Win32_DiskDrive"
wsl.exe --unmount \\.\PHYSICALDRIVE1
wsl --mount \\.\PHYSICALDRIVE1 --bare

diskpart
list disk
list partition

select disk 1
select partition 1

convert gpt
format fs=ntfs
format fs=ntfs label=myData quick

attributes disk clear readonly
'''

'''bash
fdisk -l
mount -t ext4 /dev/sde
mount /dev/sde /mnt/old_ssd
'''