# setup TCAD environment
# usage `source sentaurus.sh
export LM_LICENSE_FILE=8000@faust02.physik.uni-bonn.de
export STROOT=/tools/synopsys/2022-23/RHELx86/SENTAURUS_2022.12
export PATH="${PATH}:${STROOT}/bin"
export STRELEASE=current
export STDB="${HOME}/tcad"

export DMW_RSH_PATH=/usr/bin/ssh
# swb, svisual; snmesh, sde, tdx, etc...

echo 'Sentarus TCAD tools are available'
echo 'swb, svisual; snmesh, sde, tdx, etc...'
