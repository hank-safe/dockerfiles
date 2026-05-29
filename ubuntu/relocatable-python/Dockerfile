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
# 用法：
#   docker build -t relocatable-python:3.11.6 \
#       --build-arg app_version=3.11.6 ubuntu/relocatable-python
#   docker run --rm -v $PWD:/out relocatable-python:3.11.6 \
#       cp /packs/python-3.11.6-installer.sh /out/
#   # 然后在任意机器上：
#   bash python-3.11.6-installer.sh -p /opt/mypython -b
# =============================================================================

FROM ubuntu:22.04 AS builder

ARG app_version=3.11.6
ENV app_version=${app_version}

ARG BUILD_THREADS=8
ENV BUILD_THREADS=${BUILD_THREADS}

# 占位前缀：固定 255 字符（和 conda 一致），后面会被 sed 替换为真实路径
# 形如 /opt/_python_placeholder_xxxxxxxx...   总长 255
ENV PLACEHOLDER_PREFIX=/opt/_python_relocatable_placeholder_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential pkg-config wget ca-certificates xz-utils zstd \
        libbz2-dev libffi-dev libgdbm-dev libgdbm-compat-dev liblzma-dev \
        libncurses5-dev libreadline-dev libsqlite3-dev libssl-dev \
        uuid-dev zlib1g-dev tk-dev \
    && rm -rf /var/lib/apt/lists/*

# -------- 下载并解压源码 ----------------------------------------------------
RUN mkdir -p /src && cd /src && \
    wget -q https://www.python.org/ftp/python/${app_version}/Python-${app_version}.tgz && \
    tar -xzf Python-${app_version}.tgz

# -------- 编译：动态库 + RPATH=$ORIGIN/../lib ------------------------------
# 校验占位前缀长度必须为 255
RUN test "$(printf %s "${PLACEHOLDER_PREFIX}" | wc -c)" = "255" \
    && echo "PLACEHOLDER_PREFIX length OK (255)"

RUN cd /src/Python-${app_version} && \
    ./configure \
        --prefix=${PLACEHOLDER_PREFIX} \
        --enable-shared \
        --enable-optimizations \
        --with-ensurepip=install \
        LDFLAGS="-Wl,-rpath,\$\$ORIGIN/../lib -Wl,--disable-new-dtags" \
    && make -j ${BUILD_THREADS} \
    && make install

# -------- 把动态依赖库一起搬进 lib/，保证完全自包含 ------------------------
# 拷贝 python 主程序及 _ssl/_hashlib 等扩展所依赖的非系统库
RUN set -eux; \
    mkdir -p ${PLACEHOLDER_PREFIX}/lib; \
    bins="${PLACEHOLDER_PREFIX}/bin/python3"; \
    bins="$bins $(find ${PLACEHOLDER_PREFIX}/lib -name '*.so*' 2>/dev/null)"; \
    for f in $bins; do \
        ldd "$f" 2>/dev/null | awk '/=>/ {print $3}' | grep -E '^/' || true; \
    done | sort -u | while read lib; do \
        case "$lib" in \
            /lib/*|/lib64/*|/usr/lib/x86_64-linux-gnu/libc.*|/usr/lib/x86_64-linux-gnu/libdl.*|\
            /usr/lib/x86_64-linux-gnu/libm.*|/usr/lib/x86_64-linux-gnu/libpthread.*|\
            /usr/lib/x86_64-linux-gnu/librt.*|/usr/lib/x86_64-linux-gnu/libutil.*|\
            /usr/lib/x86_64-linux-gnu/libresolv.*|/usr/lib/x86_64-linux-gnu/libnsl.*) \
                : ;; \
            *) \
                cp -L "$lib" ${PLACEHOLDER_PREFIX}/lib/ || true ;; \
        esac; \
    done

# -------- 写入一个 manifest，记录所有需要被前缀替换的文件 ------------------
# 文本文件（脚本/配置）用 sed 替换；ELF/二进制文件需用等长替换工具
RUN set -eux; cd ${PLACEHOLDER_PREFIX}; \
    find . -type f \( -name '*.py' -o -name '*.cfg' -o -name '*.conf' \
        -o -name '*.txt' -o -name '*.pc' -o -name '*.sh' \) > /tmp/text-files.lst; \
    # 所有可能含路径的二进制（python 主程序、.so、pyc 暂不处理由 python 自己重建）
    find . -type f \( -perm -u+x -o -name '*.so' -o -name '*.so.*' \) > /tmp/bin-files.lst; \
    # 还需要扫描带 shebang 的脚本（bin/ 下大多是）
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
