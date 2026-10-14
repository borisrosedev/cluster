source log.sh

log "================================================" fun
log "Configurons kubectl pour l'utilisateur courant" msg
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
