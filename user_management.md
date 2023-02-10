# Users and Groups List

# Local Users and Groups

# LDAP User and Groups

## LDAP Server

## LDAP Client






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





## After users are locally created, and login, check the umask bit to make sure they are creating files properly:

umask

The [umask](https://en.wikipedia.org/wiki/umask) utility is used to control the file-creation mode mask, which determines the initial value of file permission bits for newly created files. The Arch wiki has good info: https://wiki.archlinux.org/title/Umask

running `umask` shows bits, and `umask -S` in the derived permissions. Note that the bits are a mask of what should *not* be set. So 7777 - umask = chmod, sorta.

For example umask = 0022 yeilds effectively a mod = 7755, or u=rwx,g=rx,o=rx

And umask 0077 means that permission will be 7700.