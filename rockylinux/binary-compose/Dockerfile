FROM rockylinux/rockylinux:10.0

WORKDIR /packs

RUN yum install wget epel-release ca-certificates -y

ARG app_version=2.31.0

RUN mkdir -p /packs/amd64/compose /packs/arm64/compose

RUN wget -O /packs/amd64/compose/docker-compose https://github.com/docker/compose/releases/download/v${app_version}/docker-compose-linux-x86_64 

RUN wget -O /packs/arm64/compose/docker-compose https://github.com/docker/compose/releases/download/v${app_version}/docker-compose-linux-aarch64 
