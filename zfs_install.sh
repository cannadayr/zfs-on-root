# add contrib + non-free srcs
echo "deb http://deb.debian.org/debian/ stretch main contrib non-free" > /etc/apt/sources.list.d/base.list
echo "deb-src http://deb.debian.org/debian/ stretch main contrib non-free" >> /etc/apt/sources.list.d/base.list

# install build dependencies for zfs
apt-get update
apt-get install -y build-essential autoconf libtool gawk alien fakeroot \
  zlib1g-dev uuid-dev libattr1-dev libblkid-dev libselinux-dev libudev-dev \
  parted lsscsi ksh libssl-dev libelf-dev linux-headers-$(uname -r) \
  git gdebi python3-dev python3-setuptools python3-cffi cryptsetup debootstrap

# clone & build zfs
git clone --depth=1 https://github.com/zfsonlinux/zfs
cd zfs/
sh autogen.sh
./configure --with-config=user
make pkg-utils deb-dkms

# install zfs
for file in *.deb; do gdebi -q --non-interactive $file; done
modprobe zfs
