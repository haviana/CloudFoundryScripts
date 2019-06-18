#!/bin/bash

# if doing interpolate, then state is invalid option
create_env ()
{
./systemVariables.sh
state="--state=./state.json"
  func_result="some result"
  if [ "$action" == "int" ]; then
   	state=""
   fi
   echo Performing $action $state
   bosh $action \
    $state \
    $BOSH_HOME/bosh-deployment/bosh.yml \
    --vars-store=$BOSH_HOME/creds.yml \
    -o $BOSH_HOME/bosh-deployment/virtualbox/cpi.yml \
    -o $BOSH_HOME/bosh-deployment/virtualbox/outbound-network.yml \
    -o $BOSH_HOME/bosh-deployment/bosh-lite.yml \
    -o $BOSH_HOME/bosh-deployment/bosh-lite-runc.yml \
    -o $BOSH_HOME/bosh-deployment/uaa.yml \
    -o $BOSH_HOME/bosh-deployment/credhub.yml \
    -o $BOSH_HOME/bosh-deployment/jumpbox-user.yml \
    -o $BOSH_HOME/override-size.yml \
    -v director_name=MGCB_DIRECTOR \
    -v internal_ip=192.168.50.2 \
    -v internal_gw=192.168.50.1 \
    -v internal_cidr=192.168.50.0/24 \
    -v outbound_network_name=NatNetwork \
    --vars-file $BOSH_HOME/vars.yml 
}
#source ~/.profile
echo "select the operation ************"
echo "  1)Installation Info"
echo "  2)Setup Bosh Cloud System"
echo "  3)Delete Bosh Cloud System"
echo "  4)Create ssh config files"
echo "  5)Create creds setup"
echo "  6)Cloud-config and Stemcell installation"

read n
case $n in
  1) echo "You chose Option 1"
	action=int
	create_env;;
  2) echo "You chose Option 2"
     action=create-env
	create_env;;

  3) echo "You chose Option 3"
	action=delete-env
	create_env;;
  4) echo "You chose Option 4"
	#get key from creds file
	#for testing ssh connection
	#ssh jumpbox@192.168.50.6 -i jumpbox.key
	bosh int creds.yml --path /jumpbox_ssh/private_key > jumpbox.key
	chmod 600 jumpbox.key;;
  5) echo "Interpolate admin password from creds.yml"
	bosh int ./creds.yml --path /admin_password
	bosh -e 192.168.50.2 alias-env virtualbox --ca-cert <(bosh int ./creds.yml --path /director_ssl/ca);;
  6) echo "You chose Option 6"
	yes Y | bosh update-cloud-config bosh-deployment/warden/cloud-config.yml
	wget https://bosh.io/d/stemcells/bosh-warden-boshlite-ubuntu-trusty-go_agent
	bosh upload-stemcell bosh-warden-boshlite-ubuntu-trusty-go_agent
	rm -f bosh-warden-boshlite-ubuntu-trusty-go_agent
	#ssh jumpbox@192.168.50.6 -i jumpbox.key
	;;
  *) echo "invalid option";;
esac
