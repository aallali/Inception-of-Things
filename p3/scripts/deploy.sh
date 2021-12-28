
# change this depends on ur path containing the config files
CONFIG_PATH="."

## [NAMESPACES] : create {argocd, dev} namespaces as required in the subjcet
echo "[NAMESPACES] : create {argocd, dev} namespaces as required in the subjcet"
kubectl create namespace argocd
kubectl create namespace dev


## [ARGOCD] : install argocd and wait for pods to rollout...
echo "################################################################################"
echo "[ARGOCD] : install argocd and wait for pods to rollout..."
# kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.0.1/manifests/install.yaml
kubectl apply -n argocd -f $CONFIG_PATH/confs/argoInstall.yaml 
# the command is downloading the config file only and then run the installation in the backend
# so you need to wait untill all the pods are running and ready
# watch kubectl get pods -n argocd
# kubectl wait --for=condition=Ready --timeout=-1s  pods --all -n argocd

# [ARGOCD-INGRESS] : setup ingress for argocd so we can access it from 8000
echo "################################################################################"
echo "[ARGOCD-INGRESS] : setup ingress for argocd so we can access it from 8080"
kubectl apply -n argocd -f $CONFIG_PATH/confs/ingress.yaml

# [ARGOCD-ROLLOUT] : wait for argocd pods to be running
echo "################################################################################"
echo "[ARGOCD-ROLLOUT] : wait for argocd pods to be running"
kubectl rollout status deployment argocd-server -n argocd
kubectl rollout status deployment argocd-redis -n argocd
kubectl rollout status deployment argocd-repo-server -n argocd
kubectl rollout status deployment argocd-dex-server -n argocd

# [wils-APPLICATION] : setup wils application to fetch its config from our github repo
echo "################################################################################"
echo "[wils-APPLICATION] : setup wils application to fetch its config from our github repo"
kubectl apply -n argocd -f $CONFIG_PATH/confs/wils-Application.yaml

# [ARGOCD-ADMIN-PASSWORD] : retrieve the password for the admin user of the dashboard
echo "################################################################################"
echo "[ARGOCD-ADMIN-PASSWORD] : retrieve the password for the admin user of the dashboard"
echo "YOUR PASSWORD IS ==============>"
echo "===============================================>"
echo "===============================================>"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
echo "<==============================================="
echo "<==============================================="

sudo kubectl wait --for=condition=Ready pods --all -n argocd
sleep 60 # wait for the app to be deployed by argocd
echo "[WILL-APP] : test app at http://localhost:8888/"
curl http://localhost:8888/

echo "#############################################################################"
echo "############################### ALL SET !! ##################################"
echo "########################## ARGOCD : localhost:8080 ##########################"
echo "########################## WIL-APP: localhost:8888 ##########################"
echo "#############################################################################"