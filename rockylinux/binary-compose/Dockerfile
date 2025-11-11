FROM rockylinux/rockylinux:10.0

WORKDIR /packs

RUN yum install wget epel-release ca-certificates -y

ARG app_version=2.31.0

RUN mkdir -p /packs/compose-x86_64 && \
    mkdir -p /packs/compose-aarch64 

RUN wget -O /packs/compose-x86_64/docker-compose https://github.com/docker/compose/releases/download/v${app_version}/docker-compose-linux-x86_64 


RUN wget -O /packs/compose-aarch64/docker-compose https://github.com/docker/compose/releases/download/v${app_version}/docker-compose-linux-aarch64 
