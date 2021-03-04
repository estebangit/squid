#!/bin/bash

#root_path='/Users/esteban/Projets/squid2/docker-squid4/squid'
root_path='/Users/ebarajas/projects/squid/squid_mitm/squid_client'
root_path_mitm='/Users/ebarajas/projects/squid/squid_mitm/squid_mitm'
cert_name='local_mitm'
host_name='kubernetes.docker.internal'
rm -rf ${root_path}
mkdir -p "${root_path}/etc/ssl/certs"

# openssl pkcs12 -export \
#     -out "${root_path}/etc/ssl/certs/${cert_name}.pfx" \
#     -inkey "${root_path_mitm}/etc/ssl/private/${cert_name}.key" \
#     -in "${root_path_mitm}/etc/ssl/certs/${cert_name}.crt"

echo 'Copy certificats ...'
# cp "${root_path_mitm}/etc/ssl/private/${cert_name}.key" "${root_path}/etc/ssl/private/${cert_name}.key"
cp "${root_path_mitm}/etc/ssl/certs/${cert_name}.crt" "${root_path}/etc/ssl/certs/${cert_name}.crt"
#cp "${root_path_mitm}/etc/ssl/certs/${cert_name}.pem" "${root_path}/etc/ssl/certs/${cert_name}.pem"
#cp www-google-com.pem "${root_path}/etc/ssl/certs/google.pem"
#cp www-google-com-chain.pem "${root_path}/etc/ssl/certs/google-chain.pem"

echo 'Client'
#curl -v -x localhost:3128 --cacert "${root_path}/etc/ssl/certs/${cert_name}.crt" -i https://mcsvc.dynatrace.com

curl -k -v --proxy ${host_name}:3128 -o /dev/null \
    --proxy-capath "${root_path}/etc/ssl/certs" \
    --proxy-cacert "${root_path}/etc/ssl/certs/${cert_name}.crt" \
    GET https://mcsvc.dynatrace.com/

# curl -k -v --proxy ${host_name}:3128 -o /dev/null \
#     --proxy-capath "${root_path}/etc/ssl/certs" \
#     --proxy-cacert "${root_path}/etc/ssl/certs/${cert_name}.crt" \
#     GET https://www.google.com/

# curl -v -x ${host_name}:8080 \
#     -i http://www.google.com
# curl -v -x ${host_name}:8080 \
#     -i https://mcsvc.dynatrace.com