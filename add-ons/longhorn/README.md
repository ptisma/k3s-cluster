## Longhorn
Longhorn is a distributed block storage system for Kubernetes applications. It is designed to provide reliable, performant, and persistent storage for stateful applications running in Kubernetes clusters.
Longhorn distributes block storage across multiple nodes in a Kubernetes cluster, providing redundancy and fault tolerance.


## Setup
Check if the node VM meets the Longhorn system requirements with a script:
curl -sSfL https://raw.githubusercontent.com/longhorn/longhorn/v1.6.2/scripts/environment_check.sh | bash

Install Longhorn using Helm:
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
helm repo add longhorn https://charts.longhorn.io
helm repo update
helm install longhorn longhorn/longhorn --namespace longhorn-system --create-namespace --version 1.6.2
kubectl -n longhorn-system get pod

Set the credentials to access the Longhorn UI:
USER=admin; PASSWORD=admin; echo "${USER}:$(openssl passwd -stdin -apr1 <<< ${PASSWORD})" >> auth
kubectl -n longhorn-system create secret generic basic-auth --from-file=auth

Deploy ingress to access the Longhorn UI (by default the Longhorn UI works only on '/' so replacePathRegex was used on ingress):
kubectl apply -f ingress.yaml

Note: for some reason when the path /longhorn is set, the blank white page is rendered so it works only with /longhorn/
Use the credentials you defined in the secret to access the Longhorn UI
## Uninstall
Using kubectl:
kubectl create -f https://raw.githubusercontent.com/longhorn/longhorn/v1.6.2/uninstall/uninstall.yaml

Using Helm:
helm uninstall longhorn -n longhorn-system
