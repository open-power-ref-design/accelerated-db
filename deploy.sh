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

#execute deployer
set -e
ACTIVATE_FILE=".accel-activate"
PLAYBOOK_LOC="playbooks/nvidia_driver.yml"
#### NEED PROMPTS REMOVED WORKAROUND BELOW
####SETUP_ENV_LOC="scripts/setup-env"
SETUP_ENV_LOC="deployenv/bin/activate"
if [ ! -f $ACTIVATE_FILE ];
then
	echo "ERROR: CAN'T FIND ACTIVATE FILE.  DID YOU RUN install.sh FIRST?"
else
if [ -z "$1" ]; then
	echo "ERROR: Please pass in config file"
else
source ${ACTIVATE_FILE}
cp $1 ${GENESIS_FULL}/config.yml
cd ${GENESIS_FULL}

source ${SETUP_ENV_LOC}
cd playbooks

ansible-playbook -i hosts lxc-create.yml -K && ansible-playbook -i hosts install_1.yml && ansible-playbook -i hosts install_2.yml -K

# wait 20m minutes for install to complete.
echo "Wait 20 minutes for install to complete"
sleep 20m

#Cluster Node Networking
ansible-playbook -i $DYNAMIC_INVENTORY ssh_keyscan.yml 
ansible-playbook -i $DYNAMIC_INVENTORY gather_mac_addresses.yml 
ansible-playbook -i $DYNAMIC_INVENTORY configure_operating_systems.yml

#Deployer as a router
cd ../../
ssh -i ~/.ssh/id_rsa_ansible-generated deployer@192.168.3.2 'sudo apt-get update && sudo apt-get install -y iptables'
ssh -i ~/.ssh/id_rsa_ansible-generated deployer@192.168.3.2 'sudo bash -s' < nat.sh

#Nvidia driver install
ansible-playbook -i $DYNAMIC_INVENTORY $PLAYBOOK_LOC
echo $DYNAMIC_INVENTORY

#Install OpsMgr
cd ${OPSMGR_FULL}/recipes/standalone
sudo ./clean-opsmgr.sh
sudo ./clean-prereq.sh
sudo ./bootstrap-prereq.sh
sudo ./bootstrap-opsmgr.sh
sudo ./provision-prereq.sh
sudo ./provision-opsmgr.sh

fi
fi

