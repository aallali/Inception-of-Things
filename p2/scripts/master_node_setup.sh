#!/usr/bin/env bash


echo "[K3S] : installing..."
export INSTALL_K3S_EXEC="--write-kubeconfig-mode=644 --tls-san $1 --node-ip $1 --flannel-iface=eth1"
curl -sfL https://get.k3s.io |  sh -

echo "[SETUP] : initiat aliases for all machine users "
echo "alias k='k3s kubectl'" >> /etc/profile.d/00-aliases.sh

echo "[TOOLS] : install ifconfig tool ..."
sudo yum install net-tools -y

echo "[APP-1] : deploying..." 
/usr/local/bin/kubectl create configmap app1-html --from-file /vagrant/confs/k3s/app1/index.html
/usr/local/bin/kubectl apply -f /vagrant/confs/k3s/app1/app1.deployment.yaml
/usr/local/bin/kubectl apply -f /vagrant/confs/k3s/app1/app1.service.yaml
/usr/local/bin/kubectl apply -f /vagrant/confs/k3s/app1/app1.ingress.yaml


echo "[APP-2] : deploying..." 
/usr/local/bin/kubectl create configmap app2-html --from-file /vagrant/confs/k3s/app2/index.html
/usr/local/bin/kubectl apply -f /vagrant/confs/k3s/app2/app2.deployment.yaml
/usr/local/bin/kubectl apply -f /vagrant/confs/k3s/app2/app2.service.yaml
/usr/local/bin/kubectl apply -f /vagrant/confs/k3s/app2/app2.ingress.yaml


echo "[APP-3] : deploying..." 
/usr/local/bin/kubectl create configmap app3-html --from-file /vagrant/confs/k3s/app3/index.html
/usr/local/bin/kubectl apply -f /vagrant/confs/k3s/app3/app3.deployment.yaml
/usr/local/bin/kubectl apply -f /vagrant/confs/k3s/app3/app3.service.yaml
/usr/local/bin/kubectl apply -f /vagrant/confs/k3s/app3/app3.ingress.yaml
