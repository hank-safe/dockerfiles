FROM rockylinux/rockylinux:10.0

WORKDIR /packs

RUN yum install wget epel-release ca-certificates -y

ARG app_version=1.26.15

RUN wget https://dl.k8s.io/v${app_version}/kubernetes-server-linux-amd64.tar.gz && \
    tar xf kubernetes-server-linux-amd64.tar.gz && \
    mkdir -p /packs/x86_64/ && \
    mv kubernetes/server/bin/kube-apiserver /packs/x86_64/ && \
    mv kubernetes/server/bin/kube-controller-manager /packs/x86_64/ && \
    mv kubernetes/server/bin/kube-scheduler /packs/x86_64/ && \
    mv kubernetes/server/bin/kube-proxy /packs/x86_64/ && \
    mv kubernetes/server/bin/kubectl /packs/x86_64/ && \
    mv kubernetes/server/bin/kubelet /packs/x86_64/ && \
    rm -rf kubernetes kubernetes-server-linux-amd64.tar.gz

RUN wget https://dl.k8s.io/v${app_version}/kubernetes-server-linux-arm64.tar.gz && \
    tar xf kubernetes-server-linux-arm64.tar.gz && \
    mkdir -p /packs/aarch64/ && \
    mv kubernetes/server/bin/kube-apiserver /packs/aarch64/ && \
    mv kubernetes/server/bin/kube-controller-manager /packs/aarch64/ && \
    mv kubernetes/server/bin/kube-scheduler /packs/aarch64/ && \
    mv kubernetes/server/bin/kube-proxy /packs/aarch64/ && \
    mv kubernetes/server/bin/kubectl /packs/aarch64/ && \
    mv kubernetes/server/bin/kubelet /packs/aarch64/ && \
    rm -rf kubernetes kubernetes-server-linux-arm64.tar.gz
