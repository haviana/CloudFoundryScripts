# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi
CF_VERSION=9.2.0
# set PATH so it includes user's private bin directories
VERSION=v10.15.0
DISTRO=linux-x64
export=/usr/local/lib/nodejs/node-$VERSION-$DISTRO/bin:$PATH
PATH="$HOME/bin:$HOME/.local/bin:$PATH"

export BOSH_ENVIRONMENT=virtualbox
export BOSH_LOG_LEVEL=info
export BOSH_CA_CERT=$(bosh int /opt/Development/bosh-virtualbox/creds.yml --path /director_ssl/ca)

export BOSH_CLIENT=admin
export BOSH_CLIENT_SECRET=$(bosh int /opt/Development/bosh-virtualbox/creds.yml --path /admin_password)


export CREDHUB_SERVER=https://192.168.50.2:8844
export CREDHUB_CLIENT=credhub-admin
export CREDHUB_SECRET=$(bosh interpolate  /opt/Development/bosh-virtualbox/creds.yml --path=/credhub_admin_client_secret)
export CREDHUB_CA_CERT="$(bosh interpolate  /opt/Development/bosh-virtualbox/creds.yml --path=/credhub_tls/ca )"$'\n'"$(bosh interpolate  /opt/Development/bosh-virtualbox/creds.yml --path=/uaa_ssl/ca)"


# stemcell type
export STEMCELL_TYPE=$(bosh int  /opt/Development/bosh-virtualbox/cf-deployment-$CF_VERSION/cf-deployment.yml --path /stemcells/alias=default/os)
# stemcell version
export STEMCELL_VERSION=$(bosh int  /opt/Development/bosh-virtualbox/cf-deployment-$CF_VERSION/cf-deployment.yml --path /stemcells/alias=default/version)

export SYSTEM_DOMAIN=bosh-lite.com 
