### external-secrets
External Secrets Operator is a Kubernetes operator that integrates external secret management systems like AWS Secrets Manager, HashiCorp Vault, Google Secrets Manager, Azure Key Vault, IBM Cloud Secrets Manager, CyberArk Conjur and many more. The operator reads information from external APIs and automatically injects the values into a Kubernetes Secret.

### setup
Install via Helm:
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

helm repo add external-secrets https://charts.external-secrets.io

helm install external-secrets \
   external-secrets/external-secrets \
    -n external-secrets \
    --create-namespace 

### uninstall
Delete all the CRD-s:
kubectl get SecretStores,ClusterSecretStores,ExternalSecrets --all-namespaces

Delete the Helm release:
helm delete external-secrets --namespace external-secrets
