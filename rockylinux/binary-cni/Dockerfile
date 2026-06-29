FROM rockylinux/rockylinux:10.0

WORKDIR /packs

RUN yum install wget epel-release ca-certificates -y

ARG app_version=1.6.2

RUN mkdir -p /packs/amd64/cni /packs/arm64/cni

RUN wget -O cni.tar.gz https://github.com/containernetworking/plugins/releases/download/v${app_version}/cni-plugins-linux-amd64-v${app_version}.tgz && \
    tar xf cni.tar.gz -C /packs/amd64/cni && \
    rm -f cni.tar.gz
    
RUN wget -O cni.tar.gz https://github.com/containernetworking/plugins/releases/download/v${app_version}/cni-plugins-linux-arm64-v${app_version}.tgz && \
    tar xf cni.tar.gz -C /packs/arm64/cni && \
    rm -f cni.tar.gz
