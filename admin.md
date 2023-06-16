"Numbers everyone should know"
| Action                              | Time (ns)      | Time (ms) |
| ----------------------------------- | -------------- | --------- |
| L1 cache reference                  | 0.5 ns         |           |
| Branch mispredict                   | 5 ns           |           |
| L2 cache reference                  | 7 ns           |           |
| Mutex lock/unlock                   | 100 ns         |           |
| Main memory reference               | 100 ns         |           |
| Compress 1K bytes with Zippy        | 10,000 ns      | 0.01 ms   |
| Send 1K bytes over 1 Gbps network   | 10,000 ns      | 0.01 ms   |
| Read 1 MB sequentially from memory  | 250,000 ns     | 0.25 ms   |
| Round trip within same datacenter   | 500,000 ns     | 0.5 ms    |
| Disk seek                           | 10,000,000 ns  | 10 ms     |
| Read 1 MB sequentially from network | 10,000,000 ns  | 10 ms     |
| Read 1 MB sequentially from disk    | 30,000,000 ns  | 30 ms     |
| Send packet CA->Netherlands->CA     | 150,000,000 ns | 150 ms    |

# Admin Experiments

Untarring a 650 GB file on Penelope produces the following system usage:

>  The read/write I/O jumps to 40MB/s and 150 MB/S. But essentially no CPU or RAM  (<5%) is used.

Comparing against our Toshiba MG08 drives, which have these specs:

| Available Capacities                                      | 16 TB, 14 TB                                  |
| --------------------------------------------------------- | --------------------------------------------- |
| Form Factor                                               | 3.5-inch                                      |
| Buffer Size                                               | 512 MiB                                       |
| Rotation Speed                                            | 7200rpm                                       |
| Maximum Data Transper Speed             (Sustained)(Typ.) | 16 TB: 262 MiB/s             14 TB: 248 MiB/s |
| Power Consumption             ( Idle - A )                | SATA: 4.00W             SAS: 4.46W            |
| MTTF/MTBF                                                 | 2 500 000 h                                   |
| Weight ( Max )                                            | 720g                                          |

Thus we're using ~60% of our max transfer speed? Do we have to include Read and Write? How does Raid6 config affect this?

## Untarring a 650 GB file took the following time:
628GiB 8:13:34 [21.7MiB/s]



## Solution to slowdown, and updating

### To upgrade to new version of Fedora Server:

```
sudo dnf upgrade --refresh
sudo dnf install dnf-plugin-system-upgrade	# was already there
sudo dnf system-upgrade download --releasever=38 # may need --allow-erasing for 3rd party packages
```

[This link](https://superuser.com/questions/1470997/available-space-on-but-home-is-running-out-of-space) contains info about a similar problem, but I don't want to follow the approach of increaing the volume.

```
[asiclab@penelope home]$ sudo pvdisplay
[sudo] password for asiclab: 
  --- Physical volume ---
  PV Name               /dev/sda3
  VG Name               fedora_penelope
  PV Size               893.25 GiB / not usable 0   
  Allocatable           yes 
  PE Size               4.00 MiB
  Total PE              228672
  Free PE               224832
  Allocated PE          3840
  PV UUID               kJwKhC-leMj-VY6E-adbz-LRvT-Uczc-u1dQds
   
[asiclab@penelope home]$ sudo vgdisplay
  --- Volume group ---
  VG Name               fedora_penelope
  System ID             
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  2
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                1
  Open LV               1
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               893.25 GiB
  PE Size               4.00 MiB
  Total PE              228672
  Alloc PE / Size       3840 / 15.00 GiB
  Free  PE / Size       224832 / 878.25 GiB
  VG UUID               7pNs2s-G7fX-blRP-GDlM-YGFH-fNLa-o0v1uX
   
[asiclab@penelope home]$ sudo lvdisplay
  --- Logical volume ---
  LV Path                /dev/fedora_penelope/root
  LV Name                root
  VG Name                fedora_penelope
  LV UUID                74tyF1-DvwS-9ODy-agNq-XcAN-4OOS-MaVAU1
  LV Write Access        read/write
  LV Creation host, time penelope.physik.uni-bonn.de, 2023-01-13 18:29:57 +0100
  LV Status              available
  # open                 1
  LV Size                15.00 GiB
  Current LE             3840
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:0
```

Other useful information can be found here:

```
[asiclab@penelope home]$ df -hT
Filesystem                       Type      Size  Used Avail Use% Mounted on
devtmpfs                         devtmpfs  4.0M     0  4.0M   0% /dev
tmpfs                            tmpfs      32G     0   32G   0% /dev/shm
tmpfs                            tmpfs      13G  1.6M   13G   1% /run
/dev/mapper/fedora_penelope-root xfs        15G   15G  638M  96% /
tmpfs                            tmpfs      32G     0   32G   0% /tmp
/dev/sda2                        xfs       960M  320M  641M  34% /boot
/dev/md127                       ext4       44T  9.9T   32T  24% /mnt/md127
tmpfs                            tmpfs     6.3G  4.0K  6.3G   1% /run/user/1000

[asiclab@asiclabwin001 ~]$ df -hT	# note this is for other server
Filesystem                            Type      Size  Used Avail Use% Mounted on
devtmpfs                              devtmpfs  4.0M     0  4.0M   0% /dev
tmpfs                                 tmpfs     7.8G  1.1G  6.7G  14% /dev/shm
tmpfs                                 tmpfs     3.1G  1.3M  3.1G   1% /run
/dev/mapper/fedora_asiclabwin001-root xfs        15G  2.6G   13G  18% /
tmpfs                                 tmpfs     7.8G   48K  7.8G   1% /tmp
/dev/sda2                             xfs       960M  280M  681M  30% /boot
/dev/sda1                             vfat      599M  7.1M  592M   2% /boot/efi
tmpfs                                 tmpfs     1.6G     0  1.6G   0% /run/user/1000

```

[From this link](https://discussion.fedoraproject.org/t/root-partition-only-15gb-how-to-utilize-the-rest/71573/7): To see what file systems are mounted and how much they’re being used:

```
df -hT
```

To get an overview of all your block devices and logical volumes and where they all reside:

```
lsblk
```

When working with Logical Volumes you will see the following terms:

- PV (Physical Volume): This refers to a physical disk, or a partition  on the disk. If you used a tool like fdisk to make 2 partitions on a  disk they will show as two PVs. You can list them with the command `pvs` or get more info with `pvdisplay`
- VG (Volume Group): You add your PVs to volume groups and with will be the pool used for the logical volumes in that group. You can list your  VGs with `vgs` and get more info with `vgdisplay`
- LV (Logical Volume): This is where the magic happens. An LV can be  resized, extended, span multiple disks. Once you create an LV you would  next format it with a file system. You can list them with `lvs`` and get more info with `lvdisplay```.

To answer your question, I’d recommend extending / to like  20G and then creating a new LV for the rest of your data you plan to  store via SAMBA.

- To extend root to 20G. The `-r` option tells it to resize the file system too:

```
lvextend -L20G -r /dev/mapper/fedora_fedora-root
```

- To create a new VG called “fedora-shares”:

```
lvcreate -L 190G -n fedora-shares fedora
```

- Extend it to use the full disk:

```
lvextend -l+100%FREE /dev/mapper/fedora_fedora-shares
```

- Format is with a file system:

```
mkfs.xfs /dev/mapper/fedora_fedora-shares
```

- Create a mountpoint and add it to your /etc/fstab:

```
mkdir -p /srv/shares
echo "/dev/mapper/fedora_fedora-shares /srv/shares                    xfs     defaults        0 0" >> /etc/fstab
```

- Test it by mounting it:

```
mount -a
```

- Finally, use `df` and `lsblk` to verify the new LV is mounted and ready to use

[Why is the volume, mounted at root "\" so small, only 15GB in Fedora?](https://unix.stackexchange.com/questions/728955/why-is-the-root-filesystem-so-small-on-a-clean-fedora-37-install)

The shortcut is `lvextend -L +10G /dev/mapper/fedora_fedora-root` to make it bigger, but maybe this isn't needed?

> This is [default behaviour of Fedora Server](https://lists.fedoraproject.org/archives/list/server@lists.fedoraproject.org/thread/D7ZK7SILYDYAATRFS6BFWZQWS6KSRGDG/) -- the root filesystem will be 15 GiB and rest of the disk space is  left unused for the user to either resize the root logical volume or use for different use case (for `/var` or virtualization etc.). If you want a different storage layout, you need to use the [custom partitioning](https://docs.fedoraproject.org/en-US/fedora/f36/install-guide/install/Installing_Using_Anaconda/#sect-installation-gui-manual-partitioning) in the installer and create the mountpoints manually .
>
> One of the reasons is that the XFS filesystem used by Fedora Server  (and only server, Workstation and other flavours use btrfs) cannot be  shrunk so if the installer uses the entire free space, it will be really hard to change the default layout.
>
> If you want to resize your root filesystem you can use `lvextend -L+<size> --resizefs fedora_fedora/root`. Where `<size>` can be for example `50G` for 50 GiB.
>
> Edit: The `--resizefs` is important, without this the `lvresize` command will resize only the volume and not the filesystem on it. If you run `lvresize` without the `--resizefs` option you can resize the filesystem afterwards with `xfs_growfs /dev/mapper/fedora_fedora-root`.
>
> It’s possibly worth also  noting that 15GB is not really all that ‘small’ either for a root  filesystem. Not counting application data and swap space, it’s not  unusual for a server system to need less than 4 GB of disk space. Fedora will run just fine in that 15GB of space as long as you split out  application data properly and make sure old logs are getting cleaned up.

Alrighty, so looking at my files, I should just figure out where the 15GB are being used. At least in my ~/home/asiclab directory, I have the large apptainer file. Also, looking at `/var` I see lots of big stuff!

```
[asiclab@penelope ~]$ sudo du -sh bag3++_centos7.sif
3.7G	bag3++_centos7.sif

[asiclab@penelope ~]$ sudo du -shc /var/*
0	/var/account
0	/var/adm
0	/var/apptainer
507M	/var/cache
0	/var/crash
0	/var/db
0	/var/empty
0	/var/ftp
0	/var/games
0	/var/kerberos
2.2G	/var/lib
0	/var/local
0	/var/lock
1.8G	/var/log
0	/var/mail
0	/var/nis
0	/var/opt
0	/var/preserve
0	/var/run
2.5M	/var/spool
248M	/var/tmp
0	/var/yp
4.7G	total
```

Okay, and checking /var/ showed the biggest thing is my journal:

```
4.6G	/var
2.2G	/var/lib
1.7G	/var/log
1.5G	/var/log/journal/2a72480699d641d881e7666c5429fb5e
1.5G	/var/log/journal
1.1G	/var/lib/plocate
1.1G	/var/lib/dnf/system-upgrade
1.1G	/var/lib/dnf
630M	/var/lib/dnf/system-upgrade/updates-b7ba662710b98f1a
617M	/var/lib/dnf/system-upgrade/updates-b7ba662710b98f1a/packages
```

An confirming this:

````
[asiclab@penelope 2a72480699d641d881e7666c5429fb5e]$ journalctl --disk-usage
Archived and active journals take up 1.4G in the file system.
````

The files from `/var/log/journal` directory can be removed.

The nicest method I've found is:

```bsh
sudo journalctl --vacuum-size=100M
```

which deletes old log-files from `/var/log/journal` until total size of the directory becomes under specified threshold (500 megabytes in this example).

> Vacuuming done, freed 1.3G of archived journals from /var/log/journal/2a72480699d641d881e7666c5429fb5e.

Sweet! Making it [permanent](https://unix.stackexchange.com/questions/130786/can-i-remove-files-in-var-log-journal-and-var-cache-abrt-di-usr/130802#130802)

Wow, wait [this article](https://developers.redhat.com/blog/2020/12/10/how-to-clean-up-the-fedora-root-folder#common_cleanable_folders) pretty much contains everything I needed, in the first place!

https://superuser.com/questions/1470997/available-space-on-but-home-is-running-out-of-space

https://serverfault.com/questions/848914/how-to-reconfigure-dev-mapper-space

https://unix.stackexchange.com/questions/728955/why-is-the-root-filesystem-so-small-on-a-clean-fedora-37-install

> LVM is somewhat different from regular partitions. With regular  partitions resizing is a PITA because they must be contigious. LVM  logical volumes do not have to be contiguous so you can have multiple  logical volumes and expand them as and when needed.

### Returning to the DNF upgrade

https://docs.fedoraproject.org/en-US/quick-docs/dnf-system-upgrade/

Installed the new version for Fedora, which took like 25 minutes to reboot. Auto-removed some old packages. Left the two older kernel versions alone, as they only take up like 300MB total.

Now checking:

```
[asiclab@penelope ~]$ df -hT
Filesystem                       Type      Size  Used Avail Use% Mounted on
devtmpfs                         devtmpfs  4.0M     0  4.0M   0% /dev
tmpfs                            tmpfs      32G     0   32G   0% /dev/shm
tmpfs                            tmpfs      13G  1.6M   13G   1% /run
/dev/mapper/fedora_penelope-root xfs        15G   12G  3.2G  79% /
tmpfs                            tmpfs      32G     0   32G   0% /tmp
/dev/sda2                        xfs       960M  323M  638M  34% /boot
/dev/md127                       ext4       44T  9.9T   32T  24% /mnt/md127
tmpfs                            tmpfs     6.3G  4.0K  6.3G   1% /run/user/1000
```

We can do better. `/var/lib/plocate` is 1.1G. Its a database of all files in your root directory. It is used by  locate utility. It's big because I have a whole CentOS7 container in my home directory.

Cleaning it with `sudo updatedb` then cleaned the size of plocate directory.

# Doubling server speed, with network bonding?

https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/configuring_and_managing_networking/configuring-network-bonding_configuring-and-managing-networking

https://jfearn.fedorapeople.org/fdocs/en-US/Fedora/20/html/Networking_Guide/sec-Using_Channel_Bonding.html

https://docs.fedoraproject.org/en-US/fedora-coreos/sysconfig-network-configuration/


# Hardware settings and config

The older machines are Lenovo E30 machines, wtih a IS6XM mother board, with a i7-2600 CPU. The 256 SSH should be connected to the first sata port: SATA 1. In the boot configuration, the USB key should be first, and SSD should be second. BIOS updates can be found here:
https://support.lenovo.com/my/en/downloads/DS018245

Press CTRL ALT delete to get back to spalsh screen from error 1962. Ideally I would enable Compatibility Support Module (CSM) but I guess this isn't supporoted in my bios version.

This answer indicates I probably need to update the BIOS: https://askubuntu.com/questions/1414366/no-operating-system-found-after-clean-install-of-ubuntu-22-04

`fdisk` and `gdisk` could be a good way to examine the structure of the boot disk. I need to understand what a EFI partition is.

The reason this process worked on asiclab00 is because it has slightly older firmware, I belive, and it didn't install a EFI partition. It installed as a legacy system. I don't think this can be done on 

Note that fwupgrade requires UEFI, and 


sudo efibootmgr -c -L "Windows Boot Manager" -l "\EFI\fedora\grubx64.efi"
sudo efibootmgr -c -d /dev/sdX -p Y -L "Windows Boot Manager" -l "\EFI\path\file.efi"
sudo efibootmgr -c -d /dev/sda1 -p 1 -L "Windows Boot Manager" -l "\EFI\boot\grubx64.efi"

default is sda so, -d flat isn't really needed. Also default partition -p is 1 so also not needed

The command that appears to work, assuming /dev/sda1 is the partition of interest:

sudo efibootmgr -c -L "Windows Boot Manager" -l "\EFI\fedora\shimx64.efi"

https://forums.fedoraforum.org/showthread.php?317210-EFI-boot-issues-Lenovo-AIO-Error-1962-No-Operating-System-Found
https://unix.stackexchange.com/questions/324753/pernicious-1962-error-installing-fedora-server-24-no-operating-system-found
https://www.reddit.com/r/ManjaroLinux/comments/e682d6/fixing_lenovos_error_code_1962_by_spoofing_the/
https://superuser.com/questions/913779/how-can-i-know-which-partition-is-efi-system-partition


make sure I can still ping asiclb010, as this is yannik's machine?
