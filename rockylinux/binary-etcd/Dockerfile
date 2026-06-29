FROM rockylinux/rockylinux:10.0

WORKDIR /packs

RUN yum install wget epel-release ca-certificates -y

ARG app_version=3.5.17

RUN mkdir -p /packs/amd64/etcd /packs/arm64/etcd

RUN wget https://github.com/etcd-io/etcd/releases/download/v${app_version}/etcd-v${app_version}-linux-amd64.tar.gz && \
    tar xf etcd-v${app_version}-linux-amd64.tar.gz && \
    mv etcd-v${app_version}-linux-amd64/etcd /packs/amd64/etcd/ && \
    mv etcd-v${app_version}-linux-amd64/etcdctl /packs/amd64/etcd/ && \
    mv etcd-v${app_version}-linux-amd64/etcdutl /packs/amd64/etcd/ && \
    rm -rf etcd-v${app_version}-linux-amd64 etcd-v${app_version}-linux-amd64.tar.gz

RUN wget https://github.com/etcd-io/etcd/releases/download/v${app_version}/etcd-v${app_version}-linux-arm64.tar.gz && \
    tar xf etcd-v${app_version}-linux-arm64.tar.gz && \
    mv etcd-v${app_version}-linux-arm64/etcd /packs/arm64/etcd/ && \
    mv etcd-v${app_version}-linux-arm64/etcdctl /packs/arm64/etcd/ && \
    mv etcd-v${app_version}-linux-arm64/etcdutl /packs/arm64/etcd/ && \
    rm -rf etcd-v${app_version}-linux-arm64 etcd-v${app_version}-linux-arm64.tar.gz
