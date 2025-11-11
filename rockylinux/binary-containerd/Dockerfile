FROM rockylinux/rockylinux:10.0

WORKDIR /packs

RUN yum install wget epel-release ca-certificates -y

ARG app_version=1.7.28

RUN mkdir -p /packs/containerd-x86_64 && \
    mkdir -p /packs/containerd-aarch64 

RUN wget -O containerd-amd64.tar.gz https://github.com/containerd/containerd/releases/download/v${app_version}/containerd-${app_version}-linux-amd64.tar.gz && \
    tar xf containerd-amd64.tar.gz && \
    mv bin/* /packs/containerd-x86_64 && \
    rm -rf bin containerd-amd64.tar.gz 

RUN wget -O containerd-arm64.tar.gz https://github.com/containerd/containerd/releases/download/v${app_version}/containerd-${app_version}-linux-arm64.tar.gz && \
    tar xf containerd-arm64.tar.gz && \
    mv bin/* /packs/containerd-aarch64 && \
    rm -rf bin containerd-arm64.tar.gz 