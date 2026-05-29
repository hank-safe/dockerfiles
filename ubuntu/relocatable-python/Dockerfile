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
ENV LD_LIBRARY_PATH=/usr/local/lib64:/usr/local/lib

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

# -------- 编译：动态库 + RPATH=$ORIGIN/../lib ------------------------------
RUN PLACEHOLDER_PREFIX=$(cat /PLACEHOLDER_PREFIX) && \
    cd /src/Python-${app_version} && \
    ./configure \
        --prefix=${PLACEHOLDER_PREFIX} \
        --enable-shared \
        --enable-optimizations \
        --with-ensurepip=install \
        LDFLAGS="-Wl,-rpath,\$\$ORIGIN/../lib -Wl,--disable-new-dtags" \
    && make -j ${BUILD_THREADS} \
    && make install

# -------- 把动态依赖库一起搬进 lib/，保证完全自包含 ------------------------
# 注意：glibc 系列（libc/libdl/libm/libpthread/libnsl/libresolv/libutil/librt
# 以及 ld-linux*）严禁打包——必须用目标机器自己的 glibc，否则 NSS/locale 全崩
RUN set -eux; \
    mkdir -p ${PLACEHOLDER_PREFIX}/lib; \
    bins="${PLACEHOLDER_PREFIX}/bin/python3"; \
    bins="$bins $(find ${PLACEHOLDER_PREFIX}/lib -name '*.so*' 2>/dev/null)"; \
    for f in $bins; do \
        ldd "$f" 2>/dev/null | awk '/=>/ {print $3}' | grep -E '^/' || true; \
    done | sort -u | while read lib; do \
        base=$(basename "$lib"); \
        case "$base" in \
            libc.so.*|libdl.so.*|libm.so.*|libpthread.so.*|librt.so.*|\
            libutil.so.*|libresolv.so.*|libnsl.so.*|libcrypt.so.*|\
            ld-linux*.so.*|libgcc_s.so.*|libstdc++.so.*) \
                : ;; \
            *) \
                cp -L "$lib" ${PLACEHOLDER_PREFIX}/lib/ || true ;; \
        esac; \
    done

# -------- 记录最低 glibc 要求（manylinux2014 通常 = 2.17） -----------------
RUN min_glibc=$(objdump -T ${PLACEHOLDER_PREFIX}/bin/python3 \
        ${PLACEHOLDER_PREFIX}/lib/*.so* 2>/dev/null \
        | awk '/GLIBC_/ {gsub(/[()]/,"",$5); print $5}' \
        | sed 's/GLIBC_//' | sort -uV | tail -n1) ; \
    echo "$min_glibc" > ${PLACEHOLDER_PREFIX}/MIN_GLIBC.txt ; \
    echo "Built against max glibc symbol = $min_glibc"

# -------- 写入 manifest，记录需要前缀替换的文件 ----------------------------
RUN set -eux; cd ${PLACEHOLDER_PREFIX}; \
    find . -type f \( -name '*.py' -o -name '*.cfg' -o -name '*.conf' \
        -o -name '*.txt' -o -name '*.pc' -o -name '*.sh' \) > /tmp/text-files.lst; \
    find . -type f \( -perm -u+x -o -name '*.so' -o -name '*.so.*' \) > /tmp/bin-files.lst; \
    find ./bin -type f >> /tmp/text-files.lst; \
    sort -u /tmp/text-files.lst -o /tmp/text-files.lst; \
    sort -u /tmp/bin-files.lst  -o /tmp/bin-files.lst

# -------- 打包：tar.zst payload --------------------------------------------
RUN mkdir -p /packs && cd /opt && \
    PLACEHOLDER_DIR=$(basename ${PLACEHOLDER_PREFIX}) && \
    tar --owner=0 --group=0 \
        --transform "s|^${PLACEHOLDER_DIR}|payload|" \
        -cf - ${PLACEHOLDER_DIR} /tmp/text-files.lst /tmp/bin-files.lst 2>/dev/null \
        | zstd -19 -T0 -o /packs/payload.tar.zst

# -------- 拼接 installer-head.sh + payload 生成自解压 sh -------------------
COPY installer-head.sh /packs/installer-head.sh
RUN set -eux; \
    sed -e "s|@@APP_VERSION@@|${app_version}|g" \
        -e "s|@@PLACEHOLDER_PREFIX@@|${PLACEHOLDER_PREFIX}|g" \
        /packs/installer-head.sh > /packs/_head.sh; \
    cat /packs/_head.sh /packs/payload.tar.zst > /packs/python-${app_version}-installer.sh; \
    chmod +x /packs/python-${app_version}-installer.sh; \
    ls -lh /packs/python-${app_version}-installer.sh

# =============================================================================
# 最终镜像：仅保留安装包，方便 docker cp 出来
# =============================================================================
FROM ubuntu:22.04

COPY --from=builder /packs/python-*-installer.sh /packs/
WORKDIR /packs
CMD ["bash", "-c", "ls -lh /packs && echo 'cp /packs/*.sh to your host'"]
