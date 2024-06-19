### Setup
Install via Helm:
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --version 7.5.0 --create-namespace --namespace kubernetes-dashboard

We access the Kubernetes Dashboard using Bearer token from one of the Service ACcounts(SA has to have the role to access to all the cluster stuff):
kubectl apply -f rbac.yaml
Save the token:
kubectl -n kubernetes-dashboard create token admin-user

Local access, from your host machine using kubectl (make sure the outside access is configured):
kubectl -n kubernetes-dashboard port-forward svc/kubernetes-dashboard-kong-proxy 8443:443

visit localhost:8443 and login using bearer token

Note: node VM have to have the socat installed for port-forward, install with sudo apt-get install socat

Access via Ingress:
kubectl apply -f ingress.yaml

Start Traefik with insecureSkipVerify option which means it doesn't validate SSL certs, we have self-signed, without this I get the internal server error, alternative workaround would be 
to either create the IngressRoute and ServersTransport CRD-s instead:

Create this static manifest at /var/lib/rancher/k3s/server/manifests/traefik-config.yaml, if it does not get picked up, apply it manually:
apiVersion: helm.cattle.io/v1
kind: HelmChartConfig
metadata:
  name: traefik
  namespace: kube-system
spec:
  valuesContent: |-
    globalArguments:
      - "--serversTransport.insecureSkipVerify=true"
