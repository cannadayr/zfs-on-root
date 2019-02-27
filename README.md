add contrib + non-free srcs
```
vi /etc/apt/sources.list.d/base.list
```

install build dependencies for zfs
```
apt-get update
apt-get install build-essential autoconf libtool gawk alien fakeroot git
apt-get install zlib1g-dev uuid-dev libattr1-dev libblkid-dev libselinux-dev libudev-dev
apt-get install parted lsscsi ksh libssl-dev libelf-dev
apt-get install linux-headers-$(uname -r)
```

clone & build zfs
```
git clone https://github.com/zfsonlinux/zfs
```
