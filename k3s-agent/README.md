### Instructions how to setup the agent node
This will install the k3s agent on a VM. K3s servers are basically worker nodes.

Note: every node in k3s cluster will have deployed the containers running Traefik acting as Load Balancers for external traffic. There is no fixed external Load Balancer that comes installed with k3s.

## Setup
Allow the following ports:
- TCP 10250 Source: All nodes Destination: All nodes (Kubelet metrics)
- UDP 8472 Source: All nodes Destination: All nodes (Flannel VXLAN)

## Install
We will use the external file for configuration, so set the path for this file in env var::
export CONFIG=$HOME/k3s-cluster/k3s-agent/config.yaml

Find the token at the server node and set the env var:
cat /var/lib/rancher/k3s/server/node-token (on server node)
export TOKEN=<TOKEN> (on agent node)

Find the URL of the server node:
kubectl get nodes -o wide (on server node)
export URL=https://<INTERNAL IP OF SERVER NODE VM>:6443

The k3s server and agents are all setup in a Hetzner Cloud private network, so we need to configure Flannel to use the private network interfaces.
Get the private network interface:
ip a
export INTERFACE=<private network interface from ip a>

Run the script:
chmod a+x agent.sh
./agent.sh

Check the status:
sudo systemctl status k3s-agent.service
sudo journalctl -u k3s-agent.service

Check with kubectl on server node:
kubectl get nodes -o wide
NAME     STATUS   ROLES                  AGE   VERSION        INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION       CONTAINER-RUNTIME
node-0   Ready    control-plane,master   13m   v1.29.5+k3s1   10.0.0.3      <none>        Ubuntu 22.04.3 LTS   5.15.0-112-generic   docker://26.1.4
node-1   Ready    <none>                 4s    v1.29.5+k3s1   10.0.0.2      <none>        Ubuntu 22.04.3 LTS   5.15.0-112-generic   docker://26.1.4

## Uninstall
To uninstall the agent node run these commands:
sudo /usr/local/bin/k3s-agent-uninstall.sh
sudo rm -rf /var/lib/rancher