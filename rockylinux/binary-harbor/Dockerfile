ARG app_version=2.12.2

FROM --platform=linux/arm64 hank997/harbor-arm:${app_version} AS harbor-arm
FROM rockylinux/rockylinux:10.0

# 3.13.1
WORKDIR /packs

RUN yum install wget epel-release ca-certificates -y

ARG app_version=2.12.2

RUN mkdir -p /packs/amd64/harbor /packs/arm64/harbor

RUN wget -O /packs/amd64/harbor/harbor-offline-installer.tgz https://github.com/goharbor/harbor/releases/download/v${app_version}/harbor-offline-installer-v${app_version}.tgz
COPY --from=harbor-arm /harbor-offline-installer-${app_version}.tgz /packs/arm64/harbor/harbor-offline-installer.tgz
