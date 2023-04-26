## TL;DR Short-Term Approach for Setting up New Fedora Machine

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

## Managing Users and Groups:

Root is disabled as a login user on Fedora. The `asiclab` account, with `UID = 1000` and `GID = 1000` should be created as the default local account on the machine.

### To list all users on a machine
Listing users on a machine

This can mean different things:
1) The files for which the UID is set to a certain number.
2) The accounts defined for login in /etc/passwd
3) The groups of UIDs that own all the folders in a home directory

Approach 1 and 2 can be done via:

```
cat /etc/passwd
```

### To check groups of a user

```
groups kcaisley
```

### To check full group and user info of user
```
id kcaisley
```

You can omit username for current user.

### To check all members in a group
```
getent groups icdesign
```

### To list all groups, and their members
Groups can be supplied from both `/etc/group` and from LDAP. The combination of both these will be show in:

```
getent group
```

### To add a group with gid
```
sudo groupadd -g 1001 icdesign
```

When you add users to a group, using the `-g` commands makes it the users primary group, where as the `-G` flag makes it a secondary group. The primary group is the default GID assigned newly created or copied files.

### To delete a group:
```
sudo groupdel kcaisley
```

### To change the UID of a user

```
sudo usermod -u 2002 kcaisley
```

### To change the GID of a group

```
sudo groupmod -g 1001 icdesign
```

### To create a group in linux

```
sudo usermod -a -G groupname username
```

### To become another user

```
su – <username>
```

### To change a user's password

```
passwd kcaisley
```

### To recursively change all UID and GID set on files in a directory

```
chown -R ownername:groupname foldername
```

The `groupname` can be omitted if not desired.

### Listing GIDs and UIDs and permissions of Files

```
ls -la
```

When running `ls -l`, the second column is the number of hardlinks (which is equal to the number of directories, sorta?) Anyways, I can just think of it as the approximate number of directories inside this one.

### To recursively change file permission

`chown` command doesn't work recursively on hidden files, and so using `chmod` is the best approach. This affects everything in the current working directory and below.

```
sudo chmod -R 775 .
```


### To enable Wheel Group (replacement for sudoers)

Tutorial: [Adding a user to sudoers and wheel group](https://docs.fedoraproject.org/en-US/quick-docs/adding_user_to_sudoers_file/)

On Fedora, it is the wheel group the user has to be added to, as this group has full admin privileges. Add a user to the group using the following command:
sudo usermod -aG wheel username

If adding the user to the group does not work immediately, you may have to edit the /etc/sudoers file to uncomment the line with the group name:
```
$ sudo visudo
...
%wheel ALL=(ALL) ALL
...
```

Then logout and back in again.


### To set the default permissions for new files

After users are locally created, and login, check the umask bit to make sure they are creating files properly:

```
umask
```

The [umask](https://en.wikipedia.org/wiki/umask) utility is used to control the file-creation mode mask, which determines the initial value of file permission bits for newly created files. [This page](https://wiki.archlinux.org/title/Umask) on the Arch wiki has good info. 

running `umask` shows bits, and `umask -S` in the derived permissions. Note that the bits are a mask of what should *not* be set. So 7777 - umask = chmod, sorta.

For example umask = 0022 yeilds effectively a mod = 7755, or u=rwx,g=rx,o=rx

And `umask 0077` means that permission will be `7700`

## FreeIPA Setup:

Starting from Fresh Fedora install

```
sudo firewall-cmd --add-service=freeipa-4 --permanent
sudo dnf install freeipa-server
```

Accept all defaults usering ENTER, and at the end type 'yes' to accept to proposed settings.

https://serverfault.com/questions/1069847/how-should-we-automount-home-directories-stored-at-different-nfs-paths-at-home

how does the homedir work?

https://www.freeipa.org/page/Quick_Start_Guide#Web_User_Interface

LDAP or freeipa will only be a source for account information: username, password, address, fax number, home directory location. Similar to a phone book. To get file "sync" you need a network home directory provided by something like NFS (or SMB if you want Windows support). Create a share on one machine, (for me this is /space/homedirs/$username), mount it on all of your other machines in the same place, and set your homedir in LDAP to be that new location.

Combine this with autofs, which you can also manage in FreeIPA, it will mount your homedir from NFS only when required, and when logged off it unmounts the NFS share. I hate stuck NFS mounts. But don't use 'softmounts' This can introduce silent data corruption.

This explains the difference between [hard and soft mounts](https://forums.centos.org/viewtopic.php?t=8787)

#### Some potential firewall fixes, in case there are probs:

https://kenmoini.com/post/2022/04/qnap-nfs-home-directories/

```bash
## Enable Firewalld
systemctl enable --now firewalld

## [Optional] Enable Cockpit
systemctl enable --now cockpit.socket

## Open the needed Firewall ports
firewall-cmd --add-service=cockpit --permanent
firewall-cmd --add-service=dns --permanent
firewall-cmd --add-service=freeipa-ldap --permanent
firewall-cmd --add-service=freeipa-ldaps --permanent
firewall-cmd --add-service=http --permanent
firewall-cmd --add-service=https --permanent
firewall-cmd --add-service=ssh --permanent
firewall-cmd --add-port=88/tcp --permanent
firewall-cmd --add-port=88/udp --permanent
firewall-cmd --add-port=464/tcp --permanent
firewall-cmd --add-port=464/udp --permanent
firewall-cmd --add-port=8080/tcp --permanent
```



#### An in depth look at IPA/NFS home directories:

https://blog.khmersite.net/2020/09/automating-home-directory-with-ipa/



##### Adding clients to FreeIPA domain

https://fedoramagazine.org/join-fedora-linux-enterprise-domain/

```bash
sudo realm join asiclabwin001.physik.uni-bonn.de -v
```

authenticate as admin account.




## Sketch of Planned UIDs and GIDs

```
UID:
asiclab         1000 (local on each computer)
user1           2001
user2           2002
user3           2003  ...etc

GID:
asiclab         1000    (just local asiclab user on each computer)
base 	      	1001    (all user directories, and default setting in tools directory)
icdesign        1002    (access to cadence/mentor/synonsys tools)
tsmc65          1003
tsmc28          1004
```




## SSSD Client with LDAP Provider

To ping a remote LDAP server and see the users it's providing from a Fedora Linux clientfirst install the ldapsearch tool on your Fedora client if it's not already installed. You can do this by running the following command:

```
sudo dnf install -y openldap-clients sssd sssd-ldap nss-pam-ldapd sssd-common
```

Also, you may need package `openssl`

Also, be sure to get the `sssctl` command. I can't recall what package providers it. Maybe sssctl-tools or something?


Old command from Piotr

```
authconfig --enableldap --enableldapauth --ldapserver=noyce.physik.uni-bonn.de --ldapbasedn=dc=faust,dc=de --enablerfc2307bis --enableforcelegacy --update
```

New command:

```
authselect apply-changes
sudo sssctl {config-check,domain-list,user-show,user-checks, debug-level 0x0070, cache-remove,}
sudo authselect list
sudo authselect select sssd
sudo vim /etc/sssd/sssd.conf
sudo vim /etc/openldap/ldap.conf    # but I think this doesn't apply to our client side?
id kcaisley
man {many differe docs!}
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



My final config:

```
[domain/default]
id_provider = ldap
auth_provider = ldap
ldap_uri = ldap://noyce.physik.uni-bonn.de
ldap_search_base = dc=faust,dc=de
ldap_group_search_base = ou=group,dc=faust,dc=de
ldap_tls_reqcert = never
ldap_schema = rfc2307bis
ldap_default_bind_dn = cn=root,dc=faust,dc=de
ldap_default_authtok_type = password
ldap_default_authtok = %Silab246%
cache_credentials = true

[sssd]
config_file_version = 2
services = nss, pam
domains = default

[nss]
homedir_substring = /faust/use
```


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

misc commands:

```
sudo cat /var/log/sssd/sssd.log
sudo cat /var/log/sssd/sssd_nss.log
sudo cat /var/log/sssd/sssd_pam.log
man sssd-ldap
```




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
```
