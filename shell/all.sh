#!/bin/bash
source colors.sh
source log.sh


log "===============================" fun
log "# 0. Identité de la machine (cp-01, worker-1, worker-2)" msg
cat <<EOF | sudo tee -a /etc/hosts
    10.10.0.10 cp-01
    10.10.0.11 worker-1
    10.10.0.12 worker-2
EOF
log "===============================" fun
log "# 1. Desactiver la swap" msg
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab
log "free -h ⬇"
free -h
log "===============================" fun
log "# 2. Charger les modules noyau au boot" msg
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
sudo modprobe overlay
sudo modprobe br_netfilter
log "===============================" fun
log "3. Parametres sysctl" msg
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
EOF
sudo sysctl --system

log "===============================" fun
log "4. Installation de containerd" msg
sudo apt update && sudo apt install -y containerd
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
log "5. Activer le cgroup driver systemd" msg
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' \
/etc/containerd/config.toml
sudo systemctl restart containerd
sudo systemctl enable containerd

log "===============================" fun
log "6. Version mineure de Kubernetes à installer (à adapter, voir kubernetes.io/releases)" msg
K8S_MINOR=v1.36
sudo apt-get update
log "quatre paquets d’amorçage" warn
sudo apt-get install -y apt-transport-https ca-certificates curl gpg

log "===============================" fun
log "7.Clé du dépôt officiel Kubernetes" warn
sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/${K8S_MINOR}/deb/Release.key \
| sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg


log "===============================" fun
log "8.Déclaration du dépôt" warn
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] \
https://pkgs.k8s.io/core:/stable:/${K8S_MINOR}/deb/ /" \
| sudo tee /etc/apt/sources.list.d/kubernetes.list


log "==============UPDATE=================" fun
sudo apt-get update
log "==============K3=================" fun
sudo apt-get install -y kubelet kubeadm kubectl
log "===============================" fun
log "9.Interdiction de la maj auto" warn
sudo apt-mark hold kubelet kubeadm kubectl
log "===============================" fun
sudo systemctl enable --now kubelet
