# Summary

These containers provide local environments for running Cadence IC design and Synopysys TCAD tools on otherwise incompatible linux distributions.

Both containers are based on CentOS7.


# Building and running

As an example, the compile the Cadence container:

```
sudo apptainer build --force /path/to/build/at/virtuoso_centos7.sif /path/to/source/def/file/virtuoso_centos7.def
```

Then to run, on local workstation:

```
xhost +
apptainer shell -B /dir1,/dir2 /path/to/built/container/virtuoso_centos7.sif
```

Where `dir1` and `dir2` are external directories to make available inside the container. The users `$HOME` directory is available by default, but you'll need to include, for example, the `/tools` or `/eda` directory that often houses the EDA tool binaries.

To check the container works, after starting it:

The current version of my redhat/centOS distribution can be checked via the following, which should yield: `CentOS Linux release 7.9.2009 (Core)`

```
cat /etc/redhat-release
```

To check Cadence config:

```
/tools/cadence/2022-23/RHELx86/IC_6.1.8.320/tools.lnx86/bin/checkSysConf IC6.1.8
```

# Troubleshooting

To properly view cadence tools running inside the container, graphically over X11, you'll need the following fonts on the **host OS**:

```
sudo dnf install xorg-x11-fonts-100dpi xorg-x11-fonts-75dpi xorg-x11-fonts-ISO8859-1-100dpi xorg-x11-fonts-ISO8859-1-75dpi xorg-x11-fonts-ISO8859-9-100dpi xorg-x11-fonts-ISO8859-9-75dpi xorg-x11-fonts-Type1 xorg-x11-fonts-misc
```

You'll also need apptainer, of course, to run the container:

```
sudo dnf install apptainer
```

