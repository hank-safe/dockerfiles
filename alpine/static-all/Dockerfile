ARG REPO=crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997
ARG STATIC_BIND_VERSION=9.16.50
ARG STATIC_BMON_VERSION=4.0
ARG STATIC_CHRONY_VERSION=4.8
ARG STATIC_CURL_VERSION=8.21.0
ARG STATIC_DOS2UNIX_VERSION=7.5.6
ARG STATIC_FIO_VERSION=3.36
ARG STATIC_GAWK_VERSION=5.4.0
ARG STATIC_HTOP_VERSION=3.5.1
ARG STATIC_IOTOP_VERSION=1.31
ARG STATIC_JQ_VERSION=1.8.2
ARG STATIC_KEEPALIVED_VERSION=2.4.1
ARG STATIC_LRZSZ_VERSION=0.12.20
ARG STATIC_NET_TOOLS_VERSION=2.10
ARG STATIC_NETCAT_VERSION=0.7.1
ARG STATIC_NMAP_VERSION=7.99
ARG STATIC_RSYNC_VERSION=3.4.4
ARG STATIC_SMARTMONTOOLS_VERSION=7.5
ARG STATIC_TAR_VERSION=1.35
ARG STATIC_TCPDUMP_VERSION=4.99.6
ARG STATIC_VIM_VERSION=9.1.1901
ARG STATIC_WGET_VERSION=1.25.0
ARG RELOCATABLE_PYTHON_VERSION=3.13.13

FROM ${REPO}/static-bind:${STATIC_BIND_VERSION} AS binary-bind
FROM ${REPO}/static-bmon:${STATIC_BMON_VERSION} AS binary-bmon
FROM ${REPO}/static-chrony:${STATIC_CHRONY_VERSION} AS binary-chrony
FROM ${REPO}/static-curl:${STATIC_CURL_VERSION} AS binary-curl
FROM ${REPO}/static-dos2unix:${STATIC_DOS2UNIX_VERSION} AS binary-dos2unix
FROM ${REPO}/static-fio:${STATIC_FIO_VERSION} AS binary-fio
FROM ${REPO}/static-gawk:${STATIC_GAWK_VERSION} AS binary-gawk
FROM ${REPO}/static-htop:${STATIC_HTOP_VERSION} AS binary-htop
FROM ${REPO}/static-iotop:${STATIC_IOTOP_VERSION} AS binary-iotop
FROM ${REPO}/static-jq:${STATIC_JQ_VERSION} AS binary-jq
FROM ${REPO}/static-keepalived:${STATIC_KEEPALIVED_VERSION} AS binary-keepalived
FROM ${REPO}/static-lrzsz:${STATIC_LRZSZ_VERSION} AS binary-lrzsz
FROM ${REPO}/static-net-tools:${STATIC_NET_TOOLS_VERSION} AS binary-net-tools
FROM ${REPO}/static-netcat:${STATIC_NETCAT_VERSION} AS binary-netcat
FROM ${REPO}/static-nmap:${STATIC_NMAP_VERSION} AS binary-nmap
FROM ${REPO}/static-rsync:${STATIC_RSYNC_VERSION} AS binary-rsync
FROM ${REPO}/static-smartmontools:${STATIC_SMARTMONTOOLS_VERSION} AS binary-smartmontools
FROM ${REPO}/static-tar:${STATIC_TAR_VERSION} AS binary-tar
FROM ${REPO}/static-tcpdump:${STATIC_TCPDUMP_VERSION} AS binary-tcpdump
FROM ${REPO}/static-vim:${STATIC_VIM_VERSION} AS binary-vim
FROM ${REPO}/static-wget:${STATIC_WGET_VERSION} AS binary-wget
FROM ${REPO}/relocatable-python:${RELOCATABLE_PYTHON_VERSION} AS binary-python

FROM alpine AS aggregator

ARG TARGETARCH

WORKDIR /packs/${TARGETARCH}

COPY --from=binary-bind /packs/${TARGETARCH}/bind ./bind
COPY --from=binary-bmon /packs/${TARGETARCH}/bmon ./bmon
COPY --from=binary-chrony /packs/${TARGETARCH}/chrony ./chrony
COPY --from=binary-curl /packs/${TARGETARCH}/curl ./curl
COPY --from=binary-dos2unix /packs/${TARGETARCH}/dos2unix ./dos2unix
COPY --from=binary-fio /packs/${TARGETARCH}/fio ./fio
COPY --from=binary-gawk /packs/${TARGETARCH}/gawk ./gawk
COPY --from=binary-htop /packs/${TARGETARCH}/htop ./htop
COPY --from=binary-iotop /packs/${TARGETARCH}/iotop ./iotop
COPY --from=binary-jq /packs/${TARGETARCH}/jq ./jq
COPY --from=binary-keepalived /packs/${TARGETARCH}/keepalived ./keepalived
COPY --from=binary-lrzsz /packs/${TARGETARCH}/lrzsz ./lrzsz
COPY --from=binary-net-tools /packs/${TARGETARCH}/net-tools ./net-tools
COPY --from=binary-netcat /packs/${TARGETARCH}/netcat ./netcat
COPY --from=binary-nmap /packs/${TARGETARCH}/nmap ./nmap
COPY --from=binary-rsync /packs/${TARGETARCH}/rsync ./rsync
COPY --from=binary-smartmontools /packs/${TARGETARCH}/smartmontools ./smartmontools
COPY --from=binary-tar /packs/${TARGETARCH}/tar ./tar
COPY --from=binary-tcpdump /packs/${TARGETARCH}/tcpdump ./tcpdump
COPY --from=binary-vim /packs/${TARGETARCH}/vim ./vim
COPY --from=binary-wget /packs/${TARGETARCH}/wget ./wget
COPY --from=binary-python /packs/${TARGETARCH} /tmp/python

RUN mkdir -p ./python && \
    cp -a /tmp/python/. ./python/

FROM alpine

COPY --from=aggregator /packs /packs
