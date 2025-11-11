FROM rockylinux/rockylinux:10.0 AS builder

RUN yum install wget epel-release ca-certificates -y

ARG https_proxy
ARG http_proxy

ARG app_version=py39_24.11.1-0

WORKDIR /packs

RUN wget -O Miniconda3-aarch64.sh https://repo.anaconda.com/miniconda/Miniconda3-${app_version}-Linux-aarch64.sh 

RUN bash Miniconda3-aarch64.sh -b -p /miniconda && \
    export PATH="/miniconda/bin:$PATH" && \
    mkdir -p /packs/ansible-base && \
    pip3 download -d /packs/ansible-base ansible-base==2.10.11 && \
    cd /packs && \
    tar zcvf ansible-base.tar.gz ansible-base && \
    rm -rf ansible-base && \
    rm -rf /miniconda

FROM rockylinux/rockylinux:10.0
WORKDIR /packs
COPY --from=builder /packs /packs 

