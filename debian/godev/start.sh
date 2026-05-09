#!/bin/bash
set -e

# 使用 sudo 以 root 身份启动 sshd
sudo /usr/sbin/sshd -D
