#FROM --platform=linux/amd64 ccr.ccs.tencentyun.com/hank997/binary:nmap AS nmap-packs
FROM ccr.ccs.tencentyun.com/hank997/debian:12.10-slim
# 旧版本
# https://github.com/AdoptOpenJDK/openjdk8-binaries
# https://github.com/AdoptOpenJDK/openjdk8-upstream-binaries

# 最新版本
# https://github.com/adoptium/temurin8-binaries/releases

LABEL maintainer "Hank"
LABEL github "https://github.com/agocan"

ARG TARGETARCH
ARG https_proxy
ARG http_proxy

ARG app_version=8u462-b08

# RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list   # 10 之前改这里
RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/debian.sources  && \
    apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates p11-kit curl telnet less libfreetype6 libx11-dev fontconfig unzip procps && \
    rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME=/usr/local/openjdk-8

RUN { \
    echo '#!/bin/sh'; \
    echo 'echo "$JAVA_HOME"'; \
    } > /usr/local/bin/docker-java-home && \
    chmod +x /usr/local/bin/docker-java-home && \
    [ "$JAVA_HOME" = "$(docker-java-home)" ]

ENV PATH=/usr/local/openjdk-8/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV LANG=C.UTF-8
ENV JAVA_VERSION=${openjdk_version}

RUN set -eux; \
    arch="$(dpkg --print-architecture)"; \
    case "$arch" in \
        'amd64') downloadUrl="https://github.com/adoptium/temurin8-binaries/releases/download/jdk${app_version}/OpenJDK8U-jdk_x64_linux_hotspot_$(echo ${app_version} | sed 's#-##g').tar.gz"; \
        ;; \
        'arm64') downloadUrl="https://github.com/adoptium/temurin8-binaries/releases/download/jdk${app_version}/OpenJDK8U-jdk_aarch64_linux_hotspot_$(echo ${app_version} | sed 's#-##g').tar.gz"; \
        ;; \
        *) echo >&2 "error: unsupported architecture: '$arch'"; exit 1; \
        ;; \
    esac; \
    savedAptMark="$(apt-mark showmanual)"; \
    apt-get update; \
    apt-get install -y --no-install-recommends dirmngr gnupg wget; \
    rm -rf /var/lib/apt/lists/*; \
    wget --progress=dot:giga -O openjdk.tgz "$downloadUrl"; \
    wget --progress=dot:giga -O openjdk.tgz.asc "$downloadUrl.sig"; \
    export GNUPGHOME="$(mktemp -d)"; \
    gpg --batch --keyserver keyserver.ubuntu.com --recv-keys EAC843EBD3EFDB98CC772FADA5CD6035332FA671; \
    gpg --batch --keyserver keyserver.ubuntu.com --keyserver-options no-self-sigs-only --recv-keys CA5F11C6CE22644D42C6AC4492EF8D39DC13168F; \
    gpg --batch --list-sigs --keyid-format 0xLONG CA5F11C6CE22644D42C6AC4492EF8D39DC13168F | tee /dev/stderr | grep '0xA5CD6035332FA671' | grep 'Andrew Haley'; \
#    gpg --batch --verify openjdk.tgz.asc openjdk.tgz; \
    gpgconf --kill all; \
    rm -rf "$GNUPGHOME"; \
    mkdir -p "$JAVA_HOME"; \
    tar --extract --file openjdk.tgz --directory "$JAVA_HOME" --strip-components 1 --no-same-owner; \
    rm openjdk.tgz*; \
    apt-mark auto '.*' > /dev/null; \
    [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark > /dev/null; \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
    { echo '#!/usr/bin/env bash'; \
    echo 'set -Eeuo pipefail'; \
    echo 'trust extract --overwrite --format=java-cacerts --filter=ca-anchors --purpose=server-auth "$JAVA_HOME/jre/lib/security/cacerts"'; \
    } > /etc/ca-certificates/update.d/docker-openjdk; \
    chmod +x /etc/ca-certificates/update.d/docker-openjdk; \
    /etc/ca-certificates/update.d/docker-openjdk; \
    find "$JAVA_HOME/lib" -name '*.so' -exec dirname '{}' ';' | sort -u > /etc/ld.so.conf.d/docker-openjdk.conf; \
    ldconfig; \
    javac -version; \
    java -version
COPY lib /usr/local/openjdk-8/lib/
COPY jre/lib /usr/local/openjdk-8/jre/lib/
COPY jre/ext /usr/local/openjdk-8/jre/lib/ext/
COPY arthas /usr/local/openjdk-8/arthas
COPY bin/arthas_boot /usr/local/openjdk-8/bin/arthas_boot
RUN chmod +x /usr/local/openjdk-8/bin/arthas_boot

#COPY --from=nmap-packs /packs/${TARGETARCH} /usr/local/bin


# 这样的方式不友好
# FROM ccr.ccs.tencentyun.com/hank997/packages:ipdb AS ipdb_builder
# RUN mkdir -p /sdyunlei/apps/tomcat8/ipdb/
# COPY --from=ipdb_builder  /ipdb/IP_city_single_WGS84.awdb /sdyunlei/apps/tomcat8/ipdb/
