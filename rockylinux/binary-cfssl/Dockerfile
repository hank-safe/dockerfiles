FROM rockylinux/rockylinux:10.0

WORKDIR /packs

RUN yum install wget epel-release ca-certificates -y

ARG app_version=1.6.5

RUN wget -O cfssl_linux-amd64 https://github.com/cloudflare/cfssl/releases/download/v${app_version}/cfssl_${app_version}_linux_amd64 && \
    wget -O cfssljson_linux-amd64 https://github.com/cloudflare/cfssl/releases/download/v${app_version}/cfssljson_${app_version}_linux_amd64 && \
    wget -O cfssl-certinfo_linux-amd64 https://github.com/cloudflare/cfssl/releases/download/v${app_version}/cfssl-certinfo_${app_version}_linux_amd64

RUN wget -O cfssl_linux-arm64 https://github.com/cloudflare/cfssl/releases/download/v${app_version}/cfssl_${app_version}_linux_arm64 && \
    wget -O cfssljson_linux-arm64 https://github.com/cloudflare/cfssl/releases/download/v${app_version}/cfssljson_${app_version}_linux_arm64 && \
    wget -O cfssl-certinfo_linux-arm64 https://github.com/cloudflare/cfssl/releases/download/v${app_version}/cfssl-certinfo_${app_version}_linux_arm64

