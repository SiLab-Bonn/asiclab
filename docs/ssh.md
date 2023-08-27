# SSH

In the text below, the "host" or "server" is the asiclab workstation being connected to, while the "client" is local machine you are trying to connection from.

## Enabling host server

On the host, the OpenSSH server process `sshd` can be enabled via:

```
sudo systemctl enable sshd
sudo systemctl start sshd
```

## Connecting from client

```
ssh kcaisley@asiclab001.physik.uni-bonn.de
```

## Enabling insecure host key algorithms

To enable SSH-RSA (and outdated protocol) on new machines
To permit using old RSA keys for OpenSSH 8.8+, add the following lines to your sshd_config:

```
HostKeyAlgorithms=ssh-rsa,ssh-rsa-cert-v01@openssh.com
PubkeyAcceptedAlgorithms=+ssh-rsa,ssh-rsa-cert-v01@openssh.com
```

Note: If you're trying to connect to, or from an older system, you may run into issues where the version keys supported is deprecated.

An alternative way to enable ssh-rsa is to just add the following to a corresponding `~/.ssh/config` file.

## Passwordless Authentication
For passwordless authentication, one can generate SSH keys, and move it to another computer for authentication

```
ssh-keygen -t ed25519
ssh-copy-id -i ~/.ssh/asiclab008.pub kcaisley@asiclab001.physik.uni-bonn.de
```

To enable SSH public key authentication on a Fedora host, make sure you go to `/etc/ssh/sshd_config` and uncomment the line

```
PubkeyAuthentication yes
```

If done properly, the host will skip prompting for a password when connecting.

## Using a config file to simplify connection

On the client, many of the following steps can be controlled by creating/modifiying the file `~/.ssh/config` the following:

```
Host asiclab001.physik.uni-bonn.de
    User kcaisley
    PubkeyAcceptedAlgorithms +ssh-rsa
    HostkeyAlgorithms +ssh-rsa
```
