# Inception-of-Things
This project aims to introduce you to kubernetes from a developer perspective.You will have to set up small clusters and discover the mechanics of continuous integration. At the end of this project you will be able to have a working cluster in docker and have a usable continuous integration for your applications.

## p1
  - vagrant up [options] [name|id]
  - vagrant global-status
  - vagrant destroy [options] [name|id]
  - vagrant ssh [options] [name|id] [-- extra ssh args]
  - ip address show | grep eth1 | grep inet | awk '{print $2}' -- (Private network)
  - https://rancher.com/docs/k3s/latest/en/installation/install-options/ (k3s installation)
  - https://rancher.com/docs/k3s/latest/en/advanced/#additional-preparation-for-red-hat-centos-enterprise-linux -- (Additional prep for red hat centos)
  - ls -lah $(which kubectl) -- (Check symlink to the k3s executable)
  - kubectl get pods -o wide -- (List all pods in ps output format with more information (such as node name))
  - kubectl get services
  - ps aux | grep "k3s server"
