FROM rockylinux/rockylinux:10.0

WORKDIR /packs

RUN yum install wget epel-release ca-certificates -y

ARG app_version=28.5.2

RUN mkdir -p /packs/docker-x86_64 && \
    mkdir -p /packs/docker-aarch64

RUN wget -O docker-amd64.tgz https://download.docker.com/linux/static/stable/x86_64/docker-${app_version}.tgz && \
    tar xf docker-amd64.tgz && mv docker/* /packs/docker-x86_64 && rm -rf docker docker-amd64.tgz 


RUN wget -O docker-arm64.tgz https://download.docker.com/linux/static/stable/aarch64/docker-${app_version}.tgz && \
    tar xf docker-arm64.tgz && mv docker/* /packs/docker-aarch64 && rm -rf docker docker-arm64.tgz 
