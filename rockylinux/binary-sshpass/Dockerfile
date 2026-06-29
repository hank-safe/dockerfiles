FROM --platform=linux/arm64 rockylinux/rockylinux:10.0 AS builder-arm64

ARG https_proxy
ARG http_proxy

# 3.13.1
WORKDIR /packs

RUN yum install wget epel-release ca-certificates -y 

ARG app_version=1.09

RUN yum install gcc gcc-c++ make -y

RUN wget -O sshpass.tar.gz https://sourceforge.net/projects/sshpass/files/sshpass/${app_version}/sshpass-${app_version}.tar.gz/download && \
    tar xf sshpass.tar.gz && \
    cd sshpass-${app_version} && \
    mkdir -p /packs/binary-sshpass && \
    ./configure --prefix=/packs/binary-sshpass && \
    make && make install && \
    cd /packs && \
    rm -rf sshpass.tar.gz sshpass-${app_version}

FROM --platform=linux/amd64 rockylinux/rockylinux:10.0 AS builder-amd64

ARG https_proxy
ARG http_proxy

# 3.13.1
WORKDIR /packs

RUN yum install wget epel-release ca-certificates -y

ARG app_version=1.09

RUN yum install gcc gcc-c++ make -y

RUN wget -O sshpass.tar.gz https://sourceforge.net/projects/sshpass/files/sshpass/${app_version}/sshpass-${app_version}.tar.gz/download && \
    tar xf sshpass.tar.gz && \
    cd sshpass-${app_version} && \
    mkdir -p /packs/binary-sshpass && \
    ./configure --prefix=/packs/binary-sshpass && \
    make && make install && \
    cd /packs && \
    rm -rf sshpass.tar.gz sshpass-${app_version}

FROM rockylinux/rockylinux:10.0
WORKDIR /packs
RUN mkdir -p /packs/amd64/sshpass && \
    mkdir -p /packs/arm64/sshpass
COPY --from=builder-amd64 /packs/binary-sshpass/bin/sshpass /packs/amd64/sshpass/sshpass
COPY --from=builder-arm64 /packs/binary-sshpass/bin/sshpass /packs/arm64/sshpass/sshpass
