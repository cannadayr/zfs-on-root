# partition ssd
wwn=$(ls -1 /dev/disk/by-id/wwn-* | grep -v "\-part[0-9]$")

# clean partition table
sgdisk --zap-all $wwn
sgdisk --zap-all $wwn

# write 512 bits to beginning of disk in case theres an existing MBR
dd if=/dev/zero of=$wwn bs=512 count=1

# partition disk
sfdisk /dev/sda <<EOF
label: dos
label-id: 0x71ca4d59
device: /dev/sda
unit: sectors

/dev/sda1 : start=        2048, size=     1048576, type=c, bootable
/dev/sda2 : start=     1050624, size=    33554432, type=82
/dev/sda3 : start=    34605056, size=   465513136, type=bf
EOF

# create zfs partitions
#TODO add encryption
zpool create -O canmount=off -O mountpoint=/ -R /mnt/ rpool $wwn-part3
zfs create -o canmount=off -o mountpoint=none rpool/ROOT
zfs create -o canmount=noauto -o mountpoint=/ rpool/ROOT/debian
zfs mount rpool/ROOT/debian
zpool set bootfs=rpool/ROOT/debian rpool

# encrypt swap #TODO add back in
#cryptsetup -y -v luksFormat /dev/sda2
#cryptsetup luksOpen /dev/disk/by-id/wwn-[SDA_ID]-part2 luks-swap 
#mkswap -f /dev/mapper/luks-swap
