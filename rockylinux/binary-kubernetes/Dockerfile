FROM rockylinux/rockylinux:10.0

WORKDIR /packs

RUN yum install wget epel-release ca-certificates -y

ARG app_version=1.26.15

RUN mkdir -p /packs/amd64/kubernetes /packs/arm64/kubernetes

RUN wget https://dl.k8s.io/v${app_version}/kubernetes-server-linux-amd64.tar.gz && \
    tar xf kubernetes-server-linux-amd64.tar.gz && \
    mv kubernetes/server/bin/kube-apiserver /packs/amd64/kubernetes/ && \
    mv kubernetes/server/bin/kube-controller-manager /packs/amd64/kubernetes/ && \
    mv kubernetes/server/bin/kube-scheduler /packs/amd64/kubernetes/ && \
    mv kubernetes/server/bin/kube-proxy /packs/amd64/kubernetes/ && \
    mv kubernetes/server/bin/kubectl /packs/amd64/kubernetes/ && \
    mv kubernetes/server/bin/kubelet /packs/amd64/kubernetes/ && \
    mv kubernetes/server/bin/kubeadm /packs/amd64/kubernetes/ && \
    rm -rf kubernetes kubernetes-server-linux-amd64.tar.gz

RUN wget https://dl.k8s.io/v${app_version}/kubernetes-server-linux-arm64.tar.gz && \
    tar xf kubernetes-server-linux-arm64.tar.gz && \
    mv kubernetes/server/bin/kube-apiserver /packs/arm64/kubernetes/ && \
    mv kubernetes/server/bin/kube-controller-manager /packs/arm64/kubernetes/ && \
    mv kubernetes/server/bin/kube-scheduler /packs/arm64/kubernetes/ && \
    mv kubernetes/server/bin/kube-proxy /packs/arm64/kubernetes/ && \
    mv kubernetes/server/bin/kubectl /packs/arm64/kubernetes/ && \
    mv kubernetes/server/bin/kubelet /packs/arm64/kubernetes/ && \
    mv kubernetes/server/bin/kubeadm /packs/arm64/kubernetes/ && \
    rm -rf kubernetes kubernetes-server-linux-arm64.tar.gz
