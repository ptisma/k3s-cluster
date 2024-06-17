#!/bin/bash

curl -sfL http://get.k3s.io | K3S_URL=$URL K3S_TOKEN=$TOKEN sh -s - -c $CONFIG
