## Overview

The documentation covers ASICLab software, servers, workstations, and other infrastructure. The scope of this document is information that a user with basic familiarity with Linux systems would need to fix problems with existing systems or add new systems to the network. Therefore, extensive documentation of general Linux knowledge should be avoided to avoid diluting the usefulness of information.

## List of Machines and their Purpose

`asiclab###`: User Workstations

`aisclabwin###`: User Windows Machines

`penelope`: NFS, LDAP, License Servers

`jupiter`: Simulation server

`juno`: Simulation server (identical configuration of jupiter)

`faust02`: (retired)

`apollo`: (retired)

`asiclab##`: (retired, or used with windows)

## Workstation Linux Install

Start here to configure a fresh installation of Fedora Linux on a lab desktop workstation.

1. Create a bootable USB drive with the latest version of Fedora Workstation. The easiest way to do this is on Fedora, MacOS, or Windows using the [Fedora Media Writer](https://getfedora.org/en/workstation/download/). Alternatively, download the latest Fedora ISO file, check the name of your drive with `sudo fdisk -l`, unmount the drive with `sudo umount /dev/sdb*`, and write the ISO image to the drive with `sudo dd bs=4M if=/path/to/fedora.iso of=/dev/sdb status=progress oflag=sync`. Wait for the writing to complete, which could take several minutes.
1. Insert the bootable USB drive into the machine to be configured and change the boot order in the BIOS or UEFI to boot from the USB drive first. Reboot the machine.
1. Once inside the Fedora installer, select "Install to Hard Drive", choose your desired region and keyboard setup, and select the machine's solid state drive for install. After install has completed and the computer has rebooted, accept the prompt to opt into 'Third Party Repositories', and create a local user account called `asiclab`. Ask one of the older lab members for the default admin password for this account. You should now be on the desktop.
1. Check for and install any packages updates with `sudo dnf update` and `sudo dnf clean packages`.
1. Follow instructions in Network Management
1. Follow instructions in Files Servers (do this before connecting LDAP, so that home directories exist) This configures RAID array, drive mounting, NFS (client and server)
1. Follow instructions in User Management via LDAP (which connects home directories, LDAP, user accounts, GID, UID, groups, etc, restrictions for different groups, passwords on machines)
1. follow Inscutrions in Printer Configuration
1. Follow Instructions in Licesnse Server: For Cadence, 
1. Follow instructions for Cadence Containerization, if you need it, using apptainer
1. Finally, enable 3rd party repos, and follow instruction to install proprietary software, like Slack, Chrome, etc.
1. If you plan to work remotely, read the section of REmote connection, which covers SSH, VNC, Wireguard (in network-manager interface)

## Workstation Windows Setup

Start here in you need to configure a fresh installation of Windows on a 

[Under construction]
