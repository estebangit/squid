#!/bin/bash

root_path='/Users/esteban/Projets/squid2/docker-squid4/squid'
root_path_mitm='/Users/ebarajas/projects/squid/squid_mitm/squid_mitm'
cert_name='local_mitm'
host_name='kubernetes.docker.internal'
rm -rf ${root_path}
mkdir -p "${root_path}/etc/ssl/certs"

echo 'Copy certificats ...'
# cp "${root_path_mitm}/etc/ssl/private/${cert_name}.key" "${root_path}/etc/ssl/private/${cert_name}.key"
cp "${root_path_mitm}/etc/ssl/certs/${cert_name}.crt" "${root_path}/etc/ssl/certs/${cert_name}.crt"

echo 'Client'

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