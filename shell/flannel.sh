source log.sh

log "===============================================" fun
log "10. Installation de Flannel (VXLAN)" msg

kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
kubectl get pods -n kube-flannel -w
kubectl get nodes
