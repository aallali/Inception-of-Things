#!/bin/bash

export TOKEN_FILE="/vagrant/scripts/node-token"
export INSTALL_K3S_EXEC="agent --server https://$1:6443 --token-file $TOKEN_FILE --node-ip=$2"
# export K3S_URL="https://192.168.42.110:6443"
# export K3S_TOKEN=`cat $TOKEN_FILE`
# curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="agent --server https://192.168.42.110:6443 --token-file /vagrant/scripts/node-token --node-ip=192.168.42.111" sh -

echo "Running agent..."
curl -sfL https://get.k3s.io | sh -

echo "[TOOLS] : install ifconfig tool ..."
sudo yum install net-tools -y

echo "[SETUP] : initiat aliases for all machine users "
# echo "alias k=kubectl" >> ~/.bashrc <-- this doesnt work someshow ! 
echo "alias k='kubectl'" >> /etc/profile.d/00-aliases.sh
# read more about it here:
### https://askubuntu.com/questions/610052/how-can-i-preset-aliases-for-all-users

echo "[machine : $(hostname)] has been setup succefully!"