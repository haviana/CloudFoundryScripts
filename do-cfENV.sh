#!/bin/bash
echo "Creating Performing action"
echo "system_domain: $SYSTEM_DOMAIN"
echo Performing $1
echo "Loading system variables"
./systemVariables.sh
# if doing interpolate, then state is invalid option
create_cf_env(){
if [ "$action" == "int" ]; then
  state=""
else
  echo " setting up DNS config"
  bosh update-runtime-config bosh-deployment/runtime-configs/dns.yml --name dns
  echo " Installing stemcell"
  bosh upload-stemcell --sha1 b33bc047562aab2d9860420228aadbd88c5fccfb \
  https://bosh.io/d/stemcells/bosh-warden-boshlite-ubuntu-xenial-go_agent?v=315.36
fi

echo "$CF_DEPLOYMENT_HOME"
bosh \
  -d cf \
 $action \
  $CF_DEPLOYMENT_HOME/cf-deployment.yml \
  -o $CF_DEPLOYMENT_HOME/operations/bosh-lite.yml \
  -o $CF_DEPLOYMENT_HOME/operations/scale-to-one-az.yml \
  -o $CF_DEPLOYMENT_HOME/operations/use-compiled-releases.yml \
  -v system_domain=$SYSTEM_DOMAIN
if  [ $? -eq 0 ]; then
   echo "Creation of cf successfully finished.."
else
 echo "Fail - Deleting cf deployment"
 bosh -d cf delete-deployment
fi
}
echo "select the operation ************"
echo "  1)CF Installation Info"
echo "  2)Deploy CF"
echo "  3)Undeploy CF"

read n
case $n in
  1) echo "You chose Option 1"
        action=int
        create_cf_env;;
  2) echo "You chose Option 2"
     action=deploy
        create_cf_env;;

  3) echo "You chose Option 3"
 	bosh -d cf delete-deployment
        ;;
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

