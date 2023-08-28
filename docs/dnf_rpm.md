# DNF and RPM package management:

Check current version of an installed RPM
`rpm -q <packagename>`

Check current versions of remote and installed versions of a package
`dnf info <packagename>`

List contents of installed RPM
`rpm -ql <packagename>`

List contents of remote repository package:
`dnf repoquery -l spdlog`

Show the last time a rpm package was upgraded/installed:
`rpm -qa --last`

Show history of explicity dnf install requests:

```
sudo dnf history
```

Show more info about an ID history number:

```
sudo dnf history info [id]
```

Dnf undo history item:

```
sudo dnf history undo/rollback [id]
```

If a package is still in the repos, here's how you find and target it:
https://unix.stackexchange.com/questions/266888/can-i-force-dnf-to-install-an-old-version-of-a-package

`dnf --showduplicates list <package>`

List packages that depend on the package of choice:
`dnf repoquery --installed --whatrequires qemu-kvm`

manually downgrade to a different package version downloaded from [this link](https://koji.fedoraproject.org)
`sudo dnf downgrade ~/Downloads/fmt-8.1.1-5.fc37.x86_64.rpm`

manually install a rpm
then simply manually install all of these rpms, assuming nothing else is in the download path
`sudo dnf install ~/Downloads/*.rpm`


clean repositories
dnf -y update && dnf clean all

also there is `dnf clean packages`



dnf enable a repository
```
sudo dnf config-manager --set-enabled fedora-cisco-openh264
```


Efficient way to add repo key to yum repos

```
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
```
Then afterwards, to update the package cache

```
dnf check-update
```