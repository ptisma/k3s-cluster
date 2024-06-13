#!/bin/bash

export CONFIG=/root/k3s-cluster/k3-master/config.yaml

curl -sfL https://get.k3s.io | sh -s - -c $CONFIG

echo "MASTER SERVER TOKEN AT /var/lib/rancher/k3s/server/node-token saved in TOKEN ENV VAR"

cat /var/lib/rancher/k3s/server/node-token