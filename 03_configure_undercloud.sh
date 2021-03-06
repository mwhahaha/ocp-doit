#!/usr/bin/env bash
set -x

source common.sh

export OS_CLOUD=standalone

openstack endpoint list
wget https://download.cirros-cloud.net/0.4.0/cirros-0.4.0-x86_64-disk.img
openstack flavor create --ram 512 --disk 1 --vcpu 1 --public tiny
openstack network create --external --provider-physical-network datacentre --provider-network-type flat public
openstack network create --internal private
openstack subnet create public-net --subnet-range $NETWORK.0/24 --no-dhcp --gateway $DEFAULT_ROUTE --allocation-pool start=$NETWORK.3,end=$NETWORK.6 --network public
openstack subnet create private-net --subnet-range 192.168.24.0/24 --network private
openstack image create cirros --container-format bare --disk-format qcow2 --public --file cirros-0.4.0-x86_64-disk.img
if [ ! -f $HOME/.ssh/id_rsa ]; then
    ssh-keygen
fi
openstack keypair create --public-key ~/.ssh/id_rsa.pub default
# create basic security group to allow ssh/ping/dns
openstack security group list
openstack security group create basic
openstack security group rule create basic --protocol tcp --dst-port 22:22 --remote-ip 0.0.0.0/0
openstack security group rule create --protocol icmp basic
openstack security group rule create --protocol udp --dst-port 53:53 basic

lolcat <<EOF
Undercloud installed and configured.  To test:

# launch instance
openstack server create --flavor tiny --image cirros --key-name default --network private --security-group basic foo
# create router
openstack router create internets
openstack router set internets --external-gateway public
openstack router add subnet internets private-net
# create floating ip
openstack floating ip create public

openstack server add floating ip foo xxxx
# login to vm
echo ssh cirros@xxx
EOF
