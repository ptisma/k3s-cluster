#!/bin/bash

# Script name: uninstall.sh
# Description: This script uninstalls the longhorn in the specified namespace
# Usage: ./uninstall.sh <arg1>
#
# Arguments:
#   arg1: The first argument, used for specifying the namespace where the longhorn is installed at
#   arg2: The second argument, used for specifying the name of the helm release used with installation of longhorn


# Exit immediately if any command exits with a non-zero status
set -e

# Check if the required number of arguments is passed
if [ "$#" -ne 2 ]; then
  echo "Error: Invalid number of arguments."
  exit 1
fi
helm uninstall "$2" -n "$1"

# Using kubectl (Helm did not delete the CRD-s sucessfully):
kubectl create -f https://raw.githubusercontent.com/longhorn/longhorn/v1.6.2/uninstall/uninstall.yaml
kubectl get job/longhorn-uninstall -n "$1" -w