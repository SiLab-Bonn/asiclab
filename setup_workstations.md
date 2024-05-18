# Workstations checklist

This is a checklist of steps to follow when installing the OS and setting up the `asiclab###` User Workstations


## Create bootable ISO

Download ISO file:

```
curl -O https://repo.almalinux.org/almalinux/9/isos/x86_64/AlmaLinux-9.1-x86_64-dvd.iso
```

or

```
wget https://download.rockylinux.org/pub/rocky/9/isos/x86_64/Rocky-9.3-x86_64-minimal.iso
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

1. Set keyboard to English (US).
2. *Root Password* should be "Disabled"
3. Create user `asiclab` with `uid = 1000` and `gid = 1000`. Make user an administrator.
4. *Installation source* is local media.
5. *Software Selection* should be "Minimal"
6. For the installation destination, select both the NVME and HDD and select 'custom' for the storage configuration. Use traditional `standard partitioning` (no LVM) and configure the disks like below. Use `ext4` for the filesystems on the `boot`, `/tmp` and `/` partitions. The swap is `swap`, and the `/boot/efi` is an EFI boot partition.

```
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS FILESYSTEM
nvme0n1     259:0    0 238.5G  0 disk             
├─nvme0n1p1 259:1    0   600M  0 part /boot/efi   efi
├─nvme0n1p2 259:2    0  1024M  0 part /boot       ext4
├─nvme0n1p3 259:3    0   200G  0 part /           ext4
└─nvme0n1p4 259:4    0    32G  0 part [SWAP]      swap
sda           8:0    0  1.82T  0 disk 
└─sda1        8:1    0  1.82T  0 part /tmp        ext4
```

7. Make sure ethernet is connected. 


## Basic

Once booting into Alma Linux, follow the basic steps below to update firmware, update core packages, and connect to NFS, LDAP/FreeIPA, and printers.

1. Make `asiclab` user able to rune `sudo` without re-entering password. Do this via `visudo` adding/uncommenting `asiclab ALL=(ALL) NOPASSWD: ALL`

2. Initial check for/install core packages updates:

```
sudo dnf clean all
sudo dnf update
```

1. Install the Workstation profile

```
sudo dnf group install Workstation
```

1. Swich to the graphical target

```
sudo systemctl set-default graphical.target
sudo systemctl get-default
sudo systemctl isolate graphical.target
```

2. Update firmware, in four commands

```
sudo fwupdmgr enable-remote lvfs
sudo fwupdmgr refresh
sudo fwupdmgr get-updates
sudo fwupdmgr update
```

If you get an error that `Failed to connect to daemon: GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner: Could not activate remote peer: startup job failed.`. Simply delete `/var/lib/fwupd` directory, which will be automatically recreated.

Afterwards, you can check firmware version with `hostnamectl`.

###[Connect to the NFS file server](file_server.md) providing user directories, EDA tools, and process design kits. This is necessary so that home directories exist.

Create mount points
```
sudo mkdir /users
sudo mkdir /tools
echo 'penelope.physik.uni-bonn.de:/export/disk/users /users nfs4 defaults 0 0' | sudo tee --append /etc/fstab
echo 'penelope.physik.uni-bonn.de:/export/disk/tools /tools nfs4 ro 0 0' | sudo tee --append /etc/fstab
sudo systemctl daemon-reload
sudo mount -a
```

Also, not that Hans's computer has the following links for compatibility

/cadence -> /tools
/faust/user -> /users

This cand be created with a command like `sudo ln -s /tools /cadence`, etc

### Append mount instructions to the end of `/etc/fstab`, using these hand commands:

```
echo 'penelope.physik.uni-bonn.de:/export/disk/users /users nfs4 defaults 0 0' | sudo tee --append /etc/fstab
echo 'penelope.physik.uni-bonn.de:/export/disk/tools /tools nfs4 ro 0 0' | sudo tee --append /etc/fstab
sudo systemctl daemon-reload
sudo mount -a
```

Check the commands are there only once:

```
sudo cat /etc/fstab
```

Make sure that the machine can mount NFS4 shares:

```
ls -l /sbin/mount*
```

If not, then install:

```
sudo dnf install nfsv4-client-utils
```

And for useful commands like `showmount`:

```
sudo dnf groupinstall "Network File System Client"
```

Report status of current NFS4 mounts on client:

```
mount -l -t nfs4
```

Ping remote host from client, to see connection options:

```
showmount -e penelope.physik.uni-bonn.de
```

Mount remote NFS shares
```
sudo systemctl daemon-reload
sudo mount -a
```

1. [Connect to the FreeIPA integrated LDAP directory server](user_management.md) to read user accounts and group settings. 

```
sudo realm join asiclabwin001.physik.uni-bonn.de -v
```

In this process, authenticate as `admin` account. This will create remote LDAP+NFS users. The changes made are summarized in the script output:

```
 * Resolving: _ldap._tcp.asiclabwin001.physik.uni-bonn.de
 * Resolving: asiclabwin001.physik.uni-bonn.de
 * Performing LDAP DSE lookup on: 131.220.164.69
 * Successfully discovered: physik.uni-bonn.de
Password for admin: 
 * Couldn't find file: /usr/sbin/ipa-client-install
 * Required files: /usr/sbin/ipa-client-install, /usr/sbin/oddjobd, /usr/libexec/oddjob/mkhomedir, /usr/sbin/sssd
 * Resolving required packages
 * Installing necessary packages: ipa-client oddjob oddjob-mkhomedir
 * LANG=C /usr/sbin/ipa-client-install --domain physik.uni-bonn.de --realm PHYSIK.UNI-BONN.DE --mkhomedir --enable-dns-updates --unattended --force-join --server asiclabwin001.physik.uni-bonn.de --fixed-primary --principal admin -W --force-ntpd
Option --force-ntpd has been deprecated and will be removed in a future release.
Client hostname: juno.physik.uni-bonn.de
Realm: PHYSIK.UNI-BONN.DE
DNS Domain: physik.uni-bonn.de
IPA Server: asiclabwin001.physik.uni-bonn.de
BaseDN: dc=physik,dc=uni-bonn,dc=de
Synchronizing time
No SRV records of NTP servers found and no NTP server or pool address was provided.
Attempting to sync time with chronyc.
Time synchronization was successful.
Successfully retrieved CA cert
    Subject:     CN=Certificate Authority,O=PHYSIK.UNI-BONN.DE
    Issuer:      CN=Certificate Authority,O=PHYSIK.UNI-BONN.DE
    Valid From:  2023-04-26 15:13:16
    Valid Until: 2043-04-26 15:13:16

Enrolled in IPA realm PHYSIK.UNI-BONN.DE
Created /etc/ipa/default.conf
Configured /etc/sssd/sssd.conf
Systemwide CA database updated.
Failed to update DNS records.
Adding SSH public key from /etc/ssh/ssh_host_ed25519_key.pub
Adding SSH public key from /etc/ssh/ssh_host_rsa_key.pub
Adding SSH public key from /etc/ssh/ssh_host_ecdsa_key.pub
Could not update DNS SSHFP records.
SSSD enabled
Configured /etc/openldap/ldap.conf
Configured /etc/ssh/ssh_config
Configured /etc/ssh/sshd_config.d/04-ipa.conf
Configuring physik.uni-bonn.de as NIS domain.
Configured /etc/krb5.conf for IPA realm PHYSIK.UNI-BONN.DE
Client configuration complete.
The ipa-client-install command was successful
This program will set up IPA client.
Version 4.10.2


Using default chrony configuration.
 * /usr/bin/systemctl enable sssd.service
 * /usr/bin/systemctl restart sssd.service
 * Successfully enrolled machine in realm
```


Check it worked, by pinging one of the user accounts:

```
id kcaisley
```

1. To configure a machine's CUPS client to connect to the PI printer server (`cups.physik.uni-bonn.de`), check for and edit `/etc/cups/client.conf` file:

```
cat /etc/cups/client.conf
```

If not found:
```
sudo touch /etc/cups/client.conf
```

And then append the server name to the file, so that is contains the line. Be sure to check with `cat`:

```
sudo echo 'ServerName cups.physik.uni-bonn.de' | sudo tee --append /etc/cups/client.conf
```

All printers on the FTD network should now be available. To check, you can view a summary of available network printers with the following command:

```
lpstat -t
```

1. Report GPU info

```
sudo lshw -C display
```



## Network config

Perhaps consider copying static hostname file to machines?


## System tools, dev tools, and extra repos:

Perhaps consider: Providing: nmap tmux zsh tigervnc, etc.... hmm no I don't want tigervnc or zsh. No don't groupinstall "System Tools"

Providing: gcc gcc-c++ make cmake git, and many rpm tools
```
sudo dnf groupinstall --with-optional "Development Tools"
```

For python and venv:

```
sudo dnf install python3-devel python3-pip
```

Install the extra repos, including 'power tools repo', also called CRB

```
sudo dnf install epel-release -y
sudo dnf install elrepo-release -y
sudo dnf config-manager --set-enabled crb -y

sudo dnf clean all
sudo dnf update
```


## EDA Tool specific setup

```
sudo dnf install -y csh tcsh glibc elfutils-libelf ksh mesa-libGL mesa-libGLU motif libXp libpng libjpeg-turbo expat glibc-devel gdb libXScrnSaver xorg-x11-fonts-misc xorg-x11-fonts-ISO8859-1-75dpi apr apr-util xorg-x11-server-Xvfb mesa-dri-drivers openssl-devel
```

For IC617 and before, you need 32 bit package versions:

```
sudo dnf install -y glibc.i686 elfutils-libelf.i686 mesa-libGL.i686 mesa-libGLU.i686 motif.i686 libXp.i686 libpng.i686 libjpeg-turbo.i686 expat.i686 glibc-devel.i686 redhat-lsb.i686
```

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

When trying to get this same compat-db47 from above:

```
Repository 'epel-9-x86_64' does not exist in project 'mlampe/compat-db47'.
Available repositories: 'epel-8-x86_64'

If you want to enable a non-default repository, use the following command:
  'dnf copr enable mlampe/compat-db47 <repository>'
But note that the installed repo file will likely need a manual modification.
[asiclab@asiclab003 kcaisley]$ sudo dnf copr enable mlampe/compat-db47 epel-8-x86_64
```


`lsb_release` doesn't seem to exist on RHEL9: https://www.reddit.com/r/RockyLinux/comments/wjlh0s/need_to_install_redhatlsbcore_on_rocky_linux_9/. Except, at the bottom someone says it's now in the AlmaLinux Devel repo:

https://almalinux.pkgs.org/9/almalinux-devel-x86_64/redhat-lsb-core-4.1-56.el9.x86_64.rpm.html

`sudo dnf config-manager --add-repo https://repo.almalinux.org/almalinux/9/devel/almalinux-devel.repo`

`sudo dnf --enablerepo=devel install redhat-lsb-core`
`sudo dnf config-manager --set-disabled copr:copr.fedorainfracloud.org:mlampe:compat-db47`

Then make sure that devel is disabled with `sudo dnf config-manager --set-disabled devel`
and then `dnf repolist`, shouldn't show devel


libcrypto.so.10 doesn't also exist. Manually downloaded and installed the version from EL8: https://almalinux.pkgs.org/8/almalinux-appstream-x86_64/compat-openssl10-1.0.2o-4.el8_6.x86_64.rpm.html

`wget https://repo.almalinux.org/almalinux/8/AppStream/x86_64/os/Packages/compat-openssl10-1.0.2o-4.el8_6.x86_64.rpm`

Then just `rpm -i package-name`


Based on this link, learned I have /lib64/libdl.so.2 but Virtuoso is looking for /lib64/libdl.so. So just created a symlink:

```shell
sudo ln -s /lib64/libdl.so.2 /lib64/libdl.so
```

Lastly, for virtuoso, we can see this symlink:

```shell
ls -la /etc/redhat-release 
lrwxrwxrwx. 1 root root 17 May 16 15:34 redhat-release -> almalinux-release
```

Remove the link, and recreate it as a files, and put the following text inside:

```shell
sudo rm /etc/redhat-release
sudo touch /etc/redhat-release
echo 'Red Hat Enterprise Linux Server release 7.9 (Maipo)' | sudo tee --append /etc/redhat-release
```

*Virtuoso now works!*

## Continuing on Alma Linux 9:

sudo dnf install tmux htop pandoc curl wget git gcc cmake g++ python3-devel python3-pip
sudo dnf install libreoffice-impress libreoffice-calc libreoffice-writer libreoffice-calc inkscape

# Installing klayout

```shell
sudo dnf install https://www.klayout.org/downloads/RockyLinux_9/klayout-0.28.15-0.x86_64.rpm
```

Will also install dependencies `http-parser qt5-qtmultimedia qt5-qtsvg qt5-qttools qt5-qttools-dev ruby`

# Installing Vivado:
Needed libtinfo.5, but had libtinfo.6, so just installed a comptability package to provide the older version in addition:

```shell
sudo dnf install ncurses-compat-libs
```

```shell
sudo dnf install fxload libusb1 libusb1-devel libusb
sudo udevadm control --reload-rules
```

# Setting up TCAD

```shell
sudo dnf install ksh perl perl-core tcsh strace valgrind gdb bc xorg-x11-server-Xvfb gcc glibc-devel bzip2 ncompress
```

Jedit is needed for editing scripts, read about it [here](http://www.jedit.org/index.php?page=download&platform=windows)

Java Runtime version 1.8 (aka Java 8) or later is required for jEdit 5.4 and later.
Java Runtime version 11 (aka Java 11) or later is required for jEdit 5.6 and later.
Sentarus provides jedit5.6, Java has to be version 11, and AlmaLinux 9 has version 8.

To fix this, install and enable Java 11:

```shell
sudo dnf install java-11-openjdk
sudo alternatives --config java
```

Then lastly, while logged in graphically on the machines, do the following: 

```shell
sudo java -jar jedit5.6.0install.jar
```

This will provide jedit which can be launched from inside TCAD as the default editor.





# Hardware notes

LenovoThinkstation E30:

[Lenovo IS6XM motherboard](https://theretroweb.com/motherboards/s/lenovo-is6xm)

[User guide](https://download.lenovo.com/ibmdl/pub/pc/pccbbs/thinkcentre_pdf/0a74582_e30_ug_en.pdf)

[Hardware Maintenance Manual](https://download.lenovo.com/ibmdl/pub/pc/pccbbs/thinkcentre_pdf/0a74658.pdf)

A CR2032 lithium battery should read between 3.0-3.4
A Duracell AAA Alkaline battery should present 1.5V

# Installing GUI apps from zip

Installing Typora, Thunderbird, or any other plain zip program. [Instructions](https://support.mozilla.org/en-US/kb/installing-thunderbird-linux)

1. Go to the [Thunderbird's download page](https://www.thunderbird.net/download/) and click on the Free Download button.
2. Open a terminal and go to the folder where your download has been saved. For example:

    ```
    cd ~/Downloads 
    ```

3. Extract the contents of the downloaded file by typing:

    ```
    tar xjf thunderbird-*.tar.bz2 
    ```

4. Move the uncompressed Thunderbird folder to /opt:

    ```
    cp thunderbird /opt 
    ```

5. Create a symlink to the Thunderbird executable:

    ```
    ln -s /opt/thunderbird/thunderbird /usr/local/bin/thunderbird 
    ```

6. Download and install a copy of the desktop file:

    ```
    wget https://raw.githubusercontent.com/mozilla/sumo-kb/main/installing-thunderbird-linux/thunderbird.desktop -P /usr/local/share/applications 
    ```

# H.264 Support

<!-- As of Fedora 37+, H.264 decoders were removed from the based distribution due to legal reasons (alongside H.265). To install alternative H.264 decoders, you can follow the instructions found [here:](https://fedoraproject.org/wiki/OpenH264) -->

<!-- ```
sudo dnf config-manager --set-enabled fedora-cisco-openh264
``` -->


RHEL or compatible like CentOS, to enable the necessary repos (RPM Fusion free and non-free):

```
sudo dnf install --nogpgcheck https://dl.fedoraproject.org/pub/epel/epel-release-latest-$(rpm -E %rhel).noarch.rpm
sudo dnf install --nogpgcheck https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-$(rpm -E %rhel).noarch.rpm https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-$(rpm -E %rhel).noarch.rpm
```

and then install the plugins:

```
sudo dnf install openh264 gstreamer1-plugin-openh264 mozilla-openh264
```

Afterwards you need open Firefox, go to menu -> Add-ons -> Plugins and enable OpenH264 plugin.

You can do a simple test whether your H.264 works in RTC on [this page](https://mozilla.github.io/webrtc-landing/pc_test.html) (check Require H.264 video).


# Install and uninstall standalone rpm packages

To manuall installl an rpm package:

```
sudo rpm --import [package.rpm]
```

Execute the following command to discover the name of the installed package:

```rpm -qa | grep PackageName```

This returns PackageName, the RPM name of your Micro Focus product which is used to identify the install package.
Execute the following command to uninstall the product:

```rpm -e PackageName```


# Additional programs:

- mc
- hwinfo
- htop
- thunderbird
- libreoffice-calc, libreoffice-impress, libreoffice-writer
- chromium
- gnome-tweaks
- groupinstall "Workstation"
- inkscape

# VS Code
VS Code is currently only shipped in a yum repository, so first add the repository:

```
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
```

Then add the package repo to `/etc/yum.repos.d`, via:

```
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
```

Update the package cache

```
dnf check-update
```

and install the package using dnf (Fedora 22 and above):

```
sudo dnf install code
```

# Zoom

Check the link for the latest rpm package from the `download` website. Then download it via `wget`, for example :

```bash
wget https://zoom.us/client/5.16.10.668/zoom_x86_64.rpm
```

Get the latest public key like so:

```
# This is currently not working, due to RHEL9 deprecating SHA1:

"warning: Signature not supported. Hash algorithm SHA1 not available."

wget https://zoom.us/linux/download/pubkey
sudo rpm --import pubkey
```

Finally, you may need to set SELinux to 'permissive' mode, to prevent it from blocking Zoom usage:

```
https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/using_selinux/changing-selinux-states-and-modes_using-selinux#changing-to-permissive-mode_changing-selinux-states-and-modes
```

# Python venvs

If you're normally used to only Anaconda, stop, and take a deep breath. Weigh the value of your sanity, and then look into how to create Python venvs. This is a new-ish feature in Python, and will make your life better.


# Email

### Incoming Server Settings:

```
Protocol: IMAP
Hostname: mail.uni-bonn.de
Port: 993
Connection Security: SSL/TLS
Authentication Method: Normal Password
Username: kcaisley@uni-bonn.de
```

### Outgoing Server Settings:

```
Protocol: SMTP
Server Name: mail.uni-bonn.de
Port: 587
Connection Security: STARTTLS
Authentication Method: Normal Password
Username: kcaisley@uni-bonn.de
```

# Calendar:


For Thunderbird:
```
Username: kcaisley
CalDAV: https://mail.uni-bonn.de/CalDAV/Work/
```

For Evolution:
```
Servername:
https://posteo.de:8443/calendars/kcaisley/default/
```

# Contacts
Network address book is integrated via CardDAV
The address book provided with each Uni ID on the e-mail server is called "Contacts"
the URL is: https://mail.uni-bonn.de/CardDAV/Contacts
user name is the Uni ID with the corresponding password
Note upper and lower case!!!

# Gnome extensions

Go to https://extensions.gnome.org/local/ and enable 'Launch new ...'