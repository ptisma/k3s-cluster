
Find token at /var/lib/rancher/k3s/server/node-token on a master node:
export TOKEN=<TOKEN>

Find the url using kubectl get nodes -o wide on master node
export URL=https://<URL>:6443

Set the absolute config file:
export CONFIG=$HOME/k3s-cluster/k3s-worker/config.yaml