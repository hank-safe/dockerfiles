FROM crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-bmon:4.0 AS binary-bmon
FROM crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-chrony:4.6 AS binary-chrony
FROM crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-curl:8.11.0 AS binary-curl
FROM crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-fio:3.36 AS binary-fio
FROM crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-gawk:5.3.2 AS binary-gawk
FROM crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-htop:3.4.1 AS binary-htop
FROM crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-iotop:1.29 AS binary-iotop
FROM crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-jq:1.8.1 AS binary-jq
FROM crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-keepalived:2.2.8 AS binary-keepalived
FROM crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-lrzsz:0.12.20 AS binary-lrzsz
FROM crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-net-tools:2.10 AS binary-net-tools
FROM crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-netcat:0.7.1 AS binary-netcat
FROM crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-nmap:7.95 AS binary-nmap
FROM crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-rsync:3.4.1 AS binary-rsync
FROM crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-tar:1.35 AS binary-tar
FROM crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-tcpdump:4.99.4 AS binary-tcpdump
FROM crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-vim:9.1.1901 AS binary-vim
FROM crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-wget:1.24.5 AS binary-wget

FROM alpine

COPY --from=binary-bmon /packs/bmon /packs/bmon
COPY --from=binary-chrony /packs/chrony /packs/chrony
COPY --from=binary-curl /packs/curl /packs/curl
COPY --from=binary-fio /packs/fio /packs/fio
COPY --from=binary-gawk /packs/gawk /packs/gawk
COPY --from=binary-htop /packs/htop /packs/htop
COPY --from=binary-jq /packs/jq /packs/jq
COPY --from=binary-keepalived /packs/keepalived /packs/keepalived
COPY --from=binary-lrzsz /packs/lrzsz /packs/lrzsz
COPY --from=binary-net-tools /packs/net-tools /packs/net-tools
COPY --from=binary-netcat /packs/netcat /packs/netcat
COPY --from=binary-nmap /packs/nmap /packs/nmap
COPY --from=binary-rsync /packs/rsync /packs/rsync
COPY --from=binary-tar /packs/tar /packs/tar
COPY --from=binary-tcpdump /packs/tcpdump /packs/tcpdump
COPY --from=binary-vim /packs/vim /packs/vim
COPY --from=binary-wget /packs/wget /packs/wget

