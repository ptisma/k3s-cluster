# k3s-cluster

This repo contains the instructions how to setup the K3s cluster.

### tools
There are some prerequisites before we start setting up the k3s, certain tools have to be installed on every node. In this folder you will find the bootstrap script to get all the necesseary stuff. Run this first

### k3s-server

In this folder you will find the instructions how to setup the server node. Run this before setting up the agent nodes.

### k3s-agent
In this folder you will find the instructions how to setup the agent node.

### add-ons
In this folder you will find the folders for each of the "infra" apps deployed on the cluster such as longhorn, dashboards, argocd etc. Many of them consist of operator and CRD yamls.
This will be in future potentially moved to the separate infra repo, but for now I will keep it here.

### architecture
#### K3s
k3s-servers:
node-0
k3s-agents:
node-1
