### Instructions how to setup the master node

Set the absolute config file:
export CONFIG=$HOME/k3s-cluster/k3s-worker/config.yaml

Run the script:
chmod a+x master.sh
./master.sh

It will output the master node token which is used in worker nodes to join in the cluster.

To uninstall the worker node run these commands:
sudo /usr/local/bin/k3s-agent-uninstall.sh
sudo rm -rf /var/lib/rancher