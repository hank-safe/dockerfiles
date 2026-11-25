#!/bin/bash

# config
if [ ! -d "/opt/conf" ]; then
    mkdir -p /opt/conf
fi
if [ ! -f "/opt/conf/default.conf" ]; then
    mv /etc/nginx/conf.d/default.conf /opt/conf
else
    rm -rf /etc/nginx/conf.d/default.conf
fi
ln -s /opt/conf/default.conf /etc/nginx/conf.d/default.conf
if [ ! -f "/opt/conf/nginx.conf" ]; then
    mv /etc/nginx/nginx.conf /opt/conf
else
    rm -rf /etc/nginx/nginx.conf
fi
ln -s /opt/conf/nginx.conf /etc/nginx/nginx.conf

if [ -n "${FASTDFS_NGINX_URL}" ];then
    sed -i "s/{{fastdfs_nginx_url}}/${FASTDFS_NGINX_URL}/g" /opt/conf/default.conf
fi

# start nginx
nginx -g 'daemon off;'
