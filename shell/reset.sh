sudo kubeadm reset -f

# reset doesn't clean these up
sudo rm -rf /etc/cni/net.d /var/lib/etcd $HOME/.kube/config
sudo iptables -F && sudo iptables -t nat -F && sudo iptables -t mangle -F && sudo iptables -X
#sudo ipvsadm --clear 2>/dev/null   # only if you use kube-proxy in IPVS mode

sudo systemctl restart containerd kubelet
