FROM alpine

ARG app_version=9.1.1901

RUN apk add gcc make musl-dev ncurses-static unzip 

RUN wget -O vim.zip https://github.com/vim/vim/archive/refs/tags/v${VIM_VERSION}.zip && \
    unzip vim.zip && \
    cd vim-${VIM_VERSION} && \
    LDFLAGS="-static" ./configure --disable-channel --disable-gpm --disable-gtktest \
    --disable-gui --disable-netbeans --disable-nls --disable-selinux --disable-smack --disable-sysmouse \
    --disable-xsmp --enable-multibyte --with-features=huge --without-x --with-tlib=ncursesw && \
    make -j && \
    make install && \
    mkdir -p /out/vim && \
    cp -r /usr/local/* /out/vim && \
    wget -O /out/vim/share/vim/vim91/master.zip https://github.com/amix/vimrc/archive/refs/heads/master.zip && \
    echo 'set mouse-=a' >> /out/vim/share/vim/vim91/defaults.vim && \
    strip /out/vim/bin/vim && \
    chown -R $(id -u):$(id -g) /out/vim && \
    mkdir -p /packs && \
    cp -a /out/vim /packs
