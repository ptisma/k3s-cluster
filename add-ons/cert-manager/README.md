### Instructions how to setup the cert-manager

### TLS/SSL concepts
Before we start setting up the cert-manager, let's revise some of the TLS/SSL concepts.

TLS CERT consists of:
- Public Key: Used for encryption and provided to clients.
- Private Key: Kept confidential on the server for decryption. (asymmetric cryptography)
- Certificate Authority (CA) Signature: Verifies the authenticity of the certificate.
- Domain Information
- Issuer Information
- Extensions
- Validity Period
- Version and Serial Number

Purpose of TLS cert:
- Encryption: data transmitted between the client and server is secure and protected
- Authentication: TLS certificates are issued by trusted Certificate Authorities (CAs). The presence of a valid TLS certificate signed by a trusted CA serves as proof that the server is who it claims to be.

Communication flow how is the certificate generated:
1. server generates the public-private key pair
2. server generates the CSR based on the public key. CSR contains information about the server and the company hosting it.
3. server sends CSR to CA
4. CA verifies server's identity and domain ownership. CA signs server's CSR with its private key, creating a certificate. CA delivers the signed certificate to the server
5. server uses the CA's public key to validate the signature on certificate, server then installs the certificate and uses its private key for secure communication, TLS certificate itself contains the server's public key and the CA's digital signature.

### How does the cert-manager works in our k3s cluster
cert-manager uses our created ClusterIssuer to define sources from which TLS certificates can be obtained. We then integrate this issuer with Ingress controller to automate TLS certificate management.

Inside the ClusterIssuer alongside the configuration of which CA we are going to use, Let's Encrypt, we also reference the secret which holds the ACME account private key. It will use that private key to register inside the Let's Encrypt ACME server.

cert-manager controller watches for ingress resources: if they get configured correctly, it will automatically start the process of creating the kind Certificate. This is a primary resource which is used to manage the lifecycle of the TLS certificate. cert-manager will use the ingress configuration such as DNS name and name of the tls secret, and will create the certificate with these attributes. This certificate will also reference the ClusterIssuer created beforehand.

Once that is created, cert-manager controller automatically generates a CSR, kind CertificateRequest for the domain names specified in the kind Certificate. Afterwards the HTTP challenge is solved, the CA issues certificate , the cert-manager stores the issued TLS certificate inside the secret which is referenced inside the Certificate.

### Setup
Point the k3s cluster configuration to env var so other tools can use it:
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

Add the repo and install the cert-manager
helm repo add jetstack https://charts.jetstack.io --force-update

helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.15.0 \
  --set crds.enabled=true

Install the cluster-issuer:
kubectl apply -f cluster-issuer.yaml

Modify the ingress, for example:
```
apiVersion: networking.k8s.io/v1 
kind: Ingress
metadata:
  name: kuard
  annotations:
    cert-manager.io/issuer: "letsencrypt-prod" # CONFIGURE

spec:
  ingressClassName: nginx
  tls:
  - hosts:
    - example.example.com              # CONFIGURE
    secretName: quickstart-example-tls # CONFIGURE
  rules:
  - host: example.example.com          # CONFIGURE
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: kuard
            port:
              number: 80
```
