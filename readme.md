Documentation for ASIC design, FGPA, and TCAD servers, workstations, and tools 

- `/startup_scripts`: Startups scripts for ASIC, FPAGa, and TCAD tools

- `/container_def`: Apptainer define files for building containers for running EDA tools

- `/docs`: Checklists and troubleshooting for workstations `asiclab000` - `asiclab011` and servers

# Workstation Setup for AlmaLinux 9:

This document is a checklist for setting up a Cadence Virtuoso development e



## Create bootable ISO

Download ISO file:

```
curl -O https://repo.almalinux.org/almalinux/9/isos/x86_64/AlmaLinux-9.1-x86_64-dvd.iso
```

Insert your target USB and locate it. There are different ways to do it, but here are some of them:

- `sudo fdisk -l`  - this command shows you the connected block storage devices, including the USB devices.
- `lsblk` - this command gives you all the availabzle block storage devices, including the USB block storage devices.
- `sudo blkid` - this command gives you the same information as `lsblk`, but you have to run it as root.

You need to look for /dev/sda or /dev/sdb or /dev/sdc, which is your target USB.

After you found out the location of your target USB, navigate to the location of your source ISO. Run the dd command to copy files from ISO to USB:

```text
sudo dd if=./AlmaLinux-9.1-x86_64-dvd.iso of=/dev/sdX status=progress
```

This command also works:

```
sudo sh -c 'cat ./AlmaLinux-9.2-x86_64-dvd.iso > /dev/sdb; sync'
```

## BIOS Settings:

Pres Fn + F2 to reach BIOS settings

Reset BIOS settings to default.
- General > Boot Sequence > Clear Full List, leaving only thumb drive
- General > Advanced Boot Options > Enable Legacy Options ROMs > Disabled
- System Configuration > SATA Operation > AHCI
- Power Management > Deep Sleep Control > Disabled
- Power Management > Wake on LAN/WLAN > LAN Only (
      - Only form states S4 = Hibernate and S5 = Power Off; standby and sleep on are lighter and constrolled at the OS level
      - More info on these states can be found [here](https://en.wikipedia.org/wiki/ACPI#Global_states)

Apply, exit, reboot. Then press Fn + F12 to Reach "One Time Boot Menu". Select UEFI -> USB Drive.

## Anaconda Install Menu

1. Set keyboard to English (US), add German as a secondary option.
2. *Root Password* should be "Disabled"
3. Create user `asiclab` with `uid = 1000` and `gid = 1000`. Make user an administrator.
4. *Installation source* is local media.
5. *Software Selection* should be "Server with GUI"
6. For the installation destination, select both the NVME and HDD and select 'custome' for the storage configuration. Use traditional partitioning (no LVM) and configure the disks like below. Use `ext4` for the filesystems on the `/tmp` and `/` partitions. The swap is swap, and the efi is a EFI boot partition.

    ```
    NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
    nvme0n1     259:0    0 238.5G  0 disk 
    ├─nvme0n1p1 259:1    0   600M  0 part /boot/efi
    ├─nvme0n1p2 259:2    0  1024M  0 part /boot
    ├─nvme0n1p3 259:3    0   200G  0 part /
    └─nvme0n1p4 259:4    0    32G  0 part [SWAP]
    sda           8:0    0  1.82T  0 disk 
    └─sda1        8:1    0  1.82T  0 part /tmp
    ```

7. Make sure ethernet is connected. 


## Post Install

1. Update firmware, in four commands
   ```
   sudo fwupdmgr enable-remote lvfs
   sudo fwupdmgr refresh
   sudo fwupdmgr get-updates
   sudo fwupdmgr update
   ```
   
2. [Verify network settings](network_configuration.md), including IP address and hostname, have been properly adopted from the department DNS server. `ping www.google.com` to make sure you have internet! Then turn on SSH in settings via  `Settings > Sharing > Enable Sharing > Enable Remote Login`.

1. Check for and install any packages updates with `sudo dnf update` and `sudo dnf clean all`.

   Especially important are security updates and firmware upgrades.

1. [Connect to the NFS file server](file_server.md) providing user directories, EDA tools, and process design kits. This is necessary so that home directories exist.

   ```
   $ cd /
   $ sudo mkdir users
   $ sudo mkdir tools
   
   $ sudo vim /etc/fstab
   penelope.physik.uni-bonn.de:/export/disk/users /users nfs4 defaults 0 0
   penelope.physik.uni-bonn.de:/export/disk/tools /tools nfs4 ro 0 0
   
   $ sudo mount -a
   ```

1. [Connect to the FreeIPA integrated LDAP directory server](user_management.md) to read user accounts and group settings. 

   ```bash
   sudo realm join asiclabwin001.physik.uni-bonn.de -v
   ```

   In this process, authenticate as `admin` account. This will create remote LDAP+NFS users, plus a local LDAP only lab user, with /home/ director

1. To configure a machine's CUPS client to connect to the PI printer server (`cups.physik.uni-bonn.de`), you should create a `/etc/cups/client.conf` file:

   ```
   touch /etc/cups/client.conf
   ```

   And then edit the empty file, so that is contains the line:

   ```
   ServerName cups.physik.uni-bonn.de
   ```

   All printers on the FTD network should now be available. To check, you can view a summary of available network printers with the following command:

   ```
   lpstat -t
   ```

   



# Workstation Setup for Fedora Linux 38+:

Start here to configure a fresh installation of Fedora Linux (>=37) on a lab desktop workstation.

1. Create a bootable USB drive with the latest version of Fedora Workstation. The easiest way to do this is on Fedora, MacOS, or Windows using the [Fedora Media Writer](https://getfedora.org/en/workstation/download/). Alternatively, download the latest Fedora ISO file, check the name of your drive with `sudo fdisk -l`, unmount the drive with `sudo umount /dev/sdb*`, and write the ISO image to the drive with `sudo dd bs=4M if=/path/to/fedora.iso of=/dev/sdb status=progress oflag=sync`. Wait for the writing to complete, which could take several minutes.

1. Before flashing Fedora, boot into the BIOS. Reset all settings to 'BIOS Default', then change the Wake on LAN setting to "Enabled with PXE", and change the system setting time to at least the correct hour. Also, be sure that the boost disk mode is set to "AHCI" rather than "Raid on".

1. Insert the bootable USB drive into the machine to be configured and change the boot order in the BIOS or UEFI to boot from the USB drive first. Reboot the machine.

1. Once the Fedora installer has loaded, select "Install to Hard Drive", choose your desired region and keyboard setup, and select the machine's solid state drive for install. After install has completed and the computer has rebooted, accept the prompt to opt into 'Third Party Repositories', and create a local user account called `asiclab`. Ask one of the older lab members for the default admin password for this account. (Password updated as of April 2023.) You should now be on the desktop.

1. [Verify network settings](network_configuration.md), including IP address and hostname, have been properly adopted from the department DNS server. `ping www.google.com` to make sure you have internet! Then turn on SSH in settings via  `Settings > Sharing > Enable Sharing > Enable Remote Login`.

   **From here forward, remote config management is possible. See [Ansible notes](ansible.md) for more info.**

1. Check for and install any packages updates with `sudo dnf update` and `sudo dnf clean packages`.

   Especially important are security updates and firmware upgrades.

1. [Connect to the NFS file server](file_server.md) providing user directories, EDA tools, and process design kits. This is necessary so that home directories exist.

   ```
   $ cd /
   $ sudo mkdir users
   $ sudo mkdir tools
   
   $ sudo vim /etc/fstab
   penelope.physik.uni-bonn.de:/export/disk/users /users nfs4 defaults 0 0
   penelope.physik.uni-bonn.de:/export/disk/tools /tools nfs4 ro 0 0
   ```

   Reboot to mount.

1. [Connect to the FreeIPA integrated LDAP directory server](user_management.md) to read user accounts and group settings. 

   ```bash
   sudo realm join asiclabwin001.physik.uni-bonn.de -v
   ```

   In this process, authenticate as `admin` account. This will create remote LDAP+NFS users, plus a local LDAP only lab user, with /home/ director

1. [Setup the printers!](printer_config.md)

1. Follow instructions for running containerized Cadence, if you need it, using `apptainer`.

1. Finally, enable 3rd party repos (if not already done), and follow instruction to install proprietary software, like Slack, Chrome, etc.

1. If you plan to work remotely, read the section on Remote Connection, which covers SSH, VNC, Wireguard (in network-manager interface)



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


## Continuing on Alma Linux 9:

sudo dnf install tmux htop pandoc curl wget git gcc cmake g++
sudo dnf install python3-devel
sudo dnf install libreoffice-impress libreoffice-calc libreoffice-writer libreoffice-calc inkscape

# power tools repo, also called CRB
sudo dnf config-manager --set-enabled crb


Snapshot of the repos:
```
$ sudo ls /etc/yum.repos.d/
almalinux-appstream.repo  almalinux-highavailability.repo  almalinux-saphana.repo                                   epel.repo
almalinux-baseos.repo     almalinux-nfv.repo               almalinux-sap.repo                                       epel-testing.repo
almalinux-crb.repo        almalinux-plus.repo              _copr:copr.fedorainfracloud.org:mlampe:compat-db47.repo  vscode.repo
almalinux-devel.repo      almalinux-resilientstorage.repo  elrepo.repo
almalinux-extras.repo     almalinux-rt.repo                epel-cisco-openh264.repo
```

```
$ sudo dnf repolist
repo id                                                       repo name
appstream                                                     AlmaLinux 9 - AppStream
baseos                                                        AlmaLinux 9 - BaseOS
code                                                          Visual Studio Code
copr:copr.fedorainfracloud.org:mlampe:compat-db47             Copr repo for compat-db47 owned by mlampe
crb                                                           AlmaLinux 9 - CRB
elrepo                                                        ELRepo.org Community Enterprise Linux Repository - el9
epel                                                          Extra Packages for Enterprise Linux 9 - x86_64
epel-cisco-openh264                                           Extra Packages for Enterprise Linux 9 openh264 (From Cisco) - x86_64
extras                                                        AlmaLinux 9 - Extras
```


