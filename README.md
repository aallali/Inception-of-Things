# 42-Inception-of-Things
This project aims to introduce you to kubernetes from a developer perspective. You will have to set up small clusters and discover the mechanics of continuous integration. At the end of this project you will be able to have a working cluster in docker and have a usable continuous integration for your applications. 

## check (v2/1337) branch, it contains the version compatible with the 1337's IMacs
### !!! IGNORE THIS IT WILL BE UPDATED !!!
### - commands sheets (ignore it, it will be re-written later in well organized documentation)
**install vbguest**
`vagrant plugin uninstall vagrant-vbguest`
`vagrant plugin install vagrant-vbguest`

**speed up download of Vagrant Boxs (install these two plugins)**
**Installation Make sure you have Vagrant 1.4+ and run:** 
`vagrant plugin install vagrant-cachier`
`vagrant plugin install vagrant-faster`

**last version of vagrant-vbguest cause the vguest plugin to be reinstall everytime you vagrant up, downgrade to this version to avoid this problem**
`vagrant plugin uninstall vagrant-vbguest`
`vagrant plugin install vagrant-vbguest --plugin-version 0.21`

`chmod 644 /etc/rancher/k3s/k3s.yml`
**or use this option**
`--write-kubeconfig-mode=644`


**clear all deployments/pods/services**
`kubectl delete --all  pods`
`k3s kubectl get service -o wide`
`k3s kubectl delete svc nginx`
`k3s kubectl delete deployment yourDeploymentNamenginx`


** create nginx deployment
`k3s kubectl create deployment nginx --image=nginx`
`k3s kubectl expose deployment nginx --type NodePort --port 80`

**get k3s ingress**
`kubectl get ing`
`kubectl describe ingress`

**more explanation about diff between natdnsproxy and natdnshostresolver**
https://stackoverflow.com/questions/51060639/virtualbox-what-is-the-difference-of-natdnsproxy1-and-natdnshostresolver1

