### minio-tenant
MinIO tenant in Kubernetes represents an isolated, logically grouped set of resources managed by MinIO, including pods, persistent volumes, and configurations. This setup ensures efficient resource usage and secure, independent storage instances for different users or applications within a single Kubernetes cluster.

### install
helm repo add minio https://operator.min.io/
helm upgrade --install -f values.yaml --namespace tenant-ns --create-namespace tenant minio/tenant
