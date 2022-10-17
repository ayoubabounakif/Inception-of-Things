# Inception-of-Things
This project aims to introduce you to kubernetes from a developer perspective.You will have to set up small clusters and discover the mechanics of continuous integration. At the end of this project you will be able to have a working cluster in docker and have a usable continuous integration for your applications.

## P1 -- Important Commands
- vagrant up [options] [name|id]
- vagrant reload [vm-name]
- vagrant global-status [options] {e.g: --prune}
- vagrant destroy [options] [name|id]
- vagrant ssh [options] [name|id] [-- extra ssh args]
- ip address show | grep eth1 | grep inet | awk '{print $2}' -- (Private network)
- k3s kubectl get nodes
- kubectl get nodes -o wide
- kubectl get services
- kubectl get pods --all-namespaces
- ps aux | grep "k3s server"
- ls -lah $(which kubectl) -- (Check symlink to the k3s executable)
- https://rancher.com/docs/k3s/latest/en/installation/install-options/ (k3s installation)
- https://rancher.com/docs/k3s/latest/en/advanced/#additional-preparation-for-red-hat-centos-enterprise-linux -- (Additional prep for red hat centos)
- sudo firewall-cmd --state (Check firewall state)

## P2
- kubectl get all
- kubectl get all -n kube-system
- kubectl apply -f [filename] [--validate=false]
- kubectl get ingress
- curl -H "host:app${i}.com" 192.168.42.110
- curl 192.168.42.110/${path}

## P3
- kubectl cluster-info
- kubectl get pod -n argocd
- kubectl get svc -n argocd
- kubectl port-forward -n argocd svc/argocd-server 8080:443

