#!/bin/bash
export MAPD_STORAGE=/var/lib/mapd
export MAPD_USER=ubuntu
export MAPD_PATH=/opt/mapd

echo "export MAPD_USER=mapd
export MAPD_GROUP=mapd
export MAPD_STORAGE=/var/lib/mapd
export MAPD_PATH=/opt/mapd" >> /home/$MAPD_USER/.bashrc

cd $MAPD_PATH/systemd
echo -e "\n" | ./install_mapd_systemd.sh 

systemctl start mapd_server
systemctl start mapd_web_server

systemctl enable mapd_server
systemctl enable mapd_web_server

#Pause to ensure servers are up
sleep 100
echo $MAPD_PATH
cd $MAPD_PATH
$MAPD_PATH/insert_sample_data <<< 2

