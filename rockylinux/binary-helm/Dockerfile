FROM rockylinux/rockylinux:10.0

WORKDIR /packs


RUN yum install wget epel-release ca-certificates -y

ARG app_version=3.16.3

RUN mkdir -p /packs/amd64/helm /packs/arm64/helm

RUN wget https://get.helm.sh/helm-v${app_version}-linux-amd64.tar.gz && \
    tar xf helm-v${app_version}-linux-amd64.tar.gz && \
    mv linux-amd64/helm /packs/amd64/helm/helm && \
    rm -rf linux-amd64 helm-v${app_version}-linux-amd64.tar.gz

RUN wget https://get.helm.sh/helm-v${app_version}-linux-arm64.tar.gz && \
    tar xf helm-v${app_version}-linux-arm64.tar.gz && \
    mv linux-arm64/helm /packs/arm64/helm/helm && \
    rm -rf linux-arm64 helm-v${app_version}-linux-arm64.tar.gz
