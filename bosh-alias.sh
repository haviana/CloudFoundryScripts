#bosh alias-env virtualbox -e 192.168.50.2 --ca-cert <(bosh int ./creds.yml --path /director_ssl/ca)
bosh -e 192.168.50.2 alias-env virtualbox --ca-cert <(bosh int ./creds.yml --path /director_ssl/ca)
export BOSH_CLIENT=admin
export BOSH_CLIENT_SECRET=$(bosh int ./creds.yml --path /admin_password)
export BOSH_ENVIRONMENT=virtualbox
