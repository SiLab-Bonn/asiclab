# Outline of workstation install script

This should be run once every couple of weeks, or whenever a new package needs to be installed system wide.

1. List desktop machines in inventory .yml
1. Send `wol` magic packets using mac address and this [playbooks](https://docs.ansible.com/ansible/latest/collections/community/general/wakeonlan_module.html). Then wait for set delay for computers to wake up.
1. Update repositories, update packages, autoremove/clean
1. Install misc packages: apptainer vscode zoom slack (both from flathub?) vim
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
