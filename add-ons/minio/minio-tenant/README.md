### minio-tenant
MinIO tenant in Kubernetes represents an isolated, logically grouped set of resources managed by MinIO, including pods, persistent volumes, and configurations. This setup ensures efficient resource usage and secure, independent storage instances for different users or applications within a single Kubernetes cluster.

### install
We deploy the tenant using Kustomize:
kubectl apply -f kustomization.yaml

Access the tenant's console (previously configured to activate the console):
kubectl -n tenant-tiny port-forward service/myminio-console 8080:9443

Visit https://localhost:8080

### usage
To interact with the MinIO tenant we first install the MinIO client CLI tool:
curl https://dl.min.io/client/mc/release/linux-amd64/mc \
  --create-dirs \
  -o $HOME/minio-binaries/mc

chmod +x $HOME/minio-binaries/mc
export PATH=$PATH:$HOME/minio-binaries/

Login into the tenant's console using previously configured credentials, head to access keys tab and create access keys

Create the mc client pod and connect to it:
kubectl apply -f client/pod.yaml
kubectl exec -it -n tenant-tiny minio-ubuntu-client -- /bin/sh

Use the previously configured access keys to add the minio tenant:
mc alias set myminio --insecure https://myminio-hl:9000 <ACCESS_KEY> <SECRET_KEY>

Check if the connection is sucessful:
mc admin info --insecure myminio

Note: we are using the --insecure flag because the tenant is configured to run with SSL mode on, and the certificate is issued by minio-operator so thats why its not valid
