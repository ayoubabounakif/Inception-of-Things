#!/bin/bash

# Requires auth
# systemctl disable firewalld --now

echo "**** Begin installing k3s"
curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" sh -
echo "**** End installing k3s
