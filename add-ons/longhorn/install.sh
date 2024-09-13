#!/bin/bash

# Script name: install.sh
# Description: This script installs the longhorn in the specified namespace and sets up the ingress with the authentication with specified credentials.
# Usage: ./install.sh <arg1> <arg2> <arg3>
#
# Arguments:
#   arg1: The first argument, used for specifying the namespace where to install the longhorn
#   arg2: The second argument, used for specifying the longhorn username
#   arg3: The third argument, used for specifying the longhorn password

# Exit immediately if any command exits with a non-zero status
set -e

# Check if the required number of arguments is passed
if [ "$#" -ne 3 ]; then
  echo "Error: Invalid number of arguments."
  exit 1
fi

# Check if the node VM meets the Longhorn system requirements with a script:
curl -sSfL https://raw.githubusercontent.com/longhorn/longhorn/v1.6.2/scripts/environment_check.sh | bash

# Install Longhorn using Helm:
helm repo add longhorn https://charts.longhorn.io
helm repo update
helm upgrade --install longhorn longhorn/longhorn --namespace "$1" --create-namespace --version 1.6.2

# Set the credentials to access the Longhorn UI:
USER="$2"
PASSWORD="$3"
echo "${USER}:$(openssl passwd -stdin -apr1 <<< ${PASSWORD})" >> auth
kubectl -n "$1" create secret generic basic-auth --from-file=auth

# Deploy ingress to access the Longhorn UI (by default the Longhorn UI works only on '/' so replacePathRegex was used on ingress):
kubectl apply -f ingress.yaml

# Note: for some reason when the path /longhorn is set, the blank white page is rendered so it works only with /longhorn/
#Use the credentials you defined in the secret to access the Longhorn UI
