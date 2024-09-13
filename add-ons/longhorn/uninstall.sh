#!/bin/bash

helm uninstall longhorn -n longhorn-system

# Using kubectl (Helm did not delete the CRD-s sucessfully):
kubectl create -f https://raw.githubusercontent.com/longhorn/longhorn/v1.6.2/uninstall/uninstall.yaml
kubectl get job/longhorn-uninstall -n longhorn-system -w