add contrib + non-free srcs
```
vi /etc/apt/sources.list.d/base.list
```

install build dependencies for zfs
```
apt-get update
apt-get install -y build-essential autoconf libtool gawk alien fakeroot
apt-get install -y zlib1g-dev uuid-dev libattr1-dev libblkid-dev libselinux-dev libudev-dev
apt-get install -y parted lsscsi ksh libssl-dev libelf-dev
apt-get install -y linux-headers-$(uname -r)
apt-get install -y git gdebi python3-dev python3-setuptools
```

clone & build zfs
```
git clone https://github.com/zfsonlinux/zfs
cd zfs/
sh autogen.sh
./configure --with-config=user
make pkg-utils deb-dkms
```

install zfs
```
for file in *.deb; do gdebi -q --non-interactive $file; done
```