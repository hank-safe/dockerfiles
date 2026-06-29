---
name: packs-arch-layout
description: 当创建或重构 dockerfiles/ 下会向 /packs 输出产物的 Dockerfile 时使用这个 skill，尤其适用于统一多架构产物目录布局，并为后续产品聚合提供一致的复制方式。该 skill 定义了标准的 /packs/<arch>/<product> 结构、架构命名规则、复制模式和迁移检查项。
---

# Packs 架构目录规范

当 Dockerfile 会把二进制、压缩包、安装器或目录输出到 `/packs` 时，使用这个 skill。

## 标准目录结构

统一使用：

```text
/packs/<arch>/<product>
```

示例：

```text
/packs/amd64/bind
/packs/amd64/curl
/packs/arm64/bind
/packs/arm64/curl
```

不要再新增下面这些结构：

```text
/packs/<product>
/packs/<product>-<arch>
/packs/<product>/<arch>
/packs/x86_64
/packs/aarch64
```

## 命名规则

- `/packs` 下的架构目录只能使用 `amd64` 和 `arm64`。
- 如果上游使用的是 `x86_64`、`aarch64`、`linux-amd64`、`linux-arm64`，只在下载或构建阶段做映射转换，最终产物目录仍然必须落到 `amd64` 或 `arm64`。
- `<product>` 应该使用该 Dockerfile 系列内稳定统一的产品名，比如 `bind`、`containerd`、`kubernetes`、`jq`。

## 为什么这样组织

- 聚合时可以直接按架构复制整棵目录。
- 每个产品都遵守同一套路径约定。
- 构建阶段可以兼容上游不同命名，但不会把这种不一致泄漏到最终产物目录。
- 后续脚本或工具可以直接遍历 `/packs/amd64/*` 和 `/packs/arm64/*`，不需要写特殊分支。

## 编写规则

- 单架构 Dockerfile 只要在构建时能确定架构，也应该输出到 `/packs/<arch>/<product>`。
- 多阶段或多平台构建要先保证每个阶段产物隔离，最后统一复制到 `/packs/amd64/<product>` 或 `/packs/arm64/<product>`。
- 如果构建系统支持 `--prefix`，优先直接指向最终标准路径。
- 如果安装路径不能直接带上最终架构目录，就先安装到临时目录，再在镜像阶段结束前搬运到标准结构。

## 推荐模式

### 基于 prefix 的安装

```Dockerfile
ARG TARGETARCH

RUN case "$TARGETARCH" in \
        amd64) pack_arch="amd64" ;; \
        arm64) pack_arch="arm64" ;; \
        *) echo "unsupported arch: $TARGETARCH" && exit 1 ;; \
    esac && \
    ./configure --prefix="/packs/${pack_arch}/bind" && \
    make -j$(nproc) && \
    make install
```

### 把下载产物移动到标准路径

```Dockerfile
RUN mkdir -p /packs/amd64/containerd /packs/arm64/containerd

RUN wget -O containerd-amd64.tar.gz "..." && \
    tar xf containerd-amd64.tar.gz && \
    mv bin/* /packs/amd64/containerd/

RUN wget -O containerd-arm64.tar.gz "..." && \
    tar xf containerd-arm64.tar.gz && \
    mv bin/* /packs/arm64/containerd/
```

### 聚合时的复制方式

```Dockerfile
COPY --from=binary-bind /packs/amd64/bind /packs/amd64/bind
COPY --from=binary-bind /packs/arm64/bind /packs/arm64/bind
COPY --from=binary-curl /packs/amd64/curl /packs/amd64/curl
COPY --from=binary-curl /packs/arm64/curl /packs/arm64/curl
```

如果聚合镜像本身就是单架构，也可以只复制一个顶层架构目录。

## 重构检查清单

修改已有 Dockerfile 时，按下面顺序检查：

1. 先确认当前 `/packs` 目录结构。
2. 把所有 `x86_64` 或 `aarch64` 输出目录统一映射为 `amd64` 和 `arm64`。
3. 把产品产物移动到 `/packs/<arch>/<product>`。
4. 同步更新 `strip`、`chown`、`COPY`、`WORKDIR` 等相关路径。
5. 检查同一产品族的其他 Dockerfile，保持命名一致。
6. 如果有聚合镜像依赖它，连带更新对应的 `COPY --from` 路径。

## 评审检查清单

- 最终镜像中的 `/packs` 下只出现 `amd64` 和/或 `arm64`。
- 产品产物必须位于架构目录下一层。
- 最终 `/packs` 路径中不要出现把产品名和架构名混在同一层级的写法。
- 上游架构命名不能泄漏到最终输出目录。
- `COPY` 路径和运行时预期都要符合这套标准结构。
