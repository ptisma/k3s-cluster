argo submit hello-world-workflow.yaml
argo get hello-world-xxx
argo logs hello-world-xxx

argo submit hello-world-workflow.yaml -p message="goodbye world"

argo submit steps-workflow.yaml --serviceaccount executor