#execute deployer
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
export ANSIBLE_HOST_KEY_CHECKING=False

ansible-playbook -i hosts lxc-create.yml -K && ansible-playbook -i hosts install.yml -K

# wait 15 minutes for install to complete.
sleep 15m
cd ../../
ansible-playbook -i $DYNAMIC_INVENTORY $PLAYBOOK_LOC -u root --private=~/.ssh/id_rsa_ansible-generated
echo $DYNAMIC_INVENTORY
fi
fi

