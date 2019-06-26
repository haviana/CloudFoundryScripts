#!/bin/bash
echo "Creating Performing action"
echo "system_domain: $SYSTEM_DOMAIN"
echo Performing $1
echo "Loading system variables"
source ./systemVariables.sh
# if doing interpolate, then state is invalid option
create_cf_env(){
if [ "$action" == "int" ]; then
  state=""
else
  echo " setting up DNS config"
  bosh update-runtime-config $BOSH_HOME/bosh-deployment/runtime-configs/dns.yml --name dns
  bosh update-cloud-config $CF_DEPLOYMENT_HOME/iaas-support/bosh-lite/cloud-config.yml
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
echo "  4)Install CF cli tool and Credhub"

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
       #
       # Install CredHub
       #
	# get release
        wget https://github.com/cloudfoundry-incubator/credhub-cli/releases/download/2.2.0/credhub-linux-2.2.0.tgz 
        # extract
        tar xvfz cred*.tgz
        # put in path and executable
        chmod ugo+r+x credhub
        sudo chown root:root credhub
        sudo mv credhub /usr/local/bin/.
        #
        # Install CF cli Tool
        #
	# get key, add repo source
	wget -q -O - https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | sudo apt-key add -

	echo "deb http://packages.cloudfoundry.org/debian stable main" | sudo tee /etc/apt/sources.list.d/cloudfoundry-cli.list

	# install package
	sudo apt-get update
	sudo apt-get install cf-cli curl -y
        ;;
  *) echo "invalid option";;
esac

