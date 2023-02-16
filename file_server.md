# Base Drive Configurtion

Could have used BTRFS as it has built-in volume management, but EXT4 - LVM combination is simple and good enough for our uses

`mount`
`mkfs.ext4`


# some basic justification as to why RAID6 was chosen

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

# Raid Array



Tutorial for creating RAID6 array:

https://www.digitalocean.com/community/tutorials/how-to-create-raid-arrays-with-mdadm-on-ubuntu-22-04

lsblk

sudo mdadm --create --verbose /dev/md/0 --level=6 --raid-devices=5 /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf

sudo mdadm --query /dev/md/0

array will take time to mirror, but in the mean time can be used. Monitor with: `cat /proc/mdstat`



sudo mkfs.ext4 -F /dev/md/0



## Mounting

# NFS Server

## Remirror to Export
`mount`

Mounting points /cadence and /faust/user


# Backup System for File Server
We use IBM Spectrum Protect (SP), provided by the HRZ to backup our Penelope file server. The services comes with an annual fee, based on the used data volume.

## Installation
The setup procedure for the IBM Tivoli Sorage Manager software (old name for IBM SP) is described on the HRZ Confluence page: https://confluence.team.uni-bonn.de/display/HRZDOK/Einrichtung#. Here's a short summary:

1. Download latest TSM client from http://www-01.ibm.com/support/docview.wss?rs=663&uid=swg21239415 or  
   `wget ftp://ftp.software.ibm.com/storage/tivoli-storage-management/patches/client/v8r1/Linux/`

2. Unpack installation archive  
   `tar -xvf [filename.tar]`

3. Installation (in this order)  
   `rpm -ivh gskcrypt*`  
   `rpm -ivh gskssl64*`  
   `yum localinstall TIVsm-API64.x86_64.rpm`  
   `rpm -ivh TIVsm-BA.x86_64.rpm`  
   `rpm -ivh TIVsm-APIcit.x86_64.rpm`  
   `rpm -ivh TIVsm-BAcit.x86_64.rpm`  

## Configuration
1. Navigation in installation directory  
  `cd /opt/tivoli/tsm/client/ba/bin`

2. Create the file "dsm.opt" and add the configurations  
  `sudo vi dsm.opt`  
  insert the following lines (Ctrl + Shift + V)  
    ```
    Servername tsm3.rhrz.uni-bonn.de
    Domain all-local
    Subdir yes
    ```
3. Create the file "dsm.sys" and insert the following configuration  
   `sudo vi dsm.sys`
   Insert the following lines (Str + Shift + V) but replace *[nodename]* with the name assigned by HRZ 
     ```
    Servername tsm3.rhrz.uni-bonn.de
    CommMethod tcpip
    TCPPort 1500
    TCPClientPort 1501
    WEBPorts 1501,0
    NODEname [nodename]
    TCPServeraddress tsm2.rhrz.uni-bonn.de
    PASSWORDAccess generate
    INCLEXCL /opt/tivoli/tsm/client/ba/bin/dsm.excl_incl
    SCHEDLOGNAME /var/log/tsm/dsmsched.log
    ERRORLOGNAME /var/log/tsm/dsmerror.log
    SCHEDLOGRETENTION 7 S
    ERRORLOGRETENTION 7 S
    schedmode prompted
    managedservices schedule
     ```
4. Create Include/Exclude file (leave empty, or read more here)  
   `sudo touch /opt/tivoli/tsm/client/ba/bin/dsm.excl_incl`

5. Running the command line programme  
   `sudo dsmc`

6. Change password  
  `sudo dsmc set passsword [old passwort] [new passwort]`

Include list etc ... TBC


# General Commands for Checking Drives
`lsblk` command is useful for this.






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





### Older, potentially redundat notes:

## automatically mount files system

$ sudo vim /etc/fstab

Add lines:
`penelope.physik.uni-bonn.de:/export/disk/users /faust/user nfs4 defaults 0 0`
`penelope.physik.uni-bonn.de:/export/disk/cadence /cadence nfs4 ro 0 0`

options for the mounting drives are: https://help.ubuntu.com/community/Fstab#Options
`https://wiki.archlinux.org/title/Fstab`





## tutorial to write

make sure primary group is 'faust', else nobody permission will happen
https://unix.stackexchange.com/questions/186568/what-is-nobody-user-and-group


The nobody user is a pseudo user in many Unixes and Linux distributions, which is used to represent the user/group with the lowest permissions. In the best case that user and its group are not assigned to any file or directory (as owner). One application that makes use of this group through is NFS. If the owner of a file or directory in a mounted NFS share doesn't exist at the local system, it is replaced by the nobody user and its group.

Take back any files that have been made under user or personal group name, and assign them to faust



Note: the general status of the penelope server can be found by checking the webserver status page.
