#!/bin/bash
WORKROOT=$(cd $(dirname $0);pwd)

# 每一行的第一个是bin包的名称，第二个到最后是需要打包的内容
PACKAGE_WITH_NAME="
base lrzsz bash-completion ipvsadm conntrack iptables nfs-common zip ipset curl
"

# 需要自行替换源，这里使用的是ubuntu18.04的源
function change_source(){
# 替换源，其中注意关键字
# 18.04： bionic
# 20.04： focal
# 22.04： jammy
if [[ -f /etc/apt/sources.list.d/ubuntu.sources ]]
then
  sed -i 's@//.*archive.ubuntu.com@//mirrors.ustc.edu.cn@g' /etc/apt/sources.list.d/ubuntu.sources
else
  sed -i 's@//.*archive.ubuntu.com@//mirrors.ustc.edu.cn@g' /etc/apt/sources.list
fi


apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32
# 如果添加例如docker-ce的源，则需要先下载例如curl等相关的命令，而下载该命令导致系统不纯净。
# 请自行调试吧。
# 推荐：可以先下载包，mv到指定地方，然后重新在安装一遍。
}

function install_package() {
  # 下载离线包到指定的路径
  package="${@:2}"
  name=$1

  apt-get update
  rm -rf /var/cache/apt/archives/*.deb
  # 下载包不指定路径了
  # 不管RHEL还是debian系列，都要用mv的方式操作
  apt-get install -d -y $package

  if [[ $? != 0 ]]
  then
    echo "error: $name 下载失败"
    exit 1
  fi


  mkdir -p /tmp/$name
  # 不管RHEL还是debian系列，都要用mv的方式操作
  mv /var/cache/apt/archives/*.deb /tmp/$name/
  chmod 777 -R /tmp/$name/

}

function make_bin(){
  package="${@:2}"
  name=$1
  rm -rf /var/debs/
  mv /tmp/$name/ /var/debs/
  cd /var
  apt-ftparchive packages debs > debs/Packages
  if [[ $? != 0 ]]
  then
    echo "error: $name 打包失败"
    exit 1
  fi
  cd debs
  gzip -c Packages > Packages.gz
  cd /var
  dpkg-scanpackages debs/ /dev/null |gzip > /var/debs/Packages.gz
  tar -zcf packages.tgz debs/

# 制作安装脚本，
cat > install.sh << EOF
#!/bin/bash
[ -d /var/debs ] && sudo mv /var/debs /var/debs.bak
sed -n -e '1,/^exit \$code$/!p' \$0 > packages.tgz 2>/dev/null
sudo tar -zxf packages.tgz -C /var
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
sudo chmod 777 /etc/apt/sources.list
sudo echo "deb [trusted=yes] file:/var debs/" > /etc/apt/sources.list
sudo apt update --allow-insecure-repositories
sudo DEBIAN_FRONTEND=noninteractive apt install -y $package --allow-unauthenticated
code=\$?
if [[ \$code != 0 ]]
then
  dpkg -i /var/debs/*.deb
  if [[ \$? != 0 ]]
  then
    code=100
  else
    code=0
  fi
fi
[ -f /etc/apt/sources.list.bak ] && sudo mv /etc/apt/sources.list.bak /etc/apt/sources.list
[ -d /var/debs.bak ] && sudo rm -rf /var/debs && sudo mv /var/debs.bak /var/debs
exit \$code
EOF

cat install.sh /var/packages.tgz > $name.bin
mv /var/$name.bin $WORKROOT
}

function do_it(){
    # 替换源
    #change_source
    # 需要制作的bin包内容
    IFS=$'\n'
    for line in $PACKAGE_WITH_NAME
    do
        unset IFS
        word=$(echo $line | awk '{print $2}')
        if [[ -z $word ]]
        then
            echo "请确保 'PACKAGE_WITH_NAME' 的拼写正确"
            exit 1
        fi
    done
    # 分开执行，下载包和制作包分开
    # 先把所有的包都下载了，然后再执行所有的打包操作
    IFS=$'\n'
    for line in $PACKAGE_WITH_NAME
    do
        unset IFS
        install_package $line
    done

    apt-get update
    apt-get install dpkg-dev apt-utils -y

    # 制作最终的bin包
    IFS=$'\n'
    for line in $PACKAGE_WITH_NAME
    do
        unset IFS
        make_bin $line
    done
}
do_it