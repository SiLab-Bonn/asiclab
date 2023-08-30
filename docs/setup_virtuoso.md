

To properly start cadence tools, over xhost +, you'll need the following fonts:

```
dnf install xorg-x11-fonts-100dpi xorg-x11-fonts-75dpi xorg-x11-fonts-ISO8859-1-100dpi xorg-x11-fonts-ISO8859-1-75dpi xorg-x11-fonts-ISO8859-9-100dpi xorg-x11-fonts-ISO8859-9-75dpi xorg-x11-fonts-Type1 xorg-x11-fonts-misc
```

You'll also need apptainer, to run the container:

```
sudo dnf install apptainer
```

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