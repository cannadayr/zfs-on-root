# install OS
debootstrap stretch /mnt/

# configure os
cp /etc/apt/sources.list.d/base.list /mnt/etc/apt/sources.list

# mount pseudo filesystems & chroot into it
# install zfs build dependencies
# install locale
# dpkg-reconfigure locale
# build + install zfs
# install bootloader
# exit
# umount
# reboot
