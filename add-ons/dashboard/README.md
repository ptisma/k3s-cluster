export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/

helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --version 7.5.0 --create-namespace --namespace kubernetes-dashboard

kubectl apply -f rbac.yaml

kubectl -n kubernetes-dashboard create token admin-user

Local access, from your host machine:
kubectl -n kubernetes-dashboard port-forward svc/kubernetes-dashboard-kong-proxy 8443:443

visit localhost:8443 and login using bearer token

Note: node VM have to have the socat installed for port-forward, install with sudo apt-get install socat