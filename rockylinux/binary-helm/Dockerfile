FROM rockylinux/rockylinux:10.0

WORKDIR /packs


RUN yum install wget epel-release ca-certificates -y

ARG app_version=3.16.3

RUN mkdir -p /packs/helm-amd64 && \
    mkdir -p /packs/helm-arm64

RUN wget https://get.helm.sh/helm-v${app_version}-linux-amd64.tar.gz && \
    tar xf helm-v${app_version}-linux-amd64.tar.gz && \
    mv linux-amd64/helm /packs/helm-amd64/helm && \
    rm -rf linux-amd64 helm-v${app_version}-linux-amd64.tar.gz

RUN wget https://get.helm.sh/helm-v${app_version}-linux-arm64.tar.gz && \
    tar xf helm-v${app_version}-linux-arm64.tar.gz && \
    mv linux-arm64/helm /packs/helm-arm64/helm && \
    rm -rf linux-arm64 helm-v${app_version}-linux-arm64.tar.gz
