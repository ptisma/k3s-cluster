### Instructions how to setup the server node
This will install the k3s server on a VM. K3s servers are basically control plane nodes in k8 world, while the k3s agents are worker nodes. Note, every k3s server is in a fact a k3s agent as well.

By default the installation script for k3s will use the Flannel as Container Network Interface (CNI) plugin, Traefik as Ingress Controller and Rancher's Local Path Provisioner as storage provisioner.

Note: every node in k3s cluster will have deployed the containers running Traefik acting as Load Balancers for external traffic. There is no fixed external Load Balancer that comes installed with k3s.

## Setup
Allow the following ports:
- TCP 6443 Source: Agents Destination: Server (K3s supervisor and Kubernetes API Server)
- TCP 10250 Source: All nodes Destination: All nodes (Kubelet metrics)
- UDP 8472 Source: All nodes Destination: All nodes (Flannel VXLAN)

## Install
We will use the external file for configuration, so set the path for this file in env var:
export CONFIG=$HOME/k3s-cluster/k3s-server/config.yaml

The k3s server and agents are all setup in a Hetzner Cloud private network, so we need to configure Flannel to use the private network interfaces.
Get the private network interface:
ip a
export INTERFACE=<private network interface from ip a>

Run the script:
chmod a+x server.sh
./server.sh

Check the status:
systemctl status k3s.service
journalctl -xeu k3s.service

Check with the kubectl:
kubectl get all -n kube-system
kubectl get nodes -o wide

NAME     STATUS   ROLES                  AGE   VERSION        INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION       CONTAINER-RUNTIME
node-0   Ready    control-plane,master   84s   v1.29.5+k3s1   10.0.0.3      <none>        Ubuntu 22.04.3 LTS   5.15.0-112-generic   docker://26.1.4

Note: the external-ip here is empty because we have no cloud controller manager installed
## Uninstall
To uninstall the k3s server node run these commands:
sudo /usr/local/bin/k3s-uninstall.sh
sudo rm -rf /var/lib/rancher