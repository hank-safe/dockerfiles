#!/bin/bash

# config
if [ ! -d "/opt/conf" ]; then
    mkdir -p /opt/conf
fi

if [ ! -f "/opt/conf/nginx.conf" ]; then
    mv /etc/nginx/nginx.conf /opt/conf
else
    rm -rf /etc/nginx/nginx.conf
fi
ln -s /opt/conf/nginx.conf /etc/nginx/nginx.conf

# start nginx
nginx -g 'daemon off;'
