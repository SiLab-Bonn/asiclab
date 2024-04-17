# Overview

The documentation covers ASICLab software, servers, workstations, and other infrastructure. The scope of this document is information that a user with basic familiarity with Linux systems would need to fix problems with existing systems or add new systems to the network. Therefore, extensive documentation of general Linux knowledge should be avoided to avoid diluting the usefulness of information.

# Network Architecture

The follow diagram shows the various workstations and servers (i.e. infrastructure used in the lab, and the major services that run on the servers like NFS and LDAP. Additionally, some useful services like DNS and CUPS are inherited from the larger PI network, as seen on the right.

```mermaid
graph TB
linkStyle default interpolate basis

subgraph pin [PI Infrastructure]
cups[(CUPS)]-->pi
dns[(DNS)]-->pi
tivoli[(IBM SP)]-->pi
end

subgraph asiclab[ASICLab Infrastructure]
spectre[(Spectre)]-->jupiter
spectre[(Spectre)]-->juno

flexlm[(FlexLM)]-->faust02
ldap[(LDAP)]-->noyce(noyce VM)
samba[(Samba)]-->noyce
nfs[(NFS)]-->penelope
noyce-->faust02
sos[(Cliosoft SOS)]-->faust02

penelope---switch[[switch]]
faust02---switch
jupiter---switch
juno---switch
end

pi(PI Machines)-.-switch

subgraph asm[ASICLab Workstations]
asiclabXXX
asiclabXX
asiclabwinXXX
end

switch---asiclabXXX
switch---asiclabXX
switch---asiclabwinXXX
```

# Machine purposes

`asiclab###`: User Workstations

`aisclabwin###`: User Windows Machines

`penelope`: NFS, LDAP, License Servers

`jupiter`: Simulation server

`juno`: Simulation server (identical configuration of jupiter)

`faust02`: (soon to be decommissioned, still running LDAP and License Server)

`apollo`: (retired)

`asiclab##`: Retired user workstations, still good for less demanding work. Easily configured for Linux or Windows.


# Tasks
- [ ] sosmgr/sosadmin server re-setup
- [ ] test fscache + NFS setup to see if it offers read speed benefits
- [ ] migrate FreeIPA LDAP server to penelope
- [ ] finish migrating remaining machines to AlmaLinux 9
- [ ] check licenses are up to date
- [ ] understand all the SELinux alerts
- [ ] update to synopsys 2023-24 tools
- [ ] Cliosoft version 7.20 recommended April 24
- [ ] port bonding on servers `penelope`, etc?
- [ ] test penelope NFS backups IBM Tivoli Spectrum
- [ ] update siemens questa to 2023-24 release?