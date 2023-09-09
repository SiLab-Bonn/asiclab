To check Cadence config:

```
/tools/cadence/2022-23/RHELx86/IC_6.1.8.320/tools.lnx86/bin/checkSysConf IC6.1.8
```

The current version of my redhat/centOS distribution can be checked via:

```
cat /etc/redhat-release
```


# EL8

sudo dnf install epel-release
sudo dnf install elrepo-release
sudo dnf update
sudo dnf install -y csh tcsh glibc elfutils-libelf ksh mesa-libGL mesa-libGLU motif libXp libpng libjpeg-turbo expat glibc-devel gdb libXScrnSaver xorg-x11-fonts-misc xorg-x11-fonts-ISO8859-1-75dpi apr apr-util xorg-x11-server-Xvfb mesa-dri-drivers openssl-devel redhat-lsb

> Note, redhat-lsb is added relative to the EL9, in the section above

Unmapped this file:
ls -la redhat-release 
lrwxrwxrwx. 1 root root 17 May 16 15:34 redhat-release -> almalinux-release
And put inside it:
`Red Hat Enterprise Linux Server release 7.9 (Maipo)`


`yum provides '*/libdb-4.7.so'`

https://forums.rockylinux.org/t/compat-db47-numpy-and-python-matplotlib-not-in-rocky-linux-8-6-
repo/6899/16

https://copr.fedorainfracloud.org/coprs/mlampe/compat-db47/

`sudo dnf copr enable mlampe/compat-db47`

`sudo dnf install compat-db47`


`yum provides '*/libcrypto.so.10'`

compat-openssl10-1:1.0.2o-4.el8_6.i686 : Compatibility version of the OpenSSL library
Repo        : appstream
Matched from:
Filename    : /usr/lib/libcrypto.so.10

compat-openssl10-1:1.0.2o-4.el8_6.x86_64 : Compatibility version of the OpenSSL library
Repo        : appstream
Matched from:
Filename    : /usr/lib64/libcrypto.so.10


sudo dnf install compat-openssl10-1:1.0.2o-4.el8_6.x86_64



`yum provides '*/libnsl.so.1'`

libnsl-2.28-225.el8.i686 : Legacy support library for NIS
Repo        : baseos
Matched from:
Filename    : /lib/libnsl.so.1

libnsl-2.28-225.el8.x86_64 : Legacy support library for NIS
Repo        : baseos
Matched from:
Filename    : /lib64/libnsl.so.1

*Virtuoso works now!*

# now the thinned list for TCAD:

sudo yum install ksh perl perl-core tcsh strace valgrind gdb bc xorg-x11-server-Xvfb gcc glibc-devel bzip2 ncompress



# --------------------- EL9 ----------------------

sudo dnf install epel-release
sudo dnf install elrepo-release
sudo dnf update
sudo dnf install -y csh tcsh glibc elfutils-libelf ksh mesa-libGL mesa-libGLU motif libXp libpng libjpeg-turbo expat glibc-devel gdb libXScrnSaver xorg-x11-fonts-misc xorg-x11-fonts-ISO8859-1-75dpi apr apr-util xorg-x11-server-Xvfb mesa-dri-drivers openssl-devel

yum provides '*/libnsl.so.1'
Last metadata expiration check: 0:11:02 ago on Sat 09 Sep 2023 02:23:52 PM CEST.
libnsl-2.34-60.el9.i686 : Legacy support library for NIS
Repo        : baseos
Matched from:
Filename    : /lib/libnsl.so.1

libnsl-2.34-60.el9.x86_64 : Legacy support library for NIS
Repo        : baseos
Matched from:
Filename    : /lib64/libnsl.so.1

sudo dnf install libnsl-2.34-60.el9.x86_64


When trying to get this same compat-db47 from above:

```
Repository 'epel-9-x86_64' does not exist in project 'mlampe/compat-db47'.
Available repositories: 'epel-8-x86_64'

If you want to enable a non-default repository, use the following command:
  'dnf copr enable mlampe/compat-db47 <repository>'
But note that the installed repo file will likely need a manual modification.
[asiclab@asiclab003 kcaisley]$ sudo dnf copr enable mlampe/compat-db47 epel-8-x86_64
```


lsb_release doesn't seem to exist on RHEL9: https://www.reddit.com/r/RockyLinux/comments/wjlh0s/need_to_install_redhatlsbcore_on_rocky_linux_9/. Except, at the bottom someone says it's now in the AlmaLinux Devel repo:

https://almalinux.pkgs.org/9/almalinux-devel-x86_64/redhat-lsb-core-4.1-56.el9.x86_64.rpm.html

`sudo dnf config-manager --add-repo https://repo.almalinux.org/almalinux/9/devel/almalinux-devel.repo`

dnf --enablerepo=devel install redhat-lsb-core

Then make sure that devel is disabled with `sudo dnf config-manager --set-disabled devel`
and then `dnf repolist`, shouldn't show devel


libcrypto.so.10 doesn't also exist. Manually downloaded and installed the version from EL8: https://almalinux.pkgs.org/8/almalinux-appstream-x86_64/compat-openssl10-1.0.2o-4.el8_6.x86_64.rpm.html

```
yum provides '*/libnsl.so.1'
Last metadata expiration check: 0:11:02 ago on Sat 09 Sep 2023 02:23:52 PM CEST.
libnsl-2.34-60.el9.i686 : Legacy support library for NIS
Repo        : baseos
Matched from:
Filename    : /lib/libnsl.so.1

libnsl-2.34-60.el9.x86_64 : Legacy support library for NIS
Repo        : baseos
Matched from:
Filename    : /lib64/libnsl.so.1

sudo dnf install libnsl-2.34-60.el9.x86_64
```


Based on this link, learned I have /lib64/libdl.so.2 but Virtuoso is looking for /lib64/libdl.so. So just created a symlink:

sudo ln -s /lib64/libdl.so.2 /lib64/libdl.so

## now the thinned list for TCAD:

sudo yum install ksh perl perl-core tcsh strace valgrind gdb bc xorg-x11-server-Xvfb gcc glibc-devel bzip2 ncompress


# 




