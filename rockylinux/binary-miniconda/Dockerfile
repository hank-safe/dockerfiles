FROM rockylinux/rockylinux:10.0 AS build-arm64

RUN yum install wget epel-release ca-certificates -y

ARG https_proxy
ARG http_proxy

ARG app_version=py39_24.11.1-0

WORKDIR /packs/arm64/miniconda

RUN wget -O Miniconda3-aarch64.sh https://repo.anaconda.com/miniconda/Miniconda3-${app_version}-Linux-aarch64.sh 

RUN bash Miniconda3-aarch64.sh -b -p /miniconda && \
    export PATH="/miniconda/bin:$PATH" && \
    mkdir -p /packs/arm64/miniconda/ansible-base && \
    pip3 download -d /packs/arm64/miniconda/ansible-base ansible-base==2.10.11 -i https://mirrors.ustc.edu.cn/pypi/simple && \
    cd /packs/arm64/miniconda && \
    tar zcvf ansible-base.tar.gz ansible-base && \
    rm -rf ansible-base && \
    rm -rf /miniconda

FROM --platform=linux/amd64 rockylinux/rockylinux:10.0 AS build-amd64

# 3.13.1
WORKDIR /packs/amd64/miniconda

ARG https_proxy
ARG http_proxy

ARG app_version=py39_24.11.1-0

RUN yum install wget epel-release ca-certificates -y

RUN wget -O Miniconda3-x86_64.sh https://repo.anaconda.com/miniconda/Miniconda3-${app_version}-Linux-x86_64.sh 

RUN bash Miniconda3-x86_64.sh -b -p /miniconda && \
    export PATH="/miniconda/bin:$PATH" && \
    mkdir -p /packs/amd64/miniconda/ansible-base && \
    pip3 download -d /packs/amd64/miniconda/ansible-base ansible-base==2.10.11 -i https://mirrors.ustc.edu.cn/pypi/simple && \
    cd /packs/amd64/miniconda && \
    tar zcvf ansible-base.tar.gz ansible-base && \
    rm -rf ansible-base && \
    rm -rf /miniconda

FROM rockylinux/rockylinux:10.0
WORKDIR /packs
COPY --from=build-arm64 /packs/arm64 /packs/arm64 
COPY --from=build-amd64 /packs/amd64 /packs/amd64 
