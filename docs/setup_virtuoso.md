# Installing CDS tools

Download the packages using sftp
Create a dummy symlink, from /eda -> /tools (as Europractice installer expects it)
Run the install script
Make sure all files are owned by group `base` (currently 200)

# Building the container

First you need a `.def file`. Ones have been created, relative to this doc page, at `../container_def/`

To compile, as `asiclab` user on penelope:
```
sudo apptainer build --force /mnt/md127/tools/containers/virtuoso_centos7.sif /mnt/md127/tools/asiclab/container_def/virtuoso_centos7.def
```

Then to run, on a workstation:

```
apptainer shell -B /tools,/users /tools/containers/virtuoso_centos7.sif
```

# Checking the container works, after starting it:

The current version of my redhat/centOS distribution can be checked via:

```
cat /etc/redhat-release
```

To check Cadence config:

```
/tools/cadence/2022-23/RHELx86/IC_6.1.8.320/tools.lnx86/bin/checkSysConf IC6.1.8
```


# Running Cadence
To properly start cadence tools, over xhost +, you'll need the following fonts:

```
dnf install xorg-x11-fonts-100dpi xorg-x11-fonts-75dpi xorg-x11-fonts-ISO8859-1-100dpi xorg-x11-fonts-ISO8859-1-75dpi xorg-x11-fonts-ISO8859-9-100dpi xorg-x11-fonts-ISO8859-9-75dpi xorg-x11-fonts-Type1 xorg-x11-fonts-misc
```

You'll also need apptainer, to run the container:

```
sudo dnf install apptainer
```

# TL;DR normal usage:
If on Fedora, first run:

```
xhost +
apptainer shell -B /tools,/users /tools/containers/virtuoso_centos7.sif
```

Then inside the container

```
Apptainer> source /tools/asiclab/startup_scripts/tsmc_crn28hpcp.sh
Apptainer> which virtuoso
/tools/cadence/2022-23/RHELx86/IC_6.1.8.320/tools/dfII/bin/virtuoso
Apptainer> virtuoso &
```