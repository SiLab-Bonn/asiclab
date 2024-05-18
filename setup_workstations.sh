sudo dnf check-update
sudo dnf groupinstall -y "Network File System Client"
sudo dnf groupinstall -y Workstation
sudo dnf groupinstall -y --with-optional "Development Tools"
sudo dnf install -y nfsv4-client-utils 
sudo dnf install -y python3-devel python3-pip
sudo dnf install -y epel-release
sudo dnf install -y elrepo-release
sudo dnf config-manager --set-enabled crb -y
sudo dnf install -y htop hwinfo gnome-tweaks curl wget git gcc cmake g++
sudo dnf install -y texlive
sudo dnf install -y chromium thunderbird
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo dnf install -y code
sudo dnf install -y --nogpgcheck https://dl.fedoraproject.org/pub/epel/epel-release-latest-$(rpm -E %rhel).noarch.rpm
sudo dnf install -y --nogpgcheck https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-$(rpm -E %rhel).noarch.rpm https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-$(rpm -E %rhel).noarch.rpm
sudo dnf install -y openh264 gstreamer1-plugin-openh264 mozilla-openh264
sudo dnf install -y https://zoom.us/client/latest/zoom_x86_64.rpm
sudo dnf install -y https://www.klayout.org/downloads/RockyLinux_9/klayout-0.29.1-0.x86_64.rpm
sudo dnf remove -y libreoffice libreoffice-impress libreoffice-calc libreoffice-writer
sudo dnf autoremove -y

sudo dnf install -y csh tcsh glibc elfutils-libelf ksh mesa-libGL mesa-libGLU motif libXp libpng libjpeg-turbo expat glibc-devel gdb libXScrnSaver xorg-x11-fonts-misc xorg-x11-fonts-ISO8859-1-75dpi apr apr-util xorg-x11-server-Xvfb mesa-dri-drivers openssl-devel
sudo dnf install -y glibc.i686 elfutils-libelf.i686 mesa-libGL.i686 mesa-libGLU.i686 motif.i686 libXp.i686 libpng.i686 libjpeg-turbo.i686 expat.i686 glibc-devel.i686
sudo dnf install -y almalinux-release-devel
sudo dnf --enablerepo=devel install -y redhat-lsb-core
sudo dnf config-manager --set-disabled devel

sudo dnf copr enable mlampe/compat-db47 epel-8-x86_64 -y
sudo dnf install -y compat-db47
sudo dnf config-manager --set-disabled copr:copr.fedorainfracloud.org:mlampe:compat-db47

sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
sudo flatpak install org.libreoffice.LibreOffice -y
sudo flatpak install org.gnome.Maps -y
sudo flatpak install com.slack.Slack -y
