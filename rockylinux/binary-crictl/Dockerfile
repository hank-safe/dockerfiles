FROM rockylinux/rockylinux:10.0

WORKDIR /packs

RUN yum install wget epel-release ca-certificates -y

ARG app_version=1.34.0

RUN mkdir -p /packs/crictl-x86_64 && \
    mkdir -p /packs/crictl-aarch64 

RUN wget -O crictl-linux-amd64.tar.gz https://github.com/kubernetes-sigs/cri-tools/releases/download/v${app_version}/crictl-v${app_version}-linux-amd64.tar.gz && \
    tar xf crictl-linux-amd64.tar.gz && \
    mv crictl /packs/crictl-x86_64 && \
    rm -f crictl-linux-amd64.tar.gz

RUN wget -O crictl-linux-arm64.tar.gz https://github.com/kubernetes-sigs/cri-tools/releases/download/v${app_version}/crictl-v${app_version}-linux-arm64.tar.gz && \
    tar xf crictl-linux-arm64.tar.gz && \
    mv crictl /packs/crictl-aarch64 && \
    rm -f crictl-linux-arm64.tar.gz 
