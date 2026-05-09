#!/bin/bash
set -e

# 非 root 用户启动，确保 /run/sshd 目录存在
mkdir -p /run/sshd

# 使用 sudo 以 root 身份启动 sshd
sudo /usr/sbin/sshd -D -f /opt/ssh/sshd_config
