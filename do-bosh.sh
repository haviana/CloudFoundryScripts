#!/bin/bash

state="--state=./state.json"
if [ -z $1 ]; then
  action="int"
else
  action=$1
fi

# if doing interpolate, then state is invalid option
if [ "$action" == "int" ]; then
  state=""
fi

echo Performing $action
bosh $action \
    $state \
    bosh-deployment/bosh.yml \
    --vars-store=./creds.yml \
    -o bosh-deployment/virtualbox/cpi.yml \
    -o bosh-deployment/virtualbox/outbound-network.yml \
    -o bosh-deployment/bosh-lite.yml \
    -o bosh-deployment/bosh-lite-runc.yml \
    -o bosh-deployment/uaa.yml \
    -o bosh-deployment/credhub.yml \
    -o bosh-deployment/jumpbox-user.yml \
    -o override-size.yml \
    -v director_name=VirtualBox-Director \
    -v internal_ip=192.168.50.2 \
    -v internal_gw=192.168.50.1 \
    -v internal_cidr=192.168.50.0/24 \
    -v outbound_network_name=NatNetwork \
    --vars-file vars.yml \
#source ~/.profile
#Interpolate admin password from creds.yml
#bosh int ./creds.yml --path /admin_password
#Create Bosh Alias to VirtualBox
#bosh -e 192.168.50.2 alias-env virtualbox --ca-cert <(bosh int ./creds.yml --path /director_ssl/ca)

# get key from creds file
#bosh int creds.yml --path /jumpbox_ssh/private_key > jumpbox.key
#chmod 600 jumpbox.key

# For testing SSh connection to the vm
# ssh jumpbox@192.168.50.6 -i jumpbox.key

#To list the env created
#bosh envs
#bosh login
