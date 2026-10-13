#!/bin/bash
cat /etc/fstab

INFO="\033[36;1m"
OK="\033[32;1m"
WARN="\033[33;1m"
ERROR="\033[31;1m"
FUN="\033[36;1m"
NO="\033[m"

log(){
    if [ "$2" == "msg" ]; then
        echo -e "${INFO}$1${NO}" 
    elif [ "$2" == "ok" ]; then 
        echo -e "${OK}$1${NO}" 
    elif [ "$2" == "error" ]; then 
        echo -e "${ERROR}$1${NO}" 
    elif [ "$2" == "warn" ]; then 
        echo -e "${WARN}$1${NO}" 
    else
        echo -e "${FUN}$1${NO}" 
    fi
}
log "===============================" fun
sudo hostnamectl set-hostname cp-01
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