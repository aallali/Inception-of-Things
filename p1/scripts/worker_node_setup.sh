#!/bin/bash

mkdir ~/.ssh
cat /tmp/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 400 ~/.ssh/authorized_keys
chown root:root ~/.ssh/authorized_keys

echo "$1 aallaliS" >> /etc/hosts
# copy k3s-node-token from the master node so we can connect to the master with that token as agent/worker
# scp -o StrictHostKeyChecking=no root@$1:/var/lib/rancher/k3s/server/token /tmp/token
# [K3s] : install k3s as agent ...
## agent                : indicate that we are running as agent server
## --server value       : (experimental/cluster) Server to connect to, used to join a cluster [$K3S_URL]
## --node-ip=ipadress   : (agent/networking) IP address to advertise for node
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="agent --server https://$1:6443 --token-file /tmp/token --node-ip=$2" sh -

# install networking tools (ifconfig,...)
yum install net-tools -y
