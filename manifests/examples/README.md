#### pods-pvc-default.yaml
This will deploy two busybox pods which will mount a volume based on the PVC. Since it's using a default storage class, it's local-path on k3s, we need to ensure they get deployed on the same node, PVC as well. We can't use the access modes MANY in this case because the default storage class local-path uses the local directory provisioner on a node.

Note: it seems if I want the pods using nodeName for my server node node-o, the PVC doesn't want to get bound, but it works for nodeSelector with the node's label.

### ingress-middleware-pods.yaml
This will deploy a simple ingress which will connect to the service and deployment. Since the k3s comes by default installed with the Traefik Ingress Controller (check the pods on every node inside the kube-system namespace and find the traefik :), we will also have to deploy a "Traefik kind", a middleware, it's basically a component which tweaks the requests before they are sent to our service, it acts as middleware between the ingress and service.

After the ingress is deployed, simply use one of the external ip of the nodes and hit the /nginx endpoint, I did preconfigure way back beore the DNS entry to point at one of my nodes, so I used that host name in the ingress.

### pods-pvc-longhorn.yaml
This will deploy a simple PVC and a pod which will mount a volume out of it. The PVC will use the longhorn storage class, as opposed to the k3's default local-path provisioner. Note the Longhorn has to be installed.

Longhorn will persist and replicate the volumes in a .img format in a folder located on the node's filesystem:
/var/lib/longhorn/replicas/

### argocd-app.yaml


https://github.com/argoproj/argo-cd/blob/master/docs/operator-manual/application.yaml

### external-secrets.yaml
This will deploy a external-secrets ClusterSecretStore and ExternalSecret. The ClusterSecretStore is using the fake provider, the ClusterSecretStore is being used by the example application "argocd-helm" which has the ExternalSecret defined in its chart.
https://github.com/ptisma/argocd-helm