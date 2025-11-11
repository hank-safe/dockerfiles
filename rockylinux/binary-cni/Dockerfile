FROM rockylinux/rockylinux:10.0

WORKDIR /packs

RUN yum install wget epel-release ca-certificates -y

ARG app_version=1.6.2


RUN wget -O cni.tar.gz https://github.com/containernetworking/plugins/releases/download/v${app_version}/cni-plugins-linux-amd64-v${app_version}.tgz && \
    mkdir -p cni-x86_64 && \
    tar xf cni.tar.gz -C cni-x86_64 && \
    rm -f cni.tar.gz

    
RUN wget -O cni.tar.gz https://github.com/containernetworking/plugins/releases/download/v${app_version}/cni-plugins-linux-arm64-v${app_version}.tgz && \
    mkdir -p cni-aarch64 && \
    tar xf cni.tar.gz -C cni-aarch64 && \
    rm -f cni.tar.gz

