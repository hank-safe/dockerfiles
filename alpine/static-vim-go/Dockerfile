FROM alpine AS builder

ARG app_version=9.1.1901
ARG golang_version=1.25.4

RUN apk add gcc make musl-dev ncurses-static unzip git curl

WORKDIR /build

# 安装Go
RUN case "$(arch)" in \
        x86_64) arch_m="amd64" ;; \
        aarch64) arch_m="arm64" ;; \
        *) echo >&2 "error: unsupported version: '$app_version'"; exit 1 ;; \
    esac && \
    wget -O go.tar.gz https://golang.org/dl/go${golang_version}.linux-${arch_m}.tar.gz && \
    tar -C /usr/local -xzf go.tar.gz && \
    rm go.tar.gz

ENV PATH="/usr/local/go/bin:$PATH"
ENV GOPATH="/go"

# 编译静态Vim
RUN wget -O vim.zip https://codeload.github.com/vim/vim/zip/refs/tags/v${app_version} && \
    unzip -q vim.zip && \
    cd vim-${app_version} && \
    LDFLAGS="-static" ./configure --disable-channel --disable-gpm --disable-gtktest \
    --disable-gui --disable-netbeans --disable-nls --disable-selinux --disable-smack --disable-sysmouse \
    --disable-xsmp --enable-multibyte --with-features=huge --without-x --with-tlib=ncursesw && \
    make -j$(nproc) && \
    make install

# 创建输出目录
RUN mkdir -p /out/vim /out/go

# 复制Vim二进制文件和运行时
RUN cp /usr/local/bin/vim /out/vim/ && \
    cp -r /usr/local/share/vim /out/vim/share/ && \
    strip /out/vim/vim

# 安装Go工具和Vim Go插件依赖
RUN mkdir -p /out/vim/pack/plugins/start && \
    cd /out/vim/pack/plugins/start && \
    git clone --depth 1 https://github.com/fatih/vim-go.git && \
    git clone --depth 1 https://github.com/scrooloose/nerdtree.git && \
    git clone --depth 1 https://github.com/airblade/vim-gitgutter.git && \
    git clone --depth 1 https://github.com/tpope/vim-fugitive.git

# 安装Go开发工具链
RUN /usr/local/go/bin/go install github.com/uudashr/gopkgs/v2/cmd/gopkgs@latest && \
    /usr/local/go/bin/go install github.com/ramya-rao-a/go-outline@latest && \
    /usr/local/go/bin/go install github.com/cweill/gotests/gotests@latest && \
    /usr/local/go/bin/go install github.com/fatih/gomodifytags@latest && \
    /usr/local/go/bin/go install github.com/josharian/impl@latest && \
    /usr/local/go/bin/go install github.com/haya14busa/goplay/cmd/goplay@latest && \
    /usr/local/go/bin/go install github.com/go-delve/delve/cmd/dlv@latest && \
    /usr/local/go/bin/go install honnef.co/go/tools/cmd/staticcheck@latest && \
    /usr/local/go/bin/go install golang.org/x/tools/gopls@latest

# 复制Go工具到输出目录
RUN cp -r /go/bin /out/go/ && \
    cp -r /usr/local/go /out/go/

# 创建Vim配置目录
RUN mkdir -p /out/vim/config

# 创建启动脚本
COPY start-vim-go.sh  /out/vim/start-vim-go.sh 

RUN chmod +x /out/vim/start-vim-go.sh

WORKDIR /out

FROM alpine

# 安装运行时依赖
RUN apk add --no-cache git curl ncurses

# 复制构建结果
COPY --from=builder /out/vim /vim
COPY --from=builder /out/go /usr/local/

# 复制vimrc配置文件
COPY vimrc /vim/config/vimrc

# 设置环境变量
ENV PATH="/usr/local/go/bin:/usr/local/bin:$PATH"
ENV GOPATH="/go"
ENV VIMRUNTIME="/vim/share/vim91"
ENV VIMINIT="source /vim/config/vimrc"

# 创建符号链接和工作目录
RUN ln -sf /vim/vim /usr/local/bin/vim && \
    ln -sf /vim/start-vim-go.sh /usr/local/bin/vim-go && \
    mkdir -p /workspace /go

WORKDIR /workspace

ENTRYPOINT ["vim-go"]