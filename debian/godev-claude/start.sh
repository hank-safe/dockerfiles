#!/bin/bash
set -e

# 动态设置 /run/sshd 权限
if [ "$(id -u)" = "0" ]; then
    # root 用户启动，确保 /run/sshd 属于 root
    chown root:root /run/sshd
else
    # 非 root 用户启动
    mkdir -p /run/sshd
fi

/usr/sbin/sshd -D -f /opt/ssh/sshd_config 