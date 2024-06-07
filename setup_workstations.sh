sudo dnf check-update
sudo dnf update -y
sudo dnf groupinstall -y Workstation
sudo dnf groupinstall -y "Network File System Client"
sudo dnf groupinstall -y --with-optional "Development Tools"
sudo dnf groupinstall -y --with-optional "System Tools"
sudo dnf install -y nfsv4-client-utils cachefilesd
sudo dnf install -y python3-devel python3-pip python3-sphinx
sudo dnf install -y epel-release
sudo dnf install -y elrepo-release
sudo dnf config-manager --set-enabled crb -y
sudo dnf install -y htop hwinfo gnome-tweaks curl wget git gcc cmake g++ perl tmux pdfgrep tigervnc-server pandoc
sudo dnf install -y chromium thunderbird rdesktop gimp
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo dnf install -y code

#Packages needed for Ramon/Basil:
sudo dnf install -y gtkwave

# Build requirements for iverilog
sudo dnf install -y autoconf gperf make gcc g++ bison flex
# also need to git clone and installed 

# For ngspice
sudo dnf install -y libXaw-devel

#extra packages found to be passibley installed from desktop usage
sudo dnf install -y openh264 gstreamer1-plugin-openh264 mozilla-openh264
sudo dnf install -y glibc-minimal-langpack hunspell-en-GB hunspell-en langpacks-core-en langpacks-en
sudo dnf install -y grub2-tools-efi grub2-tools-extra
sudo dnf install -y libcap-ng-python3 python-unversioned-command rpm-plugin-systemd-inhibit rsyslog-logrotate
sudo dnf autoremove -y

# slow repeating installs
sudo dnf install -y --nogpgcheck https://dl.fedoraproject.org/pub/epel/epel-release-latest-$(rpm -E %rhel).noarch.rpm
sudo dnf install -y --nogpgcheck https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-$(rpm -E %rhel).noarch.rpm https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-$(rpm -E %rhel).noarch.rpm
sudo dnf install -y https://zoom.us/client/latest/zoom_x86_64.rpm
sudo dnf install -y https://www.klayout.org/downloads/RockyLinux_9/klayout-0.29.1-0.x86_64.rpm
sudo dnf remove -y libreoffice libreoffice-impress libreoffice-calc libreoffice-writer

# Cadence
sudo dnf install -y csh tcsh glibc elfutils-libelf ksh mesa-libGL mesa-libGLU motif libXp libpng libjpeg-turbo expat glibc-devel gdb libXScrnSaver xorg-x11-fonts-misc xorg-x11-fonts-ISO8859-1-75dpi apr apr-util xorg-x11-server-Xvfb mesa-dri-drivers openssl-devel
sudo dnf install -y glibc.i686 elfutils-libelf.i686 mesa-libGL.i686 mesa-libGLU.i686 motif.i686 libXp.i686 libpng.i686 libjpeg-turbo.i686 expat.i686 glibc-devel.i686

sudo dnf install -y libnsl
sudo dnf install -y https://repo.almalinux.org/almalinux/8/AppStream/x86_64/os/Packages/compat-openssl10-1.0.2o-4.el8_6.x86_64.rpm

sudo dnf install -y almalinux-release-devel
sudo dnf --enablerepo=devel install -y redhat-lsb-core
sudo dnf config-manager --set-disabled devel

sudo dnf copr enable mlampe/compat-db47 epel-8-x86_64 -y
sudo dnf install -y compat-db47
sudo dnf config-manager --set-disabled copr:copr.fedorainfracloud.org:mlampe:compat-db47

# Vivado
sudo dnf install -y ncurses-compat-libs
sudo dnf install -y fxload libusb1 libusb1-devel libusb
sudo udevadm control --reload-rules

# TCAD
sudo dnf install -y ksh perl perl-core tcsh strace valgrind gdb bc xorg-x11-server-Xvfb gcc glibc-devel bzip2 ncompress
sudo dnf install -y java-11-openjdk

# flatpaks
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
sudo flatpak install org.libreoffice.LibreOffice -y
sudo flatpak install org.gnome.Maps -y
sudo flatpak install com.slack.Slack -y
sudo flatpak install org.inkscape.Inkscape -y

