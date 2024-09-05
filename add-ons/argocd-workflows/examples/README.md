argo submit hello-world-workflow.yaml
argo get hello-world-xxx
argo logs hello-world-xxx

argo submit hello-world-workflow.yaml -p message="goodbye world"

We need to create the service account with sufficient rights for the Argo Workflows executor in a pod, else it will fail with an error "cant patch Pod etc."
kubectl apply -f rbac.yaml
argo submit steps-workflow.yaml --serviceaccount argo-workflows-executor

argo submit dag-workflow.yaml --serviceaccount argo-workflows-executor
