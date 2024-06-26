### argocd
Argo CD is a declarative, GitOps continuous delivery tool for Kubernetes. Aside from automated deployments, rollouts etc. we can use it as well for monitoring and getting the real-time view of our application's state.

Argo CD is implemented as a Kubernetes controller which continuously monitors running applications and compares the current, live state against the desired target state (as specified in the Git repo).

Argo CD consists of the following components
- API Server: gRPC/REST server which exposes the API consumed by the Web UI, CLI, and CI/CD systems
- Repository Server: internal service which maintains a local cache of the Git repository holding the application manifests
- Application Controller: Kubernetes controller which continuously monitors running applications and compares the current, live state against the desired target state (as specified in the repo)

### install
We will install it using Helm (https://artifacthub.io/packages/helm/argo/argo-cd):
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
helm repo add argo https://argoproj.github.io/argo-helm
helm install my-argo-cd argo/argo-cd --version 7.2.1 --namespace argocd --create-namespace --set configs.params.server.insecure=true --set configs.params.server.rootpath=/argocd
or alternatively modify the values inside the argocd-cmd-params-cm configmap
Reason for previous settings that we do the TLS termination at the ingress level and we are accessing the argocd via ingress subpath

Create the ingress:
kubectl apply -f ingress.yaml

Get the initial secret:
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

Login via admin and secret

### uninstall
helm uninstall my-argo-cd -n argocd
kubectl delete -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml -n argocd
