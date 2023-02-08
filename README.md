# Overview

The documentation covers ASICLab software, servers, workstations, and other infrastructure. The scope of this document is information that a user with basic familiarity with Linux systems would need to fix problems with existing systems or add new systems to the network. Therefore, extensive documentation of general Linux knowledge should be avoided, to prevent the dilution of immediately useful information.

# List of Machines and their Purpose

* asiclab###: User Workstations
* aisclabwin###: User Windows Machines
* penelope: NFS, LDAP, License Servers
* jupiter: Simulation server
* juno: Simulation server (identical configuration of jupiter)
* faust02: (retired)
* apollo: (retired)
* asiclab##: (retired)

# AsicLab Workstation Setup

Start here if you're configuring a new AsicLab Workstation:

1. Produce a Fedora workstation boot-able drive using the [Fedora Media Writer](https://getfedora.org/en/workstation/download/), available for MacOs, Windows, or Fedora Linux OSes.
1. Install latest Fedora install
1. create local `asiclab` user, with default password
1. Follow instructions in Network Management
1. Follow instructions in Files Servers (do this before connecting LDAP, so that home directories exist) This configures RAID array, drive mounting, NFS (client and server)
1. Follow instructions in User Management via LDAP (which connects home directories, LDAP, user accounts, GID, UID, groups, etc, restrictions for different groups, passwords on machines)
1. follow Inscutrions in Printer Configuration
1. Follow Instructions in Licesnse Server: For Cadence, 
1. Follow instructions for Cadence Containerization, if you need it, using apptainer
1. Finally, enable 3rd party repos, and follow instruction to install proprietary software, like Slack, Chrome, etc.
1. If you plan to work remotely, read the section of REmote connection, which covers SSH, VNC, Wireguard (in network-manager interface)
