### Instructions how to setup the master node

Set the absolute config file:
export CONFIG=$HOME/k3s-cluster/k3s-master/config.yaml

Run the script:
chmod a+x master.sh
./master.sh

To uninstall the k3s master node run these commands:
sudo /usr/local/bin/k3s-uninstall.sh
sudo rm -rf /var/lib/rancher