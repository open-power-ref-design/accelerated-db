#!/bin/bash
export LD_LIBRARY_PATH=/usr/lib/jvm/default-java/jre/lib/ppc64le/server
export MAPD_LIBJVM_DIR=/usr/lib/jvm/default-java/jre/lib/ppc64le/server
export MAPD_STORAGE=/var/lib/mapd
export MAPD_USER=ubuntu
export MAPD_PATH=/opt/mapd

#May have to run twice
nvidia-xconfig --use-display-device=none --enable-all-gpus --preserve-busid
nvidia-xconfig --use-display-device=none --enable-all-gpus --preserve-busid

sudo mkdir -p $MAPD_STORAGE/data
sudo chown -R $MAPD_USER $MAPD_STORAGE

$MAPD_PATH/bin/initdb $MAPD_STORAGE/data

cd $MAPD_PATH/systemd
echo -e "\n" | ./install_mapd_systemd.sh 

systemctl start mapd_server
systemctl start mapd_web_server

systemctl enable mapd_server
systemctl enable mapd_web_server

#Pause to ensure servers are up
sleep 5
echo $MAPD_PATH
cd $MAPD_PATH
$MAPD_PATH/insert_sample_data <<< 2

