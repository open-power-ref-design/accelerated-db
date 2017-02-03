#Reset machine to initial state
sudo lxc-ls --fancy
sudo lxc-stop -n ubuntu-14-04-deployer
sudo lxc-destroy -n ubuntu-14-04-deployer
sudo lxc-ls --fancy
rm /home/ubuntu/.ssh/known_hosts
rm -rf cluster-genesis
