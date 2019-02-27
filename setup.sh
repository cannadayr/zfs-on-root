# add contrib + non-free srcs
echo "deb http://deb.debian.org/debian/ stretch main contrib non-free" > /etc/apt/sources.list.d/base.list
echo "deb-src http://deb.debian.org/debian/ stretch main contrib non-free" >> /etc/apt/sources.list.d/base.list

# install build dependencies for zfs
apt-get update
apt-get install -y build-essential autoconf libtool gawk alien fakeroot
apt-get install -y zlib1g-dev uuid-dev libattr1-dev libblkid-dev libselinux-dev libudev-dev
apt-get install -y parted lsscsi ksh libssl-dev libelf-dev
apt-get install -y linux-headers-$(uname -r)
apt-get install -y git gdebi python3-dev python3-setuptools python3-cffi cryptsetup

# clone & build zfs
git clone https://github.com/zfsonlinux/zfs
cd zfs/
sh autogen.sh
./configure --with-config=user
make pkg-utils deb-dkms

# install zfs
for file in *.deb; do gdebi -q --non-interactive $file; done
modprobe zfs

partition ssd
```
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: dos
Disk identifier: 0xe6719167

Device     Boot    Start       End   Sectors  Size Id Type
/dev/sda1           2048   1050623   1048576  512M  c W95 FAT32 (LBA)
/dev/sda2        1050624  34605055  33554432   16G 82 Linux swap / Solaris
/dev/sda3       34605056 500118191 465513136  222G bf Solaris
```

encrypt swap
```
cryptsetup -y -v luksFormat /dev/sda2
cryptsetup luksOpen /dev/disk/by-id/wwn-[SDA_ID]-part2 luks-swap 
mkswap -f /dev/mapper/luks-swap
```
