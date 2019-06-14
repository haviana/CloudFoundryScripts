#!/bin/bash
echo "Creating Performing action"
echo "system_domain: $SYSTEM_DOMAIN"
echo Performing $1
echo "Loading system variables"
./systemVariables.sh
# if doing interpolate, then state is invalid option
action=$1
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
 $1 \
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
