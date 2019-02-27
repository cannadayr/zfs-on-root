# partition ssd
wwn=$(ls -1 /dev/disk/by-id/wwn-* | grep -v "\-part[0-9]$")

# create FAT32 boot partition (run twice to make sure its ded)
sgdisk --zap-all $wwn
sgdisk --zap-all $wwn

sfdisk /dev/sda <<EOF
Disk /dev/sda: 238.5 GiB, 256060514304 bytes, 500118192 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: dos
Disk identifier: 0x4d2465be

Device     Boot    Start       End   Sectors  Size Id Type
/dev/sda1           2048   1050623   1048576  512M  c W95 FAT32 (LBA)
/dev/sda2        1050624  34605055  33554432   16G 82 Linux swap / Solaris
/dev/sda3       34605056 500118191 465513136  222G bf Solaris
EOF

# create zfs partitions
zpool create -O canmount=off -O mountpoint=/ -R /mnt/ rpool $wwn-part1
zfs create -o canmount=off -o mountpoint=none rpool/ROOT
zfs create -o canmount=noauto -o mountpoint=/ rpool/ROOT/debian
zfs mount rpool/ROOT/debian
zpool set bootfs=rpool/ROOT/debian rpool

# encrypt swap #TODO add back in
#cryptsetup -y -v luksFormat /dev/sda2
#cryptsetup luksOpen /dev/disk/by-id/wwn-[SDA_ID]-part2 luks-swap 
#mkswap -f /dev/mapper/luks-swap

# add zfs pool + partition
#TODO add native encryption
#zpool create -O mountpoint=/ -R /mnt rpool /dev/disk/by-id/wwn-[ID]-part3
#zfs create -o mountpoint=none rpool/ROOT
#zfs create -o mountpoint=/ rpool/ROOT/debian
#zpool set bootfs=rpool/ROOT/debian rpool
