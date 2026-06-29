# dockerfiles

在本地构建的方式

```bash
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes

docker buildx rm multiarch
docker buildx create --name multiarch --driver docker-container --use image=moby/buildkit:buildx-stable-1

app_version=2.2.8
platforms="linux/amd64,linux/arm64"
image_tag=2.2.8
image_name=static-keepalived

docker buildx build --build-arg app_version=${app_version} --platform ${platforms} --tag crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/${image_name}:${image_tag} --push .

#docker buildx build --build-arg app_version=0.12.20 --platform linux/amd64,linux/arm64 --tag crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-lrzsz:0.12.20 --push .
```

## 镜像列表

|name|镜像名称|路径|架构|
|---|---|---|---|
|所有静态编译|crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-all:1.0.0|[alpine/static-all](alpine/static-all)|linux/amd64,linux/arm64|

### alpine

> keepalived、lrzsz 在本地构建成功，在action构建失败

> nmap action构建失败，在有些机器构建也失败，可能跟CPU架构有关。 在 `Intel(R) Xeon(R) CPU E5-2620 v3 @ 2.40GHz ` 构建成功。 在 `Intel(R) Core(TM) i5-10400 CPU @ 2.90GHz` 构建失败。

|name|镜像名称|路径|架构|
|---|---|---|---|
|bind|crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-bind:9.16.50|[alpine/static-bind](alpine/static-bind)|linux/amd64,linux/arm64|
|bmon|crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-bmon:4.0|[alpine/static-bmon](alpine/static-bmon)|linux/amd64,linux/arm64|
|chrony|crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-chrony:4.8|[alpine/static-chrony](alpine/static-chrony)|linux/amd64,linux/arm64|
|curl|crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-curl:8.21.0|[alpine/static-curl](alpine/static-curl)|linux/amd64,linux/arm64|
|dos2unix|crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-dos2unix:7.5.6|[alpine/static-dos2unix](alpine/static-dos2unix)|linux/amd64,linux/arm64|
|fio|crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-fio:3.36|[alpine/static-fio](alpine/static-fio)|linux/amd64,linux/arm64|
|gawk|crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-gawk:5.4.0|[alpine/static-gawk](alpine/static-gawk)|linux/amd64,linux/arm64|
|htop|crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-htop:3.5.1|[alpine/static-htop](alpine/static-htop)|linux/amd64,linux/arm64|
|iotop|crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-iotop:1.31|[alpine/static-iotop](alpine/static-iotop)|linux/amd64,linux/arm64|
|jq|crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-jq:1.8.2|[alpine/static-jq](alpine/static-jq)|linux/amd64,linux/arm64|
|keepalived|crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-keepalived:2.2.8|[alpine/static-keepalived](alpine/static-keepalived)|linux/amd64,linux/arm64|
|lrzsz|crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-lrzsz:0.12.20|[alpine/static-lrzsz](alpine/static-lrzsz)|linux/amd64,linux/arm64|
|net-tools|crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-net-tools:2.10|[alpine/static-net-tools](alpine/static-net-tools)|linux/amd64,linux/arm64|
|netcat|crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-netcat:0.7.1|[alpine/static-netcat](alpine/static-netcat)|linux/amd64,linux/arm64|
|nmap|crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-nmap:7.99|[alpine/static-nmap](alpine/static-nmap)|linux/amd64,linux/arm64|
|rsync|crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-rsync:3.4.4|[alpine/static-rsync](alpine/static-rsync)|linux/amd64,linux/arm64|
|smartmontools|crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-smartmontools:7.5|[alpine/static-smartmontools](alpine/static-smartmontools)|linux/amd64,linux/arm64|
|tar|crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-tar:1.35|[alpine/static-tar](alpine/static-tar)|linux/amd64,linux/arm64|
|tcpdump|crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-tcpdump:4.99.6|[alpine/static-tcpdump](alpine/static-tcpdump)|linux/amd64,linux/arm64|
|vim|crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-vim:9.1.1901|[alpine/static-vim](alpine/static-vim)|linux/amd64,linux/arm64|
|wget|crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/static-wget:1.25.0|[alpine/static-wget](alpine/static-wget)|linux/amd64,linux/arm64|


### rockylinux
|name|镜像名称|路径|架构|
|---|---|---|---|
|cfssl|crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/binary-cfssl:1.6.5|[rockylinux/binary-cfssl](rockylinux/binary-cfssl)|linux/amd64|
|cni|crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/binary-cni:1.6.2|[rockylinux/binary-cni](rockylinux/binary-cni)|linux/amd64|
|compose|crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/binary-compose:2.31.0|[rockylinux/binary-compose](rockylinux/binary-compose)|linux/amd64|
|containerd|crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/binary-containerd:1.7.28|[rockylinux/binary-containerd](rockylinux/binary-containerd)|linux/amd64|
|crictl|crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/binary-crictl:1.34.0|[rockylinux/binary-crictl](rockylinux/binary-crictl)|linux/amd64|
|docker|crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/binary-docker:28.5.2|[rockylinux/binary-docker](rockylinux/binary-docker)|linux/amd64|
|etcd|crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/binary-etcd:3.5.17|[rockylinux/binary-etcd](rockylinux/binary-etcd)|linux/amd64|
|harbor|crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/binary-harbor:2.12.2|[rockylinux/binary-harbor](rockylinux/binary-harbor)|linux/amd64|
|helm|crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/binary-helm:3.16.3|[rockylinux/binary-helm](rockylinux/binary-helm)|linux/amd64|
|k3s|crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/binary-k3s:1.32.2-k3s1|[rockylinux/binary-k3s](rockylinux/binary-k3s)|linux/amd64|
|kubernetes|crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/binary-kubernetes:1.26.15|[rockylinux/binary-kubernetes](rockylinux/binary-kubernetes)|linux/amd64|
|miniconda|crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/binary-miniconda:py39_24.11.1-0|[rockylinux/binary-miniconda](rockylinux/binary-miniconda)|linux/amd64|
|sshpass|crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/binary-sshpass:1.09|[rockylinux/binary-sshpass](rockylinux/binary-sshpass)|linux/amd64|

### debian
|name|镜像名称|路径|架构|
|---|---|---|---|
|openjdk8|crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/openjdk:8u462-b08|[debian/openjdk/8](debian/openjdk/8)|linux/amd64,linux/arm64|
|nacos|crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/nacos:2.4.3|[debian/nacos](debian/nacos)|linux/amd64,linux/arm64|
|tomcat|crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/tomcat:9.0.112|[debian/tomcat](debian/tomcat)|linux/amd64,linux/arm64|
|go开发环境|crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/godev:1.26.3|[debian/godev](debian/godev)|linux/amd64,linux/arm64|

### ubuntu

|name|镜像名称|路径|架构|
|---|---|---|---|
|nginx-webdav|crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/nginx-webdav:1.27.4|[ubuntu/nginx-webdav](ubuntu/nginx-webdav)|linux/amd64,linux/arm64|
|ubuntu depends|crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/ubuntu:deps|[ubuntu/depends](ubuntu/depends)|linux/amd64|
|python|crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/relocatable-python:3.13.13|[ubuntu/relocatable-python](ubuntu/relocatable-python)|linux/amd64,linux/arm64|
