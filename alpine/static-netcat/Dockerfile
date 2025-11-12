FROM alpine AS builder

ARG app_version=0.7.1

RUN apk add gcc g++ make automake autoconf  libtool linux-headers

WORKDIR /packs

RUN wget https://zenlayer.dl.sourceforge.net/project/netcat/netcat/${app_version}/netcat-${app_version}.tar.gz && \
    tar xf netcat-${app_version}.tar.gz  && \
    cd netcat-${app_version} && \
    CFLAGS=-static ./configure --prefix=/packs/netcat && \
    make -j && make install 


FROM alpine

COPY --from=builder /packs /packs

WORKDIR /packs

