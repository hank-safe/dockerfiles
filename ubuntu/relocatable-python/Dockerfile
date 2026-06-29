# =============================================================================
# 仿 Miniconda 风格的 Python 自解压安装包构建
#
# 原理：
#   1) 用一个超长的"占位前缀"(PLACEHOLDER_PREFIX) 作为 --prefix 编译 Python
#      占位前缀长度固定为 255，保证用户实际安装路径一定不超过它
#   2) 动态链接 + RPATH=$ORIGIN/../lib，把依赖的 .so 全部塞进 lib/
#      这样目录整体可重定位
#   3) 把成品打成 tar.zst，拼接到 installer-head.sh 后面，生成单文件 .sh
#   4) 安装时脚本自解压 + 遍历所有文本/二进制把占位前缀替换为用户真实路径
#
# 为什么用 manylinux2014：
#   - 基于 CentOS 7，glibc 2.17，覆盖几乎所有还在用的 Linux
#     （RHEL/CentOS 7+、Ubuntu 16.04+、Debian 9+）
#   - CentOS 7 官方源已 EOL，quay.io/pypa/manylinux2014_x86_64 由 PyPA 维护，
#     yum 源指向 vault.centos.org，内置 devtoolset-10 (gcc 10) 及常用 -devel
#   - glibc 只能向后兼容：用老 glibc 编出来的可以跑在新系统上，反之不行
#
# 用法：
#   docker build -t relocatable-python:3.11.6 \
#       --build-arg app_version=3.11.6 ubuntu/relocatable-python
#   docker run --rm -v $PWD:/out relocatable-python:3.11.6 \
#       cp /packs/python-3.11.6-installer.sh /out/
#   # 然后在任意 glibc >= 2.17 的机器上：
#   bash python-3.11.6-installer.sh -p /opt/mypython -b
# =============================================================================

FROM quay.io/pypa/manylinux2014_x86_64 AS builder

ARG app_version=3.11.6
ENV app_version=${app_version}

ARG BUILD_THREADS=8
ENV BUILD_THREADS=${BUILD_THREADS}

# 占位前缀总长度（和 conda 一致默认 255）。可以通过 --build-arg 调整。
ARG PLACEHOLDER_LEN=255
ENV PLACEHOLDER_LEN=${PLACEHOLDER_LEN}
# 占位前缀的"基础部分"，剩余长度由构建脚本用 'a' 自动填充，避免手数字符出错
ENV PLACEHOLDER_BASE=/opt/_python_relocatable_placeholder_

# manylinux2014 已内置 devtoolset-10、autoconf、make、wget、各种 -devel
# 这里补充几个 yum 包；openssl 1.1.1 镜像里已经在 /usr/local 编译好了
RUN yum install -y \
        bzip2-devel libffi-devel xz-devel ncurses-devel readline-devel \
        sqlite-devel libuuid-devel zlib-devel gdbm-devel \
        wget zstd which file findutils \
    && yum clean all

# 启用 devtoolset-10（gcc 10），后续 RUN 都用它
SHELL ["/bin/bash", "-lc"]
ENV BASH_ENV=/opt/rh/devtoolset-10/enable
# manylinux 自带的较新 openssl 在 /usr/local，确保能被链接到
ENV PKG_CONFIG_PATH=/usr/local/lib64/pkgconfig:/usr/local/lib/pkgconfig:/usr/lib64/pkgconfig
ENV LD_LIBRARY_PATH=/usr/local/openssl/lib:/usr/local/lib64:/usr/local/lib

# -------- 下载并解压源码 ----------------------------------------------------
RUN mkdir -p /src && cd /src && \
    wget -q https://www.python.org/ftp/python/${app_version}/Python-${app_version}.tgz && \
    tar -xzf Python-${app_version}.tgz

# -------- 生成占位前缀（基础串 + 'a' 填充到 PLACEHOLDER_LEN）---------------
# 把最终前缀写入 /PLACEHOLDER_PREFIX，后续每个 RUN 都通过 $(cat ...) 读取
RUN set -eux; \
    base_len=$(printf %s "${PLACEHOLDER_BASE}" | wc -c); \
    if [ "$base_len" -ge "${PLACEHOLDER_LEN}" ]; then \
        echo "ERROR: PLACEHOLDER_BASE already >= PLACEHOLDER_LEN"; exit 1; \
    fi; \
    pad_len=$((PLACEHOLDER_LEN - base_len)); \
    pad=$(printf 'a%.0s' $(seq 1 $pad_len)); \
    printf '%s%s' "${PLACEHOLDER_BASE}" "$pad" > /PLACEHOLDER_PREFIX; \
    actual=$(wc -c < /PLACEHOLDER_PREFIX); \
    test "$actual" = "${PLACEHOLDER_LEN}"; \
    echo "PLACEHOLDER_PREFIX length OK (${actual}): $(cat /PLACEHOLDER_PREFIX)"

ARG openssl_version=1.1.1w
ENV openssl_version=${openssl_version}

# manylinux2014 只有 OpenSSL .so，没有头文件，无法编译 _ssl；需要自行从源码编译
# install_sw 只装库和头文件，跳过文档，速度快
RUN cd /src && \
    wget -q https://www.openssl.org/source/openssl-${openssl_version}.tar.gz && \
    tar -xzf openssl-${openssl_version}.tar.gz && \
    cd openssl-${openssl_version} && \
    ./config --prefix=/usr/local/openssl --openssldir=/usr/local/openssl \
             shared zlib no-tests && \
    make -j ${BUILD_THREADS} && \
    make install_sw && \
    echo "/usr/local/openssl" > /OPENSSL_DIR && \
    echo "OpenSSL $(cat /OPENSSL_DIR) OK"

# -------- 编译：动态库，先不设 RPATH（configure/make 会破坏 $ORIGIN 转义）-------
RUN PLACEHOLDER_PREFIX=$(cat /PLACEHOLDER_PREFIX) && \
    OPENSSL_DIR=$(cat /OPENSSL_DIR) && \
    cd /src/Python-${app_version} && \
    ./configure \
        --prefix=${PLACEHOLDER_PREFIX} \
        --enable-shared \
        --enable-optimizations \
        --with-ensurepip=install \
        --with-openssl=${OPENSSL_DIR} \
        --with-openssl-rpath=${OPENSSL_DIR}/lib \
    && make -j ${BUILD_THREADS} \
    && make install

# -------- 验证关键 C 扩展均已编译（此时 LD_LIBRARY_PATH 还在，可正常 import）---
# 先检查 .so 文件是否存在，再验证能否 import（更早报错，信息更清晰）
RUN PLACEHOLDER_PREFIX=$(cat /PLACEHOLDER_PREFIX) && \
    py_ver=$(ls ${PLACEHOLDER_PREFIX}/lib/ | grep '^python3' | head -1) && \
    dynload="${PLACEHOLDER_PREFIX}/lib/${py_ver}/lib-dynload" && \
    echo "Checking lib-dynload: $dynload" && \
    ls "$dynload"/_ssl*.so  || { echo "ERROR: _ssl.so not compiled. Check configure --with-openssl path"; exit 1; } && \
    ls "$dynload"/_hashlib*.so || { echo "ERROR: _hashlib.so not compiled"; exit 1; } && \
    LD_LIBRARY_PATH="${PLACEHOLDER_PREFIX}/lib:${LD_LIBRARY_PATH}" \
    ${PLACEHOLDER_PREFIX}/bin/python3 -c \
        'import _ssl, _hashlib, _sqlite3, zlib; print("C extensions OK")'

# -------- 把动态依赖库一起搬进 lib/，保证完全自包含 ------------------------
# 注意：必须在 patchelf 之前运行！此时 _ssl.so 等扩展还保留编译期 RPATH，
# ldd 能通过 LD_LIBRARY_PATH 找到 /usr/local/lib64/libssl.so.1.1 等依赖。
# patchelf 之后 RPATH 变成 $ORIGIN/...，ldd 对 .so 文件解析 $ORIGIN 不可靠，
# 会漏掉 libssl/libcrypto 等依赖。
# glibc 系列（libc/libdl/libm/libpthread/libnsl/libresolv/libutil/librt
# 以及 ld-linux*）严禁打包——必须用目标机器自己的 glibc，否则 NSS/locale 全崩
RUN set -eux; \
    PLACEHOLDER_PREFIX=$(cat /PLACEHOLDER_PREFIX); \
    mkdir -p ${PLACEHOLDER_PREFIX}/lib; \
    bins="${PLACEHOLDER_PREFIX}/bin/python3"; \
    bins="$bins $(find ${PLACEHOLDER_PREFIX}/lib -name '*.so*' 2>/dev/null)"; \
    for f in $bins; do \
        LD_LIBRARY_PATH="${PLACEHOLDER_PREFIX}/lib:${LD_LIBRARY_PATH:-}" \
        ldd "$f" 2>/dev/null | awk '/=>/ {print $3}' | grep -E '^/' || true; \
    done | sort -u | while read lib; do \
        base=$(basename "$lib"); \
        case "$lib" in \
            ${PLACEHOLDER_PREFIX}/*) continue ;; \
        esac; \
        case "$base" in \
            libc.so.*|libdl.so.*|libm.so.*|libpthread.so.*|librt.so.*|\
            libutil.so.*|libresolv.so.*|libnsl.so.*|libcrypt.so.*|\
            ld-linux*.so.*|libgcc_s.so.*|libstdc++.so.*) \
                : ;; \
            *) \
                cp -L "$lib" ${PLACEHOLDER_PREFIX}/lib/ || true ;; \
        esac; \
    done

# -------- 用 patchelf 直接写入 RPATH，彻底绕过 configure/make 的 shell 展开 ----
# 根据文件相对 PREFIX 的深度计算 ../，确保所有层级的 ELF 都能找到 lib/
# 例：bin/python3 (depth=1) -> $ORIGIN/../lib
#     lib/python3.11/lib-dynload/_ssl.so (depth=3) -> $ORIGIN/../../../lib
RUN set -eux; \
    PLACEHOLDER_PREFIX=$(cat /PLACEHOLDER_PREFIX); \
    find ${PLACEHOLDER_PREFIX}/bin ${PLACEHOLDER_PREFIX}/lib \
        -type f ! -type l | while read f; do \
        file "$f" | grep -q ELF || continue; \
        rel_dir=$(dirname "${f#${PLACEHOLDER_PREFIX}/}"); \
        depth=$(echo "$rel_dir" | tr '/' '\n' | grep -c .); \
        ups=$(printf '../%.0s' $(seq 1 "$depth")); \
        rpath="\$ORIGIN/${ups}lib"; \
        patchelf --set-rpath "$rpath" "$f" 2>/dev/null || true; \
    done; \
    echo "patchelf done"

# -------- Sanity check：RPATH + import 验证（依赖已拷贝完，才能真正自包含测试）--
RUN set -eux; \
    PLACEHOLDER_PREFIX=$(cat /PLACEHOLDER_PREFIX); \
    echo "=== patchelf --print-rpath python3 ==="; \
    patchelf --print-rpath ${PLACEHOLDER_PREFIX}/bin/python3; \
    patchelf --print-rpath ${PLACEHOLDER_PREFIX}/bin/python3 \
        | grep -q 'ORIGIN/\.\./lib' \
        || { echo "ERROR: RPATH not set correctly"; exit 1; }; \
    echo "RPATH OK"; \
    # 清空 LD_LIBRARY_PATH，强制只靠 RPATH 和 lib/ 下的 .so 运行
    env -u LD_LIBRARY_PATH ${PLACEHOLDER_PREFIX}/bin/python3 \
        -c 'import sys, ssl, sqlite3, zlib; print("sanity OK:", sys.version.split()[0])'

# -------- 记录最低 glibc 要求（manylinux2014 通常 = 2.17） -----------------
RUN PLACEHOLDER_PREFIX=$(cat /PLACEHOLDER_PREFIX) && \
    min_glibc=$(objdump -T ${PLACEHOLDER_PREFIX}/bin/python3 \
        ${PLACEHOLDER_PREFIX}/lib/*.so* 2>/dev/null \
        | awk '/GLIBC_/ {gsub(/[()]/,"",$5); print $5}' \
        | sed 's/GLIBC_//' | sort -uV | tail -n1) ; \
    echo "$min_glibc" > ${PLACEHOLDER_PREFIX}/MIN_GLIBC.txt ; \
    echo "Built against max glibc symbol = $min_glibc"

# -------- 写入 manifest，记录需要前缀替换的文件 ----------------------------
RUN set -eux; \
    PLACEHOLDER_PREFIX=$(cat /PLACEHOLDER_PREFIX); \
    cd ${PLACEHOLDER_PREFIX}; \
    find . -type f \( -name '*.py' -o -name '*.cfg' -o -name '*.conf' \
        -o -name '*.txt' -o -name '*.pc' -o -name '*.sh' \) > /tmp/text-files.lst; \
    find . -type f \( -perm -u+x -o -name '*.so' -o -name '*.so.*' \) > /tmp/bin-files.lst; \
    find ./bin -type f >> /tmp/text-files.lst; \
    sort -u /tmp/text-files.lst -o /tmp/text-files.lst; \
    sort -u /tmp/bin-files.lst  -o /tmp/bin-files.lst

# -------- 打包：tar.zst payload --------------------------------------------
RUN mkdir -p /packs && cd /opt && \
    PLACEHOLDER_PREFIX=$(cat /PLACEHOLDER_PREFIX) && \
    PLACEHOLDER_DIR=$(basename ${PLACEHOLDER_PREFIX}) && \
    tar --owner=0 --group=0 \
        --transform "s|^${PLACEHOLDER_DIR}|payload|" \
        -czf /packs/payload.tar.gz \
        ${PLACEHOLDER_DIR} /tmp/text-files.lst /tmp/bin-files.lst 2>/dev/null

# -------- 拼接 installer-head.sh + payload 生成自解压 sh -------------------
# 运行时通过 grep gzip 魔数 \x1f\x8b 定位 payload，无需构建时嵌入偏移
COPY installer-head.sh /packs/installer-head.sh
RUN set -eux; \
    PLACEHOLDER_PREFIX=$(cat /PLACEHOLDER_PREFIX); \
    sed -e "s|@@APP_VERSION@@|${app_version}|g" \
        -e "s|@@PLACEHOLDER_PREFIX@@|${PLACEHOLDER_PREFIX}|g" \
        /packs/installer-head.sh > /packs/_head.sh; \
    cat /packs/_head.sh /packs/payload.tar.gz > /packs/python-${app_version}-installer.sh; \
    chmod +x /packs/python-${app_version}-installer.sh; \
    ls -lh /packs/python-${app_version}-installer.sh

# =============================================================================
# 最终镜像：仅保留安装包，方便 docker cp 出来
# =============================================================================
FROM ubuntu:22.04
ARG TARGETARCH

WORKDIR /packs/${TARGETARCH}
COPY --from=builder /packs /packs/${TARGETARCH}

