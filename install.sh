
GENESIS_REMOTE="https://github.com/open-power-ref-design/cluster-genesis.git"
GENESIS_LOCAL="cluster-genesis"
GENESIS_COMMIT="730985b4dce2f3fee94938651d67f90df387b9c9" # I.e. "3.2"
GENESIS_VERSION="0.9"
GENESIS_FULL=$(pwd)/$GENESIS_LOCAL
ACCEL_DB_HOME=$(pwd)
DKMS_LOCATION="http://mirrors.kernel.org/ubuntu/pool/main/d/dkms/dkms_2.2.0.3-2ubuntu11_all.deb"
CUDA_REPO="https://developer.nvidia.com/compute/cuda/8.0/prod/local_installers/cuda-repo-ubuntu1604-8-0-local_8.0.44-1_ppc64el-deb"
PACKAGE_DIR="playbooks/packages"
DYNAMIC_INVENTORY=$GENESIS_FULL/"scripts/python/yggdrasil/inventory.py"
ACTIVATE_FILE=".accel-activate"
CUDA_FILE=${PACKAGE_DIR}/cuda8.deb
DKMS_FILE=${PACKAGE_DIR}/dkms.deb
#sudo apt-get install aptitude

./setup_git_repo.sh "${GENESIS_REMOTE}" "${GENESIS_LOCAL}" "${GENESIS_COMMIT}"

sed -i /sources.list/s/^/#/ ${GENESIS_LOCAL}/os_images/config/*.seed

mkdir -p ${PACKAGE_DIR}


#Download Cuda Repo
if [ ! -f ${CUDA_FILE} ];
then
        echo "Downloading Cuda repository"
	wget  ${CUDA_REPO} -O ${CUDA_FILE}
else
	echo "SKIPPING: Cuda repo already downloaded"
fi
if [ ! -f ${DKMS_FILE} ];
then
        echo "Downloading dkms package"
	wget  ${DKMS_LOCATION} -O ${DKMS_FILE}
else
	echo "SKIPPING: dkms package already downloaded"
fi



#call cluster genesis install script
cd ${GENESIS_LOCAL}
scripts/install.sh
cd ..
export DYNAMIC_INVENTORY
echo "DYNAMIC " $DYNAMIC_INVENTORY
#
# Move variables to activate file to be sourced by deploy.sh
# This allows us to not require the user to export the variables
# manually, and can be run in a separate environment than the
# install.sh script.
#
echo 'DYNAMIC_INVENTORY='$DYNAMIC_INVENTORY > ${ACTIVATE_FILE}
echo 'GENESIS_FULL='$GENESIS_FULL >> ${ACTIVATE_FILE}
echo 'ACCEL_DB_HOME='$ACCEL_DB_HOME >> ${ACTIVATE_FILE}
