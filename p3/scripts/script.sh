### Install Docker Engine on CentOS
echo "------ Installing latest version of Docker Engine ⏳ ------"
sudo yum install -y yum-utils
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
echo "Docker installed ✅"

## Post-installation steps for Linux
## Managing docker as non-root user
echo "------ Creating the docker group / Add user to the docker group ⏳ ------"
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
sudo systemctl start docker
echo "Docker changes activated -- Starting Docker ✅"


### Installing K3d
echo "------ Installing current latest release of K3D ⏳ ------"
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
echo "K3D Installed ✅"
echo "------ Creating a cluster with just a single server node ⏳ ------"
/usr/local/bin/k3d cluster create mycluster
echo "K3d cluster created ✅"



### Install kubectl
echo "------ Install kubectl binary with curl on Linux ⏳ ------"
## 1. Download the latest release 
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
## 2. Validating the binary (optional)
# curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
# echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
## 3. Install kubectl
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
## If you do not have root access on the target system, you can still install kubectl to the ~/.local/bin directory:
echo "------ Installing kubectl to the ~/.local/bin directory ⏳ ------"
chmod +x kubectl
sudo mv ./kubectl /usr/local/bin/kubectl -f
echo "Kubectl installed ✅"


### Install ArgoCD
echo "------ Creating ArgoCD Namespace + Applying ArgoCD YAML ⏳ ------"
/usr/local/bin/kubectl create namespace argocd
unset http_proxy
unset https_proxy
/usr/local/bin/kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
/usr/local/bin/kubectl port-forward -n argocd svc/argocd-server 8080:443
echo "ArgoCD Installed ✅"
