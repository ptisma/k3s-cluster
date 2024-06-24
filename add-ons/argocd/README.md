### argocd
Argo CD is a declarative, GitOps continuous delivery tool for Kubernetes. Aside from automated deployments, rollouts etc. we can use it as well for monitoring and getting the real-time view of our application's state.

Argo CD is implemented as a Kubernetes controller which continuously monitors running applications and compares the current, live state against the desired target state (as specified in the Git repo).

### install
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
We will install it using Helm (https://artifacthub.io/packages/helm/argo/argo-cd):
helm repo add argo https://argoproj.github.io/argo-helm
helm install my-argo-cd argo/argo-cd --version 7.2.1 --namespace argocd --create-namespace


### uninstall
helm uninstall my-argo-cd -n argocd
kubectl delete -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml -n argocd
