#!/bin/bash
bosh create-env bosh-deployment/bosh.yml
   --state ./state.json 
   --vars-store ./creds.yml
   -o bosh-deployment/virtualbox/cpi.yml
   -o bosh-deployment/virtualbox/outbound-network.yml
   -o bosh-deployment/bosh-lite.yml
   -o bosh-deployment/bosh-lite-runc.yml
   -o bosh-deployment/uaa.yml
   -o bosh-deployment/credhub.yml
   -o bosh-deployment/jumpbox-user.yml
   -o override-size.yml
   -v director_name=VirtualBox-Director
   -v internal_ip=192.168.50.2
   -v internal_gw=192.168.50.1
   -v internal_cidr=192.168.50.0/24
   -v outbound_network_name=NatNetwork
   --vars-file vars.yml 

