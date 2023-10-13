# Hostname and IP Address References

# DNS Server


Setup network
`asiclab006` should be `131.220.163.233`. 
can be checked with `ip address` command, and checking the inet address of the eno1 device.


# 6. Double check hostname and time synchronization

Both are important for trouble-free server operation. Just in case you missed its configuration during installation or it is incorrect, now is the opportunity to fix it.

Check for correct hostname

`[…]# hostnamectl`

Set hostname if required:

`[…]# hostnamectl  set-hostname  <YourFQDN>`

Control of time zone, time synchronisation, time

`[…]# timedatectl`

Correct time zone if necessary:

`[…]# timedatectl set-timezone  <ZONE>`

If necessary, activate time synchronisation:

`timedatectl set-ntp true`

Correct time if necessary:

`[…]# timedatectl set-time  <TIME>`


# Configuring Ethernet with Static IP:
The /etc/sysconfig/network-scripts/ifcfg-interface_name file was deprecated, and now `nmcli` is used, alongside it's keyfile [format](https://people.freedesktop.org/~lkundrak/nm-docs/nm-settings-keyfile.html). It's not recommended to configure this file manually, even though you technically can (and inform NetworkManager). Instead the better way to proceed is to use the nmcli setup.

The history of the migration from ifcfg to keyfiles is details in this [Fedora magazine post](https://fedoramagazine.org/converting-networkmanager-from-ifcfg-to-keyfiles/):

Here's the old ifcfg file:

```
DEVICE="INTERFACE_NAME"
BOOTPROTO="static"
PEERDNS=no
IPADDR="static_IP_as_in_/etc/hosts"
GATEWAY="131.220.163.254"
NETMASK="255.255.248.0"
IPV6INIT="no"
NM_CONTROLLED="no"
ONBOOT="yes"
```

As we can see, the netmask is 255.255.248.0 which corresponds to /21.

To create a new set of keyfiles, the best approach is something like:

```
$ nmcli con modify eth0 ipv4.method manual
$ nmcli con modify eth0 ipv4.addresses 10.0.0.10/8
$ nmcli con modify eth0 ipv4.gateway 10.0.0.1
$ nmcli con modify eth0 ipv4.dns 10.0.0.2,10.0.0.3
```

```
nmcli connection modify Wired\ connection\ 1 ipv4.method manual
nmcli connection modify Wired\ connection\ 1 ipv4.addresses 131.220.165.187/21
nmcli connection modify Wired\ connection\ 1 ipv4.gateway 131.220.163.254

nmcli connection modify Wired\ connection\ 1 ipv6.method disabled

nmcli connection up Wired\ connection\ 1
```

For more information, check out
`$ man nmcli-examples`

and
`$ man nm-settings-nmcli`

To see the connection profile, and current status of the connection:
`nmcli -p connection show Wired\ connection\ 1 | less`

Damn, it looks like nearly all of the settings for this computer were simply copied over from the network somehow. Take the resolve DNS settings:

```
$ resolvectl status
Link 3 (eno1)
    Current Scopes: DNS LLMNR/IPv4 LLMNR/IPv6
         Protocols: +DefaultRoute +LLMNR -mDNS -DNSOverTLS DNSSEC=no/unsupported
Current DNS Server: 131.220.16.220
       DNS Servers: 131.220.16.220 131.220.14.203 131.220.18.138
        DNS Domain: physik.uni-bonn.de
```






Other notes, found from CentOS stuff:
ip -br link show
show network interfaces, in simple format

ip -s link show [em1]
show statistics on specific interface, where em1 example is interface name

ip link set [em1] up
enable network interfaces if they are down, but will not always work, if there is a real problem with the hardware. em1 is example interface name

ip addr
shows address of all the network interfaces in the machine

the above is primarily for the physical layer
more advice for the data link layer and networking layer can be found here:
https://www.redhat.com/sysadmin/beginners-guide-network-troubleshooting-linux


## Debugging

`hostnamectl`
shows info about the machines network characteristics, and can be used to change host name

`ethtool [em1]`
prob status of different interfaces, where em1 is example interface

`visudo`
edit the sudoers file

`su -`
switch user to to the root user

`ip -br link show`
show network interfaces, in simple format

`ip -s link show [em1]`
show statistics on specific interface, where em1 example is interface name

`ip link set [em1] up`
enable network interfaces if they are down, but will not always work, if there is a real problem with the hardware. em1 is example interface name

`ip addr`
shows address of all the network interfaces in the machine

the above is primarily for the physical layer
more advice for the data link layer and networking layer can be found here:
https://www.redhat.com/sysadmin/beginners-guide-network-troubleshooting-linux


# DNS

The most basic DNS manual method is to just use the `/etc/hosts` and `/etc/resolv.conf` files.

Beyond that, there are two common DNS caching servers: `systemd-resolved` and `dnsmasq`, depending on whether you're on Fedora or CentOS, respectively.

https://www.linuxuprising.com/2019/07/how-to-flush-dns-cache-on-linux-for.html

systemd-resolved is a systemd service that provides network name resolution to local applications via a D-Bus interface, the resolve NSS service (nss-resolve(8)), and a local DNS stub listener on 127.0.0.53. See systemd-resolved(8) for the usage.


https://wiki.archlinux.org/title/Dnsmasq#DNS_server


`dig` is a DNS lookup utility, which works as an 'in memory' DNS analyzer

`systemd-analyze cat-config systemd/resolved.conf`