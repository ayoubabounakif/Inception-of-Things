### Install Docker Engine on CentOS
echo "------ Installing latest version of Docker Engine ⏳ ------"
sudo apt-get update
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo chmod a+r /etc/apt/keyrings/docker.gpg
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

echo "Docker installed ✅"

## Post-installation steps for Linux (Managing docker as non-root user)
# sudo systemctl enable docker.service
echo "------ Add user to the docker group ⏳ ------"
sudo usermod -aG docker $USER
newgrp docker
echo "Docker changes activated -- Starting Docker Service ✅"


### Install kubectl
echo "------ Install kubectl binary with curl on Linux ⏳ ------"
## 1. Download the latest release 
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
## 2. Validating the binary (optional)
# curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
# echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
## 3. Install kubectl


## If you do not have root access on the target system, you can still install kubectl to the ~/.local/bin directory:
sudo install -o root -g root -m 0755 ./kubectl /usr/local/bin/kubectl
export PATH=$PATH:/usr/local/bin
# source ~/.bashrc
echo "Kubectl installed ✅"


### Installing K3d
echo "------ Installing current latest release of K3d ⏳ ------"
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
echo "K3d Installed ✅"


### Creating a k3d cluster
echo "------ Creating a cluster with just a single server node ⏳ ------"
# k3d cluster create dev-cluster --port 8080:80@loadbalancer --port 8888:8888@loadbalancer --port 8443:443@loadbalancer
k3d cluster create dev-cluster

sleep 30

### Install ArgoCD
echo "------ Creating ArgoCD Namespace + Dev Namespace + Applying ArgoCD YAML ⏳ ------"
kubectl create namespace argocd
kubectl create namespace dev
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# unset http_proxy
# unset https_proxy

echo "ArgoCD Installed ✅"

# Ingress
# kubectl apply -n argocd -f ./confs/ingress.yaml

echo "------ Waiting for argocd-server to be ready ⏳ -------"
kubectl wait -n argocd --timeout=180s --for=condition=ready pod -l app.kubernetes.io/name=argocd-server

sleep 10

# App
kubectl apply -n argocd -f ./confs/application.yaml

sleep 30

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

echo "===== Port Forwarding ====="
kubectl port-forward --address 0.0.0.0 svc/argocd-server -n argocd 8080:443 2>&1 >/dev/null &
sleep 5
echo "===== You can now access ArgoCD Server on https://192.168.42.110:8080 ====="
# kubectl port-forward --address 0.0.0.0 svc/will-app-service -n dev 8888 2>&1 >/dev/null &

sleep 10

# SETUP OF THE GITLAB CI
# REPO: https://gitlab.com/ayoubabounakif/aabounak

# Install Helm
sudo curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
sudo chmod 700 get_helm.sh
sudo ./get_helm.sh

sleep 5

sudo k3d kubeconfig get dev-cluster > cluster-kubeconfig.yaml
export KUBECONFIG=$(realpath cluster-kubeconfig.yaml)



