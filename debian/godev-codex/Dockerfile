# https://github.com/docker-library/golang
ARG app_version=1.26.2

FROM golang:${app_version}

# 安装一些依赖包，并且做好 ssh的配置
RUN apt-get update && \
    apt-get install -y git vim wget openssh-server sudo screen && \
    wget -O $(ls -d /usr/share/vim/vim*)/basic.vim https://raw.githubusercontent.com/amix/vimrc/refs/heads/master/vimrcs/basic.vim && \
    sed -i 's#mouse=a#mouse-=a#g' $(ls -d /usr/share/vim/vim*)/defaults.vim || \
    sed -i 's@#PermitRootLogin prohibit-password@PermitRootLogin yes@g' /etc/ssh/sshd_config && \
    addgroup --gid 1008 normaluser && \
    adduser --system --disabled-password --home /home/normaluser -u 1008 --ingroup normaluser normaluser --shell /bin/bash && \
    echo normaluser ALL=\(ALL\) NOPASSWD:ALL >> /etc/sudoers && \
    cp -a /etc/ssh/ /home/normaluser/ssh && \
    chown -R normaluser:normaluser /home/normaluser && \
    mkdir -p /run/sshd && \
    chown -R normaluser:normaluser /run/sshd && \
    chown -R normaluser:normaluser /go
#USER normaluser
# 把代码通通放进去，其实可以在里面用git命令拉取
#COPY . /home/normaluser
WORKDIR /home/normaluser

# 配置 ssh的配置，然后使用它
RUN echo 'Port 2222' > /home/normaluser/ssh/sshd_config && \
    echo 'PermitRootLogin yes' >> /home/normaluser/ssh/sshd_config && \
    echo HostKey /home/normaluser/ssh/ssh_host_rsa_key >> /home/normaluser/ssh/sshd_config && \
    echo HostKey /home/normaluser/ssh/ssh_host_ecdsa_key >> /home/normaluser/ssh/sshd_config && \
    echo HostKey /home/normaluser/ssh/ssh_host_ed25519_key >> /home/normaluser/ssh/sshd_config && \
    echo AuthorizedKeysFile  .ssh/authorized_keys >> /home/normaluser/ssh/sshd_config && \
    echo ChallengeResponseAuthentication no >> /home/normaluser/ssh/sshd_config && \
    echo UsePAM yes >> /home/normaluser/ssh/sshd_config && \
    echo Subsystem       sftp    /usr/lib/openssh/sftp-server >> /home/normaluser/ssh/sshd_config && \
    echo PidFile /home/normaluser/ssh/sshd.pid >> /home/normaluser/ssh/sshd_config

RUN echo 'normaluser:123456' |chpasswd && \
    echo 'root:123456' |chpasswd

# 编写脚本，主要是为了启动的时候获取环境变量，然后ssh 登录的时候不丢失环境变量
RUN echo '#!/bin/bash' > /home/normaluser/get_env.sh && \
    echo 'for i in `env`' >> /home/normaluser/get_env.sh && \
    echo 'do' >> /home/normaluser/get_env.sh && \
    echo '    echo export $i >> /home/normaluser/set_env.sh' >> /home/normaluser/get_env.sh && \
    echo 'done' >> /home/normaluser/get_env.sh

# 加载环境变量
RUN echo "source /home/normaluser/set_env.sh" >> /etc/profile

# 配置高亮
RUN echo "alias ls='ls --color=auto'" >> /etc/profile

RUN /usr/local/go/bin/go install github.com/uudashr/gopkgs/v2/cmd/gopkgs@latest && \
    /usr/local/go/bin/go install github.com/ramya-rao-a/go-outline@latest && \
    /usr/local/go/bin/go install github.com/cweill/gotests/gotests@latest && \
    /usr/local/go/bin/go install github.com/fatih/gomodifytags@latest && \
    /usr/local/go/bin/go install github.com/josharian/impl@latest && \
    /usr/local/go/bin/go install github.com/haya14busa/goplay/cmd/goplay@latest && \
    /usr/local/go/bin/go install github.com/go-delve/delve/cmd/dlv@latest && \
    /usr/local/go/bin/go install honnef.co/go/tools/cmd/staticcheck@latest && \
    /usr/local/go/bin/go install golang.org/x/tools/gopls@latest

RUN node_version=24.15.0 && apt-get update && apt-get install -y xz-utils \
    case "$(arch)" in \
        x86_64) arch_m="x64" ;; \
        aarch64) arch_m="arm64" ;; \
        *) echo >&2 "error: unsupported version: '$app_version'"; exit 1 ;; \
    esac && \
    wget https://nodejs.org/dist/v${node_version}/node-v${node_version}-linux-${arch_m}.tar.xz && \
    tar xf node-v${node_version}-linux-${arch_m}.tar.xz -C /usr/local/ && \
    ln -sf /usr/local/node-v${node_version}-linux-${arch_m} /usr/local/node

ENV PATH=$PATH:/usr/local/node/bin

RUN npm install -g @openai/codex

# 启动命令，主要就是先获取环境变量，然后让sshd 前台运行即可
CMD ["bash", "-c", "bash /home/normaluser/get_env.sh;/usr/sbin/sshd -D -f /home/normaluser/ssh/sshd_config"]