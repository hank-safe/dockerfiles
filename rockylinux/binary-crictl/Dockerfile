FROM rockylinux/rockylinux:10.0

WORKDIR /packs

RUN yum install wget epel-release ca-certificates -y

ARG app_version=1.34.0

RUN mkdir -p /packs/amd64/crictl /packs/arm64/crictl

RUN wget -O crictl-linux-amd64.tar.gz https://github.com/kubernetes-sigs/cri-tools/releases/download/v${app_version}/crictl-v${app_version}-linux-amd64.tar.gz && \
    tar xf crictl-linux-amd64.tar.gz && \
    mv crictl /packs/amd64/crictl && \
    rm -f crictl-linux-amd64.tar.gz

RUN wget -O crictl-linux-arm64.tar.gz https://github.com/kubernetes-sigs/cri-tools/releases/download/v${app_version}/crictl-v${app_version}-linux-arm64.tar.gz && \
    tar xf crictl-linux-arm64.tar.gz && \
    mv crictl /packs/arm64/crictl && \
    rm -f crictl-linux-arm64.tar.gz 
