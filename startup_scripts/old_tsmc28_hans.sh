#############################################################
################ environment setting ########################
#############################################################

export LANG=C

# Cadence should be started from a PDK specific working dir, e.g. `~/cadence/tsmc28`
if [ "$HOME" == "$PWD" ]; then
   echo "You can't start cadence from your HOME directory."
   exit 1
fi

export CDS_QUIET=no

export OA_UNSUPPORTED_PLAT=linux_rhel60

export TOOLS_PATH=/tools/cadence
export RELEASE_YEAR=2022-23

export LM_LICENSE_FILE=8000@faust02.physik.uni-bonn.de

export CDSDIR=$TOOLS_PATH/$RELEASE_YEAR/RHELx86/IC_6.1.8.320
#export ASSURAHOME=$TOOLS_PATH/$RELEASE_YEAR/RHELx86/ASSURA_04.16.113_618
export MMSIM=$TOOLS_PATH/$RELEASE_YEAR/RHELx86/SPECTRE_21.10.751
#export AMSHOME=$TOOLS_PATH/$RELEASE_YEAR/RHELx86/INCISIVE_15.20.058
export PVSHOME=$TOOLS_PATH/$RELEASE_YEAR/RHELx86/PVS_21.12.000

export EXT=/cadence/cadence/EXT161
export CLIOSOFT_DIR=/cadence/clio/sos7

export CDS_AUTO_64BIT=ALL
#export CDS_AUTO_64BIT="EXCLUDE:si"
export CDS=$CDSDIR
export CDSHOME=$CDSDIR
export CDS_HIER=$CDSDIR

export QRC_ENABLE_EXTRACTION=1
export QRC_HOME=EXT

#export=USE_CALIBRE_VCO ixl
export MGC_HOME=/cadence/mentor/calibre
export CALIBRE_HOME=/cadence/mentor/calibre
export SYN_HSPICE=/cadence/synopsis/hspice/bin

export GDM_USE_SHLIB_ENVVAR=1
export SOS_CDS_EXIT=yes

export SPECTRE_DEFAULTS=-E
export CDS_LOAD_ENV=CWDElseHome

#export OSS_IRUN_BIND2= YES
#export pvs_source_added_place= TRUE

#export OA_HOME= ${CDSDIR}/oa_v22.41.018
#export OA_HOME= ${CDSDIR}/oa
#export OA_HOME= /cadence/cadence/EDI11/oa_v22.43.003
#export OA_HOME= /cadence/cadence/EXT152/oa_v22.50.034

alias help_cds_ic='$CDS_IC/tools/cdnshelp/bin/cdnshelp &'

export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/${CLIOSOFT_DIR}/lib:${CLIOSOFT_DIR}/lib/64bit:${PVSHOME}/tools/lib

# export PATH=${MMSIM}/tools/bin:${MMSIM}/tools/dfII/bin:${CDSDIR}/tools/bin:${CDSDIR}/tools/dfII/bin:${EXT}/bin:${EXT}/tools/bin:${ASSURAHOME}/tools/bin:${ASSURAHOME}/tools/dfII/bin:${AMSHOME}/tools/dfII/bin:${AMSHOME}/tools/bin:${MGC_HOME}/bin:${CLIOSOFT_DIR}/bin:${SYN_HSPICE}:${PVSHOME}/bin:${PATH}

export PATH=${MMSIM}/tools/bin:${MMSIM}/tools/dfII/bin:${CDSDIR}/tools/bin:${CDSDIR}/tools/dfII/bin:${EXT}/bin:${EXT}/tools/bin:${MGC_HOME}/bin:${CLIOSOFT_DIR}/bin:${SYN_HSPICE}:${PVSHOME}/bin:${PATH}

export CDS_USE_PALETTE
# disable openGL for VIVA - old driver problems
# export CDS_WAVESCAN_OPENGL="-Dsun.java2d.opengl=False" 
#export AHDLCMI_GCC_HOME $MMSIM/tools/systemc/gcc/install

#############################################################
####################### PDK SETTINGS ########################
#############################################################

###  Setting for cds PDK
export OSS_IRUN_BIND2=YES
### 
export PDK_PATH=/cadence/kits/TSMC/CRN28HPC+
export PDK_RELEASE=HEP_DesignKit_TSMC28_HPCplusRF_v1.0 #cern.20210311
export PDK_OPTION=1P9M_5X1Y1Z1U_UT_AlRDL
export TSMC_PDK=$PDK_PATH/$PDK_RELEASE/

### Set the default netlisting mode to "Analog" - the recommended default 
### Default may be "Digital" depending on the virtuoso executable. 
export CDS_Netlisting_Mode=Analog

### Setting for PVS/QUANTUS
export PVS_QRCTECHDIR=$PDK_PATH/$PDK_RELEASE/pdk/$PDK_OPTION/cdsPDK/PVS_QUANTUS
export PV_COLOR_DIR=$PVS_QRCTECHDIR/.color_setup

################ Create the local cds.lib file
 if [ ! -f ./cds.lib ]; then
	cp $PDK_PATH/$PDK_RELEASE/CERN/StartFiles/cds.lib .
	cp $PDK_PATH/$PDK_RELEASE/CERN/StartFiles/cdsinit.pdk .cdsinit
	cp $PDK_PATH/$PDK_RELEASE/CERN/StartFiles/cdsLibMgr.il .
	
   echo "Creating new config files"
 fi
 
   chmod 775 ./cds.lib
   chmod 775 ./.cdsinit
   chmod 775 ./cdsLibMgr.il
   
################ Calibre Default Switches ################


############### Create Temp Direcotories ################

	if [ ! -d /tmp/$USER/DRC ]; then
  		mkdir -p /tmp/$USER/DRC
	fi
	
    if [ ! -d ./DRC ]; then
	  ln -s /tmp/$USER/DRC DRC
    fi
  
    if [ ! -d /tmp/$USER/LVS ]; then
  		mkdir -p /tmp/$USER/LVS
	fi
	
    if [ ! -d ./LVS ]; then
  	  ln -s /tmp/$USER/LVS LVS
    fi

   	if [ ! -d /tmp/$USER/SIM ]; then
  		mkdir -p /tmp/$USER/SIM
	fi
	
    if [ ! -d ./SIM ]; then
  	  ln -s /tmp/$USER/SIM SIM
    fi
  
	if [ ! -d /tmp/$USER/XRC ]; then
  		mkdir -p /tmp/$USER/XRC 
	fi
	
    if [ ! -d ./XRC ]; then
  	   ln -s /tmp/$USER/XRC  XRC
    fi
	
##########################################

# xterm
virtuoso

exit 0

################ end of script ###########