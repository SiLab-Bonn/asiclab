# Wireguard

As of Fedora 38, which is built on Gnome 44, you can simply import Wireguard `.conf` files directly in the Settings application, under the Network tab.


## Use with wg-quick

## Use in Network Manager
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






# SSH

To enable SSH public key authentication on Fedora, make sure you go to /etc/ssh/sshd_config and uncomment the line PubkeyAuthentication yes.
To enable SSH-RSA (and outdated protocol) on new machines
To permit using old RSA keys for OpenSSH 8.8+, add the following lines to your sshd_config:

```
HostKeyAlgorithms=ssh-rsa,ssh-rsa-cert-v01@openssh.com
PubkeyAcceptedAlgorithms=+ssh-rsa,ssh-rsa-cert-v01@openssh.com
```

Note: If you're trying to connect to, or from an older system, you may run into issues where the version keys supported is deprecated. I found a solution to this, which Lise has in her Github issues.

## Server Start
sudo systemctl enable sshd
sudo systemctl start sshd


## SSH Key Gen

## SSH Config


# X11 Forwarding

# VNC

For CentO 7, this is the article that has worked:

https://linuxize.com/post/how-to-install-and-configure-vnc-on-centos-7/

# RDP


### enable and connect via RDP:

app????


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


