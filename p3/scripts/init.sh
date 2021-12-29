
#!/bin/bash
echo "alias k='kubectl'" >> ~/.bashrc
echo "alias kpk='kubectl get pods -n kube-system '" >> ~/.bashrc
echo "alias kak='kubectl get all -n kube-system '" >> ~/.bashrc
echo "alias kdi='kubectl describe ingress -n'" >> ~/.bashrc
 
source .bashrc
apt-get update
apt-get upgrade -y

echo "################################################################################"
echo "[DOCKER] : install docker"
curl https://releases.rancher.com/install-docker/20.10.sh | sh
systemctl start docker
# usermod -aG docker $(whoami)
echo "################################################################################"
echo "[K3D] : install..."
curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash
k3d cluster create dev-cluster --port 8080:80@loadbalancer --port 8888:8888@loadbalancer --port 8443:443@loadbalancer

# [KUBECTL] : install
# [Ref] : https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/ # if you are in debian distor
# [Ref] : https://phoenixnap.com/kb/how-to-install-kubernetes-on-centos # if you running centOs8/7 
echo "################################################################################"
echo "[KUBECTL] : install..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(<kubectl.sha256) kubectl" | sha256sum --check
chmod +x kubectl
mv ./kubectl /usr/local/bin

echo "################################################################################"
echo "[KUBE-SYSTEM-ROLLOUT] : wait for kube-system hobs to rolle out."
# use this command to watch the pods rollout
# watch kubectl get pods -n kube-system
# [Ref] : https://serverfault.com/questions/981012/kubernetes-wait-on-pod-job/1013636
# watch kubectl get pods -n kube-system
sleep 5
kubectl get pods -n kube-system 
kubectl rollout status deployment local-path-provisioner -n kube-system
kubectl rollout status deployment metrics-server -n kube-system
kubectl rollout status deployment coredns -n kube-system
kubectl get pods -n kube-system


echo "############################################################################"
echo "################# {DOCKER,KUBECTL,K3D} installed succefully ################"
echo "############################################################################"

watch kubectl get pods -n kube-system

sudo bash scripts/deploy.sh