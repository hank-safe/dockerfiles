FROM rockylinux/rockylinux:10.0 AS builder

ARG https_proxy
ARG http_proxy
ARG app_version=1.09

WORKDIR /packs

RUN yum install wget epel-release ca-certificates gcc gcc-c++ make -y

RUN wget -O sshpass.tar.gz https://sourceforge.net/projects/sshpass/files/sshpass/${app_version}/sshpass-${app_version}.tar.gz/download && \
    tar xf sshpass.tar.gz && \
    cd sshpass-${app_version} && \
    ./configure --prefix=/packs/sshpass && \
    make && \
    make install && \
    cd /packs && \
    rm -rf sshpass.tar.gz sshpass-${app_version}

FROM rockylinux/rockylinux:10.0

ARG TARGETARCH

WORKDIR /packs/${TARGETARCH}
COPY --from=builder /packs /packs/${TARGETARCH}

WORKDIR /packs
