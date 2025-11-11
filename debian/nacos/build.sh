

app_name=nacos-server
version=2.4.3

proxy_arg="--build-arg https_proxy=192.168.88.84:1080"
img1=ccr.ccs.tencentyun.com/hank997/${app_name}:${version}
img2=ccr.ccs.tencentyun.com/hank997/${app_name}:${version}-amd64
img3=ccr.ccs.tencentyun.com/hank997/${app_name}:${version}-arm64

docker build --platform linux/amd64 ${proxy_arg} -t ${img2} .
docker build --platform linux/arm64 ${proxy_arg} -t ${img3} .

docker push ${img2}
docker push ${img3}

docker rmi $img1 2> /dev/null
docker manifest rm $img1
docker manifest create --insecure --amend $img1 $img2 $img3
docker manifest annotate $img1 $img2 --os linux --arch amd64
docker manifest annotate $img1 $img3 --os linux --arch arm64 --variant v8
docker manifest push --insecure $img1