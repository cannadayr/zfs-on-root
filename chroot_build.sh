# install OS
debootstrap stretch /mnt/

# configure os
cp /etc/apt/sources.list.d/base.list /mnt/etc/apt/sources.list
echo vega > /mnt/etc/hostname
sed -i '1 s/$/ vega/' /mnt/etc/hosts

mount --rbind /dev  /mnt/dev
mount --rbind /proc /mnt/proc
mount --rbind /sys  /mnt/sys
chroot /mnt /bin/bash --login

ln -s /proc/self/mounts /etc/mtab
apt-get update
apt-get install -y locales
dpkg-reconfigure locales
dpkg-reconfigure tzdata

apt-get install -y build-essential autoconf libtool gawk alien fakeroot \
  zlib1g-dev uuid-dev libattr1-dev libblkid-dev libselinux-dev libudev-dev \
  parted lsscsi ksh libssl-dev libelf-dev linux-headers-$(uname -r) \
  git gdebi-core python3-dev python3-setuptools python3-cffi cryptsetup firmware-iwlwifi

git clone --depth=1 https://github.com/zfsonlinux/zfs
cd zfs/
sh autogen.sh
./configure --with-config=user
make pkg-utils deb-dkms

# install zfs
for file in *.deb; do gdebi -q --non-interactive $file; done

# mount pseudo filesystems & chroot into i
# install zfs build dependencies
# install locale
# dpkg-reconfigure locale
# build + install zfs
# install bootloader
# exit
# umount
# reboot
