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
sudo dnf history info #
```

Dnf undo history item:

```
sudo dnf history undo/rollback #
```

If a package is still in the repos, here's how you find and target it:
https://unix.stackexchange.com/questions/266888/can-i-force-dnf-to-install-an-old-version-of-a-package

`dnf --showduplicates list <package>`

List packages that depend on the package of choice:
`dnf repoquery --installed --whatrequires qemu-kvm`

manually downgrade to a different package version downloaded from [this link](https://koji.fedoraproject.org)
`sudo dnf downgrade ~/Downloads/fmt-8.1.1-5.fc37.x86_64.rpm`