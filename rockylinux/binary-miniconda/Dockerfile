FROM rockylinux/rockylinux:10.0 AS builder

ARG TARGETARCH
ARG https_proxy
ARG http_proxy
ARG app_version=py39_24.11.1-0

RUN yum install wget epel-release ca-certificates -y

WORKDIR /tmp

RUN case "$TARGETARCH" in \
        amd64) upstream_arch="x86_64"; pack_arch="amd64" ;; \
        arm64) upstream_arch="aarch64"; pack_arch="arm64" ;; \
        *) echo "unsupported arch: $TARGETARCH" && exit 1 ;; \
    esac && \
    wget -O "Miniconda3-${upstream_arch}.sh" "https://repo.anaconda.com/miniconda/Miniconda3-${app_version}-Linux-${upstream_arch}.sh" && \
    bash "Miniconda3-${upstream_arch}.sh" -b -p /miniconda && \
    export PATH="/miniconda/bin:$PATH" && \
    mkdir -p "/packs/${pack_arch}/miniconda/ansible-base" && \
    pip3 download -d "/packs/${pack_arch}/miniconda/ansible-base" ansible-base==2.10.11 -i https://mirrors.ustc.edu.cn/pypi/simple && \
    cd "/packs/${pack_arch}/miniconda" && \
    tar zcvf ansible-base.tar.gz ansible-base && \
    rm -rf ansible-base /miniconda

FROM rockylinux/rockylinux:10.0

ARG TARGETARCH

WORKDIR /packs/${TARGETARCH}
COPY --from=builder /packs/${TARGETARCH} /packs/${TARGETARCH}

WORKDIR /packs
