# Outline of workstation install script

This should be run once every couple of weeks, or whenever a new package needs to be installed system wide.

1. List desktop machines in inventory .yml
1. Send `wol` magic packets using mac address and this [playbooks](https://docs.ansible.com/ansible/latest/collections/community/general/wakeonlan_module.html). Then wait for set delay for computers to wake up.
1. Update repositories, update packages, autoremove/clean
1. Install FOSS packages:
```
sudo dnf install apptainer vim tmux htop pandoc curl wget cmake make gcc-g++
```

1. vscode, zoom, slack,
1. Install BAG3++ packages
1. Add mountpoints, then `mount -a`
1. Realm join which installs some packages too
1. Setup printers
1. dnf autoremove/autoclean



# BAG + Cadence Setup
User Workspace setup script? should maybe just be instructions

1. create /cadence /designs directory, etc
1. user shouldn't need to have their own containers or init script... it should live on server
1. more setup, etc.



Hostname inventory file

```
all:
  workstations:
    dell7060:
      asiclab001
      asiclab002
      asiclab003
      asiclab006
      asiclab008
    legacy:
      asiclab00
      asiclab01
      asiclab02
      asiclab05
      asiclab07
      asiclab08
```

# Base Fedora Repos

```
fedora                                                      Fedora 38 - x86_64
fedora-cisco-openh264                                       Fedora 38 openh264 (From Cisco) - x86_64
fedora-modular                                              Fedora Modular 38 - x86_64
updates                                                     Fedora 38 - x86_64 - Updates
updates-modular                                             Fedora Modular 38 - x86_64 - Updates
```

In case the special cisco repo isn't enabled, one can do:

```
sudo dnf config-manager --set-enabled fedora-cisco-openh264
```



# Official Fedora Third-Party Repos + RPM Fusion

clicking thirdparty/enabled repos does this:

```
sudo fedora-third-party enable
```

gives this (four different repos):

```
copr:copr.fedorainfracloud.org:phracek:PyCharm                      Copr repo for PyCharm owned by phracek
google-chrome                                                       google-chrome
rpmfusion-nonfree-nvidia-driver                                     RPM Fusion for Fedora 38 - Nonfree - NVIDIA Driver
rpmfusion-nonfree-steam                                             RPM Fusion for Fedora 38 - Nonfree - Steam
```

running dnf install rpm fusion 

```
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
```

gives this instead:

```
rpmfusion-free                                              RPM Fusion for Fedora 38 - Free
rpmfusion-free-updates                                      RPM Fusion for Fedora 38 - Free - Updates
rpmfusion-nonfree                                           RPM Fusion for Fedora 38 - Nonfree
rpmfusion-nonfree-updates                                   RPM Fusion for Fedora 38 - Nonfree - Updates
```

# Flatpak

Fedora by default has just a Fedora flapak repo. Additionally, from the software center you can enable a filtered flathub. But from the command below will enable an unfiltered version:

```
flatpak remote-add --if-not-exists fedora oci+https://registry.fedoraproject.org
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```

No flatpaks will be installed by default though. I seem to have opnh264, Mesa, Mesa Extra, and Freedesktop flatform installed. I should figure out where they came from. There's also an Intel install?

The `flatpak` command also lists and installs apps and runtimes. To list all apps available in a specific repository, run the `remote-ls` command:

```
$ flatpak remote-ls flathub --app
```

Then, install an app with the `install` command

```
flatpak install flathub us.zoom.Zoom
```

This is what I have so far:

```
Typora                         io.typora.Typora                              1.5.10            stable               system
Freedesktop Platform           org.freedesktop.Platform                      22.08.11          22.08                system
Mesa                           org.freedesktop.Platform.GL.default           23.0.2            22.08                system
Mesa (Extra)                   org.freedesktop.Platform.GL.default           23.0.2            22.08-extra          system
Intel                          org.freedesktop.Platform.VAAPI.Intel                            22.08                system
openh264                       org.freedesktop.Platform.openh264             2.1.0             2.2.0                system
```



# Firmware upgrades

Firmware upgrade can be run by:

```
fwupdmgr get-upgrades
and
sudo fwupdmgr update
```


## How to log:

Append the regiser and debug

```
   - name: Cleaning DNF Cache
     shell: dnf clean all
     register: command_output
       
   - debug: var=command_output
```

## Roles, Tasks, Modules, etc
https://devops.stackexchange.com/questions/9832/ansible-whats-the-difference-between-task-role-play-and-playbook


Playbook: the highest level, just a list of plays
    Play: ties tasks to host lists, often just one per playbook)
    Tasks: definition of a call to a module (undelying execution can be written in any language)
    Besides tasks, a play may have pre-tasks, post-tasks and handlers, which are all task-like, and roles.
    






to do list:

- ~~create user and tools directory~~
- ~~mount NFS directories (fstab and mount -a)~~
- ~~connect to LDAP, test users?~~
- 

- configure Drivers for USB JTAG programmers?



on each machine, change the BIOS to boot from SSD, make sure BIOS is UEFI, ensure AHCI boot is on, and make sure Wake-on-lan is enabled

enable location services

enable automatic time zone

change power settings, system wide for all users, so that system goes into sleep, but is still pingable to wake back up

configure internal drive, on a mount point, for scratch space

additional installs: pycharm gstreamer1-plugin-openh264 mozilla-openh264

zoom vscode slack typora? Not sure if custom rpm or flathub?



# Unused commands:

```
    - name: Create directory for users
      become: true
      ansible.builtin.file:
        path: /users
        state: directory
        owner: 0
        group: 0
        mode: 0755
      tags: nfs
      
    - name: Create directory for tools directory
      become: true
      ansible.builtin.file:
        path: /tools
        state: directory
        owner: 0
        group: 0
        mode: 0755
      tags: nfs
      
    - name: Add users mount to /etc/fstab
      become: true
      ansible.builtin.lineinfile:
        path: /etc/fstab
        line: penelope.physik.uni-bonn.de:/export/disk/users /users nfs4 defaults 0 0
        create: yes
      tags: nfs
      
    - name: Add tool mount to /etc/fstab
      become: true
      ansible.builtin.lineinfile:
        path: /etc/fstab
        line: penelope.physik.uni-bonn.de:/export/disk/tools /tools nfs4 ro 0 0
        create: yes
      tags: nfs
    
    - name: Reload system daemon to mount
      become: true
      ansible.builtin.systemd:
        daemon_reload: true
```



guest password is 'guestpassword'



for freeipa syntax, use the following:

https://github.com/freeipa/ansible-freeipa

https://github.com/freeipa/ansible-freeipa/blob/master/roles/ipaclient/README.md
