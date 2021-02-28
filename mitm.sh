#!/bin/bash

echo ''
echo '**********************'
echo '***** MITM Mode ******'
echo '**********************'

# Start Squid4 in MITM mode
echo 'Prepare env ...'
root_path='/Users/esteban/Projets/squid2/docker-squid4/squid_mitm'
cert_name='local_mitm'

mkdir -p "${root_path}/tmp"
mkdir -p "${root_path}/cache"
mkdir -p "${root_path}/etc/ssl/certs"
mkdir -p "${root_path}/etc/ssl/private"

# Generate certificat
echo 'Generate certificats ...'
openssl req -new -newkey rsa:2048 -sha256 -days 3650 -nodes -x509 -outform PEM -verbose \
    -keyout ${root_path}/etc/ssl/private/${cert_name}.key \
    -out ${root_path}/etc/ssl/certs/${cert_name}.crt \
    -config ./openssl.cnf
#    -subj "/C=CH/ST=Geneva/L=Geneva/O=Esteban/OU=test/CN=kubernetes.docker.internal"

echo ''
echo 'Check key'
openssl rsa -in ${root_path}/etc/ssl/private/${cert_name}.key -check
echo ''
echo ''
openssl x509 -in ${root_path}/etc/ssl/certs/${cert_name}.crt -text -noout

# echo ''
# echo 'Alternative certificate generation ...'
# # Generate Private Key
# openssl genrsa -out example.com.key 2048
# echo ' ---1---'
# # Create Certificate Signing Request
# openssl req -new -key "${root_path}/tmp/example.com.key" -out "${root_path}/tmp/example.com.csr" -config ./openssl.cnf
# echo ' ---2---'
# # Sign Certificate
# openssl x509 -req -days 3652 -in "${root_path}/tmp/example.com.csr" -signkey "${root_path}/tmp/example.com.key" -out "${root_path}/tmp/example.com.crt"
# echo ' ---3---'
# # Check
# openssl rsa -in "${root_path}/tmp/example.com.key" -check
# openssl x509 -in "${root_path}/tmp/example.com.crt" -text -noout

#echo 'Copy certificats ...'
# cp ca.key "${root_path}/etc/ssl/private/${cert_name}.key"
# cp ca.cer "${root_path}/etc/ssl/certs/${cert_name}.crt"

cp www-google-com-chain.pem "${root_path}/etc/ssl/certs/google-chain.pem"
cp www-google-com.pem "${root_path}/etc/ssl/certs/google.crt"

echo 'Start docker ...'

docker run -t --rm --name squid_mitm -p 3128:3128 \
    --volume="${root_path}/cache":/var/cache/squid4 \
    --volume="${root_path}/etc/ssl/certs":/etc/ssl/certs:ro \
    --volume="${root_path}/etc/ssl/private/${cert_name}.key":/${cert_name}.key:ro \
    --volume="${root_path}/etc/ssl/certs/${cert_name}.crt":/${cert_name}.crt:ro \
    -e "MITM_CERT=/${cert_name}.crt" \
    -e "MITM_KEY=/${cert_name}.key" \
    -e "MITM_PROXY=yes" \
    -e "MITM_PROXY_PARENT=kubernetes.docker.internal" \
    -e "MITM_PROXY_PARENT_PORT=8080" \
    -e "DISABLE_CACHE=yes" \
    -e "PROXYCHAIN=no" \
    -e "PROXYCHAIN_PROXY1=http 127.0.0.1 8080" \
    squid_mitm:latest

echo 'Done'
