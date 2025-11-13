FROM --platform=linux/amd64 crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-bmon:4.0 AS x86_64-bmon
FROM --platform=linux/arm64 crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-bmon:4.0 AS aarch64-bmon

FROM alpine

COPY --from=x86_64-bmon /packs/bmon /packs/x86_64/bmon
COPY --from=aarch64-bmon /packs/bmon /packs/aarch64/bmon
