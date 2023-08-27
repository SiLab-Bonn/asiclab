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


---

## RDP

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
