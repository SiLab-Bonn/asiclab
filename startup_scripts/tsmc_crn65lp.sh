#############################################################
################ environment setting ########################
#############################################################

export LANG=C

if [ $HOME == $PWD ]; then
   echo "You can't start cadence from your HOME directory."
   exit 1
fi

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

alias help_cds_ic='$CDS_IC/tools/cdnshelp/bin/cdnshelp &'

export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/${CLIOSOFT_DIR}/lib:${CLIOSOFT_DIR}/lib/64bit:${PVSHOME}/tools/lib

export PATH=${MMSIM}/tools/bin:${MMSIM}/tools/dfII/bin:${CDSDIR}/tools/bin:${CDSDIR}/tools/dfII/bin:${EXT}/bin:${EXT}/tools/bin:${MGC_HOME}/bin:${CLIOSOFT_DIR}/bin:${SYN_HSPICE}:${PVSHOME}/bin:${PATH}

export CDS_USE_PALETTE

#############################################################
####################### PDK SETTINGS ########################
#############################################################

###  Setting for cds PDK
export OSS_IRUN_BIND2=YES
### 
export PDK_PATH=/cadence/kits/TSMC/CRN65LP/Base_PDK
export PDK_RELEASE=V1.7A_1
export PDK_OPTION=1p9m6x1z1u
export OPTION=$PDK_OPTION
export TSMC_PDK=$PDK_PATH/$PDK_RELEASE/$PDK_OPTION
export TSMC_DIR=$TSMC_PDK

### Set the default netlisting mode to "Analog" - the recommended default 
### Default may be "Digital" depending on the virtuoso executable. 
export CDS_Netlisting_Mode=Analog

################ Create the local cds.lib file
 if [ ! -f ./cds.lib ]; then
	cp ${PDK_PATH}/setup/cds.lib .
	cp ${PDK_PATH}/setup/pvtech.lib .
	cp ${PDK_PATH}/setup/cdsinit .cdsinit
	cp ${PDK_PATH}/setup/cdsLibMgr.il .
	
   echo "Creating new config files"
 fi
 
   chmod 775 ./cds.lib
   chmod 775 ./.cdsinit
   chmod 775 ./cdsLibMgr.il
   chmod 775 ./pvtech.lib   
   
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
