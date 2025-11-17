FROM alpine AS builder

ARG app_version=0.7.1

RUN apk add gcc g++ make automake autoconf  libtool linux-headers

WORKDIR /build

RUN wget https://zenlayer.dl.sourceforge.net/project/netcat/netcat/${app_version}/netcat-${app_version}.tar.gz && \
    tar xf netcat-${app_version}.tar.gz  && \
    cd netcat-${app_version} && \
    arch="$(arch)"; \
    case "$arch" in \
        'x86_64') CFLAGS=-static ./configure --prefix=/packs/netcat; \
        ;; \
        'aarch64') CFLAGS=-static ./configure --prefix=/packs/netcat --build=aarch64-unknown-linux-gnu; \
        ;; \
        *) echo >&2 "error: unsupported architecture: '$arch'"; exit 1; \
        ;; \
    esac; \
    make -j && make install 
WORKDIR /packs

FROM alpine

COPY --from=builder /packs /packs

WORKDIR /packs

