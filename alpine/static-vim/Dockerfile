FROM alpine AS builder

ARG app_version=9.1.1901

RUN apk add gcc make musl-dev ncurses-static unzip 

WORKDIR /build

RUN wget -O vim.zip https://codeload.github.com/vim/vim/zip/refs/tags/v${app_version} && \
    unzip -q vim.zip && \
    cd vim-${app_version} && \
    LDFLAGS="-static" ./configure --disable-channel --disable-gpm --disable-gtktest \
    --disable-gui --disable-netbeans --disable-nls --disable-selinux --disable-smack --disable-sysmouse \
    --disable-xsmp --enable-multibyte --with-features=huge --without-x --with-tlib=ncursesw && \
    make -j2 && \
    make install && \
    mkdir -p /out/vim && \
    cp -r /usr/local/* /out/vim && \
    major_version=$(echo "$app_version" | cut -d. -f1,2) && \
    case "$major_version" in \
        8.2) vim_dir="vim82" ;; \
        9.0) vim_dir="vim90" ;; \
        9.1) vim_dir="vim91" ;; \
        *) echo >&2 "error: unsupported version: '$app_version'"; exit 1 ;; \
    esac && \
    wget -O /out/vim/share/vim/${vim_dir}/basic.vim https://raw.githubusercontent.com/amix/vimrc/refs/heads/master/vimrcs/basic.vim && \
    echo 'set mouse-=a' >> /out/vim/share/vim/${vim_dir}/defaults.vim && \
    strip /out/vim/bin/vim && \
    chown -R $(id -u):$(id -g) /out/vim && \
    mkdir -p /packs && \
    cp -a /out/vim /packs

WORKDIR /packs

FROM alpine

COPY --from=builder /packs /packs

WORKDIR /packs

