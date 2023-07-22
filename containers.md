

# Motivation

Proprietary EDA tools like Cadence Virtuoso are typically only supported on [a handful of operating systems](https://www.cadence.com/content/dam/cadence-www/global/en_US/documents/support/2021-2024-cadence-compute-platform-roadmap-v1-public.pdf). As machines for ASIC design are typically dedicated for that purpose, this can therefore lead to 


# Containers

Container provide for operating system virtualization,  in which the kernel allows the existence of multiple isolated user space instances.

## Intro to Containers

OS-level virtualization is an operating system (OS) paradigm in which the kernel allows the existence of multiple isolated user space instances, called containers (LXC, Solaris containers, Docker, Podman), zones (Solaris containers), virtual private servers (OpenVZ), partitions, virtual environments (VEs), virtual kernels (DragonFly BSD), or jails (FreeBSD jail or chroot jail).[1] Such instances may look like real computers from the point of view of programs running in them. A computer program running on an ordinary operating system can see all resources (connected devices, files and folders, network shares, CPU power, quantifiable hardware capabilities) of that computer. However, programs running inside of a container can only see the container's contents and devices assigned to the container.

A short list of tech to consider: Docker, Fedora CoreOS, Silverblue, Toolbx, Singularity/Apptainer, Podman, LXC, Flatpak

In short, unlike a virtual machine, containers provide abstraction at the operating system level. This can be useful for running proprietary GUI-based applications like Cadence Virtuoso, which e

We can use a CentOS7 image for setting up and running our cadence development.

But how do we then access data?

Docker is a single-purpose *application virtualization* and LXC is a multi-purpose *operating system* virtualization. If one looks for a portability and scalability of the application / micro-service, Docker and Kubernetes is a good choice. If one would like to have several (or even thousands of) portable systems on a single computer, LXC is a good choice.

Docker was not designed out of the box for GUI apps, so you need to have a video server with X11 typically for that.

Linux containers are all based on the virtualization, isolation, and resource management mechanisms provided by the [Linux kernel](https://en.wikipedia.org/wiki/Linux_kernel), notably [Linux namespaces](https://en.wikipedia.org/wiki/Linux_namespaces) and [cgroups](https://en.wikipedia.org/wiki/Cgroups).

#### OS-Level Virtualization (Containers) and Application Virtualization Technologies:

With this tech, different distributions are fine, but other operating systems or kernels are not. Full application virtualization requires a virtualization layer.[[2\]](https://en.wikipedia.org/wiki/Application_virtualization#cite_note-Husain-2) Application virtualization layers replace part of the [runtime environment](https://en.wikipedia.org/wiki/Runtime_environment) normally provided by the operating system. The layer intercepts all disk operations of virtualized applications and transparently redirects them to a virtualized location, often a single file.[[3\]](https://en.wikipedia.org/wiki/Application_virtualization#cite_note-Gurr-3) The application remains unaware that it accesses a virtual resource instead of a physical one. Since the application is now working with one file instead of many files spread throughout the system, it becomes easy to run the application on a different computer and previously incompatible applications can be run side by side. 

A container image is simply a file (or collection of files) saved on disk that stores everything you need to run a target application or applications:

* code
* runtime
* system tools
* libraries
* etc

A container process is simply a standard (Linux) process running on top of the underlying host's operating system and kernel, but whose software environment is defined by the contents of the container image.

> How do I develop in a container, when I need to run a GUI as part of my workflow? What are the limits of containerization? 

#### Limitations of Containers

1. Architecture dependent; always limited by CPU architecture (x86 vs ARM) and binary format (ELF)
2. Portability: Requires glibc and kernel compatibility between host and container; also requires any other kernel-user space API compatibility (e.g., OFED/IB, NVIDIA/GPUs)
   1. Like something built on Ubuntu 22.04 wouldn't work on CentOS 6
3. Filesystem isolation: Filesystem paths are (mostly) different when viewed inside and outside container
   1. By default containers can't see the contents of the host file system. To access host filesystem from inside the file system requires a bit of extra work to 'bind' it. 


#### Most Common Use Cases

* Building and running applications that require older/newer system libraries than are available on the host system
  * Most modern tools, like PyTorch, assume the latest packages, and expect a debian-based environment like Ubuntu, which most HPC system aren't doing. Containers can solve these incompatibilities.
* Running commercial applications binaries that have specific OS requirements not met by the host system.
  * Your license agreement may only give you a compiled binary, which you're  
  * Oh! Wow this is exactly my use case. How do I build a repoducible environment when commercial binaries (maybe even with GUI?) are part of the workflow?
* Converting prexisting Docker containers, which won't work for HPC clusters, to Singularity containers

#### Workflow

1. **Build** your Singularity containers on you local system where you have root or sudo access; e.g., a personal computer where you have installed Singularity
   1. You can't work on native MacOS, as you need to use a Virtual machine with a Ubuntu or Fedora-based OS. This is doubly true, if your Mac has an M1 ARM chipset.
2. **Transfer** your Singularity containers to the HPC system where you want to run them
3. **Run** your Singularity containers on that HPC system




## Why Apptainer? (open-source Singularity fork)

#### Docker

Really designed for network centric services like web servers and databases, but not really meant for HPC systems where many users are sharing a space. Docker assumes you have trust for all users running on systems. Whereas in HPC, the admins don't even trust the users.

Docker also wasn't designed to support batch-based workflows

Docker not designed to support tightly-coupled, highly distributed parallel applications (MPI)

#### Singularity

* Designed at Berkeley Lab as the equivalent for HPC.
* Each container is a single (read-only) image file (unlike the layered arch. in Docker). If you want to change it, you have to to rebuild it.
* No root owned daemon processes
* Support shared/multi-tenant resource environments
* Support HPC Hardware: Infiniband, GPUs
* Supports HPC applications: MPI


#### Conclusion: Use Apptainer

Overview of why not Docker, and the better options:

https://blog.jwf.io/2019/08/hpc-workloads-containers/

Using Singularity/Apptainer with GUI commercial applications:

https://learningpatterns.me/posts/2018-01-30-abaqus-singularity/

https://apptainer.org



## Starting Cadence Virtuoso (IC617 and IC618) from Fedora Linux Client

Install apptainer

```
sudo dnf install apptainer
```

Create a `.def` file with the name `virtuoso_centos7.def`:

```
Bootstrap: docker
From: centos:7
    
%setup
    #run on the host system, after the base container OS is installed. Filepaths are relative to host (fedora)
    mkdir ${APPTAINER_ROOTFS}/users
    mkdir ${APPTAINER_ROOTFS}/tools
    
%environment
    # IC617 doesn't recognize the OS environment properly, need to specify it manually
    export OA_UNSUPPORTED_PLAT=linux_rhel50_gcc48x

%post
    #section to download and install packages before container is immutable
    
    #CentOS 7 image on dockerhub isn't updated, so run this first
    yum -y update && yum clean all
    
    #list of packages required by Cadence Virtusoso IC618
    yum install -y csh tcsh glibc elfutils-libelf ksh mesa-libGL mesa-libGLU motif libXp libpng libjpeg-turbo expat glibc-devel gdb xorg-x11-fonts-misc xorg-x11-fonts-ISO8859-1-75dpi redhat-lsb libXScrnSaver apr apr-util compat-db47 xorg-x11-server-Xvfb mesa-dri-drivers openssl-devel
    
    #For IC617 and below, i686 package versions are required to support 32-bit binaries
    yum install -y glibc.i686 elfutils-libelf.i686 mesa-libGL.i686 mesa-libGLU.i686 motif.i686 libXp.i686 libpng.i686 libjpeg-turbo.i686 expat.i686 glibc-devel.i686 redhat-lsb.i686  
        
    # additional packages required by Cliosoft SOS
    yum install -y libXpm
    
    # additional package required for X11 forwarding
    yum install -y xorg-x11-utils                           
```

Build the container, in an immutable mode:

```
apptainer build virtuoso_centos7.sif virtuoso_centos7.def
```

On the host machine, before running the startup script, we must start a `xhost +`, as discussed in this solution found [here](https://rescale.com/documentation/main/rescale-advanced-features/running-your-custom-code-on-rescale/using-apptainer-singularity/):

```
xhost +
```

Run the immutable container, and start a shell inside:

```
apptainer shell -B /tools,/users virtuoso_centos7.sif
```

Inside the container, check the system configuration with the Cadence provided tool `checkSysConf`:

```
Apptainer> /cadence/cadence/IC618/tools.lnx86/bin/checkSysConf IC6.1.8
or
Apptainer> /tools/cadence/IC618/tools.lnx86/bin/checkSysConf IC6.1.8
```

Finally, run the virtuoso start-up script, using the full path to `tcsh`. Make sure the start up script contains the line `virtuoso &`. 

```
Apptainer> /bin/tcsh ./startup.sh
```

Else you need to source the script instead, and run the command `virtuoso &` manually.




## Troubleshooting

* If you are not able to start Cadence, ensure your environment has both `tcsh` and `ksh` installed.
* Check to make sure the cadence executable is known: `which virutoso`
* To check the current shell interpreter:
```
# Display your current shell name reliably. 
ps -p $$

# Print the shell for the current user but not necessarily the shell that is running at the movement. 
echo "$SHELL"

# Another reliable and simple method to get the current shell interpreter name on Linux or Unix-like systems.
echo $0
```




## Changing shell

Need the `tcsh` and `chsh` commands to be 

To check which shell is active: 

cat /etc/passwd | grep `cd; pwd`

To change shell, by running this and then restarting termina:

chsh -s /usr/bin/tcsh



This works now, but I needed ksh installed.



okay, still complaining that it's not a supported OS. Tried running the checkSysConf tool:


```
/cadence/cadence/IC618/tools.lnx86/bin/checkSysConf
```

Okay, I'm still having issues, and cadence isn't giving me any useful messages. I've ruled the issue with wayland and Xorg, and I've switched to Xorg. My next step is to figure out how to get more verbose information on why Virtuoso isn't starting. All it says right now is:

```
2022/11/30 13:13:40 System is not a supported distribution
2022/11/30 13:13:40 An error occurred. We don't recognize OS 
2022/11/30 13:13:40 WARNING This OS does not appear to be a Cadence supported Linux configuration.
2022/11/30 13:13:40 For more info, please run CheckSysConf in <cdsRoot/tools.lnx86/bin/checkSysConf <productId>
```

Before I start hacking away and changing packages like openssl-devel to be more inline with the CentOS7 system, perhaps I can figure out better exactly what may need to change. Let's look at the CheckSysConf script and try to figure out what the latest supported version of the packages is. What version of Ubuntu is supported? Maybe there is a log message being written somewhere, and the people [here](https://www.edaboard.com/forums/linux-software.21/) might know where to find that log message.


## Which package provides file on RHEL Based System
`dnf provides ./filename`

Then check why a package was explici



The `run`, `exec`, and `shell` commands are the three primary ways in which to interact with a container image. The `run` command will start the container, run the scripts marked for execution inside the container (if any), and then exit. The `exec` commands allows a one time command to be run inside the shell, which then exits. The `shell` command allows an interactive shell to be spun up, which can be exited at will. The first option is good for image usage once it is finalized. The latter two are best for prototyping when building in sandbox mode.

```
WARNING: The sandbox contain files/dirs that cannot be removed with 'rm'.
WARNING: Use 'chmod -R u+rwX' to set permissions that allow removal with 'rm -rf'
WARNING: Use the '--fix-perms' option to 'apptainer build' to modify permissions at build time.
```










I need to install a couple packages within this container. The right process is **not** to enter a shell within the container and run sudo yum install.


Tomorrow:

bind mount the cadence folder
install the lsb-release package
run the cadence compatibility script, and manually specify all the packages to install, until this check is passed
figure out how to start the gui of the container
write define file to make the above reproducible

[docs](https://apptainer.org/docs/user/main/index.html)
[commerical GUI](https://learningpatterns.me/posts/2018-01-30-abaqus-singularity/)
[NIH tutorail](https://hpc.nih.gov/apps/apptainer.html)

Starting the container with Cadence folder available:
`apptainer shell -B /cadence:/cadence virtuoso_centos7.sif`

Okay, so I can't use the --writable option and have stuff automatically bind-mounted. Therefor in sandbox mode, I at least need to create the mountpoints manually.
No the better

```
$ apptainer build virtuoso_centos7_immut.sif virtuoso_centos7.def
$ xhost +
$ apptainer shell -B /cadence:/cadence virtuoso_centos7_immut.sif

Apptainer> /cadence/cadence/IC618/tools.lnx86/bin/checkSysConf IC6.1.8
Apptainer> /bin/tcsh /faust/user/kcaisley/cadence/tsmc65/tsmc_crn65lp_1.7a
```

On the host machine, before running the startup script, we must start a `xhost +` 
Solution found [here](https://rescale.com/documentation/main/rescale-advanced-features/running-your-custom-code-on-rescale/using-apptainer-singularity/)


for the whole bash  vs tcsh problem:

ps -p $$ – Display your current shell name reliably. 

echo "$SHELL" – Print the shell for the current user but not necessarily the shell that is running at the movement. 

echo $0 – Another reliable and simple method to get the current shell interpreter name on Linux or Unix-like systems.



I may want to look at passing the `--nv` flag when trying to do heavy layout work flows.

I think that the reason why `xdpyinfo` didn't work is because I hadn't made the xhost visible to the container.

## To find which package a utility is provided by (that isn't downloaded yet)
```
yum provides /usr/bin/xdpyinfo
```
If the package were downloaded, and if `which` were also on the system, we could do this instead:

```
yum provides `which free`
```

Anyways, we find the right package to install for it is `yum info xorg-x11-utils`

Yes, it does appear that the package is no longer missing. However, now there is no $DISPLAY env variable, so I can't test it. This is because I'm command line only for now.


check where container is running







Further more, some notes from stuff I did in BAG:

# Container Creation
sudo dnf install apptainer
apptainer build --sandbox cbag_centos7.sif docker://centos:7
apptainer shell --fakeroot --writable cbag_centos7.sif/

# For Centos7:
yum -y update && yum clean all
yum install centos-release-scl
yum install devtoolset-8
yum install epel-release
yum install which yaml-cpp yaml-cpp-devel fmt fmt-devel spdlog spdlog-devel cmake3 //note cmake3
source /opt/rh/devtoolset-8/enable

cd to folder and export CC and CXX
tried to build, but didn't work as spdlog wasn't new enough to include .cmake files

# For RockyLinux 8.7:
dnf -y update && dnf clean all
dnf install epel-release
dnf install which yaml-cpp yaml-cpp-devel fmt fmt-devel spdlog spdlog-devel cmake gcc gcc-c++ boost boost-devel

starts compiling after stting static boost to OFF, but then fails at compiling with boost...

# For RockyLinux 9.1:
dnf -y update && dnf clean all
dnf -y install epel-release
dnf -y install which yaml-cpp yaml-cpp-devel fmt fmt-devel spdlog spdlog-devel cmake gcc gcc-c++ boost boost-devel




# Final Container Design for Cadence: (This ist he .def file, used to generate an immutable container)

```
Bootstrap: docker
From: centos:7

	
%setup
    #run on the host system, after the base container OS is installed. Filepaths are relative to host (fedora)
    mkdir ${APPTAINER_ROOTFS}/cadence

%post
    #section to download and install packages before container is immutable
    
    #CentOS 7 image on dockerhub isn't updated, so run this first
    yum -y update && yum clean all
    
    #list of packages required by Cadence
    yum install -y csh tcsh glibc elfutils-libelf ksh mesa-libGL mesa-libGLU motif libXp libpng libjpeg-turbo expat glibc-devel gdb xorg-x11-fonts-misc xorg-x11-fonts-ISO8859-1-75dpi redhat-lsb libXScrnSaver apr apr-util compat-db47 xorg-x11-server-Xvfb mesa-dri-drivers openssl-devel
    yum install -y xorg-x11-utils
```



## There appears to be some permissions issue with writing sandbox containers directly to the NFS directories

The fix is to just write on the host system. If I can't delete a file, just do this first:

` sudo chmod -R +rw cbag_centos7_sandbox.sif/`

`rm -rf cbag_centos7_sandbox.sif/`



# Determining dependencies on Linux:

show library dependencies (pretty simple, actually):
`ldd "executable name"`
including nested dependencies
 `ldd -v  "executable name"`

One has to target the direct (and full) path to the binary:
`/cadence/cadence/IC618/tools.lnx86/dfII/bin/64bit/virtuoso`Interestingly, the are a lot of libraries which are not found, even from within the apptainer:

```
Apptainer> ldd  /cadence/cadence/IC618/tools.lnx86/dfII/bin/64bit/virtuoso
/cadence/cadence/IC618/tools.lnx86/dfII/bin/64bit/virtuoso: /lib64/libstdc++.so.6: version `CXXABI_1.3.8' not found (required by /cadence/cadence/IC618/tools.lnx86/dfII/bin/64bit/virtuoso)
/cadence/cadence/IC618/tools.lnx86/dfII/bin/64bit/virtuoso: /lib64/libstdc++.so.6: version `GLIBCXX_3.4.20' not found (required by /cadence/cadence/IC618/tools.lnx86/dfII/bin/64bit/virtuoso)
/cadence/cadence/IC618/tools.lnx86/dfII/bin/64bit/virtuoso: /lib64/libstdc++.so.6: version `GLIBCXX_3.4.22' not found (required by /cadence/cadence/IC618/tools.lnx86/dfII/bin/64bit/virtuoso)
/cadence/cadence/IC618/tools.lnx86/dfII/bin/64bit/virtuoso: /lib64/libstdc++.so.6: version `CXXABI_1.3.9' not found (required by /cadence/cadence/IC618/tools.lnx86/dfII/bin/64bit/virtuoso)
/cadence/cadence/IC618/tools.lnx86/dfII/bin/64bit/virtuoso: /lib64/libstdc++.so.6: version `GLIBCXX_3.4.21' not found (required by /cadence/cadence/IC618/tools.lnx86/dfII/bin/64bit/virtuoso)
	linux-vdso.so.1 =>  (0x00007ffd18935000)
	libap_sh.so => not found
	libapAssist_sh.so => not found
	libapInfra_sh.so => not found
	libpl_sh.so => not found
	libplt_sh.so => not found
	libadeStateXML_sh.so => not found
	libeadSpectreEmir.so => not found
	libvsacpp.so => not found
	libpthread.so.0 => /lib64/libpthread.so.0 (0x00007fa524600000)
	libpython3.6m.so.1.0 => not found
	libvpsl.so => not found
	libcthDRM.so => not found
	libcrypt.so.1 => /lib64/libcrypt.so.1 (0x00007fa524200000)
	libxerces-c-3.1.so => not found
	libcrypto.so.10 => /lib64/libcrypto.so.10 (0x00007fa523c00000)
	libPolyBool.so => not found
	libprotobuf.so.3.12.2.0 => not found
	libgrpc++.so.1 => not found
	libgrpc.so.11 => not found
	libaddress_sorting.so.11 => not found
	libre2.so => not found
	libupb.so.11 => not found
	libz.so.1 => /lib64/libz.so.1 (0x00007fa523800000)
.....
```
