# Alpine Static Components - 待新增组件清单

## 已有组件 (22个)

| 组件 | 说明 |
|------|------|
| static-all | 全量组件 |
| static-bind | DNS 工具（dig / nslookup / host / nsupdate） |
| static-bmon | 带宽监控 |
| static-chrony | 时间同步 |
| static-curl | HTTP 客户端 |
| static-dos2unix | 换行符转换 |
| static-fio | 磁盘 IO 测试 |
| static-gawk | 文本处理 |
| static-htop | 进程监控 |
| static-iotop | IO 监控 |
| static-jq | JSON 处理 |
| static-keepalived | 高可用 |
| static-lrzsz | 传输工具 |
| static-net-tools | 网络工具集 |
| static-netcat | 网络 debug |
| static-nload | 实时网络流量监控 |
| static-nmap | 端口扫描 |
| static-rsync | 文件同步 |
| static-tar | 打包解压 |
| static-tcpdump | 抓包工具 |
| static-vim-go | Vim + Go 插件 |
| static-vim | 编辑器 |
| static-wget | 下载工具 |

---

## 高优先级（常用且缺失）

- [ ] **static-strace** — 进程/系统调用追踪，排查问题的必备工具
- [ ] **static-iperf3** — 网络带宽测试，运维高频使用
- [ ] **static-mtr** — 网络链路诊断
- [ ] **static-traceroute** — 路由追踪
- [ ] **static-git** — 版本控制（轻量版）
- [ ] **static-zip** / **static-unzip** — 压缩解压

## 中优先级（场景化）

- [ ] **static-openssl** — SSL/TLS/加密工具链
- [x] **static-dig** — DNS 排查（已合并至 static-bind）
- [x] **static-nslookup** — DNS 查询（已合并至 static-bind）
- [ ] **static-screen** — 终端复用
- [ ] **static-tmux** — 终端复用
- [ ] **static-less** — 文件查看器
- [ ] **static-more** — 文件查看器
- [ ] **static-diffutils** — diff/cmp 等文件对比工具
- [ ] **static-tree** — 目录结构展示
- [ ] **static-sysstat** — iostat/vmstat/mpstat 性能采集
- [ ] **static-lsof** — 查看打开的文件
- [ ] **static-psmisc** — killall/pstree 等
- [ ] **static-sudo** — 权限提升
- [ ] **static-ca-certificates** — 根证书

## 低优先级（特定场景）

- [ ] **static-gdb** — 调试器
- [ ] **static-nano** — 轻量编辑器
- [ ] **static-crontab** — 定时任务
- [ ] **static-logrotate** — 日志轮转
- [ ] **static-vi** — 极简 vi
- [ ] **static-busybox** — 静态编译瑞士军刀

## 组合套件方向

- [ ] **static-networkkit** — iperf3 + mtr + dig + nmap + tcpdump（网络诊断套件）
- [ ] **static-debugkit** — strace + lsof + psmisc + htop + iotop（排障套件）
- [ ] **static-devkit** — git + vim + jq + curl + wget（最小开发环境）
