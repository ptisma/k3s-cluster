#### loghorn
##### pods-pvc-default.yaml
This will deploy two busybox pods which will mount a volume based on the PVC. Since it's using a default storage class, it's local-path on k3s, we need to ensure they get deployed on the same node, PVC as well. We can't use the access modes MANY in this case because the default storage class local-path uses the local directory provisioner on a node.

Note: it seems if I want the pods using nodeName for my server node node-o, the PVC doesn't want to get bound, but it works for nodeSelector with the node's label.

#### pods-pvc-longhorn.yaml
This will deploy a simple PVC and a pod which will mount a volume out of it. The PVC will use the longhorn storage class, as opposed to the k3's default local-path provisioner. Note the Longhorn has to be installed.

Longhorn will persist and replicate the volumes in a .img format in a folder located on the node's filesystem:
/var/lib/longhorn/replicas/

### traefik
#### ingress-middleware-pods.yaml
This will deploy a simple ingress which will connect to the service and deployment. Since the k3s comes by default installed with the Traefik Ingress Controller (check the pods on every node inside the kube-system namespace and find the traefik :), we will also have to deploy a "Traefik kind", a middleware, it's basically a component which tweaks the requests before they are sent to our service, it acts as middleware between the ingress and service.

After the ingress is deployed, simply use one of the external ip of the nodes and hit the /nginx endpoint, I did preconfigure way back beore the DNS entry to point at one of my nodes, so I used that host name in the ingress.

### argocd
#### argocd-helm-root-app.yaml
Create the namespace argocd-helm first. 
This will deploy a ArgoCD project and ArgoCD root application. We are using the ArgoCD app-of-apps pattern, the root application will then track the kind Application manifests in the apps folder which are going to be the child applications. These then Applications will target their own specific manifests inside their perspective target repos, in this case they will deploy the Helm charts defined in https://github.com/ptisma/argocd-helm repository. Helm charts here are defined alongside the application code for sake of simplicity, this is not a good practice in GitOps and they should be decoupled.

#### apps/argocd-helm-server-app.yaml
This contains the kind Application which represents the Helm packaged argocd-helm-server application defined in https://github.com/ptisma/argocd-helm. The values for the Helm chart are injected in two ways: using static value files defined in the application repo and dynamic secret values using external secrets. Alongside the other manifests such as deployment, service etc. I have also added the ExternalSecret kind, which is going to create the regular Secret which will in fact contain this "secret" data, this eliminates the need for embedding the secret data in git.

I have also added the ArgoCD sync hook, which is just a simple sleep job, in the manifest file to demonstrate the sync waves. Using sync waves on our Applications we control the flow of deployment of our Helm packaged applications, we want to deploy the argocd-helm-server before the argocd-helm-client.

Sadly, when deploying Helm packaged applications using ArgoCD, the applications do not show when running helm list.

docs for value file:
https://github.com/argoproj/argo-cd/blob/master/docs/operator-manual/application.yaml

#### apps/argocd-helm-client-app.yaml
Same as above, except its deploying a argocd-helm-client, in this case I am not using the ExternalSecret, just static value file.

### external-secrets
#### external-secrets.yaml
This will deploy a external-secrets ClusterSecretStore and ExternalSecret. The ClusterSecretStore is using the fake provider, the ClusterSecretStore is being used by the example application "argocd-helm" which has the ExternalSecret defined in its chart.
External Secrets Operator uses its own CRD-s: we create the ExternalSecret which references the SecretStore, think of it as a object instance of some external secret API, once the ExternalSecret "fetches the data", it stores it locally at our cluster as regular Kubernetes Secret.
https://github.com/ptisma/argocd-helm


#### 
argo submit hello-world-workflow.yaml