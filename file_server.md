# Client NFS Mounting

```
$ cd /
$ sudo mkdir users
$ sudo mkdir tools

$ sudo vim /etc/fstab
penelope.physik.uni-bonn.de:/export/disk/users /users nfs4 defaults 0 0
penelope.physik.uni-bonn.de:/export/disk/tools /tools nfs4 ro 0 0

# To remount 
sudo systemctl daemon-reload
sudo mount -a
```

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

## Integrity check
The RAID array should be checked on a regular basis to detect emerging issues early. This can be handled by a cron job, but the Fedora default method is systemd.
   ```
   sudo systemctl list-timers --all
   ```
   lists the active timers.

In our case, we are interested in `raid-check.timer` which we can edit with  
   ```sudo systemctl edit raid-check.timer```

For example, the entry `OnCalendar=*-*-* Fri 19:00:00/4w` schedules a check on Friday at 19:00 every 4 weeks.

The change is applied with
   ```
   sudo systemctl daemon-reload
   sudo systemctl restart raid-check.timer
   ```

To turn the automatic check off, run the following commands:
   ```
   sudo systemctl stop raid-check.timer
   sudo systemctl disable raid-check.timer
   sudo systemctl daemon-reload
   sudo systemctl restart raid-check.timer
   ```

# NFS Server

## Remirror to Export
`mount`

Mounting points /cadence and /faust/user


# Backup System for File Server
We use IBM Spectrum Protect (SP), provided by the HRZ to backup our Penelope file server. The services comes with an annual fee, based on the used data volume.
Email notifications will be sent to the contacts after each scheduled activity.

## Installation
The setup procedure for the IBM Tivoli Sorage Manager software (old name for IBM SP) is described on the HRZ Confluence page: https://confluence.team.uni-bonn.de/display/HRZDOK/Einrichtung#. Here's a short summary:

1. Download latest TSM client from http://www-01.ibm.com/support/docview.wss?rs=663&uid=swg21239415 or  
   ```bash
   wget ftp://ftp.software.ibm.com/storage/tivoli-storage-management/patches/client/v8r1/Linux/
   ```

3. Unpack installation archive  
   ```bash
   tar -xvf [filename.tar]
   ```

5. Installation (in this order) #todo: Change to dnf
   ```bash
      rpm -ivh gskcrypt*
      rpm -ivh gskssl64*
      yum localinstall TIVsm-API64.x86_64.rpm 
      rpm -ivh TIVsm-BA.x86_64.rpm
      rpm -ivh TIVsm-APIcit.x86_64.rpm 
      rpm -ivh TIVsm-BAcit.x86_64.rpm
   ```


## Configuration
1. Navigation in installation directory  
    ```cd /opt/tivoli/tsm/client/ba/bin```

2. Create the file "dsm.opt" and add the configurations  
   ```sudo vi dsm.opt```
  
    Insert the following lines (Ctrl + Shift + V)  
    ```
    Servername tsm3.rhrz.uni-bonn.de
    Domain all-local
    Subdir yes
    ```

3. Create the file "dsm.sys" and insert the following configuration  
    ```sudo vi dsm.sys```
   
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
   ```sudo touch /opt/tivoli/tsm/client/ba/bin/dsm.excl_incl```

5. Running the command line programme  
   ```sudo dsmc```

6. Change password  
    ```sudo dsmc set passsword [old passwort] [new passwort]```


## Include/exclude list
Next we have to define which files and folder to be backed up. This is managed with the file ´/opt/tivoli/tsm/client/ba/bin/dsm.excl_incl´ as  defined in ´dsm.sys´.

Allowed statements are

   Include/Exclude | Statement Options
   --- | ---
   include | Includes files in backup
   exclude | Exclude files from backup. Exclude a directory including all subdirectories and files it contains.
   exclude.dir | Subdirectories and files. It is not possible to include options to override exclude.dir
   exclude.fs | Exclude a file system

Example: If we want to backup the /home directory but exclude the asiclab user, we would define
   ```
   include /home/*
   exclude /home/asiclab/*
   ```


## Commands for data store and restore
Start by ```sudo dsmc```. Enter in command line after prompt Protect>. This is only a subset. Partitions can also be saved and restored, but this seems to be less relevant for us.


### Data backup
1. Save the whole folder   
   ```incr /[path]/* ```

2. Back up individual files   
   ```incr /[path]/[file] ```


Example of a backup procedure:

   ```
   Protect> incr /mnt/md127/vm/* -su=yes

   Incremental backup of volume '/mnt/md127/vm/*'
   Successful incremental backup of '/mnt/md127/vm/*'

   Total number of objects inspected:            5
   Total number of objects backed up:            0
   Total number of objects updated:              0
   Total number of objects rebound:              0
   Total number of objects deleted:              0
   Total number of objects expired:              0
   Total number of objects failed:               0
   Total number of objects encrypted:            0
   Total number of objects grew:                 0
   Total number of retries:                      0
   Total number of bytes inspected:          11.69 GB
   Total number of bytes transferred:            0  B
   Data transfer time:                        0.00 sec
   Network data transfer rate:                0.00 KB/sec
   Aggregate data transfer rate:              0.00 KB/sec
   Objects compressed by:                        0%
   Total data reduction ratio:              100.00%
   Elapsed processing time:               00:00:01
   ```



### Query for data backup
1. Includes/Excludes   
   ```bash
   q inclexcl
   ```

2. Files   
   ```bash
   q ba /[path]/* -subdir=yes
   ```
   
### Restore data
When restoring data, make a concious decision about the destination path. Most of the times, it is better to restore data to a temporary folder instead of the original location.
1. Individual files   
   ```bash
   rest /[source-path]/[soruce-file]
   ```

2. Multiple files, folders and partitions   
   ```bash
   rest /[source-path]/* /[destination-path]/ -su=yes
   ```
   
3. Display what is backed up on TSM nodes (and subsequent restore to second folder path when files are selected)
   ```bash
   restore -subdir=yes -pick "/*" "/[destination-path]/"
   ```

   In this mode, you can interactivly browse the backup and select folders and files.
   Example:
   ```
   restore -subdir=yes -pick "/mnt/md127/vm/*" "/tmp/restore-test/"
   
   Scrollable PICK Window - Restore
   
        #    Backup Date/Time        File Size A/I  File
           ----------------------------------------------------------------------------------------------------------------
        1. | 03/03/2023 13:29:47       4.00 KB  A   /mnt/md127/vm
        2. | 03/03/2023 13:29:47       5.00 GB  A   /mnt/md127/vm/noyce.physik.uni-bonn.de-disk1-2022-11-09.img
        3. | 03/03/2023 13:29:47       4.00 KB  A   /mnt/md127/vm/tests
        4. | 03/03/2023 13:31:16       5.00 GB  A   /mnt/md127/vm/tests/noyce.physik.uni-bonn.de-disk1.img
        5. | 03/03/2023 13:32:42       1.69 GB  A   /mnt/md127/vm/tests/noyce.physik.uni-bonn.de-disk1.qcow2
           |
           |
           |
           |
           |
           |
           |
           |
           |
           |
           |
           |
           |
           |
           |
           |
           0---------10--------20--------30--------40--------50--------60--------70--------80--------90--------100-------11
   <U>=Up  <D>=Down  <T>=Top  <B>=Bottom  <R#>=Right  <L#>=Left
   <G#>=Goto Line #  <#>=Toggle Entry  <+>=Select All  <->=Deselect All
   <#:#+>=Select A Range <#:#->=Deselect A Range  <O>=Ok  <C>=Cancel
   pick>
   ```
   
   If the files already exist in the destination, you will be prompted to descide whether you want to replace or skip the object in questions.
   ```
   --- User Action is Required ---
   File '/tmp/restore-test/vm/tests/noyce.physik.uni-bonn.de-disk1.img' exists
   
   Select an appropriate action
     1. Replace this object
     2. Replace all objects that already exist
     3. Skip this object
     4. Skip all objects that already exist
     A. Abort this operation
   Action [1,2,3,4,A] :
   ```








## Raid Server management

`lsblk` command is useful foor checking drive names

mdadm  `--query` option

Free space
`df -h`

Used space
`du (??options?)`

List Hardware devices:
`lsblk`

To check the status of current NFS or SMB shares, use the following (TYPE = nfs4, smb, autofs,cifs,etc)
`mount -l -t TYPE`



# Software Raid Re-Setup:
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

The `-p` creates necessary parent directories.

`sudo mount --bind /mnt/md0/ /export/disk/`     (using bind mount, rather than regular, as we both locations must be readable, rather than one being a /dev/ location)

this is bad form, one should instead add both the ext4 mount and the bind mount to the /etc/fstab file:

`sudo vim /etc/fstab`

```
/dev/md127 /mnt/md127 ext4 defaults,nofail,discard 0 0
/mnt/md127/users /export/disk/users none bind

# old bind for tools
/mnt/md127/tools /export/disk/cadence none bind

# new bind mount for tools
/mnt/md127/tools /export/disk/tools none bind
```

After saving, make sure to restart the systemctl daemon and remount:

```
sudo systemctl daemon-reload
sudo mount -a
```

5. Properly set permissions of export directory before exporting:

6. Now that our directory to be exported is availalb, we must create/config the  `/etc/exports` NFS file: (don't use the last location, as it is just for backups)

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

#### Updated mount points:



```
cd /
sudo mkdir users
sudo mkdir tools

penelope.physik.uni-bonn.de:/export/disk/users /users nfs4 defaults 0 0
penelope.physik.uni-bonn.de:/export/disk/tools /tools nfs4 ro 0 0
```




## tutorial to write

make sure primary group is 'faust', else nobody permission will happen
https://unix.stackexchange.com/questions/186568/what-is-nobody-user-and-group


The nobody user is a pseudo user in many Unixes and Linux distributions, which is used to represent the user/group with the lowest permissions. In the best case that user and its group are not assigned to any file or directory (as owner). One application that makes use of this group through is NFS. If the owner of a file or directory in a mounted NFS share doesn't exist at the local system, it is replaced by the nobody user and its group.

Take back any files that have been made under user or personal group name, and assign them to faust



Note: the general status of the penelope server can be found by checking the webserver status page.

# Trying to debug slow speeds on NFS server.

Programs like Typora take forever to open on an NFS user, but with local users is very fast.

Read first about Raid Array Speeds: https://www.raid-calculator.com/raid-types-reference.aspx

Our 5 disk, 14.6TB per disk machine in Raid 6 has:

Capacity	43.8 TB
Speed gain	3x read speed, no write speed gain
Fault tolerance	2-drive failure



On the server side: https://linux.die.net/man/5/exports



When mounting: noatime: Setting this value disables the NFS server from updating the inodes access time. As most applications do not necessarily need this value, you can safely disable this updating.

nocto: Suppress the retrieval of new attributes when creating a file.


This page has lots of things tried: https://serverfault.com/questions/682000/nfs-poor-write-performance









the below text was moved from 'remote connection'

# SiRUSH SMB Server

Sirrush is shared via smb. You can simply use a file manager and go to smb://sirrush.physik.uni-bonn.de and log in with silab/pidub12. One can only access the `/silab` directory with this login. If you also want
to access project folder, an account has to be made for you.


# SFTP

# Samba

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
