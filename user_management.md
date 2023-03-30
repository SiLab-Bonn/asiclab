## Short Term Method for Adding a User to Fedora

```
# create groups
sudo groupadd -g 200 faust
sudo groupadd -g 1001 icdesign
sudo groupadd -g 1003 tsmcpdk
sudo groupadd -g 1004 tsmcpdk28

# create user
sudo useradd -u 37838 -g faust --no-create-home -d /faust/user/kcaisley kcaisley

# add user to groups
sudo usermod -a -G icdesign kcaisley
sudo usermod -a -G tsmcpdk kcaisley
sudo usermod -a -G tsmcpdk28 kcaisley
sudo usermod -a -G wheel kcaisley

# change user password
sudo passwd kcaisley
```




## LDAP Client

To ping a remote LDAP server and see the users it's providing from a Fedora Linux clientfirst install the ldapsearch tool on your Fedora client if it's not already installed. You can do this by running the following command:

```
sudo dnf install -y openldap-clients sssd sssd-ldap nss-pam-ldapd sssd-common
```

```
authconfig --enableldap --enableldapauth --ldapserver=noyce.physik.uni-bonn.de --ldapbasedn=dc=faust,dc=de --enablerfc2307bis --enableforcelegacy --update
```

```
sudo authselect list
sudo authselect select sssd
sudo vim /etc/sssd/sssd.conf
```

Create and fill out `/etc/sssd/sssd.conf` with:

```
[domain/default]
id_provider = ldap
auth_provider = ldap
ldap_uri = ldap://noyce.physik.uni-bonn.de
ldap_search_base = dc=faust,dc=de
cache_credentials = True

[sssd]
services = nss, pam
domains = default

[nss]
homedir_substring = /faust/user
```

Then `sudo vim /etc/openldap/ldap.conf`

```
# See ldap.conf(5) for details
# This file should be world readable but not world writable.

BASE    dc=faust,dc=de
URI     ldap://noyce.physik.uni-bonn.de

#SIZELIMIT      12
#TIMELIMIT      15
#DEREF          never

# When no CA certificates are specified the Shared System Certificates
# are in use. In order to have these available along with the ones specified
# by TLS_CACERTDIR one has to include them explicitly:
#TLS_CACERT     /etc/pki/tls/cert.pem

# System-wide Crypto Policies provide up to date cipher suite which should
# be used unless one needs a finer grinded selection of ciphers. Hence, the
# PROFILE=SYSTEM value represents the default behavior which is in place
# when no explicit setting is used. (see openssl-ciphers(1) for more info)
#TLS_CIPHER_SUITE PROFILE=SYSTEM

# Turning this off breaks GSSAPI used with krb5 when rdns = false
SASL_NOCANON    on
```

finally

```
sudo authselect apply-changes
systemctl restart sssd
systemctl enable sssd
```


to check contents of LDAP server:
```
ldapsearch -x -H ldap://noyce.physik.uni-bonn.de -b dc=faust,dc=de
```


[nss] [cache_req_common_process_dp_reply] (0x3f7c0): [CID#265] CR #557: Could not get account info [1432158212]: SSSD is offline


[asiclab@asiclab008 ~]$ sudo systemctl status sssd
● sssd.service - System Security Services Daemon
     Loaded: loaded (/usr/lib/systemd/system/sssd.service; enabled; preset: enabled)
     Active: active (running) since Tue 2023-03-28 16:26:27 CEST; 12min ago
   Main PID: 868 (sssd)
      Tasks: 4 (limit: 76850)
     Memory: 56.6M
        CPU: 338ms
     CGroup: /system.slice/sssd.service
             ├─868 /usr/sbin/sssd -i --logger=files
             ├─922 /usr/libexec/sssd/sssd_be --domain default --uid 0 --gid 0 --logger=files
             ├─939 /usr/libexec/sssd/sssd_nss --uid 0 --gid 0 --logger=files
             └─940 /usr/libexec/sssd/sssd_pam --uid 0 --gid 0 --logger=files

Mar 28 16:26:26 fedora systemd[1]: Starting sssd.service - System Security Services Daemon...
Mar 28 16:26:26 fedora sssd[868]: Starting up
Mar 28 16:26:26 fedora sssd_be[922]: Starting up
Mar 28 16:26:27 fedora sssd_nss[939]: Starting up
Mar 28 16:26:27 fedora sssd_pam[940]: Starting up
Mar 28 16:26:27 fedora systemd[1]: Started sssd.service - System Security Services Daemon.
Mar 28 16:26:51 asiclab008.physik.uni-bonn.de sssd_be[922]: Could not start TLS encryption. unknown error
Mar 28 16:28:15 asiclab008.physik.uni-bonn.de sssd_be[922]: Backend is online


SEE ALSO
       sssd(8), sssd.conf(5), sssd-ldap(5), sssd-krb5(5), sssd-simple(5), sssd-ipa(5), sssd-ad(5), sssd-files(5), sssd-sudo(5), sssd-session-recording(5), sss_cache(8),
       sss_debuglevel(8), sss_obfuscate(8), sss_seed(8), sssd_krb5_locator_plugin(8), sss_ssh_authorizedkeys(8), sss_ssh_knownhostsproxy(8), sssd-ifp(5), pam_sss(8).  sss_rpcidmapd(5)
       sssd-systemtap(5)

AUTHORS
       The SSSD upstream - https://github.com/SSSD/sssd/








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
