FROM rockylinux/rockylinux:10.0

WORKDIR /packs

RUN yum install wget epel-release ca-certificates -y

ARG app_version=1.6.5

RUN mkdir -p /packs/amd64/cfssl /packs/arm64/cfssl

RUN wget -O /packs/amd64/cfssl/cfssl https://github.com/cloudflare/cfssl/releases/download/v${app_version}/cfssl_${app_version}_linux_amd64 && \
    wget -O /packs/amd64/cfssl/cfssljson https://github.com/cloudflare/cfssl/releases/download/v${app_version}/cfssljson_${app_version}_linux_amd64 && \
    wget -O /packs/amd64/cfssl/cfssl-certinfo https://github.com/cloudflare/cfssl/releases/download/v${app_version}/cfssl-certinfo_${app_version}_linux_amd64

RUN wget -O /packs/arm64/cfssl/cfssl https://github.com/cloudflare/cfssl/releases/download/v${app_version}/cfssl_${app_version}_linux_arm64 && \
    wget -O /packs/arm64/cfssl/cfssljson https://github.com/cloudflare/cfssl/releases/download/v${app_version}/cfssljson_${app_version}_linux_arm64 && \
    wget -O /packs/arm64/cfssl/cfssl-certinfo https://github.com/cloudflare/cfssl/releases/download/v${app_version}/cfssl-certinfo_${app_version}_linux_arm64
