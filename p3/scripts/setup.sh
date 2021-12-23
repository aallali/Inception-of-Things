#!/bin/bash

# use export path if you running inside root user
export PATH=$PATH:/usr/local/bin
echo "export PATH=$PATH:/usr/local/bin" >> .bashrc
source .bashrc
#  sudo systemctl disable --now firewalld

# [DOCKER] : install
# [Ref] : https://docs.docker.com/engine/install/centos/
echo "################################################################################"
echo "[DOCKER] : install docker + vim editor(optional)"

yum install -y vim
yum install -y yum-utils
yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce docker-ce-cli containerd.io

systemctl enable --now docker.service
systemctl enable --now containerd.service
systemctl start docker
# usermod -aG docker ${USER} # no need if you are root

# [K3D] : install
# [Ref] : https://k3d.io/v5.2.2/
echo "################################################################################"
echo "[K3D] : install..."
curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash
k3d cluster create dev-cluster --port 8080:80@loadbalancer --port 8888:8888@loadbalancer --port 8443:443@loadbalancer


# [KUBECTL] : install
# [Ref] : https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/ # if you are in debian distor
# [Ref] : https://phoenixnap.com/kb/how-to-install-kubernetes-on-centos # centOs8/7 
echo "################################################################################"
echo "[KUBECTL] : install..."

# set the kubernetes repo so yum can search `kubectl` in it
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
yum install -y kubectl
# the following setup process doesnt work in centos but works in other linux distor
# curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
# curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
# echo "$(<kubectl.sha256) kubectl" | sha256sum --check
# # sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl # if you running as root user
# chmod +x kubectl
# sudo mv ./kubectl /usr/local/bin

echo "################################################################################"
echo "[KUBE-SYSTEM-ROLLOUT] : wait for kube-system hobs to rolle out."
# use this command to watch the pods rollout
# watch kubectl get pods -n kube-system
# [Ref] : https://serverfault.com/questions/981012/kubernetes-wait-on-pod-job/1013636
kubectl get jobs -n kube-system 
kubectl -n kube-system wait --for=condition=complete --timeout=-1s jobs/helm-install-traefik-crd
kubectl -n kube-system wait --for=condition=complete --timeout=-1s jobs/helm-install-traefik
kubectl get jobs -n kube-system

sleep 10
echo "############################################################################"
echo "################# {DOCKER,KUBECTL,K3D} installed succefully ################"
echo "############################################################################"

## Resources
# DOCS : https://www.techmanyu.com/setup-a-gitops-deployment-model-on-your-local-development-environment-with-k3s-k3d-and-argocd-4be0f4f30820
# VIDEO: https://www.youtube.com/watch?v=2WSJF7d8dUg&ab_channel=ThatDevOpsGuy