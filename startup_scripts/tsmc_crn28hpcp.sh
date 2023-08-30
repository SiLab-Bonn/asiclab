#!/bin/bash

# Usage instructions:
# * `cd ~/cadence/tsmc28`
# * `source ./tsmc_crn28hpcp.sh`
# * `virtuoso &`

# Cadence tools should be started from a PDK specific working dir, e.g. `~/cadence/tsmc28`
if [ "$HOME" == "$PWD" ]; then
   echo "You shouldn't start cadence tools from your HOME directory."
   echo "It will create a bunch of Virtuoso-specific stuff you don't want in there."
   echo "Instead use a PDK-specific working dir, e.g: ~/cadence/tsmc28"
   # having just an exit will cause sourcing the script to crash the terminal
   # having just a `return` will casues execution of this script to fail
   # therefore, we do both:
   return 2> /dev/null; exit  # learned from https://www.baeldung.com/linux/safely-exit-scripts#the-return-command
fi

### FlexLM: License manager server
export LM_LICENSE_FILE="8000@faust02.physik.uni-bonn.de"

# Tells Cadence tools which version of OA to use, if it can't intuit the OS
export OA_UNSUPPORTED_PLAT=linux_rhel60
# Make sure all CDS tools start in 64-bit mode
export CDS_AUTO_64BIT=ALL

# Variables to just avoid repetition & easily change to new release
export CDS_TOOLS_PREFIX="/tools/cadence"
export RELEASE_YEAR="2022-23"

####################### Tool Specific Settings ########################

### Cadence Virtuoso: Full custom analog design
export CDS_IC="${CDS_TOOLS_PREFIX}/${RELEASE_YEAR}/RHELx86/IC_6.1.8.320"
# This line is required by some design kits...
export CDSDIR=$CDS_IC
# When using ADE set netlisting mode to analog ("dfIIconfig.pdf"), p16. Alternative is 'digital'
export CDS_Netlisting_Mode=Analog
# Required for tutorial material and cadence libraries (eg analogLib). Not used to set path
export CDSHOME=$CDS_IC
export CDS_USE_PALETTE
# provides commands `virtuoso` 
export PATH="${PATH}:${CDS_IC}/tools/bin"
export PATH="${PATH}:${CDS_IC}/tools/dfII/bin"
export PATH="${PATH}:${CDS_IC}/tools/plot/bin"
alias help_cds_ic='$CDS_IC/tools/cdnshelp/bin/cdnshelp &'

### Cadence Spectre: Analog simulation
export CDS_SPECTRE="${CDS_TOOLS_PREFIX}/${RELEASE_YEAR}/RHELx86/SPECTRE_21.10.751"
export SPECTRE_DEFAULTS=-E
# provides commands `spectre`, `ultrasim`, `aps`
export PATH="${PATH}:${CDS_SPECTRE}/bin"
export PATH="${PATH}:${CDS_SPECTRE}/tools/bin"
export PATH="${PATH}:${CDS_SPECTRE}/tools/dfII/bin"
export PATH="${PATH}:${CDS_SPECTRE}/tools/plot/bin"
# Create alias to easily start help
alias help_cds_spectre='$CDS_SPECTRE/tools/cdnshelp/bin/cdnshelp &'

### Cadence PVS: a replacement for the DRC/LVS/PERC portions of Assura, PVE, EXT, etc below 45nm
export CDS_PVS="${CDS_TOOLS_PREFIX}/${RELEASE_YEAR}/RHELx86/PVS_21.12.000"
# provides commands `pvs` and `k2_viewer`
export PATH="${PATH}:${CDS_PVS}/bin"
export PATH="${PATH}:${CDS_PVS}/tools/bin"
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${CDS_PVS}/tools/lib"    # not sure if necessary?
# Create alias to easily start help
alias help_cds_pvs='$CDS_PVS/tools/cdnshelp/bin/cdnshelp &'

### Cadence Quantus: a replacement for the PEX aka QRC components of Assura, PVE, EXT, etc below 45nm
export CDS_QUANTUS="${CDS_TOOLS_PREFIX}/${RELEASE_YEAR}/RHELx86/QUANTUS_21.11.000"
# non-path ENV var, used by cadence
export QRC_HOME=$CDS_QUANTUS
# provides commands qrc
export PATH="${PATH}:${CDS_QUANTUS}/bin"
#export PATH="${PATH}:${CDS_QUANTUS}/tools/bin"  # commented out in the example scripts
# Create alias to easily start help
alias help_cds_qrc='$CDS_QUANTUS/tools/cdnshelp/bin/cdnshelp=&'

### Cadence Xcelium: digital simulation replacement for Incisive, ncsim, AMSHOME etc
export CDS_XCELIUM="${CDS_TOOLS_PREFIX}/${RELEASE_YEAR}/RHELx86/XCELIUM_22.03.005"
# provides commands `xrun`, `simvision`, `xmvhdl`, `xmvlog`, `xmsc`, `xmelab`, `xmsim`, `xmls`, `xmhelp`, `xfr`, `xmxlimport`
export PATH="${PATH}:${CDS_XCELIUM}/bin"
export PATH="${PATH}:${CDS_XCELIUM}/tools/bin"
export PATH="${PATH}:${CDS_XCELIUM}/tools/cdsgcc/gcc/bin"
# Create alias to easily start help
alias help_cds_xcelium='$CDS_XCELIUM/tools/cdnshelp/bin/cdnshelp &'

# Cliosoft: Version control system for OA design libs
export CLIOSOFT_DIR=/tools/clio/sos7
export PATH="${CLIOSOFT_DIR}/bin:${PATH}"
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${CLIOSOFT_DIR}/lib"
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${CLIOSOFT_DIR}/lib/64bit"
export SOS_CDS_EXIT=yes

####################### PDK Specific Settings ########################

export PDK_PATH="/tools/kits/TSMC/CRN28HPC+"
export PDK_RELEASE="HEP_DesignKit_TSMC28_HPCplusRF_v1.0"  # e.g. cern.20210311
export PDK_OPTION="1P9M_5X1Y1Z1U_UT_AlRDL"
export TSMC_PDK="${PDK_PATH}/${PDK_RELEASE}/"

# From `HEP_DesignKit_TSMC28_HPCplusRF_v1.0/cdsusers/setup.csh`
export OSS_IRUN_BIND2=YES # Not sure of purpose... and should this be XRUN, as we use Xcelium and not Incisive?

# Setting for PVS, again from `HEP_DesignKit_TSMC28_HPCplusRF_v1.0/cdsusers/setup.csh`
export PVS_QRCTECHDIR="${PDK_PATH}/${PDK_RELEASE}/pdk/${PDK_OPTION}/cdsPDK/PVS_QUANTUS"
export PV_COLOR_DIR="${PVS_QRCTECHDIR}/.color_setup"

# Create the copy default 28nm Virtuoso files locally, if not already present
if [ ! -f ./cds.lib ]; then
    echo "Copying default config files (cds.lib, .cdsinit, cdsLibMgr.il) from PDK to local dir..."
    cp $PDK_PATH/$PDK_RELEASE/CERN/StartFiles/cds.lib .
    cp $PDK_PATH/$PDK_RELEASE/CERN/StartFiles/.cdsinit .    # This SKILL script calls the corresponding cdsinit.pdk script
    cp $PDK_PATH/$PDK_RELEASE/CERN/StartFiles/cdsLibMgr.il .
    echo "Copying done!"
fi

# Make sure Virtuoso config files are executable
chmod 775 ./cds.lib
chmod 775 ./.cdsinit
chmod 775 ./cdsLibMgr.il

############### Create Temp Directories ################

directories=("DRC" "LVS" "SIM" "XRC")

# Fancy loop which repeats the same process for the four locations listed above
for dir in "${directories[@]}"; do
    if [ ! -d /tmp/"$USER"/"$dir" ]; then
        mkdir -p /tmp/"$USER"/"$dir"
        echo "Created directory: /tmp/$USER/$dir"
    fi

    if [ ! -d ./"$dir" ]; then
        ln -s /tmp/"$USER"/"$dir" "$dir"
        echo "Created local symbolic link: $dir"
    fi
done

# see lines 12-14 above for explanation of this exit command
return 2> /dev/null; exit
