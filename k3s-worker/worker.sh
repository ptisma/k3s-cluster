#!/bin/bash

export CONFIG=/root/k3s-cluster/k3s-worker/config.yaml

curl -sfL http://get.k3s.io | K3S_URL=$URL K3S_TOKEN=$TOKEN sh -s - -c $CONFIG
