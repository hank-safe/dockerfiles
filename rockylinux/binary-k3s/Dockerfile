FROM rockylinux/rockylinux:10.0

WORKDIR /packs

RUN yum install wget epel-release ca-certificates -y

ARG app_version=1.32.2+k3s1

# https://docs.rancher.cn/docs/k3s/installation/airgap/_index/
# k3s 的release使用了 + 号，到了域名就是   %2B
RUN mkdir -p /packs/x86_64 && \
    cd /packs/x86_64 && \
    wget -O k3s-airgap-images.tar.gz "https://github.com/k3s-io/k3s/releases/download/v${app_version}/k3s-airgap-images-amd64.tar.gz" && \
    wget -O k3s "https://github.com/k3s-io/k3s/releases/download/v${app_version}/k3s"

RUN mkdir -p /packs/aarch64 && \
    cd /packs/aarch64 && \
    wget -O k3s-airgap-images.tar.gz "https://github.com/k3s-io/k3s/releases/download/v${app_version}/k3s-airgap-images-arm64.tar.gz" && \
    wget -O k3s "https://github.com/k3s-io/k3s/releases/download/v${app_version}/k3s-arm64"
