# Copyright 2016 IBM Corp.
#
# All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e
#
#Cluster Genesis repository 
#
GENESIS_REMOTE="https://github.com/open-power-ref-design-toolkit/cluster-genesis.git"
GENESIS_LOCAL="cluster-genesis"
GENESIS_COMMIT="9ace07b6bc3341ac0efecc6fabb4567077aa6807"
GENESIS_VERSION="release-1.3"
GENESIS_FULL=$(pwd)/$GENESIS_LOCAL

#Point to Genesis script used to generate the dynamic inventory from /var/oprc/inventory.yml
DYNAMIC_INVENTORY=$GENESIS_FULL/"playbooks/inventory.py"

#
#Operations Manager repository 
#
OPSMGR_REMOTE="https://github.com/open-power-ref-design-toolkit/opsmgr.git"
OPSMGR_LOCAL="opsmgr"
OPSMGR_COMMIT="054505c871488d95a94096d67928c8b655123a12"
OPSMGR_VERSION="branch-v3"
OPSMGR_FULL=$(pwd)/$OPSMGR_LOCAL


# Recipe home is assumed to be the current working directory.
ACCEL_DB_HOME=$(pwd)

#Hidden file to store variables needed by install.sh
ACTIVATE_FILE=".accel-activate"
PACKAGE_DIR="playbooks/packages"
#Make Local package directory.
mkdir -p ${PACKAGE_DIR}

#pull cluster-genesis into project directory and patch
./setup_git_repo.sh "${GENESIS_REMOTE}" "${GENESIS_LOCAL}" "${GENESIS_COMMIT}"
./patch_source.sh "${GENESIS_LOCAL}"

#Checking for OPSMGR toggle to clone repo 
if [ ! -z $OPSMGR_DISABLED ]; then
        echo "OpsMgr disabled"
else
        echo "Cloning OpsMgr repository"
        #pull OpsMgr into project directory
        ./setup_git_repo.sh "${OPSMGR_REMOTE}" "${OPSMGR_LOCAL}" "${OPSMGR_COMMIT}"
fi


#Call cluster genesis install script
cd ${GENESIS_LOCAL}
scripts/install.sh

cd ..

#export DYNAMIC_INVENTORY
#
# Move variables to activate file to be sourced by deploy.sh
# This allows us to not require the user to export the variables
# manually, and can be run in a separate environment than the
# install.sh script.
#
echo 'DYNAMIC_INVENTORY='$DYNAMIC_INVENTORY > ${ACTIVATE_FILE}
echo 'GENESIS_FULL='$GENESIS_FULL >> ${ACTIVATE_FILE}
echo 'ACCEL_DB_HOME='$ACCEL_DB_HOME >> ${ACTIVATE_FILE}
echo 'OPSMGR_FULL='$OPSMGR_FULL >> ${ACTIVATE_FILE}
echo 'OPSMGR_DISABLED='$OPSMGR_DISABLED >> ${ACTIVATE_FILE}

