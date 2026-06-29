FROM alpine AS builder

ARG app_version=7.5.4

RUN apk add build-base libcap-dev texinfo nettle-dev gnutls-dev bash wget tar gcc make gettext-dev gettext-static

WORKDIR /build

RUN wget https://sourceforge.net/projects/dos2unix/files/dos2unix/${app_version}/dos2unix-${app_version}.tar.gz && \
    tar zxf dos2unix-${app_version}.tar.gz && \
    rm -f dos2unix-${app_version}.tar.gz && \
    cd dos2unix-${app_version} && \
    make LDFLAGS="-static" LIBS="-lintl" && \
    make install prefix=/packs/dos2unix && \
    strip /packs/dos2unix/bin/dos2unix && \
    chown -R $(id -u):$(id -g) /packs/dos2unix

FROM alpine

ARG TARGETARCH

WORKDIR /packs/${TARGETARCH}
COPY --from=builder /packs /packs/${TARGETARCH}


WORKDIR /packs
