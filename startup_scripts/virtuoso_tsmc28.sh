#!/bin/bash

################ Environment/Path Setting ########################

# Cadence should be started from a PDK specific working dir, e.g. `~/cadence/tsmc28`
if [ "$HOME" == "$PWD" ]; then
   echo "You can't start cadence from your HOME directory."
   exit 1
fi

export TOOLS_PATH=/tools/cadence
export RELEASE_YEAR=2022-23

export LM_LICENSE_FILE=8000@faust02.physik.uni-bonn.de


export CDS_IC=$TOOLS_PATH/$RELEASE_YEAR/RHELx86/IC_6.1.8.320
export PATH=${CDS_IC}/tools/bin:${PATH}
export PATH=${CDS_IC}/tools/dfII/bin:${PATH}
export PATH=${CDS_IC}/tools/plot/bin:${PATH}
alias help_cds_ic='$CDS_IC/tools/cdnshelp/bin/cdnshelp &'


export CDS_SPECTRE=$TOOLS_PATH/$RELEASE_YEAR/RHELx86/SPECTRE_21.10.751
# provides spectre, ultrasim, aps
export PATH="${PATH}:${CDS_SPECTRE}/bin"
export PATH=${CDS_SPECTRE}/tools/dfII/bin:${PATH}
export PATH=${CDS_SPECTRE}/tools/bin
export PATH=${CDS_SPECTRE}/tools/dfII/bin:${PATH}
alias help_cds_spectre='$CDS_SPECTRE/tools/cdnshelp/bin/cdnshelp &'


# replacement for Assura, PVE, EXT, etc, for below 45nm nodes
export CDS_PVS=$TOOLS_PATH/$RELEASE_YEAR/RHELx86/PVS_21.12.000
export LD_LIBRARY_PATH=${CDS_PVS}/tools/lib:${LD_LIBRARY_PATH}
alias help_cds_pvs='$CDS_PVS/tools/cdnshelp/bin/cdnshelp &'

# replacement for AMSHOME, Incisive, ncsim, etc
export CDS_XCELIUM=$TOOLS_PATH/$RELEASE_YEAR/RHELx86/XCELIUM_22.03.005
# provides xrun, simvision, xmvhdl, xmvlog, xmsc, xmelab, xmsim, xmls, xmhelp, xfr, xmxlimport
export PATH="${PATH}:${CDS_XCELIUM}/bin:${CDS_XCELIUM}/tools/bin:${CDS_XCELIUM}/tools/cdsgcc/gcc/bin"
export PATH=${EXT}/bin:${PATH}
export PATH=${EXT}/tools/bin:${PATH}
export PATH=${CDS_PVS}/bin:${PATH}
# Create aliases to easily start help
alias help_cds_xcelium='$CDS_XCELIUM/tools/cdnshelp/bin/cdnshelp &'


export CLIOSOFT_DIR=/tools/clio/sos7
export PATH=${CLIOSOFT_DIR}/bin:${PATH}
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/${CLIOSOFT_DIR}/lib
export LD_LIBRARY_PATH=${CLIOSOFT_DIR}/lib/64bit:${LD_LIBRARY_PATH}
export SOS_CDS_EXIT=yes


export PATH=${MGC_HOME}/bin:${PATH}
export MGC_HOME=/cadence/mentor/calibre
export CALIBRE_HOME=/cadence/mentor/calibre


export QRC_ENABLE_EXTRACTION=1
export QRC_HOME=EXT

export GDM_USE_SHLIB_ENVVAR=1


####################### Tool Specific Settings ########################

# Set the default netlisting mode to "Analog" for Virtuoso/Spectre
# as the alternative "Digital", may have been default 
export CDS_Netlisting_Mode=Analog

# Purpose?
export CDS_USE_PALETTE

export SPECTRE_DEFAULTS=-E

# Setting from Europractice example start script, not sure on purpose?
# I think this should be XRUN, and not IRUN though, as we use Xcelium and not Incisive
export OSS_IRUN_BIND2=YES

# Tells Virtuoso which version of OA to use, if it can't intuit the OS
export OA_UNSUPPORTED_PLAT=linux_rhel60

export CDS_AUTO_64BIT=ALL

export CDS_LOAD_ENV=CWDElseHome


####################### PDK Specific Settings ########################

export PDK_PATH=/tools/kits/TSMC/CRN28HPC+
export PDK_RELEASE=HEP_DesignKit_TSMC28_HPCplusRF_v1.0  # e.g. cern.20210311
export PDK_OPTION=1P9M_5X1Y1Z1U_UT_AlRDL
export TSMC_PDK=$PDK_PATH/$PDK_RELEASE/

# Setting for PVS/QUANTUS
export PVS_QRCTECHDIR=$PDK_PATH/$PDK_RELEASE/pdk/$PDK_OPTION/cdsPDK/PVS_QUANTUS
export PV_COLOR_DIR=$PVS_QRCTECHDIR/.color_setup

# Create the copy default 28nm Virtuoso files locally, if not already present
if [ ! -f ./cds.lib ]; then
    cp $PDK_PATH/$PDK_RELEASE/CERN/StartFiles/cds.lib .
    cp $PDK_PATH/$PDK_RELEASE/CERN/StartFiles/cdsinit.pdk .cdsinit
    cp $PDK_PATH/$PDK_RELEASE/CERN/StartFiles/cdsLibMgr.il .
    echo "Creating new config files"
fi

# Make sure Virtuoso config files are executable
chmod 775 ./cds.lib
chmod 775 ./.cdsinit
chmod 775 ./cdsLibMgr.il

############### Create Temp Directories ################

directories=("DRC" "LVS" "SIM" "XRC")

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

exit 0