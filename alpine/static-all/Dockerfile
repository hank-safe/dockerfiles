FROM crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-bind:9.16.50 AS binary-bind
FROM crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-bmon:4.0 AS binary-bmon
FROM crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-chrony:4.8 AS binary-chrony
FROM crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-curl:8.21.0 AS binary-curl
FROM crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-dos2unix:7.5.6 AS binary-dos2unix
FROM crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-fio:3.36 AS binary-fio
FROM crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-gawk:5.4.0 AS binary-gawk
FROM crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-htop:3.5.1 AS binary-htop
FROM crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-iotop:1.31 AS binary-iotop
FROM crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-jq:1.8.2 AS binary-jq
FROM crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-keepalived:2.4.1 AS binary-keepalived
FROM crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-lrzsz:0.12.20 AS binary-lrzsz
FROM crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-net-tools:2.10 AS binary-net-tools
FROM crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-netcat:0.7.1 AS binary-netcat
FROM crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-nmap:7.99 AS binary-nmap
FROM crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-rsync:3.4.4 AS binary-rsync
FROM crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-smartmontools:7.5 AS binary-smartmontools
FROM crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-tar:1.35 AS binary-tar
FROM crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-tcpdump:4.99.6 AS binary-tcpdump
FROM crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-vim:9.1.1901 AS binary-vim
FROM crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-wget:1.25.0 AS binary-wget
FROM crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/relocatable-python:3.13.13 AS binary-python

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
