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