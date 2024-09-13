#!/bin/bash
# Check if the node VM meets the Longhorn system requirements with a script:
# 

# Install Longhorn using Helm:
helm repo add longhorn https://charts.longhorn.io
helm repo update
helm install longhorn longhorn/longhorn --namespace longhorn-system --create-namespace --version 1.7.1
kubectl -n longhorn-system get pod

# Set the credentials to access the Longhorn UI:
USER=admin; PASSWORD=admin; echo "${USER}:$(openssl passwd -stdin -apr1 <<< ${PASSWORD})" >> auth
kubectl -n longhorn-system create secret generic basic-auth --from-file=auth

# Deploy ingress to access the Longhorn UI (by default the Longhorn UI works only on '/' so replacePathRegex was used on ingress):
kubectl apply -f ingress.yaml

# Note: for some reason when the path /longhorn is set, the blank white page is rendered so it works only with /longhorn/
# Use the credentials you defined in the secret to access the Longhorn UI
