### Install Docker Engine on CentOS
echo "------ Installing latest version of Docker Engine ⏳ ------"
sudo yum install -y yum-utils git vim
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
sudo systemctl enable docker.service
echo "Docker installed ✅"

## Post-installation steps for Linux
## Managing docker as non-root user
echo "------ Add user to the docker group ⏳ ------"
sudo usermod -aG docker $USER
newgrp docker
sudo systemctl start docker.service
echo "Docker changes activated -- Starting Docker Service ✅"


### Install kubectl
echo "------ Install kubectl binary with curl on Linux ⏳ ------"
## 1. Download the latest release 
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
## 2. Validating the binary (optional)
# curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
# echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
## 3. Install kubectl
## If you do not have root access on the target system, you can still install kubectl to the ~/.local/bin directory:
sudo install -o root -g root -m 0755 ./kubectl /usr/local/bin/kubectl
export PATH=$PATH:/usr/local/bin
echo "Kubectl installed ✅"

# echo "------ Install kubectl using native package management [Red Hat-based distributions] ⏳ ------"
# cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
# [kubernetes]
# name=Kubernetes
# baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
# enabled=1
# gpgcheck=1
# gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
# EOF
# sudo yum install -y kubectl
# echo "Kubectl installed ✅"

### Installing K3d
echo "------ Installing current latest release of K3d ⏳ ------"
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
echo "K3d Installed ✅"


### Creating a k3d cluster
echo "------ Creating a cluster with just a single server node ⏳ ------"
k3d cluster create mycluster
echo "K3d cluster created ✅"


### Install ArgoCD
echo "------ Creating ArgoCD Namespace + Applying ArgoCD YAML ⏳ ------"
kubectl create namespace argocd
# unset http_proxy
# unset https_proxy
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
echo "ArgoCD Installed ✅"

echo "===== Port Forwarding ====="
# sleep(120)

# kubectl port-forward --address 0.0.0.0 svc/argocd-server -n argocd 8080:443
