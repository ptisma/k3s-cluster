### minIO
MinIO is a Kubernetes-native high performance object store with an S3-compatible API. We will install it using the MinIO Operator.

The MinIO Operator installs a Custom Resource Definition (CRD) to support describing MinIO tenants as a Kubernetes object.
The MinIO Operator exists in its own namespace and it uses the two pods:
- The Operator pod for the base Operator functions to deploy, manage, modify, and maintain tenants
- Console pod for the Operator’s Graphical User Interface, the Operator Console

Each pod has three containers:
- MinIO Container: Runs standard MinIO functions, storing and retrieving objects in mounted persistent volumes.
- InitContainer: Manages configuration secrets during startup and terminates afterward.
- SideCar Container: Monitors and updates configuration secrets, and checks for root credentials, raising an error if they are missing.

I will be using the MinIO as a artifact repository for my Argo Workflows CI pipeline.

### install
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
helm repo add minio-operator https://operator.min.io
helm upgrade --install --namespace minio-operator --create-namespace --version 5.0.15 operator minio-operator/operator
kubectl get all -n minio-operator

Get the JWT secret to access the console:
kubectl -n minio-operator get secret console-sa-secret -o jsonpath="{.data.token}" | base64 --decode

Access locally:
kubectl --namespace minio-operator port-forward svc/console 9090:9090

or via ingress at root path:
kubectl apply -f ingress.yaml

### uninstall  
helm uninstall operator -n minio-operator