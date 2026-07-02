# 基于 ubuntu/relocatable-python 的构建产物，生成对应 Python/架构的
# Ansible 离线依赖包。relocatable-python 镜像本身不会进入最终产物。
#
# 先构建上游镜像：
#   docker build \
#     -t relocatable-python:3.11.6 \
#     --build-arg app_version=3.11.6 \
#     ubuntu/relocatable-python
#
# 再构建本镜像：
#   docker build \
#     -t relocatable-python-with-ansible:3.11.6 \
#     --build-arg app_version=3.11.6 \
#     ubuntu/relocatable-python-with-ansible

ARG app_version=3.13.13
ARG RELOCATABLE_PYTHON_IMAGE=crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/relocatable-python:${app_version}

FROM ${RELOCATABLE_PYTHON_IMAGE} AS builder

ARG app_version
ARG TARGETARCH
ARG ansible_package=ansible-base
ARG ansible_version=2.10.11
ARG pip_index_url=https://mirrors.ustc.edu.cn/pypi/simple

# 安装器来自 ubuntu/relocatable-python 的 /packs/${TARGETARCH}。
# 用这套 Python 执行 pip，可以让 pip 按它的 Python 版本、ABI 和架构选择依赖。
RUN set -eux; \
    installer="/packs/${TARGETARCH}/python-${app_version}-installer.sh"; \
    test -f "${installer}"; \
    bash "${installer}" -p /opt/relocatable-python -b; \
    output="/packs/${TARGETARCH}/ansible-base"; \
    mkdir -p "${output}"; \
    /opt/relocatable-python/bin/python3 -m pip download \
        --dest "${output}" \
        --index-url "${pip_index_url}" \
        "${ansible_package}==${ansible_version}"; \
    cd "/packs/${TARGETARCH}"; \
    tar -czf ansible-base.tar.gz ansible-base; \
    rm -rf ansible-base /opt/relocatable-python

FROM ubuntu:22.04

WORKDIR /packs
COPY --from=builder /packs/ /packs/
