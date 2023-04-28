# Thunderbird Email

```
sudo dnf install thundbird
```

Uni-Bonn email setup described [here](https://confluence.team.uni-bonn.de/display/HRZDOK/Einrichten+von+E-Mail+Clients#expand-AccountSetUp) is summarized below:

### Incoming Server Settings:

```
Protocol: IMAP
Hostname: mail.uni-bonn.de
Port: 933
Connection Security: SSL/TLS
Authentication Method: Normal Password
Username: kcaisley@uni-bonn.de
```

### Outgoing Server Settings:

```
Protocol: IMAP
Server Name: mail.uni-bonn.de
Port: 587
Connection Security: STARTTLS
Authentication Method: Normal Password
Username: kcaisley@uni-bonn.de
```

# Wireguard

As of Fedora 38, which is built on Gnome 44, you can simply import Wireguard `.conf` files directly in the Settings application, under the Network tab.

# Github Access w/ SSH Keys

[Instructions for SSH key authentication.](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)

Create a new key, if necessary, and following prompts.
```
ssh-keygen -t ed25519 -C "your_email@example.com"
```

Print out public key, and paste into Github.
```
cat id_ed25519.pub
```

Test the connection
```
ssh -T git@github.com
```

If you have issues, try changing the permissions of the key pair using `chmod 600 {key}` and add the keys to the SSH agent with `ssh-add`.

### Then to allow copying down repos

To add commits, and push back to github, make sure your configure your local git with your username and password, matching those of Github:
```
git config --global user.email "you@example.com"
git config --global user.name "Username"
```

Check settings with:

```
git config --get user.email
```




Clone down a repository, to proceed with work. For example:
```
git clone -b develop git@github.com:SiLab-Bonn/pybag.git --recurse-submodules
```


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

# SSH Keys
ssh-copy-id -i ~/.ssh/asiclab008.pub kcaisley@asiclab008.physik.uni-bonn.de

# SiRUSH SMB Server

Sirrush is shared via smb. You can simply use a file manager and go to smb://sirrush.physik.uni-bonn.de and log in with silab/pidub12. One can only access the `/silab` directory with this login. If you also want
to access project folder, an account has to be made for you.

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

