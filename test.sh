#!/bin/bash

root_path='/Users/esteban/Projets/squid2/docker-squid4/squid'

openssl pkcs12 -export \
    -out "${root_path}/etc/ssl/certs/local_mitm.pfx" \
    -inkey "${root_path}/etc/ssl/certs/local_mitm.key" \
    -in "${root_path}/etc/ssl/certs/local_mitm.crt"

echo 'Client'
#curl -v -x localhost:3128 --cacert "${root_path}/etc/ssl/certs/local_mitm.crt" -i https://mcsvc.dynatrace.com

# curl -k -v -x kubernetes.docker.internal:3128 \
#     --proxy-capath "${root_path}/etc/ssl/certs" \
#     -i https://mcsvc.dynatrace.com
#     # --cacert "${root_path}/etc/ssl/certs/local_mitm.crt" /

curl -k -v -x kubernetes.docker.internal:3128 \
    --proxy-capath "${root_path}/etc/ssl/certs" \
    -i https://www.google.com
    # --cert "${root_path}/etc/ssl/certs/local_mitm.crt" --capath "${root_path}/etc/ssl/certs" \

# curl -v -x kubernetes.docker.internal:8080 \
#     -i http://www.google.com
# curl -v -x kubernetes.docker.internal:8080 \
#     -i https://mcsvc.dynatrace.com