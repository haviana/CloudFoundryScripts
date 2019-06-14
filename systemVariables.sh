CF_VERSION=9.3.0
export BOSH_HOME=/opt/Development/bosh-virtualbox
export CF_DEPLOYMENT_HOME=/opt/Development/bosh-virtualbox/cf-deployment-$CF_VERSION
#Bosh Enviroment
export BOSH_ENVIRONMENT=virtualbox
export BOSH_LOG_LEVEL=info
export BOSH_CA_CERT=$(bosh int $BOSH_HOME/creds.yml --path /director_ssl/ca)

export BOSH_CLIENT=admin
export BOSH_CLIENT_SECRET=$(bosh int $BOSH_HOME/creds.yml --path /admin_password)

#CredHub authentication System
export CREDHUB_SERVER=https://192.168.50.2:8844
export CREDHUB_CLIENT=credhub-admin
export CREDHUB_SECRET=$(bosh interpolate  $BOSH_HOME/creds.yml --path=/credhub_admin_client_secret)
export CREDHUB_CA_CERT="$(bosh interpolate  $BOSH_HOME/creds.yml --path=/credhub_tls/ca )"$'\n'"$(bosh interpolate  $BOSH_HOME/creds.yml --path=/uaa_ssl/ca)"


# stemcell type
export STEMCELL_TYPE=$(bosh int  $CF_DEPLOYMENT_HOME/cf-deployment.yml --path /stemcells/alias=default/os)
# stemcell version
export STEMCELL_VERSION=$(bosh int  $CF_DEPLOYMENT_HOME/cf-deployment.yml --path /stemcells/alias=default/version)

export SYSTEM_DOMAIN=bosh-lite.com 

