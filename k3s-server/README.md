### Instructions how to setup the server node

## Install
Set the absolute config file:
export CONFIG=$HOME/k3s-cluster/k3s-master/config.yaml

Run the script:
chmod a+x server.sh
./server.sh

## Setup
Allow the following ports:
- TCP 6443 Source: Agents Destination: Server (K3s supervisor and Kubernetes API Server)
- TCP 10250 Source: All nodes Destination: All nodes (Kubelet metrics)
- UDP 8472 Source: All nodes Destination: All nodes (Flannel VXLAN)


## Uninstall
To uninstall the k3s server node run these commands:
sudo /usr/local/bin/k3s-uninstall.sh
sudo rm -rf /var/lib/rancher