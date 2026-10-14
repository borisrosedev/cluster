#!/bin/bash
source log.sh


POD_NETWORK_CIDR=$(grep "^POD_NETWORK_CIDR=" .env | cut -d= -f2-)
CONTROL_PLANE_IP_ADDRESS=$(grep "^CONTROL_PLANE_IP_ADDRESS=" .env | cut -d= -f2-)

cat /etc/fstab
log "===============================" fun
sudo hostnamectl set-hostname cp-01


log "================================================" fun
log "Effectuons la commande kubeadm" msg
sudo kubeadm init \
--pod-network-cidr="$POD_NETWORK_CIDR" \
--apiserver-advertise-address="$CONTROL_PLANE_IP_ADDRESS" > workers.sh

log "================================================" fun
log "Configurons kubectl pour l'utilisateur courant" msg
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
