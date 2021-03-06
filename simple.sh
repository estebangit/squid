#!/bin/bash

echo ''
echo '**********************'
echo '**** Simple Mode *****'
echo '**********************'

# Start Squid5 in simple mode
echo 'Prepare env ...'
root_path='/Users/esteban/Projets/squid2/docker-squid4/squid_simple'
rm -rf ${root_path}
mkdir -p "${root_path}/cache"

echo 'Start docker ...'

docker run -t --rm --name squid_simple -p 8080:3128 \
    --volume="${root_path}/cache":/var/cache/squid5 \
    --volume="${root_path}/etc/ssl/certs":/etc/ssl/certs:ro \
    -e "MITM_PROXY=" \
    -e "DISABLE_CACHE=yes" \
    squid_mitm:latest

echo 'Done'
