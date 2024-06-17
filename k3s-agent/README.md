### Instructions how to setup the agent node

## Install
Set the absolute config file:
export CONFIG=$HOME/k3s-cluster/k3s-worker/config.yaml

Find the token at server node on this file and set the env var:
cat /var/lib/rancher/k3s/server/node-token (on server node)
export TOKEN=<TOKEN>

Find the URL of the server node:
k get nodes -o wide (on server node)
EXPORT URL=https://<INTERNAL IP OF SERVER NODE VM>:6443

Run the script:
chmod a+x agent.sh
./agent.sh

## Setup
Allow the following ports:
- TCP 10250 Source: All nodes Destination: All nodes (Kubelet metrics)
- UDP 8472 Source: All nodes Destination: All nodes (Flannel VXLAN)

## Uninstall
To uninstall the agent node run these commands:
sudo /usr/local/bin/k3s-agent-uninstall.sh
sudo rm -rf /var/lib/rancher