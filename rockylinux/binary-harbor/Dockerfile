ARG app_version=2.12.2

FROM --platform=linux/arm64 hank997/harbor-arm:${app_version}-arm64 AS harbor-arm
FROM rockylinux/rockylinux:10.0

# 3.13.1
WORKDIR /packs

RUN yum install wget epel-release ca-certificates -y

ARG app_version=2.12.2

RUN wget -O harbor-amd64.tgz https://github.com/goharbor/harbor/releases/download/v${app_version}/harbor-offline-installer-v${app_version}.tgz
COPY --from=harbor-arm /harbor-offline-installer-${app_version}.tgz /packs/harbor-arm64.tgz
