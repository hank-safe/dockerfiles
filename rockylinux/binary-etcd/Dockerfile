FROM rockylinux/rockylinux:10.0

WORKDIR /packs

RUN yum install wget epel-release ca-certificates -y

ARG app_version=3.5.17

RUN wget https://github.com/etcd-io/etcd/releases/download/v${app_version}/etcd-v${app_version}-linux-amd64.tar.gz && \
    mkdir -p /packs/x86_64 && \
    tar xf etcd-v${app_version}-linux-amd64.tar.gz && \
    mv etcd-v${app_version}-linux-amd64/etcd /packs/x86_64/ && \
    mv etcd-v${app_version}-linux-amd64/etcdctl /packs/x86_64/ && \
    mv etcd-v${app_version}-linux-amd64/etcdutl /packs/x86_64/

RUN wget https://github.com/etcd-io/etcd/releases/download/v${app_version}/etcd-v${app_version}-linux-arm64.tar.gz && \
    mkdir -p /packs/aarch64 && \
    tar xf etcd-v${app_version}-linux-arm64.tar.gz && \
    mv etcd-v${app_version}-linux-arm64/etcd /packs/aarch64/ && \
    mv etcd-v${app_version}-linux-arm64/etcdctl /packs/aarch64/ && \
    mv etcd-v${app_version}-linux-arm64/etcdutl /packs/aarch64/
