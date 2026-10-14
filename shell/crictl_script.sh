source log.sh
log "===============================" fun
log "7. Définission pour crictl. crictl du chemin vers le runtime " msg
cat <<EOF | sudo tee /etc/crictl.yaml
runtime-endpoint: unix:///run/containerd/containerd.sock
EOF
sudo crictl ps
sudo crictl images
