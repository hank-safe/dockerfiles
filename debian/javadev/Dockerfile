# JDK8 + Maven 开发环境
# 基于 debian/openjdk/8 镜像，模仿 debian/godev 风格
ARG app_version=8u462-b08

FROM debian:12.10-slim

LABEL maintainer "Hank"
LABEL github "https://github.com/agocan"

ARG TARGETARCH
ARG https_proxy
ARG http_proxy

ARG app_version=8u462-b08
ARG maven_version=3.9.9

# 安装基础工具及 SSH 服务
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates p11-kit curl telnet less \
        libfreetype6 libx11-dev fontconfig unzip procps \
        git vim wget openssh-server sudo screen locales && \
    sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen && \
    wget -O $(ls -d /usr/share/vim/vim*)/basic.vim https://raw.githubusercontent.com/amix/vimrc/refs/heads/master/vimrcs/basic.vim && \
    sed -i 's#mouse=a#mouse-=a#g' $(ls -d /usr/share/vim/vim*)/defaults.vim && \
    rm -rf /var/lib/apt/lists/*

ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# 安装 JDK8
ENV JAVA_HOME=/usr/local/openjdk-8
ENV PATH=${JAVA_HOME}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV JAVA_VERSION=${app_version}

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
    apt-get install -y --no-install-recommends dirmngr gnupg; \
    rm -rf /var/lib/apt/lists/*; \
    echo $downloadUrl; \
    wget --progress=dot:giga -O openjdk.tgz "$downloadUrl"; \
    wget --progress=dot:giga -O openjdk.tgz.asc "$downloadUrl.sig"; \
    export GNUPGHOME="$(mktemp -d)"; \
    gpg --batch --keyserver keyserver.ubuntu.com --recv-keys EAC843EBD3EFDB98CC772FADA5CD6035332FA671; \
    gpg --batch --keyserver keyserver.ubuntu.com --keyserver-options no-self-sigs-only --recv-keys CA5F11C6CE22644D42C6AC4492EF8D39DC13168F; \
    gpg --batch --list-sigs --keyid-format 0xLONG CA5F11C6CE22644D42C6AC4492EF8D39DC13168F | tee /dev/stderr | grep '0xA5CD6035332FA671' | grep 'Andrew Haley'; \
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
    java -version

# 安装 Maven
ENV MAVEN_HOME=/usr/local/maven
ENV MAVEN_VERSION=${maven_version}
ENV PATH=${MAVEN_HOME}/bin:${PATH}

RUN wget --progress=dot:giga -O maven.tar.gz "https://archive.apache.org/dist/maven/maven-3/${maven_version}/binaries/apache-maven-${maven_version}-bin.tar.gz" && \
    mkdir -p "$MAVEN_HOME" && \
    tar --extract --file maven.tar.gz --directory "$MAVEN_HOME" --strip-components 1 --no-same-owner && \
    rm maven.tar.gz && \
    mvn -version

# 配置 Maven 本地仓库目录
RUN mkdir -p /root/.m2/repository

# 创建普通用户
RUN addgroup --gid 1008 normaluser && \
    adduser --system --disabled-password --home /home/normaluser -u 1008 --ingroup normaluser normaluser --shell /bin/bash && \
    echo normaluser ALL=\(ALL\) NOPASSWD:ALL >> /etc/sudoers && \
    mkdir -p /home/normaluser/.m2/repository && \
    chown -R normaluser:normaluser /home/normaluser && \
    echo "alias ls='ls --color=auto'" >> /home/normaluser/.bashrc

WORKDIR /home/normaluser

# 配置 SSH
RUN echo "Port 2222" >> /etc/ssh/sshd_config && \
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    echo "ChallengeResponseAuthentication no" >> /etc/ssh/sshd_config

RUN echo 'normaluser:123456' | chpasswd && \
    echo 'root:123456' | chpasswd

RUN sed -i '43asession        required      pam_env.so envfile=/etc/environment' /etc/pam.d/sshd

# 配置 Java/Maven 环境变量，SSH 登录时也可用
RUN echo "export JAVA_HOME=${JAVA_HOME}" > /etc/profile.d/java.sh && \
    echo "export MAVEN_HOME=${MAVEN_HOME}" >> /etc/profile.d/java.sh && \
    echo 'export PATH=${JAVA_HOME}/bin:${MAVEN_HOME}/bin:$PATH' >> /etc/profile.d/java.sh && \
    echo "alias ls='ls --color=auto'" >> /etc/profile.d/alias.sh && \
    echo "LANG=en_US.UTF-8" >> /etc/profile.d/locale.sh && \
    echo "LC_ALL=en_US.UTF-8" >> /etc/profile.d/locale.sh

# 复制启动脚本
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

COPY ssh /home/normaluser/.ssh
COPY ssh /root/.ssh
RUN chown -R normaluser:normaluser /home/normaluser/.ssh && \
    chown -R root:root /root/.ssh && \
    chmod 700 /home/normaluser/.ssh && \
    chmod 600 /home/normaluser/.ssh/* && \
    chmod 644 /home/normaluser/.ssh/id_rsa.pub && \
    chmod 700 /root/.ssh && \
    chmod 600 /root/.ssh/* && \
    chmod 644 /root/.ssh/id_rsa.pub

EXPOSE 2222

CMD ["/usr/local/bin/start.sh"]
