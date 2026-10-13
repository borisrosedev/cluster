#!/bin/bash
cat /etc/fstab

INFO="\033[36;1m"
NO="\033[m"

log(){
    echo -e "${INFO}$1${NO}" 
}

sudo hostnamectl set-hostname cp-01

log "==============================="
cat <<EOF | sudo tee -a /etc/hosts
    10.10.0.10 cp-01
    10.10.0.11 worker-1
    10.10.0.12 worker-2
EOF
log "==============================="
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab
log "==============================="