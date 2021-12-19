#!/bin/bash

echo "[K3S] : installing..."
export INSTALL_K3S_EXEC="--write-kubeconfig-mode=644 --tls-san $(hostname) --node-ip $1  --bind-address=$1 --advertise-address=$1 "
curl -sfL https://get.k3s.io |  sh -

echo "[K3S] : Copy naster-node-token to (/vagrant/scripts/node-token)"
# copy the master node token outside to the shared folder so workers node can connect to it
sudo cp /var/lib/rancher/k3s/server/node-token /vagrant/scripts/


echo "[TOOLS] : install ifconfig tool ..."
sudo yum install net-tools -y

echo "[SETUP] : initiat aliases for all machine users "
# echo "alias k=kubectl" >> ~/.bashrc <-- this doesnt work somehow ! 
echo "alias k='kubectl'" >> /etc/profile.d/00-aliases.sh
# read more about it here:
### https://askubuntu.com/questions/610052/how-can-i-preset-aliases-for-all-users

echo "[machine : $(hostname)] has been setup succefully!"

# /usr/local/bin/k3s-uninstall.sh
