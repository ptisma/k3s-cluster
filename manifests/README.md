#### pods-pvc-default.yaml
This will deploy two busybox pods which will mount a volume based on the PVC. Since it's using a default storage class, it's local-path on k3s, we need to ensure they get deployed on the same node, PVC as well. We can't use the access modes MANY in this case because the default storage class local-path uses the local directory provisioner on a node.

Note: it seems if I want the pods using nodeName for my server node node-o, the PVC doesn't want to get bound, but it works for nodeSelector with the node's label.

### ingress-middleware-pods.yaml
This will deploy a simple ingress which will connect to the service and deployment. Since the k3s comes by default installed with the Traefik Ingress Controller (check the pods on every node inside the kube-system namespace and find the traefik :), we will also have to deploy a "Traefik kind", a middleware, it's basically a component which tweaks the requests before they are sent to our service, it acts as middleware between the ingress and service.

After the ingress is deployed, simply use one of the external ip of the nodes and hit the /nginx endpoint, I did preconfigure way back beore the DNS entry to point at one of my nodes, so I used that host name in the ingress.