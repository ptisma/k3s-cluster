### argocd-workflows
ArgoCD Workflows, part of the Argo Project, is a container-native workflow engine for orchestrating parallel jobs on Kubernetes. It allows the definition and execution of complex workflows as DAGs (Directed Acyclic Graphs) of tasks, facilitating CI/CD pipelines and other automated processes. Key points include its scalability, flexibility in defining dependencies and retries, and integration with Kubernetes, making it suitable for managing complex cloud-native applications and operations.

Workflows architecture consists of Workflow Controller and Argo Server. Workflow controller can be installed as cluster install or namespace install. The default for helm chart is cluster install, so it watches and executes the workflows in all namespaces (behaves like every other kubernetes controller, watches for the Argo workflow CRD-s on api-server). Argo server just serves the API and we interact with it using GUI or Argo CLI.
### prerequisite
Install argocd cli:
curl -sLO https://github.com/argoproj/argo-workflows/releases/download/v3.5.8/argo-linux-amd64.gz
gunzip argo-linux-amd64.gz
chmod +x argo-linux-amd64
mv ./argo-linux-amd64 /usr/local/bin/argo
argo version

### install
Install ArgoCD workflows:
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

helm repo add argo https://argoproj.github.io/argo-helm

kubectl create ns argocd-workflows

helm install my-argo-workflows argo/argo-workflows --version 0.41.11 -n argocd-workflows --create-namespace
