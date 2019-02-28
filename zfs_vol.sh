# create zfs partitions
wwn=$(ls -1 /dev/disk/by-id/wwn-* | grep -v "\-part[0-9]$")

#TODO add encryption
zpool create -O canmount=off -O mountpoint=/ -R /mnt/ rpool $wwn-part3
zfs create -o canmount=off -o mountpoint=none rpool/ROOT
zfs create -o canmount=noauto -o mountpoint=/ rpool/ROOT/debian
zpool set bootfs=rpool/ROOT/debian rpool

# mount stuff
zfs mount rpool/ROOT/debian
mkdir /mnt/boot
mkfs.vfat $wwn-part1
mount $wwn-part1 /mnt/boot

# encrypt swap #TODO add back in
#cryptsetup -y -v luksFormat /dev/sda2
#cryptsetup luksOpen /dev/disk/by-id/wwn-[SDA_ID]-part2 luks-swap 
#mkswap -f /dev/mapper/luks-swap
