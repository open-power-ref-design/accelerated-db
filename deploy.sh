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
source ${GENESIS_FULL}/${SETUP_ENV_LOC}
cp $1 ${GENESIS_FULL}/config.yml
cd ${GENESIS_FULL}
ansible-playbook -i hosts lxc-create.yml -K && ansible-playbook -i hosts install.yml -K
ansible-playbook -i hosts lxc-create.yml -K && ansible-playbook -i hosts install.yml -K

ansible-playbook -i $DYNAMIC_INVENTORY $PLAYBOOK_LOC -u --private=~/.ssh/id_rsa_ansible-generated
echo $DYNAMIC_INVENTORY
fi
fi

