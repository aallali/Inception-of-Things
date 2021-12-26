#!/bin/bash

mkdir ~/.ssh
cat /tmp/id_rsa.pub >> ~/.ssh/authorized_keys

# [K3s] : install k3s as master ...
## --write-kubeconfig-mode=644  : (client) Write kubeconfig with this mode [$K3S_KUBECONFIG_MODE]
## --cluster-init               : (experimental/cluster) : Initialize new cluster master [$K3S_CLUSTER_INIT]
## --tls-san $(hostname)        : (listener) Add additional hostname or IP as a Subject Alternative Name in the TLS cert
## --bind-address=ipadress      : (listener) k3s bind address (default: 0.0.0.0)
## --advertise-address=ipadress : (listener) IP address that apiserver uses to advertise to members of the cluster (default: node-external-ip/node-ip)
## --node-ip=ipadress           : (agent/networking) IP address to advertise for node
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --write-kubeconfig-mode=644 --cluster-init --tls-san $(hostname) --bind-address=$1 --advertise-address=$1 --node-ip=$1" sh -

# [NETWORK TOOLS] : install ....
yum install net-tools -y

echo "alias k='kubectl'" >> /etc/profile.d/00-aliases.sh

# after reboot run this : systemctl restart k3s

# write-kubeconfig-mode=644
## SAME AS => 
# chmod +r /etc/rancher/k3s/k3s.yaml