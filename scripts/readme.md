This is a collection of startup scripts which configure the environment for a given PDK including the Cadence tools version. To use the startup script for a specific project, additional environment variables might have to be set. For example

SOS_ROOT_DIR and/or CDS_PROJECT are commonly used variables used in project specific cds.lib files to configure the library manager.

A wrapper for the startup script could look like this:

    # cad_tsmc28.sh start script
    cd <path to the project work folder> # switch to a project path
    export SOS_ROOT_DIR=<path to the SOS managed design files>
    export CDS_PROJECT=<path to the SOS managed design files>
    ~/tsmc_crn28hpcp.sh


Check /tools/kits/TSMC/CRN65LP/Base_PDK_2017/setup for 65 ... was this modified?
Check /tools/kits/TSMC/CRN28HPC+/HEP_DesignKit_TSMC28_HPCplusRF_v1.0/CERN/StartFiles for 28