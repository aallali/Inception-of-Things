#!/usr/bin/env bash

mkdir ~/.ssh
mv /tmp/id_rsa* ~/.ssh/
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

echo "[K3S] : installing..."
# [K3s] : install k3s as master ...
## --write-kubeconfig-mode=644  : (client) Write kubeconfig with this mode [$K3S_KUBECONFIG_MODE]
## --tls-san $(hostname)        : (listener) Add additional hostname or IP as a Subject Alternative Name in the TLS cert
## --node-ip=ipadress           : (agent/networking) IP address to advertise for node
## --flannel-iface value        : (agent/networking) Override default flannel interface (optional, it will take the default one which is eth1 in most cases)

export INSTALL_K3S_EXEC="--write-kubeconfig-mode=644 --tls-san $1 --node-ip $1 --flannel-iface=eth1"
echo $INSTALL_K3S_EXEC
curl -sfL https://get.k3s.io |  sh -

echo "[SETUP] : initiat aliases for all machine users "
echo "alias k='k3s kubectl'" >> /etc/profile.d/00-aliases.sh

echo "[TOOLS] : install ifconfig tool ..."
sudo yum install net-tools -y

echo "[ROLLOUT] : wait for deployments/jobs to rollout..."
/usr/local/bin/kubectl wait --for condition=complete --timeout=-1s job/helm-install-traefik-crd -n kube-system

kubectl rollout status deployment local-path-provisioner -n kube-system
kubectl rollout status deployment metrics-server -n kube-system
kubectl rollout status deployment coredns -n kube-system

sleep 60

echo "[APP-1] : deploying..." 
/usr/local/bin/kubectl create configmap app1-html --from-file /tmp/confs/k3s/app1/index.html
/usr/local/bin/kubectl apply -f /tmp/confs/k3s/app1/app1.deployment.yaml
/usr/local/bin/kubectl apply -f /tmp/confs/k3s/app1/app1.service.yaml
/usr/local/bin/kubectl apply -f /tmp/confs/k3s/app1/app1.ingress.yaml

echo "[APP-2] : deploying..." 
/usr/local/bin/kubectl create configmap app2-html --from-file /tmp/confs/k3s/app2/index.html
/usr/local/bin/kubectl apply -f /tmp/confs/k3s/app2/app2.deployment.yaml
/usr/local/bin/kubectl apply -f /tmp/confs/k3s/app2/app2.service.yaml
/usr/local/bin/kubectl apply -f /tmp/confs/k3s/app2/app2.ingress.yaml

echo "[APP-3] : deploying..." 
/usr/local/bin/kubectl create configmap app3-html --from-file /tmp/confs/k3s/app3/index.html
/usr/local/bin/kubectl apply -f /tmp/confs/k3s/app3/app3.deployment.yaml
/usr/local/bin/kubectl apply -f /tmp/confs/k3s/app3/app3.service.yaml
/usr/local/bin/kubectl apply -f /tmp/confs/k3s/app3/app3.ingress.yaml
