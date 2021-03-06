wwn=$(ls -1 /dev/disk/by-id/wwn-* | grep -v "\-part[0-9]$")

# install OS
debootstrap stretch /mnt/
test "$?" != 0 && exit 1

exit
# configure os
echo "deb http://deb.debian.org/debian/ stretch main contrib non-free" > /mnt/etc/apt/sources.list
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
passwd

#apt-get install -y debootstrap gdisk dpkg-dev linux-headers-$(uname -r)
#apt-get install -y zfs-dkms
apt-get install -y --no-install-recommends linux-image-$(uname -r)
apt-get install -y zfs-initramfs

#apt-get install -y build-essential autoconf libtool gawk alien fakeroot \
#  zlib1g-dev uuid-dev libattr1-dev libblkid-dev libselinux-dev libudev-dev \
#  parted lsscsi ksh libssl-dev libelf-dev linux-headers-$(uname -r) \
#  git gdebi-core python3-dev python3-setuptools python3-cffi cryptsetup \
#  firmware-iwlwifi dkms linux-image-$(uname -r)

#git clone --depth=1 https://github.com/zfsonlinux/zfs
#cd zfs/
#sh autogen.sh
#./configure --with-config=user
#make pkg-utils deb-dkms

# install zfs
#for file in *.deb; do gdebi -q --non-interactive $file; done

apt-get install -y grub-pc

update-initramfs -u -k all
update-grub
grub-install $wwn

#UUID=[UUID] /boot vfat defaults 0 1
#$wwn-part3 / zfs defaults 0 0

#zfs snapshot rpool/ROOT/debian@install

# install bootloader
# exit
# umount
# reboot
