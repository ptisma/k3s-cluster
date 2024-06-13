#!/bin/bash

# Setup the k3s binary
curl -Lo /usr/local/bin/k3s https://github.com/k3s-io/k3s/releases/download/v1.26.5+k3s1/k3s

chmod a+x /usr/local/bin/k3s

# Install the k3s server using custom config file

k3s server -c config.yaml



