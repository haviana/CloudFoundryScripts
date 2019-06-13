#!/bin/bash
echo "Creating cf VM.."
echo "System domain: $SYSTEM_DOMAIN"
#bosh update-runtime-config bosh-deployment/runtime-configs/dns.yml --name dns
bosh -d cf deploy cf-deployment-9.2.0/cf-deployment.yml  
 -o cf-deployment-9.2.0/operations/bosh-lite.yml \
 -v system_domain=$SYSTEM_DOMAIN \
 -o cf-deployment-9.2.0/operations/scale-to-one-az.yml \
 -o cf-deployment-9.2.0/operations/use-compiled-releases.yml \
 -o ~/workspace/cf-deployment-9.2.0/operations/experimental/use-bosh-dns.yml \
 -o ~/workspace/cf-deployment-9.2.0/operations/experimental/use-bosh-dns-for-containers.yml \
 --no-redact
if  [ $? -eq 0 ]; then
   echo "Creation of cf successfully finished.."
else
 echo "Fail"
fi
