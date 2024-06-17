## Longhorn
Longhorn is a distributed block storage system for Kubernetes applications. It is designed to provide reliable, performant, and persistent storage for stateful applications running in Kubernetes clusters.
Longhorn distributes block storage across multiple nodes in a Kubernetes cluster, providing redundancy and fault tolerance.


## Setup

Using kubectl:
kubectl apply -f https://raw.githubusercontent.com/longhorn/longhorn/v1.6.2/deploy/longhorn.yaml

Using Helm:
helm repo add longhorn https://charts.longhorn.io
helm repo update
helm install longhorn longhorn/longhorn --namespace longhorn-system --create-namespace --version 1.6.2


## Uninstall

Using kubectl:
kubectl create -f https://raw.githubusercontent.com/longhorn/longhorn/v1.6.2/uninstall/uninstall.yaml

Using Helm:
helm uninstall longhorn -n longhorn-system