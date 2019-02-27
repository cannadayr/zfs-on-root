add contrib + non-free srcs
```
vi /etc/apt/sources.list.d/base.list
```

install build dependencies for zfs
```
apt-get update
apt-get build-deps zfs-dkms
apt-get install git
```

clone & build zfs
```
git clone https://github.com/zfsonlinux/zfs
```
