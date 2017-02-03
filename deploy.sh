#execute deployer
set -e
ACTIVATE_FILE=".accel-activate"
PLAYBOOK_LOC="playbooks/nvidia_driver.yml"
SETUP_ENV_LOC="scripts/setup-env"
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

sed -i /sources.list/s/^/#/ os_images/config/ubuntu-16.04.1-server-ppc64el.seed

source ${SETUP_ENV_LOC}
cd playbooks
#export ANSIBLE_HOST_KEY_CHECKING=

ansible-playbook -i hosts lxc-create.yml -K && ansible-playbook -i hosts install.yml -K


# wait 20m minutes for install to complete.
echo "Wait 20 minutes for install to complete"
sleep 20m

#Cluster Node Networking
ansible-playbook -i $DYNAMIC_INVENTORY ssh_keyscan.yml -u root --private-key=~/.ssh/id_rsa_ansible-generated
ansible-playbook -i $DYNAMIC_INVENTORY gather_mac_addresses.yml -u root --private-key=~/.ssh/id_rsa_ansible-generated
ansible-playbook -i $DYNAMIC_INVENTORY configure_operating_systems.yml -u root --private-key=~/.ssh/id_rsa_ansible-generated

#Nvidia driver install
cd ../../
ansible-playbook -i $DYNAMIC_INVENTORY $PLAYBOOK_LOC -u root --private=~/.ssh/id_rsa_ansible-generated
echo $DYNAMIC_INVENTORY
fi
fi

