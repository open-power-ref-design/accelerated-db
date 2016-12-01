#execute deployer
ACTIVATE_FILE=".accel-activate"
PLAYBOOK_LOC="playbooks/nvidia_driver.yml"
SETUP_ENV_LOC="scripts/setup-env"
if [ ! -f $ACTIVATE_FILE ];
then
	echo "ERROR: CAN'T FIND ACTIVATE FILE.  DID YOU RUN install.sh FIRST?"
else

source ${ACTIVATE_FILE}
source ${GENESIS_FULL}/${SETUP_ENV_LOC}
ansible-playbook -i $DYNAMIC_INVENTORY $PLAYBOOK_LOC -u --private=~/.ssh/id_rsa_ansible-generated
#echo $DYNAMIC_INVENTORY
fi


