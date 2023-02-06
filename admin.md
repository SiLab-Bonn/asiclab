This is a backward test [link](README.md)

What should the script do? After Fedora has been installed, the local user has been created (with default password), you will reach the home screen. From here we must simple 

User Machines (asiclab###)

## Initial OS Installation

* Produce a Fedora workstation boot-able drive using the [Fedora Media Writer](https://getfedora.org/en/workstation/download/), available for MacOs, Windows, or Fedora Linux OSes.
* Install latest Fedora install
* create local `asiclab` user, with default password
* enable 3rd party repos
* 





Workstations:

Need to setup:

Mounting points /cadence and /faust/user

hostname

setup 2TB Harddrive

VSCode

GIMP

Inkscape

Enable 3rd party repos

X11 Forwarding, SSH keys, and TigerVNC

OpenLDAP

Printer Server

File Servers

meld
dialect
visual studio code
password manager thing


# DNF and RPM package management:

Check current version of an installed RPM
`rpm -q <packagename>`

Check current versions of remote and installed versions of a package
`dnf info <packagename>`

List contents of installed RPM
`rpm -ql <packagename>`

List contents of remote repository package:
`dnf repoquery -l spdlog`


## Configuration Management:

What I need to do it develop a configuration management strategy for ASICLab. I need to balance a number of different factors against each other 

The simplest strategy is going to be just simply building a list of family of bash scripts in a git repo, which is then hosted on the laboratory github page.

These should be used for everything from the start-ups of Cadence (with rules for start-up), to the configuration of the license servers.

Explaining why certain thing are in a specific location is the best strategy.

Future linux system admins in ASICLab will have to understand bash scripts, and basic linux systems admin tools, as they pertain to modern versions of Fedora.

Then we can make a rule that software installations on the system need to be pushed through the central git repository, rather than being done independantly to a machine. This repo will be setup in such a way that changes to machines on the lab network can then simply be done from a git repository which can be pulled down to a person's lab top by cloning, and then run out against all the computers via GNU Parallel.

I've considered maybe building this tool using something like Python, but I think ultimately it's going to be running Bash scripts in the backend anyways, and so it's good if I just use Bash as the interemediate interface.

I can use a similar workflow to this for my designs in Python/Cadence. The final versions of design scripts should be hosted and modified in Github repositories.

The trick here is that if the design is detailed in a procedural manner, rather than as a absolute output, that you get documentation relatively for free.

What if the same format as Pweave existed for Bash. I could write my documentation with inline code, and then either weave it into completed documentation that can be statically hosted, or tangle it into the Bash script that must be targeted at the host machine to be configured.

If source control is used to then maintain this script, then we can make sure we never lose track of how this script is modified over time.

Github/Git and Python are already fluently used by the rest of the laboratory, and so I think it would be  an added advantage to simply stick with it.

One philosophical delineation that I'm realizing I want to use is to always draft everything, be it markdown, LaTex, python, or Bash in a plaintex format, and to execute and compile the output of that code on a machine that can be either local or remote. I can simply use Git to move things and maintain things because of that, and I will gain the speed of being able to write incredible fast in Vim.

When it comes to viewing the compiled output of my file, I can then use web browser technology to render HTML or open a PDF. This is incredibly powerful.

As far as IDE features go, there are some features I should be able to access in Vim, like:

* syntax highlighting,
* tab completion
* hooks (for executing builds/scripts)
* variable introspection
* doc strings
* inline file browsing and switching
* fuzzy finding
* project wide searching
* multi-language linting/error checking
* type checking
* quick terminal execution without exiting the editor
* jump to definition (which I can do with Ctags)
* code formatting plugins
* auto-brackets

Inline figures and inline rendered markdown won't be supported, but I'm getting this from my web-based rendering strategy.

I obviously get all these things for free, but I'd rather not tie myself to a specific editor, because all of the modularity I've been building up with window management, etc seems as though it will be wasted then.

One window per task is my philosophy.

GNU Parallels is a great way to configure a bunch of machines in parallel:

Using this option: **--nonall**

## OS interaction features in python:

* subprocess module, with methods subprocess.run() and subprocess.open()

* command library from PyPI: 3rd party so don't want to use it
* os module: deprecated



Also, learning to use basic tools first, and creating a home spun solution, which then may eventually reach it's limits, and that leads you to understanding exactly what you need out of a 3rd party project is the best way to proceed.



## 1. Boot from USB, using latest Fedora Desktop edition

## 2. Setup drives (didn't take care of 2 TB HDD yet)
`lsblk` command is useful for this.

## 3. Setup network
`asiclab006` should be `131.220.163.233`. 
can be checked with `ip address` command, and checking the inet address of the eno1 device.


# 6. Double check hostname and time synchronization

Both are important for trouble-free server operation. Just in case you missed its configuration during installation or it is incorrect, now is the opportunity to fix it.

Check for correct hostname

`[…]# hostnamectl`

Set hostname if required:

`[…]# hostnamectl  set-hostname  <YourFQDN>`

Control of time zone, time synchronisation, time

`[…]# timedatectl`

Correct time zone if necessary:

`[…]# timedatectl set-timezone  <ZONE>`

If necessary, activate time synchronisation:

`timedatectl set-ntp true`

Correct time if necessary:

`[…]# timedatectl set-time  <TIME>`


# Configuring Ethernet with Static IP:
The /etc/sysconfig/network-scripts/ifcfg-interface_name file was deprecated, and now `nmcli` is used, alongside it's keyfile [format](https://people.freedesktop.org/~lkundrak/nm-docs/nm-settings-keyfile.html). It's not recommended to configure this file manually, even though you technically can (and inform NetworkManager). Instead the better way to proceed is to use the nmcli setup.

The history of the migration from ifcfg to keyfiles is details in this [Fedora magazine post](https://fedoramagazine.org/converting-networkmanager-from-ifcfg-to-keyfiles/):

Here's the old ifcfg file:

```
DEVICE="INTERFACE_NAME"
BOOTPROTO="static"
PEERDNS=no
IPADDR="static_IP_as_in_/etc/hosts"
GATEWAY="131.220.163.254"
NETMASK="255.255.248.0"
IPV6INIT="no"
NM_CONTROLLED="no"
ONBOOT="yes"
```

As we can see, the netmask is 255.255.248.0 which corresponds to /21.

To create a new set of keyfiles, the best approach is something like:

```
$ nmcli con modify eth0 ipv4.method manual
$ nmcli con modify eth0 ipv4.addresses 10.0.0.10/8
$ nmcli con modify eth0 ipv4.gateway 10.0.0.1
$ nmcli con modify eth0 ipv4.dns 10.0.0.2,10.0.0.3
```

```
nmcli connection modify Wired\ connection\ 1 ipv4.method manual
nmcli connection modify Wired\ connection\ 1 ipv4.addresses 131.220.165.187/21
nmcli connection modify Wired\ connection\ 1 ipv4.gateway 131.220.163.254

nmcli connection modify Wired\ connection\ 1 ipv6.method disabled

nmcli connection up Wired\ connection\ 1
```

For more information, check out
`$ man nmcli-examples`

and
`$ man nm-settings-nmcli`

To see the connection profile, and current status of the connection:
`nmcli -p connection show Wired\ connection\ 1 | less`

Damn, it looks like nearly all of the settings for this computer were simply copied over from the network somehow. Take the resolve DNS settings:

```
$ resolvectl status
Link 3 (eno1)
    Current Scopes: DNS LLMNR/IPv4 LLMNR/IPv6
         Protocols: +DefaultRoute +LLMNR -mDNS -DNSOverTLS DNSSEC=no/unsupported
Current DNS Server: 131.220.16.220
       DNS Servers: 131.220.16.220 131.220.14.203 131.220.18.138
        DNS Domain: physik.uni-bonn.de
```



## BTRFS

Has built in volume management, so something like the EXT4 - LVM combination isn't needed.

* `man 5 btrfs` — info about btrfs itself: mount options, features, limits, swapfile support, the case of multiple block group profiles
* `man btrfs` — btrfs user space commands overview
* `man btrfs <command>` — man page for this specific btrfs command, e.g. `man btrfs device`. NOTE: Any command name can be shortened so long as the shortened form is unambiguous, e.g. `btrfs fi us` is equivalent to `btrfs filesystem usage`.
* `man mkfs.btrfs` — man page for the mkfs command, includes info on block groups, chunks, raid, multiple device layouts, profiles, redundancy, space utilization, and minimum devices.





When adding storage to a Linux server, system administrators often use commands like *pvcreate*, *vgcreate*, *lvcreate*, and *mkfs* to integrate the new storage into the system.

https://fedoramagazine.org/getting-started-with-stratis-up-and-running/

Tutorial for creating RAID6 array:

https://www.digitalocean.com/community/tutorials/how-to-create-raid-arrays-with-mdadm-on-ubuntu-22-04



lsblk

sudo mdadm --create --verbose /dev/md/0 --level=6 --raid-devices=5 /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf

sudo mdadm --query /dev/md/0

array will take time to mirror, but in the mean time can be used. Monitor with: `cat /proc/mdstat`



sudo mkfs.ext4 -F /dev/md/0













## Raid Server management

mdadm  `--query` option

Free space
`df -h`

Used space
`du (??options?)`

List Hardware devices:
`lsblk`

To check the status of current NFS or SMB shares, use the following (TYPE = nfs4, smb, autofs,cifs,etc)
`mount -l -t TYPE`

## NFS

## NFS



#Software Raid Re-Setup:
https://serverfault.com/questions/32709/how-do-i-move-a-linux-software-raid-to-a-new-machine

`mdadm --assemble --scan --verbose /dev/md{number} /dev/{disk1} /dev/{disk2} /dev/{disk3} /dev/{disk4}`

it may be automatically detected and rebuilt, and so you'll just need to:


sudo mkdir mnt/raid/
sudo mount /dev/md127/ /mnt/raid/



# NFS

List PIDs of NFS shares on a host/server machine:
`service nfs status` (CentOS6) or `systemctl status nfs` (CentOS7)

Show status of nfs-mountd service on NFS clients (doesn't exist on CentOS 6)
`systemctl status nfs-mountd`

On host, show info on what clients are mounting an NFS server (should show nothing on client machines)
`showmount --all`

Resolve DNS names
Reverse resolve a IP address to a name, via the local DNS:

`nslookup 131.220.166.32` (etc)

Resolve a name to an IP:

`nslookup faust02.physik.uni-bonn.de`

List currently connected clients from host server:

`sudo netstat -a | grep :nfs`

Report status of current NFS4 mounts on client:

`mount -l -t nfs4`

Ping remote host from client, to see connection options:

`showmount -e penelope.physik.uni-bonn.de`

Mount a directory on client

`sudo mount -t nfs4 penelope.physik.uni-bonn.de:/export/disk/users /faust/user`
`sudo mount -t nfs4 penelope.physik.uni-bonn.de:/export/disk/cadence /cadence`

### Setup of new NFS server on Fedora:

ip should be: `131.220.165.56`

locations: `/export/disk/users` and `/export/disk/cadence`

NFSv4 exports exist in a single *pseudo filesystem*, where the real directories are mounted with the `--bind` option. [Here](http://www.citi.umich.edu/projects/nfsv4/linux/using-nfsv4.html) is some additional information regarding this fact. 

- Let's say we want to export our users' home directories in `/home/users`. First we create the export filesystem: 

  ```
  sudo mkdir /export
  sudo mkdir /export/users 
  ```

and mount the real users directory with: 

```
sudo mount --bind /home/users /export/users 
```

To save us from retyping this after every reboot we add the following line to `/etc/fstab`: 

```
/home/users    /export/users   none    bind  0  0 
```


### Actually setting up NFS:
a good tutorial: https://www.redhat.com/sysadmin/nfs-server-client

1. Let Penelope read from noyce LDAP server/ make sure UID and GIDs are correct: 
https://docs.fedoraproject.org/en-US/fedora/latest/system-administrators-guide/servers/Directory_Servers/


2. Start NFS Server on Penelope

`sudo systemctl start nfs-server.service`
`sudo systemctl enable nfs-server.service`

3. List the current versions of NFS running: (NFS3 vs 4)
`rpcinfo -p | grep nfs`

4. create mount points For legacy export locations:

`sudo mkdir -p /export/disks`
`sudo mount --bind /mnt/md0/ /export/disk/`     (using bind mount, rather than regular, as we both locations must be readable, rather than one being a /dev/ location)

this is bad form, one should instead add both the ext4 mount and the bind mount to the /etc/fstab file:

sudo vim /etc/fstab

/dev/md127 /mnt/md127 ext4 defaults,nofail,discard 0 0
/mnt/md127/users /export/disk/users none bind
/mnt/md127/tools /export/disk/cadence none bind

After saving, make sure to restart the systemctl daemon and remount:

sudo systemctl daemon-reload
sudo mount -a

5. Properly set permissions of export directory before exporting:

6. Create `/etc/exports` file: (don't use the last location, as it is just for backups)

```
/export/disk/cadence   apollo(rw,sync,no_root_squash,no_all_squash) faust02(rw,sync,no_root_squash,no_all_squash) asiclab*(ro,sync,root_squash,no_all_squash) jupiter(ro,sync,root_squash,no_all_squash) noyce(ro,sync,root_squash,no_all_squash) juno(rw,sync,root_squash,no_all_squash)

/export/disk/users asiclab*(rw,root_squash,async,no_subtree_check) apollo(rw,async,no_root_squash,no_subtree_check) faust02(rw,async,no_root_squash,no_all_squash,no_subtree_check) jupiter(rw,async,root_squash,no_all_squash,no_subtree_check) noyce(rw,async,root_squash,no_all_squash,no_subtree_check) penelope(rw,async,root_squash,no_all_squash,no_subtree_check) juno(rw,async,root_squash,no_all_squash,no_subtree_check)

/export/backup   apollo(rw,sync,no_root_squash,no_all_squash)
```

7. Run export command on 
sudo exportfs -rav

This command should only be run once, unless you change something. If you see complaints about stale file handles from the clients, one should do:

`exportfs -ua`
`cat /proc/fs/nfs/exports`  this file should be empty after previous command. Also, debug here for duplicates
`exportfs -a`

8. Allow through firewall: https://www.redhat.com/sysadmin/nfs-server-client

https://www.redhat.com/sysadmin/nfs-server-client
sudo firewall-cmd --permanent --add-service=nfs
sudo firewall-cmd --permanent --add-service=rpc-bind        (needed for NFS3 configs)
sudo firewall-cmd --permanent --add-service=mountd          (needed for NFS3 configs)
sudo firewall-cmd --reload

more complicated commands, for NFS4 only:
https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/managing_file_systems/configuring-an-nfsv4-only-server_managing-file-systems#benefits-and-drawbacks-of-an-nfsv4-only-server_configuring-an-nfsv4-only-server



The default installation installs NFS, but neither enables it nor configures the firewall accordingly.

```none
[…]# systemctl enable nfs-server --now
[…]# systemctl status nfs-server
[…]# firewall-cmd --permanent --add-service=nfs
[…]# firewall-cmd --reload
```




## SMB/Samba/CIFS

report status of connections on SMB server (noyce) (must be >=CentOS7)
`smbstatus`

ftp-like client to access SMB/CIFS resources on servers, with -U flag to check current config for a user,
to ping and repo available servers of remote server from local client machine
`smbclient -L noyce.physik.uni-bonn.de -U kcaisley`

to add folders shares to the on the server:
Edit the file "/etc/samba/smb.conf"
`sudo vim /etc/samba/smb.conf`

```
Once "smb.conf" has loaded, add this to the very end of the file:
    
    [<folder_name>]
    path = /home/<user_name>/<folder_name>
    valid users = <user_name>
    read only = no
```
    Tip: There Should be in the spaces between the lines, and note que also there should be a single space both before and after each of the equal signs.

To access your network share from the client machines

```
      sudo apt-get install smbclient
      # List all shares:
      smbclient -L //<HOST_IP_OR_NAME>/<folder_name> -U <user>
      # connect:
      smbclient //<HOST_IP_OR_NAME>/<folder_name> -U <user>
```

#### Othere SMB commands:

NetBIOS over TCP/IP client used to lookup NetBIOS names, part of samba suite.
`nmblookup __SAMBA__`

List info about machines that respond to SMB name queries on a subnet. Uses nmblookup and smbclient as backend.
`findsmb`

# Groups, UIDs, and GIDs

## User permissions plan:
UID:
asiclab         1000 (local on each computer)
user1           2001
user2           2002
user3           2003  ...etc

GID:
admingroup      1000    (just local asiclab user on each computer)
basegroup       1001    (all user directories, and default setting in tools directory)
cdsgroup        1002    (access to cadence tools? Does this include mentor and synonpsys as well?)
tsmc65group     1003
tsmc28group     1004



## 
note, when running ls -l, the second column is the number of hardlinks (which is equal to the number of directories, sorta?) anyways, i can just think of it as the approximate number of directories inside this one.


Why are some of the /faust/user directories owned by `faust`, and others `root`?
What is the the wheel group used for?
Root is disabled as a login user on Fedora.

### Check groups of a user
`groups kcaisley`

### check full group and user info of user
`id kcaisley`

### check all members in a group
`getent groups icdesign`

### List all groups, and their members
Groups can be supplied from both /etc/group and from LDAP. The combination of both these will be show in:

`getent group`

###Add a group with gid
`sudo groupadd -g 1001 icdesign`

When you add users to a group, using the `-g` commands makes it the users primary group, where as the `-G` flag makes it a secondary group.

###To delete a group:
`sudo groupdel kcaisley`


Ahh shit, this was `adduser` rather than `useradd`
Add a new user, but use an already existing home:
`sudo adduser kcaisley --no-create-home --home /faust/user/kcaisley/ --uid 37838`

should rewrite this command with 

`useradd`
`usermod`
`userdel`
`groupadd`
`groupmod`
`groupdel`
`chmod`
`chown`
`chgrp`

###To create a group in linux:
`sudo usermod -a -G groupname username`

###To become another user
`su – <username>`

###To change a user's password
`passwd edward`

[https://docs.fedoraproject.org/en-US/quick-docs/adding_user_to_sudoers_file/](Adding a user to sudoers and wheel group)

On Fedora, it is the wheel group the user has to be added to, as this group has full admin privileges. Add a user to the group using the following command:
sudo usermod -aG wheel username

If adding the user to the group does not work immediately, you may have to edit the /etc/sudoers file to uncomment the line with the group name:
```
$ sudo visudo
...
%wheel ALL=(ALL) ALL
...
```
Then logout and back in


To list the user and UID and groups and their GIDS for a specific user (omit for current user)
`id asiclab`

## listing users on a computer:
This can mean different things:
1) The files for which the UID is set to a certain number.
2) The accounts defined for login in /etc/passwd
3) The groups of UIDs that own all the folders in a home directory

Viewing the second and third can be done with:
`cat /etc/passwd`

#### List of users and UIDs
drwxr-xr-x.   5 48914 root  4096 Jun  1  2017 bmatthieu
drwxr-xr-x.  38  9181 root  4096 Feb 22  2021 cbespin
drwxr-xr-x.  65 29853 root  4096 Aug 17  2020 cdrtest
drwxr-xr-x. 109   204  200 12288 Aug 23 10:30 cdsmgr
drwxr-xr-x.  18 12435 root  4096 Apr 27  2020 ci-runner
drwxr-xr-x.  35 13108 root  4096 Jul 25 11:06 cirunner
drwxr-xr-x.   2  2018  200  4096 Dec  4  2012 dpohl
drwxr-xr-x.  38 38737 root  4096 Jan  9 10:51 dschuechter
drwxr-xr-x.  33 39748 root  4096 May  5  2020 ekimmerle
drwxr-xr-x.  35   613  200  4096 Jun 26  2014 fhuegging
drwxr-xr-x.  12  1004 root  4096 Sep 16  2010 fluetticke
drwxr-xr-x.  38 23374 root  4096 Dec  9  2019 fpiro
drwxr-xr-x.  18 11100 root  4096 Apr 27  2020 gitlab-runner
drwxr-xr-x.  42 40685 root  4096 Jun  7  2019 iberdalovic
drwxr-xr-x.  22 42487 root  4096 Feb  9  2021 icaicedo
drwxr-xr-x.   8  2014  200  4096 Dec 19  2011 jjanssen
drwxr-xr-x.  33 15119 root  4096 Oct  5  2021 jklas
drwxr-xr-x.  30 37838 root  4096 Jan 13 11:51 kcaisley
drwxr-xr-x.  37 12607 root  4096 Feb  1  2021 kmoustak
drwxr-xr-x. 134 40882  200 16384 Sep 27  2021 kmoustakas
drwxr-xr-x. 140   201  200 12288 Nov 16 09:14 krueger
drwxr-xr-x.  32 64291 root  4096 Jul 19  2019 lflores
drwxr-xr-x.  49 20546 root  4096 Oct  5 07:47 lhafiane
drwxr-xr-x.  56 25987 root  4096 Jul 28  2017 mbautista
drwxr-xr-x.  15  9244 root  4096 Mar 16  2017 mdaas
drwxr-xr-x.   3 22429 root  4096 Mar 31  2021 mfrohne
drwxr-xr-x.  40 13333 root  4096 Sep  9  2016 mkaragou
drwxr-xr-x.  79 26533 root 12288 Dec 19 05:36 mstandke
drwxr-xr-x.   9  5122 5123  4096 Jun 21  2011 munin
drwxr-xr-x. 144 17279 root 20480 Jan 13 11:51 mvogt
drwxr-xr-x. 135  2019 root 20480 Nov  1 12:43 prymaszewski
drwxr-xr-x.  56 57985 root  4096 Jan 13 11:58 skhan
drwxr-xr-x.  66 12502 root  4096 Jan 12 05:55 szhang
drwxr-xr-x.  27 12470 root  4096 Jun  1  2017 temp
drwxr-xr-x. 256   612  200 32768 Nov  1 13:03 themperek
drwxr-xr-x.  56  2020  200  4096 Jan 28  2021 thirono
drwxr-xr-x.  89  2450 root 20480 Oct 25  2021 tianyang
drwxr-xr-x.  47  3504 root  4096 Aug 12  2021 tkamilaris
drwxr-xr-x.  18 36611 root  4096 Jun 14  2019 tuser
drwxr-xr-x.  70  2028  200 12288 Feb 27  2020 twang



##------------------------------------------------------------------

## adding a printer:
Configure the CUPS client to use one of the following CUPS servers:
cups.physik.uni-bonn.de (PI network)

To do this, create a file /etc/cups/client.conf  with the contents:
`ServerName cups.physik.uni-bonn.de`


setting up wireguard:
https://confluence.team.uni-bonn.de/display/PHYIT/WireGuard+VPN#tab-Linux

To check the port of service:
`cat /etc/service | less`


## automatically mount files system

$ sudo vim /etc/fstab

Add lines:
`penelope.physik.uni-bonn.de:/export/disk/users /faust/user nfs4 defaults 0 0`
`penelope.physik.uni-bonn.de:/export/disk/cadence /cadence nfs4 ro 0 0`

options for the mounting drives are: https://help.ubuntu.com/community/Fstab#Options
`https://wiki.archlinux.org/title/Fstab`

## enable and start ssh:
sudo systemctl enable sshd
sudo systemctl start sshd

## enable and connect via RDP:

app


## tutorial to write

make sure primary group is 'faust', else nobody permission will happen
https://unix.stackexchange.com/questions/186568/what-is-nobody-user-and-group


The nobody user is a pseudo user in many Unixes and Linux distributions, which is used to represent the user/group with the lowest permissions. In the best case that user and its group are not assigned to any file or directory (as owner). One application that makes use of this group through is NFS. If the owner of a file or directory in a mounted NFS share doesn't exist at the local system, it is replaced by the nobody user and its group.

Take back any files that have been made under user or personal group name, and assign them to faust

## Changing shell

Need the `tcsh` and `chsh` commands to be 

To check which shell is active: 

cat /etc/passwd | grep `cd; pwd`

To change shell, by running this and then restarting termina:

`chsh -s /usr/bin/zsh`



This works now, but I needed ksh installed.



okay, still complaining that it's not a supported OS. Tried running the checkSysConf tool:


```
/cadence/cadence/IC618/tools.lnx86/bin/checkSysConf
```


installed Zoom

## Packages needed (underlined weren't needed on CentOS 7)

glibc                  		2.17								2.36
elfutils-libelf        	0.166							0.187			
ksh                   	 	20120801				  **1.0.3**				manually installed
mesa-libGL            11.2.2							**22.2.3**
mesa-libGLU			9.0.0							9.0.1				manually installed
motif                  		2.3.4							2.3.4				manually installed
libXp                  		1.0.2							1.0.3				manually installed
libpng                 	1.5.13								1.6.37		
libjpeg-turbo          1.2.90							**2.1.3**
expat                  	2.1.0								2.5.0
glibc-devel            2.17									2.36
gdb                    	7.6.1								12.1.0
xorg-x11-fonts-misc    						7.5		7.5				manually installed
<u>xorg-x11-fonts-ISO8859-1-75dpi</u>   7.5		
<u>redhat-lsb</u>             				4.1
libXScrnSaver          		1.2.2						1.2.3
apr                    			1.4.8							1.7.0
apr-util               				1.5.2						1.6.1
compat-db47					4.7.25						5.3.28 (libdb: Berkeley DB library for C)
<u>org-x11-server-Xvfb</u>   	1.15.0
mesa-dri-drivers       	17.2.3						22.2.3
openssl-devel          	1.0.1e							**3.0.5**  this was a big change, it could be a problem??



Okay, I'm still having issues, and cadence isn't giving me any useful messages. I've ruled the issue with wayland and Xorg, and I've switched to Xorg. My next step is to figure out how to get more verbose information on why Virtuoso isn't starting. All it says right now is:

```
2022/11/30 13:13:40 System is not a supported distribution
2022/11/30 13:13:40 An error occurred. We don't recognize OS 
2022/11/30 13:13:40 WARNING This OS does not appear to be a Cadence supported Linux configuration.
2022/11/30 13:13:40 For more info, please run CheckSysConf in <cdsRoot/tools.lnx86/bin/checkSysConf <productId>
```

Before I start hacking away and changing packages like openssl-devel to be more inline with the CentOS7 system, perhaps I can figure out better exactly what may need to change. Let's look at the CheckSysConf script and try to figure out what the latest supported version of the packages is. What version of Ubuntu is supported? Maybe there is a log message being written somewhere, and the people [here](https://www.edaboard.com/forums/linux-software.21/) might know where to find that log message.

## Containers

OS-level virtualization is an operating system (OS) paradigm in which the kernel allows the existence of multiple isolated user space instances, called containers (LXC, Solaris containers, Docker, Podman), zones (Solaris containers), virtual private servers (OpenVZ), partitions, virtual environments (VEs), virtual kernels (DragonFly BSD), or jails (FreeBSD jail or chroot jail).[1] Such instances may look like real computers from the point of view of programs running in them. A computer program running on an ordinary operating system can see all resources (connected devices, files and folders, network shares, CPU power, quantifiable hardware capabilities) of that computer. However, programs running inside of a container can only see the container's contents and devices assigned to the container. 

A short list of tech to consider: Docker, Fedora CoreOS, Silverblue, Ansible, Toolbx, Singularity/Apptainer, Podman, LXC, Flatpak

Unlike a virtual machine, container are abstraction at the operating system level.

We can use a CentOS7 image for setting up and running our cadence development.

But how do we then access data?

Docker is a single-purpose *application virtualization* and LXC is a multi-purpose *operating system* virtualization. If one looks for a portability and scalability of the application / micro-service, Docker and Kubernetes is a good choice. If one would like to have several (or even thousands of) portable systems on a single computer, LXC is a good choice.

Docker was not designed out of the box for GUI apps, so you need to have a video server with X11 typically for that.

Linux containers are all based on the virtualization, isolation, and resource management mechanisms provided by the [Linux kernel](https://en.wikipedia.org/wiki/Linux_kernel), notably [Linux namespaces](https://en.wikipedia.org/wiki/Linux_namespaces) and [cgroups](https://en.wikipedia.org/wiki/Cgroups).

#### OS-Level Virtualization (Containers) and Application Virtualization Technologies:

With this tech, different distributions are fine, but other operating systems or kernels are not. Full application virtualization requires a virtualization layer.[[2\]](https://en.wikipedia.org/wiki/Application_virtualization#cite_note-Husain-2) Application virtualization layers replace part of the [runtime environment](https://en.wikipedia.org/wiki/Runtime_environment) normally provided by the operating system. The layer intercepts all disk operations of virtualized applications and transparently redirects them to a virtualized location, often a single file.[[3\]](https://en.wikipedia.org/wiki/Application_virtualization#cite_note-Gurr-3) The application remains unaware that it accesses a virtual resource instead of a physical one. Since the application is now working with one file instead of many files spread throughout the system, it becomes easy to run the application on a different computer and previously incompatible applications can be run side by side. 

A container image is simply a file (or collection of files) saved on disk that stores everything you need to run a target application or applications:

* code
* runtime
* system tools
* libraries
* etc

A container process is simply a standard (Linux) process running on top of the underlying host's operating system and kernel, but whose software environment is defined by the contents of the container image.

> How do I develop in a container, when I need to run a GUI as part of my workflow? What are the limits of containerization? 

#### Limitations of Containers

1. Architecture dependent; always limited by CPU architecture (x86 vs ARM) and binary format (ELF)
2. Portability: Requires glibc and kernel compatibility between host and container; also requires any other kernel-user space API compatibility (e.g., OFED/IB, NVIDIA/GPUs)
   1. Like something built on Ubuntu 22.04 wouldn't work on CentOS 6
3. Filesystem isolation: Filesystem paths are (mostly) different when viewed inside and outside container
   1. By default containers can't see the contents of the host file system. To access host filesystem from inside the file system requires a bit of extra work to 'bind' it. 

#### Docker

Really designed for network centric services like web servers and databases, but not really meant for HPC systems where many users are sharing a space. Docker assumes you have trust for all users running on systems. Whereas in HPC, the admins don't even trust the users.

Docker also wasn't designed to support batch-based workflows

Docker not designed to support tightly-coupled, highly distributed parallel applications (MPI)

#### Singularity

* Designed at Berkeley Lab as the equivalent for HPC.
* Each container is a single (read-only) image file (unlike the layered arch. in Docker). If you want to change it, you have to to rebuild it.
* No root owned daemon processes
* Support shared/multi-tenant resource environments
* Support HPC Hardware: Infiniband, GPUs
* Supports HPC applications: MPI

#### Most Common Use Cases

* Building and running applications that require older/newer system libraries than are available on the host system
  * Most modern tools, like PyTorch, assume the latest packages, and expect a debian-based environment like Ubuntu, which most HPC system aren't doing. Containers can solve these incompatibilities.
* Running commercial applications binaries that have specific OS requirements not met by the host system.
  * Your license agreement may only give you a compiled binary, which you're  
  * Oh! Wow this is exactly my use case. How do I build a repoducible environment when commercial binaries (maybe even with GUI?) are part of the workflow?
* Converting prexisting Docker containers, which won't work for HPC clusters, to Singularity containers

#### Workflow

1. **Build** your Singularity containers on you local system where you have root or sudo access; e.g., a personal computer where you have installed Singularity
   1. You can't work on native MacOS, as you need to use a Virtual machine with a Ubuntu or Fedora-based OS. This is doubly true, if your Mac has an M1 ARM chipset.
2. **Transfer** your Singularity containers to the HPC system where you want to run them
3. **Run** your Singularity containers on that HPC system

#### Conclusion: Use Apptainer

Overview of why not Docker, and the better options:

https://blog.jwf.io/2019/08/hpc-workloads-containers/

Using Singularity/Apptainer with GUI commercial applications:

https://learningpatterns.me/posts/2018-01-30-abaqus-singularity/

https://apptainer.org

## Which package provides file on RHEL Based System
`dnf provides ./filename`

Then check why a package was explici

# How to use Apptainer

I don't technically need to use a define file to make sure that this work. I can, at least for prototyping, try creating a container in sandbox mode:

```
$ apptainer build --sandbox virtuoso_centos7.sif docker://centos:7
WARNING: The sandbox contain files/dirs that cannot be removed with 'rm'.
```

Next we can start a shell inside this modifiable container:

`$ apptainer shell virtuoso_centos7.sif`

The `run`, `exec`, and `shell` commands are the three primary ways in which to interact with a container image. The `run` command will start the container, run the scripts marked for execution inside the container (if any), and then exit. The `exec` commands allows a one time command to be run inside the shell, which then exits. The `shell` command allows an interactive shell to be spun up, which can be exited at will. The first option is good for image usage once it is finalized. The latter two are best for prototyping when building in sandbox mode.

I need to install a couple packages within this container. The right process is **not** to enter a shell within the container and run sudo yum install.

Tomorrow:

bind mount the cadence folder
install the lsb-release package
run the cadence compatibility script, and manually specify all the packages to install, until this check is passed
figure out how to start the gui of the container
write define file to make the above reproducible

[docs](https://apptainer.org/docs/user/main/index.html)
[commerical GUI](https://learningpatterns.me/posts/2018-01-30-abaqus-singularity/)
[NIH tutorail](https://hpc.nih.gov/apps/apptainer.html)

Starting the container with Cadence folder available:
`apptainer shell -B /cadence:/cadence virtuoso_centos7.sif`

Okay, so I can't use the --writable option and have stuff automatically bind-mounted. Therefor in sandbox mode, I at least need to create the mountpoints manually.
No the better

```
$ apptainer build virtuoso_centos7_immut.sif virtuoso_centos7.def
$ xhost +
$ apptainer shell -B /cadence:/cadence virtuoso_centos7_immut.sif

Apptainer> /cadence/cadence/IC618/tools.lnx86/bin/checkSysConf IC6.1.8
Apptainer> /bin/tcsh /faust/user/kcaisley/cadence/tsmc65/tsmc_crn65lp_1.7a
```

On the host machine, before running the startup script, we must start a `xhost +` 
Solution found [here](https://rescale.com/documentation/main/rescale-advanced-features/running-your-custom-code-on-rescale/using-apptainer-singularity/)

I may want to look at passing the `--nv` flag when trying to do heavy layout work flows.

I think that the reason why `xdpyinfo` didn't work is because I hadn't made the xhost visible to the container.

## To find which package a utility is provided by (that isn't downloaded yet)
```
yum provides /usr/bin/xdpyinfo
```
If the package were downloaded, and if `which` were also on the system, we could do this instead:

```
yum provides `which free`
```

Anyways, we find the right package to install for it is `yum info xorg-x11-utils`

Yes, it does appear that the package is no longer missing. However, now there is no $DISPLAY env variable, so I can't test it. This is because I'm command line only for now.


check where container is running

Should I use a raid configuration?
If you buy in batches, they fail in batches. Rebuild time is large.
The sensible approach moving forward is raid6, raidz2, raiddp. (two disk partiy)

Never choose raid5. Use Raid6, raid10, raidz2, or raidz3.

'raid' is used commonly for different configs, where you combine multiple drives.
the parameters are mirroring, parity, striping, and if so, how fast? Instant or minutes after

`ZFS` and `BTRFS` are two options, which aren't 'RAID' in the traditional sense, even though people say it.

ZFS and BTRFS is a combination of a file system (based on copy-on-write COW principle) with a logical volume manager.

Btrfs is intended to address the lack of pooling, snapshots, checksums, and integral multi-device spanning in Linux file systems.

For performance, EXT4 is very fast.

In (4 drive) RAID 10, if one drive is failed, there’s a 1-in-3 chance that a second drive failure will take out the whole array. RAID 6 doesn’t have this risk.
Also, when an array has more than 4 drives RAID 6 starts to make even more sense, as you can get more useable space out of the drives while still having two-point-failure redundancy.

Hardware support for RAID has been deprecated, and so 


EXT4 on LVM is similar to BTRFS, but is two components so it is more clunky.

BTRFS has better snapshotting, and better data integrity. 

Caching and COW on 


## How to install vscode

RHEL, Fedora, and CentOS based distributions
We currently ship the stable 64-bit VS Code in a yum repository, the following script will install the key and repository:

sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
Then update the package cache and install the package using dnf (Fedora 22 and above):

dnf check-update
sudo dnf install code



## Wireguard and umask

The [umask](https://en.wikipedia.org/wiki/umask) utility is used to control the file-creation mode mask, which determines the initial value of file permission bits for newly created files. The Arch wiki has good info: https://wiki.archlinux.org/title/Umask

running `umask` shows bits, and `umask -S` in the derived permissions. Note that the bits are a mask of what should *not* be set. So 7777 - umask = chmod, sorta.

For example umask = 0022 yeilds effectively a mod = 7755, or u=rwx,g=rx,o=rx

And umask 0077 means that permission will be 7700.

#### Networking

systemd is controlled via the `systemctl` command. The networking components of it can be controlled by either `systemd-networkd` or `NetworkManager`. Both are present on a Fedora install as systemd modules, but `systmed-networkd` is still feature incomplete, and is deactivated by default.

Therefore `NetworkManager` is the standard method for controlling network interfaces. It has gnome shell integration, and provides command line control via `nmcli`. You can inspect it's service status with `systemctl status NetworkManager`. 

If we wanted to use NetworkManager with wireguard, we could follow this tutorial: https://blogs.gnome.org/thaller/2019/03/15/wireguard-in-networkmanager/

But a simpler way is to just use `wg-quick` which reads files stored at `/etc/wireguard/`

The current WireGuard configuration can be saved by utilizing the [wg(8)](https://man.archlinux.org/man/wg.8) utility's `showconf` command. For example:

```
# sudo wg showconf wg0 > /etc/wireguard/wg0.conf
```

To start a tunnel with a configuration file, use

```
# sudo wg-quick up interfacename
```

To quickly see the status of the interface is to just run the command

`# sudo wg show`

If this isn't working, it may be because `NetworkManager` is also automatically trying to control the wireguard interface. Check this section of this article: https://wiki.archlinux.org/title/WireGuard#Persistent_configuration



## VNC:

For CentO 7, this is the article that has worked:

https://linuxize.com/post/how-to-install-and-configure-vnc-on-centos-7/



# Bash:

You can set env variables in a bash script by just writing X='text', where X is the env variable name. You don't have to export.

To make sure that these are available then in the terminal session that launched it, you need to make sure you source the script, or write a '.' before the bash script name. `.` is the POSIX compliant way of sourcing, and `source` is a Bash-exclusive synonym.


#SSH
To enable SSH public key authentication on Fedora, make sure you go to /etc/ssh/sshd_config and uncomment the line PubkeyAuthentication yes.
To enable SSH-RSA (and outdated protocol) on new machines
To permit using old RSA keys for OpenSSH 8.8+, add the following lines to your sshd_config:

```
HostKeyAlgorithms=ssh-rsa,ssh-rsa-cert-v01@openssh.com
PubkeyAcceptedAlgorithms=+ssh-rsa,ssh-rsa-cert-v01@openssh.com
```


# Building specs table for each machine:

`lscpu` gives cpu info
`free -hm` gives ram info


# Find all files with certain extension:
`find . -type f -name "*.txt"`


# Find all files containing a certain string (you can add -i flag to IGNORE case)

`grep -R "text to find" .`

## 
note, when running ls -l, the second column is the number of hardlinks (which is equal to the number of directories, sorta?) anyways, i can just think of it as the approximate number of directories inside this one.

### Using Git to restore a deleted, uncommitted file:
If your changes have not been staged or committed: The command you should use in this scenario is `git restore FILENAME`
