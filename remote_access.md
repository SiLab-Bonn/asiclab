# Remote Access

How to connect to workstations machines using a variety of methods, including `ssh`, `sftp`, `vnc`, `rdp`, and `X11` forwarding.

---

## Wireguard VPN

If offsite or using non-LAN connected machine (e.g. using `eduroam` Wi-Fi), one must first use a [Wireguard](https://www.wireguard.com/) VPN tunnel to connect to the PI network.

Instructions for installing `wireguard` client, generating a public/private key pair, and contacting Physics IT support for registration can be found [here](https://confluence.team.uni-bonn.de/display/PHYIT/WireGuard+VPN).

This process will allow you to prepare a `.conf` file for configuring the client. The file will have the following format:

```
[Interface]
PrivateKey = Fill_in_your_private_key_here
Address = DeviceIP/32
DNS = 10.160.24.1, physik.uni-bonn.de
[Peer]
PublicKey = iwnIOPboknjbBSlw+92px82r9AhLVZPapcZTawNNtBc=
AllowedIPs = 0.0.0.0/0
Endpoint = wireguard.physik.uni-bonn.de:53115
PersistentKeepalive = 25
```

---

# X11 forwarding for GUI application

From this link, I found that:

The default ssh settings make for a pretty slow connection. Try the following instead:

```ssh -YC4c arcfour,blowfish-cbc user@hostname firefox -no-remote```

The options used are:

```
-Y      Enables trusted X11 forwarding.  Trusted X11 forwardings are not
         subjected to the X11 SECURITY extension controls.
 -C      Requests compression of all data (including stdin, stdout,
         stderr, and data for forwarded X11 and TCP connections).  The
         compression algorithm is the same used by gzip(1), and the
         “level” can be controlled by the CompressionLevel option for pro‐
         tocol version 1.  Compression is desirable on modem lines and
         other slow connections, but will only slow down things on fast
         networks.  The default value can be set on a host-by-host basis
         in the configuration files; see the Compression option.
 -4      Forces ssh to use IPv4 addresses only.
 -c cipher_spec
         Selects the cipher specification for encrypting the session.

         For protocol version 2, cipher_spec is a comma-separated list of
         ciphers listed in order of preference.  See the Ciphers keyword
         in ssh_config(5) for more information.
```


---

## VNC via Gnome Remote Desktop (If server is AlmaLinux 9)

As of Gnome 42, there is a `grdctl` command and a built-in freerdp implementation. But EL9 only has Gnome 40.

freerdp		Used by gnome it implement screen sharing, 
xrdp		tightly coupled to X11, accepts connections from rdesktop, FreeRDP, and Windows
remmina		Is a client
rdesktop	Is a client, In need of maintenance

[This link explains how to enable it.](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/getting_started_with_the_gnome_desktop_environment/how-to-authenticate-with-enterprise-credentials-in-gnome_getting-started-with-the-gnome-desktop-environment)

[History of feature development](https://gitlab.gnome.org/GNOME/gnome-remote-desktop/-/issues/26)

You can remotely connect to the desktop as a single user on a EL9 server using graphical GNOME applications. Only a single user can connect to the desktop on the server at a given time.

This procedure configures a RHEL server to enable a remote desktop connection from a single client.

Prerequisites

The GNOME Remote Desktop service is installed:
    
```
# dnf install gnome-remote-desktop
```

Procedure

Configure a firewall rule to enable VNC access to the server:

```
# firewall-cmd --permanent --add-service=vnc-server
success
```

Reload firewall rules:

```
# firewall-cmd --reload
success
```

Open Settings in GNOME.

Navigate to the Sharing menu:

screen sharing 0

Click Screen Sharing.

The screen sharing configuration opens:

screen sharing 1 off

Click the switch button in the window header to enable screen sharing:

screen sharing 2 on highlight
Select the Allow connections to control the screen check box.
Under Access Options, select the Require a password option.

Set a password in the Password field.

Remote clients must enter this password when connecting to the desktop on the server.

screen sharing 4 password 

Then, to connect from another device, user the IP:5900 as the address






## RDP (If server is Fedora)

For graphical access, RDP has the best performance, with minimal setup. By default, Fedora includes a RDP server via the built-in `gnome-remote-desktop` package. One limitation is that it only allows for accessing an already existing display session.

[These RHEL Docs](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/getting_started_with_the_gnome_desktop_environment/remotely-accessing-the-desktop-as-a-single-user_getting-started-with-the-gnome-desktop-environment) explain how to enable desktop sharing on a machine using GNOME.

1. On the host, check the RDP status

```
sudo grdctl status --show-credentials
```

2. On the host, enable RDP and set username/password

```
sudo grdctl rdp enable
sudo grdctl rdp 
```

```
$ grdctl status

RDP:
	Status: enabled
	TLS certificate: /users/kcaisley/.local/share/gnome-remote-desktop/rdp-tls.crt
	TLS key: /users/kcaisley/.local/share/gnome-remote-desktop/rdp-tls.key
	View-only: no
	Username: (hidden)
	Password: (hidden)

```

Behind the scenes, this is actually just editing the dconf store with the standard `gsettings` command. Read more [here](https://askubuntu.com/questions/249887/gconf-dconf-gsettings-and-the-relationship-between-them)

```
gsettings list-recursively org.gnome.desktop.remote-desktop.vnc
gsettings get org.gnome.desktop.remote-desktop.rdp enable
```

To connect, run `gnome-connections`, and use:

```
rdp://asiclab008.physik.uni-bonn.de:3389
```

## VNC

Under construction. CentOS7 instructions may be relevant, [found here](https://linuxize.com/post/how-to-install-and-configure-vnc-on-centos-7/).

## X11 Forwarding

Under construction.

## Sleep, suspend, and hibernate

Note: As currently configured, the workstations will enter a 'hibernate' state that prevents new connections and can kill inactive ones. This can be disabled via `Settings > Power > Automatic Suspend > Off`.

There are [multiple methods](https://docs.kernel.org/admin-guide/pm/sleep-states.html) of suspending available, notably:

- Suspend to RAM (aka suspend, aka sleep): The **S3** sleeping state as defined by ACPI. Works by cutting  off power to most parts of the machine aside from the RAM, which is  required to restore the machine's state. Because of the large power  savings, it is advisable for laptops to automatically enter this mode  when the computer is running on batteries and the lid is closed (or the  user is inactive for some time).

- Suspend to disk (aka hibernate): The **S4** sleeping state as defined by ACPI. Saves the machine's state into [swap space](https://wiki.archlinux.org/title/Swap_space) and completely powers off the machine. When the machine is powered on, the state is restored. Until then, there is [zero](https://en.wikipedia.org/wiki/Standby_power) power consumption.

- Hybrid suspend: A hybrid of suspending and hibernating, sometimes called **suspend to both**. Saves the machine's state into swap space, but does not power off the  machine. Instead, it invokes the default suspend. Therefore, if the  battery is not depleted, the system can resume instantly. If the battery is depleted, the system can be resumed from disk, which is much slower  than resuming from RAM, but the machine's state has not been lost.

Some relevant commands:

```
sudo systemctl status sleep.target suspend.target hibernate.target hybrid-sleep.target
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
sudo systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target
```

## Systemd Sleep settings:
https://www.freedesktop.org/software/systemd/man/systemd-sleep.conf.html

`/etc/systemd/sleep.conf`

Question: What is the difference between the settings in Gnome, and the settings in systemctl, and the settings in this conf file? Do they interact or supercede each other?
